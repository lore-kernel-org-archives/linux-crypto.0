From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 01/10] crypto: caam - move append_key_aead() into init_sh_desc_key_aead()
Date: Tue, 22 Nov 2016 15:44:03 +0200
Message-ID: <1479822252-23833-2-git-send-email-horia.geanta@nxp.com>
References: <1479822252-23833-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0071.outbound.protection.outlook.com ([104.47.32.71]:31601
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933140AbcKVOAP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Nov 2016 09:00:15 -0500
In-Reply-To: <1479822252-23833-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

append_key_aead() is used in only one place, thus inline it.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 8db54b090d39..567e234fb49b 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -228,12 +228,19 @@ struct caam_ctx {
 	unsigned int authsize;
 };
 
-static void append_key_aead(u32 *desc, struct caam_ctx *ctx,
-			    int keys_fit_inline, bool is_rfc3686)
+static void init_sh_desc_key_aead(u32 *desc, struct caam_ctx *ctx,
+				  int keys_fit_inline, bool is_rfc3686)
 {
-	u32 *nonce;
+	u32 *key_jump_cmd;
 	unsigned int enckeylen = ctx->enckeylen;
 
+	/* Note: Context registers are saved. */
+	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
+
+	/* Skip if already shared */
+	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
+				   JUMP_COND_SHRD);
+
 	/*
 	 * RFC3686 specific:
 	 *	| ctx->key = {AUTH_KEY, ENC_KEY, NONCE}
@@ -258,6 +265,8 @@ static void append_key_aead(u32 *desc, struct caam_ctx *ctx,
 
 	/* Load Counter into CONTEXT1 reg */
 	if (is_rfc3686) {
+		u32 *nonce;
+
 		nonce = (u32 *)((void *)ctx->key + ctx->split_key_pad_len +
 			       enckeylen);
 		append_load_as_imm(desc, nonce, CTR_RFC3686_NONCE_SIZE,
@@ -269,21 +278,6 @@ static void append_key_aead(u32 *desc, struct caam_ctx *ctx,
 			    (16 << MOVE_OFFSET_SHIFT) |
 			    (CTR_RFC3686_NONCE_SIZE << MOVE_LEN_SHIFT));
 	}
-}
-
-static void init_sh_desc_key_aead(u32 *desc, struct caam_ctx *ctx,
-				  int keys_fit_inline, bool is_rfc3686)
-{
-	u32 *key_jump_cmd;
-
-	/* Note: Context registers are saved. */
-	init_sh_desc(desc, HDR_SHARE_SERIAL | HDR_SAVECTX);
-
-	/* Skip if already shared */
-	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
-				   JUMP_COND_SHRD);
-
-	append_key_aead(desc, ctx, keys_fit_inline, is_rfc3686);
 
 	set_jump_tgt_here(desc, key_jump_cmd);
 }
-- 
2.4.4
