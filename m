From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>
Subject: [PATCH] crypto: caam - fix rfc4106 encap shared descriptor
Date: Thu, 30 Jul 2015 16:39:26 +0300
Message-ID: <1438263566-22222-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0110.outbound.protection.outlook.com ([207.46.100.110]:30421
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750910AbbG3Nj4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 09:39:56 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The encap shared descriptor was changed to use the new IV convention.
In the process some commands were shifted, making the output length
zero, caam effectively writing garbage in dst.

While here, update the decap descriptor to execute the "write" commands
before the "read"s (as it previously was).
This makes sure the input fifo is drained before becoming full.

=46ixes: 46218750d523 ("crypto: caam - Use new IV convention")
Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@freescale.com>
---
 drivers/crypto/caam/caamalg.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamal=
g.c
index 3c50a5082127..b08ae6983d1f 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -989,19 +989,19 @@ static int rfc4106_set_sh_desc(struct crypto_aead=
 *aead)
 	/* Will read cryptlen bytes */
 	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
=20
-	/* Read payload data */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
-			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
-
 	/* Skip assoc data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
=20
 	/* cryptlen =3D seqoutlen - assoclen */
-	append_math_sub(desc, VARSEQOUTLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
+	append_math_sub(desc, VARSEQOUTLEN, VARSEQINLEN, REG0, CAAM_CMD_SZ);
=20
 	/* Write encrypted data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VL=
=46);
=20
+	/* Read payload data */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
+			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
+
 	/* Write ICV */
 	append_seq_store(desc, ctx->authsize, LDST_CLASS_1_CCB |
 			 LDST_SRCDST_BYTE_CONTEXT);
@@ -1060,10 +1060,6 @@ static int rfc4106_set_sh_desc(struct crypto_aea=
d *aead)
 	/* Will read cryptlen bytes */
 	append_math_sub(desc, VARSEQINLEN, SEQOUTLEN, REG3, CAAM_CMD_SZ);
=20
-	/* Read encrypted data */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
-			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_FLUSH1);
-
 	/* Skip assoc data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
=20
@@ -1073,6 +1069,10 @@ static int rfc4106_set_sh_desc(struct crypto_aea=
d *aead)
 	/* Store payload data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_MESSAGE_DATA | FIFOLDST_VL=
=46);
=20
+	/* Read encrypted data */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
+			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_FLUSH1);
+
 	/* Read ICV */
 	append_seq_fifo_load(desc, ctx->authsize, FIFOLD_CLASS_CLASS1 |
 			     FIFOLD_TYPE_ICV | FIFOLD_TYPE_LAST1);
--=20
2.4.4
