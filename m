Return-Path: <SRS0=b7AZ=AU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282A1C433E1
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:09:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B94820786
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jul 2020 12:09:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgGIMJm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jul 2020 08:09:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35992 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726767AbgGIMJk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jul 2020 08:09:40 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jtVMv-0003Ay-Nd; Thu, 09 Jul 2020 22:09:38 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 09 Jul 2020 22:09:37 +1000
Date:   Thu, 9 Jul 2020 22:09:37 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-sparse@vger.kernel.org
Subject: Re: [PATCH 5/5] crypto: arm/ghash - use variably sized key struct
Message-ID: <20200709120937.GA13332@gondor.apana.org.au>
References: <20200629073925.127538-1-ardb@kernel.org>
 <20200629073925.127538-6-ardb@kernel.org>
 <20200709082200.GA1892@gondor.apana.org.au>
 <CAMj1kXE8HELm1j3jx-+mHrK3OjG6Rjp4jtP_QEYorRBnRxA+=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXE8HELm1j3jx-+mHrK3OjG6Rjp4jtP_QEYorRBnRxA+=w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 09, 2020 at 11:51:10AM +0300, Ard Biesheuvel wrote:
>
> That looks like a sparse bug to me. Since when is it not allowed to
> pass a non-const value as a const parameter?
> 
> I.e., you can pass a u64[] to a function that takes a u64 const *,
> giving the caller the guarantee that their u64[] will not be modified
> during the call, even if it is passed by reference.
> 
> Here, we are dealing with u64[][2], but the same reasoning holds. A
> const u64[][2] formal parameter (or u64 const (*)[2] which comes down
> to the same thing) does not require a const argument, it only tells
> the caller that the array will be left untouched. This is why the
> compiler is perfectly happy with this arrangement.

You're right.  Luc, here is the patch that triggers the bogus
warning with sparse.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
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
