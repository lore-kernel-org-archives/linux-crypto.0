From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 6/7] crypto: caam - fix polarity of "propagate error" logic
Date: Mon, 12 Dec 2011 14:59:15 -0600
Message-ID: <1323723556-7100-7-git-send-email-kim.phillips@freescale.com>
References: <1323723556-7100-1-git-send-email-kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:19008 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab1LLVAg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Dec 2011 16:00:36 -0500
In-Reply-To: <1323723556-7100-1-git-send-email-kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

the polarity of the definition for error propagation was reverse
in the initial desc.h.  Fix desc.h and its users.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c     |   10 +++++-----
 drivers/crypto/caam/desc.h        |    4 ++--
 drivers/crypto/caam/desc_constr.h |    7 ++++---
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index a5bc706..e73cf2e 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -113,7 +113,7 @@ static inline void append_dec_shr_done(u32 *desc)
 
 	jump_cmd = append_jump(desc, JUMP_CLASS_CLASS1 | JUMP_TEST_ALL);
 	set_jump_tgt_here(desc, jump_cmd);
-	append_cmd(desc, SET_OK_PROP_ERRORS | CMD_LOAD);
+	append_cmd(desc, SET_OK_NO_PROP_ERRORS | CMD_LOAD);
 }
 
 /*
@@ -213,7 +213,7 @@ static void init_sh_desc_key_aead(u32 *desc, struct caam_ctx *ctx,
 	set_jump_tgt_here(desc, key_jump_cmd);
 
 	/* Propagate errors from shared to job descriptor */
-	append_cmd(desc, SET_OK_PROP_ERRORS | CMD_LOAD);
+	append_cmd(desc, SET_OK_NO_PROP_ERRORS | CMD_LOAD);
 }
 
 static int aead_set_sh_desc(struct crypto_aead *aead)
@@ -310,7 +310,7 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	/* Only propagate error immediately if shared */
 	jump_cmd = append_jump(desc, JUMP_TEST_ALL);
 	set_jump_tgt_here(desc, key_jump_cmd);
-	append_cmd(desc, SET_OK_PROP_ERRORS | CMD_LOAD);
+	append_cmd(desc, SET_OK_NO_PROP_ERRORS | CMD_LOAD);
 	set_jump_tgt_here(desc, jump_cmd);
 
 	/* Class 2 operation */
@@ -683,7 +683,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	set_jump_tgt_here(desc, key_jump_cmd);
 
 	/* Propagate errors from shared to job descriptor */
-	append_cmd(desc, SET_OK_PROP_ERRORS | CMD_LOAD);
+	append_cmd(desc, SET_OK_NO_PROP_ERRORS | CMD_LOAD);
 
 	/* Load iv */
 	append_cmd(desc, CMD_SEQ_LOAD | LDST_SRCDST_BYTE_CONTEXT |
@@ -724,7 +724,7 @@ static int ablkcipher_setkey(struct crypto_ablkcipher *ablkcipher,
 	/* For aead, only propagate error immediately if shared */
 	jump_cmd = append_jump(desc, JUMP_TEST_ALL);
 	set_jump_tgt_here(desc, key_jump_cmd);
-	append_cmd(desc, SET_OK_PROP_ERRORS | CMD_LOAD);
+	append_cmd(desc, SET_OK_NO_PROP_ERRORS | CMD_LOAD);
 	set_jump_tgt_here(desc, jump_cmd);
 
 	/* load IV */
diff --git a/drivers/crypto/caam/desc.h b/drivers/crypto/caam/desc.h
index 6984cc5..a17c295 100644
--- a/drivers/crypto/caam/desc.h
+++ b/drivers/crypto/caam/desc.h
@@ -233,8 +233,8 @@
 #define LDOFF_CHG_SHARE_SHIFT		0
 #define LDOFF_CHG_SHARE_MASK		(0x3 << LDOFF_CHG_SHARE_SHIFT)
 #define LDOFF_CHG_SHARE_NEVER		(0x1 << LDOFF_CHG_SHARE_SHIFT)
-#define LDOFF_CHG_SHARE_OK_NO_PROP	(0x2 << LDOFF_CHG_SHARE_SHIFT)
-#define LDOFF_CHG_SHARE_OK_PROP		(0x3 << LDOFF_CHG_SHARE_SHIFT)
+#define LDOFF_CHG_SHARE_OK_PROP		(0x2 << LDOFF_CHG_SHARE_SHIFT)
+#define LDOFF_CHG_SHARE_OK_NO_PROP	(0x3 << LDOFF_CHG_SHARE_SHIFT)
 
 #define LDOFF_ENABLE_AUTO_NFIFO		(1 << 2)
 #define LDOFF_DISABLE_AUTO_NFIFO	(1 << 3)
diff --git a/drivers/crypto/caam/desc_constr.h b/drivers/crypto/caam/desc_constr.h
index 0991323..348b882 100644
--- a/drivers/crypto/caam/desc_constr.h
+++ b/drivers/crypto/caam/desc_constr.h
@@ -18,9 +18,10 @@
 #define PRINT_POS
 #endif
 
-#define SET_OK_PROP_ERRORS (IMMEDIATE | LDST_CLASS_DECO | \
-			    LDST_SRCDST_WORD_DECOCTRL | \
-			    (LDOFF_CHG_SHARE_OK_PROP << LDST_OFFSET_SHIFT))
+#define SET_OK_NO_PROP_ERRORS (IMMEDIATE | LDST_CLASS_DECO | \
+			       LDST_SRCDST_WORD_DECOCTRL | \
+			       (LDOFF_CHG_SHARE_OK_NO_PROP << \
+				LDST_OFFSET_SHIFT))
 #define DISABLE_AUTO_INFO_FIFO (IMMEDIATE | LDST_CLASS_DECO | \
 				LDST_SRCDST_WORD_DECOCTRL | \
 				(LDOFF_DISABLE_AUTO_NFIFO << LDST_OFFSET_SHIFT))
-- 
1.7.8
