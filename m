From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH v2] crypto: AF_ALG - race-free access of encryption flag
Date: Tue, 28 Nov 2017 22:33:09 +0100
Message-ID: <1943686.EAKghbSqDq@positron.chronox.de>
References: <001a113f2cd2d62b59055efb7618@google.com> <20171128053738.GA2383@zzz.localdomain> <6174444.U6zRo7pOhC@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Eric Biggers <ebiggers3@gmail.com>,
        syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42584 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752526AbdK1VdM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 16:33:12 -0500
In-Reply-To: <6174444.U6zRo7pOhC@tauon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I verified the correctnes of the patch with Eric's test program.
Without the patch, the issue is present. With the patch, the kernel
happily lives ever after.

Changes v2: change the submission into a proper patch

Ciao
Stephan

---8<---

The function af_alg_get_rsgl may sleep to wait for additional data. In
this case, the socket lock may be dropped. This allows user space to
change values in the socket data structure. Hence, all variables of the
context that are needed before and after the af_alg_get_rsgl must be
copied into a local variable.

This issue applies to the ctx->enc variable only. Therefore, this
value is copied into a local variable that is used for all operations
before and after the potential sleep and lock release. This implies that
any changes on this variable while the kernel waits for data will only
be picked up in another recvmsg operation.

Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/algif_aead.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 7d2d162666e5..4ba13c0b97ca 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -110,6 +110,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	size_t outlen = 0;		/* [out] RX bufs produced by kernel */
 	size_t usedpages = 0;		/* [in]  RX bufs to be used from user */
 	size_t processed = 0;		/* [in]  TX bufs to be consumed */
+	bool enc = ctx->enc;		/* prevent race if sock lock dropped */
 
 	/*
 	 * Data length provided by caller via sendmsg/sendpage that has not
@@ -137,7 +138,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	 * buffer provides the tag which is consumed resulting in only the
 	 * plaintext without a buffer for the tag returned to the caller.
 	 */
-	if (ctx->enc)
+	if (enc)
 		outlen = used + as;
 	else
 		outlen = used - as;
@@ -211,7 +212,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 	/* Use the RX SGL as source (and destination) for crypto op. */
 	rsgl_src = areq->first_rsgl.sgl.sg;
 
-	if (ctx->enc) {
+	if (enc) {
 		/*
 		 * Encryption operation - The in-place cipher operation is
 		 * achieved by the following operation:
@@ -288,7 +289,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		aead_request_set_callback(&areq->cra_u.aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
 					  af_alg_async_cb, areq);
-		err = ctx->enc ? crypto_aead_encrypt(&areq->cra_u.aead_req) :
+		err = enc ? crypto_aead_encrypt(&areq->cra_u.aead_req) :
 				 crypto_aead_decrypt(&areq->cra_u.aead_req);
 
 		/* AIO operation in progress */
@@ -305,7 +306,7 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
 		aead_request_set_callback(&areq->cra_u.aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
 					  crypto_req_done, &ctx->wait);
-		err = crypto_wait_req(ctx->enc ?
+		err = crypto_wait_req(enc ?
 				crypto_aead_encrypt(&areq->cra_u.aead_req) :
 				crypto_aead_decrypt(&areq->cra_u.aead_req),
 				&ctx->wait);
-- 
2.14.3
