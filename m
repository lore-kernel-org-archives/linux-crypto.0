From: Leonard Crestez <leonard.crestez@nxp.com>
Subject: [PATCH 3/3] crypto: mxs-dcp - Fix AES issues
Date: Tue, 2 Oct 2018 19:01:52 +0000
Message-ID: <a032d88bf4cb620f4a2da17c92eb462eb436f7f7.1538505573.git.leonard.crestez@nxp.com>
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

The DCP driver does not obey cryptlen, when doing android CTS this
results in passing to hardware input stream lengths which are not
multiple of block size.

Add a check to prevent future erroneous stream lengths from reaching the
hardware and adjust the scatterlist walking code to obey cryptlen.

Also properly copy-out the IV for chaining.

Signed-off-by: Radu Solea <radu.solea@nxp.com>
Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Signed-off-by: Leonard Crestez <leonard.crestez@nxp.com>
---
 drivers/crypto/mxs-dcp.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
index 3821cf971b5e..203c682dda99 100644
--- a/drivers/crypto/mxs-dcp.c
+++ b/drivers/crypto/mxs-dcp.c
@@ -230,10 +230,16 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx=
,
 	dma_addr_t src_phys =3D dma_map_single(sdcp->dev, sdcp->coh->aes_in_buf,
 					     DCP_BUF_SZ, DMA_TO_DEVICE);
 	dma_addr_t dst_phys =3D dma_map_single(sdcp->dev, sdcp->coh->aes_out_buf,
 					     DCP_BUF_SZ, DMA_FROM_DEVICE);
=20
+	if (actx->fill % AES_BLOCK_SIZE) {
+		dev_err(sdcp->dev, "Invalid block size!\n");
+		ret =3D -EINVAL;
+		goto aes_done_run;
+	}
+
 	/* Fill in the DMA descriptor. */
 	desc->control0 =3D MXS_DCP_CONTROL0_DECR_SEMAPHORE |
 		    MXS_DCP_CONTROL0_INTERRUPT |
 		    MXS_DCP_CONTROL0_ENABLE_CIPHER;
=20
@@ -259,10 +265,11 @@ static int mxs_dcp_run_aes(struct dcp_async_ctx *actx=
,
 	desc->payload =3D key_phys;
 	desc->status =3D 0;
=20
 	ret =3D mxs_dcp_start_dma(actx);
=20
+aes_done_run:
 	dma_unmap_single(sdcp->dev, key_phys, 2 * AES_KEYSIZE_128,
 			 DMA_TO_DEVICE);
 	dma_unmap_single(sdcp->dev, src_phys, DCP_BUF_SZ, DMA_TO_DEVICE);
 	dma_unmap_single(sdcp->dev, dst_phys, DCP_BUF_SZ, DMA_FROM_DEVICE);
=20
@@ -285,17 +292,19 @@ static int mxs_dcp_aes_block_crypt(struct crypto_asyn=
c_request *arq)
 	uint8_t *in_buf =3D sdcp->coh->aes_in_buf;
 	uint8_t *out_buf =3D sdcp->coh->aes_out_buf;
=20
 	uint8_t *out_tmp, *src_buf, *dst_buf =3D NULL;
 	uint32_t dst_off =3D 0;
+	uint32_t last_out_len =3D 0;
=20
 	uint8_t *key =3D sdcp->coh->aes_key;
=20
 	int ret =3D 0;
 	int split =3D 0;
-	unsigned int i, len, clen, rem =3D 0;
+	unsigned int i, len, clen, rem =3D 0, tlen =3D 0;
 	int init =3D 0;
+	bool limit_hit =3D false;
=20
 	actx->fill =3D 0;
=20
 	/* Copy the key from the temporary location. */
 	memcpy(key, actx->key, actx->key_len);
@@ -310,10 +319,15 @@ static int mxs_dcp_aes_block_crypt(struct crypto_asyn=
c_request *arq)
 	}
=20
 	for_each_sg(req->src, src, nents, i) {
 		src_buf =3D sg_virt(src);
 		len =3D sg_dma_len(src);
+		tlen +=3D len;
+		limit_hit =3D tlen > req->nbytes;
+
+		if (limit_hit)
+			len =3D req->nbytes - (tlen - len);
=20
 		do {
 			if (actx->fill + len > out_off)
 				clen =3D out_off - actx->fill;
 			else
@@ -326,17 +340,19 @@ static int mxs_dcp_aes_block_crypt(struct crypto_asyn=
c_request *arq)
=20
 			/*
 			 * If we filled the buffer or this is the last SG,
 			 * submit the buffer.
 			 */
-			if (actx->fill =3D=3D out_off || sg_is_last(src)) {
+			if (actx->fill =3D=3D out_off || sg_is_last(src) ||
+				limit_hit) {
 				ret =3D mxs_dcp_run_aes(actx, req, init);
 				if (ret)
 					return ret;
 				init =3D 0;
=20
 				out_tmp =3D out_buf;
+				last_out_len =3D actx->fill;
 				while (dst && actx->fill) {
 					if (!split) {
 						dst_buf =3D sg_virt(dst);
 						dst_off =3D 0;
 					}
@@ -355,10 +371,23 @@ static int mxs_dcp_aes_block_crypt(struct crypto_asyn=
c_request *arq)
 						split =3D 1;
 					}
 				}
 			}
 		} while (len);
+
+		if (limit_hit)
+			break;
+	}
+
+	/* Copy the IV for CBC for chaining */
+	if (!rctx->ecb) {
+		if (rctx->enc)
+			memcpy(req->info, out_buf+(last_out_len-AES_BLOCK_SIZE),
+				AES_BLOCK_SIZE);
+		else
+			memcpy(req->info, in_buf+(last_out_len-AES_BLOCK_SIZE),
+				AES_BLOCK_SIZE);
 	}
=20
 	return ret;
 }
=20
--=20
2.17.1
