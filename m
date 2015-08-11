From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@freescale.com>
Subject: [PATCH] crypto: caam - fix memory corruption in ahash_final_ctx
Date: Tue, 11 Aug 2015 20:19:20 +0300
Message-ID: <1439313560-14347-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <linux-crypto@vger.kernel.org>, <stable@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bn0103.outbound.protection.outlook.com ([157.56.110.103]:29514
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751672AbbHKRdu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Aug 2015 13:33:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When doing pointer operation for accessing the HW S/G table,
a value representing number of entries (and not number of bytes)
must be used.

Cc: <stable@vger.kernel.org> # 3.6+
=46ixes: 045e36780f115 ("crypto: caam - ahash hmac support")
Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>
---
 drivers/crypto/caam/caamhash.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamh=
ash.c
index bb0935a3817c..6c142617f8cc 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -909,13 +909,14 @@ static int ahash_final_ctx(struct ahash_request *=
req)
 			  state->buflen_1;
 	u32 *sh_desc =3D ctx->sh_desc_fin, *desc;
 	dma_addr_t ptr =3D ctx->sh_desc_fin_dma;
-	int sec4_sg_bytes;
+	int sec4_sg_bytes, sec4_sg_src_index;
 	int digestsize =3D crypto_ahash_digestsize(ahash);
 	struct ahash_edesc *edesc;
 	int ret =3D 0;
 	int sh_len;
=20
-	sec4_sg_bytes =3D (1 + (buflen ? 1 : 0)) * sizeof(struct sec4_sg_entr=
y);
+	sec4_sg_src_index =3D 1 + (buflen ? 1 : 0);
+	sec4_sg_bytes =3D sec4_sg_src_index * sizeof(struct sec4_sg_entry);
=20
 	/* allocate space for base edesc and hw desc commands, link tables */
 	edesc =3D kzalloc(sizeof(*edesc) + DESC_JOB_IO_LEN + sec4_sg_bytes,
@@ -942,7 +943,7 @@ static int ahash_final_ctx(struct ahash_request *re=
q)
 	state->buf_dma =3D try_buf_map_to_sec4_sg(jrdev, edesc->sec4_sg + 1,
 						buf, state->buf_dma, buflen,
 						last_buflen);
-	(edesc->sec4_sg + sec4_sg_bytes - 1)->len |=3D SEC4_SG_LEN_FIN;
+	(edesc->sec4_sg + sec4_sg_src_index - 1)->len |=3D SEC4_SG_LEN_FIN;
=20
 	edesc->sec4_sg_dma =3D dma_map_single(jrdev, edesc->sec4_sg,
 					    sec4_sg_bytes, DMA_TO_DEVICE);
--=20
2.4.4
