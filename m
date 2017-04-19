From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/2] crypto: acomp - add support for deflate rfc1950 (zlib)
Date: Wed, 19 Apr 2017 15:11:42 +0100
Message-ID: <20170419141142.3678-2-giovanni.cabiddu@intel.com>
References: <20170419141142.3678-1-giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, weigang.li@intel.com,
        giovanni.cabiddu@gmail.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:59504 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934727AbdDSOMC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Apr 2017 10:12:02 -0400
In-Reply-To: <20170419141142.3678-1-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add scomp backend for zlib-deflate compression algorithm.
This backend outputs data using the format defined in rfc1950
(raw deflate surrounded by zlib header and footer).

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 crypto/deflate.c | 61 ++++++++++++++++++++++++++++++++-------------
 crypto/testmgr.c | 10 ++++++++
 crypto/testmgr.h | 75 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 129 insertions(+), 17 deletions(-)

diff --git a/crypto/deflate.c b/crypto/deflate.c
index f942cb3..647f2e5 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -43,20 +43,24 @@ struct deflate_ctx {
 	struct z_stream_s decomp_stream;
 };
 
-static int deflate_comp_init(struct deflate_ctx *ctx)
+static int deflate_comp_init(struct deflate_ctx *ctx, int format)
 {
 	int ret = 0;
 	struct z_stream_s *stream = &ctx->comp_stream;
 
 	stream->workspace = vzalloc(zlib_deflate_workspacesize(
-				-DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL));
+				    MAX_WBITS, MAX_MEM_LEVEL));
 	if (!stream->workspace) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	ret = zlib_deflateInit2(stream, DEFLATE_DEF_LEVEL, Z_DEFLATED,
-	                        -DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
-	                        Z_DEFAULT_STRATEGY);
+	if (format)
+		ret = zlib_deflateInit(stream, 3);
+	else
+		ret = zlib_deflateInit2(stream, DEFLATE_DEF_LEVEL, Z_DEFLATED,
+					-DEFLATE_DEF_WINBITS,
+					DEFLATE_DEF_MEMLEVEL,
+					Z_DEFAULT_STRATEGY);
 	if (ret != Z_OK) {
 		ret = -EINVAL;
 		goto out_free;
@@ -68,7 +72,7 @@ static int deflate_comp_init(struct deflate_ctx *ctx)
 	goto out;
 }
 
-static int deflate_decomp_init(struct deflate_ctx *ctx)
+static int deflate_decomp_init(struct deflate_ctx *ctx, int format)
 {
 	int ret = 0;
 	struct z_stream_s *stream = &ctx->decomp_stream;
@@ -78,7 +82,10 @@ static int deflate_decomp_init(struct deflate_ctx *ctx)
 		ret = -ENOMEM;
 		goto out;
 	}
-	ret = zlib_inflateInit2(stream, -DEFLATE_DEF_WINBITS);
+	if (format)
+		ret = zlib_inflateInit(stream);
+	else
+		ret = zlib_inflateInit2(stream, -DEFLATE_DEF_WINBITS);
 	if (ret != Z_OK) {
 		ret = -EINVAL;
 		goto out_free;
@@ -102,21 +109,21 @@ static void deflate_decomp_exit(struct deflate_ctx *ctx)
 	vfree(ctx->decomp_stream.workspace);
 }
 
-static int __deflate_init(void *ctx)
+static int __deflate_init(void *ctx, int format)
 {
 	int ret;
 
-	ret = deflate_comp_init(ctx);
+	ret = deflate_comp_init(ctx, format);
 	if (ret)
 		goto out;
-	ret = deflate_decomp_init(ctx);
+	ret = deflate_decomp_init(ctx, format);
 	if (ret)
 		deflate_comp_exit(ctx);
 out:
 	return ret;
 }
 
-static void *deflate_alloc_ctx(struct crypto_scomp *tfm)
+static void *gen_deflate_alloc_ctx(struct crypto_scomp *tfm, int format)
 {
 	struct deflate_ctx *ctx;
 	int ret;
@@ -125,7 +132,7 @@ static void *deflate_alloc_ctx(struct crypto_scomp *tfm)
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	ret = __deflate_init(ctx);
+	ret = __deflate_init(ctx, format);
 	if (ret) {
 		kfree(ctx);
 		return ERR_PTR(ret);
@@ -134,11 +141,21 @@ static void *deflate_alloc_ctx(struct crypto_scomp *tfm)
 	return ctx;
 }
 
+static void *deflate_alloc_ctx(struct crypto_scomp *tfm)
+{
+	return gen_deflate_alloc_ctx(tfm, 0);
+}
+
+static void *zlib_deflate_alloc_ctx(struct crypto_scomp *tfm)
+{
+	return gen_deflate_alloc_ctx(tfm, 1);
+}
+
 static int deflate_init(struct crypto_tfm *tfm)
 {
 	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	return __deflate_init(ctx);
+	return __deflate_init(ctx, 0);
 }
 
 static void __deflate_exit(void *ctx)
@@ -272,7 +289,7 @@ static struct crypto_alg alg = {
 	.coa_decompress  	= deflate_decompress } }
 };
 
-static struct scomp_alg scomp = {
+static struct scomp_alg scomp[] = { {
 	.alloc_ctx		= deflate_alloc_ctx,
 	.free_ctx		= deflate_free_ctx,
 	.compress		= deflate_scompress,
@@ -282,7 +299,17 @@ static struct scomp_alg scomp = {
 		.cra_driver_name = "deflate-scomp",
 		.cra_module	 = THIS_MODULE,
 	}
-};
+}, {
+	.alloc_ctx		= zlib_deflate_alloc_ctx,
+	.free_ctx		= deflate_free_ctx,
+	.compress		= deflate_scompress,
+	.decompress		= deflate_sdecompress,
+	.base			= {
+		.cra_name	= "zlib(deflate)",
+		.cra_driver_name = "deflate-rfc1950-scomp",
+		.cra_module	 = THIS_MODULE,
+	}
+} };
 
 static int __init deflate_mod_init(void)
 {
@@ -292,7 +319,7 @@ static int __init deflate_mod_init(void)
 	if (ret)
 		return ret;
 
-	ret = crypto_register_scomp(&scomp);
+	ret = crypto_register_scomps(scomp, ARRAY_SIZE(scomp));
 	if (ret) {
 		crypto_unregister_alg(&alg);
 		return ret;
@@ -304,7 +331,7 @@ static int __init deflate_mod_init(void)
 static void __exit deflate_mod_fini(void)
 {
 	crypto_unregister_alg(&alg);
-	crypto_unregister_scomp(&scomp);
+	crypto_unregister_scomps(scomp, ARRAY_SIZE(scomp));
 }
 
 module_init(deflate_mod_init);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index cd075c7..b687cf7 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3489,6 +3489,16 @@ static const struct alg_test_desc alg_test_descs[] = {
 				.dec = __VECS(tf_xts_dec_tv_template)
 			}
 		}
+	}, {
+		.alg = "zlib(deflate)",
+		.test = alg_test_comp,
+		.fips_allowed = 1,
+		.suite = {
+			.comp = {
+				.comp = __VECS(zlib_deflate_comp_tv_template),
+				.decomp = __VECS(zlib_deflate_decomp_tv_template)
+			}
+		}
 	}
 };
 
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 15c043f..4293573 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -33204,6 +33204,81 @@ static const struct comp_testvec deflate_decomp_tv_template[] = {
 	},
 };
 
+static const struct comp_testvec zlib_deflate_comp_tv_template[] = {
+	{
+		.inlen	= 70,
+		.outlen	= 44,
+		.input	= "Join us now and share the software "
+			"Join us now and share the software ",
+		.output	= "\x78\x5e\xf3\xca\xcf\xcc\x53\x28"
+			  "\x2d\x56\xc8\xcb\x2f\x57\x48\xcc"
+			  "\x4b\x51\x28\xce\x48\x2c\x4a\x55"
+			  "\x28\xc9\x48\x55\x28\xce\x4f\x2b"
+			  "\x29\x07\x71\xbc\x08\x2b\x01\x00"
+			  "\x7c\x65\x19\x3d",
+	}, {
+		.inlen	= 191,
+		.outlen	= 129,
+		.input	= "This document describes a compression method based on the DEFLATE"
+			"compression algorithm.  This document defines the application of "
+			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
+		.output	= "\x78\x5e\x5d\xce\x41\x0a\xc3\x30"
+			  "\x0c\x04\xc0\xaf\xec\x0b\xf2\x87"
+			  "\xd2\xa6\x50\xe8\xc1\x07\x7f\x40"
+			  "\xb1\x95\x5a\x60\x5b\xc6\x56\x0f"
+			  "\xfd\x7d\x93\x1e\x42\xe8\x51\xec"
+			  "\xee\x20\x9f\x64\x20\x6a\x78\x17"
+			  "\xae\x86\xc8\x23\x74\x59\x78\x80"
+			  "\x10\xb4\xb4\xce\x63\x88\x56\x14"
+			  "\xb6\xa4\x11\x0b\x0d\x8e\xd8\x6e"
+			  "\x4b\x8c\xdb\x7c\x7f\x5e\xfc\x7c"
+			  "\xae\x51\x7e\x69\x17\x4b\x65\x02"
+			  "\xfc\x1f\xbc\x4a\xdd\xd8\x7d\x48"
+			  "\xad\x65\x09\x64\x3b\xac\xeb\xd9"
+			  "\xc2\x01\xc0\xf4\x17\x3c\x1c\x1c"
+			  "\x7d\xb2\x52\xc4\xf5\xf4\x8f\xeb"
+			  "\x6a\x1a\x34\x4f\x5f\x2e\x32\x45"
+			  "\x4e",
+	},
+};
+
+static const struct comp_testvec zlib_deflate_decomp_tv_template[] = {
+	{
+		.inlen	= 128,
+		.outlen	= 191,
+		.input	= "\x78\x9c\x5d\x8d\x31\x0e\xc2\x30"
+			  "\x10\x04\xbf\xb2\x2f\xc8\x1f\x10"
+			  "\x04\x09\x89\xc2\x85\x3f\x70\xb1"
+			  "\x2f\xf8\x24\xdb\x67\xd9\x47\xc1"
+			  "\xef\x49\x68\x12\x51\xae\x76\x67"
+			  "\xd6\x27\x19\x88\x1a\xde\x85\xab"
+			  "\x21\xf2\x08\x5d\x16\x1e\x20\x04"
+			  "\x2d\xad\xf3\x18\xa2\x15\x85\x2d"
+			  "\x69\xc4\x42\x83\x23\xb6\x6c\x89"
+			  "\x71\x9b\xef\xcf\x8b\x9f\xcf\x33"
+			  "\xca\x2f\xed\x62\xa9\x4c\x80\xff"
+			  "\x13\xaf\x52\x37\xed\x0e\x52\x6b"
+			  "\x59\x02\xd9\x4e\xe8\x7a\x76\x1d"
+			  "\x02\x98\xfe\x8a\x87\x83\xa3\x4f"
+			  "\x56\x8a\xb8\x9e\x8e\x5c\x57\xd3"
+			  "\xa0\x79\xfa\x02\x2e\x32\x45\x4e",
+		.output	= "This document describes a compression method based on the DEFLATE"
+			"compression algorithm.  This document defines the application of "
+			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
+	}, {
+		.inlen	= 44,
+		.outlen	= 70,
+		.input	= "\x78\x9c\xf3\xca\xcf\xcc\x53\x28"
+			  "\x2d\x56\xc8\xcb\x2f\x57\x48\xcc"
+			  "\x4b\x51\x28\xce\x48\x2c\x4a\x55"
+			  "\x28\xc9\x48\x55\x28\xce\x4f\x2b"
+			  "\x29\x07\x71\xbc\x08\x2b\x01\x00"
+			  "\x7c\x65\x19\x3d",
+		.output	= "Join us now and share the software "
+			"Join us now and share the software ",
+	},
+};
+
 /*
  * LZO test vectors (null-terminated strings).
  */
-- 
2.9.3
