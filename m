Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0FC296BD7;
	Sat,  6 Sep 2025 21:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757194619; cv=none; b=AtHA2Rgk6Ak3vwYLc83rIAgU/cNN4zNvc8vrvH9gl6ikjt+C8qldMbAqY3DTcTpDuMDeGWC1gzkcGATPoyD79ti+9RDf8mqbfxvdGuQvYbnIslgWSw39kAR3WqsU4v5cXpUIxIkx8XSs/LlQFNldD9p8gckyVsYEzh/OJ4il5Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757194619; c=relaxed/simple;
	bh=VPdOFbOFfFUM5Rs4n3jQWJkq3lHGWPzXISc9hbkpRBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYAol0XsWwX87ZkoncvDIFpvAE6qbIIhFRzilgVL1OBTSQ7DyPBDyOQkABJBk0o3Y6meqGBS7KEOJ7fLJH40lmA3E1ufTiOkJ79kmpqEaqEf+vaSaUZ/IndJjqBdjYQHU0I4xOrcMqm1XcppdlnuzRADj+v1MU9gRWqjKVQKgqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hFZ9itCY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFZ9itCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65AA4C4CEE7;
	Sat,  6 Sep 2025 21:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757194619;
	bh=VPdOFbOFfFUM5Rs4n3jQWJkq3lHGWPzXISc9hbkpRBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFZ9itCYTgBY8M3fyX1sur3owxrvaazIwm6xawrcX4SCSDQBTyAybxUVEO3E7SfBp
	 1XzDRCvP66sqF3xlf9dC6R5apsZtV722vGcWmjrvgppKRlxh2FJp6pTy4dheq4aD0A
	 s2OfuXlqZ0St4oB9PKXIrFhnUNWEppWsV3xOd5w3ERFSSlDo76CM5nSX/XedRvmRGU
	 ZIzz6IOTsmSB/XYZwRNo1amYMoLhZMOl3uyB+QiW/ot25KvlCtUb8Xbcif9fWRc+M3
	 qhedcfIAOmMRSewykNZC4eR6pDA1UZYU9/pi5XmiwraGdhlmZnp1ErR/tz0cvQRRpy
	 yfUVU0SmS7HoA==
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
Subject: [PATCH v2 03/12] crypto: powerpc/curve25519 - Remove unused kpp support
Date: Sat,  6 Sep 2025 14:35:14 -0700
Message-ID: <20250906213523.84915-4-ebiggers@kernel.org>
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
remove the unused "curve25519-ppc64le" kpp algorithm.

Note that the underlying PowerPC optimized Curve25519 code remains fully
supported and accessible via the library API.

It's also worth noting that even if the kpp support for Curve25519 comes
back later, there is no need for arch-specific kpp glue code like this,
as a single kpp algorithm that wraps the library API is sufficient.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/powerpc/crypto/Kconfig                   |   1 -
 arch/powerpc/crypto/curve25519-ppc64le-core.c | 105 ------------------
 2 files changed, 106 deletions(-)

diff --git a/arch/powerpc/crypto/Kconfig b/arch/powerpc/crypto/Kconfig
index f4b779c7352de..6106a219da6af 100644
--- a/arch/powerpc/crypto/Kconfig
+++ b/arch/powerpc/crypto/Kconfig
@@ -3,11 +3,10 @@
 menu "Accelerated Cryptographic Algorithms for CPU (powerpc)"
 
 config CRYPTO_CURVE25519_PPC64
 	tristate
 	depends on PPC64 && CPU_LITTLE_ENDIAN
-	select CRYPTO_KPP
 	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	default CRYPTO_LIB_CURVE25519_INTERNAL
 	help
 	  Curve25519 algorithm
diff --git a/arch/powerpc/crypto/curve25519-ppc64le-core.c b/arch/powerpc/crypto/curve25519-ppc64le-core.c
index f7810be0b292b..6eb18ee19cad3 100644
--- a/arch/powerpc/crypto/curve25519-ppc64le-core.c
+++ b/arch/powerpc/crypto/curve25519-ppc64le-core.c
@@ -6,17 +6,15 @@
  *   Based on RFC7748 and AArch64 optimized implementation for X25519
  *     - Algorithm 1 Scalar multiplication of a variable point
  */
 
 #include <crypto/curve25519.h>
-#include <crypto/internal/kpp.h>
 
 #include <linux/types.h>
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/scatterlist.h>
 
 #include <linux/cpufeature.h>
 #include <linux/processor.h>
 
 typedef uint64_t fe51[5];
@@ -190,111 +188,8 @@ void curve25519_base_arch(u8 pub[CURVE25519_KEY_SIZE],
 {
 	curve25519_fe51(pub, secret, curve25519_base_point);
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
-	.base.cra_driver_name	= "curve25519-ppc64le",
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
-static int __init curve25519_mod_init(void)
-{
-	return IS_REACHABLE(CONFIG_CRYPTO_KPP) ?
-		crypto_register_kpp(&curve25519_alg) : 0;
-}
-
-static void __exit curve25519_mod_exit(void)
-{
-	if (IS_REACHABLE(CONFIG_CRYPTO_KPP))
-		crypto_unregister_kpp(&curve25519_alg);
-}
-
-module_init(curve25519_mod_init);
-module_exit(curve25519_mod_exit);
-
-MODULE_ALIAS_CRYPTO("curve25519");
-MODULE_ALIAS_CRYPTO("curve25519-ppc64le");
 MODULE_DESCRIPTION("PPC64le Curve25519 scalar multiplication with 51 bits limbs");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Danny Tsen <dtsen@us.ibm.com>");
-- 
2.50.1

