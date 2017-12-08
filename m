From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: AF_ALG - fix race accessing cipher request
Date: Fri, 08 Dec 2017 11:50:37 +0100
Message-ID: <5543369.6UIL7PonCy@positron.chronox.de>
References: <001a1141f050d78763055f85c42e@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot
        <bot+3cbaad7926415bb8cfce88469e5f66a2bbd0d0cd@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <001a1141f050d78763055f85c42e@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert,

This patch would go on top of 7d2c3f54e6f646887d019faa45f35d6fe9fe82ce
"crypto: af_alg - remove locking in async callback" found in Linus' tree
which is not yet in the cryptodev-2.6 tree.

In addition, this patch is already on top of the other patches discussed
on this list fixing similar issues. I.e. depending in which order you apply
the patches, there may be a hunk. In case you want me to rebase the patch,
please let me know.

---8<---
When invoking an asynchronous cipher operation, the invocation of the
callback may be performed before the subsequent operations in the
initial code path are invoked. The callback deletes the cipher request
data structure which implies that after the invocation of the
asynchronous cipher operation, this data structure must not be accessed
any more.

The setting of the return code size with the request data structure must
therefore be moved before the invocation of the asynchronous cipher
operation.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c     | 10 +++++-----
 crypto/algif_skcipher.c | 10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 15e561dc47b5..d7ec2f4ebaf9 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -291,6 +291,10 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		/* AIO operation */
 		sock_hold(sk);
 		areq->iocb = msg->msg_iocb;
+
+		/* Remember output size that will be generated. */
+		areq->outlen = outlen;
+
 		aead_request_set_callback(&areq->cra_u.aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
 					  af_alg_async_cb, areq);
@@ -298,12 +302,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 				 crypto_aead_decrypt(&areq->cra_u.aead_req);
 
 		/* AIO operation in progress */
-		if (err == -EINPROGRESS || err == -EBUSY) {
-			/* Remember output size that will be generated. */
-			areq->outlen = outlen;
-
+		if (err == -EINPROGRESS || err == -EBUSY)
 			return -EIOCBQUEUED;
-		}
 
 		sock_put(sk);
 	} else {
diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6fb595cd63ac..baef9bfccdda 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -125,6 +125,10 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 		/* AIO operation */
 		sock_hold(sk);
 		areq->iocb = msg->msg_iocb;
+
+		/* Remember output size that will be generated. */
+		areq->outlen = len;
+
 		skcipher_request_set_callback(&areq->cra_u.skcipher_req,
 					      CRYPTO_TFM_REQ_MAY_SLEEP,
 					      af_alg_async_cb, areq);
@@ -133,12 +137,8 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
 			crypto_skcipher_decrypt(&areq->cra_u.skcipher_req);
 
 		/* AIO operation in progress */
-		if (err == -EINPROGRESS || err == -EBUSY) {
-			/* Remember output size that will be generated. */
-			areq->outlen = len;
-
+		if (err == -EINPROGRESS || err == -EBUSY)
 			return -EIOCBQUEUED;
-		}
 
 		sock_put(sk);
 	} else {
-- 
2.14.3
