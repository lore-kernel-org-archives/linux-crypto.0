From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 13/13] crypto: caam - fix condition for the jump over key(s) command
Date: Fri, 7 Jul 2017 16:05:23 +0300
Message-ID: <20170707130523.32427-14-horia.geanta@nxp.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0040.outbound.protection.outlook.com ([104.47.40.40]:30793
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752148AbdGGNGK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Jul 2017 09:06:10 -0400
In-Reply-To: <20170707130523.32427-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tudor Ambarus <tudor-dan.ambarus@nxp.com>

SELF condition has no meaning for the SERIAL sharing since the jobs
are executed in the same DECO.

Signed-off-by: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg_desc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamalg_desc.c b/drivers/crypto/caam/caamalg_desc.c
index 6f9c7ec0e339..530c14ee32de 100644
--- a/drivers/crypto/caam/caamalg_desc.c
+++ b/drivers/crypto/caam/caamalg_desc.c
@@ -599,7 +599,7 @@ void cnstr_shdsc_gcm_encap(u32 * const desc, struct alginfo *cdata,
 
 	/* skip key loading if they are loaded due to sharing */
 	key_jump_cmd = append_jump(desc, JUMP_JSL | JUMP_TEST_ALL |
-				   JUMP_COND_SHRD | JUMP_COND_SELF);
+				   JUMP_COND_SHRD);
 	if (cdata->key_inline)
 		append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
 				  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
@@ -688,8 +688,7 @@ void cnstr_shdsc_gcm_decap(u32 * const desc, struct alginfo *cdata,
 
 	/* skip key loading if they are loaded due to sharing */
 	key_jump_cmd = append_jump(desc, JUMP_JSL |
-				   JUMP_TEST_ALL | JUMP_COND_SHRD |
-				   JUMP_COND_SELF);
+				   JUMP_TEST_ALL | JUMP_COND_SHRD);
 	if (cdata->key_inline)
 		append_key_as_imm(desc, cdata->key_virt, cdata->keylen,
 				  cdata->keylen, CLASS_1 | KEY_DEST_CLASS_REG);
-- 
2.12.0.264.gd6db3f216544
