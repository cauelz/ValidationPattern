public class FilterStream {

    List<SObject> filteredRecord;
    List<SObject> newRecords;
    Map<Id, SObject> oldRecords;
    String changedField;
    String changedValue;

    public FilterStream(List<SObject> newRecords) {
        this.newRecords = newRecords;
    }
    public FilterStream(List<SObject> newRecords, Map<Id, SObject> oldRecords) {
        this(newRecords);
        this.oldRecords = oldRecords;
    }
    public FilterStream() {
        
    }
    public FilterStream() {
        
    }

        /**
     * Filter newRecords by Changed field with specific Value
     * @param  newRecords  Trigger.new
     * @param  oldRecords  Trigger.oldMap
     * @param  changedField
     * @param  changedValue
     * @return filtered records
     */
    public List<SObject> relevantChangeRecordsFilter (List<SObject> newRecords, Map<Id, SObject> oldRecords, String changedField, String changedValue) { //NOPMD

        List<SObject> changedRecords = relevantChangeRecordsFilter (newRecords, oldRecords, new String[] {changedField} );

        List<SObject> changedRecordsWithValue = new List<SObject>();

        for (SObject record : changedRecords ) {

            String recordValue = '' + record.get(changedField);
            String receivedValue = '' + changedValue;

            if ( recordValue == receivedValue ) {
                changedRecordsWithValue.add(record);
            }


        }

        return changedRecordsWithValue;

    }

    public List<SObject> relevantChangeRecordsFilter (List<SObject> newRecords
            , Map<Id, SObject> oldRecords
            , Schema.FieldSet fieldset ) {

        List<SObject> relevantChanges = new List<SObject>();

        if ( newRecords == null || newRecords.isEmpty() ) return relevantChanges;

        if ( oldRecords == null || oldRecords.isEmpty() ) return newRecords;

        if (fieldset == null || fieldset.fields.isEmpty()) return newRecords;

        List<String> changedFields = new List<String>();

        for(Schema.FieldSetMember fieldSetMemberObj : fieldSet.fields){
            changedFields.add(fieldSetMemberObj.getFieldPath());
        }

        return this.relevantChangeRecordsFilter(newRecords, oldRecords, changedFields);

    }
    
    /**
     * Provide helper method to filter change by relevant fields
     * @author ercarval
     * @param  newRecords    Trigger.new
     * @param  oldRecords    Trigger.oldMap
     * @param  changedFields changeableField separated by comma
     * @return New List of Only Relevant changes
     */
    public List<SObject> relevantChangeRecordsFilter (List<SObject> newRecords
            , Map<Id, SObject> oldRecords
            , List<String> changedFields ) {

        List<SObject> relevantChanges = new List<SObject>();

        if ( newRecords == null || newRecords.isEmpty() ) return relevantChanges;

        if ( oldRecords == null || oldRecords.isEmpty() ) return newRecords;

        for ( SObject record : newRecords  ) {

            SObject oldRecord = oldRecords.get( (Id) record.get('Id') ) ;

            if ( hasRelevantChanges (record, oldRecord, changedFields) ) {
                relevantChanges.add (record);
            }

        }

        return relevantChanges;

    }


    private boolean hasRelevantChanges (SObject changed , SObject old , List<String> changedFields ) {

        //is new
        if (old == null) return true;

        for (String field : changedFields) {

            if ( changed.get(field)  !=  old.get(field) ) return true;

        }

        return false;

    }


    public List<SObject> filterByValue( List<SObject> newRecords, String field, String value ){

        List<SObject> filtered = new List<SObject>();

        if( newRecords.isEmpty() || newRecords == null ) return filtered;

        for( SObject newRecord : newRecords ){

            String fieldValue = String.valueOf( newRecord.get(field) );
            if( fieldValue != value ) continue;
            filtered.add(newRecord);
        }
        return filtered;
    }

    public List<SObject> filterByDifferentValue( List<SObject> newRecords, String field, String value ){

        List<SObject> filtered = new List<SObject>();

        if( newRecords.isEmpty() || newRecords == null ) return filtered;

        for( SObject newRecord : newRecords ){

            String fieldValue = String.valueOf( newRecord.get(field) );
            if( fieldValue == value ) continue;
            filtered.add(newRecord);
        }
        return filtered;
    }

    public List<SObject> filterByListValue( List<SObject> newRecords, String field, List<String> values ){

        List<SObject> filtered = new List<SObject>();

        if( newRecords.isEmpty() || newRecords == null ) return filtered;
        if( values.isEmpty() || values == null ) return filtered;

        for( SObject newRecord : newRecords ){

            String fieldValue = String.valueOf( newRecord.get(field) );
            if( !values.contains(fieldValue )) continue;
            filtered.add(newRecord);
        }
        return filtered;
    }

    public List<SObject> filterByDifferentListValue( List<SObject> newRecords, String field, List<String> values ){

        List<SObject> filtered = new List<SObject>();

        if( newRecords.isEmpty() || newRecords == null ) return filtered;
        if( values.isEmpty() || values == null ) return filtered;

        for( SObject newRecord : newRecords ){

            String fieldValue = String.valueOf( newRecord.get(field) );
            if( values.contains(fieldValue )) continue;
            filtered.add(newRecord);
        }
        return filtered;
    }

    public List<SObject> filterByEmptyValue( List<SObject> newRecords, String field ){

        List<SObject> filtered = new List<SObject>();

        if( newRecords.isEmpty() || newRecords == null ) return filtered;

        for( SObject newRecord : newRecords ){

            String fieldValue = String.valueOf( newRecord.get(field) );
            if( String.isNotEmpty(fieldValue) ) continue;
            filtered.add(newRecord);
        }
        return filtered;
    }

    public List<SObject> filterByNotEmptyValue( List<SObject> newRecords, String field ){

        List<SObject> filtered = new List<SObject>();

        if( newRecords.isEmpty() || newRecords == null ) return filtered;

        for( SObject newRecord : newRecords ){

            String fieldValue = String.valueOf( newRecord.get(field) );
            if( String.isEmpty(fieldValue) ) continue;
            filtered.add(newRecord);
        }
        return filtered;
    }
}