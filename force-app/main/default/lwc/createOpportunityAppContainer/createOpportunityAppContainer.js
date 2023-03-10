import { LightningElement, api } from 'lwc';
import {createStore, combineReducers, createLogger} from 'c/lwcRedux';
import reducers from 'c/createOpportunityAppReducer';


const ENABLE_LOGGING = true;
export default class CreateOpportunityAppContainer extends LightningElement {
    
    @api store;
    initialize(){
        let logger;
        
        if(ENABLE_LOGGING){
            logger = createLogger({
                duration: true,
                diff: true
            });
        }
        const combineReducersInstance = combineReducers(reducers);
        this.store = createStore(combineReducersInstance, logger);
    }
}