Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.70.43.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525300;
	b=YWxxCYt5Dn0mPD3FUeRGUbNKXE1phD9xPoYxXFP1mOSl4GnyspY9csmbsB1Flijz5VEA
	 SGg1aFyg6/HP1jNHUhiKfTqS5wfUbsBfVxMCTfesLDfBaD1OSTkODopvpequOvUARwlbl
	 ZFdV8olClo+F0YuoOf1kJ7cJEItU1FwvgGH+htEqoYpSK6ZlBhtUGEdlGAeVT9SkXME/2
	 odVzI+Tsy5rWp9tTZcWK4fl7K9hlEgyHeZLUKxP0LDIkR48MRj5V7zkCadK+nVQt2FbYo
	 S4vz+cPgg6ai6A3ZNkoe8w+6UJndVTmsmmDE42KSgJlFh9waZGQeHCFJ6CHrfMK/ghg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525300;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=0rcBsFLxdGApB+kuMVUpvU0iG7zihiKLY19DdfLzKbU=;
	b=xJdVRu5BXWsSSSWlNgd37I+TOdsu3IA30ZqMW+66fyEpX2Xp3GdLA2yZsvTfzO8ZXDR7
	 3FQS46f659N2ICqjVMH5GVxOXMGEd5yi8sDvb8dcugCIabZhDUmUdgMjGp7CBZgugWFNR
	 5bmau2TexSjgDLsZxruplEgYva51kAreNCjmKN84/9wbpop42otKGf8oFrP79vpm7sdvV
	 0thBMwExf4XOteoA8LKQ6q8hJwCBjDIKi02USI43TcVk5yGLfkoQnnzgExPW/5PeQGAQj
	 v63cPDmq0Zy6SHCnjcoG75bNStXmedl5hLwPdY05BbFvjL2WeOHnxKQGB+UaRZu4vbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=protonmail.com;
	spf=pass smtp.mailfrom=protonmail.com;
	dkim=pass header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=j0v9JSGX;
	arc=none smtp.remote-ip=185.70.43.16
Received: from mail-4316.protonmail.ch (mail-4316.protonmail.ch [185.70.43.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09925606A31E;
	Tue, 24 Nov 2026 13:01:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09925606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=protonmail.com header.i=@protonmail.com header.a=rsa-sha256 header.s=protonmail3 header.b=j0v9JSGX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1795525296; x=1795784496;
	bh=0rcBsFLxdGApB+kuMVUpvU0iG7zihiKLY19DdfLzKbU=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=j0v9JSGXlaiWgQp0mn3z4oGsy4OJgA0a5/zavLXE3sy+K/kVMzt5IECqB2obYmw2d
	 kxyEuc+wJbKUtqQC8OzMRemLLxuBtOV+TGk1Z1SP7rgc9/5PCRiLKDADvmI+OQFzsp
	 LbwRXmkFHYOqXOAenxc2Y6TAHWlP1IcZ8ifmXYdREUBSxqNYXC2RaFb+NlUIUy0SMF
	 2eO+8WfCf6S9AU61MfDCV80EUCtFmV1NGTm5BqdgW2KrwoFsdnCiqp8UN5Q5JYT1eU
	 k6o9Ws6RV9zxQMbOej8z1d8A78/I4rRQxZ0Cs1/82TkODw4LzImAgVOFvBw608f7p1
	 rrjw8Z4sK3CBQ==
Date: Tue, 24 Nov 2026 13:01:27 +0000
To: Zhiqi Song <songzhiqi1@huawei.com>, Longfang Liu <liulongfang@huawei.com>
From: Ryan Prinz <rc4d5a@protonmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, Ryan Prinz <rc4d5a@protonmail.com>
Subject: [PATCH v2] crypto: hisilicon/hpre - fix ECDH compute_shared_secret dst_len requirement
Message-ID: <20261124130105.1735019-1-rc4d5a@protonmail.com>
Feedback-ID: 190731814:user:proton
X-Pm-Message-ID: 7ed7a1181463cefcc9ed7bc7cc69b3b0f1d0e1bd
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

Both in-tree callers of the generic ecdh-nist-pNNN names call
compute_shared_secret() with a buffer sized for just the X
coordinate: net/bluetooth/ecdh_helper.c's compute_ecdh_secret()
allocates secret[32] for P-256, and drivers/char/tpm/tpm2-sessions.c's
session salt derivation does kpp_request_set_output(req, d, EC_PT_SZ).

Bluetooth reaches this unconditionally and fails with -EOVERFLOW on
HPRE hardware before the peer's public key is looked at. TPM2's
session code would hit the same failure, but on HPRE hardware it
never gets that far: the same session's earlier generate_public_key()
call uses a 2-entry destination scatterlist for its own public key,
which hpre_ecdh_dst_data_init()'s existing sg_is_last() check
rejects, for a reason unrelated to this patch.

Found by Sashiko's automated review of a related patch, as a
pre-existing issue that patch doesn't introduce.

Fixed by requiring the curve's own coordinate size for
compute_shared_secret(), and using a bounce buffer for that case:
hpre_ecdh_dst_data_init() DMA-maps an internal 2 * key_sz buffer
instead of the caller's, and hpre_ecdh_hw_data_clr_all() copies the
X coordinate to the caller's destination. generate_public_key() is
unaffected; it still requires, and writes directly into, a
2 * key_sz-sized caller buffer. areq->dst_len is also now set to
what was written (curve_sz or 2 * curve_sz) instead of reporting
2 * key_sz.

Fixes: 05e7b906aa7c ("crypto: hisilicon/hpre - add 'ECDH' algorithm")
Signed-off-by: Ryan Prinz <rc4d5a@protonmail.com>
---
v2:
 - Fixed a bug Sashiko's automated review found: moving the dst
   compaction/copy-out into hpre_ecdh_hw_data_clr_all() made it run
   from the clear_all error path too, where hpre_send() failed
   before reaching hardware. That path now only frees/unmaps;
   a new copy_out argument, true only from the real completion
   callback, gates the data-touching steps.
 - Fixed a second bug Sashiko's review found: areq->dst_len for
   generate_public_key() still reported ctx->key_sz << 1, which is
   wrong for P-192, where ctx->key_sz is the 32-byte P-256 hardware
   slot width but the compaction only produces 2 * curve_sz =3D 48
   valid bytes. Both branches are now curve_sz-based.

No HiSilicon HPRE hardware was available to reproduce this. Verified
by building the modified driver against an unmodified kernel tree,
confirming the module compiles and links cleanly with no new
warnings. Verified the first fix above by enumerating every path
that reaches the clear_all label and confirming copy_out is false
for all of them, while remaining true only on the hardware-completion
callback path. Verified the sizing and offset arithmetic in a standalone
test across all three supported curves (P-192, P-256, P-384): the
compute_shared_secret() minimum (curve_sz) and generate_public_key()
minimum (2 * key_sz) come out distinct and correct; every
read/write offset used by both the bounce-buffer copy-out and the
direct-buffer compaction stays inside its respective buffer; and
the corrected generate_public_key() dst_len now matches the
number of valid bytes the compaction produces for all three curves
(48/64/96), rather than always reporting key_sz << 1 (64/64/96,
wrong for P-192).

AI Disclosure: An AI assistant was used to assist with the
analysis and testing. I have verified the vulnerability, the fix, and
the test results myself and take responsibility for this contribution,
per Documentation/process/coding-assistants.rst.

 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 82 +++++++++++++++++++++++--=
----
 1 file changed, 65 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_crypto.c b/drivers/crypto/h=
isilicon/hpre/hpre_crypto.c
index 66a276786a7d..74f59c0f80ff 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_crypto.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_crypto.c
@@ -1388,11 +1388,14 @@ static int hpre_ecdh_set_secret(struct crypto_kpp *=
tfm, const void *buf,
 static void hpre_ecdh_hw_data_clr_all(struct hpre_ctx *ctx,
 =09=09=09=09      struct hpre_asym_request *req,
 =09=09=09=09      struct scatterlist *dst,
-=09=09=09=09      struct scatterlist *src)
+=09=09=09=09      struct scatterlist *src,
+=09=09=09=09      bool copy_out)
 {
+=09unsigned int curve_sz =3D hpre_ecdh_get_curvesz(ctx->curve_id);
 =09struct device *dev =3D ctx->dev;
 =09struct hpre_sqe *sqe =3D &req->req;
 =09dma_addr_t dma;
+=09char *p;

 =09dma =3D le64_to_cpu(sqe->in);
 =09if (unlikely(dma_mapping_error(dev, dma)))
@@ -1405,8 +1408,29 @@ static void hpre_ecdh_hw_data_clr_all(struct hpre_ct=
x *ctx,
 =09if (unlikely(dma_mapping_error(dev, dma)))
 =09=09return;

-=09if (dst)
+=09if (req->dst) {
+=09=09/*
+=09=09 * Bounce buffer for compute_shared_secret(): holds the
+=09=09 * hardware's full, hw-slot-padded X||Y output. copy_out is
+=09=09 * false when this is cleanup after a failure that never
+=09=09 * reached hardware, in which case there is nothing valid
+=09=09 * to extract. Otherwise, copy out just the tightly-packed
+=09=09 * X coordinate to the caller's own (possibly smaller)
+=09=09 * buffer.
+=09=09 */
+=09=09p =3D req->dst;
+=09=09if (copy_out && dst)
+=09=09=09scatterwalk_map_and_copy(p + ctx->key_sz - curve_sz,
+=09=09=09=09=09=09 dst, 0, curve_sz, 1);
+=09=09dma_free_coherent(dev, ctx->key_sz << 1, req->dst, dma);
+=09} else if (dst) {
 =09=09dma_unmap_single(dev, dma, ctx->key_sz << 1, DMA_FROM_DEVICE);
+=09=09if (copy_out) {
+=09=09=09p =3D sg_virt(dst);
+=09=09=09memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
+=09=09=09memmove(p + curve_sz, p + (ctx->key_sz << 1) - curve_sz, curve_sz=
);
+=09=09}
+=09}
 }

 static void hpre_ecdh_cb(struct hpre_ctx *ctx, void *resp)
@@ -1416,23 +1440,18 @@ static void hpre_ecdh_cb(struct hpre_ctx *ctx, void=
 *resp)
 =09struct hpre_asym_request *req =3D NULL;
 =09struct kpp_request *areq;
 =09u64 overtime_thrhld;
-=09char *p;
 =09int ret;

 =09ret =3D hpre_alg_res_post_hf(ctx, resp, (void **)&req);
 =09areq =3D req->areq.ecdh;
-=09areq->dst_len =3D ctx->key_sz << 1;
+=09areq->dst_len =3D req->dst ? curve_sz : curve_sz << 1;

 =09overtime_thrhld =3D atomic64_read(&dfx[HPRE_OVERTIME_THRHLD].value);
 =09if (overtime_thrhld && hpre_is_bd_timeout(req, overtime_thrhld))
 =09=09atomic64_inc(&dfx[HPRE_OVER_THRHLD_CNT].value);

 =09/* Do unmap before data processing */
-=09hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src);
-
-=09p =3D sg_virt(areq->dst);
-=09memmove(p, p + ctx->key_sz - curve_sz, curve_sz);
-=09memmove(p + curve_sz, p + areq->dst_len - curve_sz, curve_sz);
+=09hpre_ecdh_hw_data_clr_all(ctx, req, areq->dst, areq->src, true);

 =09kpp_request_complete(areq, ret);

@@ -1446,7 +1465,17 @@ static int hpre_ecdh_msg_request_set(struct hpre_ctx=
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
@@ -1503,12 +1532,15 @@ static int hpre_ecdh_src_data_init(struct hpre_asym=
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
@@ -1516,10 +1548,26 @@ static int hpre_ecdh_dst_data_init(struct hpre_asym=
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
@@ -1566,7 +1608,7 @@ static int hpre_ecdh_compute_value(struct kpp_request=
 *req)
 =09=09return -EINPROGRESS;

 clear_all:
-=09hpre_ecdh_hw_data_clr_all(ctx, hpre_req, req->dst, req->src);
+=09hpre_ecdh_hw_data_clr_all(ctx, hpre_req, req->dst, req->src, false);
 =09return ret;
 }

--
2.51.2

