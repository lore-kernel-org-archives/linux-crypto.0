From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/3] crypto-ansi_cprng: Delete unnecessary blank lines
Date: Sat, 21 Oct 2017 19:17:25 +0200
Message-ID: <7c466b3a-ca32-b946-f36e-a963c31a2320@users.sourceforge.net>
References: <d284473a-b968-2b3e-9147-1c8598a26f7c@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:58160 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932149AbdJURSf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 Oct 2017 13:18:35 -0400
In-Reply-To: <d284473a-b968-2b3e-9147-1c8598a26f7c@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 21 Oct 2017 16:27:56 +0200

The script "checkpatch.pl" pointed information out like the following.

CHECK: Please don't use multiple blank lines

Thus fix the affected source code places.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 crypto/ansi_cprng.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 3d805bf6d0c6..b9ec1975dde7 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -40,7 +40,6 @@
  * for implementation details
  */
 
-
 struct prng_context {
 	spinlock_t prng_lock;
 	unsigned char rand_data[DEFAULT_BLK_SZ];
@@ -77,8 +76,8 @@ static void xor_vectors(unsigned char *in1, unsigned char *in2,
 
 	for (i = 0; i < size; i++)
 		out[i] = in1[i] ^ in2[i];
-
 }
+
 /*
  * Returns DEFAULT_BLK_SZ bytes of random data per call
  * returns 0 if generation succeeded, <0 if something went wrong
@@ -89,7 +88,6 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	unsigned char tmp[DEFAULT_BLK_SZ];
 	unsigned char *output = NULL;
 
-
 	dbgprint(KERN_CRIT "Calling _get_more_prng_bytes for context %p\n",
 		ctx);
 
@@ -101,7 +99,6 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 	 * This algorithm is a 3 stage state machine
 	 */
 	for (i = 0; i < 3; i++) {
-
 		switch (i) {
 		case 0:
 			/*
@@ -156,10 +153,8 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 			break;
 		}
 
-
 		/* do the encryption */
 		crypto_cipher_encrypt_one(ctx->tfm, output, tmp);
-
 	}
 
 	/*
@@ -190,7 +185,6 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
 	unsigned int byte_count = (unsigned int)nbytes;
 	int err;
 
-
 	spin_lock_bh(&ctx->prng_lock);
 	if (ctx->flags & PRNG_NEED_RESET)
 		goto failure_indication;
@@ -214,7 +208,6 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
 	dbgprint(KERN_CRIT "getting %d random bytes for context %p\n",
 		byte_count, ctx);
 
-
 remainder:
 	if (ctx->rand_data_valid == DEFAULT_BLK_SZ &&
 	    _get_more_prng_bytes(ctx, do_cont_test) < 0)
-- 
2.14.2
