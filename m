Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D012749CD;
	Tue, 22 Apr 2025 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745335335; cv=none; b=Ipy/8rUaNRcB37p8+dTdge8Q2C//8tji+vOj3Z0YmS8W2ARAE+uZ7nfQFzbnqui2DGzVXAT/7siOYrmokTodg1o1OzUSzaRNCGBDaE0B6mG7LXkdI6JSGhvkygbU3nGeL9DyrwoAoMH15kNk78vuJDaiE6qJWbhmCghKCuTdYhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745335335; c=relaxed/simple;
	bh=VWdIHfp62FpQhsxJqqk7rsXa3ipyLUWLzEXRYrT1f/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0rV8JJKukncV/qdjHvDaVq604rS1qx+8BV2OJnxv2f9iaP9f0XnCcwEYYSD9PLfwdKfxRHOknqhCmn749prXBKZrHmtH9gFJxO/m58MArYojkbRmxhr9ecY8OOWty2p5zRdPgItKptfwZKF2BlZiXCzhOVsuxTbiWwB+kRLYWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hFnHCsvu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hFnHCsvu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853AEC4CEEE;
	Tue, 22 Apr 2025 15:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745335335;
	bh=VWdIHfp62FpQhsxJqqk7rsXa3ipyLUWLzEXRYrT1f/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFnHCsvuhC/wMzsAMqn1LrjxhKuVmxIJcc3M/o4owu4b6P+DFyCsOQvbLL8O9KMxk
	 eUyBIHIFV+A/49vvlGsoK17nVykThYgHhF9MlpuC9I4KP4yJG8wA1JoK9YMkfkzR3Y
	 9C/O9kZaYZ9tcs0b+YNfJeY1bxGFC09oDf9/+1ccXHWeYkX/Nl7sH4jYzSRjF8KAaF
	 lj7VnhQSQ9I1i1MoRcPkKlNF65hVTQTPyPssdlNcbbGQOwRhnqSw0EPHwDGkenupr0
	 coJjvu+kpVQGmzRSlx9F8gbdbcIfMwL/9xFredP7aDY1NyTejRxhSbxLcmZJNRS1+d
	 f1vNILuC1WtDQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/9] crypto: tcrypt - rename CRYPTO_TEST to CRYPTO_BENCHMARK
Date: Tue, 22 Apr 2025 08:21:44 -0700
Message-ID: <20250422152151.3691-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250422152151.3691-1-ebiggers@kernel.org>
References: <20250422152151.3691-1-ebiggers@kernel.org>
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
index 9322e42e562de..48283975fb2ba 100644
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
index 5d2f2a28d8a07..18b057a799b02 100644
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
index 879fc21dcc166..d1d88debbd71e 100644
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
index 96c843a246071..7f938ac93e583 100644
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

