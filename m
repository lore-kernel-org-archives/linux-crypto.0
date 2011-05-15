From: Kim Phillips <kim.phillips@freescale.com>
Subject: [PATCH 2/4] crypto: caam - fix decryption shared vs. non-shared key
  setting
Date: Sat, 14 May 2011 22:08:02 -0500
Message-ID: <20110514220802.c8c48a51.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:3785 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753591Ab1EODIK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 14 May 2011 23:08:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Key sharing is enabled by default in the shared descriptor.

Using CBC decrypt, AES has to alter the key in order to decrypt.
During high traffic decryption rates, i.e, when sharing starts to
take place, we need to use a different OPERATION option to tell AES
that the key was already altered by the PRIOR descriptor - we need
the following kind of logic:

if ( shared )
    operation where AES uses decryption key (DK=1)
else
    operation where AES uses encryption key (DK=0)

this patch implements this logic using a conditional and
a non-conditional local jump within the decryption job
descriptor.

Signed-off-by: Kim Phillips <kim.phillips@freescale.com>
---
 drivers/crypto/caam/caamalg.c |   26 ++++++++++++++++++++++----
 1 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index b97575e..4c69ba7 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -571,9 +571,27 @@ static int ipsec_esp(struct ipsec_esp_edesc *edesc, struct aead_request *areq,
 	/* copy iv from cipher/class1 input context to class2 infifo */
 	append_move(desc, MOVE_SRC_CLASS1CTX | MOVE_DEST_CLASS2INFIFO | ivsize);
 
-	/* start class 1 (cipher) operation */
-	append_operation(desc, ctx->class1_alg_type | OP_ALG_AS_INITFINAL |
-			 encrypt);
+	if (!encrypt) {
+		u32 *jump_cmd, *uncond_jump_cmd;
+
+		/* JUMP if shared */
+		jump_cmd = append_jump(desc, JUMP_TEST_ALL | JUMP_COND_SHRD);
+
+		/* start class 1 (cipher) operation, non-shared version */
+		append_operation(desc, ctx->class1_alg_type |
+				 OP_ALG_AS_INITFINAL);
+
+		uncond_jump_cmd = append_jump(desc, 0);
+
+		set_jump_tgt_here(desc, jump_cmd);
+
+		/* start class 1 (cipher) operation, shared version */
+		append_operation(desc, ctx->class1_alg_type |
+				 OP_ALG_AS_INITFINAL | OP_ALG_AAI_DK);
+		set_jump_tgt_here(desc, uncond_jump_cmd);
+	} else
+		append_operation(desc, ctx->class1_alg_type |
+				 OP_ALG_AS_INITFINAL | encrypt);
 
 	/* load payload & instruct to class2 to snoop class 1 if encrypting */
 	options = 0;
@@ -762,7 +780,7 @@ static int aead_authenc_decrypt(struct aead_request *req)
 	req->cryptlen -= ctx->authsize;
 
 	/* allocate extended descriptor */
-	edesc = ipsec_esp_edesc_alloc(req, 21 * sizeof(u32));
+	edesc = ipsec_esp_edesc_alloc(req, 24 * sizeof(u32));
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
-- 
1.7.5.1
