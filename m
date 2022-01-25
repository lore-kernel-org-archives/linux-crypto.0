Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE475C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 25 Jan 2022 02:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S3419745AbiAYCUK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jan 2022 21:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415338AbiAYBpS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jan 2022 20:45:18 -0500
Received: from mail-ua1-x94a.google.com (mail-ua1-x94a.google.com [IPv6:2607:f8b0:4864:20::94a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F935C0A8876
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jan 2022 17:45:18 -0800 (PST)
Received: by mail-ua1-x94a.google.com with SMTP id i28-20020a9f305c000000b00305923be96aso11346580uab.9
        for <linux-crypto@vger.kernel.org>; Mon, 24 Jan 2022 17:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=A79nkcZwBR0NLt8+NnfzgPYKFdLcz7PnLt3dca6foZw=;
        b=WSkq+D+gecDAojURQZAiZRJui8bvUQ/90EBrAkv5BlxFU0N1gd/QbMbWdx4J4zmNMo
         wjmkmi9hPG5hhxGLT7ANm/lMLZMImplGYjknXXGpK7N6JSmgQrRDxf6BRxc3/URSdCdN
         YqzAfE502cgbVTTnDFD+iy2n3sjnupfwL3Urwd2bpGdolRuNQmw9QgclhEBTAfEHZ4Vt
         Zax2BGWJBCmNFd+5eXkfEU+oMtmDm8NR5DA/8gHynXPQreIGJZBbBfSJ5ewIYcJ71O7+
         9ydzVj6yMhpUzOdZ0kyZXYCQtcNVvyfjW7ImqccxebHnIXeV50gPLIX/2vQ4I9zWgRY4
         sVOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=A79nkcZwBR0NLt8+NnfzgPYKFdLcz7PnLt3dca6foZw=;
        b=BNLJWEHlc1dGCM/put/JDOc0mL87XnI6rXnTbFdepuLXtTytImH1Bom3kBU9lCIx3S
         0eat56+oknuDyPimChfvqbMemxyQNW56LcxYMqbZxDgKeG0OfZpsCTwhXgI6aVBB24uO
         X6P8u4tTzaBKX8pgXg6nqTLBBWl28dn4uJtSIT7UwlGL12HUCVk4k7vQxeoyLhn6KQDj
         +0AwFdtf5pwSMxnwtGG0VRquPB8kbOVRDs4eeluFZCrGj90k+cWJwbUybTDNtDywWu/Q
         mWcnyZqme0jHxH0ilGkmsOkNKJynEh2AowJGkxriqQsK7ugteP2j+rwAexxWzkehkV7Q
         ERJA==
X-Gm-Message-State: AOAM531rC35NqHOZGatWfjMbvepZ9lqITXApuzInVbQHhRE/OpyTKpi/
        alqQtV5CaiSaSn7WsL1n8qGimf44VZc3pkUvPspe4cKqWVlbDZKca+3hydVkCI3YirpGnJ9eW7I
        Y2Cxi1BdeG9w4W8Mvq7UqDt/lwKvE68Y6N20zqU3ROELc/b8sx+eSEtLUWBxHRc9hmQ8=
X-Google-Smtp-Source: ABdhPJwWasivCuAnDdlKcsFnLRLpKMMy6E8EmA2PPfF47SW0EXUslagzCWHriWl65MLLjyw3kIgx7GL2hg==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a67:df8e:: with SMTP id x14mr6969862vsk.80.1643075117363;
 Mon, 24 Jan 2022 17:45:17 -0800 (PST)
Date:   Mon, 24 Jan 2022 19:44:17 -0600
In-Reply-To: <20220125014422.80552-1-nhuck@google.com>
Message-Id: <20220125014422.80552-3-nhuck@google.com>
Mime-Version: 1.0
References: <20220125014422.80552-1-nhuck@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [RFC PATCH 2/7] crypto: polyval - Add POLYVAL support
From:   Nathan Huckleberry <nhuck@google.com>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add support for POLYVAL, an =CE=B5-universal hash function similar to GHASH=
.
POLYVAL is used as a component to implement HCTR2 mode.

POLYVAL is implemented as an shash algorithm.  The implementation is
modified from ghash-generic.c.

More information on POLYVAL can be found in the HCTR2 paper:
https://eprint.iacr.org/2021/1441.pdf

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 crypto/Kconfig           |   8 ++
 crypto/Makefile          |   1 +
 crypto/polyval-generic.c | 183 +++++++++++++++++++++++++
 crypto/tcrypt.c          |   4 +
 crypto/testmgr.c         |   6 +
 crypto/testmgr.h         | 284 +++++++++++++++++++++++++++++++++++++++
 include/crypto/polyval.h |  22 +++
 7 files changed, 508 insertions(+)
 create mode 100644 crypto/polyval-generic.c
 create mode 100644 include/crypto/polyval.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b00de5f22eaf..051060cd5e21 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -760,6 +760,14 @@ config CRYPTO_GHASH
 	  GHASH is the hash function used in GCM (Galois/Counter Mode).
 	  It is not a general-purpose cryptographic hash function.
=20
+config CRYPTO_POLYVAL
+	tristate
+	select CRYPTO_GF128MUL
+	select CRYPTO_HASH
+	help
+	  POLYVAL is the hash function used in HCTR2.  It is not a general-purpos=
e
+	  cryptographic hash function.
+
 config CRYPTO_POLY1305
 	tristate "Poly1305 authenticator algorithm"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index 6b3fe3df1489..561f901a91d4 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -169,6 +169,7 @@ UBSAN_SANITIZE_jitterentropy.o =3D n
 jitterentropy_rng-y :=3D jitterentropy.o jitterentropy-kcapi.o
 obj-$(CONFIG_CRYPTO_TEST) +=3D tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) +=3D ghash-generic.o
+obj-$(CONFIG_CRYPTO_POLYVAL) +=3D polyval-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) +=3D af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) +=3D algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) +=3D algif_skcipher.o
diff --git a/crypto/polyval-generic.c b/crypto/polyval-generic.c
new file mode 100644
index 000000000000..63e908697ea0
--- /dev/null
+++ b/crypto/polyval-generic.c
@@ -0,0 +1,183 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * POLYVAL: hash function for HCTR2.
+ *
+ * Copyright (c) 2007 Nokia Siemens Networks - Mikko Herranen <mh1@iki.fi>
+ * Copyright (c) 2009 Intel Corp.
+ *   Author: Huang Ying <ying.huang@intel.com>
+ * Copyright 2021 Google LLC
+ */
+
+/*
+ * Code based on crypto/ghash-generic.c
+ *
+ * POLYVAL is a keyed hash function similar to GHASH. POLYVAL uses a
+ * different modulus for finite field multiplication which makes hardware
+ * accelerated implementations on little-endian machines faster.
+ *
+ * Like GHASH, POLYVAL is not a cryptographic hash function and should
+ * not be used outside of crypto modes explicitly designed to use POLYVAL.
+ *
+ */
+
+#include <asm/unaligned.h>
+#include <crypto/algapi.h>
+#include <crypto/gf128mul.h>
+#include <crypto/polyval.h>
+#include <crypto/internal/hash.h>
+#include <linux/crypto.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+struct polyval_tfm_ctx {
+	struct gf128mul_4k *gf128;
+};
+
+static int polyval_init(struct shash_desc *desc)
+{
+	struct polyval_desc_ctx *dctx =3D shash_desc_ctx(desc);
+
+	memset(dctx, 0, sizeof(*dctx));
+
+	return 0;
+}
+
+static void reverse_block(u8 block[POLYVAL_BLOCK_SIZE])
+{
+	u64 *p1 =3D (u64 *)block;
+	u64 *p2 =3D (u64 *)&block[8];
+	u64 a =3D get_unaligned(p1);
+	u64 b =3D get_unaligned(p2);
+
+	put_unaligned(swab64(a), p2);
+	put_unaligned(swab64(b), p1);
+}
+
+static int polyval_setkey(struct crypto_shash *tfm,
+			const u8 *key, unsigned int keylen)
+{
+	struct polyval_tfm_ctx *ctx =3D crypto_shash_ctx(tfm);
+	be128 k;
+
+	if (keylen !=3D POLYVAL_BLOCK_SIZE)
+		return -EINVAL;
+
+	gf128mul_free_4k(ctx->gf128);
+
+	BUILD_BUG_ON(sizeof(k) !=3D POLYVAL_BLOCK_SIZE);
+	memcpy(&k, key, POLYVAL_BLOCK_SIZE); /* avoid violating alignment rules *=
/
+
+	reverse_block((u8 *)&k);
+	gf128mul_x_lle(&k, &k);
+
+	ctx->gf128 =3D gf128mul_init_4k_lle(&k);
+	memzero_explicit(&k, POLYVAL_BLOCK_SIZE);
+
+	if (!ctx->gf128)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int polyval_update(struct shash_desc *desc,
+			 const u8 *src, unsigned int srclen)
+{
+	struct polyval_desc_ctx *dctx =3D shash_desc_ctx(desc);
+	const struct polyval_tfm_ctx *ctx =3D crypto_shash_ctx(desc->tfm);
+	u8 *dst =3D dctx->buffer;
+	u8 *pos;
+	u8 tmp[POLYVAL_BLOCK_SIZE];
+	int n;
+
+	if (dctx->bytes) {
+		n =3D min(srclen, dctx->bytes);
+		pos =3D dst + dctx->bytes - 1;
+
+		dctx->bytes -=3D n;
+		srclen -=3D n;
+
+		while (n--)
+			*pos-- ^=3D *src++;
+
+		if (!dctx->bytes)
+			gf128mul_4k_lle((be128 *)dst, ctx->gf128);
+	}
+
+	while (srclen >=3D POLYVAL_BLOCK_SIZE) {
+		memcpy(tmp, src, POLYVAL_BLOCK_SIZE);
+		reverse_block(tmp);
+		crypto_xor(dst, tmp, POLYVAL_BLOCK_SIZE);
+		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
+		src +=3D POLYVAL_BLOCK_SIZE;
+		srclen -=3D POLYVAL_BLOCK_SIZE;
+	}
+
+	if (srclen) {
+		dctx->bytes =3D POLYVAL_BLOCK_SIZE - srclen;
+		pos =3D dst + POLYVAL_BLOCK_SIZE - 1;
+		while (srclen--)
+			*pos-- ^=3D *src++;
+	}
+
+	return 0;
+}
+
+static int polyval_final(struct shash_desc *desc, u8 *dst)
+{
+	struct polyval_desc_ctx *dctx =3D shash_desc_ctx(desc);
+	const struct polyval_tfm_ctx *ctx =3D crypto_shash_ctx(desc->tfm);
+	u8 *buf =3D dctx->buffer;
+
+	if (dctx->bytes)
+		gf128mul_4k_lle((be128 *)dst, ctx->gf128);
+	dctx->bytes =3D 0;
+
+	reverse_block(buf);
+	memcpy(dst, buf, POLYVAL_BLOCK_SIZE);
+
+	return 0;
+}
+
+static void polyval_exit_tfm(struct crypto_tfm *tfm)
+{
+	struct polyval_tfm_ctx *ctx =3D crypto_tfm_ctx(tfm);
+
+	gf128mul_free_4k(ctx->gf128);
+}
+
+static struct shash_alg polyval_alg =3D {
+	.digestsize	=3D POLYVAL_DIGEST_SIZE,
+	.init		=3D polyval_init,
+	.update		=3D polyval_update,
+	.final		=3D polyval_final,
+	.setkey		=3D polyval_setkey,
+	.descsize	=3D sizeof(struct polyval_desc_ctx),
+	.base		=3D {
+		.cra_name		=3D "polyval",
+		.cra_driver_name	=3D "polyval-generic",
+		.cra_priority		=3D 100,
+		.cra_blocksize		=3D POLYVAL_BLOCK_SIZE,
+		.cra_ctxsize		=3D sizeof(struct polyval_tfm_ctx),
+		.cra_module		=3D THIS_MODULE,
+		.cra_exit		=3D polyval_exit_tfm,
+	},
+};
+
+static int __init polyval_mod_init(void)
+{
+	return crypto_register_shash(&polyval_alg);
+}
+
+static void __exit polyval_mod_exit(void)
+{
+	crypto_unregister_shash(&polyval_alg);
+}
+
+subsys_initcall(polyval_mod_init);
+module_exit(polyval_mod_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("POLYVAL hash function");
+MODULE_ALIAS_CRYPTO("polyval");
+MODULE_ALIAS_CRYPTO("polyval-generic");
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index da7848f84d12..b358a5141218 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1924,6 +1924,10 @@ static int do_test(const char *alg, u32 type, u32 ma=
sk, int m, u32 num_mb)
 		ret +=3D tcrypt_test("ccm(sm4)");
 		break;
=20
+	case 57:
+		ret +=3D tcrypt_test("polyval");
+		break;
+
 	case 100:
 		ret +=3D tcrypt_test("hmac(md5)");
 		break;
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 5acf92354543..a3a24aa07492 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5248,6 +5248,12 @@ static const struct alg_test_desc alg_test_descs[] =
=3D {
 		.suite =3D {
 			.hash =3D __VECS(poly1305_tv_template)
 		}
+	}, {
+		.alg =3D "polyval",
+		.test =3D alg_test_hash,
+		.suite =3D {
+			.hash =3D __VECS(polyval_tv_template)
+		}
 	}, {
 		.alg =3D "rfc3686(ctr(aes))",
 		.test =3D alg_test_skcipher,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index e1ebbb3c4d4c..da3736e51982 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -33346,4 +33346,288 @@ static const struct cipher_testvec aes_xctr_tv_te=
mplate[] =3D {
 	},
 };
=20
+/*
+ * Test vectors generated using https://github.com/google/hctr2
+ */
+static const struct hash_testvec polyval_tv_template[] =3D {
+	{
+		.key	=3D "\x31\x07\x28\xd9\x91\x1f\x1f\x38"
+			  "\x37\xb2\x43\x16\xc3\xfa\xb9\xa0",
+		.plaintext	=3D "\x65\x78\x61\x6d\x70\x6c\x65\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x48\x65\x6c\x6c\x6f\x20\x77\x6f"
+			  "\x72\x6c\x64\x00\x00\x00\x00\x00"
+			  "\x38\x00\x00\x00\x00\x00\x00\x00"
+			  "\x58\x00\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\xad\x7f\xcf\x0b\x51\x69\x85\x16"
+			  "\x62\x67\x2f\x3c\x5f\x95\x13\x8f",
+		.psize	=3D 48,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\xd9\xb3\x60\x27\x96\x94\x94\x1a"
+			  "\xc5\xdb\xc6\x98\x7a\xda\x73\x77",
+		.plaintext	=3D "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.psize	=3D 16,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\xd9\xb3\x60\x27\x96\x94\x94\x1a"
+			  "\xc5\xdb\xc6\x98\x7a\xda\x73\x77",
+		.plaintext	=3D "\x01\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x40\x00\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\xeb\x93\xb7\x74\x09\x62\xc5\xe4"
+			  "\x9d\x2a\x90\xa7\xdc\x5c\xec\x74",
+		.psize	=3D 32,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\xd9\xb3\x60\x27\x96\x94\x94\x1a"
+			  "\xc5\xdb\xc6\x98\x7a\xda\x73\x77",
+		.plaintext	=3D "\x01\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x60\x00\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\x48\xeb\x6c\x6c\x5a\x2d\xbe\x4a"
+			  "\x1d\xde\x50\x8f\xee\x06\x36\x1b",
+		.psize	=3D 32,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\xd9\xb3\x60\x27\x96\x94\x94\x1a"
+			  "\xc5\xdb\xc6\x98\x7a\xda\x73\x77",
+		.plaintext	=3D "\x01\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x02\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x01\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\xce\x6e\xdc\x9a\x50\xb3\x6d\x9a"
+			  "\x98\x98\x6b\xbf\x6a\x26\x1c\x3b",
+		.psize	=3D 48,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\xd9\xb3\x60\x27\x96\x94\x94\x1a"
+			  "\xc5\xdb\xc6\x98\x7a\xda\x73\x77",
+		.plaintext	=3D "\x01\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x02\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x03\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x80\x01\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\x81\x38\x87\x46\xbc\x22\xd2\x6b"
+			  "\x2a\xbc\x3d\xcb\x15\x75\x42\x22",
+		.psize	=3D 64,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\xd9\xb3\x60\x27\x96\x94\x94\x1a"
+			  "\xc5\xdb\xc6\x98\x7a\xda\x73\x77",
+		.plaintext	=3D "\x01\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x02\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x03\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x04\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x02\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\x1e\x39\xb6\xd3\x34\x4d\x34\x8f"
+			  "\x60\x44\xf8\x99\x35\xd1\xcf\x78",
+		.psize	=3D 80,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\xd9\xb3\x60\x27\x96\x94\x94\x1a"
+			  "\xc5\xdb\xc6\x98\x7a\xda\x73\x77",
+		.plaintext	=3D "\x01\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x02\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x03\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x08\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x01\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\x2c\xe7\xda\xaf\x7c\x89\x49\x08"
+			  "\x22\x05\x12\x55\xb1\x2e\xca\x6b",
+		.psize	=3D 64,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\xd9\xb3\x60\x27\x96\x94\x94\x1a"
+			  "\xc5\xdb\xc6\x98\x7a\xda\x73\x77",
+		.plaintext	=3D "\x01\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x02\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x03\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x04\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x08\x00\x00\x00\x00\x00\x00\x00"
+			  "\x80\x01\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\x9c\xa9\x87\x71\x5d\x69\xc1\x78"
+			  "\x67\x11\xdf\xcd\x22\xf8\x30\xfc",
+		.psize	=3D 80,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\xd9\xb3\x60\x27\x96\x94\x94\x1a"
+			  "\xc5\xdb\xc6\x98\x7a\xda\x73\x77",
+		.plaintext	=3D "\x01\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x02\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x03\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x04\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x05\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x08\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x02\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\xff\xcd\x05\xd5\x77\x0f\x34\xad"
+			  "\x92\x67\xf0\xa5\x99\x94\xb1\x5a",
+		.psize	=3D 96,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\x03\x6e\xe1\xfe\x2d\x79\x26\xaf"
+			  "\x68\x89\x80\x95\xe5\x4e\x7b\x3c",
+		.plaintext	=3D "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.psize	=3D 16,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\x37\x24\xf5\x5f\x1d\x22\xac\x0a"
+			  "\xb8\x30\xda\x0b\x6a\x99\x5d\x74",
+		.plaintext	=3D "\x75\x76\xf7\x02\x8e\xc6\xeb\x5e"
+			  "\xa7\xe2\x98\x34\x2a\x94\xd4\xb2"
+			  "\x02\xb3\x70\xef\x97\x68\xec\x65"
+			  "\x61\xc4\xfe\x6b\x7e\x72\x96\xfa"
+			  "\x85\x9c\x21\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\xe4\x2a\x3c\x02\xc2\x5b\x64\x86"
+			  "\x9e\x14\x6d\x7b\x23\x39\x87\xbd"
+			  "\xdf\xc2\x40\x87\x1d\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x18\x01\x00\x00\x00\x00\x00\x00"
+			  "\xa8\x00\x00\x00\x00\x00\x00\x00",
+		.digest	=3D "\x4c\xbb\xa0\x90\xf0\x3f\x7d\x11"
+			  "\x88\xea\x55\x74\x9f\xa6\xc7\xbd",
+		.psize	=3D 96,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\x90\xcc\xac\xee\xba\xd7\xd4\x68"
+			  "\x98\xa6\x79\x70\xdf\x66\x15\x6c",
+		.plaintext	=3D "",
+		.digest	=3D "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.psize	=3D 0,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\x89\xc9\x4b\xde\x40\xa6\xf9\x62"
+			  "\x58\x04\x51\x26\xb4\xb1\x14\xe4",
+		.plaintext	=3D "",
+		.digest	=3D "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.psize	=3D 0,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\x37\xbe\x68\x16\x50\xb9\x4e\xb0"
+			  "\x47\xde\xe2\xbd\xde\xe4\x48\x09",
+		.plaintext	=3D "\x87\xfc\x68\x9f\xff\xf2\x4a\x1e"
+			  "\x82\x3b\x73\x8f\xc1\xb2\x1b\x7a"
+			  "\x6c\x4f\x81\xbc\x88\x9b\x6c\xa3"
+			  "\x9c\xc2\xa5\xbc\x14\x70\x4c\x9b"
+			  "\x0c\x9f\x59\x92\x16\x4b\x91\x3d"
+			  "\x18\x55\x22\x68\x12\x8c\x63\xb2"
+			  "\x51\xcb\x85\x4b\xd2\xae\x0b\x1c"
+			  "\x5d\x28\x9d\x1d\xb1\xc8\xf0\x77"
+			  "\xe9\xb5\x07\x4e\x06\xc8\xee\xf8"
+			  "\x1b\xed\x72\x2a\x55\x7d\x16\xc9"
+			  "\xf2\x54\xe7\xe9\xe0\x44\x5b\x33"
+			  "\xb1\x49\xee\xff\x43\xfb\x82\xcd"
+			  "\x4a\x70\x78\x81\xa4\x34\x36\xe8"
+			  "\x4c\x28\x54\xa6\x6c\xc3\x6b\x78"
+			  "\xe7\xc0\x5d\xc6\x5d\x81\xab\x70"
+			  "\x08\x86\xa1\xfd\xf4\x77\x55\xfd"
+			  "\xa3\xe9\xe2\x1b\xdf\x99\xb7\x80"
+			  "\xf9\x0a\x4f\x72\x4a\xd3\xaf\xbb"
+			  "\xb3\x3b\xeb\x08\x58\x0f\x79\xce"
+			  "\xa5\x99\x05\x12\x34\xd4\xf4\x86"
+			  "\x37\x23\x1d\xc8\x49\xc0\x92\xae"
+			  "\xa6\xac\x9b\x31\x55\xed\x15\xc6"
+			  "\x05\x17\x37\x8d\x90\x42\xe4\x87"
+			  "\x89\x62\x88\x69\x1c\x6a\xfd\xe3"
+			  "\x00\x2b\x47\x1a\x73\xc1\x51\xc2"
+			  "\xc0\x62\x74\x6a\x9e\xb2\xe5\x21"
+			  "\xbe\x90\xb5\xb0\x50\xca\x88\x68"
+			  "\xe1\x9d\x7a\xdf\x6c\xb7\xb9\x98"
+			  "\xee\x28\x62\x61\x8b\xd1\x47\xf9"
+			  "\x04\x7a\x0b\x5d\xcd\x2b\x65\xf5"
+			  "\x12\xa3\xfe\x1a\xaa\x2c\x78\x42"
+			  "\xb8\xbe\x7d\x74\xeb\x59\xba\xba",
+		.digest	=3D "\xae\x11\xd4\x60\x2a\x5f\x9e\x42"
+			  "\x89\x04\xc2\x34\x8d\x55\x94\x0a",
+		.psize	=3D 256,
+		.ksize	=3D 16,
+	},
+	{
+		.key	=3D "\xc8\x53\xde\xaa\xb1\x4b\x6b\xd5"
+			  "\x88\xd6\x4c\xe9\xba\x35\x3d\x5a",
+		.plaintext	=3D "\xc1\xeb\xba\x8d\xb7\x20\x09\xe0"
+			  "\x28\x4f\x29\xf3\xd8\x26\x50\x40"
+			  "\xd9\x06\xa8\xa8\xc0\xbe\xf0\xfb"
+			  "\x75\x7c\x02\x86\x16\x83\x9d\x65"
+			  "\x8f\x5e\xc4\x58\xed\x6a\xb3\x10"
+			  "\xd2\xf7\x23\xc2\x4a\xb0\x00\x6a"
+			  "\x01\x7c\xf7\xf7\x69\x42\xb2\x12"
+			  "\xb0\xeb\x65\x07\xd7\x8e\x2d\x27"
+			  "\x67\xa2\x57\xf0\x49\x0f\x3f\x0e"
+			  "\xc9\xf7\x1b\xe0\x5b\xdd\x87\xfb"
+			  "\x89\xd1\xfa\xb1\x46\xaf\xa2\x93"
+			  "\x01\x65\xb6\x6f\xbe\x29\x7d\x9f"
+			  "\xfa\xf5\x58\xc6\xb5\x92\x55\x25"
+			  "\x4c\xb5\x0c\xc2\x61\x9f\xc4\xb1"
+			  "\x7f\xe3\x61\x18\x3f\x8c\xb2\xd6"
+			  "\xfd\x9f\xd8\xe5\x3d\x03\x05\xa2"
+			  "\x5d\x1a\xa8\xf0\x04\x41\xea\xa6"
+			  "\x07\x67\x86\x00\xe8\x86\xfc\xb1"
+			  "\xc3\x15\x3e\xc8\x84\x2e\x5e\x5f"
+			  "\x7b\x75\x6a\xc4\x48\xb4\xee\x5f"
+			  "\xe9\x76\xdf\xe6\x1a\xd4\x15\x92"
+			  "\x23\x03\x06\xc1\x2d\x0f\x94\xcb"
+			  "\xe6\x5e\x18\xa6\x3b\x38\x1f\xc2"
+			  "\x28\x73\x8a\xbd\x3a\x6f\xb0\x95"
+			  "\x0f\x1c\xc7\xdf\x10\x0b\x2a\x7d"
+			  "\xf9\x6b\xe1\x4a\xfb\xe1\x07\xc9"
+			  "\x69\x7b\x27\x65\xc0\x08\x49\xc0"
+			  "\xf3\x0b\x5b\xa6\x8b\xf7\x1a\xfe"
+			  "\xe3\x9f\x87\x1d\x68\x07\xf4\x53"
+			  "\x8d\x54\xe9\x3f\xd5\x02\x3a\x09"
+			  "\x72\xa9\x84\xdc\x25\xd3\xad\xdb"
+			  "\x4e\x45\x4f\x7f\xe8\x02\x69\x45",
+		.digest	=3D "\x7b\x4f\x29\xb3\x0b\x4d\x2b\xa3"
+			  "\x40\xc8\x56\x5a\x0a\xcf\xbd\x9b",
+		.psize	=3D 256,
+		.ksize	=3D 16,
+	},
+};
+
 #endif	/* _CRYPTO_TESTMGR_H */
diff --git a/include/crypto/polyval.h b/include/crypto/polyval.h
new file mode 100644
index 000000000000..fd0c6e124b65
--- /dev/null
+++ b/include/crypto/polyval.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common values for the Polyval hash algorithm
+ *
+ * Copyright 2021 Google LLC
+ */
+
+#ifndef _CRYPTO_POLYVAL_H
+#define _CRYPTO_POLYVAL_H
+
+#include <linux/types.h>
+#include <linux/crypto.h>
+
+#define POLYVAL_BLOCK_SIZE	16
+#define POLYVAL_DIGEST_SIZE	16
+
+struct polyval_desc_ctx {
+	u8 buffer[POLYVAL_BLOCK_SIZE];
+	u32 bytes;
+};
+
+#endif
--=20
2.35.0.rc0.227.g00780c9af4-goog

