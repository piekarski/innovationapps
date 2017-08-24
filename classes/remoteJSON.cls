public class remoteJSON {



    @RemoteAction
    public static List<SObject> query(String queryJSON) {
        Map<String, Object> qconfig = (Map<String, Object>) JSON.deserializeUntyped(queryJSON);
        Query query = new Query(qconfig);
        query.validate(); // HERE we check FLS and other access control
        return Database.query(query.toSOQL());
    }
}