From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 3/3] crypto: algif_skcipher - Do not set MAY_BACKLOG on the async path
Date: Mon, 01 Feb 2016 21:08:03 +0800
Message-ID: <E1aQED5-00022p-BA@gondolin.me.apana.org.au>
References: <20160201130644.GA6904@gondor.apana.org.au>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48218 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932568AbcBANIG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 08:08:06 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The async path cannot use MAY_BACKLOG because it is not meant to
block, which is what MAY_BACKLOG does.  On the other hand, both
the sync and async paths can make use of MAY_SLEEP.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algif_skcipher.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 2d549aa..41580b4 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -536,7 +536,7 @@ static int skcipher_recvmsg_async(struct socket *sock, struct msghdr *msg,
 	sg_init_table(sreq->tsg, tx_nents);
 	memcpy(iv, ctx->iv, ivsize);
 	skcipher_request_set_tfm(req, tfm);
-	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
 				      skcipher_async_cb, sreq);
 
 	while (iov_iter_count(&msg->msg_iter)) {
@@ -949,7 +949,8 @@ static int skcipher_accept_parent_nokey(void *private, struct sock *sk)
 	ask->private = ctx;
 
 	skcipher_request_set_tfm(&ctx->req, skcipher);
-	skcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+	skcipher_request_set_callback(&ctx->req, CRYPTO_TFM_REQ_MAY_SLEEP |
+						 CRYPTO_TFM_REQ_MAY_BACKLOG,
 				      af_alg_complete, &ctx->completion);
 
 	sk->sk_destruct = skcipher_sock_destruct;
