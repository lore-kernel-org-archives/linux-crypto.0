From: Leonard Crestez <leonard.crestez@nxp.com>
Subject: [PATCH 2/3] crypto: mxs-dcp - Fix SHA null hashes and output length
Date: Tue, 2 Oct 2018 19:01:50 +0000
Message-ID: <7a39a214e7fbeb0d829f10b9e3655597f07900f5.1538505573.git.leonard.crestez@nxp.com>
References: <cover.1538505573.git.leonard.crestez@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: Horia Geanta <horia.geanta@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S . Miller " <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Radu Solea <radu.solea@nxp.com>
To: Marek Vasut <marek.vasut@gmail.com>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1538505573.git.leonard.crestez@nxp.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Radu Solea <radu.solea@nxp.com>

DCP writes at least 32 bytes in the output buffer instead of hash length
as documented. Add intermediate buffer to prevent write out of bounds.

When requested to produce null hashes DCP fails to produce valid output.
Add software workaround to bypass hardware and return valid output.

Signed-off-by: Radu Solea <radu.solea@nxp.com>
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
---
 drivers/crypto/mxs-dcp.c | 47 +++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index b7f41a6b65a5..3821cf971b5e 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -27,13 +27,28 @@
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
=20
 #define DCP_MAX_CHANS	4
 #define DCP_BUF_SZ	PAGE_SIZE
+#define DCP_SHA_PAY_SZ  64
=20
 #define DCP_ALIGNMENT	64
=20
+/*
+ * Null hashes to align with hw behavior on imx6sl and ull
+ * these are flipped for consistency with hw output
+ */
+const uint8_t sha1_null_hash[] =3D
+	"\x09\x07\xd8\xaf\x90\x18\x60\x95\xef\xbf"
+	"\x55\x32\x0d\x4b\x6b\x5e\xee\xa3\x39\xda";
+
+const uint8_t sha256_null_hash[] =3D
+	"\x55\xb8\x52\x78\x1b\x99\x95\xa4"
+	"\x4c\x93\x9b\x64\xe4\x41\xae\x27"
+	"\x24\xb9\x6f\x99\xc8\xf4\xfb\x9a"
+	"\x14\x1c\xfc\x98\x42\xc4\xb0\xe3";
+
 /* DCP DMA descriptor. */
 struct dcp_dma_desc {
 	uint32_t	next_cmd_addr;
 	uint32_t	control0;
 	uint32_t	control1;
@@ -47,10 +62,11 @@ struct dcp_dma_desc {
 /* Coherent aligned block for bounce buffering. */
 struct dcp_coherent_block {
 	uint8_t			aes_in_buf[DCP_BUF_SZ];
 	uint8_t			aes_out_buf[DCP_BUF_SZ];
 	uint8_t			sha_in_buf[DCP_BUF_SZ];
+	uint8_t			sha_out_buf[DCP_SHA_PAY_SZ];
=20
 	uint8_t			aes_key[2 * AES_KEYSIZE_128];
=20
 	struct dcp_dma_desc	desc[DCP_MAX_CHANS];
 };
@@ -518,12 +534,10 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	int ret;
=20
 	struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
 	struct dcp_async_ctx *actx =3D crypto_ahash_ctx(tfm);
 	struct dcp_sha_req_ctx *rctx =3D ahash_request_ctx(req);
-	struct hash_alg_common *halg =3D crypto_hash_alg_common(tfm);
-
 	struct dcp_dma_desc *desc =3D &sdcp->coh->desc[actx->chan];
=20
 	dma_addr_t digest_phys =3D 0;
 	dma_addr_t buf_phys =3D dma_map_single(sdcp->dev, sdcp->coh->sha_in_buf,
 					     DCP_BUF_SZ, DMA_TO_DEVICE);
@@ -541,24 +555,38 @@ static int mxs_dcp_run_sha(struct ahash_request *req)
 	desc->destination =3D 0;
 	desc->size =3D actx->fill;
 	desc->payload =3D 0;
 	desc->status =3D 0;
=20
+	/*
+	 * Align driver with hw behavior when generating null hashes
+	 */
+	if (rctx->init && rctx->fini && desc->size =3D=3D 0) {
+		struct hash_alg_common *halg =3D crypto_hash_alg_common(tfm);
+		const uint8_t *sha_buf =3D
+			(actx->alg =3D=3D MXS_DCP_CONTROL1_HASH_SELECT_SHA1) ?
+			sha1_null_hash : sha256_null_hash;
+		memcpy(sdcp->coh->sha_out_buf, sha_buf, halg->digestsize);
+		ret =3D 0;
+		goto done_run;
+	}
+
 	/* Set HASH_TERM bit for last transfer block. */
 	if (rctx->fini) {
-		digest_phys =3D dma_map_single(sdcp->dev, req->result,
-					     halg->digestsize, DMA_FROM_DEVICE);
+		digest_phys =3D dma_map_single(sdcp->dev, sdcp->coh->sha_out_buf,
+					     DCP_SHA_PAY_SZ, DMA_FROM_DEVICE);
 		desc->control0 |=3D MXS_DCP_CONTROL0_HASH_TERM;
 		desc->payload =3D digest_phys;
 	}
=20
 	ret =3D mxs_dcp_start_dma(actx);
=20
 	if (rctx->fini)
-		dma_unmap_single(sdcp->dev, digest_phys, halg->digestsize,
+		dma_unmap_single(sdcp->dev, digest_phys, DCP_SHA_PAY_SZ,
 				 DMA_FROM_DEVICE);
=20
+done_run:
 	dma_unmap_single(sdcp->dev, buf_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
=20
 	return ret;
 }
=20
@@ -572,10 +600,11 @@ static int dcp_sha_req_to_buf(struct crypto_async_req=
uest *arq)
 	struct dcp_sha_req_ctx *rctx =3D ahash_request_ctx(req);
 	struct hash_alg_common *halg =3D crypto_hash_alg_common(tfm);
 	const int nents =3D sg_nents(req->src);
=20
 	uint8_t *in_buf =3D sdcp->coh->sha_in_buf;
+	uint8_t *out_buf =3D sdcp->coh->sha_out_buf;
=20
 	uint8_t *src_buf;
=20
 	struct scatterlist *src;
=20
@@ -626,15 +655,13 @@ static int dcp_sha_req_to_buf(struct crypto_async_req=
uest *arq)
 		if (ret)
 			return ret;
=20
 		actx->fill =3D 0;
=20
-		/* For some reason, the result is flipped. */
-		for (i =3D 0; i < halg->digestsize / 2; i++) {
-			swap(req->result[i],
-			     req->result[halg->digestsize - i - 1]);
-		}
+		/* For some reason the result is flipped */
+		for (i =3D 0; i < halg->digestsize; i++)
+			req->result[i] =3D out_buf[halg->digestsize - i - 1];
 	}
=20
 	return 0;
 }
=20
--=20
2.17.1
