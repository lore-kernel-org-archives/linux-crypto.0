From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 07/14] crypto: caam - remove unused command from aead givencrypt
Date: Wed, 9 Nov 2016 10:46:17 +0200
Message-ID: <1478681184-9442-8-git-send-email-horia.geanta@nxp.com>
References: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-dm3nam03on0089.outbound.protection.outlook.com ([104.47.41.89]:31520
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751977AbcKIJUF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 04:20:05 -0500
In-Reply-To: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

REG3 no longer needs to be updated, since it's not used after that.
This shared descriptor command is a leftover of the conversion to
AEAD interface.

Fixes: 479bcc7c5b9e1 "crypto: caam - Convert authenc to new AEAD interface"
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index cb26a57c5aaf..1982dacce80e 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -75,7 +75,7 @@
 #define DESC_AEAD_BASE			(4 * CAAM_CMD_SZ)
 #define DESC_AEAD_ENC_LEN		(DESC_AEAD_BASE + 11 * CAAM_CMD_SZ)
 #define DESC_AEAD_DEC_LEN		(DESC_AEAD_BASE + 15 * CAAM_CMD_SZ)
-#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 9 * CAAM_CMD_SZ)
+#define DESC_AEAD_GIVENC_LEN		(DESC_AEAD_ENC_LEN + 7 * CAAM_CMD_SZ)
 
 /* Note: Nonce is counted in enckeylen */
 #define DESC_AEAD_CTR_RFC3686_LEN	(4 * CAAM_CMD_SZ)
@@ -697,9 +697,6 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 	append_math_add(desc, VARSEQINLEN, ZERO, REG3, CAAM_CMD_SZ);
 	append_math_add(desc, VARSEQOUTLEN, ZERO, REG3, CAAM_CMD_SZ);
 
-	/* ivsize + cryptlen = seqoutlen - authsize */
-	append_math_sub_imm_u32(desc, REG3, SEQOUTLEN, IMM, ctx->authsize);
-
 	/* Skip assoc data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
 
-- 
2.4.4
