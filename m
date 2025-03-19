Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9AE211707
	for <linux-crypto@vger.kernel.org>; Wed, 19 Mar 2025 06:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742364304; cv=none; b=stG0kLLfy9U2LXtD7jlKGqav/jA49YLVDOz9XIVLm6zBFUBgrN7FZiPuwshLn2V8uAKF3F28Z6pACW3R2cg3IEcLpwG6JVb7EiHmRewmhWM0f98OHEcAtW4KQLbTltpRKytklkQ3tfxkpa7r0BbvpUziPdGVscPLeinskUcgkOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742364304; c=relaxed/simple;
	bh=LK9PEgq1z6NKofBc+4jV5s3AMFqeJnBGjK+OLYJAJDY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=FAsY0Tc4pXunIS176t+8wtNWAwwg64d8o2PRXB2C0XRP5kB9T8xra2wTeEghc4I5OMVOY5W5njvKDTffcy39JI04YPW1kS09NDtpzex170wYv+6gAiM890t5mHmuFPLDZVPGp5ZdVMxoJcTCkGmqZ5uBEfsPxFPdBoXsjDIMEMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=pJysoqyL; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="pJysoqyL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LwjZmHPA2joTOfS3eNElEJn++lI/MFll7oMONEHUrXs=; b=pJysoqyLELcERgOZdvkIUavTER
	bxG97CmXFufwfgwfm4VEdZnD4RRpxzdYjx8PGXEg8NA/plbQCIgyMkOtVdf+m4sf3wj/dtd1unBzu
	m0s9gxl8KZpQUq5oUFO1X53MedDLN2gCY+mUNQG8K6UvcWZxFwfHAXVRNfVJt2ASxjzKt8VxJkL41
	nYdHyrlkl53VxXL5OUoZhxFl57vZcD+06bhjqTfoEKpqMzK1YyHG/NVVY5rt9xSL651h/F1zlasll
	5+yWDSXh1xyrhtFGjXGgJBc1P1I+8gF/k7bWOT4zU/S7dnIl6XitH1LHP4OKlwAHULpFcTlvYDmzX
	HNKrnzhQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tumXw-008IUy-2q;
	Wed, 19 Mar 2025 14:04:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Mar 2025 14:04:56 +0800
Date: Wed, 19 Mar 2025 14:04:56 +0800
Message-Id: <877922625d5ef7172a2675fe803ff969564cc6ce.1742364215.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1742364215.git.herbert@gondor.apana.org.au>
References: <cover.1742364215.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] crypto: deflate - Convert to acomp
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This based on work by Ard Biesheuvel <ardb@kernel.org>.

Convert deflate from scomp to acomp.  This removes the need for
the caller to linearise the source and destination.

Link: https://lore.kernel.org/all/20230718125847.3869700-21-ardb@kernel.org/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/deflate.c | 405 ++++++++++++++++++++++++-----------------------
 1 file changed, 208 insertions(+), 197 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index 5c346c544093..bc76c343a0cf 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -6,246 +6,255 @@
  * by IPCOMP (RFC 3173 & RFC 2394).
  *
  * Copyright (c) 2003 James Morris <jmorris@intercode.com.au>
- *
- * FIXME: deflate transforms will require up to a total of about 436k of kernel
- * memory on i386 (390k for compression, the rest for decompression), as the
- * current zlib kernel code uses a worst case pre-allocation system by default.
- * This needs to be fixed so that the amount of memory required is properly
- * related to the  winbits and memlevel parameters.
- *
- * The default winbits of 11 should suit most packets, and it may be something
- * to configure on a per-tfm basis in the future.
- *
- * Currently, compression history is not maintained between tfm calls, as
- * it is not needed for IPCOMP and keeps the code simpler.  It can be
- * implemented if someone wants it.
+ * Copyright (c) 2023 Google, LLC. <ardb@kernel.org>
+ * Copyright (c) 2025 Herbert Xu <herbert@gondor.apana.org.au>
  */
+#include <crypto/internal/acompress.h>
+#include <crypto/scatterwalk.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/crypto.h>
+#include <linux/mutex.h>
+#include <linux/percpu.h>
+#include <linux/scatterlist.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
 #include <linux/zlib.h>
-#include <linux/vmalloc.h>
-#include <linux/interrupt.h>
-#include <linux/mm.h>
-#include <linux/net.h>
-#include <crypto/internal/scompress.h>
 
 #define DEFLATE_DEF_LEVEL		Z_DEFAULT_COMPRESSION
 #define DEFLATE_DEF_WINBITS		11
 #define DEFLATE_DEF_MEMLEVEL		MAX_MEM_LEVEL
 
-struct deflate_ctx {
-	struct z_stream_s comp_stream;
-	struct z_stream_s decomp_stream;
+struct deflate_stream {
+	struct z_stream_s stream;
+	u8 workspace[];
 };
 
-static int deflate_comp_init(struct deflate_ctx *ctx)
+static DEFINE_MUTEX(deflate_stream_lock);
+
+static void *deflate_alloc_stream(void)
 {
-	int ret = 0;
-	struct z_stream_s *stream = &ctx->comp_stream;
+	size_t size = max(zlib_inflate_workspacesize(),
+			  zlib_deflate_workspacesize(-DEFLATE_DEF_WINBITS,
+						     DEFLATE_DEF_MEMLEVEL));
+	struct deflate_stream *ctx;
 
-	stream->workspace = vzalloc(zlib_deflate_workspacesize(
-				    -DEFLATE_DEF_WINBITS, MAX_MEM_LEVEL));
-	if (!stream->workspace) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	ret = zlib_deflateInit2(stream, DEFLATE_DEF_LEVEL, Z_DEFLATED,
-				-DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
-				Z_DEFAULT_STRATEGY);
-	if (ret != Z_OK) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-out:
-	return ret;
-out_free:
-	vfree(stream->workspace);
-	goto out;
-}
-
-static int deflate_decomp_init(struct deflate_ctx *ctx)
-{
-	int ret = 0;
-	struct z_stream_s *stream = &ctx->decomp_stream;
-
-	stream->workspace = vzalloc(zlib_inflate_workspacesize());
-	if (!stream->workspace) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	ret = zlib_inflateInit2(stream, -DEFLATE_DEF_WINBITS);
-	if (ret != Z_OK) {
-		ret = -EINVAL;
-		goto out_free;
-	}
-out:
-	return ret;
-out_free:
-	vfree(stream->workspace);
-	goto out;
-}
-
-static void deflate_comp_exit(struct deflate_ctx *ctx)
-{
-	zlib_deflateEnd(&ctx->comp_stream);
-	vfree(ctx->comp_stream.workspace);
-}
-
-static void deflate_decomp_exit(struct deflate_ctx *ctx)
-{
-	zlib_inflateEnd(&ctx->decomp_stream);
-	vfree(ctx->decomp_stream.workspace);
-}
-
-static int __deflate_init(void *ctx)
-{
-	int ret;
-
-	ret = deflate_comp_init(ctx);
-	if (ret)
-		goto out;
-	ret = deflate_decomp_init(ctx);
-	if (ret)
-		deflate_comp_exit(ctx);
-out:
-	return ret;
-}
-
-static void *deflate_alloc_ctx(void)
-{
-	struct deflate_ctx *ctx;
-	int ret;
-
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	ctx = kvmalloc(sizeof(*ctx) + size, GFP_KERNEL);
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	ret = __deflate_init(ctx);
-	if (ret) {
-		kfree(ctx);
-		return ERR_PTR(ret);
-	}
+	ctx->stream.workspace = ctx->workspace;
 
 	return ctx;
 }
 
-static void __deflate_exit(void *ctx)
+static struct crypto_acomp_streams deflate_streams = {
+	.alloc_ctx = deflate_alloc_stream,
+	.cfree_ctx = kvfree,
+};
+
+static int deflate_compress_one(struct acomp_req *req,
+				struct deflate_stream *ds)
 {
-	deflate_comp_exit(ctx);
-	deflate_decomp_exit(ctx);
+	struct z_stream_s *stream = &ds->stream;
+	struct acomp_walk walk;
+	int ret;
+
+	ret = acomp_walk_virt(&walk, req);
+	if (ret)
+		return ret;
+
+	do {
+		unsigned int dcur;
+
+		dcur = acomp_walk_next_dst(&walk);
+		if (!dcur)
+			return -ENOSPC;
+
+		stream->avail_out = dcur;
+		stream->next_out = walk.dst.virt.addr;
+
+		do {
+			int flush = Z_FINISH;
+			unsigned int scur;
+
+			stream->avail_in = 0;
+			stream->next_in = NULL;
+
+			scur = acomp_walk_next_src(&walk);
+			if (scur) {
+				if (acomp_walk_more_src(&walk, scur))
+					flush = Z_NO_FLUSH;
+				stream->avail_in = scur;
+				stream->next_in = walk.src.virt.addr;
+			}
+
+			ret = zlib_deflate(stream, flush);
+
+			if (scur) {
+				scur -= stream->avail_in;
+				acomp_walk_done_src(&walk, scur);
+			}
+		} while (ret == Z_OK && stream->avail_out);
+
+		acomp_walk_done_dst(&walk, dcur);
+	} while (ret == Z_OK);
+
+	if (ret != Z_STREAM_END)
+		return -EINVAL;
+
+	req->dlen = stream->total_out;
+	return 0;
 }
 
-static void deflate_free_ctx(void *ctx)
+static int deflate_compress(struct acomp_req *req)
 {
-	__deflate_exit(ctx);
-	kfree_sensitive(ctx);
-}
+	struct crypto_acomp_stream *s;
+	struct deflate_stream *ds;
+	struct acomp_req *r2;
+	int err;
 
-static int __deflate_compress(const u8 *src, unsigned int slen,
-			      u8 *dst, unsigned int *dlen, void *ctx)
-{
-	int ret = 0;
-	struct deflate_ctx *dctx = ctx;
-	struct z_stream_s *stream = &dctx->comp_stream;
+	s = crypto_acomp_lock_stream_bh(&deflate_streams);
+	ds = s->ctx;
 
-	ret = zlib_deflateReset(stream);
-	if (ret != Z_OK) {
-		ret = -EINVAL;
+	err = zlib_deflateInit2(&ds->stream, DEFLATE_DEF_LEVEL, Z_DEFLATED,
+				-DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
+				Z_DEFAULT_STRATEGY);
+	if (err != Z_OK) {
+		err = -EINVAL;
 		goto out;
 	}
 
-	stream->next_in = (u8 *)src;
-	stream->avail_in = slen;
-	stream->next_out = (u8 *)dst;
-	stream->avail_out = *dlen;
+	err = deflate_compress_one(req, ds);
+	req->base.err = err;
 
-	ret = zlib_deflate(stream, Z_FINISH);
-	if (ret != Z_STREAM_END) {
-		ret = -EINVAL;
-		goto out;
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		zlib_deflateReset(&ds->stream);
+		r2->base.err = deflate_compress_one(r2, ds);
 	}
-	ret = 0;
-	*dlen = stream->total_out;
+
 out:
+	crypto_acomp_unlock_stream_bh(s);
+
+	return err;
+}
+
+static int deflate_decompress_one(struct acomp_req *req,
+				  struct deflate_stream *ds)
+{
+	struct z_stream_s *stream = &ds->stream;
+	bool out_of_space = false;
+	struct acomp_walk walk;
+	int ret;
+
+	ret = acomp_walk_virt(&walk, req);
+	if (ret)
+		return ret;
+
+	do {
+		unsigned int scur;
+
+		stream->avail_in = 0;
+		stream->next_in = NULL;
+
+		scur = acomp_walk_next_src(&walk);
+		if (scur) {
+			stream->avail_in = scur;
+			stream->next_in = walk.src.virt.addr;
+		}
+
+		do {
+			unsigned int dcur;
+
+			dcur = acomp_walk_next_dst(&walk);
+			if (!dcur) {
+				out_of_space = true;
+				break;
+			}
+
+			stream->avail_out = dcur;
+			stream->next_out = walk.dst.virt.addr;
+
+			ret = zlib_inflate(stream, Z_NO_FLUSH);
+
+			dcur -= stream->avail_out;
+			acomp_walk_done_dst(&walk, dcur);
+		} while (ret == Z_OK && stream->avail_in);
+
+		if (scur)
+			acomp_walk_done_src(&walk, scur);
+
+		if (out_of_space)
+			return -ENOSPC;
+	} while (ret == Z_OK);
+
+	if (ret != Z_STREAM_END)
+		return -EINVAL;
+
+	req->dlen = stream->total_out;
+	return 0;
+}
+
+static int deflate_decompress(struct acomp_req *req)
+{
+	struct crypto_acomp_stream *s;
+	struct deflate_stream *ds;
+	struct acomp_req *r2;
+	int err;
+
+	s = crypto_acomp_lock_stream_bh(&deflate_streams);
+	ds = s->ctx;
+
+	err = zlib_inflateInit2(&ds->stream, -DEFLATE_DEF_WINBITS);
+	if (err != Z_OK) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = deflate_decompress_one(req, ds);
+	req->base.err = err;
+
+	list_for_each_entry(r2, &req->base.list, base.list) {
+		zlib_inflateReset(&ds->stream);
+		r2->base.err = deflate_decompress_one(r2, ds);
+	}
+
+out:
+	crypto_acomp_unlock_stream_bh(s);
+
+	return err;
+}
+
+static int deflate_init(struct crypto_acomp *tfm)
+{
+	int ret;
+
+	mutex_lock(&deflate_stream_lock);
+	ret = crypto_acomp_alloc_streams(&deflate_streams);
+	mutex_unlock(&deflate_stream_lock);
+
 	return ret;
 }
 
-static int deflate_scompress(struct crypto_scomp *tfm, const u8 *src,
-			     unsigned int slen, u8 *dst, unsigned int *dlen,
-			     void *ctx)
-{
-	return __deflate_compress(src, slen, dst, dlen, ctx);
-}
-
-static int __deflate_decompress(const u8 *src, unsigned int slen,
-				u8 *dst, unsigned int *dlen, void *ctx)
-{
-
-	int ret = 0;
-	struct deflate_ctx *dctx = ctx;
-	struct z_stream_s *stream = &dctx->decomp_stream;
-
-	ret = zlib_inflateReset(stream);
-	if (ret != Z_OK) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	stream->next_in = (u8 *)src;
-	stream->avail_in = slen;
-	stream->next_out = (u8 *)dst;
-	stream->avail_out = *dlen;
-
-	ret = zlib_inflate(stream, Z_SYNC_FLUSH);
-	/*
-	 * Work around a bug in zlib, which sometimes wants to taste an extra
-	 * byte when being used in the (undocumented) raw deflate mode.
-	 * (From USAGI).
-	 */
-	if (ret == Z_OK && !stream->avail_in && stream->avail_out) {
-		u8 zerostuff = 0;
-		stream->next_in = &zerostuff;
-		stream->avail_in = 1;
-		ret = zlib_inflate(stream, Z_FINISH);
-	}
-	if (ret != Z_STREAM_END) {
-		ret = -EINVAL;
-		goto out;
-	}
-	ret = 0;
-	*dlen = stream->total_out;
-out:
-	return ret;
-}
-
-static int deflate_sdecompress(struct crypto_scomp *tfm, const u8 *src,
-			       unsigned int slen, u8 *dst, unsigned int *dlen,
-			       void *ctx)
-{
-	return __deflate_decompress(src, slen, dst, dlen, ctx);
-}
-
-static struct scomp_alg scomp = {
-	.alloc_ctx		= deflate_alloc_ctx,
-	.free_ctx		= deflate_free_ctx,
-	.compress		= deflate_scompress,
-	.decompress		= deflate_sdecompress,
-	.base			= {
-		.cra_name	= "deflate",
-		.cra_driver_name = "deflate-scomp",
-		.cra_module	 = THIS_MODULE,
-	}
+static struct acomp_alg acomp = {
+	.compress		= deflate_compress,
+	.decompress		= deflate_decompress,
+	.init			= deflate_init,
+	.base.cra_name		= "deflate",
+	.base.cra_driver_name	= "deflate-generic",
+	.base.cra_flags		= CRYPTO_ALG_REQ_CHAIN,
+	.base.cra_module	= THIS_MODULE,
 };
 
 static int __init deflate_mod_init(void)
 {
-	return crypto_register_scomp(&scomp);
+	return crypto_register_acomp(&acomp);
 }
 
 static void __exit deflate_mod_fini(void)
 {
-	crypto_unregister_scomp(&scomp);
+	crypto_unregister_acomp(&acomp);
+	crypto_acomp_free_streams(&deflate_streams);
 }
 
 subsys_initcall(deflate_mod_init);
@@ -254,5 +263,7 @@ module_exit(deflate_mod_fini);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Deflate Compression Algorithm for IPCOMP");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
+MODULE_AUTHOR("Ard Biesheuvel <ardb@kernel.org>");
+MODULE_AUTHOR("Herbert Xu <herbert@gondor.apana.org.au>");
 MODULE_ALIAS_CRYPTO("deflate");
 MODULE_ALIAS_CRYPTO("deflate-generic");
-- 
2.39.5

