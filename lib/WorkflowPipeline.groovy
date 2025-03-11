//
// This file holds functions to validate user-supplied arguments
//

class WorkflowPipeline {

    //
    // Check and validate parameters
    //
    public static void initialise( params, log) {
        
        if (!params.input) {
            log.info "Pipeline requires a folder with read files as input (--input)"
            System.exit(1)
        }
    }

}
