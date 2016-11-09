From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 01/14] crypto: caam - fix AEAD givenc descriptors
Date: Wed, 9 Nov 2016 10:46:11 +0200
Message-ID: <1478681184-9442-2-git-send-email-horia.geanta@nxp.com>
References: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        Alex Porosanu <alexandru.porosanu@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2nam02on0049.outbound.protection.outlook.com ([104.47.38.49]:56000
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751934AbcKIIrn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 03:47:43 -0500
In-Reply-To: <1478681184-9442-1-git-send-email-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Alex Porosanu <alexandru.porosanu@nxp.com>

The AEAD givenc descriptor relies on moving the IV through the
output FIFO and then back to the CTX2 for authentication. The
SEQ FIFO STORE could be scheduled before the data can be
read from OFIFO, especially since the SEQ FIFO LOAD needs
to wait for the SEQ FIFO LOAD SKIP to finish first. The
SKIP takes more time when the input is SG than when it's
a contiguous buffer. If the SEQ FIFO LOAD is not scheduled
before the STORE, the DECO will hang waiting for data
to be available in the OFIFO so it can be transferred to C2.
In order to overcome this, first force transfer of IV to C2
by starting the "cryptlen" transfer first and then starting to
store data from OFIFO to the output buffer.

Fixes: 1acebad3d8db8 ("crypto: caam - faster aead implementation")
Cc: <stable@vger.kernel.org> # 3.2+
Signed-off-by: Alex Porosanu <alexandru.porosanu@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/caamalg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamalg.c
index 8de85dfb1b04..5317d8cad44d 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -736,7 +736,9 @@ static int aead_set_sh_desc(struct crypto_aead *aead)
 
 	/* Will read cryptlen */
 	append_math_add(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
-	aead_append_src_dst(desc, FIFOLD_TYPE_MSG1OUT2);
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_BOTH | KEY_VLF |
+			     FIFOLD_TYPE_MSG1OUT2 | FIFOLD_TYPE_LASTBOTH);
+	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | KEY_VLF);
 
 	/* Write ICV */
 	append_seq_store(desc, ctx->authsize, LDST_CLASS_2_CCB |
-- 
2.4.4
