Embrace's Background User Task Testing Harness Sample Project

Embrace published this code alongside this blog post: <link goes here>

The project demonstrates the use of our testing harness to assist with solving background user task termination scenarios.



[Running the app without the harness]
This is the only logs printed before the sample app crashes without the harness:<br/><br/>
<br/><br/>
"Background task still not ended after expiration handlers were called: <private>. This app will likely be terminated by the system. Call UIApplication.endBackgroundTask(_:) to avoid this.""<br/><br/>
<br/><br/>
^^ if you weren't looking at logs you would not even know this had happened at all since it happens in the background.<br/><br/>

Further, see how the task name is anonymized to <private>.  That's all you get in the logs.  It's up to you to figure out who created that task, but how can you do it?



[Running the app WITH the harness]
Here is the logging you see when the Embrace harness is attached:

// First we create our first background task, this one will be allowed to expire as a demonstration, this task is assigned id (1) by the system<br/><br/>
// Note how our harness outputs the real task name, and the stack trace that created it -- not just <private><br/><br/>
user_task_expiration_sample	[EMB] beginBackgroundTaskWithName MyBackgroundTask_1: called from (<stack trace>)<br/><br/>
user_task_expiration_sample	[EMB] handler is null? 0<br/><br/>
user_task_expiration_sample	[EMB] assigned identifier: 1<br/><br/>
<br/><br/>
// Next we create our control task, this task we are going to end -- it should not crash our application, this task is assigned id (2) by the system<br/><br/>
user_task_expiration_sample	[EMB] beginBackgroundTaskWithName MyBackgroundTask_2: called from  (<stack trace>)<br/><br/>
user_task_expiration_sample	[EMB] handler is null? 0<br/><br/>
user_task_expiration_sample	[EMB] assigned identifier: 2<br/><br/>
<br/><br/>
// Here the harness is helping us to confirm that task (2) was ended correctly.  Normally nothing is printed for this event:<br/><br/>
user_task_expiration_sample	[EMB] endBackgroundTask identifier: 2, called from:  (<stack trace>)<br/><br/>
<br/><br/>
<br/><br/>
... 26 seconds goes by with no logging<br/><br/>
// here is the same error as the above example, we now have to figure out which task is the <private> one:<br/><br/>
Background task still not ended after expiration handlers were called: <private>. This app will likely be terminated by the system. Call UIApplication.endBackgroundTask(_:) to avoid this.<br/><br/>
<br/><br/>

Now we can debug by looking at the logs and seeing which task id was never ended.  Since nothing ever ended task (1) we can be certain that the code that created task 1 is the code that crashed out app, we've unmasked the <private> task using the harness.
