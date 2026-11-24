Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.31
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795515584;
	b=p9Ve81iTU5DulIRCJqZ7GmGzRw2vdhYuWFiKjTpIUHSmofIowuw9iirJRZLCLnoHth1P
	 R8vlVrhjenHXxu2yCKjFzVlupq2txOFoNFW2OF0tW60muxzX/DV4NXp64viGh1d6mImSO
	 uMkGY+ob25A7JXYTytD+PeyfAeSQvYfVoftiNdPUQscba7MvzPTSZp4KwA3Tz+EpJOBMX
	 LPSx0PxZCtlNFz2LxBZiPf1NJiPaqXNlpbwF1gHB3tcBo2F4zX/CkYs46SrHW213gtrvH
	 hUpyZdSBRIcbfdGYTQp2kQpYA7EOAEiFgviJx2ghKpKPaHtZZbvZxrag6M5hKW12hSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795515584;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=MSiiqzjYsStKdL0yI/w6hAU+IWlaakRZaMTGNaLVLoE=;
	b=nRS6ZVY7gWpcJanaxqjq9mEjbe5zVlplyW/OBHDqu84C77FKOdZwbYcY9kn+NBgewBXK
	 ou4Xjpnif3DCuOi1wK9QVIfIdSN75et5eBu+bA1gfjo0gecakAR7sOJ4nmq3TfBuqWX5j
	 K1ISP0hR4/o1dybh0E09ieLGDDfVL8hzUUEmLCr7V9cNzCvODIgpxpbtsCn3fVaP4ZGsb
	 zQG3X0TpJV/S83OhkHn49u2kWHy98/OxTFgzR9yMtpsq8azpPrE2vFfab4WOczkUvRARb
	 wx0xoRN450xZ+dpbeDYfJFKZShBt8jDQzvJoV3VYZ45SHF6gfRDw4t51klLmNkE8grw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=DQ4aZVHx;
	arc=none smtp.remote-ip=79.135.106.31
Received: from mail-10631.protonmail.ch (mail-10631.protonmail.ch [79.135.106.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5A5606A331
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 10:19:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A5A5606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=DQ4aZVHx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795515580; x=1795774780;
	bh=MSiiqzjYsStKdL0yI/w6hAU+IWlaakRZaMTGNaLVLoE=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=DQ4aZVHxxKQj0exhLxUAXKDmx1EqPabvnNAGkYACWllJOL7gDK7+N4dPufYN1xZlZ
	 4ISFRX6hzVT/+euDgfIGBZkkEwvLrm/3Bc+vFlUPLqpTud8eFGh30TWvErB1IMwECg
	 pLxVmm6IlzP6ja7pCcfLCkGFtwUPgHWQrEGOPDS3kQQQGz9SP7fOCHJwGBQzg0o2ZR
	 hJwFpt3hKEcCqXvoUmal9TmnS/qTSDQ4wXfbCCF0clhVTVVWgi7QzCOSKB1AEidY81
	 +0TIAcNfQDR57XuO+VpSx17i95pSnPjfNXWPU87557R4MicpZUpELKVwmr8B8VksPm
	 AUxSSmKRcDlaA==
Date: Tue, 24 Nov 2026 10:19:31 +0000
To: Zhiqi Song <songzhiqi1@huawei.com>, Longfang Liu <liulongfang@huawei.com>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ryan Prinz <rc4d5a@protonmail.com>
Subject: [PATCH] crypto: hisilicon/hpre - fix ECDH compute_shared_secret dst_len requirement
Message-ID: <20261124101912.1718740-1-rc4d5a@protonmail.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: 93b1c5b9310d57c8a9b0670d0768977bda8535c8
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

hpre_ecdh_msg_request_set() requires req->dst_len to be at least
2 * ctx->key_sz, regardless of which operation is being performed.
The generic KPP convention only needs that much for
generate_public_key(); a shared secret is conventionally just the X
coordinate, ctx->key_sz bytes.

Both in-tree callers of the generic ecdh-nist-pNNN names provide
exactly that smaller buffer for compute_shared_secret():
net/bluetooth/ecdh_helper.c's compute_ecdh_secret() allocates
secret[32] for P-256, and drivers/char/tpm/tpm2-sessions.c's session
salt derivation does kpp_request_set_output(req, d, EC_PT_SZ). Both
calls fail with -EOVERFLOW on HPRE hardware before the peer's public
key is looked at.

Found by Sashiko's automated review of a related patch, as a
pre-existing issue that patch doesn't introduce.

Fixed by requiring only the curve's own coordinate size for
compute_shared_secret(), and using a bounce buffer for that case:
hpre_ecdh_dst_data_init() DMA-maps an internal 2 * key_sz buffer
instead of the caller's, and hpre_ecdh_hw_data_clr_all() copies the
X coordinate to the caller's destination. generate_public_key() is
unaffected; it still requires, and writes directly into, a
2 * key_sz-sized caller buffer. areq->dst_len is also now set to
whatever was written (curve_sz or 2 * key_sz) instead of reporting
2 * key_sz.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Signed-off-by: Ryan Prinz <rc4d5a@protonmail.com>
---
No HiSilicon HPRE hardware was available to reproduce this. Verified
by building the modified driver against an unmodified kernel tree,
confirming the module compiles and links cleanly with no new
warnings. Verified the sizing and offset arithmetic in a standalone
test across all three supported curves (P-192, P-256,
P-384): the new compute_shared_secret() minimum (curve_sz) and
unchanged generate_public_key() minimum (2 * key_sz) come out
distinct and correct for each, and every read/write offset used by
both the bounce-buffer copy-out and the existing direct-buffer
compaction stays inside its respective buffer.

AI Disclosure: An AI assistant was used to assist with the
analysis and testing. I have verified the vulnerability, the fix, and
the test results myself and take responsibility for this contribution,
per Documentation/process/coding-assistants.rst.

 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 70 +++++++++++++++++++++++--=
----
 1 file changed, 56 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/h=
isilicon/hpre/hpre_crypto.c
index 66a276786a7d..a3fec7c7549d 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1390,9 +1390,11 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ct=
x *ctx,
 =09=09=09=09      struct scatterlist *dst,
 =09=09=09=09      struct scatterlist *src)
 {
+=09unsigned int curve_sz =3D hpre_ecdh_get_curvesz(ctx->curve_id);
 =09struct device *dev =3D ctx->dev;
 =09struct hpre_sqe *sqe =3D &req->req;
 =09dma_addr_t dma;
+=09char *p;

 =09dma =3D le64_to_cpu(sqe->in);
 =09if (unlikely(dma_mapping_error(dev, dma)))
@@ -1405,8 +1407,24 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ct=
x *ctx,
 =09if (unlikely(dma_mapping_error(dev, dma)))
 =09=09return;

-=09if (dst)
+=09if (req->dst) {
+=09=09/*
+=09=09 * Bounce buffer for compute_shared_secret(): holds the
+=09=09 * hardware's full, hw-slot-padded X||Y output. Copy out
+=09=09 * just the tightly-packed X coordinate to the caller's
+=09=09 * own (possibly smaller) buffer.
+=09=09 */
+=09=09p =3D req->dst;
+=09=09if (dst)
+=09=09=09scatterwalk_map_and_copy(p + ctx->key_sz - curve_sz,
+=09=09=09=09=09=09 dst, 0, curve_sz, 1);
+=09=09dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
+=09} else if (dst) {
 =09=09dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
+=09=09p =3D sg_virt(dst);
+=09=09memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
+=09=09memmove(p + curve_sz, p + (ctx->key_sz << 1) - curve_sz, curve_sz);
+=09}
 }

 static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
@@ -1416,12 +1434,11 @@ static void hpre_ecdh_cb(struct hpre_ctx *ctx, void=
 *resp)
 =09struct hpre_asym_request *req =3D NULL;
 =09struct kpp_request *areq;
 =09u64 overtime_thrhld;
-=09char *p;
 =09int ret;

 =09ret =3D hpre_alg_res_post_hf(ctx, resp, (void **)&req);
 =09areq =3D req->areq.ecdh;
-=09areq->dst_len =3D ctx->key_sz << 1;
+=09areq->dst_len =3D req->dst ? curve_sz : ctx->key_sz << 1;

 =09overtime_thrhld =3D atomic64_read(&dfx[HPRE_OVERTIME_THRHLD].value);
 =09if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
@@ -1430,10 +1447,6 @@ static void hpre_ecdh_cb(struct hpre_ctx *ctx, void =
*resp)
 =09/* Do unmap before data processing */
 =09hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);

-=09p =3D sg_virt(areq->dst);
-=09memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
-=09memmove(p + curve_sz, p + areq->dst_len - curve_sz, curve_sz);
-
 =09kpp_request_complete(areq, ret);

 =09atomic64_inc(&dfx[HPRE_RECV_CNT].value);
@@ -1446,7 +1459,17 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx=
 *ctx,
 =09struct hpre_sqe *msg;
 =09void *tmp;

-=09if (req->dst_len < ctx->key_sz << 1) {
+=09if (req->src) {
+=09=09unsigned int curve_sz =3D hpre_ecdh_get_curvesz(ctx->curve_id);
+
+=09=09if (!curve_sz)
+=09=09=09return -EINVAL;
+
+=09=09if (req->dst_len < curve_sz) {
+=09=09=09req->dst_len =3D curve_sz;
+=09=09=09return -EOVERFLOW;
+=09=09}
+=09} else if (req->dst_len < ctx->key_sz << 1) {
 =09=09req->dst_len =3D ctx->key_sz << 1;
 =09=09return -EOVERFLOW;
 =09}
@@ -1503,12 +1526,15 @@ static int hpre_ecdh_src_data_init(struct hpre_asym=
_request *hpre_req,
 }

 static int hpre_ecdh_dst_data_init(struct hpre_asym_request *hpre_req,
-=09=09=09=09   struct scatterlist *data, unsigned int len)
+=09=09=09=09   struct scatterlist *data, unsigned int len,
+=09=09=09=09   bool is_shared_secret)
 {
+=09gfp_t gfp =3D hpre_req->flags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :=
 GFP_ATOMIC;
 =09struct hpre_sqe *msg =3D &hpre_req->req;
 =09struct hpre_ctx *ctx =3D hpre_req->ctx;
 =09struct device *dev =3D ctx->dev;
 =09dma_addr_t dma;
+=09void *ptr;

 =09if (unlikely(!data || !sg_is_last(data))) {
 =09=09dev_err(dev, "data is illegal!\n");
@@ -1516,10 +1542,26 @@ static int hpre_ecdh_dst_data_init(struct hpre_asym=
_request *hpre_req,
 =09}

 =09hpre_req->dst =3D NULL;
-=09dma =3D dma_map_single(dev, sg_virt(data), ctx->key_sz << 1, DMA_FROM_D=
EVICE);
-=09if (unlikely(dma_mapping_error(dev, dma))) {
-=09=09dev_err(dev, "dma map data err!\n");
-=09=09return -ENOMEM;
+
+=09/*
+=09 * compute_shared_secret() may be given a buffer sized for just
+=09 * the X coordinate, per the generic KPP convention, but the
+=09 * hardware always produces both X and Y. Use a bounce buffer so
+=09 * the output has somewhere safe to land; hpre_ecdh_hw_data_clr_all()
+=09 * copies out just X afterward.
+=09 */
+=09if (is_shared_secret) {
+=09=09ptr =3D dma_alloc_coherent(dev, ctx->key_sz << 1, &dma, gfp);
+=09=09if (unlikely(!ptr))
+=09=09=09return -ENOMEM;
+=09=09hpre_req->dst =3D ptr;
+=09} else {
+=09=09dma =3D dma_map_single(dev, sg_virt(data), ctx->key_sz << 1,
+=09=09=09=09     DMA_FROM_DEVICE);
+=09=09if (unlikely(dma_mapping_error(dev, dma))) {
+=09=09=09dev_err(dev, "dma map data err!\n");
+=09=09=09return -ENOMEM;
+=09=09}
 =09}

 =09msg->out =3D cpu_to_le64(dma);
@@ -1552,7 +1594,7 @@ static int hpre_ecdh_compute_value(struct kpp_request=
 *req)
 =09=09msg->in =3D cpu_to_le64(ctx->ecdh.dma_g);
 =09}

-=09ret =3D hpre_ecdh_dst_data_init(hpre_req, req->dst, req->dst_len);
+=09ret =3D hpre_ecdh_dst_data_init(hpre_req, req->dst, req->dst_len, !!req=
->src);
 =09if (unlikely(ret)) {
 =09=09dev_err(dev, "failed to init dst data, ret =3D %d!\n", ret);
 =09=09goto clear_all;
--
2.51.2

