Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825E32C031E;
	Sat,  6 Sep 2025 21:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757194624; cv=none; b=eYJut3cqNx04XLABswxSKsFj0BvmHQ6U8SiDSgqJYxRPewYpvgfMVf+f20EAcKTHlgl6exTiXaPV20lzSnxAqVhsX21NFyqLpG/+ibUG5sijzLHSXHbsr5ykYud8OENM2KGmWyV9YjO+PFyxFFLDxs0I7tIluGYABxaNhhBw4fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757194624; c=relaxed/simple;
	bh=qgC3ZMySIzbT7snif3jifRd6wEGhkdEbMg6+X/hdkEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcJZZe4pe5qQFBvkJZXjKdBKmI5GdH2SMKyQNqXrgfKtlrxDSiM4dXlrKrUY6TFgEl+myGVQU6TIrN4pHTONo2yAeSMXXe7n2oRvWQV+3Vt4Bl5qulWT8kt88AbSXw2orlN/cNHUlumf7eWPx1y912oV7WioHK6DoTL3DVXWKdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HnoS8wHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HnoS8wHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC403C4CEF9;
	Sat,  6 Sep 2025 21:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757194624;
	bh=qgC3ZMySIzbT7snif3jifRd6wEGhkdEbMg6+X/hdkEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HnoS8wHmNnAGXmjtE/Ly7bQ7EaKSHOs35JkeDWyFwsdG9Ef0wGj/vRGGJi9LdHgEG
	 6554LkhwPyJSQdav86Ah8LR1Az7qGvnT8pakFGsdrktTJPFodmNAYNDA7mplknq9hY
	 OW/gW6f8vnby4h7cHEhDMspXJQB2bekl39gTwXoKOksiJVJQ+fLpNSmlq3qGP4RllR
	 mruhQRhcwQXyF50nfeUOnWCxZ05ApEJuyYd5Ns1efTg6CeAPdnoat3/ddkoslV6bvx
	 BmzBRNBrkqfhfamYYWCtEEgKPMzOAiRgIM6VVp721vi9qCEbm0FQHrHW2VfmKizDAJ
	 oKm6HcxZ1EZYA==
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
Subject: [PATCH v2 08/12] lib/crypto: tests: Add Curve25519 benchmark
Date: Sat,  6 Sep 2025 14:35:19 -0700
Message-ID: <20250906213523.84915-9-ebiggers@kernel.org>
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

Add a benchmark to curve25519_kunit.  This brings it in line with the
other crypto KUnit tests and provides an easy way to measure
performance.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/curve25519_kunit.c | 31 +++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/lib/crypto/tests/curve25519_kunit.c b/lib/crypto/tests/curve25519_kunit.c
index 0d1c46ca74018..355ad79a210d1 100644
--- a/lib/crypto/tests/curve25519_kunit.c
+++ b/lib/crypto/tests/curve25519_kunit.c
@@ -3,10 +3,11 @@
  * Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
 #include <crypto/curve25519.h>
 #include <kunit/test.h>
+#include <linux/timekeeping.h>
 
 struct curve25519_test_vector {
 	u8 private[CURVE25519_KEY_SIZE];
 	u8 public[CURVE25519_KEY_SIZE];
 	u8 result[CURVE25519_KEY_SIZE];
@@ -1314,13 +1315,43 @@ static void test_curve25519_basepoint(struct kunit *test)
 		KUNIT_EXPECT_MEMEQ_MSG(test, out, out2, CURVE25519_KEY_SIZE,
 				       "in=%*phN", CURVE25519_KEY_SIZE, in);
 	}
 }
 
+static void benchmark_curve25519(struct kunit *test)
+{
+	const u8 *private = curve25519_test_vectors[0].private;
+	const u8 *public = curve25519_test_vectors[0].public;
+	const size_t warmup_niter = 5000;
+	const size_t benchmark_niter = 1024;
+	u8 out[CURVE25519_KEY_SIZE];
+	bool ok = true;
+	u64 t;
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))
+		kunit_skip(test, "not enabled");
+
+	/* Warm-up */
+	for (size_t i = 0; i < warmup_niter; i++)
+		ok &= curve25519(out, private, public);
+
+	/* Benchmark */
+	preempt_disable();
+	t = ktime_get_ns();
+	for (size_t i = 0; i < benchmark_niter; i++)
+		ok &= curve25519(out, private, public);
+	t = ktime_get_ns() - t;
+	preempt_enable();
+	KUNIT_EXPECT_TRUE(test, ok);
+	kunit_info(test, "%llu ops/s",
+		   div64_u64((u64)benchmark_niter * NSEC_PER_SEC, t ?: 1));
+}
+
 static struct kunit_case curve25519_test_cases[] = {
 	KUNIT_CASE(test_curve25519),
 	KUNIT_CASE(test_curve25519_basepoint),
+	KUNIT_CASE(benchmark_curve25519),
 	{},
 };
 
 static struct kunit_suite curve25519_test_suite = {
 	.name = "curve25519",
-- 
2.50.1

