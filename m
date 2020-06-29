Return-Path: <SRS0=qXKu=AK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A14BC433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0667620656
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jun 2020 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593466868;
	bh=7Y5xZ76bHIz+nL86N9wS8g1Q/maA8uLO1WTDULpHDGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=HL+q4b5I5l6NJXvFjXTk75aFHgsF6Je4t+LX+8CEFg/PKiY8JAL1eC36zs6xktjiG
	 8WXog1y3HyC1wFtN99B7oEPp2zPhokd2hHlBTA4x7G7tx0JwTsPrAr5kSnpw1/fU/w
	 YrmxoHzsRfK8gyk3FUMYzkK3s2tonwZoityWgCiQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgF2VlG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbgF2SkV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:21 -0400
Received: from localhost.localdomain (82-64-249-211.subs.proxad.net [82.64.249.211])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93C3C23331;
        Mon, 29 Jun 2020 07:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593416387;
        bh=7Y5xZ76bHIz+nL86N9wS8g1Q/maA8uLO1WTDULpHDGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjaTxkVQo77RnjMTvqsm9J9gDC64ewZzlQTUMR3ICZow8sEUu3OwKFmbP8XoNkjqY
         9+BtfIXj3nd5SajtkhkGthbSlf/Vpwb1+hi1Co3uSG/7IAZ5JpdiNXv+rSoi4W75cx
         Wl7Xl1bRzo3bu8oikqo+03Vhtn4pLEsVNPQwWgHc=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5/5] crypto: arm/ghash - use variably sized key struct
Date:   Mon, 29 Jun 2020 09:39:25 +0200
Message-Id: <20200629073925.127538-6-ardb@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200629073925.127538-1-ardb@kernel.org>
References: <20200629073925.127538-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Of the two versions of GHASH that the ARM driver implements, only one
performs aggregation, and so the other one has no use for the powers
of H to be precomputed, or space to be allocated for them in the key
struct. So make the context size dependent on which version is being
selected, and while at it, use a static key to carry this decision,
and get rid of the function pointer.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/crypto/ghash-ce-glue.c | 51 +++++++++-----------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
index a00fd329255f..f13401f3e669 100644
--- a/arch/arm/crypto/ghash-ce-glue.c
+++ b/arch/arm/crypto/ghash-ce-glue.c
@@ -16,6 +16,7 @@
 #include <crypto/gf128mul.h>
 #include <linux/cpufeature.h>
 #include <linux/crypto.h>
+#include <linux/jump_label.h>
 #include <linux/module.h>
 
 MODULE_DESCRIPTION("GHASH hash function using ARMv8 Crypto Extensions");
@@ -27,12 +28,8 @@ MODULE_ALIAS_CRYPTO("ghash");
 #define GHASH_DIGEST_SIZE	16
 
 struct ghash_key {
-	u64	h[2];
-	u64	h2[2];
-	u64	h3[2];
-	u64	h4[2];
-
 	be128	k;
+	u64	h[][2];
 };
 
 struct ghash_desc_ctx {
@@ -46,16 +43,12 @@ struct ghash_async_ctx {
 };
 
 asmlinkage void pmull_ghash_update_p64(int blocks, u64 dg[], const char *src,
-				       struct ghash_key const *k,
-				       const char *head);
+				       u64 const h[][2], const char *head);
 
 asmlinkage void pmull_ghash_update_p8(int blocks, u64 dg[], const char *src,
-				      struct ghash_key const *k,
-				      const char *head);
+				      u64 const h[][2], const char *head);
 
-static void (*pmull_ghash_update)(int blocks, u64 dg[], const char *src,
-				  struct ghash_key const *k,
-				  const char *head);
+static __ro_after_init DEFINE_STATIC_KEY_FALSE(use_p64);
 
 static int ghash_init(struct shash_desc *desc)
 {
@@ -70,7 +63,10 @@ static void ghash_do_update(int blocks, u64 dg[], const char *src,
 {
 	if (likely(crypto_simd_usable())) {
 		kernel_neon_begin();
-		pmull_ghash_update(blocks, dg, src, key, head);
+		if (static_branch_likely(&use_p64))
+			pmull_ghash_update_p64(blocks, dg, src, key->h, head);
+		else
+			pmull_ghash_update_p8(blocks, dg, src, key->h, head);
 		kernel_neon_end();
 	} else {
 		be128 dst = { cpu_to_be64(dg[1]), cpu_to_be64(dg[0]) };
@@ -161,25 +157,26 @@ static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *inkey, unsigned int keylen)
 {
 	struct ghash_key *key = crypto_shash_ctx(tfm);
-	be128 h;
 
 	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
 
 	/* needed for the fallback */
 	memcpy(&key->k, inkey, GHASH_BLOCK_SIZE);
-	ghash_reflect(key->h, &key->k);
+	ghash_reflect(key->h[0], &key->k);
 
-	h = key->k;
-	gf128mul_lle(&h, &key->k);
-	ghash_reflect(key->h2, &h);
+	if (static_branch_likely(&use_p64)) {
+		be128 h = key->k;
 
-	gf128mul_lle(&h, &key->k);
-	ghash_reflect(key->h3, &h);
+		gf128mul_lle(&h, &key->k);
+		ghash_reflect(key->h[1], &h);
 
-	gf128mul_lle(&h, &key->k);
-	ghash_reflect(key->h4, &h);
+		gf128mul_lle(&h, &key->k);
+		ghash_reflect(key->h[2], &h);
 
+		gf128mul_lle(&h, &key->k);
+		ghash_reflect(key->h[3], &h);
+	}
 	return 0;
 }
 
@@ -195,7 +192,7 @@ static struct shash_alg ghash_alg = {
 	.base.cra_driver_name	= "ghash-ce-sync",
 	.base.cra_priority	= 300 - 1,
 	.base.cra_blocksize	= GHASH_BLOCK_SIZE,
-	.base.cra_ctxsize	= sizeof(struct ghash_key),
+	.base.cra_ctxsize	= sizeof(struct ghash_key) + sizeof(u64[2]),
 	.base.cra_module	= THIS_MODULE,
 };
 
@@ -354,10 +351,10 @@ static int __init ghash_ce_mod_init(void)
 	if (!(elf_hwcap & HWCAP_NEON))
 		return -ENODEV;
 
-	if (elf_hwcap2 & HWCAP2_PMULL)
-		pmull_ghash_update = pmull_ghash_update_p64;
-	else
-		pmull_ghash_update = pmull_ghash_update_p8;
+	if (elf_hwcap2 & HWCAP2_PMULL) {
+		ghash_alg.base.cra_ctxsize += 3 * sizeof(u64[2]);
+		static_branch_enable(&use_p64);
+	}
 
 	err = crypto_register_shash(&ghash_alg);
 	if (err)
-- 
2.20.1

