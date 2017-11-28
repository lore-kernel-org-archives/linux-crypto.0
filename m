From: Stephan Mueller <smueller@chronox.de>
Subject: Re: general protection fault in blkcipher_walk_done
Date: Tue, 28 Nov 2017 10:03:53 +0100
Message-ID: <6174444.U6zRo7pOhC@tauon.chronox.de>
References: <001a113f2cd2d62b59055efb7618@google.com> <20171128053738.GA2383@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: syzbot
        <bot+3401d9494b9380f7244bcc7fec49680878fccba6@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171128053738.GA2383@zzz.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 28. November 2017, 06:37:38 CET schrieb Eric Biggers:

Hi Eric,

> On Mon, Nov 27, 2017 at 10:56:47AM -0800, syzbot wrote:
> > Hello,
> > 
> > syzkaller hit the following crash on
> > 1ea8d039f9edcfefb20d8ddfe136930f6e551529
> > git://git.cmpxchg.org/linux-mmots.git/master
> > compiler: gcc (GCC) 7.1.1 20170620
> > .config is attached
> > Raw console output is attached.
> > C reproducer is attached
> > syzkaller reproducer is attached. See https://goo.gl/kgGztJ
> > for information about syzkaller reproducers
> 
> Still happens on latest Linus tree (v4.15-rc1) with crypto/master merged in.
>  It seems that _aead_recvmsg() is being confused by the operation mode
> being changed from encryption to decryption while it has dropped the socket
> lock in af_alg_wait_for_data().  Here's a simplified reproducer:

Right, the enc/dec direction should be a local variable and not used from the context.

All other variables are either accessed before or after the sleep that releases the socket. Thus, the other variables are save regarding this issue.

Note, I also checked the code before v4.13: this code is not affected by this issue because the sleep happens before any member of the context is dereferenced.

Eric, may I ask you to check the attached patch? Note, I did not yet test that patch myself. Thanks a lot.

---8<---

>From a06f26e1baaf6acb855ab8fb55a220a176aa0b9f Mon Sep 17 00:00:00 2001
From: Stephan Mueller <stephan.mueller@atsec.com>
Date: Tue, 28 Nov 2017 09:48:33 +0100
Subject: [PATCH] crypto: AF_ALG - race-free access of encryption flag

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
Signed-off-by: Stephan Mueller <stephan.mueller@atsec.com>
---
 crypto/algif_aead.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index 7d2d162666e5..4fa5dd408eba 100644
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
