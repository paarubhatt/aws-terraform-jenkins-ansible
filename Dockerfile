FROM openjdk:8
ADD jarstaging/com/team2/demo-workshop/1.0.0/demo-workshop-1.0.0.jar sample_app.jar 
ENTRYPOINT [ "java", "-jar", "sample_app.jar" ]
