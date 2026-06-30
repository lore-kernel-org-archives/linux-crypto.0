Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C5126E706;
	Tue, 30 Jun 2026 08:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.35.192.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782808492; cv=none; b=CJE8V1d++Nmi+hOKSNRzqrZXfHncGkTo5dMYmQcr5dCKZwLGDX+qMDmSgbyKgKqqvXZJtMODRd0d1Cp2R/AxtHYidGcwcpNltQBUXuPcnD5jnhFF+lZXDyqzZx4fh/BrRQddZxIabqG01gStPLv+GNrgUVkD5XapdLngTgEOE34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782808492; c=relaxed/simple;
	bh=4d9N22ePKHu0cqNDRs94YVybwOIJYuJQMIDBQnjtGzE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aZJmd85kyIgZLz9guAwdqvjAbM3iBY5IdWXS4RjI5nAweOKzdzNOzgcDjOhWfyuKNWFcTTH+himsGMgF06xgbX12/yvgj9KJX2nk17R3HXwYjeXc0COno+/5dFkwmH5HRMFgNY8jDrHqPstzycDLselQhZY9G5gVuREpO6kK4Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=QlW00SL9; arc=none smtp.client-ip=52.35.192.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="QlW00SL9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1782808487; x=1814344487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L0aNwTM4xsyVDJfGkroBvflBS/wHl3/+s2a0+xJHX7Q=;
  b=QlW00SL9nlWCrLxnsYofIYofth0hYN2mLdSey+t84t9RtRP7N0raLChn
   D2P2Un+QDgXbWt440IDKscdnjrnZL0zxEUktWa1l/h9FqCAZx7eNeURcr
   ynN+mFYrcMH1oBpJqY3/23pQDgY0zFxQzyUthTgscjlEAEueilvrhVje8
   NIuq2xRjEUWpUPskk3RRUTLTeOIgOsE+Und0GLtu7bbUwoonF4Uajf5hs
   uW8hpej+cOvz58Wg/OSeiYqW0RHsA28Mku4r+XZyEsc7/hBg4MAjP98rN
   t9nMp+kUDrIZsbqc99SQUrZhgW3uw8xEEdzzmt9c/DV1kt8gExa6fEYQp
   w==;
X-CSE-ConnectionGUID: v8hd5pM8TS6cGsTUrqndBQ==
X-CSE-MsgGUID: VIC36+V0Rry+OQ2tUOwq+A==
X-IronPort-AV: E=Sophos;i="6.24,233,1774310400"; 
   d="scan'208";a="22530319"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 08:34:44 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:5494]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.1.61:2525] with esmtp (Farcaster)
 id a1bad821-8a74-40bd-b3ca-5eeafe1137a8; Tue, 30 Jun 2026 08:34:44 +0000 (UTC)
X-Farcaster-Flow-ID: a1bad821-8a74-40bd-b3ca-5eeafe1137a8
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 08:34:44 +0000
Received: from dev-dsk-lravich-1b-7405803b.eu-west-1.amazon.com (10.13.225.95)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Tue, 30 Jun 2026 08:34:42 +0000
From: Leonid Ravich <lravich@amazon.com>
To: <linux-crypto@vger.kernel.org>, <dm-devel@lists.linux.dev>
CC: <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ebiggers@kernel.org>,
	<snitzer@kernel.org>, <mpatocka@redhat.com>, <axboe@kernel.dk>
Subject: [PATCH v5 2/5] crypto: dun - data-unit-number dispatch template
Date: Tue, 30 Jun 2026 08:34:28 +0000
Message-ID: <20260630083431.2772-3-lravich@amazon.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630083431.2772-1-lravich@amazon.com>
References: <20260630083431.2772-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D044UWA001.ant.amazon.com (10.13.139.100) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Add a dun(...) skcipher template that wraps an inner skcipher whose IV
is a wide data-unit-number counter (e.g. dun(xts(aes),le)).  When the
caller sets skcipher_request::data_unit_size, the template splits the
request into cryptlen / data_unit_size sub-requests on the inner cipher,
walking the IV +1 per unit.  Each inner ->encrypt/->decrypt is a direct
call, so only the outer dispatch into the crypto API is indirect -- the
per-unit work is not.

The second template parameter selects the counter endianness: dun(...,le)
for a little-endian counter (dm-crypt plain64, blk-crypto inline
encryption) and dun(...,be) for a big-endian one (dm-crypt plain64be).
Those are the only two ways a per-unit IV relates to its neighbour by a
+1 step; IV modes that are not such a counter are simply not wrapped.
Like cryptd() and pcrypt(), dun() wraps an inner skcipher and changes
only how the request is dispatched -- here, split across data units --
performing no cipher transform of its own.

A dun() tfm exists solely for multi-DU dispatch, so a request with
data_unit_size 0 is rejected with -EINVAL; a caller wanting plain
single-DU encryption uses the inner skcipher.

A hardware engine that consumes a whole multi-DU request in one pass
registers its own dun(...) at a higher cra_priority and is selected
automatically by the existing priority mechanism; no per-algorithm
capability flag is needed.  The generic template is sync-only (the split
loop treats any non-zero inner return as terminal), so it resolves against
a sync inner cipher (mask | CRYPTO_ALG_ASYNC); async is left to such
native drivers.

The inner IV must be a whole number of 64-bit limbs and no wider than 32
bytes: 16 covers xts(...), 32 covers the widest inline-encryption mode
(Adiantum).

Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Leonid Ravich <lravich@amazon.com>
---
 crypto/Kconfig  |  14 ++
 crypto/Makefile |   1 +
 crypto/dun.c    | 359 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 374 insertions(+)
 create mode 100644 crypto/dun.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 103d1f58cb7c..4f90a780c4fc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -746,6 +746,20 @@ config CRYPTO_XTS
 	  implementation currently can't handle a sectorsize which is not a
 	  multiple of 16 bytes.
 
+config CRYPTO_DUN
+	tristate "Data-unit-number (DUN) dispatch template"
+	select CRYPTO_SKCIPHER
+	select CRYPTO_MANAGER
+	help
+	  dun(...) wraps an skcipher whose IV is a wide data-unit-number
+	  counter (e.g. xts(aes)) and lets a caller submit several data units
+	  sharing one starting IV in a single request, via
+	  skcipher_request::data_unit_size.  The counter endianness is the
+	  second parameter: dun(xts(aes),le) or dun(xts(aes),be).  The template
+	  splits the request into one inner call per data unit; a hardware
+	  driver may register a higher-priority dun(...) that handles the whole
+	  request in one pass.  The first user is dm-crypt.
+
 endmenu
 
 menu "AEAD (authenticated encryption with associated data) ciphers"
diff --git a/crypto/Makefile b/crypto/Makefile
index 162242593c7c..584d9e8c4347 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_CRYPTO_PCBC) += pcbc.o
 obj-$(CONFIG_CRYPTO_CTS) += cts.o
 obj-$(CONFIG_CRYPTO_LRW) += lrw.o
 obj-$(CONFIG_CRYPTO_XTS) += xts.o
+obj-$(CONFIG_CRYPTO_DUN) += dun.o
 obj-$(CONFIG_CRYPTO_CTR) += ctr.o
 obj-$(CONFIG_CRYPTO_XCTR) += xctr.o
 obj-$(CONFIG_CRYPTO_HCTR2) += hctr2.o
diff --git a/crypto/dun.c b/crypto/dun.c
new file mode 100644
index 000000000000..4fcb81a025b9
--- /dev/null
+++ b/crypto/dun.c
@@ -0,0 +1,359 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * dun: data-unit-number dispatch template for skcipher
+ *
+ * Wraps an inner skcipher (e.g. xts(aes)) and, when the caller sets
+ * skcipher_request::data_unit_size, splits the request into cryptlen /
+ * data_unit_size sub-requests, each unit's IV the previous one +1 -- the
+ * data-unit-number (DUN) convention.  The second parameter selects the IV
+ * walk (see struct dun_mode): dun(xts(aes),le) or dun(xts(aes),be).
+ *
+ * Like cryptd()/pcrypt(), dun() only changes how a request is dispatched and
+ * performs no transform of its own; a native one-pass multi-DU driver wins by
+ * cra_priority.  Callers that never set data_unit_size pay nothing.
+ */
+
+#include <crypto/algapi.h>
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/string.h>
+
+/* Bounds the on-stack IV buffers: 16 covers xts(...), 32 covers Adiantum. */
+#define DUN_MAX_IVSIZE		32
+
+/*
+ * A dun() mode is the rule for deriving each data unit's IV from the request's
+ * starting IV.  @name is the template's second parameter; @iv_next advances the
+ * @ivsize-byte @iv in place to the next data unit.  @ivsize_ok rejects IV sizes
+ * the walk can't handle.  Add a row to dun_modes[] to support a new convention.
+ */
+struct dun_mode {
+	const char *name;
+	void (*iv_next)(u8 *iv, unsigned int ivsize);
+	bool (*ivsize_ok)(unsigned int ivsize);
+};
+
+struct dun_tfm_ctx {
+	struct crypto_skcipher *child;
+	const struct dun_mode *mode;
+};
+
+struct dun_inst_ctx {
+	struct crypto_skcipher_spawn spawn;
+	const struct dun_mode *mode;
+};
+
+struct dun_request_ctx {
+	/* Must be last; the child request is appended with its own reqsize. */
+	struct skcipher_request subreq;
+};
+
+/* Little-endian counter: increment the IV per __le64 limb, low limb first. */
+static void dun_iv_next_le(u8 *iv, unsigned int ivsize)
+{
+	unsigned int i;
+
+	for (i = 0; i < ivsize; i += sizeof(__le64)) {
+		__le64 limb;
+		u64 v;
+
+		memcpy(&limb, iv + i, sizeof(limb));
+		v = le64_to_cpu(limb) + 1;
+		limb = cpu_to_le64(v);
+		memcpy(iv + i, &limb, sizeof(limb));
+		if (likely(v != 0))
+			break;			/* no carry into the next limb */
+	}
+}
+
+/* Big-endian counter: increment the IV byte-wise from the last byte. */
+static void dun_iv_next_be(u8 *iv, unsigned int ivsize)
+{
+	unsigned int i = ivsize;
+
+	while (i--) {
+		if (likely(++iv[i]))
+			break;			/* no carry into the next byte */
+	}
+}
+
+/*
+ * le requires this: it walks the IV in __le64 limbs, so the size must be a
+ * whole number of limbs.  be increments byte-wise and would accept any size,
+ * but reuses the same check for a uniform value-space.
+ */
+static bool dun_ivsize_whole_limbs(unsigned int ivsize)
+{
+	return IS_ALIGNED(ivsize, sizeof(__le64));
+}
+
+static const struct dun_mode dun_modes[] = {
+	{ "le", dun_iv_next_le, dun_ivsize_whole_limbs },
+	{ "be", dun_iv_next_be, dun_ivsize_whole_limbs },
+};
+
+static const struct dun_mode *dun_find_mode(const char *name)
+{
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(dun_modes); i++)
+		if (!strcmp(name, dun_modes[i].name))
+			return &dun_modes[i];
+	return NULL;
+}
+
+static int dun_setkey(struct crypto_skcipher *parent, const u8 *key,
+		      unsigned int keylen)
+{
+	struct dun_tfm_ctx *ctx = crypto_skcipher_ctx(parent);
+	struct crypto_skcipher *child = ctx->child;
+
+	crypto_skcipher_clear_flags(child, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(child, crypto_skcipher_get_flags(parent) &
+					 CRYPTO_TFM_REQ_MASK);
+	return crypto_skcipher_setkey(child, key, keylen);
+}
+
+/*
+ * Run one inner ->crypt per data unit, walking the IV as a wide counter.
+ * @req->iv is never modified; the inner cipher only sees the iv_unit copy.
+ */
+static int dun_split(struct skcipher_request *req,
+		     int (*crypt)(struct skcipher_request *))
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct dun_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct dun_request_ctx *rctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq = &rctx->subreq;
+	const unsigned int du = req->data_unit_size;
+	const unsigned int total = req->cryptlen;
+	const unsigned int ivsize = crypto_skcipher_ivsize(tfm);
+	const struct dun_mode *mode = ctx->mode;
+	bool inplace = req->src == req->dst;
+	struct scatter_walk src_walk, dst_walk;
+	struct scatterlist src_sg[2], dst_sg[2];
+	u8 iv_ctr[DUN_MAX_IVSIZE];
+	u8 iv_unit[DUN_MAX_IVSIZE];
+	unsigned int off;
+	int err = 0;
+
+	/* iv_ctr is the counter; iv_unit is a per-unit copy an inner may write
+	 * back in place (e.g. xts, essiv), so the counter is never mutated.
+	 */
+	memcpy(iv_ctr, req->iv, ivsize);
+
+	sg_init_table(src_sg, 2);
+	scatterwalk_start(&src_walk, req->src);
+	if (!inplace) {
+		sg_init_table(dst_sg, 2);
+		scatterwalk_start(&dst_walk, req->dst);
+	}
+
+	skcipher_request_set_tfm(subreq, ctx->child);
+	skcipher_request_set_callback(subreq, skcipher_request_flags(req),
+				      NULL, NULL);
+
+	for (off = 0; off < total; off += du) {
+		struct scatterlist *s, *d;
+
+		scatterwalk_get_sglist(&src_walk, src_sg);
+		scatterwalk_skip(&src_walk, du);
+		s = src_sg;
+		if (inplace) {
+			d = src_sg;
+		} else {
+			scatterwalk_get_sglist(&dst_walk, dst_sg);
+			scatterwalk_skip(&dst_walk, du);
+			d = dst_sg;
+		}
+
+		memcpy(iv_unit, iv_ctr, ivsize);
+		skcipher_request_set_crypt(subreq, s, d, du, iv_unit);
+		err = crypt(subreq);
+		if (err)
+			break;
+
+		mode->iv_next(iv_ctr, ivsize);
+	}
+
+	return err;
+}
+
+/*
+ * Validate a multi-DU request: non-zero cryptlen, and a data_unit_size that is
+ * set, a multiple of the block size, and divides cryptlen evenly.
+ */
+static int dun_check(struct skcipher_request *req)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+
+	if (!req->cryptlen || !req->data_unit_size ||
+	    !IS_ALIGNED(req->data_unit_size, crypto_skcipher_blocksize(tfm)) ||
+	    (req->cryptlen % req->data_unit_size))
+		return -EINVAL;
+	return 0;
+}
+
+static int dun_encrypt(struct skcipher_request *req)
+{
+	int err = dun_check(req);
+
+	if (err)
+		return err;
+	return dun_split(req, crypto_skcipher_encrypt);
+}
+
+static int dun_decrypt(struct skcipher_request *req)
+{
+	int err = dun_check(req);
+
+	if (err)
+		return err;
+	return dun_split(req, crypto_skcipher_decrypt);
+}
+
+static int dun_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct dun_inst_ctx *ictx = skcipher_instance_ctx(inst);
+	struct dun_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *child;
+
+	child = crypto_spawn_skcipher(&ictx->spawn);
+	if (IS_ERR(child))
+		return PTR_ERR(child);
+
+	ctx->child = child;
+	ctx->mode = ictx->mode;
+	crypto_skcipher_set_reqsize(tfm,
+				    sizeof(struct dun_request_ctx) +
+				    crypto_skcipher_reqsize(child));
+	return 0;
+}
+
+static void dun_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct dun_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_skcipher(ctx->child);
+}
+
+static void dun_free_instance(struct skcipher_instance *inst)
+{
+	struct dun_inst_ctx *ictx = skcipher_instance_ctx(inst);
+
+	crypto_drop_skcipher(&ictx->spawn);
+	kfree(inst);
+}
+
+static int dun_create(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	struct skcipher_alg_common *alg;
+	struct skcipher_instance *inst;
+	struct dun_inst_ctx *ictx;
+	const struct dun_mode *mode;
+	const char *cipher_name;
+	const char *mode_name;
+	u32 mask;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	if (err)
+		return err;
+
+	cipher_name = crypto_attr_alg_name(tb[1]);
+	if (IS_ERR(cipher_name))
+		return PTR_ERR(cipher_name);
+
+	/* Second parameter: the IV-walk mode (see dun_modes[]). */
+	mode_name = crypto_attr_alg_name(tb[2]);
+	if (IS_ERR(mode_name))
+		return PTR_ERR(mode_name);
+	mode = dun_find_mode(mode_name);
+	if (!mode)
+		return -EINVAL;
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+	ictx = skcipher_instance_ctx(inst);
+	ictx->mode = mode;
+
+	/*
+	 * Sync-only: the split loop can't drive an async (-EINPROGRESS) child,
+	 * so resolve against a sync inner (mask | CRYPTO_ALG_ASYNC).
+	 */
+	err = crypto_grab_skcipher(&ictx->spawn, skcipher_crypto_instance(inst),
+				   cipher_name, 0, mask | CRYPTO_ALG_ASYNC);
+	if (err)
+		goto err_free_inst;
+
+	alg = crypto_spawn_skcipher_alg_common(&ictx->spawn);
+
+	/* The mode must accept this IV size, and it must fit our buffers. */
+	err = -EINVAL;
+	if (!alg->ivsize || alg->ivsize > DUN_MAX_IVSIZE ||
+	    !mode->ivsize_ok(alg->ivsize))
+		goto err_free_inst;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME, "dun(%s,%s)",
+		     alg->base.cra_name, mode->name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "dun(%s,%s)", alg->base.cra_driver_name,
+		     mode->name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+
+	inst->alg.base.cra_priority = alg->base.cra_priority;
+	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
+	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
+	inst->alg.base.cra_ctxsize = sizeof(struct dun_tfm_ctx);
+
+	inst->alg.ivsize = alg->ivsize;
+	inst->alg.chunksize = alg->chunksize;
+	inst->alg.min_keysize = alg->min_keysize;
+	inst->alg.max_keysize = alg->max_keysize;
+
+	inst->alg.init = dun_init_tfm;
+	inst->alg.exit = dun_exit_tfm;
+	inst->alg.setkey = dun_setkey;
+	inst->alg.encrypt = dun_encrypt;
+	inst->alg.decrypt = dun_decrypt;
+
+	inst->free = dun_free_instance;
+
+	err = skcipher_register_instance(tmpl, inst);
+	if (err) {
+err_free_inst:
+		dun_free_instance(inst);
+	}
+	return err;
+}
+
+static struct crypto_template dun_tmpl = {
+	.name = "dun",
+	.create = dun_create,
+	.module = THIS_MODULE,
+};
+
+static int __init dun_module_init(void)
+{
+	return crypto_register_template(&dun_tmpl);
+}
+
+static void __exit dun_module_exit(void)
+{
+	crypto_unregister_template(&dun_tmpl);
+}
+
+module_init(dun_module_init);
+module_exit(dun_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Data-unit-number dispatch template for skcipher");
+MODULE_ALIAS_CRYPTO("dun");
-- 
2.47.3

