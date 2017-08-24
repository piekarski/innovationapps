//This class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.
global class VAUserSSOHandler implements Auth.SamlJitHandler {
    private class JitException extends Exception{}
    
    private void handleUser(boolean create, User u, Map<String, String> attributes,
        String federationIdentifier, boolean isStandard) {
        
        if(create && attributes.containsKey('User.Username')) {
            u.Username = attributes.get('User.Username');     
        }
        //throw new JitException('NEWUSERzzzzzzzUsername is'+ u.Username);
        if(create) {
            //Revisit if we need this (bz)
            if(attributes.containsKey('User.FederationIdentifier')) {
                u.FederationIdentifier = attributes.get('User.FederationIdentifier');
            } else {
                u.FederationIdentifier = federationIdentifier;
            }
            if (attributes.containsKey('User.Email')) {
                u.Email = attributes.get('User.Email');
            }
        
        }
        //throw new JitException('yyyyyyyyyyyyyyyyy'+ u.FederationIdentifier);
        if(attributes.containsKey('User.Phone')) {
            u.Phone = attributes.get('User.Phone');
        }
        //Perhaps need this as future enhancement to update User/Contact email as long as Federation ID remains the same (bz)               
        if(attributes.containsKey('User.Email')) {
            u.Email = attributes.get('User.Email');
        }
        if(attributes.containsKey('User.FirstName')) {
            u.FirstName = attributes.get('User.FirstName');
        }
        if(attributes.containsKey('User.LastName')) {
            u.LastName = attributes.get('User.LastName');
        }
        if(attributes.containsKey('User.Title')) {
            u.Title = attributes.get('User.Title');
        }

        if(attributes.containsKey('User.Street')) {
            u.Street = attributes.get('User.Street');
        }
        /* Removed unti GAL has consistent State field
        if(attributes.containsKey('User.State')) {
            u.State = attributes.get('User.State');
        }
        */
        if(attributes.containsKey('User.City')) {
            u.City = attributes.get('User.City');
        }
        if(attributes.containsKey('User.Zip')) {
            u.PostalCode = attributes.get('User.Zip');
        }


        String uid = UserInfo.getUserId();
        System.debug ('are we supposed to create the user ==> '+create);
        User currentUser = 
            [SELECT LocaleSidKey, LanguageLocaleKey, TimeZoneSidKey, EmailEncodingKey FROM User WHERE Id=:uid];
            
        if(attributes.containsKey('User.LocaleSidKey')) {
            u.LocaleSidKey = attributes.get('User.LocaleSidKey');
        } else if(create) {
            u.LocaleSidKey = currentUser.LocaleSidKey;
        }
        if(attributes.containsKey('User.LanguageLocaleKey')) {
            u.LanguageLocaleKey = attributes.get('User.LanguageLocaleKey');
        } else if(create) {
            u.LanguageLocaleKey = currentUser.LanguageLocaleKey;
        }
        if(attributes.containsKey('User.Alias')) {
            u.Alias = attributes.get('User.Alias');
        } else if(create) {
            String alias = '';
            if(u.FirstName == null) {
                alias = u.LastName;
            } else {
                alias = u.FirstName.charAt(0) + u.LastName;
            }
            if(alias.length() > 5) {
                alias = alias.substring(0, 5);
            }
            u.Alias = alias;
        }
        
        if(attributes.containsKey('User.TimeZoneSidKey')) {
            u.TimeZoneSidKey = attributes.get('User.TimeZoneSidKey');
        } else if(create) {
            u.TimeZoneSidKey = currentUser.TimeZoneSidKey;
        }
        if(attributes.containsKey('User.EmailEncodingKey')) {
            u.EmailEncodingKey = attributes.get('User.EmailEncodingKey');
        } else if(create) {
            u.EmailEncodingKey = currentUser.EmailEncodingKey;
        }

        /*
         * If you are updating Contact or Account object fields, you cannot update the following User fields at the same time.
         * If your identity provider sends these User fields as attributes along with Contact 
         * or Account fields, you must modify the logic in this class to update either these 
         * User fields or the Contact and Account fields.
         */
        if(attributes.containsKey('User.IsActive')) {
            String IsActiveVal = attributes.get('User.IsActive');
            u.IsActive = '1'.equals(IsActiveVal) || Boolean.valueOf(IsActiveVal);
        }
       
        if(attributes.containsKey('User.ForecastEnabled')) {
            String ForecastEnabledVal = attributes.get('User.ForecastEnabled');
            u.ForecastEnabled = '1'.equals(ForecastEnabledVal) || Boolean.valueOf(ForecastEnabledVal);
        }
        
        if(attributes.containsKey('User.ProfileId')) {
            String profileId = attributes.get('User.ProfileId');
            Profile p = [SELECT Id FROM Profile WHERE Id=:profileId];
            u.ProfileId = p.Id;
        }

        //If we are creating this user and the profile was not sent in, then we have to default the profile (bz)
        else if (create) {
            String profileName = 'VA Std Community Plus';
            Profile p = [SELECT Id FROM Profile WHERE Name=:profileName];
            u.ProfileId = p.Id;
        }
        //throw new JitException('HANDLEUSER6zzzzzzzzzzzzzzzzzz');
        if(attributes.containsKey('User.UserRoleId')) {
            String userRole = attributes.get('User.UserRoleId');
            UserRole r = [SELECT Id FROM UserRole WHERE Id=:userRole];
            u.UserRoleId = r.Id;
        }
        //Handle custom fields here
        
        if(!create) {
            update(u);
        }
        //throw new JitException('HDONEHEREDONEHERE');
    }

    private void handleContact(boolean create, String accountId, User u, Map<String, String> attributes) {
        Contact c;
        boolean newContact = false;
        if(create) {       
                //Look to see if User already has a contact based on the email, no employee ID in the VA so need to use email for now (bz)
                if(attributes.containsKey('User.Email')) {                
                    String userEmail = attributes.get('User.Email');
                    //throw new JitException('WANT TO USE User Email to Find Contact'+userEmail);
                    // Check to see if Contact record exists for this user based on their email, if not then create the contact (bz)
                    try {                 
                        c = [SELECT Id, AccountId FROM Contact WHERE Email=:userEmail];
                    }
                    catch (Exception e) {
                        System.debug('Need to make new contact');
                        c = new Contact();
                        newContact = true;
                    }
                    u.ContactId = c.Id;
                    
                    //throw new JitException('WANT TO USE User Email to Find Contact'+ u.ContactId);
                }
                else {
                    throw new JitException('User.Email is required in order to create a new user');
                }
        } else {
            //Get Contact Id from the user record and find the contact object            
                String contact = u.ContactId;
                c = [SELECT Id, AccountId FROM Contact WHERE Id=:contact];
        }
        if(!newContact && c.AccountId != accountId) {
            throw new JitException('Mismatched account: ' + c.AccountId + ', ' + accountId);
        }
        //only use Contact Email on new user because the Contact email is the key to find User and contact so we do not want it to update
        System.debug('last name is' + attributes.get('Contact.LastName'));
        if (newContact) {
            if(attributes.containsKey('Contact.Email')) {
                c.Email = attributes.get('Contact.Email');
            }
        }
        if(attributes.containsKey('Contact.FirstName')) {
            c.FirstName = attributes.get('Contact.FirstName');
        }
        if(attributes.containsKey('Contact.LastName')) {
            c.LastName = attributes.get('Contact.LastName');
        }
        
        if(attributes.containsKey('Contact.Phone')) {
            c.Phone = attributes.get('Contact.Phone');
        }
        if(attributes.containsKey('Contact.MailingStreet')) {
            c.MailingStreet = attributes.get('Contact.MailingStreet');
        }
        if(attributes.containsKey('Contact.MailingCity')) {
            c.MailingCity = attributes.get('Contact.MailingCity');
        }
        /*
        if(attributes.containsKey('Contact.MailingState')) {
            c.MailingState = attributes.get('Contact.MailingState');
        }
        
        if(attributes.containsKey('Contact.MailingCountry')) {
            c.MailingCountry = attributes.get('Contact.MailingCountry');
        }
        */
        if(attributes.containsKey('Contact.MailingPostalCode')) {
            c.MailingPostalCode = attributes.get('Contact.MailingPostalCode');
        }

        if(attributes.containsKey('Contact.Title')) {
            c.Title = attributes.get('Contact.Title');
        }

        //------------------
        //CUSTOMIZED FOR VA
        if(attributes.containsKey('Contact.Office__c')) {
            c.Office__c = attributes.get('Contact.Office__c');
        }
        
        //------------------
        if(newContact) {
            c.AccountId = accountId;
            insert(c);
            u.ContactId = c.Id;
        } else {
            update(c);
        }
        
        //throw new JitException('HEREHERE22222222'+ u.ContactId);
    }
    //Handles account for Community users only (internal users are not brought into this method)
    private String handleAccount(boolean create, User u, Map<String, String> attributes) {
        Account a;
        boolean newAccount = false;
        //u.AccountId contains the users account ID if this is an existing *community* user
        //throw new JitException('DEBUG HANDLE_ACCOUNT '+u.AccountId);
        if(create) {
                    
                    // Do not create new account for new community users, instead we will assign
                    // them to the holding account (bz) 
                    String account = '001r00000057CKlAAM';
                    System.debug('NEW ACCOUNT ASSUMED');
                    //throw new JitException('newUserASSUMED' + account);
                    //a = [SELECT Id FROM Account WHERE Id=:account];
                    a = [SELECT Id FROM Account WHERE Name='New User Holding Account'];
                    if (a==null) {
                        System.debug('ACCOUNT IS NULL');
                    }
                    //System.debug('HELP name is ' + a.Id);
                    //a = new Account();
                    //newAccount = true;
        } else {

                    //Get the Account ID of this existing user from their User record if it is available (bz)
                    String account = u.AccountId;
                    //String account = '00135000002NImeAAG';
                    //throw new JitException('LookingForThisAccount' + account);
                    a = [SELECT Id FROM Account WHERE Id=:account];
        }
 
        System.debug('REturning account ID ');
        return a.Id;
    }

    private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
        if(communityId != null || portalId != null) {
        System.debug('handleJiT: before user creation');
            //gets the account the user is assigned to, if a new user it will return the holding account (bz)
            String account = handleAccount(create, u, attributes);
            
            handleContact(create, account, u, attributes);
            
            handleUser(create, u, attributes, federationIdentifier, false);
           
            
        } else {
            //Throw an error if this user is a create user and not a communities user because we are not creating standard users JiT
            if (create) {
                throw new JitException('You do not have a valid login');
            }
            else {
                handleUser(create, u, attributes, federationIdentifier, true);
            }
        }
    }

    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
        
        User u = new User();
        u.LastName = 'TestLastName';
        
        handleJit(true, u, samlSsoProviderId, communityId, portalId,
            federationIdentifier, attributes, assertion);
        System.debug('createUser: User First name is' + u.FirstName);    
        return u;
        throw new JitException('createUser '+samlSsoProviderId);
    }

    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId,
        String federationIdentifier, Map<String, String> attributes, String assertion) {
        //Added AccountId to pull from user record (bz)
        User u = [SELECT Id, FirstName, ContactId, AccountId FROM User WHERE Id=:userId];
        System.debug('in Update User with user id' + u.id);
        handleJit(false, u, samlSsoProviderId, communityId, portalId,
            federationIdentifier, attributes, assertion);
        //throw new JitException('updateUser '+samlSsoProviderId);
    }
}