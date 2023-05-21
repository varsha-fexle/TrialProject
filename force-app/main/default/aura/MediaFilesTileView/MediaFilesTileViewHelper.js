({
    
    //handle play event on audio tag
    handlePlay : function(component, event, helper) {
        
        //get currently played audio id and previously played audio id
        var index = event.target.id;
        var prePlayId = component.get('v.playId');
        
        if(prePlayId != index && prePlayId != '' && prePlayId != 'undefined')
            helper.handlePause(prePlayId);
        
        component.set('v.playId',index);
    },
    
    //handle pause event 
    handlePause: function(prePlayId) {
        
        var audio_video = document.getElementById(prePlayId);
        audio_video.pause();
    },
    
})