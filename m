Return-Path: <SRS0=qsBZ=OA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-eopbgr810045.outbound.protection.outlook.com ([40.107.81.45]:27898
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726001AbeKUSKZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Nov 2018 13:10:25 -0500
From: "Nagadheeraj, Rottela" <Rottela.Nagadheeraj@cavium.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Srikanth, Jampala" <Jampala.Srikanth@cavium.com>,
        "Nagadheeraj, Rottela" <Rottela.Nagadheeraj@cavium.com>
Subject: [PATCH 1/1] crypto: cavium/nitrox - crypto request format changes
Date: Wed, 21 Nov 2018 07:36:58 +0000
Message-ID: <20181121073628.17039-1-rottela.nagadheeraj@cavium.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

nitrox_skcipher_crypt() will do the necessary formatting/ordering of
input and output sglists based on the algorithm requirements.
It will also accommodate the mandatory output buffers required for
NITROX hardware like Output request headers (ORH) and Completion headers.

Signed-off-by: Nagadheeraj Rottela <rottela.nagadheeraj@cavium.com>
Reviewed-by: Srikanth Jampala <Jampala.Srikanth@cavium.com>
---
 drivers/crypto/cavium/nitrox/nitrox_algs.c   | 111 ++++++++++-
 drivers/crypto/cavium/nitrox/nitrox_req.h    |  94 ++++++----
 drivers/crypto/cavium/nitrox/nitrox_reqmgr.c | 266 ++++++-----------------=
----
 3 files changed, 227 insertions(+), 244 deletions(-)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_algs.c b/drivers/crypto/ca=
vium/nitrox/nitrox_algs.c
index 5d54ebc20cb3..10075a97ff0d 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_algs.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_algs.c
@@ -155,13 +155,109 @@ static int nitrox_aes_setkey(struct crypto_skcipher =
*cipher, const u8 *key,
 	return nitrox_skcipher_setkey(cipher, aes_keylen, key, keylen);
 }
=20
+static int alloc_src_sglist(struct skcipher_request *skreq, int ivsize)
+{
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+	int nents =3D sg_nents(skreq->src) + 1;
+	struct se_crypto_request *creq =3D &nkreq->creq;
+	char *iv;
+	struct scatterlist *sg;
+
+	/* Allocate buffer to hold IV and input scatterlist array */
+	nkreq->src =3D alloc_req_buf(nents, ivsize, creq->gfp);
+	if (!nkreq->src)
+		return -ENOMEM;
+
+	/* copy iv */
+	iv =3D nkreq->src;
+	memcpy(iv, skreq->iv, ivsize);
+
+	sg =3D (struct scatterlist *)(iv + ivsize);
+	creq->src =3D sg;
+	sg_init_table(sg, nents);
+
+	/* Input format:
+	 * +----+----------------+
+	 * | IV | SRC sg entries |
+	 * +----+----------------+
+	 */
+
+	/* IV */
+	sg =3D create_single_sg(sg, iv, ivsize);
+	/* SRC entries */
+	create_multi_sg(sg, skreq->src);
+
+	return 0;
+}
+
+static int alloc_dst_sglist(struct skcipher_request *skreq, int ivsize)
+{
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+	int nents =3D sg_nents(skreq->dst) + 3;
+	int extralen =3D ORH_HLEN + COMP_HLEN;
+	struct se_crypto_request *creq =3D &nkreq->creq;
+	struct scatterlist *sg;
+	char *iv =3D nkreq->src;
+
+	/* Allocate buffer to hold ORH, COMPLETION and output scatterlist
+	 * array
+	 */
+	nkreq->dst =3D alloc_req_buf(nents, extralen, creq->gfp);
+	if (!nkreq->dst)
+		return -ENOMEM;
+
+	creq->orh =3D (u64 *)(nkreq->dst);
+	set_orh_value(creq->orh);
+
+	creq->comp =3D (u64 *)(nkreq->dst + ORH_HLEN);
+	set_comp_value(creq->comp);
+
+	sg =3D (struct scatterlist *)(nkreq->dst + ORH_HLEN + COMP_HLEN);
+	creq->dst =3D sg;
+	sg_init_table(sg, nents);
+
+	/* Output format:
+	 * +-----+----+----------------+-----------------+
+	 * | ORH | IV | DST sg entries | COMPLETION Bytes|
+	 * +-----+----+----------------+-----------------+
+	 */
+
+	/* ORH */
+	sg =3D create_single_sg(sg, creq->orh, ORH_HLEN);
+	/* IV */
+	sg =3D create_single_sg(sg, iv, ivsize);
+	/* DST entries */
+	sg =3D create_multi_sg(sg, skreq->dst);
+	/* COMPLETION Bytes */
+	create_single_sg(sg, creq->comp, COMP_HLEN);
+
+	return 0;
+}
+
+static void free_src_sglist(struct skcipher_request *skreq)
+{
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+
+	kfree(nkreq->src);
+}
+
+static void free_dst_sglist(struct skcipher_request *skreq)
+{
+	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
+
+	kfree(nkreq->dst);
+}
+
 static void nitrox_skcipher_callback(struct skcipher_request *skreq,
 				     int err)
 {
+	free_src_sglist(skreq);
+	free_dst_sglist(skreq);
 	if (err) {
 		pr_err_ratelimited("request failed status 0x%0x\n", err);
 		err =3D -EINVAL;
 	}
+
 	skcipher_request_complete(skreq, err);
 }
=20
@@ -172,6 +268,7 @@ static int nitrox_skcipher_crypt(struct skcipher_reques=
t *skreq, bool enc)
 	struct nitrox_kcrypt_request *nkreq =3D skcipher_request_ctx(skreq);
 	int ivsize =3D crypto_skcipher_ivsize(cipher);
 	struct se_crypto_request *creq;
+	int ret;
=20
 	creq =3D &nkreq->creq;
 	creq->flags =3D skreq->base.flags;
@@ -192,11 +289,15 @@ static int nitrox_skcipher_crypt(struct skcipher_requ=
est *skreq, bool enc)
 	creq->ctx_handle =3D nctx->u.ctx_handle;
 	creq->ctrl.s.ctxl =3D sizeof(struct flexi_crypto_context);
=20
-	/* copy the iv */
-	memcpy(creq->iv, skreq->iv, ivsize);
-	creq->ivsize =3D ivsize;
-	creq->src =3D skreq->src;
-	creq->dst =3D skreq->dst;
+	ret =3D alloc_src_sglist(skreq, ivsize);
+	if (ret)
+		return ret;
+
+	ret =3D alloc_dst_sglist(skreq, ivsize);
+	if (ret) {
+		free_src_sglist(skreq);
+		return ret;
+	}
=20
 	nkreq->nctx =3D nctx;
 	nkreq->skreq =3D skreq;
diff --git a/drivers/crypto/cavium/nitrox/nitrox_req.h b/drivers/crypto/cav=
ium/nitrox/nitrox_req.h
index 19f0a20e3bb3..d45ff91c19a9 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_req.h
+++ b/drivers/crypto/cavium/nitrox/nitrox_req.h
@@ -7,6 +7,8 @@
=20
 #include "nitrox_dev.h"
=20
+#define PENDING_SIG	0xFFFFFFFFFFFFFFFFUL
+
 /**
  * struct gphdr - General purpose Header
  * @param0: first parameter.
@@ -46,13 +48,6 @@ union se_req_ctrl {
 	} s;
 };
=20
-struct nitrox_sglist {
-	u16 len;
-	u16 raz0;
-	u32 raz1;
-	dma_addr_t dma;
-};
-
 #define MAX_IV_LEN 16
=20
 /**
@@ -62,8 +57,10 @@ struct nitrox_sglist {
  * @ctx_handle: Crypto context handle.
  * @gph: GP Header
  * @ctrl: Request Information.
- * @in: Input sglist
- * @out: Output sglist
+ * @orh: ORH address
+ * @comp: completion address
+ * @src: Input sglist
+ * @dst: Output sglist
  */
 struct se_crypto_request {
 	u8 opcode;
@@ -73,9 +70,8 @@ struct se_crypto_request {
=20
 	struct gphdr gph;
 	union se_req_ctrl ctrl;
-
-	u8 iv[MAX_IV_LEN];
-	u16 ivsize;
+	u64 *orh;
+	u64 *comp;
=20
 	struct scatterlist *src;
 	struct scatterlist *dst;
@@ -200,6 +196,8 @@ struct nitrox_kcrypt_request {
 	struct se_crypto_request creq;
 	struct nitrox_crypto_ctx *nctx;
 	struct skcipher_request *skreq;
+	u8 *src;
+	u8 *dst;
 };
=20
 /**
@@ -376,26 +374,19 @@ struct nitrox_sgcomp {
=20
 /*
  * strutct nitrox_sgtable - SG list information
- * @map_cnt: Number of buffers mapped
- * @nr_comp: Number of sglist components
+ * @sgmap_cnt: Number of buffers mapped
  * @total_bytes: Total bytes in sglist.
- * @len: Total sglist components length.
- * @dma: DMA address of sglist component.
- * @dir: DMA direction.
- * @buf: crypto request buffer.
- * @sglist: SG list of input/output buffers.
+ * @sgcomp_len: Total sglist components length.
+ * @sgcomp_dma: DMA address of sglist component.
+ * @sg: crypto request buffer.
  * @sgcomp: sglist component for NITROX.
  */
 struct nitrox_sgtable {
-	u8 map_bufs_cnt;
-	u8 nr_sgcomp;
+	u8 sgmap_cnt;
 	u16 total_bytes;
-	u32 len;
-	dma_addr_t dma;
-	enum dma_data_direction dir;
-
-	struct scatterlist *buf;
-	struct nitrox_sglist *sglist;
+	u32 sgcomp_len;
+	dma_addr_t sgcomp_dma;
+	struct scatterlist *sg;
 	struct nitrox_sgcomp *sgcomp;
 };
=20
@@ -405,10 +396,8 @@ struct nitrox_sgtable {
 #define COMP_HLEN	8
=20
 struct resp_hdr {
-	u64 orh;
-	dma_addr_t orh_dma;
-	u64 completion;
-	dma_addr_t completion_dma;
+	u64 *orh;
+	u64 *completion;
 };
=20
 typedef void (*completion_t)(struct skcipher_request *skreq, int err);
@@ -434,7 +423,6 @@ struct nitrox_softreq {
 	u32 flags;
 	gfp_t gfp;
 	atomic_t status;
-	bool inplace;
=20
 	struct nitrox_device *ndev;
 	struct nitrox_cmdq *cmdq;
@@ -450,4 +438,46 @@ struct nitrox_softreq {
 	struct skcipher_request *skreq;
 };
=20
+static inline void *alloc_req_buf(int nents, int extralen, gfp_t gfp)
+{
+	size_t size;
+
+	size =3D sizeof(struct scatterlist) * nents;
+	size +=3D extralen;
+
+	return kzalloc(size, gfp);
+}
+
+static inline struct scatterlist *create_single_sg(struct scatterlist *sg,
+						   void *buf, int buflen)
+{
+	sg_set_buf(sg, buf, buflen);
+	sg++;
+	return sg;
+}
+
+static inline struct scatterlist *create_multi_sg(struct scatterlist *to_s=
g,
+						  struct scatterlist *from_sg)
+{
+	struct scatterlist *sg;
+	int i;
+
+	for_each_sg(from_sg, sg, sg_nents(from_sg), i) {
+		sg_set_buf(to_sg, sg_virt(sg), sg->length);
+		to_sg++;
+	}
+
+	return to_sg;
+}
+
+static inline void set_orh_value(u64 *orh)
+{
+	WRITE_ONCE(*orh, PENDING_SIG);
+}
+
+static inline void set_comp_value(u64 *comp)
+{
+	WRITE_ONCE(*comp, PENDING_SIG);
+}
+
 #endif /* __NITROX_REQ_H */
diff --git a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c b/drivers/crypto/=
cavium/nitrox/nitrox_reqmgr.c
index 3987cd84c033..d566bb904ec2 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_reqmgr.c
@@ -13,7 +13,6 @@
 #define FDATA_SIZE 32
 /* Base destination port for the solicited requests */
 #define SOLICIT_BASE_DPORT 256
-#define PENDING_SIG	0xFFFFFFFFFFFFFFFFUL
=20
 #define REQ_NOT_POSTED 1
 #define REQ_BACKLOG    2
@@ -52,58 +51,26 @@ static inline int incr_index(int index, int count, int =
max)
 	return index;
 }
=20
-/**
- * dma_free_sglist - unmap and free the sg lists.
- * @ndev: N5 device
- * @sgtbl: SG table
- */
 static void softreq_unmap_sgbufs(struct nitrox_softreq *sr)
 {
 	struct nitrox_device *ndev =3D sr->ndev;
 	struct device *dev =3D DEV(ndev);
-	struct nitrox_sglist *sglist;
-
-	/* unmap in sgbuf */
-	sglist =3D sr->in.sglist;
-	if (!sglist)
-		goto out_unmap;
-
-	/* unmap iv */
-	dma_unmap_single(dev, sglist->dma, sglist->len, DMA_BIDIRECTIONAL);
-	/* unmpa src sglist */
-	dma_unmap_sg(dev, sr->in.buf, (sr->in.map_bufs_cnt - 1), sr->in.dir);
-	/* unamp gather component */
-	dma_unmap_single(dev, sr->in.dma, sr->in.len, DMA_TO_DEVICE);
-	kfree(sr->in.sglist);
+
+
+	dma_unmap_sg(dev, sr->in.sg, sr->in.sgmap_cnt, DMA_BIDIRECTIONAL);
+	dma_unmap_single(dev, sr->in.sgcomp_dma, sr->in.sgcomp_len,
+			 DMA_TO_DEVICE);
 	kfree(sr->in.sgcomp);
-	sr->in.sglist =3D NULL;
-	sr->in.buf =3D NULL;
-	sr->in.map_bufs_cnt =3D 0;
-
-out_unmap:
-	/* unmap out sgbuf */
-	sglist =3D sr->out.sglist;
-	if (!sglist)
-		return;
-
-	/* unmap orh */
-	dma_unmap_single(dev, sr->resp.orh_dma, ORH_HLEN, sr->out.dir);
-
-	/* unmap dst sglist */
-	if (!sr->inplace) {
-		dma_unmap_sg(dev, sr->out.buf, (sr->out.map_bufs_cnt - 3),
-			     sr->out.dir);
-	}
-	/* unmap completion */
-	dma_unmap_single(dev, sr->resp.completion_dma, COMP_HLEN, sr->out.dir);
+	sr->in.sg =3D NULL;
+	sr->in.sgmap_cnt =3D 0;
=20
-	/* unmap scatter component */
-	dma_unmap_single(dev, sr->out.dma, sr->out.len, DMA_TO_DEVICE);
-	kfree(sr->out.sglist);
+	dma_unmap_sg(dev, sr->out.sg, sr->out.sgmap_cnt,
+		     DMA_BIDIRECTIONAL);
+	dma_unmap_single(dev, sr->out.sgcomp_dma, sr->out.sgcomp_len,
+			 DMA_TO_DEVICE);
 	kfree(sr->out.sgcomp);
-	sr->out.sglist =3D NULL;
-	sr->out.buf =3D NULL;
-	sr->out.map_bufs_cnt =3D 0;
+	sr->out.sg =3D NULL;
+	sr->out.sgmap_cnt =3D 0;
 }
=20
 static void softreq_destroy(struct nitrox_softreq *sr)
@@ -116,7 +83,7 @@ static void softreq_destroy(struct nitrox_softreq *sr)
  * create_sg_component - create SG componets for N5 device.
  * @sr: Request structure
  * @sgtbl: SG table
- * @nr_comp: total number of components required
+ * @map_nents: number of dma mapped entries
  *
  * Component structure
  *
@@ -140,7 +107,7 @@ static int create_sg_component(struct nitrox_softreq *s=
r,
 {
 	struct nitrox_device *ndev =3D sr->ndev;
 	struct nitrox_sgcomp *sgcomp;
-	struct nitrox_sglist *sglist;
+	struct scatterlist *sg;
 	dma_addr_t dma;
 	size_t sz_comp;
 	int i, j, nr_sgcomp;
@@ -154,17 +121,15 @@ static int create_sg_component(struct nitrox_softreq =
*sr,
 		return -ENOMEM;
=20
 	sgtbl->sgcomp =3D sgcomp;
-	sgtbl->nr_sgcomp =3D nr_sgcomp;
=20
-	sglist =3D sgtbl->sglist;
+	sg =3D sgtbl->sg;
 	/* populate device sg component */
 	for (i =3D 0; i < nr_sgcomp; i++) {
-		for (j =3D 0; j < 4; j++) {
-			sgcomp->len[j] =3D cpu_to_be16(sglist->len);
-			sgcomp->dma[j] =3D cpu_to_be64(sglist->dma);
-			sglist++;
+		for (j =3D 0; j < 4 && sg; j++) {
+			sgcomp[i].len[j] =3D cpu_to_be16(sg_dma_len(sg));
+			sgcomp[i].dma[j] =3D cpu_to_be64(sg_dma_address(sg));
+			sg =3D sg_next(sg);
 		}
-		sgcomp++;
 	}
 	/* map the device sg component */
 	dma =3D dma_map_single(DEV(ndev), sgtbl->sgcomp, sz_comp, DMA_TO_DEVICE);
@@ -174,8 +139,8 @@ static int create_sg_component(struct nitrox_softreq *s=
r,
 		return -ENOMEM;
 	}
=20
-	sgtbl->dma =3D dma;
-	sgtbl->len =3D sz_comp;
+	sgtbl->sgcomp_dma =3D dma;
+	sgtbl->sgcomp_len =3D sz_comp;
=20
 	return 0;
 }
@@ -193,66 +158,27 @@ static int dma_map_inbufs(struct nitrox_softreq *sr,
 {
 	struct device *dev =3D DEV(sr->ndev);
 	struct scatterlist *sg =3D req->src;
-	struct nitrox_sglist *glist;
 	int i, nents, ret =3D 0;
-	dma_addr_t dma;
-	size_t sz;
=20
-	nents =3D sg_nents(req->src);
+	nents =3D dma_map_sg(dev, req->src, sg_nents(req->src),
+			   DMA_BIDIRECTIONAL);
+	if (!nents)
+		return -EINVAL;
=20
-	/* creater gather list IV and src entries */
-	sz =3D roundup((1 + nents), 4) * sizeof(*glist);
-	glist =3D kzalloc(sz, sr->gfp);
-	if (!glist)
-		return -ENOMEM;
-
-	sr->in.sglist =3D glist;
-	/* map IV */
-	dma =3D dma_map_single(dev, &req->iv, req->ivsize, DMA_BIDIRECTIONAL);
-	if (dma_mapping_error(dev, dma)) {
-		ret =3D -EINVAL;
-		goto iv_map_err;
-	}
-
-	sr->in.dir =3D (req->src =3D=3D req->dst) ? DMA_BIDIRECTIONAL : DMA_TO_DE=
VICE;
-	/* map src entries */
-	nents =3D dma_map_sg(dev, req->src, nents, sr->in.dir);
-	if (!nents) {
-		ret =3D -EINVAL;
-		goto src_map_err;
-	}
-	sr->in.buf =3D req->src;
-
-	/* store the mappings */
-	glist->len =3D req->ivsize;
-	glist->dma =3D dma;
-	glist++;
-	sr->in.total_bytes +=3D req->ivsize;
-
-	for_each_sg(req->src, sg, nents, i) {
-		glist->len =3D sg_dma_len(sg);
-		glist->dma =3D sg_dma_address(sg);
-		sr->in.total_bytes +=3D glist->len;
-		glist++;
-	}
-	/* roundup map count to align with entires in sg component */
-	sr->in.map_bufs_cnt =3D (1 + nents);
+	for_each_sg(req->src, sg, nents, i)
+		sr->in.total_bytes +=3D sg_dma_len(sg);
=20
-	/* create NITROX gather component */
-	ret =3D create_sg_component(sr, &sr->in, sr->in.map_bufs_cnt);
+	sr->in.sg =3D req->src;
+	sr->in.sgmap_cnt =3D nents;
+	ret =3D create_sg_component(sr, &sr->in, sr->in.sgmap_cnt);
 	if (ret)
 		goto incomp_err;
=20
 	return 0;
=20
 incomp_err:
-	dma_unmap_sg(dev, req->src, nents, sr->in.dir);
-	sr->in.map_bufs_cnt =3D 0;
-src_map_err:
-	dma_unmap_single(dev, dma, req->ivsize, DMA_BIDIRECTIONAL);
-iv_map_err:
-	kfree(sr->in.sglist);
-	sr->in.sglist =3D NULL;
+	dma_unmap_sg(dev, req->src, nents, DMA_BIDIRECTIONAL);
+	sr->in.sgmap_cnt =3D 0;
 	return ret;
 }
=20
@@ -260,104 +186,25 @@ static int dma_map_outbufs(struct nitrox_softreq *sr=
,
 			   struct se_crypto_request *req)
 {
 	struct device *dev =3D DEV(sr->ndev);
-	struct nitrox_sglist *glist =3D sr->in.sglist;
-	struct nitrox_sglist *slist;
-	struct scatterlist *sg;
-	int i, nents, map_bufs_cnt, ret =3D 0;
-	size_t sz;
+	int nents, ret =3D 0;
=20
-	nents =3D sg_nents(req->dst);
+	nents =3D dma_map_sg(dev, req->dst, sg_nents(req->dst),
+			   DMA_BIDIRECTIONAL);
+	if (!nents)
+		return -EINVAL;
=20
-	/* create scatter list ORH, IV, dst entries and Completion header */
-	sz =3D roundup((3 + nents), 4) * sizeof(*slist);
-	slist =3D kzalloc(sz, sr->gfp);
-	if (!slist)
-		return -ENOMEM;
-
-	sr->out.sglist =3D slist;
-	sr->out.dir =3D DMA_BIDIRECTIONAL;
-	/* map ORH */
-	sr->resp.orh_dma =3D dma_map_single(dev, &sr->resp.orh, ORH_HLEN,
-					  sr->out.dir);
-	if (dma_mapping_error(dev, sr->resp.orh_dma)) {
-		ret =3D -EINVAL;
-		goto orh_map_err;
-	}
-
-	/* map completion */
-	sr->resp.completion_dma =3D dma_map_single(dev, &sr->resp.completion,
-						 COMP_HLEN, sr->out.dir);
-	if (dma_mapping_error(dev, sr->resp.completion_dma)) {
-		ret =3D -EINVAL;
-		goto compl_map_err;
-	}
-
-	sr->inplace =3D (req->src =3D=3D req->dst) ? true : false;
-	/* out place */
-	if (!sr->inplace) {
-		nents =3D dma_map_sg(dev, req->dst, nents, sr->out.dir);
-		if (!nents) {
-			ret =3D -EINVAL;
-			goto dst_map_err;
-		}
-	}
-	sr->out.buf =3D req->dst;
-
-	/* store the mappings */
-	/* orh */
-	slist->len =3D ORH_HLEN;
-	slist->dma =3D sr->resp.orh_dma;
-	slist++;
-
-	/* copy the glist mappings */
-	if (sr->inplace) {
-		nents =3D sr->in.map_bufs_cnt - 1;
-		map_bufs_cnt =3D sr->in.map_bufs_cnt;
-		while (map_bufs_cnt--) {
-			slist->len =3D glist->len;
-			slist->dma =3D glist->dma;
-			slist++;
-			glist++;
-		}
-	} else {
-		/* copy iv mapping */
-		slist->len =3D glist->len;
-		slist->dma =3D glist->dma;
-		slist++;
-		/* copy remaining maps */
-		for_each_sg(req->dst, sg, nents, i) {
-			slist->len =3D sg_dma_len(sg);
-			slist->dma =3D sg_dma_address(sg);
-			slist++;
-		}
-	}
-
-	/* completion */
-	slist->len =3D COMP_HLEN;
-	slist->dma =3D sr->resp.completion_dma;
-
-	sr->out.map_bufs_cnt =3D (3 + nents);
-
-	ret =3D create_sg_component(sr, &sr->out, sr->out.map_bufs_cnt);
+	sr->out.sg =3D req->dst;
+	sr->out.sgmap_cnt =3D nents;
+	ret =3D create_sg_component(sr, &sr->out, sr->out.sgmap_cnt);
 	if (ret)
 		goto outcomp_map_err;
=20
 	return 0;
=20
 outcomp_map_err:
-	if (!sr->inplace)
-		dma_unmap_sg(dev, req->dst, nents, sr->out.dir);
-	sr->out.map_bufs_cnt =3D 0;
-	sr->out.buf =3D NULL;
-dst_map_err:
-	dma_unmap_single(dev, sr->resp.completion_dma, COMP_HLEN, sr->out.dir);
-	sr->resp.completion_dma =3D 0;
-compl_map_err:
-	dma_unmap_single(dev, sr->resp.orh_dma, ORH_HLEN, sr->out.dir);
-	sr->resp.orh_dma =3D 0;
-orh_map_err:
-	kfree(sr->out.sglist);
-	sr->out.sglist =3D NULL;
+	dma_unmap_sg(dev, req->dst, nents, DMA_BIDIRECTIONAL);
+	sr->out.sgmap_cnt =3D 0;
+	sr->out.sg =3D NULL;
 	return ret;
 }
=20
@@ -556,8 +403,8 @@ int nitrox_process_se_request(struct nitrox_device *nde=
v,
=20
 	atomic_set(&sr->status, REQ_NOT_POSTED);
=20
-	WRITE_ONCE(sr->resp.orh, PENDING_SIG);
-	WRITE_ONCE(sr->resp.completion, PENDING_SIG);
+	sr->resp.orh =3D req->orh;
+	sr->resp.completion =3D req->comp;
=20
 	ret =3D softreq_map_iobuf(sr, req);
 	if (ret) {
@@ -598,13 +445,13 @@ int nitrox_process_se_request(struct nitrox_device *n=
dev,
=20
 	/* fill the packet instruction */
 	/* word 0 */
-	sr->instr.dptr0 =3D cpu_to_be64(sr->in.dma);
+	sr->instr.dptr0 =3D cpu_to_be64(sr->in.sgcomp_dma);
=20
 	/* word 1 */
 	sr->instr.ih.value =3D 0;
 	sr->instr.ih.s.g =3D 1;
-	sr->instr.ih.s.gsz =3D sr->in.map_bufs_cnt;
-	sr->instr.ih.s.ssz =3D sr->out.map_bufs_cnt;
+	sr->instr.ih.s.gsz =3D sr->in.sgmap_cnt;
+	sr->instr.ih.s.ssz =3D sr->out.sgmap_cnt;
 	sr->instr.ih.s.fsz =3D FDATA_SIZE + sizeof(struct gphdr);
 	sr->instr.ih.s.tlen =3D sr->instr.ih.s.fsz + sr->in.total_bytes;
 	sr->instr.ih.value =3D cpu_to_be64(sr->instr.ih.value);
@@ -626,11 +473,11 @@ int nitrox_process_se_request(struct nitrox_device *n=
dev,
=20
 	/* word 4 */
 	sr->instr.slc.value[0] =3D 0;
-	sr->instr.slc.s.ssz =3D sr->out.map_bufs_cnt;
+	sr->instr.slc.s.ssz =3D sr->out.sgmap_cnt;
 	sr->instr.slc.value[0] =3D cpu_to_be64(sr->instr.slc.value[0]);
=20
 	/* word 5 */
-	sr->instr.slc.s.rptr =3D cpu_to_be64(sr->out.dma);
+	sr->instr.slc.s.rptr =3D cpu_to_be64(sr->out.sgcomp_dma);
=20
 	/*
 	 * No conversion for front data,
@@ -664,6 +511,11 @@ void backlog_qflush_work(struct work_struct *work)
 	post_backlog_cmds(cmdq);
 }
=20
+static bool sr_completed(struct nitrox_softreq *sr)
+{
+	return (READ_ONCE(*sr->resp.orh) !=3D READ_ONCE(*sr->resp.completion));
+}
+
 /**
  * process_request_list - process completed requests
  * @ndev: N5 device
@@ -691,13 +543,13 @@ static void process_response_list(struct nitrox_cmdq =
*cmdq)
 			break;
=20
 		/* check orh and completion bytes updates */
-		if (READ_ONCE(sr->resp.orh) =3D=3D READ_ONCE(sr->resp.completion)) {
+		if (!sr_completed(sr)) {
 			/* request not completed, check for timeout */
 			if (!cmd_timeout(sr->tstamp, ndev->timeout))
 				break;
 			dev_err_ratelimited(DEV(ndev),
 					    "Request timeout, orh 0x%016llx\n",
-					    READ_ONCE(sr->resp.orh));
+					    READ_ONCE(*sr->resp.orh));
 		}
 		atomic_dec(&cmdq->pending_count);
 		atomic64_inc(&ndev->stats.completed);
@@ -710,7 +562,7 @@ static void process_response_list(struct nitrox_cmdq *c=
mdq)
 		skreq =3D sr->skreq;
=20
 		/* ORH error code */
-		err =3D READ_ONCE(sr->resp.orh) & 0xff;
+		err =3D READ_ONCE(*sr->resp.orh) & 0xff;
 		softreq_destroy(sr);
=20
 		if (callback)
--=20
2.13.6
