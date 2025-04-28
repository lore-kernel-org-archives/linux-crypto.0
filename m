Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72E11BBBFD;
	Mon, 28 Apr 2025 18:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745865557; cv=none; b=Z9sAXjen5U3jAcZW9EV02RwFrfq22Lql9LWL3pX1X0TeLNtar4Y+g0wIeSiEZTCkmZMRmuOiewGPSGR8lGb39AdxBPhcuNTJSIiBPTP2dILmJhLsF7whqEa/rdFoI2tHEunCQ/Ktz3OPOIwGeIDP8uPhVXM7hkZS4syBLhQneWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745865557; c=relaxed/simple;
	bh=1g5UsXA4X/cUaqdKytfkoN8xTqDuxiR3Ac2nTac0D0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eQTtfj3FulNodp7DhYIv5nzwG+Ll1tG/pXsytalCFAliylkEr7EFPto4FXbT9cWErUj8gVuWu1ySYHIZL0bzP1XVeQJFX0lg+8YzMy9WeX4w0lPbQV3gyKDPKfxKw/Ls8BVdGV42T5/9cfM2PNd3eSJVDATGQOxherfRqphDomc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GKlBgZjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GKlBgZjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDE0C4CEEC;
	Mon, 28 Apr 2025 18:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745865555;
	bh=1g5UsXA4X/cUaqdKytfkoN8xTqDuxiR3Ac2nTac0D0s=;
	h=From:To:Cc:Subject:Date:From;
	b=GKlBgZjUebfOQvhUlhLsa1Stsc986glohqumv/oxWqvv5Hy9tnBohba5TMspZSB25
	 2fpLYfmBfzWNUdBwmCERcWDyV4HwKRy1RG0ogybvqJFO3WLcV8FJSAtxKI6TRF0x1K
	 VI1mBKCEdkaSUktL2PGxeiPde0RMl8mRFftg+sQGmqHOlHxuUrepfimFa+JogETtWj
	 AD/p/qPfPBCzGKhWduu4QP4GEm89FKTreIjZwv3BwgyRAfiXnT3XjNlXYh4vcPDe2Q
	 ZsQaJe5hGA7o1If/PttqrnqY3+9LpBlv2k80zuHvXFN78R9aMOLfqcWEjSimD98ZCj
	 jq1wjICWWAF/Q==
From: Eric Biggers <ebiggers@kernel.org>
To: x86@kernel.org,
	linux-sgx@vger.kernel.org,
	Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: [PATCH] x86/sgx: Use SHA-256 library API instead of crypto_shash API
Date: Mon, 28 Apr 2025 11:38:38 -0700
Message-ID: <20250428183838.799333-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

This user of SHA-256 does not support any other algorithm, so the
crypto_shash abstraction provides no value.  Just use the SHA-256
library API instead, which is much simpler and easier to use.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This patch is targeting the x86 tree for 6.16.

 arch/x86/Kconfig                 |  3 +--
 arch/x86/kernel/cpu/sgx/driver.h |  1 -
 arch/x86/kernel/cpu/sgx/ioctl.c  | 30 ++----------------------------
 3 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index faafd99e52292..bf4874ba4fcfb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1880,12 +1880,11 @@ config X86_INTEL_TSX_MODE_AUTO
 endchoice
 
 config X86_SGX
 	bool "Software Guard eXtensions (SGX)"
 	depends on X86_64 && CPU_SUP_INTEL && X86_X2APIC
-	depends on CRYPTO=y
-	depends on CRYPTO_SHA256=y
+	select CRYPTO_LIB_SHA256
 	select MMU_NOTIFIER
 	select NUMA_KEEP_MEMINFO if NUMA
 	select XARRAY_MULTI
 	help
 	  Intel(R) Software Guard eXtensions (SGX) is a set of CPU instructions
diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
index 4eddb4d571ef2..30f39f92c98fc 100644
--- a/arch/x86/kernel/cpu/sgx/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver.h
@@ -1,10 +1,9 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __ARCH_SGX_DRIVER_H__
 #define __ARCH_SGX_DRIVER_H__
 
-#include <crypto/hash.h>
 #include <linux/kref.h>
 #include <linux/mmu_notifier.h>
 #include <linux/radix-tree.h>
 #include <linux/rwsem.h>
 #include <linux/sched.h>
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 776a20172867e..66f1efa16fbb7 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -1,10 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 /*  Copyright(c) 2016-20 Intel Corporation. */
 
 #include <asm/mman.h>
 #include <asm/sgx.h>
+#include <crypto/sha2.h>
 #include <linux/mman.h>
 #include <linux/delay.h>
 #include <linux/file.h>
 #include <linux/hashtable.h>
 #include <linux/highmem.h>
@@ -461,35 +462,10 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 		return -EFAULT;
 
 	return ret;
 }
 
-static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
-			      void *hash)
-{
-	SHASH_DESC_ON_STACK(shash, tfm);
-
-	shash->tfm = tfm;
-
-	return crypto_shash_digest(shash, modulus, SGX_MODULUS_SIZE, hash);
-}
-
-static int sgx_get_key_hash(const void *modulus, void *hash)
-{
-	struct crypto_shash *tfm;
-	int ret;
-
-	tfm = crypto_alloc_shash("sha256", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	ret = __sgx_get_key_hash(tfm, modulus, hash);
-
-	crypto_free_shash(tfm);
-	return ret;
-}
-
 static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 			 void *token)
 {
 	u64 mrsigner[4];
 	int i, j;
@@ -521,13 +497,11 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 	if (sigstruct->body.xfrm & sigstruct->body.xfrm_mask &
 	    sgx_xfrm_reserved_mask)
 		return -EINVAL;
 
-	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
-	if (ret)
-		return ret;
+	sha256(sigstruct->modulus, SGX_MODULUS_SIZE, (u8 *)mrsigner);
 
 	mutex_lock(&encl->lock);
 
 	/*
 	 * ENCLS[EINIT] is interruptible because it has such a high latency,

base-commit: 33035b665157558254b3c21c3f049fd728e72368
-- 
2.49.0

