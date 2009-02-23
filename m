From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] crypto: compress - Add pcomp interface
Date: Mon, 23 Feb 2009 18:32:19 +0100 (CET)
Message-ID: <alpine.LRH.2.00.0902231822080.22762@vixen.sonytel.be>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <20090114031613.GA7429@gondor.apana.org.au> <Pine.LNX.4.64.0901141528010.31703@vixen.sonytel.be>
 <20090115030526.GA27726@gondor.apana.org.au> <alpine.LRH.2.00.0902051703150.4290@vixen.sonytel.be> <20090210061822.GA19774@gondor.apana.org.au> <alpine.LRH.2.00.0902121613580.29413@vixen.sonytel.be> <20090219040847.GA973@gondor.apana.org.au>
 <alpine.LRH.2.00.0902191005110.27630@vixen.sonytel.be> <20090219104250.GA9633@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:54335 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752011AbZBWRcY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Feb 2009 12:32:24 -0500
In-Reply-To: <20090219104250.GA9633@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

	Hi Herbert,

On Thu, 19 Feb 2009, Herbert Xu wrote:
> On Thu, Feb 19, 2009 at 10:12:18AM +0100, Geert Uytterhoeven wrote:
> > IIUC, my setup() routines should decode the parameters using nla_pa=
rse()?
>=20
> Right.
>=20
> > And the caller of a setup() routine should encode the data. But how=
? All the
> > nla_put*() routines seem to be targeted at skb's.
>=20
> The callers in the kernel should just lay it out on the stack, e.g.,
>=20
> 	struct {
> 		struct nlattr foo;
> 		u32 foo_val;
> 		struct nlattr bar;
> 		u32 bar_val;
> 		...
> 	};
>=20
> Note that the netlink alignment is 4 so u32 doesn't need any padding
> though u8/u16 would need padding before the next nlattr.  Although
> for our purposes u32 should be sufficient.
>=20
> > The only place where nla_parse() is called with a void */length pai=
r is
> > net/sched/em_meta.c:em_meta_change(). But I can find no place where=
 the actual
> > TCA_EM_META_* fields are encoded.
>=20
> For simple things like u32 the format is just header followed by
> the u32.  See nla_get_u32 for details.

Is the below (on top of my last patch series) what you have in mind?

Notes:
  - I had to drop the `const' from the `params' pointers of
    pcomp_alg.{,de}compress_setup().
    Trying to make nla_parse() take const nlattr structures instead see=
ms to
    open a big can of worms...
  - I should add a dependency of CONFIG_CRYPTO_ZLIB on CONFIG_NET (due =
to the
    need for nla_parse()). However, I don't like that.

Thanks for your comments!

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 4703137..b50c3c6 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -919,7 +919,8 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 	for (i =3D 0; i < ctcount; i++) {
 		struct comp_request req;
=20
-		error =3D crypto_compress_setup(tfm, ctemplate[i].params);
+		error =3D crypto_compress_setup(tfm, ctemplate[i].params,
+					      ctemplate[i].paramsize);
 		if (error) {
 			pr_err("alg: pcomp: compression setup failed on test "
 			       "%d for %s: error=3D%d\n", i + 1, algo, error);
@@ -986,7 +987,8 @@ static int test_pcomp(struct crypto_pcomp *tfm,
 	for (i =3D 0; i < dtcount; i++) {
 		struct comp_request req;
=20
-		error =3D crypto_decompress_setup(tfm, dtemplate[i].params);
+		error =3D crypto_decompress_setup(tfm, dtemplate[i].params,
+						dtemplate[i].paramsize);
 		if (error) {
 			pr_err("alg: pcomp: decompression setup failed on "
 			       "test %d for %s: error=3D%d\n", i + 1, algo,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 098c033..526f00a 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -15,7 +15,9 @@
 #ifndef _CRYPTO_TESTMGR_H
 #define _CRYPTO_TESTMGR_H
=20
+#include <linux/netlink.h>
 #include <linux/zlib.h>
+
 #include <crypto/compress.h>
=20
 #define MAX_DIGEST_SIZE		64
@@ -8351,7 +8353,8 @@ struct comp_testvec {
 };
=20
 struct pcomp_testvec {
-	const void *params;
+	void *params;
+	unsigned int paramsize;
 	int inlen, outlen;
 	char input[COMP_BUF_SIZE];
 	char output[COMP_BUF_SIZE];
@@ -8440,21 +8443,60 @@ static struct comp_testvec deflate_decomp_tv_te=
mplate[] =3D {
 #define ZLIB_COMP_TEST_VECTORS 2
 #define ZLIB_DECOMP_TEST_VECTORS 2
=20
-static const struct zlib_comp_params deflate_comp_params =3D {
-	.level			=3D Z_DEFAULT_COMPRESSION,
-	.method			=3D Z_DEFLATED,
-	.windowBits		=3D -11,
-	.memLevel		=3D MAX_MEM_LEVEL,
-	.strategy		=3D Z_DEFAULT_STRATEGY
+static const struct {
+	struct nlattr nla;
+	int val;
+} deflate_comp_params[] =3D {
+	{
+		.nla =3D {
+			.nla_len	=3D NLA_HDRLEN + sizeof(int),
+			.nla_type	=3D ZLIB_COMP_LEVEL,
+		},
+		.val			=3D Z_DEFAULT_COMPRESSION,
+	}, {
+		.nla =3D {
+			.nla_len	=3D NLA_HDRLEN + sizeof(int),
+			.nla_type	=3D ZLIB_COMP_METHOD,
+		},
+		.val			=3D Z_DEFLATED,
+	}, {
+		.nla =3D {
+			.nla_len	=3D NLA_HDRLEN + sizeof(int),
+			.nla_type	=3D ZLIB_COMP_WINDOWBITS,
+		},
+		.val			=3D -11,
+	}, {
+		.nla =3D {
+			.nla_len	=3D NLA_HDRLEN + sizeof(int),
+			.nla_type	=3D ZLIB_COMP_MEMLEVEL,
+		},
+		.val			=3D MAX_MEM_LEVEL,
+	}, {
+		.nla =3D {
+			.nla_len	=3D NLA_HDRLEN + sizeof(int),
+			.nla_type	=3D ZLIB_COMP_STRATEGY,
+		},
+		.val			=3D Z_DEFAULT_STRATEGY,
+	}
 };
=20
-static const struct zlib_decomp_params deflate_decomp_params =3D {
-	.windowBits		=3D -11,
+static const struct {
+	struct nlattr nla;
+	int val;
+} deflate_decomp_params[] =3D {
+	{
+		.nla =3D {
+			.nla_len	=3D NLA_HDRLEN + sizeof(int),
+			.nla_type	=3D ZLIB_DECOMP_WINDOWBITS,
+		},
+		.val			=3D -11,
+	}
 };
=20
 static struct pcomp_testvec zlib_comp_tv_template[] =3D {
 	{
 		.params =3D &deflate_comp_params,
+		.paramsize =3D sizeof(deflate_comp_params),
 		.inlen	=3D 70,
 		.outlen	=3D 38,
 		.input	=3D "Join us now and share the software "
@@ -8466,6 +8508,7 @@ static struct pcomp_testvec zlib_comp_tv_template=
[] =3D {
 			  "\x71\xbc\x08\x2b\x01\x00",
 	}, {
 		.params =3D &deflate_comp_params,
+		.paramsize =3D sizeof(deflate_comp_params),
 		.inlen	=3D 191,
 		.outlen	=3D 122,
 		.input	=3D "This document describes a compression method based on th=
e DEFLATE"
@@ -8493,6 +8536,7 @@ static struct pcomp_testvec zlib_comp_tv_template=
[] =3D {
 static struct pcomp_testvec zlib_decomp_tv_template[] =3D {
 	{
 		.params =3D &deflate_decomp_params,
+		.paramsize =3D sizeof(deflate_decomp_params),
 		.inlen	=3D 122,
 		.outlen	=3D 191,
 		.input	=3D "\x5d\x8d\x31\x0e\xc2\x30\x10\x04"
@@ -8516,6 +8560,7 @@ static struct pcomp_testvec zlib_decomp_tv_templa=
te[] =3D {
 			"the DEFLATE algorithm to the IP Payload Compression Protocol.",
 	}, {
 		.params =3D &deflate_decomp_params,
+		.paramsize =3D sizeof(deflate_decomp_params),
 		.inlen	=3D 38,
 		.outlen	=3D 70,
 		.input	=3D "\xf3\xca\xcf\xcc\x53\x28\x2d\x56"
diff --git a/crypto/zlib.c b/crypto/zlib.c
index 77b865d..33609ba 100644
--- a/crypto/zlib.c
+++ b/crypto/zlib.c
@@ -33,11 +33,13 @@
=20
 #include <crypto/internal/compress.h>
=20
+#include <net/netlink.h>
+
=20
 struct zlib_ctx {
-	struct zlib_decomp_params decomp_params;
 	struct z_stream_s comp_stream;
 	struct z_stream_s decomp_stream;
+	int decomp_windowBits;
 };
=20
=20
@@ -77,13 +79,18 @@ static void zlib_exit(struct crypto_tfm *tfm)
 }
=20
=20
-static int zlib_compress_setup(struct crypto_pcomp *tfm, const void *p=
arams)
+static int zlib_compress_setup(struct crypto_pcomp *tfm, void *params,
+			       unsigned int len)
 {
 	struct zlib_ctx *ctx =3D crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	const struct zlib_comp_params *zparams =3D params;
 	struct z_stream_s *stream =3D &ctx->comp_stream;
+	struct nlattr *tb[ZLIB_COMP_MAX + 1];
 	size_t workspacesize;
-	int ret =3D 0;
+	int ret;
+
+	ret =3D nla_parse(tb, ZLIB_COMP_MAX, params, len, NULL);
+	if (ret)
+		return ret;
=20
 	zlib_comp_exit(ctx);
=20
@@ -93,9 +100,22 @@ static int zlib_compress_setup(struct crypto_pcomp =
*tfm, const void *params)
 		return -ENOMEM;
=20
 	memset(stream->workspace, 0, workspacesize);
-	ret =3D zlib_deflateInit2(stream, zparams->level, zparams->method,
-				zparams->windowBits, zparams->memLevel,
-				zparams->strategy);
+	ret =3D zlib_deflateInit2(stream,
+				tb[ZLIB_COMP_LEVEL]
+					? nla_get_u32(tb[ZLIB_COMP_LEVEL])
+					: Z_DEFAULT_COMPRESSION,
+				tb[ZLIB_COMP_METHOD]
+					? nla_get_u32(tb[ZLIB_COMP_METHOD])
+					: Z_DEFLATED,
+				tb[ZLIB_COMP_WINDOWBITS]
+					? nla_get_u32(tb[ZLIB_COMP_WINDOWBITS])
+					: MAX_WBITS,
+				tb[ZLIB_COMP_MEMLEVEL]
+					? nla_get_u32(tb[ZLIB_COMP_MEMLEVEL])
+					: DEF_MEM_LEVEL,
+				tb[ZLIB_COMP_STRATEGY]
+					? nla_get_u32(tb[ZLIB_COMP_STRATEGY])
+					: Z_DEFAULT_STRATEGY);
 	if (ret !=3D Z_OK) {
 		vfree(stream->workspace);
 		stream->workspace =3D NULL;
@@ -187,22 +207,29 @@ static int zlib_compress_final(struct crypto_pcom=
p *tfm,
 }
=20
=20
-static int zlib_decompress_setup(struct crypto_pcomp *tfm, const void =
*params)
+static int zlib_decompress_setup(struct crypto_pcomp *tfm, void *param=
s,
+				 unsigned int len)
 {
 	struct zlib_ctx *ctx =3D crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	const struct zlib_decomp_params *zparams =3D params;
 	struct z_stream_s *stream =3D &ctx->decomp_stream;
+	struct nlattr *tb[ZLIB_DECOMP_MAX + 1];
 	int ret =3D 0;
=20
+	ret =3D nla_parse(tb, ZLIB_DECOMP_MAX, params, len, NULL);
+	if (ret)
+		return ret;
+
 	zlib_decomp_exit(ctx);
=20
-	ctx->decomp_params =3D *zparams;
+	ctx->decomp_windowBits =3D tb[ZLIB_DECOMP_WINDOWBITS]
+				 ? nla_get_u32(tb[ZLIB_DECOMP_WINDOWBITS])
+				 : DEF_WBITS;
=20
 	stream->workspace =3D kzalloc(zlib_inflate_workspacesize(), GFP_KERNE=
L);
 	if (!stream->workspace)
 		return -ENOMEM;
=20
-	ret =3D zlib_inflateInit2(stream, zparams->windowBits);
+	ret =3D zlib_inflateInit2(stream, ctx->decomp_windowBits);
 	if (ret !=3D Z_OK) {
 		kfree(stream->workspace);
 		stream->workspace =3D NULL;
@@ -277,7 +304,7 @@ static int zlib_decompress_final(struct crypto_pcom=
p *tfm,
 	stream->next_out =3D req->next_out;
 	stream->avail_out =3D req->avail_out;
=20
-	if (dctx->decomp_params.windowBits < 0) {
+	if (dctx->decomp_windowBits < 0) {
 		ret =3D zlib_inflate(stream, Z_SYNC_FLUSH);
 		/*
 		 * Work around a bug in zlib, which sometimes wants to taste an
diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 12ed86d..62be5ae 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -39,6 +39,8 @@
=20
 #include <crypto/compress.h>
=20
+#include <net/netlink.h>
+
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
@@ -81,7 +83,16 @@ static int squashfs_fill_super(struct super_block *s=
b, void *data, int silent)
 	unsigned short flags;
 	unsigned int fragments;
 	u64 lookup_table_start;
-	struct zlib_decomp_params params =3D { .windowBits =3D DEF_WBITS };
+	struct {
+		struct nlattr nla;
+		int val;
+	} params =3D {
+		.nla =3D {
+			.nla_len	=3D nla_attr_size(sizeof(int)),
+			.nla_type	=3D ZLIB_DECOMP_WINDOWBITS,
+		},
+		.val			=3D DEF_WBITS,
+	};
 	int err;
=20
 	TRACE("Entered squashfs_fill_superblock\n");
@@ -102,7 +113,7 @@ static int squashfs_fill_super(struct super_block *=
sb, void *data, int silent)
 		goto failed_pcomp;
 	}
=20
-	err =3D crypto_decompress_setup(msblk->tfm, &params);
+	err =3D crypto_decompress_setup(msblk->tfm, &params, sizeof(params));
 	if (err) {
 		ERROR("Failed to set up decompression parameters\n");
 		goto failure;
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
index 67ba57d..86163ef 100644
--- a/include/crypto/compress.h
+++ b/include/crypto/compress.h
@@ -30,30 +30,40 @@ struct comp_request {
 	unsigned int avail_out;		/* bytes available at next_out */
 };
=20
-struct zlib_comp_params {
-	int level;			/* e.g. Z_DEFAULT_COMPRESSION */
-	int method;			/* e.g. Z_DEFLATED */
-	int windowBits;			/* e.g. MAX_WBITS */
-	int memLevel;			/* e.g. DEF_MEM_LEVEL */
-	int strategy;			/* e.g. Z_DEFAULT_STRATEGY */
+enum zlib_comp_params {
+	ZLIB_COMP_LEVEL =3D 1,		/* e.g. Z_DEFAULT_COMPRESSION */
+	ZLIB_COMP_METHOD,		/* e.g. Z_DEFLATED */
+	ZLIB_COMP_WINDOWBITS,		/* e.g. MAX_WBITS */
+	ZLIB_COMP_MEMLEVEL,		/* e.g. DEF_MEM_LEVEL */
+	ZLIB_COMP_STRATEGY,		/* e.g. Z_DEFAULT_STRATEGY */
+	__ZLIB_COMP_MAX,
 };
=20
-struct zlib_decomp_params {
-	int windowBits;			/* e.g. DEF_WBITS */
+#define ZLIB_COMP_MAX	(__ZLIB_COMP_MAX - 1)
+
+
+enum zlib_decomp_params {
+	ZLIB_DECOMP_WINDOWBITS =3D 1,	/* e.g. DEF_WBITS */
+	__ZLIB_DECOMP_MAX,
 };
=20
+#define ZLIB_DECOMP_MAX	(__ZLIB_DECOMP_MAX - 1)
+
+
 struct crypto_pcomp {
 	struct crypto_tfm base;
 };
=20
 struct pcomp_alg {
-	int (*compress_setup)(struct crypto_pcomp *tfm, const void *params);
+	int (*compress_setup)(struct crypto_pcomp *tfm, void *params,
+			      unsigned int len);
 	int (*compress_init)(struct crypto_pcomp *tfm);
 	int (*compress_update)(struct crypto_pcomp *tfm,
 			       struct comp_request *req);
 	int (*compress_final)(struct crypto_pcomp *tfm,
 			      struct comp_request *req);
-	int (*decompress_setup)(struct crypto_pcomp *tfm, const void *params)=
;
+	int (*decompress_setup)(struct crypto_pcomp *tfm, void *params,
+				unsigned int len);
 	int (*decompress_init)(struct crypto_pcomp *tfm);
 	int (*decompress_update)(struct crypto_pcomp *tfm,
 				 struct comp_request *req);
@@ -87,9 +97,9 @@ static inline struct pcomp_alg *crypto_pcomp_alg(stru=
ct crypto_pcomp *tfm)
 }
=20
 static inline int crypto_compress_setup(struct crypto_pcomp *tfm,
-					const void *params)
+					void *params, unsigned int len)
 {
-	return crypto_pcomp_alg(tfm)->compress_setup(tfm, params);
+	return crypto_pcomp_alg(tfm)->compress_setup(tfm, params, len);
 }
=20
 static inline int crypto_compress_init(struct crypto_pcomp *tfm)
@@ -110,9 +120,9 @@ static inline int crypto_compress_final(struct cryp=
to_pcomp *tfm,
 }
=20
 static inline int crypto_decompress_setup(struct crypto_pcomp *tfm,
-					  const void *params)
+					  void *params, unsigned int len)
 {
-	return crypto_pcomp_alg(tfm)->decompress_setup(tfm, params);
+	return crypto_pcomp_alg(tfm)->decompress_setup(tfm, params, len);
 }
=20
 static inline int crypto_decompress_init(struct crypto_pcomp *tfm)

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =B7 Da Vincilaan 7-D1 =B7 B-1935 Zaventem =B7 Bel=
gium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =B7 RPR Brussels
=46ortis =B7 BIC GEBABEBB =B7 IBAN BE41293037680010
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
