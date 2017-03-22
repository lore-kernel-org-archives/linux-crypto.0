From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH] crypto: DRBG - initialize SGL only once
Date: Wed, 22 Mar 2017 15:26:36 +0100
Message-ID: <1909030.BalyQCuxjY@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58204 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759063AbdCVO0z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Mar 2017 10:26:55 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

An SGL to be initialized only once even when its buffers are written
to several times.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 8a4d98b..fa749f4 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1749,17 +1749,16 @@ static int drbg_kcapi_sym_ctr(struct drbg_state *drbg,
 			      u8 *inbuf, u32 inlen,
 			      u8 *outbuf, u32 outlen)
 {
-	struct scatterlist sg_in;
+	struct scatterlist sg_in, sg_out;
 	int ret;
 
 	sg_init_one(&sg_in, inbuf, inlen);
+	sg_init_one(&sg_out, drbg->outscratchpad, DRBG_OUTSCRATCHLEN);
 
 	while (outlen) {
 		u32 cryptlen = min3(inlen, outlen, (u32)DRBG_OUTSCRATCHLEN);
-		struct scatterlist sg_out;
 
 		/* Output buffer may not be valid for SGL, use scratchpad */
-		sg_init_one(&sg_out, drbg->outscratchpad, cryptlen);
 		skcipher_request_set_crypt(drbg->ctr_req, &sg_in, &sg_out,
 					   cryptlen, drbg->V);
 		ret = crypto_skcipher_encrypt(drbg->ctr_req);
-- 
2.9.3
