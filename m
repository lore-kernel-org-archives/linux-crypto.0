Return-Path: <SRS0=YB2u=UC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A930C04AB6
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39BE7247B4
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Jun 2019 05:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559540502;
	bh=Xywc37pAGWuGx21aj51Ip8YU2sJtIdECRHdSolKUJIk=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FYw1LaHzM9i37f6Y56V0kosKM6Pg8iZ3UWxFtdp+Q6L5Zx8RDerNEvbJREc1t44TV
	 EJrb/we4NA8xmSVwy3mikGDEJbIFVWrQFeD9OftJpHu0oocNMHUqn7soEN4Jqli/F4
	 YyNYXb9Syjv37mQKpfyufynmkd5j728SNFqeZ1Cg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfFCFll (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Jun 2019 01:41:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:53716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbfFCFlk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jun 2019 01:41:40 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E17D8247BF
        for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2019 05:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559540499;
        bh=Xywc37pAGWuGx21aj51Ip8YU2sJtIdECRHdSolKUJIk=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=rPRTvc8awcj2lhFFj4q9apDVV1zoAcaiNsSnH4JTfzIycSBi8dBH2uquuiCT8nn9Z
         b+mITjETZ9kt7WTLN04c+T+H+NjCvsl+RLVOkLGddv30W8tB/0pgMhD9sVXAAL/utx
         kVm0iez8GZe0sk4poMgVQWXWge+uKMt1lXTWNCZ4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH 1/2] crypto: make all generic algorithms set cra_driver_name
Date:   Sun,  2 Jun 2019 22:40:57 -0700
Message-Id: <20190603054058.5449-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603054058.5449-1-ebiggers@kernel.org>
References: <20190603054058.5449-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Most generic crypto algorithms declare a driver name ending in
"-generic".  The rest don't declare a driver name and instead rely on
the crypto API automagically appending "-generic" upon registration.

Having multiple conventions is unnecessarily confusing and makes it
harder to grep for all generic algorithms in the kernel source tree.
But also, allowing NULL driver names is problematic because sometimes
people fail to set it, e.g. the case fixed by commit 417980364300
("crypto: cavium/zip - fix collision with generic cra_driver_name").

Of course, people can also incorrectly name their drivers "-generic".
But that's much easier to notice / grep for.

Therefore, let's make cra_driver_name mandatory.  In preparation for
this, this patch makes all generic algorithms set cra_driver_name.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/anubis.c          |  1 +
 crypto/arc4.c            |  2 ++
 crypto/crypto_null.c     |  3 +++
 crypto/deflate.c         |  1 +
 crypto/fcrypt.c          |  1 +
 crypto/khazad.c          |  1 +
 crypto/lz4.c             |  1 +
 crypto/lz4hc.c           |  1 +
 crypto/lzo-rle.c         |  1 +
 crypto/lzo.c             |  1 +
 crypto/md4.c             |  7 ++++---
 crypto/md5.c             |  7 ++++---
 crypto/michael_mic.c     |  1 +
 crypto/rmd128.c          |  1 +
 crypto/rmd160.c          |  1 +
 crypto/rmd256.c          |  1 +
 crypto/rmd320.c          |  1 +
 crypto/serpent_generic.c |  1 +
 crypto/tea.c             |  3 +++
 crypto/tgr192.c          | 21 ++++++++++++---------
 crypto/wp512.c           | 21 ++++++++++++---------
 crypto/zstd.c            |  1 +
 22 files changed, 55 insertions(+), 24 deletions(-)

diff --git a/crypto/anubis.c b/crypto/anubis.c
index 673927de0eb92..f9ce78fde6eee 100644
--- a/crypto/anubis.c
+++ b/crypto/anubis.c
@@ -673,6 +673,7 @@ static void anubis_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 
 static struct crypto_alg anubis_alg = {
 	.cra_name		=	"anubis",
+	.cra_driver_name	=	"anubis-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	ANUBIS_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct anubis_ctx),
diff --git a/crypto/arc4.c b/crypto/arc4.c
index 2233d36456e27..b78dcb390a7e2 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -115,6 +115,7 @@ static int ecb_arc4_crypt(struct skcipher_request *req)
 
 static struct crypto_alg arc4_cipher = {
 	.cra_name		=	"arc4",
+	.cra_driver_name	=	"arc4-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	ARC4_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct arc4_ctx),
@@ -132,6 +133,7 @@ static struct crypto_alg arc4_cipher = {
 
 static struct skcipher_alg arc4_skcipher = {
 	.base.cra_name		=	"ecb(arc4)",
+	.base.cra_driver_name	=	"ecb(arc4)-generic",
 	.base.cra_priority	=	100,
 	.base.cra_blocksize	=	ARC4_BLOCK_SIZE,
 	.base.cra_ctxsize	=	sizeof(struct arc4_ctx),
diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 9320d4eaa4a8a..6aa9a4c29edf8 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -105,6 +105,7 @@ static struct shash_alg digest_null = {
 	.final  		=	null_final,
 	.base			=	{
 		.cra_name		=	"digest_null",
+		.cra_driver_name	=	"digest_null-generic",
 		.cra_blocksize		=	NULL_BLOCK_SIZE,
 		.cra_module		=	THIS_MODULE,
 	}
@@ -127,6 +128,7 @@ static struct skcipher_alg skcipher_null = {
 
 static struct crypto_alg null_algs[] = { {
 	.cra_name		=	"cipher_null",
+	.cra_driver_name	=	"cipher_null-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	NULL_BLOCK_SIZE,
 	.cra_ctxsize		=	0,
@@ -139,6 +141,7 @@ static struct crypto_alg null_algs[] = { {
 	.cia_decrypt		=	null_crypt } }
 }, {
 	.cra_name		=	"compress_null",
+	.cra_driver_name	=	"compress_null-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_blocksize		=	NULL_BLOCK_SIZE,
 	.cra_ctxsize		=	0,
diff --git a/crypto/deflate.c b/crypto/deflate.c
index aab089cde1bf8..1143ccbe0296b 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -279,6 +279,7 @@ static int deflate_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 
 static struct crypto_alg alg = {
 	.cra_name		= "deflate",
+	.cra_driver_name	= "deflate-generic",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct deflate_ctx),
 	.cra_module		= THIS_MODULE,
diff --git a/crypto/fcrypt.c b/crypto/fcrypt.c
index 4e8704405a3b9..58f935315cf8f 100644
--- a/crypto/fcrypt.c
+++ b/crypto/fcrypt.c
@@ -391,6 +391,7 @@ static int fcrypt_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int key
 
 static struct crypto_alg fcrypt_alg = {
 	.cra_name		=	"fcrypt",
+	.cra_driver_name	=	"fcrypt-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	8,
 	.cra_ctxsize		=	sizeof(struct fcrypt_ctx),
diff --git a/crypto/khazad.c b/crypto/khazad.c
index b50aa8a3ab4cf..14ca7f1631c79 100644
--- a/crypto/khazad.c
+++ b/crypto/khazad.c
@@ -848,6 +848,7 @@ static void khazad_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 
 static struct crypto_alg khazad_alg = {
 	.cra_name		=	"khazad",
+	.cra_driver_name	=	"khazad-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	KHAZAD_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct khazad_ctx),
diff --git a/crypto/lz4.c b/crypto/lz4.c
index 1e35134d0a98d..ed9088c97c6e7 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -119,6 +119,7 @@ static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 
 static struct crypto_alg alg_lz4 = {
 	.cra_name		= "lz4",
+	.cra_driver_name	= "lz4-generic",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct lz4_ctx),
 	.cra_module		= THIS_MODULE,
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 4a220b628fe7e..21a342c6b9d4c 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -120,6 +120,7 @@ static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 
 static struct crypto_alg alg_lz4hc = {
 	.cra_name		= "lz4hc",
+	.cra_driver_name	= "lz4hc-generic",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct lz4hc_ctx),
 	.cra_module		= THIS_MODULE,
diff --git a/crypto/lzo-rle.c b/crypto/lzo-rle.c
index 4c82bf18440f0..469814926f02b 100644
--- a/crypto/lzo-rle.c
+++ b/crypto/lzo-rle.c
@@ -122,6 +122,7 @@ static int lzorle_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 
 static struct crypto_alg alg = {
 	.cra_name		= "lzo-rle",
+	.cra_driver_name	= "lzo-rle-generic",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct lzorle_ctx),
 	.cra_module		= THIS_MODULE,
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 4a6ac8f247d0a..a98ac046613a1 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -122,6 +122,7 @@ static int lzo_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 
 static struct crypto_alg alg = {
 	.cra_name		= "lzo",
+	.cra_driver_name	= "lzo-generic",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct lzo_ctx),
 	.cra_module		= THIS_MODULE,
diff --git a/crypto/md4.c b/crypto/md4.c
index 9a1a228a0c695..2e7f2f319f950 100644
--- a/crypto/md4.c
+++ b/crypto/md4.c
@@ -216,9 +216,10 @@ static struct shash_alg alg = {
 	.final		=	md4_final,
 	.descsize	=	sizeof(struct md4_ctx),
 	.base		=	{
-		.cra_name	=	"md4",
-		.cra_blocksize	=	MD4_HMAC_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
+		.cra_name	 =	"md4",
+		.cra_driver_name =	"md4-generic",
+		.cra_blocksize	 =	MD4_HMAC_BLOCK_SIZE,
+		.cra_module	 =	THIS_MODULE,
 	}
 };
 
diff --git a/crypto/md5.c b/crypto/md5.c
index 221c2c0932f83..22dc60bc04375 100644
--- a/crypto/md5.c
+++ b/crypto/md5.c
@@ -228,9 +228,10 @@ static struct shash_alg alg = {
 	.descsize	=	sizeof(struct md5_state),
 	.statesize	=	sizeof(struct md5_state),
 	.base		=	{
-		.cra_name	=	"md5",
-		.cra_blocksize	=	MD5_HMAC_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
+		.cra_name	 =	"md5",
+		.cra_driver_name =	"md5-generic",
+		.cra_blocksize	 =	MD5_HMAC_BLOCK_SIZE,
+		.cra_module	 =	THIS_MODULE,
 	}
 };
 
diff --git a/crypto/michael_mic.c b/crypto/michael_mic.c
index 538ae79337957..be5c07ea6841c 100644
--- a/crypto/michael_mic.c
+++ b/crypto/michael_mic.c
@@ -159,6 +159,7 @@ static struct shash_alg alg = {
 	.descsize		=	sizeof(struct michael_mic_desc_ctx),
 	.base			=	{
 		.cra_name		=	"michael_mic",
+		.cra_driver_name	=	"michael_mic-generic",
 		.cra_blocksize		=	8,
 		.cra_alignmask		=	3,
 		.cra_ctxsize		=	sizeof(struct michael_mic_ctx),
diff --git a/crypto/rmd128.c b/crypto/rmd128.c
index faf4252c4b856..81fcae094bd5e 100644
--- a/crypto/rmd128.c
+++ b/crypto/rmd128.c
@@ -303,6 +303,7 @@ static struct shash_alg alg = {
 	.descsize	=	sizeof(struct rmd128_ctx),
 	.base		=	{
 		.cra_name	 =	"rmd128",
+		.cra_driver_name =	"rmd128-generic",
 		.cra_blocksize	 =	RMD128_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
diff --git a/crypto/rmd160.c b/crypto/rmd160.c
index b33309916d4fe..0c0d178dee9dd 100644
--- a/crypto/rmd160.c
+++ b/crypto/rmd160.c
@@ -347,6 +347,7 @@ static struct shash_alg alg = {
 	.descsize	=	sizeof(struct rmd160_ctx),
 	.base		=	{
 		.cra_name	 =	"rmd160",
+		.cra_driver_name =	"rmd160-generic",
 		.cra_blocksize	 =	RMD160_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
diff --git a/crypto/rmd256.c b/crypto/rmd256.c
index 2a643250c9a5c..cdbbe37266c35 100644
--- a/crypto/rmd256.c
+++ b/crypto/rmd256.c
@@ -322,6 +322,7 @@ static struct shash_alg alg = {
 	.descsize	=	sizeof(struct rmd256_ctx),
 	.base		=	{
 		.cra_name	 =	"rmd256",
+		.cra_driver_name =	"rmd256-generic",
 		.cra_blocksize	 =	RMD256_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
diff --git a/crypto/rmd320.c b/crypto/rmd320.c
index 2f062574fc8c8..9327af0fe4b7a 100644
--- a/crypto/rmd320.c
+++ b/crypto/rmd320.c
@@ -371,6 +371,7 @@ static struct shash_alg alg = {
 	.descsize	=	sizeof(struct rmd320_ctx),
 	.base		=	{
 		.cra_name	 =	"rmd320",
+		.cra_driver_name =	"rmd320-generic",
 		.cra_blocksize	 =	RMD320_BLOCK_SIZE,
 		.cra_module	 =	THIS_MODULE,
 	}
diff --git a/crypto/serpent_generic.c b/crypto/serpent_generic.c
index ec4ec89ad1085..f2f549330d2b7 100644
--- a/crypto/serpent_generic.c
+++ b/crypto/serpent_generic.c
@@ -641,6 +641,7 @@ static struct crypto_alg srp_algs[2] = { {
 	.cia_decrypt		=	serpent_decrypt } }
 }, {
 	.cra_name		=	"tnepres",
+	.cra_driver_name	=	"tnepres-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	SERPENT_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof(struct serpent_ctx),
diff --git a/crypto/tea.c b/crypto/tea.c
index 786b589e13995..fa012589d3b0d 100644
--- a/crypto/tea.c
+++ b/crypto/tea.c
@@ -221,6 +221,7 @@ static void xeta_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 
 static struct crypto_alg tea_algs[3] = { {
 	.cra_name		=	"tea",
+	.cra_driver_name	=	"tea-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	TEA_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct tea_ctx),
@@ -234,6 +235,7 @@ static struct crypto_alg tea_algs[3] = { {
 	.cia_decrypt		=	tea_decrypt } }
 }, {
 	.cra_name		=	"xtea",
+	.cra_driver_name	=	"xtea-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	XTEA_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct xtea_ctx),
@@ -247,6 +249,7 @@ static struct crypto_alg tea_algs[3] = { {
 	.cia_decrypt		=	xtea_decrypt } }
 }, {
 	.cra_name		=	"xeta",
+	.cra_driver_name	=	"xeta-generic",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	XTEA_BLOCK_SIZE,
 	.cra_ctxsize		=	sizeof (struct xtea_ctx),
diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index 40020f8adc46a..39b3ffd22f5d7 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -635,9 +635,10 @@ static struct shash_alg tgr_algs[3] = { {
 	.final		=	tgr192_final,
 	.descsize	=	sizeof(struct tgr192_ctx),
 	.base		=	{
-		.cra_name	=	"tgr192",
-		.cra_blocksize	=	TGR192_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
+		.cra_name	 =	"tgr192",
+		.cra_driver_name =	"tgr192-generic",
+		.cra_blocksize	 =	TGR192_BLOCK_SIZE,
+		.cra_module	 =	THIS_MODULE,
 	}
 }, {
 	.digestsize	=	TGR160_DIGEST_SIZE,
@@ -646,9 +647,10 @@ static struct shash_alg tgr_algs[3] = { {
 	.final		=	tgr160_final,
 	.descsize	=	sizeof(struct tgr192_ctx),
 	.base		=	{
-		.cra_name	=	"tgr160",
-		.cra_blocksize	=	TGR192_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
+		.cra_name	 =	"tgr160",
+		.cra_driver_name =	"tgr160-generic",
+		.cra_blocksize	 =	TGR192_BLOCK_SIZE,
+		.cra_module	 =	THIS_MODULE,
 	}
 }, {
 	.digestsize	=	TGR128_DIGEST_SIZE,
@@ -657,9 +659,10 @@ static struct shash_alg tgr_algs[3] = { {
 	.final		=	tgr128_final,
 	.descsize	=	sizeof(struct tgr192_ctx),
 	.base		=	{
-		.cra_name	=	"tgr128",
-		.cra_blocksize	=	TGR192_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
+		.cra_name	 =	"tgr128",
+		.cra_driver_name =	"tgr128-generic",
+		.cra_blocksize	 =	TGR192_BLOCK_SIZE,
+		.cra_module	 =	THIS_MODULE,
 	}
 } };
 
diff --git a/crypto/wp512.c b/crypto/wp512.c
index 1b8e502d999ff..feadc13ccae06 100644
--- a/crypto/wp512.c
+++ b/crypto/wp512.c
@@ -1126,9 +1126,10 @@ static struct shash_alg wp_algs[3] = { {
 	.final		=	wp512_final,
 	.descsize	=	sizeof(struct wp512_ctx),
 	.base		=	{
-		.cra_name	=	"wp512",
-		.cra_blocksize	=	WP512_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
+		.cra_name	 =	"wp512",
+		.cra_driver_name =	"wp512-generic",
+		.cra_blocksize	 =	WP512_BLOCK_SIZE,
+		.cra_module	 =	THIS_MODULE,
 	}
 }, {
 	.digestsize	=	WP384_DIGEST_SIZE,
@@ -1137,9 +1138,10 @@ static struct shash_alg wp_algs[3] = { {
 	.final		=	wp384_final,
 	.descsize	=	sizeof(struct wp512_ctx),
 	.base		=	{
-		.cra_name	=	"wp384",
-		.cra_blocksize	=	WP512_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
+		.cra_name	 =	"wp384",
+		.cra_driver_name =	"wp384-generic",
+		.cra_blocksize	 =	WP512_BLOCK_SIZE,
+		.cra_module	 =	THIS_MODULE,
 	}
 }, {
 	.digestsize	=	WP256_DIGEST_SIZE,
@@ -1148,9 +1150,10 @@ static struct shash_alg wp_algs[3] = { {
 	.final		=	wp256_final,
 	.descsize	=	sizeof(struct wp512_ctx),
 	.base		=	{
-		.cra_name	=	"wp256",
-		.cra_blocksize	=	WP512_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
+		.cra_name	 =	"wp256",
+		.cra_driver_name =	"wp256-generic",
+		.cra_blocksize	 =	WP512_BLOCK_SIZE,
+		.cra_module	 =	THIS_MODULE,
 	}
 } };
 
diff --git a/crypto/zstd.c b/crypto/zstd.c
index 2c04055e407f0..c9ff2ec8d4a32 100644
--- a/crypto/zstd.c
+++ b/crypto/zstd.c
@@ -214,6 +214,7 @@ static int zstd_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 
 static struct crypto_alg alg = {
 	.cra_name		= "zstd",
+	.cra_driver_name	= "zstd-generic",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
 	.cra_ctxsize		= sizeof(struct zstd_ctx),
 	.cra_module		= THIS_MODULE,
-- 
2.21.0

