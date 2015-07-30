From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>
Subject: [PATCH v2] crypto: caam - fix rfc4106 encap shared descriptor
Date: Thu, 30 Jul 2015 22:11:18 +0300
Message-ID: <1438283478-32198-1-git-send-email-horia.geanta@freescale.com>
References: <55BA435C.1000803@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor.ambarus@freescale.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bon0132.outbound.protection.outlook.com ([157.56.111.132]:26848
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752057AbbG3TZl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 30 Jul 2015 15:25:41 -0400
In-Reply-To: <55BA435C.1000803@freescale.com>
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

v2 - added erratum workaround

 drivers/crypto/caam/caamalg.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/caam/caamalg.c b/drivers/crypto/caam/caamal=
g.c
index 3c50a5082127..e49373409582 100644
--- a/drivers/crypto/caam/caamalg.c
+++ b/drivers/crypto/caam/caamalg.c
@@ -87,8 +87,8 @@
 #define DESC_GCM_DEC_LEN		(DESC_GCM_BASE + 12 * CAAM_CMD_SZ)
=20
 #define DESC_RFC4106_BASE		(3 * CAAM_CMD_SZ)
-#define DESC_RFC4106_ENC_LEN		(DESC_RFC4106_BASE + 12 * CAAM_CMD_SZ)
-#define DESC_RFC4106_DEC_LEN		(DESC_RFC4106_BASE + 12 * CAAM_CMD_SZ)
+#define DESC_RFC4106_ENC_LEN		(DESC_RFC4106_BASE + 13 * CAAM_CMD_SZ)
+#define DESC_RFC4106_DEC_LEN		(DESC_RFC4106_BASE + 13 * CAAM_CMD_SZ)
=20
 #define DESC_RFC4543_BASE		(3 * CAAM_CMD_SZ)
 #define DESC_RFC4543_ENC_LEN		(DESC_RFC4543_BASE + 11 * CAAM_CMD_SZ)
@@ -989,19 +989,22 @@ static int rfc4106_set_sh_desc(struct crypto_aead=
 *aead)
 	/* Will read cryptlen bytes */
 	append_math_sub(desc, VARSEQINLEN, SEQINLEN, REG0, CAAM_CMD_SZ);
=20
-	/* Read payload data */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
-			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_LAST1);
+	/* Workaround for erratum A-005473 (simultaneous SEQ FIFO skips) */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_MSG);
=20
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
@@ -1060,9 +1063,8 @@ static int rfc4106_set_sh_desc(struct crypto_aead=
 *aead)
 	/* Will read cryptlen bytes */
 	append_math_sub(desc, VARSEQINLEN, SEQOUTLEN, REG3, CAAM_CMD_SZ);
=20
-	/* Read encrypted data */
-	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLDST_VLF |
-			     FIFOLD_TYPE_MSG | FIFOLD_TYPE_FLUSH1);
+	/* Workaround for erratum A-005473 (simultaneous SEQ FIFO skips) */
+	append_seq_fifo_load(desc, 0, FIFOLD_CLASS_CLASS1 | FIFOLD_TYPE_MSG);
=20
 	/* Skip assoc data */
 	append_seq_fifo_store(desc, 0, FIFOST_TYPE_SKIP | FIFOLDST_VLF);
@@ -1073,6 +1075,10 @@ static int rfc4106_set_sh_desc(struct crypto_aea=
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
