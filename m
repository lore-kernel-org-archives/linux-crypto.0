Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D271DED72;
	Sat, 19 Apr 2025 16:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745079453; cv=none; b=KgyGShDYbVO57buQilTJV4m18Mk/cW8sYhb7KLEQTKSrMPMYc1h5nqVGky+UOvnRnNW5zJCSpAi3WfMYmyMkw3hznq34t3Lze5rUcYIMnQI6titYjzETfxsJplZlXh1NrD4f/0x+8m7OtWoQav+VBB2/ia/3OL4iTaFBKh5VbAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745079453; c=relaxed/simple;
	bh=2rB0N4riKb1i0IpUawdTCB0Q6AEMznGVzsiXwou3PqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGxmOPcv3j+ZQLMRJ2S2W60+Vs3DJbtvtZwhHF9aDAWQvsz+ywRe6tBrHOk6pclvtLdyiwdJ6g0DgBECLqgfu09SaGr9A+0VEeANecUPS88LahOZxPK40q15oW5dEftqjOdu5DN3WnysWrEN2Tsmz07ToaRNpNLcf5+Wn+re80Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uZluZb8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uZluZb8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1AAC4CEE9;
	Sat, 19 Apr 2025 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745079453;
	bh=2rB0N4riKb1i0IpUawdTCB0Q6AEMznGVzsiXwou3PqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZluZb8ZEpvO2lkPV8eOSK+v/yKedoUtr0ude2zzRXKbqkXcMzVQPet4fhSKrvYhW
	 KXMS3xb2ftaKIp3Au+LseIsWOh5l4w3QwUJgitAx6znTGtL4lIt5l9+emV0qc5IH3A
	 SyrZe2LipvjkAKiGJODw6BSVuact29t0bBLUqGNc9clA+/RGJTPO3ssrbmWvvgDSJG
	 Tfrybsu9fO50tn3zGsGXSzttYRTcpZO8Ygm8f0gK/z62iZm967XtepXePkWeaFoqkG
	 kQWKgrZ/7lSIxjG9zJcEvIusAsFGa6JVcmBs7MY3/20s0euZxRYnepA4agaXsXy4/L
	 sFfXpVGIpUrcQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] crypto: tcrypt - rename CRYPTO_TEST to CRYPTO_BENCHMARK
Date: Sat, 19 Apr 2025 09:15:36 -0700
Message-ID: <20250419161543.139344-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250419161543.139344-1-ebiggers@kernel.org>
References: <20250419161543.139344-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

tcrypt is actually a benchmarking module and not the actual tests.  This
regularly causes confusion.  Update the kconfig option name and help
text accordingly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/Kconfig  | 10 +++++++---
 crypto/Makefile |  2 +-
 crypto/tcrypt.c |  8 ++++----
 crypto/tcrypt.h |  4 ++--
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9322e42e562d..48283975fb2b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -244,16 +244,20 @@ config CRYPTO_KRB5ENC
 	help
 	  Combined hash and cipher support for Kerberos 5 RFC3961 simplified
 	  profile.  This is required for Kerberos 5-style encryption, used by
 	  sunrpc/NFS and rxrpc/AFS.
 
-config CRYPTO_TEST
-	tristate "Testing module"
+config CRYPTO_BENCHMARK
+	tristate "Crypto benchmarking module"
 	depends on m || EXPERT
 	select CRYPTO_MANAGER
 	help
-	  Quick & dirty crypto test module.
+	  Quick & dirty crypto benchmarking module.
+
+	  This is mainly intended for use by people developing cryptographic
+	  algorithms in the kernel.  It should not be enabled in production
+	  kernels.
 
 config CRYPTO_SIMD
 	tristate
 	select CRYPTO_CRYPTD
 
diff --git a/crypto/Makefile b/crypto/Makefile
index 5d2f2a28d8a0..18b057a799b0 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -171,11 +171,11 @@ obj-$(CONFIG_CRYPTO_JITTERENTROPY) += jitterentropy_rng.o
 CFLAGS_jitterentropy.o = -O0
 KASAN_SANITIZE_jitterentropy.o = n
 UBSAN_SANITIZE_jitterentropy.o = n
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
 obj-$(CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE) += jitterentropy-testing.o
-obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
+obj-$(CONFIG_CRYPTO_BENCHMARK) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_POLYVAL) += polyval-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
 obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
 obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 879fc21dcc16..d1d88debbd71 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * Quick & dirty crypto testing module.
+ * Quick & dirty crypto benchmarking module.
  *
- * This will only exist until we have a better testing mechanism
+ * This will only exist until we have a better benchmarking mechanism
  * (e.g. a char device).
  *
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) 2007 Nokia Siemens Networks
@@ -37,11 +37,11 @@
 
 #include "internal.h"
 #include "tcrypt.h"
 
 /*
- * Need slab memory for testing (size in number of pages).
+ * Need slab memory for benchmarking (size in number of pages).
  */
 #define TVMEMSIZE	4
 
 /*
 * Used by test_cipher_speed()
@@ -2866,7 +2866,7 @@ module_param(num_mb, uint, 0000);
 MODULE_PARM_DESC(num_mb, "Number of concurrent requests to be used in mb speed tests (defaults to 8)");
 module_param(klen, uint, 0);
 MODULE_PARM_DESC(klen, "Key length (defaults to 0)");
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Quick & dirty crypto testing module");
+MODULE_DESCRIPTION("Quick & dirty crypto benchmarking module");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 96c843a24607..7f938ac93e58 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -1,10 +1,10 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- * Quick & dirty crypto testing module.
+ * Quick & dirty crypto benchmarking module.
  *
- * This will only exist until we have a better testing mechanism
+ * This will only exist until we have a better benchmarking mechanism
  * (e.g. a char device).
  *
  * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
  * Copyright (c) 2002 Jean-Francois Dive <jef@linuxbe.org>
  * Copyright (c) 2007 Nokia Siemens Networks
-- 
2.49.0

