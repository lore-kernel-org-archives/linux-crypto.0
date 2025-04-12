Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5A12B9BF
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744455455; cv=none; b=ucwU6bp/wC2jnsjs4dMgdRVOAr+sdg3eFLeZDtnGrHq4jBC2eenMDdw0WgKxucJPydnUaUGTZO2ip42aEWhg0DFEYNQ+A5rW8tZL2CH4z+da3U+qzAKAXyg/B1udgMicqufcyfGEbg77iu6oTJ5+wK1cNj6OlCVRojLCpXRMtfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744455455; c=relaxed/simple;
	bh=DJg/lJavUf/y5rf/ORD0oIq++ok0nPkK57XupUbRY8U=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=WUOZNtazVJ6ml4qN/zuDZSL4WuVkpwhnrQffeCDxjX1BIOIPkrfT93JIb2fVamg75cdeCwdnyGTCVMojSJwl7PQK6XjIzbVwZbI+BaXmj+SC8RvyyHdOwmOucuHk1SwdctA3b1o7CfZvo6e8iDyfb/+FrFbhdJGb7JJX3M0r534=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gCuVlMAX; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gCuVlMAX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/cGK8DTQUaWaIVHx6FwOQIaw4QF6GuL4EzD2qR9r6Nc=; b=gCuVlMAXEAmmiRuWpOsBjtJCkA
	4xCk44dvAWxWTA7jv4myXZgRkKKiI4cmWCOrxrCPnFYbQlaArLkwV+vygLd1IUznbH0LHCoYNjLcl
	dg7bt7Wpo5AqQqfDS54rowjqJzOJ8yIMjWQtPTUiMMDjwLvDZoj+OfQPmGIwcMVExdaXpyX1hFAYR
	FQuV/MCKhWLYT8IocvXt7f+1ahHZUyJ2iNTmmDydZEEvujOCILbJd/kBjYVWCkCmR/q/Qbg9ZCIWx
	e+ffMB77HTI626h7XOr4kQ4t8vSgZDCM0/fNrBeVIVLyWuBmT0tVALS10AewM6Goles91xMaRrMbc
	yKUaQdQg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YYD-00F5Kb-0f;
	Sat, 12 Apr 2025 18:57:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:57:29 +0800
Date: Sat, 12 Apr 2025 18:57:29 +0800
Message-Id: <f3586deb6f7c58e1b344e1d8892623699e30610f.1744455146.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744455146.git.herbert@gondor.apana.org.au>
References: <cover.1744455146.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/8] crypto: lib/sm3 - Move sm3 library into lib/crypto
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Move the sm3 library code into lib/crypto.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/Kconfig    | 4 ++--
 arch/riscv/crypto/Kconfig    | 2 +-
 arch/x86/crypto/Kconfig      | 2 +-
 crypto/Kconfig               | 5 +----
 crypto/Makefile              | 1 -
 lib/crypto/Kconfig           | 3 +++
 lib/crypto/Makefile          | 3 +++
 {crypto => lib/crypto}/sm3.c | 0
 8 files changed, 11 insertions(+), 9 deletions(-)
 rename {crypto => lib/crypto}/sm3.c (100%)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index ce655da0fbee..9dd1ae7a68a4 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -101,7 +101,7 @@ config CRYPTO_SM3_NEON
 	tristate "Hash functions: SM3 (NEON)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
-	select CRYPTO_SM3
+	select CRYPTO_LIB_SM3
 	help
 	  SM3 (ShangMi 3) secure hash function (OSCCA GM/T 0004-2012)
 
@@ -112,7 +112,7 @@ config CRYPTO_SM3_ARM64_CE
 	tristate "Hash functions: SM3 (ARMv8.2 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_HASH
-	select CRYPTO_SM3
+	select CRYPTO_LIB_SM3
 	help
 	  SM3 (ShangMi 3) secure hash function (OSCCA GM/T 0004-2012)
 
diff --git a/arch/riscv/crypto/Kconfig b/arch/riscv/crypto/Kconfig
index 6392e1e11bc9..27a1f26d41bd 100644
--- a/arch/riscv/crypto/Kconfig
+++ b/arch/riscv/crypto/Kconfig
@@ -61,7 +61,7 @@ config CRYPTO_SM3_RISCV64
 	tristate "Hash functions: SM3 (ShangMi 3)"
 	depends on 64BIT && RISCV_ISA_V && TOOLCHAIN_HAS_VECTOR_CRYPTO
 	select CRYPTO_HASH
-	select CRYPTO_SM3
+	select CRYPTO_LIB_SM3
 	help
 	  SM3 (ShangMi 3) secure hash function (OSCCA GM/T 0004-2012)
 
diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index 0cec75926380..4e0bd1258751 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -455,7 +455,7 @@ config CRYPTO_SM3_AVX_X86_64
 	tristate "Hash functions: SM3 (AVX)"
 	depends on X86 && 64BIT
 	select CRYPTO_HASH
-	select CRYPTO_SM3
+	select CRYPTO_LIB_SM3
 	help
 	  SM3 secure hash function as defined by OSCCA GM/T 0004-2012 SM3
 
diff --git a/crypto/Kconfig b/crypto/Kconfig
index dbf97c4e7c59..9322e42e562d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1012,13 +1012,10 @@ config CRYPTO_SHA3
 	help
 	  SHA-3 secure hash algorithms (FIPS 202, ISO/IEC 10118-3)
 
-config CRYPTO_SM3
-	tristate
-
 config CRYPTO_SM3_GENERIC
 	tristate "SM3 (ShangMi 3)"
 	select CRYPTO_HASH
-	select CRYPTO_SM3
+	select CRYPTO_LIB_SM3
 	help
 	  SM3 (ShangMi 3) secure hash function (OSCCA GM/T 0004-2012, ISO/IEC 10118-3)
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 98510a2aa0b1..baf5040ca661 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -79,7 +79,6 @@ obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512_generic.o
 obj-$(CONFIG_CRYPTO_SHA3) += sha3_generic.o
-obj-$(CONFIG_CRYPTO_SM3) += sm3.o
 obj-$(CONFIG_CRYPTO_SM3_GENERIC) += sm3_generic.o
 obj-$(CONFIG_CRYPTO_STREEBOG) += streebog_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 798972b29b68..2c6ab80e0cdc 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -152,4 +152,7 @@ config CRYPTO_LIB_SHA1
 config CRYPTO_LIB_SHA256
 	tristate
 
+config CRYPTO_LIB_SM3
+	tristate
+
 endmenu
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 01fac1cd05a1..4dd62bc5bee3 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -60,3 +60,6 @@ endif
 obj-$(CONFIG_MPILIB) += mpi/
 
 obj-$(CONFIG_CRYPTO_MANAGER_EXTRA_TESTS)	+= simd.o
+
+obj-$(CONFIG_CRYPTO_LIB_SM3)			+= libsm3.o
+libsm3-y					:= sm3.o
diff --git a/crypto/sm3.c b/lib/crypto/sm3.c
similarity index 100%
rename from crypto/sm3.c
rename to lib/crypto/sm3.c
-- 
2.39.5

