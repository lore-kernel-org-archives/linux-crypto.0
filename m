Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1CD17AE11
	for <linux-crypto@vger.kernel.org>; Wed,  4 Jun 2025 04:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749011145; cv=none; b=tFbPfawmRoEV2NwfxLk9lVZxUJ4QnAy0F4kD6IrIcdWp0pRVsyANEpVMLQjOvFDWc3V4SCkwyljNwvO6RXKQqRgR7uhCeyrxhi+vwzXmPxsCTvUqXZJbZs6Iui1XEkh6r/Le5LW9+699BVNX+YS6wkPThV9ixeYbxCI90qq9jMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749011145; c=relaxed/simple;
	bh=cI0t0/1bhpHwRgGViGpY8PsRt1VZa3rZbKBa7CvuiS0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=frf79Ah6v6q/nC0YJoF1p7S/lyuYc7hKQnIbUwWKcF6Ad+2aGhgl35D10HgSREbyy0cCSlPF0shkmRpe1QlvenrErvUBB7u8kj6S2jK9+olDVlk2iAeyYhekbhlCheMwyqUpjAxMXnGg6HP76bfNWO5Gq04k2rm4FXz87PWf54g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cKJEXgHL; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cKJEXgHL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749011144; x=1780547144;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cI0t0/1bhpHwRgGViGpY8PsRt1VZa3rZbKBa7CvuiS0=;
  b=cKJEXgHLU2EUyZ4oniR7mtKEYxDOBQ8QHOOWzGDaWPls8GMtTtHAFdU4
   +Oz8/Ta73Pp2PR0zE4ZbBMh/yhC9JSKtatsW0Eod1yuhEGGC/o5/OA0OU
   VyRbEbERX/QcSAgTmbYnCEqpqf5bNFShRym29vbrImiXEwgSpoFqxYn2B
   Xu3f4avwaQcci0HAf6l7rRysmeQyconr1vu7+v4IV33dptobhaZtiUfME
   ZBfI+8/Phx+oUfwUYteYyw6Kn7AG9Lhqz5DGWTH80T0onFwTBQ0bf7Mje
   kWORxG5jP+KQj/1aJNWo0EJEfHnvLwNCmcIxh/+9r5xgeh7Q2Wns9XZV5
   g==;
X-CSE-ConnectionGUID: BQYiOnfhQDic/RlDDHMB+w==
X-CSE-MsgGUID: pZMHsjx1SSWmRNYKIVFnVQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="51072502"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="51072502"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:25:43 -0700
X-CSE-ConnectionGUID: 4H06gOY9Tue0UXV+D4hxLg==
X-CSE-MsgGUID: q89Yf6PWRd+WBRmf4lGIaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="176009401"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa002.jf.intel.com with ESMTP; 03 Jun 2025 21:25:41 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	dsterba@suse.com,
	terrelln@fb.com,
	clabbe.montjoie@gmail.com
Subject: [PATCH v6] crypto: zstd - convert to acomp
Date: Wed,  4 Jun 2025 05:25:38 +0100
Message-Id: <20250604042538.876415-1-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the implementation to a native acomp interface using zstd
streaming APIs, eliminating the need for buffer linearization.

This includes:
   - Removal of the scomp interface in favor of acomp
   - Refactoring of stream allocation, initialization, and handling for
     both compression and decompression using Zstandard streaming APIs
   - Replacement of crypto_register_scomp() with crypto_register_acomp()
     for module registration

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
v5->v6:
   - On x86 (i386), u64 _align only guarantees 4-byte alignment,
     which causes the test to fail. To ensure consistent 8-byte alignment
     across all architectures, explicitly specify the alignment using the
     __aligned(8) attribute.

v4->v5
   - Swapping the order of acomp_walk_done_src/dst during
     decompression for a single flat buffer.

v3->v4:
   - Added acomp_walk_done_src/dst calls after completing
     compression/decompression for a single flat buffer
   
v2->v3:
   - Updated the logic to verify the existence of a single flat
     buffer using the acomp walk API.

v1->v2:
   - Made the wksp address to be 8 byte aligned.
   - Added logic to use Zstd non streaming APIs for single flat buffer.

 crypto/zstd.c | 385 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 248 insertions(+), 137 deletions(-)

diff --git a/crypto/zstd.c b/crypto/zstd.c
index 7570e11b4ee6..bd43ff544d38 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -12,188 +12,299 @@
 #include <linux/net.h>
 #include <linux/vmalloc.h>
 #include <linux/zstd.h>
-#include <crypto/internal/scompress.h>
+#include <crypto/internal/acompress.h>
+#include <crypto/scatterwalk.h>
 
 
-#define ZSTD_DEF_LEVEL	3
+#define ZSTD_DEF_LEVEL		3
+#define ZSTD_MAX_WINDOWLOG	18
+#define ZSTD_MAX_SIZE		BIT(ZSTD_MAX_WINDOWLOG)
 
 struct zstd_ctx {
 	zstd_cctx *cctx;
 	zstd_dctx *dctx;
-	void *cwksp;
-	void *dwksp;
+	size_t wksp_size;
+	zstd_parameters params;
+	u8 wksp[0] __attribute__((aligned(8)));
 };
 
-static zstd_parameters zstd_params(void)
+static DEFINE_MUTEX(zstd_stream_lock);
+
+static void *zstd_alloc_stream(void)
 {
-	return zstd_get_params(ZSTD_DEF_LEVEL, 0);
-}
-
-static int zstd_comp_init(struct zstd_ctx *ctx)
-{
-	int ret = 0;
-	const zstd_parameters params = zstd_params();
-	const size_t wksp_size = zstd_cctx_workspace_bound(&params.cParams);
-
-	ctx->cwksp = vzalloc(wksp_size);
-	if (!ctx->cwksp) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ctx->cctx = zstd_init_cctx(ctx->cwksp, wksp_size);
-	if (!ctx->cctx) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-out:
-	return ret;
-out_free:
-	vfree(ctx->cwksp);
-	goto out;
-}
-
-static int zstd_decomp_init(struct zstd_ctx *ctx)
-{
-	int ret = 0;
-	const size_t wksp_size = zstd_dctx_workspace_bound();
-
-	ctx->dwksp = vzalloc(wksp_size);
-	if (!ctx->dwksp) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ctx->dctx = zstd_init_dctx(ctx->dwksp, wksp_size);
-	if (!ctx->dctx) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-out:
-	return ret;
-out_free:
-	vfree(ctx->dwksp);
-	goto out;
-}
-
-static void zstd_comp_exit(struct zstd_ctx *ctx)
-{
-	vfree(ctx->cwksp);
-	ctx->cwksp = NULL;
-	ctx->cctx = NULL;
-}
-
-static void zstd_decomp_exit(struct zstd_ctx *ctx)
-{
-	vfree(ctx->dwksp);
-	ctx->dwksp = NULL;
-	ctx->dctx = NULL;
-}
-
-static int __zstd_init(void *ctx)
-{
-	int ret;
-
-	ret = zstd_comp_init(ctx);
-	if (ret)
-		return ret;
-	ret = zstd_decomp_init(ctx);
-	if (ret)
-		zstd_comp_exit(ctx);
-	return ret;
-}
-
-static void *zstd_alloc_ctx(void)
-{
-	int ret;
+	zstd_parameters params;
 	struct zstd_ctx *ctx;
+	size_t wksp_size;
 
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	params = zstd_get_params(ZSTD_DEF_LEVEL, ZSTD_MAX_SIZE);
+
+	wksp_size = max_t(size_t,
+			  zstd_cstream_workspace_bound(&params.cParams),
+			  zstd_dstream_workspace_bound(ZSTD_MAX_SIZE));
+	if (!wksp_size)
+		return ERR_PTR(-EINVAL);
+
+	ctx = kvmalloc(sizeof(*ctx) + wksp_size, GFP_KERNEL);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	ret = __zstd_init(ctx);
-	if (ret) {
-		kfree(ctx);
-		return ERR_PTR(ret);
-	}
+	ctx->params = params;
+	ctx->wksp_size = wksp_size;
 
 	return ctx;
 }
 
-static void __zstd_exit(void *ctx)
+static struct crypto_acomp_streams zstd_streams = {
+	.alloc_ctx = zstd_alloc_stream,
+	.cfree_ctx = kvfree,
+};
+
+static int zstd_init(struct crypto_acomp *acomp_tfm)
 {
-	zstd_comp_exit(ctx);
-	zstd_decomp_exit(ctx);
+	int ret = 0;
+
+	mutex_lock(&zstd_stream_lock);
+	ret = crypto_acomp_alloc_streams(&zstd_streams);
+	mutex_unlock(&zstd_stream_lock);
+
+	return ret;
 }
 
-static void zstd_free_ctx(void *ctx)
+static void zstd_exit(struct crypto_acomp *acomp_tfm)
 {
-	__zstd_exit(ctx);
-	kfree_sensitive(ctx);
+	crypto_acomp_free_streams(&zstd_streams);
 }
 
-static int __zstd_compress(const u8 *src, unsigned int slen,
-			   u8 *dst, unsigned int *dlen, void *ctx)
+static int zstd_compress_one(struct acomp_req *req, struct zstd_ctx *ctx, unsigned int *dlen)
 {
-	size_t out_len;
-	struct zstd_ctx *zctx = ctx;
-	const zstd_parameters params = zstd_params();
+	unsigned int out_len;
 
-	out_len = zstd_compress_cctx(zctx->cctx, dst, *dlen, src, slen, &params);
+	ctx->cctx = zstd_init_cctx(ctx->wksp, ctx->wksp_size);
+	if (!ctx->cctx)
+		return -EINVAL;
+
+	out_len = zstd_compress_cctx(ctx->cctx, sg_virt(req->dst),
+				     req->dlen, sg_virt(req->src),
+				     req->slen, &ctx->params);
 	if (zstd_is_error(out_len))
 		return -EINVAL;
+
 	*dlen = out_len;
+
 	return 0;
 }
 
-static int zstd_scompress(struct crypto_scomp *tfm, const u8 *src,
-			  unsigned int slen, u8 *dst, unsigned int *dlen,
-			  void *ctx)
+static int zstd_compress(struct acomp_req *req)
 {
-	return __zstd_compress(src, slen, dst, dlen, ctx);
-}
+	struct crypto_acomp_stream *s;
+	unsigned int pos, scur, dcur;
+	unsigned int total_out = 0;
+	bool data_available = true;
+	zstd_out_buffer outbuf;
+	struct acomp_walk walk;
+	zstd_in_buffer inbuf;
+	struct zstd_ctx *ctx;
+	size_t pending_bytes;
+	size_t num_bytes;
+	int ret;
 
-static int __zstd_decompress(const u8 *src, unsigned int slen,
-			     u8 *dst, unsigned int *dlen, void *ctx)
-{
-	size_t out_len;
-	struct zstd_ctx *zctx = ctx;
+	s = crypto_acomp_lock_stream_bh(&zstd_streams);
+	ctx = s->ctx;
 
-	out_len = zstd_decompress_dctx(zctx->dctx, dst, *dlen, src, slen);
-	if (zstd_is_error(out_len))
-		return -EINVAL;
-	*dlen = out_len;
-	return 0;
-}
+	ret = acomp_walk_virt(&walk, req, true);
+	if (ret)
+		goto out;
 
-static int zstd_sdecompress(struct crypto_scomp *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen,
-			    void *ctx)
-{
-	return __zstd_decompress(src, slen, dst, dlen, ctx);
-}
-
-static struct scomp_alg scomp = {
-	.alloc_ctx		= zstd_alloc_ctx,
-	.free_ctx		= zstd_free_ctx,
-	.compress		= zstd_scompress,
-	.decompress		= zstd_sdecompress,
-	.base			= {
-		.cra_name	= "zstd",
-		.cra_driver_name = "zstd-scomp",
-		.cra_module	 = THIS_MODULE,
+	ctx->cctx = zstd_init_cstream(&ctx->params, 0, ctx->wksp, ctx->wksp_size);
+	if (!ctx->cctx) {
+		ret = -EINVAL;
+		goto out;
 	}
+
+	do {
+		dcur = acomp_walk_next_dst(&walk);
+		if (!dcur) {
+			ret = -ENOSPC;
+			goto out;
+		}
+
+		outbuf.pos = 0;
+		outbuf.dst = (u8 *)walk.dst.virt.addr;
+		outbuf.size = dcur;
+
+		do {
+			scur = acomp_walk_next_src(&walk);
+			if (dcur == req->dlen && scur == req->slen) {
+				ret = zstd_compress_one(req, ctx, &total_out);
+				acomp_walk_done_src(&walk, scur);
+				acomp_walk_done_dst(&walk, dcur);
+				goto out;
+			}
+
+			if (scur) {
+				inbuf.pos = 0;
+				inbuf.src = walk.src.virt.addr;
+				inbuf.size = scur;
+			} else {
+				data_available = false;
+				break;
+			}
+
+			num_bytes = zstd_compress_stream(ctx->cctx, &outbuf, &inbuf);
+			if (ZSTD_isError(num_bytes)) {
+				ret = -EIO;
+				goto out;
+			}
+
+			pending_bytes = zstd_flush_stream(ctx->cctx, &outbuf);
+			if (ZSTD_isError(pending_bytes)) {
+				ret = -EIO;
+				goto out;
+			}
+			acomp_walk_done_src(&walk, inbuf.pos);
+		} while (dcur != outbuf.pos);
+
+		total_out += outbuf.pos;
+		acomp_walk_done_dst(&walk, dcur);
+	} while (data_available);
+
+	pos = outbuf.pos;
+	num_bytes = zstd_end_stream(ctx->cctx, &outbuf);
+	if (ZSTD_isError(num_bytes))
+		ret = -EIO;
+	else
+		total_out += (outbuf.pos - pos);
+
+out:
+	if (ret)
+		req->dlen = 0;
+	else
+		req->dlen = total_out;
+
+	crypto_acomp_unlock_stream_bh(s);
+
+	return ret;
+}
+
+static int zstd_decompress_one(struct acomp_req *req, struct zstd_ctx *ctx, unsigned int *dlen)
+{
+	size_t out_len;
+
+	ctx->dctx = zstd_init_dctx(ctx->wksp, ctx->wksp_size);
+	if (!ctx->dctx)
+		return -EINVAL;
+
+	out_len = zstd_decompress_dctx(ctx->dctx, sg_virt(req->dst),
+				       req->dlen, sg_virt(req->src),
+				       req->slen);
+	if (zstd_is_error(out_len))
+		return -EINVAL;
+
+	*dlen = out_len;
+
+	return 0;
+}
+
+static int zstd_decompress(struct acomp_req *req)
+{
+	struct crypto_acomp_stream *s;
+	unsigned int total_out = 0;
+	unsigned int scur, dcur;
+	zstd_out_buffer outbuf;
+	struct acomp_walk walk;
+	zstd_in_buffer inbuf;
+	struct zstd_ctx *ctx;
+	size_t pending_bytes;
+	int ret;
+
+	s = crypto_acomp_lock_stream_bh(&zstd_streams);
+	ctx = s->ctx;
+
+	ret = acomp_walk_virt(&walk, req, true);
+	if (ret)
+		goto out;
+
+	ctx->dctx = zstd_init_dstream(ZSTD_MAX_SIZE, ctx->wksp, ctx->wksp_size);
+	if (!ctx->dctx) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	do {
+		scur = acomp_walk_next_src(&walk);
+		if (scur) {
+			inbuf.pos = 0;
+			inbuf.size = scur;
+			inbuf.src = walk.src.virt.addr;
+		} else {
+			break;
+		}
+
+		do {
+			dcur = acomp_walk_next_dst(&walk);
+			if (dcur == req->dlen && scur == req->slen) {
+				ret = zstd_decompress_one(req, ctx, &total_out);
+				acomp_walk_done_dst(&walk, dcur);
+				acomp_walk_done_src(&walk, scur);
+				goto out;
+			}
+
+			if (!dcur) {
+				ret = -ENOSPC;
+				goto out;
+			}
+
+			outbuf.pos = 0;
+			outbuf.dst = (u8 *)walk.dst.virt.addr;
+			outbuf.size = dcur;
+
+			pending_bytes = zstd_decompress_stream(ctx->dctx, &outbuf, &inbuf);
+			if (ZSTD_isError(pending_bytes)) {
+				ret = -EIO;
+				goto out;
+			}
+
+			total_out += outbuf.pos;
+
+			acomp_walk_done_dst(&walk, outbuf.pos);
+		} while (scur != inbuf.pos);
+
+		if (scur)
+			acomp_walk_done_src(&walk, scur);
+	} while (ret == 0);
+
+out:
+	if (ret)
+		req->dlen = 0;
+	else
+		req->dlen = total_out;
+
+	crypto_acomp_unlock_stream_bh(s);
+
+	return ret;
+}
+
+static struct acomp_alg zstd_acomp = {
+	.base = {
+		.cra_name = "zstd",
+		.cra_driver_name = "zstd-generic",
+		.cra_flags = CRYPTO_ALG_REQ_VIRT,
+		.cra_module = THIS_MODULE,
+	},
+	.init = zstd_init,
+	.exit = zstd_exit,
+	.compress = zstd_compress,
+	.decompress = zstd_decompress,
 };
 
 static int __init zstd_mod_init(void)
 {
-	return crypto_register_scomp(&scomp);
+	return crypto_register_acomp(&zstd_acomp);
 }
 
 static void __exit zstd_mod_fini(void)
 {
-	crypto_unregister_scomp(&scomp);
+	crypto_unregister_acomp(&zstd_acomp);
 }
 
 module_init(zstd_mod_init);

base-commit: 70e6c5902da426d27ea62361f09c5e9e2251de1b
-- 
2.40.1

