Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6E42135AD;
	Sat,  6 Sep 2025 21:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757194620; cv=none; b=ElS0vAzEcysA5kAF82Aigoir5WIfxy5kaBPSndcL7ZehuwgdFetL3kyUtRIoIPOQAqWNeTUArnsj39/DJbdemWb1XvWp/oqtPlnwscWIq7p3ykWNjSg85M8+jeb6bSbUmQZ+3/6xTELHxRimou5+ZR17LLKRcNeUwb+PGUx2+nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757194620; c=relaxed/simple;
	bh=b2kyrv9GFCik/BKIFbZ27LKOAd7AEvTjfTWJfDtuZc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKngDyGQIp7KgMy/qH5PbCgIQjNDb1cjqjC1p+LPEE3CkdoywMWnIAXeXR5TN87V23mT06noRniK+3/g1zXR0bbf15Sj4lyGCfR6rm+0n9OBOWnwAw5rVQnbPxpBV2GC6Mw74JQq39PSfkk/TkxMj7VnrbhOl80vJvu8v8tWOvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ui3AP+Vw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ui3AP+Vw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AECFC4CEF9;
	Sat,  6 Sep 2025 21:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757194620;
	bh=b2kyrv9GFCik/BKIFbZ27LKOAd7AEvTjfTWJfDtuZc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ui3AP+Vwt2+C0Wwth5KD5a1GA7Y0lDSKB/05nC07zKJG6qYA3fflzkHi63TuHJjkt
	 nOmmgDsiYO3KOHgpAg9ZanfcC53poi6noKU5idw3F/I0L2YHmNM+ek63DJqHc/BXRy
	 3PzbXbkgp6mU1+oigacKmZcEXT8QFteYSoLStAWpE0EbAXvFm3uNTtUzzgk410X9TE
	 IG4ivYk5HDze/2UYiHlqo07IWxq+UDWqKNdFG1s4Out4kerTjLjYB0cpI+y2dl4N1K
	 E3xzm8akEZCP6aDXpz6x7te/y2C6v7UzYXvKm05hwQKuqvvzTTh8MbTrBTrXjqUQkF
	 eI5Y/Qc4+BQ2Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 04/12] crypto: x86/curve25519 - Remove unused kpp support
Date: Sat,  6 Sep 2025 14:35:15 -0700
Message-ID: <20250906213523.84915-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250906213523.84915-1-ebiggers@kernel.org>
References: <20250906213523.84915-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Curve25519 is used only via the library API, not the crypto_kpp API.  In
preparation for removing the unused crypto_kpp API for Curve25519,
remove the unused "curve25519-x86" kpp algorithm.

Note that the underlying x86_64 optimized Curve25519 code remains fully
supported and accessible via the library API.

It's also worth noting that even if the kpp support for Curve25519 comes
back later, there is no need for arch-specific kpp glue code like this,
as a single kpp algorithm that wraps the library API is sufficient.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig             |  1 -
 arch/x86/crypto/curve25519-x86_64.c | 98 +----------------------------
 2 files changed, 1 insertion(+), 98 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 94016c60561e2..6a895a571b00e 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -3,11 +3,10 @@
 menu "Accelerated Cryptographic Algorithms for CPU (x86)"
 
 config CRYPTO_CURVE25519_X86
 	tristate
 	depends on 64BIT
-	select CRYPTO_KPP
 	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	default CRYPTO_LIB_CURVE25519_INTERNAL
 	help
 	  Curve25519 algorithm
diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
index d587f05c3c8c3..ab91368284a47 100644
--- a/arch/x86/crypto/curve25519-x86_64.c
+++ b/arch/x86/crypto/curve25519-x86_64.c
@@ -3,18 +3,16 @@
  * Copyright (C) 2020 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  * Copyright (c) 2016-2020 INRIA, CMU and Microsoft Corporation
  */
 
 #include <crypto/curve25519.h>
-#include <crypto/internal/kpp.h>
 
 #include <linux/export.h>
 #include <linux/types.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
 
 #include <asm/cpufeature.h>
 #include <asm/processor.h>
 
 static __always_inline u64 eq_mask(u64 a, u64 b)
@@ -1611,116 +1609,22 @@ void curve25519_base_arch(u8 pub[CURVE25519_KEY_SIZE],
 	else
 		curve25519_generic(pub, secret, curve25519_base_point);
 }
 EXPORT_SYMBOL(curve25519_base_arch);
 
-static int curve25519_set_secret(struct crypto_kpp *tfm, const void *buf,
-				 unsigned int len)
-{
-	u8 *secret = kpp_tfm_ctx(tfm);
-
-	if (!len)
-		curve25519_generate_secret(secret);
-	else if (len == CURVE25519_KEY_SIZE &&
-		 crypto_memneq(buf, curve25519_null_point, CURVE25519_KEY_SIZE))
-		memcpy(secret, buf, CURVE25519_KEY_SIZE);
-	else
-		return -EINVAL;
-	return 0;
-}
-
-static int curve25519_generate_public_key(struct kpp_request *req)
-{
-	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
-	const u8 *secret = kpp_tfm_ctx(tfm);
-	u8 buf[CURVE25519_KEY_SIZE];
-	int copied, nbytes;
-
-	if (req->src)
-		return -EINVAL;
-
-	curve25519_base_arch(buf, secret);
-
-	/* might want less than we've got */
-	nbytes = min_t(size_t, CURVE25519_KEY_SIZE, req->dst_len);
-	copied = sg_copy_from_buffer(req->dst, sg_nents_for_len(req->dst,
-								nbytes),
-				     buf, nbytes);
-	if (copied != nbytes)
-		return -EINVAL;
-	return 0;
-}
-
-static int curve25519_compute_shared_secret(struct kpp_request *req)
-{
-	struct crypto_kpp *tfm = crypto_kpp_reqtfm(req);
-	const u8 *secret = kpp_tfm_ctx(tfm);
-	u8 public_key[CURVE25519_KEY_SIZE];
-	u8 buf[CURVE25519_KEY_SIZE];
-	int copied, nbytes;
-
-	if (!req->src)
-		return -EINVAL;
-
-	copied = sg_copy_to_buffer(req->src,
-				   sg_nents_for_len(req->src,
-						    CURVE25519_KEY_SIZE),
-				   public_key, CURVE25519_KEY_SIZE);
-	if (copied != CURVE25519_KEY_SIZE)
-		return -EINVAL;
-
-	curve25519_arch(buf, secret, public_key);
-
-	/* might want less than we've got */
-	nbytes = min_t(size_t, CURVE25519_KEY_SIZE, req->dst_len);
-	copied = sg_copy_from_buffer(req->dst, sg_nents_for_len(req->dst,
-								nbytes),
-				     buf, nbytes);
-	if (copied != nbytes)
-		return -EINVAL;
-	return 0;
-}
-
-static unsigned int curve25519_max_size(struct crypto_kpp *tfm)
-{
-	return CURVE25519_KEY_SIZE;
-}
-
-static struct kpp_alg curve25519_alg = {
-	.base.cra_name		= "curve25519",
-	.base.cra_driver_name	= "curve25519-x86",
-	.base.cra_priority	= 200,
-	.base.cra_module	= THIS_MODULE,
-	.base.cra_ctxsize	= CURVE25519_KEY_SIZE,
-
-	.set_secret		= curve25519_set_secret,
-	.generate_public_key	= curve25519_generate_public_key,
-	.compute_shared_secret	= curve25519_compute_shared_secret,
-	.max_size		= curve25519_max_size,
-};
-
-
 static int __init curve25519_mod_init(void)
 {
 	if (boot_cpu_has(X86_FEATURE_BMI2) && boot_cpu_has(X86_FEATURE_ADX))
 		static_branch_enable(&curve25519_use_bmi2_adx);
-	else
-		return 0;
-	return IS_REACHABLE(CONFIG_CRYPTO_KPP) ?
-		crypto_register_kpp(&curve25519_alg) : 0;
+	return 0;
 }
 
 static void __exit curve25519_mod_exit(void)
 {
-	if (IS_REACHABLE(CONFIG_CRYPTO_KPP) &&
-	    static_branch_likely(&curve25519_use_bmi2_adx))
-		crypto_unregister_kpp(&curve25519_alg);
 }
 
 module_init(curve25519_mod_init);
 module_exit(curve25519_mod_exit);
 
-MODULE_ALIAS_CRYPTO("curve25519");
-MODULE_ALIAS_CRYPTO("curve25519-x86");
 MODULE_DESCRIPTION("Curve25519 algorithm, ADX optimized");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Jason A. Donenfeld <Jason@zx2c4.com>");
-- 
2.50.1

