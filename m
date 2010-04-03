From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 7/7] net/ppp_mppe: convert from arc4 to arc4blk
Date: Sat,  3 Apr 2010 09:49:29 +0200
Message-ID: <1270280969-11357-8-git-send-email-sebastian@breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
	<linux-ppp@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-ppp-owner@vger.kernel.org>
In-Reply-To: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Sender: linux-ppp-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

ecb(arc4) is getting replaced by arc4 which is a blkcipher by itself

Cc: <linux-ppp@vger.kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 drivers/net/Kconfig    |    3 +--
 drivers/net/ppp_mppe.c |   12 ++++++------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index dd9a09c..4b5dd86 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3075,8 +3075,7 @@ config PPP_MPPE
        depends on PPP && EXPERIMENTAL
        select CRYPTO
        select CRYPTO_SHA1
-       select CRYPTO_ARC4
-       select CRYPTO_ECB
+       select CRYPTO_ARC4BLK
        ---help---
          Support for the MPPE Encryption protocol, as employed by the
 	 Microsoft Point-to-Point Tunneling Protocol.
diff --git a/drivers/net/ppp_mppe.c b/drivers/net/ppp_mppe.c
index 6d1a1b8..4deaf70 100644
--- a/drivers/net/ppp_mppe.c
+++ b/drivers/net/ppp_mppe.c
@@ -42,7 +42,6 @@
  *                    MOD_DEC_USAGE_COUNT/MOD_INC_USAGE_COUNT which are
  *                    deprecated in 2.6
  */
-
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -55,6 +54,7 @@
 #include <linux/ppp_defs.h>
 #include <linux/ppp-comp.h>
 #include <linux/scatterlist.h>
+#include <crypto/arc4.h>
 
 #include "ppp_mppe.h"
 
@@ -162,11 +162,11 @@ static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
 {
 	struct scatterlist sg_in[1], sg_out[1];
 	struct blkcipher_desc desc = { .tfm = state->arc4 };
+	struct arc4_iv *iv = crypto_blkcipher_crt(state->arc4)->iv;
 
 	get_new_key_from_sha(state);
 	if (!initial_key) {
-		crypto_blkcipher_setkey(state->arc4, state->sha1_digest,
-					state->keylen);
+		arc4_setup_iv(iv, state->sha1_digest, state->keylen);
 		sg_init_table(sg_in, 1);
 		sg_init_table(sg_out, 1);
 		setup_sg(sg_in, state->sha1_digest, state->keylen);
@@ -184,7 +184,7 @@ static void mppe_rekey(struct ppp_mppe_state * state, int initial_key)
 		state->session_key[1] = 0x26;
 		state->session_key[2] = 0x9e;
 	}
-	crypto_blkcipher_setkey(state->arc4, state->session_key, state->keylen);
+	arc4_setup_iv(iv, state->session_key, state->keylen);
 }
 
 /*
@@ -204,7 +204,7 @@ static void *mppe_alloc(unsigned char *options, int optlen)
 		goto out;
 
 
-	state->arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
+	state->arc4 = crypto_alloc_blkcipher("arc4", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(state->arc4)) {
 		state->arc4 = NULL;
 		goto out_free;
@@ -712,7 +712,7 @@ static struct compressor ppp_mppe = {
 static int __init ppp_mppe_init(void)
 {
 	int answer;
-	if (!(crypto_has_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC) &&
+	if (!(crypto_has_blkcipher("arc4", 0, CRYPTO_ALG_ASYNC) &&
 	      crypto_has_hash("sha1", 0, CRYPTO_ALG_ASYNC)))
 		return -ENODEV;
 
-- 
1.6.6

