From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 3/3] crypto: caam - set descriptor sharing type to SERIAL
Date: Fri, 13 Jul 2012 17:49:28 -0500
Message-ID: <20120713174928.2f09fea79e1fbd7abda4c3ce@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:20392
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755167Ab2GMWv3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Jul 2012 18:51:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

SHARE_WAIT, whilst more optimal for association-less crypto,
has the ability to start thrashing the CCB descriptor/key
caches, given high levels of traffic across multiple security
associations (and thus keys).

Switch to using the SERIAL sharing type, which prefers
the last used CCB for the SA.  On a 2-DECO platform
such as the P3041, this can improve performance by
about 3.7%.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c  | 8 ++++----
 drivers/crypto/caam/caamhash.c | 4 ++--
 drivers/crypto/caam/caamrng.c  | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index d772105..2916614 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -205,7 +205,7 @@ static void init_sh_desc_key_aead(u32 *desc, struct caam_ctx *ctx,
 {
 	u32 *key_jump_cmd;
 
-	init_sh_desc(desc, HDR_SHARE_WAIT);
+	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
 	/* Skip if already shared */
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
@@ -302,7 +302,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	desc = ctx->sh_desc_dec;
 
 	/* aead_decrypt shared descriptor */
-	init_sh_desc(desc, HDR_SHARE_WAIT);
+	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
 	/* Skip if already shared */
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
@@ -564,7 +564,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 
 	/* ablkcipher_encrypt shared descriptor */
 	desc = ctx->sh_desc_enc;
-	init_sh_desc(desc, HDR_SHARE_WAIT);
+	init_sh_desc(desc, HDR_SHARE_SERIAL);
 	/* Skip if already shared */
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
@@ -605,7 +605,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	/* ablkcipher_decrypt shared descriptor */
 	desc = ctx->sh_desc_dec;
 
-	init_sh_desc(desc, HDR_SHARE_WAIT);
+	init_sh_desc(desc, HDR_SHARE_SERIAL);
 	/* Skip if already shared */
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
 				   JUMP_COND_SHRD);
diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index dca3c19..fbf3fe8 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -225,7 +225,7 @@ static inline void init_sh_desc_key_ahash(u32 *desc, struct caam_hash_ctx *ctx)
 {
 	u32 *key_jump_cmd;
 
-	init_sh_desc(desc, HDR_SHARE_WAIT);
+	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
 	if (ctx->split_key_len) {
 		/* Skip if already shared */
@@ -311,7 +311,7 @@ static int ahash_set_sh_desc(struct crypto_ahash *ahash)
 	/* ahash_update shared descriptor */
 	desc = ctx->sh_desc_update;
 
-	init_sh_desc(desc, HDR_SHARE_WAIT);
+	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
 	/* Import context from software */
 	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index ccedb54..d1939a9 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -193,7 +193,7 @@ static inline void rng_create_sh_desc(struct caam_rng_ctx *ctx)
 	struct device *jrdev = ctx->jrdev;
 	u32 *desc = ctx->sh_desc;
 
-	init_sh_desc(desc, HDR_SHARE_WAIT);
+	init_sh_desc(desc, HDR_SHARE_SERIAL);
 
 	/* Propagate errors from shared to job descriptor */
 	append_cmd(desc, SET_OK_NO_PROP_ERRORS | CMD_LOAD);
-- 
1.7.11.2
