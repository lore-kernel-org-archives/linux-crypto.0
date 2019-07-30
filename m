Return-Path: <SRS0=RABd=V3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE928C0650F
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97B8120693
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jul 2019 12:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbfG3Mip (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jul 2019 08:38:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53552 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729579AbfG3Min (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jul 2019 08:38:43 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D221F882FF;
        Tue, 30 Jul 2019 12:38:42 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9074B5D6B2;
        Tue, 30 Jul 2019 12:38:41 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC 3/3] crypto/sha256: Build the SHA256 core separately from the crypto module
Date:   Tue, 30 Jul 2019 14:38:35 +0200
Message-Id: <20190730123835.10283-4-hdegoede@redhat.com>
In-Reply-To: <20190730123835.10283-1-hdegoede@redhat.com>
References: <20190730123835.10283-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 30 Jul 2019 12:38:42 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Andy Lutomirski <luto@kernel.org>

This just moves code around -- no code changes in this patch.  This
wil let BPF-based tracing link against the SHA256 core code without
depending on the crypto core.

Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 crypto/Kconfig                               |   8 +
 crypto/Makefile                              |   1 +
 crypto/{sha256_generic.c => sha256_direct.c} | 103 +--------
 crypto/sha256_generic.c                      | 214 -------------------
 4 files changed, 15 insertions(+), 311 deletions(-)
 copy crypto/{sha256_generic.c => sha256_direct.c} (76%)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index e801450bcb1c..3f4daf6632e4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -10,6 +10,13 @@ config XOR_BLOCKS
 #
 source "crypto/async_tx/Kconfig"
 
+#
+# Cryptographic algorithms that are usable without the Crypto API.
+# None of these should have visible config options.
+#
+config CRYPTO_SHA256_DIRECT
+	bool
+
 #
 # Cryptographic API Configuration
 #
@@ -931,6 +938,7 @@ config CRYPTO_SHA1_PPC_SPE
 
 config CRYPTO_SHA256
 	tristate "SHA224 and SHA256 digest algorithm"
+	select CRYPTO_SHA256_DIRECT
 	select CRYPTO_HASH
 	help
 	  SHA256 secure hash standard (DFIPS 180-2).
diff --git a/crypto/Makefile b/crypto/Makefile
index 9479e1a45d8c..70c6bbfb4e38 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -66,6 +66,7 @@ obj-$(CONFIG_CRYPTO_RMD160) += rmd160.o
 obj-$(CONFIG_CRYPTO_RMD256) += rmd256.o
 obj-$(CONFIG_CRYPTO_RMD320) += rmd320.o
 obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
+obj-$(CONFIG_CRYPTO_SHA256_DIRECT) += sha256_direct.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512_generic.o
 obj-$(CONFIG_CRYPTO_SHA3) += sha3_generic.o
diff --git a/crypto/sha256_generic.c b/crypto/sha256_direct.c
similarity index 76%
copy from crypto/sha256_generic.c
copy to crypto/sha256_direct.c
index 4e7265e0b40d..2029e4c08339 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_direct.c
@@ -1,4 +1,3 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
 /*
  * Cryptographic API.
  *
@@ -11,33 +10,19 @@
  * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * SHA224 Support Copyright 2007 Intel Corporation <jonathan.lynch@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option) 
+ * any later version.
+ *
  */
-#include <crypto/internal/hash.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/mm.h>
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <crypto/sha256_base.h>
 #include <asm/byteorder.h>
 #include <asm/unaligned.h>
 
-const u8 sha224_zero_message_hash[SHA224_DIGEST_SIZE] = {
-	0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b, 0xc9, 0x47,
-	0x61, 0x02, 0xbb, 0x28, 0x82, 0x34, 0xc4, 0x15, 0xa2,
-	0xb0, 0x1f, 0x82, 0x8e, 0xa6, 0x2a, 0xc5, 0xb3, 0xe4,
-	0x2f
-};
-EXPORT_SYMBOL_GPL(sha224_zero_message_hash);
-
-const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE] = {
-	0xe3, 0xb0, 0xc4, 0x42, 0x98, 0xfc, 0x1c, 0x14,
-	0x9a, 0xfb, 0xf4, 0xc8, 0x99, 0x6f, 0xb9, 0x24,
-	0x27, 0xae, 0x41, 0xe4, 0x64, 0x9b, 0x93, 0x4c,
-	0xa4, 0x95, 0x99, 0x1b, 0x78, 0x52, 0xb8, 0x55
-};
-EXPORT_SYMBOL_GPL(sha256_zero_message_hash);
-
 static inline u32 Ch(u32 x, u32 y, u32 z)
 {
 	return z ^ (x & (y ^ z));
@@ -242,21 +227,6 @@ void sha256_update_direct(struct sha256_state *sctx, const u8 *data,
 }
 EXPORT_SYMBOL(sha256_update_direct);
 
-int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
-			  unsigned int len)
-{
-	sha256_update_direct(shash_desc_ctx(desc), data, len);
-	return 0;
-}
-EXPORT_SYMBOL(crypto_sha256_update);
-
-static int sha256_final(struct shash_desc *desc, u8 *out)
-{
-	__sha256_final_direct(shash_desc_ctx(desc),
-			      crypto_shash_digestsize(desc->tfm), out);
-	return 0;
-}
-
 void __sha256_final_direct(struct sha256_state *sctx, unsigned int digest_size,
 			   u8 *out)
 {
@@ -265,65 +235,4 @@ void __sha256_final_direct(struct sha256_state *sctx, unsigned int digest_size,
 }
 EXPORT_SYMBOL(sha256_final_direct);
 
-int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *hash)
-{
-	struct sha256_state *sctx = shash_desc_ctx(desc);
-	unsigned int digest_size = crypto_shash_digestsize(desc->tfm);
-
-	sha256_update_direct(sctx, data, len);
-	__sha256_final_direct(sctx, digest_size, hash);
-	return 0;
-}
-EXPORT_SYMBOL(crypto_sha256_finup);
-
-static struct shash_alg sha256_algs[2] = { {
-	.digestsize	=	SHA256_DIGEST_SIZE,
-	.init		=	sha256_base_init,
-	.update		=	crypto_sha256_update,
-	.final		=	sha256_final,
-	.finup		=	crypto_sha256_finup,
-	.descsize	=	sizeof(struct sha256_state),
-	.base		=	{
-		.cra_name	=	"sha256",
-		.cra_driver_name=	"sha256-generic",
-		.cra_priority	=	100,
-		.cra_blocksize	=	SHA256_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
-	}
-}, {
-	.digestsize	=	SHA224_DIGEST_SIZE,
-	.init		=	sha224_base_init,
-	.update		=	crypto_sha256_update,
-	.final		=	sha256_final,
-	.finup		=	crypto_sha256_finup,
-	.descsize	=	sizeof(struct sha256_state),
-	.base		=	{
-		.cra_name	=	"sha224",
-		.cra_driver_name=	"sha224-generic",
-		.cra_priority	=	100,
-		.cra_blocksize	=	SHA224_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
-	}
-} };
-
-static int __init sha256_generic_mod_init(void)
-{
-	return crypto_register_shashes(sha256_algs, ARRAY_SIZE(sha256_algs));
-}
-
-static void __exit sha256_generic_mod_fini(void)
-{
-	crypto_unregister_shashes(sha256_algs, ARRAY_SIZE(sha256_algs));
-}
-
-subsys_initcall(sha256_generic_mod_init);
-module_exit(sha256_generic_mod_fini);
-
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("SHA-224 and SHA-256 Secure Hash Algorithm");
-
-MODULE_ALIAS_CRYPTO("sha224");
-MODULE_ALIAS_CRYPTO("sha224-generic");
-MODULE_ALIAS_CRYPTO("sha256");
-MODULE_ALIAS_CRYPTO("sha256-generic");
diff --git a/crypto/sha256_generic.c b/crypto/sha256_generic.c
index 4e7265e0b40d..c6cefcc691d0 100644
--- a/crypto/sha256_generic.c
+++ b/crypto/sha256_generic.c
@@ -19,8 +19,6 @@
 #include <linux/types.h>
 #include <crypto/sha.h>
 #include <crypto/sha256_base.h>
-#include <asm/byteorder.h>
-#include <asm/unaligned.h>
 
 const u8 sha224_zero_message_hash[SHA224_DIGEST_SIZE] = {
 	0xd1, 0x4a, 0x02, 0x8c, 0x2a, 0x3a, 0x2b, 0xc9, 0x47,
@@ -38,210 +36,6 @@ const u8 sha256_zero_message_hash[SHA256_DIGEST_SIZE] = {
 };
 EXPORT_SYMBOL_GPL(sha256_zero_message_hash);
 
-static inline u32 Ch(u32 x, u32 y, u32 z)
-{
-	return z ^ (x & (y ^ z));
-}
-
-static inline u32 Maj(u32 x, u32 y, u32 z)
-{
-	return (x & y) | (z & (x | y));
-}
-
-#define e0(x)       (ror32(x, 2) ^ ror32(x,13) ^ ror32(x,22))
-#define e1(x)       (ror32(x, 6) ^ ror32(x,11) ^ ror32(x,25))
-#define s0(x)       (ror32(x, 7) ^ ror32(x,18) ^ (x >> 3))
-#define s1(x)       (ror32(x,17) ^ ror32(x,19) ^ (x >> 10))
-
-static inline void LOAD_OP(int I, u32 *W, const u8 *input)
-{
-	W[I] = get_unaligned_be32((__u32 *)input + I);
-}
-
-static inline void BLEND_OP(int I, u32 *W)
-{
-	W[I] = s1(W[I-2]) + W[I-7] + s0(W[I-15]) + W[I-16];
-}
-
-static void sha256_transform(u32 *state, const u8 *input)
-{
-	u32 a, b, c, d, e, f, g, h, t1, t2;
-	u32 W[64];
-	int i;
-
-	/* load the input */
-	for (i = 0; i < 16; i++)
-		LOAD_OP(i, W, input);
-
-	/* now blend */
-	for (i = 16; i < 64; i++)
-		BLEND_OP(i, W);
-
-	/* load the state into our registers */
-	a=state[0];  b=state[1];  c=state[2];  d=state[3];
-	e=state[4];  f=state[5];  g=state[6];  h=state[7];
-
-	/* now iterate */
-	t1 = h + e1(e) + Ch(e,f,g) + 0x428a2f98 + W[ 0];
-	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
-	t1 = g + e1(d) + Ch(d,e,f) + 0x71374491 + W[ 1];
-	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
-	t1 = f + e1(c) + Ch(c,d,e) + 0xb5c0fbcf + W[ 2];
-	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
-	t1 = e + e1(b) + Ch(b,c,d) + 0xe9b5dba5 + W[ 3];
-	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
-	t1 = d + e1(a) + Ch(a,b,c) + 0x3956c25b + W[ 4];
-	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
-	t1 = c + e1(h) + Ch(h,a,b) + 0x59f111f1 + W[ 5];
-	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
-	t1 = b + e1(g) + Ch(g,h,a) + 0x923f82a4 + W[ 6];
-	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
-	t1 = a + e1(f) + Ch(f,g,h) + 0xab1c5ed5 + W[ 7];
-	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
-
-	t1 = h + e1(e) + Ch(e,f,g) + 0xd807aa98 + W[ 8];
-	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
-	t1 = g + e1(d) + Ch(d,e,f) + 0x12835b01 + W[ 9];
-	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
-	t1 = f + e1(c) + Ch(c,d,e) + 0x243185be + W[10];
-	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
-	t1 = e + e1(b) + Ch(b,c,d) + 0x550c7dc3 + W[11];
-	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
-	t1 = d + e1(a) + Ch(a,b,c) + 0x72be5d74 + W[12];
-	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
-	t1 = c + e1(h) + Ch(h,a,b) + 0x80deb1fe + W[13];
-	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
-	t1 = b + e1(g) + Ch(g,h,a) + 0x9bdc06a7 + W[14];
-	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
-	t1 = a + e1(f) + Ch(f,g,h) + 0xc19bf174 + W[15];
-	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
-
-	t1 = h + e1(e) + Ch(e,f,g) + 0xe49b69c1 + W[16];
-	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
-	t1 = g + e1(d) + Ch(d,e,f) + 0xefbe4786 + W[17];
-	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
-	t1 = f + e1(c) + Ch(c,d,e) + 0x0fc19dc6 + W[18];
-	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
-	t1 = e + e1(b) + Ch(b,c,d) + 0x240ca1cc + W[19];
-	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
-	t1 = d + e1(a) + Ch(a,b,c) + 0x2de92c6f + W[20];
-	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
-	t1 = c + e1(h) + Ch(h,a,b) + 0x4a7484aa + W[21];
-	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
-	t1 = b + e1(g) + Ch(g,h,a) + 0x5cb0a9dc + W[22];
-	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
-	t1 = a + e1(f) + Ch(f,g,h) + 0x76f988da + W[23];
-	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
-
-	t1 = h + e1(e) + Ch(e,f,g) + 0x983e5152 + W[24];
-	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
-	t1 = g + e1(d) + Ch(d,e,f) + 0xa831c66d + W[25];
-	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
-	t1 = f + e1(c) + Ch(c,d,e) + 0xb00327c8 + W[26];
-	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
-	t1 = e + e1(b) + Ch(b,c,d) + 0xbf597fc7 + W[27];
-	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
-	t1 = d + e1(a) + Ch(a,b,c) + 0xc6e00bf3 + W[28];
-	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
-	t1 = c + e1(h) + Ch(h,a,b) + 0xd5a79147 + W[29];
-	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
-	t1 = b + e1(g) + Ch(g,h,a) + 0x06ca6351 + W[30];
-	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
-	t1 = a + e1(f) + Ch(f,g,h) + 0x14292967 + W[31];
-	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
-
-	t1 = h + e1(e) + Ch(e,f,g) + 0x27b70a85 + W[32];
-	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
-	t1 = g + e1(d) + Ch(d,e,f) + 0x2e1b2138 + W[33];
-	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
-	t1 = f + e1(c) + Ch(c,d,e) + 0x4d2c6dfc + W[34];
-	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
-	t1 = e + e1(b) + Ch(b,c,d) + 0x53380d13 + W[35];
-	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
-	t1 = d + e1(a) + Ch(a,b,c) + 0x650a7354 + W[36];
-	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
-	t1 = c + e1(h) + Ch(h,a,b) + 0x766a0abb + W[37];
-	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
-	t1 = b + e1(g) + Ch(g,h,a) + 0x81c2c92e + W[38];
-	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
-	t1 = a + e1(f) + Ch(f,g,h) + 0x92722c85 + W[39];
-	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
-
-	t1 = h + e1(e) + Ch(e,f,g) + 0xa2bfe8a1 + W[40];
-	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
-	t1 = g + e1(d) + Ch(d,e,f) + 0xa81a664b + W[41];
-	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
-	t1 = f + e1(c) + Ch(c,d,e) + 0xc24b8b70 + W[42];
-	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
-	t1 = e + e1(b) + Ch(b,c,d) + 0xc76c51a3 + W[43];
-	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
-	t1 = d + e1(a) + Ch(a,b,c) + 0xd192e819 + W[44];
-	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
-	t1 = c + e1(h) + Ch(h,a,b) + 0xd6990624 + W[45];
-	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
-	t1 = b + e1(g) + Ch(g,h,a) + 0xf40e3585 + W[46];
-	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
-	t1 = a + e1(f) + Ch(f,g,h) + 0x106aa070 + W[47];
-	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
-
-	t1 = h + e1(e) + Ch(e,f,g) + 0x19a4c116 + W[48];
-	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
-	t1 = g + e1(d) + Ch(d,e,f) + 0x1e376c08 + W[49];
-	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
-	t1 = f + e1(c) + Ch(c,d,e) + 0x2748774c + W[50];
-	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
-	t1 = e + e1(b) + Ch(b,c,d) + 0x34b0bcb5 + W[51];
-	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
-	t1 = d + e1(a) + Ch(a,b,c) + 0x391c0cb3 + W[52];
-	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
-	t1 = c + e1(h) + Ch(h,a,b) + 0x4ed8aa4a + W[53];
-	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
-	t1 = b + e1(g) + Ch(g,h,a) + 0x5b9cca4f + W[54];
-	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
-	t1 = a + e1(f) + Ch(f,g,h) + 0x682e6ff3 + W[55];
-	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
-
-	t1 = h + e1(e) + Ch(e,f,g) + 0x748f82ee + W[56];
-	t2 = e0(a) + Maj(a,b,c);    d+=t1;    h=t1+t2;
-	t1 = g + e1(d) + Ch(d,e,f) + 0x78a5636f + W[57];
-	t2 = e0(h) + Maj(h,a,b);    c+=t1;    g=t1+t2;
-	t1 = f + e1(c) + Ch(c,d,e) + 0x84c87814 + W[58];
-	t2 = e0(g) + Maj(g,h,a);    b+=t1;    f=t1+t2;
-	t1 = e + e1(b) + Ch(b,c,d) + 0x8cc70208 + W[59];
-	t2 = e0(f) + Maj(f,g,h);    a+=t1;    e=t1+t2;
-	t1 = d + e1(a) + Ch(a,b,c) + 0x90befffa + W[60];
-	t2 = e0(e) + Maj(e,f,g);    h+=t1;    d=t1+t2;
-	t1 = c + e1(h) + Ch(h,a,b) + 0xa4506ceb + W[61];
-	t2 = e0(d) + Maj(d,e,f);    g+=t1;    c=t1+t2;
-	t1 = b + e1(g) + Ch(g,h,a) + 0xbef9a3f7 + W[62];
-	t2 = e0(c) + Maj(c,d,e);    f+=t1;    b=t1+t2;
-	t1 = a + e1(f) + Ch(f,g,h) + 0xc67178f2 + W[63];
-	t2 = e0(b) + Maj(b,c,d);    e+=t1;    a=t1+t2;
-
-	state[0] += a; state[1] += b; state[2] += c; state[3] += d;
-	state[4] += e; state[5] += f; state[6] += g; state[7] += h;
-
-	/* clear any sensitive info... */
-	a = b = c = d = e = f = g = h = t1 = t2 = 0;
-	memzero_explicit(W, 64 * sizeof(u32));
-}
-
-static void sha256_generic_block_fn(struct sha256_state *sst, u8 const *src,
-				    int blocks)
-{
-	while (blocks--) {
-		sha256_transform(sst->state, src);
-		src += SHA256_BLOCK_SIZE;
-	}
-}
-
-void sha256_update_direct(struct sha256_state *sctx, const u8 *data,
-			  unsigned int len)
-{
-	__sha256_base_do_update(sctx, data, len, sha256_generic_block_fn);
-}
-EXPORT_SYMBOL(sha256_update_direct);
-
 int crypto_sha256_update(struct shash_desc *desc, const u8 *data,
 			  unsigned int len)
 {
@@ -257,14 +51,6 @@ static int sha256_final(struct shash_desc *desc, u8 *out)
 	return 0;
 }
 
-void __sha256_final_direct(struct sha256_state *sctx, unsigned int digest_size,
-			   u8 *out)
-{
-	sha256_do_finalize_direct(sctx, sha256_generic_block_fn);
-	__sha256_base_finish(sctx, digest_size, out);
-}
-EXPORT_SYMBOL(sha256_final_direct);
-
 int crypto_sha256_finup(struct shash_desc *desc, const u8 *data,
 			unsigned int len, u8 *hash)
 {
-- 
2.21.0

