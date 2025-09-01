Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D59826F2A0;
	Mon,  1 Sep 2025 20:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756758004; cv=none; b=telw62HORmdTS1zptn/voWgU8VhsYYUk+UmxQwi+q+uwoFuYK3hZoEb3paG77US8rzN7cUXe7V7UziEJsP0RGJq+yb8FcIZ9Z/Q/WaU1/oZIEChgDeGnjhYn0uJiBLjQt11031RqAuvIX5KsZA1674Pnbgf6dLX55HGpc7ATxdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756758004; c=relaxed/simple;
	bh=JT5BiLSYDda9F7JFlPUyma7+VlywOSy3ji25SAsdSjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLKuJ6Z3cdDeLXB14LzoyYqrSR1GpipciuU3vUcNrzuQMb6bP/umYO9ni3o0ZzYJpBk4T2Fj55GQcdXhcy0SEfi/iJIthZLmUVOkYI6Sl9vZEK1oqOipSY7IafkforNOJKM1vrO0DE7pdfy9+p20x1bA00av5qb7Agv0aRJ/rFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cIv556mj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cIv556mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E76C4CEF7;
	Mon,  1 Sep 2025 20:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756758003;
	bh=JT5BiLSYDda9F7JFlPUyma7+VlywOSy3ji25SAsdSjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIv556mj78srUYKhhiIsf5bRS5w3KmxqdTYYJ3t9pCTlMTQrWVdEk8o4UiDSI4da8
	 TwsnQcPkOLEGWnNN1i2BvzYxwKRZ2OL0Xta/6Ry1WG3dir2IyTPt2hQxAUf4ntRghe
	 Qe3qXPdw4iRHmCGfnZEdjb7cuzGd6mJy/wkpeWJB8sF6j3htHmWrVaTt4a9x6uB2BJ
	 8z++/1e0hOWXaqiyejBAk+ZC8jwyKDjZw3SRztPnBveuthxLs3GaAFdqU/wbcFpAj1
	 pOllmIj46N5FxKdsXbpS96eu3Mb7G6CjI/62ePYuW+7e0qpRcA4nQMVPFDzXmezuRQ
	 CxtulhW2ELojA==
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
Subject: [PATCH 3/6] lib/crypto: tests: Add Curve25519 benchmark
Date: Mon,  1 Sep 2025 13:18:12 -0700
Message-ID: <20250901201815.594177-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250901201815.594177-1-ebiggers@kernel.org>
References: <20250901201815.594177-1-ebiggers@kernel.org>
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
index 585f7ad3ed5f7..2e1d781563648 100644
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
@@ -1317,13 +1318,43 @@ static void test_curve25519_basepoint(struct kunit *test)
 		KUNIT_EXPECT_MEMEQ_MSG(test, out, out2, CURVE25519_KEY_SIZE,
 				       "in=%*phN", CURVE25519_KEY_SIZE, in);
 	}
 }
 
+static void benchmark_curve25519(struct kunit *test)
+{
+	const u8 *private = curve25519_test_vectors[0].private;
+	const u8 *public = curve25519_test_vectors[0].public;
+	u8 out[CURVE25519_KEY_SIZE];
+	const size_t warmup_niter = 5000;
+	const size_t benchmark_niter = 1024;
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
+		   div64_u64((u64)benchmark_niter * 1000000000, t ?: 1));
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

