const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});

//フォロー時の通知設定
exports.observeFollowing = functions.database.ref('/following/{uid}/{followingId}')
.onCreate((snapshot, context) => {
    const original = snapshot.val();

    var uid = context.params.uid;
    var followingId = context.params.followingId;

    console.log("User: " + uid + " Following: " + followingId)

    return admin.database().ref('/users/' + followingId).once('value', snapshot => {
        var userWeAreFollowing = snapshot.val();
        console.log("User username: " + userWeAreFollowing.nickname + " fcmToken: " + userWeAreFollowing.fcmToken)

        admin.database().ref('/users/' + uid).once('value', snapshot => {
            var userDoingTheFollowing = snapshot.val();

            var payload = {
                notification: {
                    body: '[' + userWeAreFollowing.nickname + ']: ' + userDoingTheFollowing.nickname + 'さんがあなたをフォローしました。'
                },
                data: {
                    followerId: uid
                }
            }

            return admin.messaging().sendToDevice(userWeAreFollowing.fcmToken, payload)
            .then(response => {
                return console.log("Successfully sent message: ", response)
                // return console.log("Successfully sent message: ", response.results[0].error);
            }).catch(error => {
                return console.log("Error sending message: ", error);
            })
        })
    })
})

//いいねの通知
exports.observeLikes = functions.database.ref('/likes/{uid}/{postId}/{likerId}')
.onCreate((snapshot, context) => {
    
    var uid = context.params.uid
    var postId = context.params.postId
    var likerId = context.params.likerId

    console.log("uid: " + uid + "PostId: " + postId + " LikerId: " + likerId)

    return admin.database().ref('/users/' + uid).once('value', snapshot => {
        var userWeAreLiking = snapshot.val();
        console.log("User username: " + userWeAreLiking.nickname + " fcmToken: " + userWeAreLiking.fcmToken)

        admin.database().ref('/users/' + likerId).once('value', snapshot => {
            var userDoingTheLiking = snapshot.val();

            var payload = {
                notification: {
                    body: '[' + userWeAreLiking.nickname + ']: ' + userDoingTheLiking.nickname + 'さんがあなたの写真にいいねしました。'
                },
                data: {
                    followerId: uid
                }
            }

            return admin.messaging().sendToDevice(userWeAreLiking.fcmToken, payload)
            .then(response => {
                return console.log("Successfully sent message: ", response)
                // return console.log("Successfully sent message: ", response.results[0].error);
            }).catch(error => {
                return console.log("Error sending message: ", error);
            })
        })
    })
})

exports.pushNotification = functions.https.onRequest((req, res) => {
    var uid = "tqIEHHdE7OX1YsGUX0zcJpAG8Iy1"

    admin.database().ref('/users/' + uid).once('value', snapshot => {
        var user = snapshot.val();

        console.log("User username: " + user.nickname + " fcmToken: " + user.fcmToken )

        var payload = {
            notification: {
                title: "Test PushNotification Title",
                body: "Test PushNotification Body"
            }
        }

        admin.messaging().sendToDevice(user.fcmToken, payload)
        .then(response => {
            return console.log("Successfully sent message: ", response);
        }).catch(error => {
            console.log("Error sending message: ", error);
        })
    })
})
