Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14D550B8BA
	for <linux-crypto@vger.kernel.org>; Tue, 13 Oct 2026 13:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791897150; cv=none; b=Pj5dEYpOyUnygudRuW+vPPDEmN6UVuxf99QfuBHgFWRfOsPc/QmrMlIdLMBycuxHqtNTt/CVeKyghAVEucAWPOSrinm6WQPfs4+h3G+AsJFKoR65GTTE8//tDyq6t6Add2ygT04IrRBlc/T7BezbNgNsi/cJIAybA2D8zStRfq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791897150; c=relaxed/simple;
	bh=VxQDZPxxEU2a+Zx0RMvo6Iuh1WceLIfwv/nz6PZUfrw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dBriR8PkCpohZ7pwGFEK8lStW+zjlYr6AAxFYOx9A37MNxePaJqQBLWAAoSQkLSCjwT8iz9zhxsb0RyRoow0vx+twZYnrKO8/1oG8qYwAH0dLJfrTdFIYQsySGYiLV8d2AZpOsIuTkfBjZLpx+3Xh4wN4kD5T5tICBKvvoFeAA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=aVt9Ao4S; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="aVt9Ao4S"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id 46D6A1A1215;
	Tue, 13 Oct 2026 13:12:25 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 14C8060362;
	Tue, 13 Oct 2026 13:12:25 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 0D55F11D713A0;
	Tue, 13 Oct 2026 15:12:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1791897143; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=EnFm4YxrPX7OvNRYSIjnyPix+LrvUZjFGpB8INMh8hI=;
	b=aVt9Ao4SHJkJB+v01Wx4XUTCTJKTS1YJKumeSr2zdA5nJiMyliMk8scUMhUtsovpvM8c+j
	L4AUF0T3AovAxTlHKFbsyNSgh0JX8MRhmvtNWii82bpNZgiMzoT5JFubgJEVQVL3EnBY6o
	Btxsprz7oNf/e2KprFpdmOGU5cmNta58S5ZD8U70akNUxYluPSNwPdla6Z0DZhKq1g4QN1
	J6TKL32TxWIali/+ImFYR1Jjznc9UobkRaolVgaO/dH7gtzdxUWPHcYDlWAZz96FvLSkzf
	bSYw9DsGl6d/Ay2ogNhR7MOW3uvoVGU6nljkCvDQLjlmki9O4ZjBLxVCxmPLVQ==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 13 Oct 2026 15:11:34 +0200
Subject: [PATCH v8 08/20] crypto: talitos/aead - Move into separate file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-7-3-rc2_talitos_cleanup-v8-8-ca02be17696b@bootlin.com>
References: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
In-Reply-To: <20261013-7-3-rc2_talitos_cleanup-v8-0-ca02be17696b@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791897108; l=63564;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=VxQDZPxxEU2a+Zx0RMvo6Iuh1WceLIfwv/nz6PZUfrw=;
 b=/EqLOAm9ZOgO/PSXQnuD4lfuuce9yP2oMWoam+PIhJ36X0rdeQ+JDk+buJ7u272Khhn8wlTkF
 A+YjskqilKSAYJ8uD0o4gEN7k9y2efi/8dVaYsCIgdJCMfHC6fbt101
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Move the AEAD algorithm implementations from talitos.c into
a dedicated talitos-aead.c file.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/Makefile       |   2 +-
 drivers/crypto/talitos/talitos-aead.c | 900 ++++++++++++++++++++++++++++++++
 drivers/crypto/talitos/talitos-core.c | 947 +---------------------------------
 drivers/crypto/talitos/talitos.h      |   3 +
 4 files changed, 913 insertions(+), 939 deletions(-)

diff --git a/drivers/crypto/talitos/Makefile b/drivers/crypto/talitos/Makefile
index 3319cdbce7e9..a85228cda189 100644
--- a/drivers/crypto/talitos/Makefile
+++ b/drivers/crypto/talitos/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
 
-talitos-y += talitos-core.o talitos-rng.o talitos-hash.o talitos-skcipher.o
+talitos-y += talitos-core.o talitos-rng.o talitos-hash.o talitos-skcipher.o talitos-aead.o
diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
new file mode 100644
index 000000000000..0236f152743b
--- /dev/null
+++ b/drivers/crypto/talitos/talitos-aead.c
@@ -0,0 +1,900 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <crypto/authenc.h>
+#include <crypto/internal/des.h>
+#include <crypto/internal/aead.h>
+#include <crypto/md5.h>
+#include <crypto/sha1.h>
+#include <crypto/sha2.h>
+
+#include "talitos.h"
+
+/*
+ * Defines a priority for doing AEAD with descriptors type
+ * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
+ */
+#define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
+
+static int aead_setkey(struct crypto_aead *authenc,
+		       const u8 *key, unsigned int keylen)
+{
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct device *dev = ctx->dev;
+	struct crypto_authenc_keys keys;
+
+	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
+		goto badkey;
+
+	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
+		goto badkey;
+
+	if (ctx->keylen)
+		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
+
+	memcpy(ctx->key, keys.authkey, keys.authkeylen);
+	memcpy(&ctx->key[keys.authkeylen], keys.enckey, keys.enckeylen);
+
+	ctx->keylen = keys.authkeylen + keys.enckeylen;
+	ctx->enckeylen = keys.enckeylen;
+	ctx->authkeylen = keys.authkeylen;
+	ctx->dma_key = dma_map_single(dev, ctx->key, ctx->keylen,
+				      DMA_TO_DEVICE);
+
+	memzero_explicit(&keys, sizeof(keys));
+	return 0;
+
+badkey:
+	memzero_explicit(&keys, sizeof(keys));
+	return -EINVAL;
+}
+
+static int aead_des3_setkey(struct crypto_aead *authenc,
+			    const u8 *key, unsigned int keylen)
+{
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct device *dev = ctx->dev;
+	struct crypto_authenc_keys keys;
+	int err;
+
+	err = crypto_authenc_extractkeys(&keys, key, keylen);
+	if (unlikely(err))
+		goto out;
+
+	err = -EINVAL;
+	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
+		goto out;
+
+	err = verify_aead_des3_key(authenc, keys.enckey, keys.enckeylen);
+	if (err)
+		goto out;
+
+	if (ctx->keylen)
+		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
+
+	memcpy(ctx->key, keys.authkey, keys.authkeylen);
+	memcpy(&ctx->key[keys.authkeylen], keys.enckey, keys.enckeylen);
+
+	ctx->keylen = keys.authkeylen + keys.enckeylen;
+	ctx->enckeylen = keys.enckeylen;
+	ctx->authkeylen = keys.authkeylen;
+	ctx->dma_key = dma_map_single(dev, ctx->key, ctx->keylen,
+				      DMA_TO_DEVICE);
+
+out:
+	memzero_explicit(&keys, sizeof(keys));
+	return err;
+}
+
+static void ipsec_esp_unmap(struct device *dev,
+			    struct talitos_edesc *edesc,
+			    struct aead_request *areq, bool encrypt)
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
+	unsigned int ivsize = crypto_aead_ivsize(aead);
+	unsigned int authsize = crypto_aead_authsize(aead);
+	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
+	bool is_ipsec_esp = edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP;
+	struct talitos_ptr *civ_ptr = &edesc->desc.ptr[is_ipsec_esp ? 2 : 3];
+
+	if (is_ipsec_esp)
+		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6],
+					 DMA_FROM_DEVICE);
+	unmap_single_talitos_ptr(dev, civ_ptr, DMA_TO_DEVICE);
+
+	talitos_sg_unmap(dev, edesc, areq->src, areq->dst,
+			 cryptlen + authsize, areq->assoclen);
+
+	if (edesc->dma_len)
+		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
+				 DMA_BIDIRECTIONAL);
+
+	if (!is_ipsec_esp) {
+		unsigned int dst_nents = edesc->dst_nents ? : 1;
+
+		sg_pcopy_to_buffer(areq->dst, dst_nents, ctx->iv, ivsize,
+				   areq->assoclen + cryptlen - ivsize);
+	}
+}
+
+/*
+ * ipsec_esp descriptor callbacks
+ */
+static void ipsec_esp_encrypt_done(struct device *dev,
+				   struct talitos_desc *desc, void *context,
+				   int err)
+{
+	struct aead_request *areq = context;
+	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
+	unsigned int ivsize = crypto_aead_ivsize(authenc);
+	struct talitos_edesc *edesc;
+
+	edesc = container_of(desc, struct talitos_edesc, desc);
+
+	ipsec_esp_unmap(dev, edesc, areq, true);
+
+	dma_unmap_single(dev, edesc->iv_dma, ivsize, DMA_TO_DEVICE);
+
+	kfree(edesc);
+
+	aead_request_complete(areq, err);
+}
+
+static void ipsec_esp_decrypt_swauth_done(struct device *dev,
+					  struct talitos_desc *desc,
+					  void *context, int err)
+{
+	struct aead_request *req = context;
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	unsigned int authsize = crypto_aead_authsize(authenc);
+	struct talitos_edesc *edesc;
+	char *oicv, *icv;
+
+	edesc = container_of(desc, struct talitos_edesc, desc);
+
+	ipsec_esp_unmap(dev, edesc, req, false);
+
+	if (!err) {
+		/* auth check */
+		oicv = edesc->buf + edesc->dma_len;
+		icv = oicv - authsize;
+
+		err = crypto_memneq(oicv, icv, authsize) ? -EBADMSG : 0;
+	}
+
+	kfree(edesc);
+
+	aead_request_complete(req, err);
+}
+
+static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
+					  struct talitos_desc *desc,
+					  void *context, int err)
+{
+	struct aead_request *req = context;
+	struct talitos_edesc *edesc;
+
+	edesc = container_of(desc, struct talitos_edesc, desc);
+
+	ipsec_esp_unmap(dev, edesc, req, false);
+
+	/* check ICV auth status */
+	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
+		     DESC_HDR_LO_ICCR1_PASS))
+		err = -EBADMSG;
+
+	kfree(edesc);
+
+	aead_request_complete(req, err);
+}
+
+/*
+ * fill in and submit ipsec_esp descriptor
+ */
+static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
+		     bool encrypt,
+		     void (*callback)(struct device *dev,
+				      struct talitos_desc *desc,
+				      void *context, int error))
+{
+	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
+	unsigned int authsize = crypto_aead_authsize(aead);
+	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
+	struct device *dev = ctx->dev;
+	struct talitos_desc *desc = &edesc->desc;
+	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
+	unsigned int ivsize = crypto_aead_ivsize(aead);
+	int tbl_off = 0;
+	int sg_count, ret;
+	int elen = 0;
+	bool sync_needed = false;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+	bool is_ipsec_esp = desc->hdr & DESC_HDR_TYPE_IPSEC_ESP;
+	struct talitos_ptr *civ_ptr = &desc->ptr[is_ipsec_esp ? 2 : 3];
+	struct talitos_ptr *ckey_ptr = &desc->ptr[is_ipsec_esp ? 3 : 2];
+	dma_addr_t dma_icv = edesc->dma_link_tbl + edesc->dma_len - authsize;
+
+	/* hmac key */
+	to_talitos_ptr(&desc->ptr[0], ctx->dma_key, ctx->authkeylen, is_sec1);
+
+	sg_count = edesc->src_nents ?: 1;
+	if (is_sec1 && sg_count > 1)
+		sg_copy_to_buffer(areq->src, sg_count, edesc->buf,
+				  areq->assoclen + cryptlen);
+	else
+		sg_count = dma_map_sg(dev, areq->src, sg_count,
+				      (areq->src == areq->dst) ?
+				      DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+
+	/* hmac data */
+	ret = talitos_sg_map(dev, areq->src, areq->assoclen, edesc,
+			     &desc->ptr[1], sg_count, 0, tbl_off);
+
+	if (ret > 1) {
+		tbl_off += ret;
+		sync_needed = true;
+	}
+
+	/* cipher iv */
+	to_talitos_ptr(civ_ptr, edesc->iv_dma, ivsize, is_sec1);
+
+	/* cipher key */
+	to_talitos_ptr(ckey_ptr, ctx->dma_key  + ctx->authkeylen,
+		       ctx->enckeylen, is_sec1);
+
+	/*
+	 * cipher in
+	 * map and adjust cipher len to aead request cryptlen.
+	 * extent is bytes of HMAC postpended to ciphertext,
+	 * typically 12 for ipsec
+	 */
+	if (is_ipsec_esp && (desc->hdr & DESC_HDR_MODE1_MDEU_CICV))
+		elen = authsize;
+
+	ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
+				 sg_count, areq->assoclen, tbl_off, elen,
+				 false, 1);
+
+	if (ret > 1) {
+		tbl_off += ret;
+		sync_needed = true;
+	}
+
+	/* cipher out */
+	if (areq->src != areq->dst) {
+		sg_count = edesc->dst_nents ? : 1;
+		if (!is_sec1 || sg_count == 1)
+			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
+	}
+
+	if (is_ipsec_esp && encrypt)
+		elen = authsize;
+	else
+		elen = 0;
+	ret = talitos_sg_map_ext(dev, areq->dst, cryptlen, edesc, &desc->ptr[5],
+				 sg_count, areq->assoclen, tbl_off, elen,
+				 is_ipsec_esp && !encrypt, 1);
+	tbl_off += ret;
+
+	if (!encrypt && is_ipsec_esp) {
+		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
+
+		/* Add an entry to the link table for ICV data */
+		to_talitos_ptr_ext_set(tbl_ptr - 1, 0, is_sec1);
+		to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RET, is_sec1);
+
+		/* icv data follows link tables */
+		to_talitos_ptr(tbl_ptr, dma_icv, authsize, is_sec1);
+		to_talitos_ptr_ext_or(&desc->ptr[5], authsize, is_sec1);
+		sync_needed = true;
+	} else if (!encrypt) {
+		to_talitos_ptr(&desc->ptr[6], dma_icv, authsize, is_sec1);
+		sync_needed = true;
+	} else if (!is_ipsec_esp) {
+		talitos_sg_map(dev, areq->dst, authsize, edesc, &desc->ptr[6],
+			       sg_count, areq->assoclen + cryptlen, tbl_off);
+	}
+
+	/* iv out */
+	if (is_ipsec_esp)
+		map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv,
+				       DMA_FROM_DEVICE);
+
+	if (sync_needed)
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+					   edesc->dma_len,
+					   DMA_BIDIRECTIONAL);
+
+	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
+	if (ret != -EINPROGRESS) {
+		ipsec_esp_unmap(dev, edesc, areq, encrypt);
+		kfree(edesc);
+	}
+	return ret;
+}
+
+static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
+					      int icv_stashing, bool encrypt)
+{
+	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
+	unsigned int authsize = crypto_aead_authsize(authenc);
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	unsigned int ivsize = crypto_aead_ivsize(authenc);
+	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
+
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
+				   iv, areq->assoclen, cryptlen,
+				   authsize, ivsize, icv_stashing,
+				   areq->base.flags, encrypt);
+}
+
+static int aead_encrypt(struct aead_request *req)
+{
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct talitos_edesc *edesc;
+
+	/* allocate extended descriptor */
+	edesc = aead_edesc_alloc(req, req->iv, 0, true);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* set encrypt */
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
+
+	return ipsec_esp(edesc, req, true, ipsec_esp_encrypt_done);
+}
+
+static int aead_decrypt(struct aead_request *req)
+{
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	unsigned int authsize = crypto_aead_authsize(authenc);
+	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
+	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
+	struct talitos_edesc *edesc;
+	void *icvdata;
+
+	/* allocate extended descriptor */
+	edesc = aead_edesc_alloc(req, req->iv, 1, false);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	if ((edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP) &&
+	    (priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
+	    ((!edesc->src_nents && !edesc->dst_nents) ||
+	     priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT)) {
+
+		/* decrypt and check the ICV */
+		edesc->desc.hdr = ctx->desc_hdr_template |
+				  DESC_HDR_DIR_INBOUND |
+				  DESC_HDR_MODE1_MDEU_CICV;
+
+		/* reset integrity check result bits */
+
+		return ipsec_esp(edesc, req, false,
+				 ipsec_esp_decrypt_hwauth_done);
+	}
+
+	/* Have to check the ICV with software */
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
+
+	/* stash incoming ICV for later cmp with ICV generated by the h/w */
+	icvdata = edesc->buf + edesc->dma_len;
+
+	sg_pcopy_to_buffer(req->src, edesc->src_nents ? : 1, icvdata, authsize,
+			   req->assoclen + req->cryptlen - authsize);
+
+	return ipsec_esp(edesc, req, false, ipsec_esp_decrypt_swauth_done);
+}
+
+static int talitos_cra_init_aead(struct crypto_aead *tfm)
+{
+	struct aead_alg *alg = crypto_aead_alg(tfm);
+	struct talitos_crypto_alg *talitos_alg;
+	struct talitos_ctx *ctx = crypto_aead_ctx(tfm);
+
+	talitos_alg = container_of(alg, struct talitos_crypto_alg,
+				   algt.alg.aead);
+
+	return talitos_init_common(ctx, talitos_alg);
+}
+
+static const struct talitos_alg_template aead_driver_algs[] = {
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-aes-talitos-hsna",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha1),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha1-"
+						   "cbc-3des-talitos-hsna",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
+	},
+	{       .type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
+	},
+	{       .type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "cbc-aes-talitos-hsna",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha224),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha224-"
+						   "cbc-3des-talitos-hsna",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA224_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-aes-talitos-hsna",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha256),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha256-"
+						   "cbc-3des-talitos-hsna",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha384),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha384-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUB |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha384),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha384-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA384_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUB |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha512),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-sha512-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUB |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(sha512),"
+					    "cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-sha512-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUB |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-aes-talitos",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(aes))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-aes-talitos-hsna",
+				.cra_blocksize = AES_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-3des-talitos",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_AEAD,
+		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
+		.alg.aead = {
+			.base = {
+				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
+				.cra_driver_name = "authenc-hmac-md5-"
+						   "cbc-3des-talitos-hsna",
+				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_ALLOCATES_MEMORY,
+			},
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.maxauthsize = MD5_DIGEST_SIZE,
+			.setkey = aead_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES |
+				     DESC_HDR_SEL1_MDEUA |
+				     DESC_HDR_MODE1_MDEU_INIT |
+				     DESC_HDR_MODE1_MDEU_PAD |
+				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
+	},
+};
+
+int talitos_register_aead(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	struct talitos_alg_template talitos_alg_template;
+	struct aead_alg *aead_alg;
+	struct crypto_alg *alg;
+	size_t i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(aead_driver_algs); i++) {
+		if (!talitos_hw_supports(dev,
+					 aead_driver_algs[i].desc_hdr_template))
+			continue;
+
+		talitos_alg_template = aead_driver_algs[i];
+
+		aead_alg = &talitos_alg_template.alg.aead;
+		alg = &aead_alg->base;
+
+		alg->cra_exit = talitos_cra_exit;
+		if (has_ftr_sec1(priv))
+			alg->cra_alignmask = 3;
+
+		aead_alg->init = talitos_cra_init_aead;
+		aead_alg->setkey = aead_alg->setkey ?: aead_setkey;
+		aead_alg->encrypt = aead_encrypt;
+		aead_alg->decrypt = aead_decrypt;
+		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
+		    !strncmp(alg->cra_name, "authenc(hmac(sha224)", 20)) {
+			continue;
+		}
+
+		ret = talitos_register_common(dev, &talitos_alg_template);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/talitos/talitos-core.c b/drivers/crypto/talitos/talitos-core.c
index 2d3509478ff0..c4e8499a8178 100644
--- a/drivers/crypto/talitos/talitos-core.c
+++ b/drivers/crypto/talitos/talitos-core.c
@@ -727,87 +727,6 @@ DEF_TALITOS2_INTERRUPT(ch0_2, TALITOS2_ISR_CH_0_2_DONE, TALITOS2_ISR_CH_0_2_ERR,
 DEF_TALITOS2_INTERRUPT(ch1_3, TALITOS2_ISR_CH_1_3_DONE, TALITOS2_ISR_CH_1_3_ERR,
 		       1)
 
-
-/*
- * crypto alg
- */
-#define TALITOS_CRA_PRIORITY		3000
-/*
- * Defines a priority for doing AEAD with descriptors type
- * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP
- */
-#define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)
-
-static int aead_setkey(struct crypto_aead *authenc,
-		       const u8 *key, unsigned int keylen)
-{
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct device *dev = ctx->dev;
-	struct crypto_authenc_keys keys;
-
-	if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
-		goto badkey;
-
-	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
-		goto badkey;
-
-	if (ctx->keylen)
-		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
-
-	memcpy(ctx->key, keys.authkey, keys.authkeylen);
-	memcpy(&ctx->key[keys.authkeylen], keys.enckey, keys.enckeylen);
-
-	ctx->keylen = keys.authkeylen + keys.enckeylen;
-	ctx->enckeylen = keys.enckeylen;
-	ctx->authkeylen = keys.authkeylen;
-	ctx->dma_key = dma_map_single(dev, ctx->key, ctx->keylen,
-				      DMA_TO_DEVICE);
-
-	memzero_explicit(&keys, sizeof(keys));
-	return 0;
-
-badkey:
-	memzero_explicit(&keys, sizeof(keys));
-	return -EINVAL;
-}
-
-static int aead_des3_setkey(struct crypto_aead *authenc,
-			    const u8 *key, unsigned int keylen)
-{
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct device *dev = ctx->dev;
-	struct crypto_authenc_keys keys;
-	int err;
-
-	err = crypto_authenc_extractkeys(&keys, key, keylen);
-	if (unlikely(err))
-		goto out;
-
-	err = -EINVAL;
-	if (keys.authkeylen + keys.enckeylen > TALITOS_MAX_KEY_SIZE)
-		goto out;
-
-	err = verify_aead_des3_key(authenc, keys.enckey, keys.enckeylen);
-	if (err)
-		goto out;
-
-	if (ctx->keylen)
-		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
-
-	memcpy(ctx->key, keys.authkey, keys.authkeylen);
-	memcpy(&ctx->key[keys.authkeylen], keys.enckey, keys.enckeylen);
-
-	ctx->keylen = keys.authkeylen + keys.enckeylen;
-	ctx->enckeylen = keys.enckeylen;
-	ctx->authkeylen = keys.authkeylen;
-	ctx->dma_key = dma_map_single(dev, ctx->key, ctx->keylen,
-				      DMA_TO_DEVICE);
-
-out:
-	memzero_explicit(&keys, sizeof(keys));
-	return err;
-}
-
 void talitos_sg_unmap(struct device *dev,
 			     struct talitos_edesc *edesc,
 			     struct scatterlist *src,
@@ -836,109 +755,6 @@ void talitos_sg_unmap(struct device *dev,
 	}
 }
 
-static void ipsec_esp_unmap(struct device *dev,
-			    struct talitos_edesc *edesc,
-			    struct aead_request *areq, bool encrypt)
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
-	unsigned int ivsize = crypto_aead_ivsize(aead);
-	unsigned int authsize = crypto_aead_authsize(aead);
-	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
-	bool is_ipsec_esp = edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP;
-	struct talitos_ptr *civ_ptr = &edesc->desc.ptr[is_ipsec_esp ? 2 : 3];
-
-	if (is_ipsec_esp)
-		unmap_single_talitos_ptr(dev, &edesc->desc.ptr[6],
-					 DMA_FROM_DEVICE);
-	unmap_single_talitos_ptr(dev, civ_ptr, DMA_TO_DEVICE);
-
-	talitos_sg_unmap(dev, edesc, areq->src, areq->dst,
-			 cryptlen + authsize, areq->assoclen);
-
-	if (edesc->dma_len)
-		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
-				 DMA_BIDIRECTIONAL);
-
-	if (!is_ipsec_esp) {
-		unsigned int dst_nents = edesc->dst_nents ? : 1;
-
-		sg_pcopy_to_buffer(areq->dst, dst_nents, ctx->iv, ivsize,
-				   areq->assoclen + cryptlen - ivsize);
-	}
-}
-
-/*
- * ipsec_esp descriptor callbacks
- */
-static void ipsec_esp_encrypt_done(struct device *dev,
-				   struct talitos_desc *desc, void *context,
-				   int err)
-{
-	struct aead_request *areq = context;
-	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
-	unsigned int ivsize = crypto_aead_ivsize(authenc);
-	struct talitos_edesc *edesc;
-
-	edesc = container_of(desc, struct talitos_edesc, desc);
-
-	ipsec_esp_unmap(dev, edesc, areq, true);
-
-	dma_unmap_single(dev, edesc->iv_dma, ivsize, DMA_TO_DEVICE);
-
-	kfree(edesc);
-
-	aead_request_complete(areq, err);
-}
-
-static void ipsec_esp_decrypt_swauth_done(struct device *dev,
-					  struct talitos_desc *desc,
-					  void *context, int err)
-{
-	struct aead_request *req = context;
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	unsigned int authsize = crypto_aead_authsize(authenc);
-	struct talitos_edesc *edesc;
-	char *oicv, *icv;
-
-	edesc = container_of(desc, struct talitos_edesc, desc);
-
-	ipsec_esp_unmap(dev, edesc, req, false);
-
-	if (!err) {
-		/* auth check */
-		oicv = edesc->buf + edesc->dma_len;
-		icv = oicv - authsize;
-
-		err = crypto_memneq(oicv, icv, authsize) ? -EBADMSG : 0;
-	}
-
-	kfree(edesc);
-
-	aead_request_complete(req, err);
-}
-
-static void ipsec_esp_decrypt_hwauth_done(struct device *dev,
-					  struct talitos_desc *desc,
-					  void *context, int err)
-{
-	struct aead_request *req = context;
-	struct talitos_edesc *edesc;
-
-	edesc = container_of(desc, struct talitos_edesc, desc);
-
-	ipsec_esp_unmap(dev, edesc, req, false);
-
-	/* check ICV auth status */
-	if (!err && ((desc->hdr_lo & DESC_HDR_LO_ICCR1_MASK) !=
-		     DESC_HDR_LO_ICCR1_PASS))
-		err = -EBADMSG;
-
-	kfree(edesc);
-
-	aead_request_complete(req, err);
-}
-
 /*
  * convert scatterlist to SEC h/w link table format
  * stop at cryptlen bytes
@@ -1039,132 +855,6 @@ int talitos_sg_map(struct device *dev, struct scatterlist *src,
 				  tbl_off, 0, false, 1);
 }
 
-/*
- * fill in and submit ipsec_esp descriptor
- */
-static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
-		     bool encrypt,
-		     void (*callback)(struct device *dev,
-				      struct talitos_desc *desc,
-				      void *context, int error))
-{
-	struct crypto_aead *aead = crypto_aead_reqtfm(areq);
-	unsigned int authsize = crypto_aead_authsize(aead);
-	struct talitos_ctx *ctx = crypto_aead_ctx(aead);
-	struct device *dev = ctx->dev;
-	struct talitos_desc *desc = &edesc->desc;
-	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
-	unsigned int ivsize = crypto_aead_ivsize(aead);
-	int tbl_off = 0;
-	int sg_count, ret;
-	int elen = 0;
-	bool sync_needed = false;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-	bool is_ipsec_esp = desc->hdr & DESC_HDR_TYPE_IPSEC_ESP;
-	struct talitos_ptr *civ_ptr = &desc->ptr[is_ipsec_esp ? 2 : 3];
-	struct talitos_ptr *ckey_ptr = &desc->ptr[is_ipsec_esp ? 3 : 2];
-	dma_addr_t dma_icv = edesc->dma_link_tbl + edesc->dma_len - authsize;
-
-	/* hmac key */
-	to_talitos_ptr(&desc->ptr[0], ctx->dma_key, ctx->authkeylen, is_sec1);
-
-	sg_count = edesc->src_nents ?: 1;
-	if (is_sec1 && sg_count > 1)
-		sg_copy_to_buffer(areq->src, sg_count, edesc->buf,
-				  areq->assoclen + cryptlen);
-	else
-		sg_count = dma_map_sg(dev, areq->src, sg_count,
-				      (areq->src == areq->dst) ?
-				      DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
-
-	/* hmac data */
-	ret = talitos_sg_map(dev, areq->src, areq->assoclen, edesc,
-			     &desc->ptr[1], sg_count, 0, tbl_off);
-
-	if (ret > 1) {
-		tbl_off += ret;
-		sync_needed = true;
-	}
-
-	/* cipher iv */
-	to_talitos_ptr(civ_ptr, edesc->iv_dma, ivsize, is_sec1);
-
-	/* cipher key */
-	to_talitos_ptr(ckey_ptr, ctx->dma_key  + ctx->authkeylen,
-		       ctx->enckeylen, is_sec1);
-
-	/*
-	 * cipher in
-	 * map and adjust cipher len to aead request cryptlen.
-	 * extent is bytes of HMAC postpended to ciphertext,
-	 * typically 12 for ipsec
-	 */
-	if (is_ipsec_esp && (desc->hdr & DESC_HDR_MODE1_MDEU_CICV))
-		elen = authsize;
-
-	ret = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[4],
-				 sg_count, areq->assoclen, tbl_off, elen,
-				 false, 1);
-
-	if (ret > 1) {
-		tbl_off += ret;
-		sync_needed = true;
-	}
-
-	/* cipher out */
-	if (areq->src != areq->dst) {
-		sg_count = edesc->dst_nents ? : 1;
-		if (!is_sec1 || sg_count == 1)
-			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
-	}
-
-	if (is_ipsec_esp && encrypt)
-		elen = authsize;
-	else
-		elen = 0;
-	ret = talitos_sg_map_ext(dev, areq->dst, cryptlen, edesc, &desc->ptr[5],
-				 sg_count, areq->assoclen, tbl_off, elen,
-				 is_ipsec_esp && !encrypt, 1);
-	tbl_off += ret;
-
-	if (!encrypt && is_ipsec_esp) {
-		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
-
-		/* Add an entry to the link table for ICV data */
-		to_talitos_ptr_ext_set(tbl_ptr - 1, 0, is_sec1);
-		to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RET, is_sec1);
-
-		/* icv data follows link tables */
-		to_talitos_ptr(tbl_ptr, dma_icv, authsize, is_sec1);
-		to_talitos_ptr_ext_or(&desc->ptr[5], authsize, is_sec1);
-		sync_needed = true;
-	} else if (!encrypt) {
-		to_talitos_ptr(&desc->ptr[6], dma_icv, authsize, is_sec1);
-		sync_needed = true;
-	} else if (!is_ipsec_esp) {
-		talitos_sg_map(dev, areq->dst, authsize, edesc, &desc->ptr[6],
-			       sg_count, areq->assoclen + cryptlen, tbl_off);
-	}
-
-	/* iv out */
-	if (is_ipsec_esp)
-		map_single_talitos_ptr(dev, &desc->ptr[6], ivsize, ctx->iv,
-				       DMA_FROM_DEVICE);
-
-	if (sync_needed)
-		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-					   edesc->dma_len,
-					   DMA_BIDIRECTIONAL);
-
-	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
-	if (ret != -EINPROGRESS) {
-		ipsec_esp_unmap(dev, edesc, areq, encrypt);
-		kfree(edesc);
-	}
-	return ret;
-}
-
 /*
  * allocate and map the extended descriptor
  */
@@ -1263,540 +953,6 @@ struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	return edesc;
 }
 
-static struct talitos_edesc *aead_edesc_alloc(struct aead_request *areq, u8 *iv,
-					      int icv_stashing, bool encrypt)
-{
-	struct crypto_aead *authenc = crypto_aead_reqtfm(areq);
-	unsigned int authsize = crypto_aead_authsize(authenc);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	unsigned int ivsize = crypto_aead_ivsize(authenc);
-	unsigned int cryptlen = areq->cryptlen - (encrypt ? 0 : authsize);
-
-	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
-				   iv, areq->assoclen, cryptlen,
-				   authsize, ivsize, icv_stashing,
-				   areq->base.flags, encrypt);
-}
-
-static int aead_encrypt(struct aead_request *req)
-{
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct talitos_edesc *edesc;
-
-	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, req->iv, 0, true);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-	/* set encrypt */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
-
-	return ipsec_esp(edesc, req, true, ipsec_esp_encrypt_done);
-}
-
-static int aead_decrypt(struct aead_request *req)
-{
-	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
-	unsigned int authsize = crypto_aead_authsize(authenc);
-	struct talitos_ctx *ctx = crypto_aead_ctx(authenc);
-	struct talitos_private *priv = dev_get_drvdata(ctx->dev);
-	struct talitos_edesc *edesc;
-	void *icvdata;
-
-	/* allocate extended descriptor */
-	edesc = aead_edesc_alloc(req, req->iv, 1, false);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-	if ((edesc->desc.hdr & DESC_HDR_TYPE_IPSEC_ESP) &&
-	    (priv->features & TALITOS_FTR_HW_AUTH_CHECK) &&
-	    ((!edesc->src_nents && !edesc->dst_nents) ||
-	     priv->features & TALITOS_FTR_SRC_LINK_TBL_LEN_INCLUDES_EXTENT)) {
-
-		/* decrypt and check the ICV */
-		edesc->desc.hdr = ctx->desc_hdr_template |
-				  DESC_HDR_DIR_INBOUND |
-				  DESC_HDR_MODE1_MDEU_CICV;
-
-		/* reset integrity check result bits */
-
-		return ipsec_esp(edesc, req, false,
-				 ipsec_esp_decrypt_hwauth_done);
-	}
-
-	/* Have to check the ICV with software */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
-
-	/* stash incoming ICV for later cmp with ICV generated by the h/w */
-	icvdata = edesc->buf + edesc->dma_len;
-
-	sg_pcopy_to_buffer(req->src, edesc->src_nents ? : 1, icvdata, authsize,
-			   req->assoclen + req->cryptlen - authsize);
-
-	return ipsec_esp(edesc, req, false, ipsec_esp_decrypt_swauth_done);
-}
-
-static struct talitos_alg_template driver_algs[] = {
-	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha1),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_AESU |
-		                     DESC_HDR_MODE0_AESU_CBC |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha1),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha1),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha1),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha1-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA1_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA1_HMAC,
-	},
-	{       .type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha224),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA224_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
-	},
-	{       .type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha224),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA224_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha224),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA224_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha224),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha224-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA224_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA224_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha256),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_AESU |
-		                     DESC_HDR_MODE0_AESU_CBC |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha256),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha256),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha256),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha256-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA256_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_SHA256_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha384),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha384-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA384_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_AESU |
-		                     DESC_HDR_MODE0_AESU_CBC |
-		                     DESC_HDR_SEL1_MDEUB |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha384),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha384-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA384_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUB |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEUB_SHA384_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha512),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-sha512-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = SHA512_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_AESU |
-		                     DESC_HDR_MODE0_AESU_CBC |
-		                     DESC_HDR_SEL1_MDEUB |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(sha512),"
-					    "cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-sha512-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = SHA512_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUB |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEUB_SHA512_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(md5),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-aes-talitos",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = MD5_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_AESU |
-		                     DESC_HDR_MODE0_AESU_CBC |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(md5),cbc(aes))",
-				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-aes-talitos-hsna",
-				.cra_blocksize = AES_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = AES_BLOCK_SIZE,
-			.maxauthsize = MD5_DIGEST_SIZE,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-3des-talitos",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = MD5_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_IPSEC_ESP |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES |
-		                     DESC_HDR_SEL1_MDEUA |
-		                     DESC_HDR_MODE1_MDEU_INIT |
-		                     DESC_HDR_MODE1_MDEU_PAD |
-		                     DESC_HDR_MODE1_MDEU_MD5_HMAC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_AEAD,
-		.priority = TALITOS_CRA_PRIORITY_AEAD_HSNA,
-		.alg.aead = {
-			.base = {
-				.cra_name = "authenc(hmac(md5),cbc(des3_ede))",
-				.cra_driver_name = "authenc-hmac-md5-"
-						   "cbc-3des-talitos-hsna",
-				.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-				.cra_flags = CRYPTO_ALG_ASYNC |
-					     CRYPTO_ALG_ALLOCATES_MEMORY,
-			},
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.maxauthsize = MD5_DIGEST_SIZE,
-			.setkey = aead_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC |
-				     DESC_HDR_MODE0_DEU_3DES |
-				     DESC_HDR_SEL1_MDEUA |
-				     DESC_HDR_MODE1_MDEU_INIT |
-				     DESC_HDR_MODE1_MDEU_PAD |
-				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
-	},
-};
-
 int talitos_init_common(struct talitos_ctx *ctx,
 			struct talitos_crypto_alg *talitos_alg)
 {
@@ -1819,18 +975,6 @@ int talitos_init_common(struct talitos_ctx *ctx,
 	return 0;
 }
 
-static int talitos_cra_init_aead(struct crypto_aead *tfm)
-{
-	struct aead_alg *alg = crypto_aead_alg(tfm);
-	struct talitos_crypto_alg *talitos_alg;
-	struct talitos_ctx *ctx = crypto_aead_ctx(tfm);
-
-	talitos_alg = container_of(alg, struct talitos_crypto_alg,
-				   algt.alg.aead);
-
-	return talitos_init_common(ctx, talitos_alg);
-}
-
 void talitos_cra_exit(struct crypto_tfm *tfm)
 {
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -1940,6 +1084,12 @@ int talitos_register_common(struct device *dev,
 				       t_alg->algt.type);
 		ret = crypto_register_skcipher(&t_alg->algt.alg.skcipher);
 		break;
+	case CRYPTO_ALG_TYPE_AEAD:
+		alg = &t_alg->algt.alg.aead.base;
+		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
+				       t_alg->algt.type);
+		ret = crypto_register_aead(&t_alg->algt.alg.aead);
+		break;
 	default:
 		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
 		devm_kfree(dev, t_alg);
@@ -1958,59 +1108,6 @@ int talitos_register_common(struct device *dev,
 	return 0;
 }
 
-static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
-						    struct talitos_alg_template
-						           *template)
-{
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	struct talitos_crypto_alg *t_alg;
-	struct crypto_alg *alg;
-
-	t_alg = devm_kzalloc(dev, sizeof(struct talitos_crypto_alg),
-			     GFP_KERNEL);
-	if (!t_alg)
-		return ERR_PTR(-ENOMEM);
-
-	t_alg->algt = *template;
-
-	switch (t_alg->algt.type) {
-	case CRYPTO_ALG_TYPE_AEAD:
-		alg = &t_alg->algt.alg.aead.base;
-		alg->cra_exit = talitos_cra_exit;
-		t_alg->algt.alg.aead.init = talitos_cra_init_aead;
-		t_alg->algt.alg.aead.setkey = t_alg->algt.alg.aead.setkey ?:
-					      aead_setkey;
-		t_alg->algt.alg.aead.encrypt = aead_encrypt;
-		t_alg->algt.alg.aead.decrypt = aead_decrypt;
-		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
-		    !strncmp(alg->cra_name, "authenc(hmac(sha224)", 20)) {
-			devm_kfree(dev, t_alg);
-			return ERR_PTR(-ENOTSUPP);
-		}
-		break;
-	default:
-		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
-		devm_kfree(dev, t_alg);
-		return ERR_PTR(-EINVAL);
-	}
-
-	alg->cra_module = THIS_MODULE;
-	if (t_alg->algt.priority)
-		alg->cra_priority = t_alg->algt.priority;
-	else
-		alg->cra_priority = TALITOS_CRA_PRIORITY;
-	if (has_ftr_sec1(priv) && t_alg->algt.type != CRYPTO_ALG_TYPE_AHASH)
-		alg->cra_alignmask = 3;
-	else
-		alg->cra_alignmask = 0;
-	alg->cra_ctxsize = sizeof(struct talitos_ctx);
-	alg->cra_flags |= CRYPTO_ALG_KERN_DRIVER_ONLY;
-
-	t_alg->dev = dev;
-
-	return t_alg;
-}
-
 static int talitos_probe_irq(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
@@ -2231,36 +1328,10 @@ static int talitos_probe(struct platform_device *ofdev)
 	if (err)
 		goto err_out;
 
-	/* register crypto algorithms the device supports */
-	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
-		if (talitos_hw_supports(dev,
-					driver_algs[i].desc_hdr_template)) {
-			struct talitos_crypto_alg *t_alg;
-			struct crypto_alg *alg = NULL;
-
-			t_alg = talitos_alg_alloc(dev, &driver_algs[i]);
-			if (IS_ERR(t_alg)) {
-				err = PTR_ERR(t_alg);
-				if (err == -ENOTSUPP)
-					continue;
-				goto err_out;
-			}
+	err = talitos_register_aead(dev);
+	if (err)
+		goto err_out;
 
-			switch (t_alg->algt.type) {
-			case CRYPTO_ALG_TYPE_AEAD:
-				err = crypto_register_aead(
-					&t_alg->algt.alg.aead);
-				alg = &t_alg->algt.alg.aead.base;
-				break;
-			}
-			if (err) {
-				dev_err(dev, "%s alg registration failed\n",
-					alg->cra_driver_name);
-				devm_kfree(dev, t_alg);
-			} else
-				list_add_tail(&t_alg->entry, &priv->alg_list);
-		}
-	}
 	if (!list_empty(&priv->alg_list))
 		dev_info(dev, "%s algorithms registered in /proc/crypto\n",
 			 (char *)of_get_property(np, "compatible", NULL));
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index 07cdd6034883..8aa3102e9935 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -21,6 +21,8 @@
 #define TALITOS1_MAX_DATA_LEN 32768
 #define TALITOS2_MAX_DATA_LEN 65535
 
+#define TALITOS_CRA_PRIORITY 3000
+
 #define DESC_TYPE(desc_hdr) ((be32_to_cpu(desc_hdr) >> 3) & 0x1f)
 #define PRIMARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 28) & 0xf)
 #define SECONDARY_EU(desc_hdr) ((be32_to_cpu(desc_hdr) >> 16) & 0xf)
@@ -611,3 +613,4 @@ void talitos_unregister_rng(struct device *dev);
 
 int talitos_register_hash(struct device *dev);
 int talitos_register_skcipher(struct device *dev);
+int talitos_register_aead(struct device *dev);

-- 
2.56.0

