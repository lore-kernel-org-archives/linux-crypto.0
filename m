Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D80369217;
	Fri,  6 Mar 2026 03:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772768296; cv=none; b=HO+jEiax9+pDqvwY5ejj7ishdEVimK2jpDZJ6o5ztflb+MqTy+lfeEWB98rBXky4ehoJ4Gkjii8h5LWTm/6iLosP6sZSXzLR72ZlT9IscmDy+iERPKnrZ29xQ5J9Lhpa3JukbIxZD3k5ZANb1AJr41KRudIsQMPAz8WGwZ/oyBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772768296; c=relaxed/simple;
	bh=agnbrV4bRkUCMC0bqRHHY8STp+AM8bV+FkZeMZ8KuYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1VYn8qhnnp0nMBm7c9rGpVZDsRIA+mLI2ROe00tQcNBNjsQVm37pKiH8SQlFhgPlQ044AFSNaj4JTpohM54qQg9VSCE04wKcZeKLLrIih6h8FRg+KHYH5GKijhUJ4jd1d369g7jj5gR3VE27I+eWNYEbI1G9JuL1RmsVqM8sDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5LMPYRz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5LMPYRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7819C19423;
	Fri,  6 Mar 2026 03:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772768295;
	bh=agnbrV4bRkUCMC0bqRHHY8STp+AM8bV+FkZeMZ8KuYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5LMPYRzibSOT4oXX4rXkEw6vtgQJCETn9WARaQANTBV/+n+8LiOlWYrGOoApsUl5
	 Qt8nzpu1tbMZdsIb2yM9AQYROBftskWlG6W6g6kebJLe3kkre6vzLSmUwPstbjs/bS
	 UfoQ500YHGH2V8T/iPtWtaUVCJe7eBfFrQ1R++TO/YRQ8bNTjCPdLKx3t6gBLkjE23
	 TdSFhgNtgJksIMqjMWeoj5eenx0ZEMO7OD6wKe/YkRPjk7Ug5b4m/D/EMcAAHLFeHe
	 KWQqMRwWT1SYoLzKq3CJu9Hzd0cDyxo1TtFWEp+1oG0ohJOcnZOOI3Tg1ysQWCFOmA
	 WHWnFqB/6Mchw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	kunit-dev@googlegroups.com,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] lib/crc: tests: Make crc_kunit test only the enabled CRC variants
Date: Thu,  5 Mar 2026 19:35:55 -0800
Message-ID: <20260306033557.250499-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260306033557.250499-1-ebiggers@kernel.org>
References: <20260306033557.250499-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like commit 4478e8eeb871 ("lib/crypto: tests: Depend on library options
rather than selecting them") did with the crypto library tests, make
crc_kunit depend on the code it tests rather than selecting it.  This
follows the standard convention for KUnit and fixes an issue where
enabling KUNIT_ALL_TESTS enabled non-test code.

crc_kunit does differ from the crypto library tests in that it
consolidates the tests for multiple CRC variants, with 5 kconfig
options, into one KUnit suite.  Since depending on *all* of these
kconfig options would greatly restrict the ability to enable crc_kunit,
instead just depend on *any* of these options.  Update crc_kunit
accordingly to test only the reachable code.

Alternatively we could split crc_kunit into 5 test suites.  But keeping
it as one is simpler for now.

Fixes: e47d9b1a76ed ("lib/crc_kunit.c: add KUnit test suite for CRC library functions")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crc/Kconfig           |  7 +------
 lib/crc/tests/crc_kunit.c | 28 ++++++++++++++++++++++------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
index 70e7a6016de3..9ddfd1a29757 100644
--- a/lib/crc/Kconfig
+++ b/lib/crc/Kconfig
@@ -97,17 +97,12 @@ config CRC_OPTIMIZATIONS
 	  Keep this enabled unless you're really trying to minimize the size of
 	  the kernel.
 
 config CRC_KUNIT_TEST
 	tristate "KUnit tests for CRC functions" if !KUNIT_ALL_TESTS
-	depends on KUNIT
+	depends on KUNIT && (CRC7 || CRC16 || CRC_T10DIF || CRC32 || CRC64)
 	default KUNIT_ALL_TESTS
-	select CRC7
-	select CRC16
-	select CRC_T10DIF
-	select CRC32
-	select CRC64
 	help
 	  Unit tests for the CRC library functions.
 
 	  This is intended to help people writing architecture-specific
 	  optimized versions.  If unsure, say N.
diff --git a/lib/crc/tests/crc_kunit.c b/lib/crc/tests/crc_kunit.c
index 9a450e25ac81..9428cd913625 100644
--- a/lib/crc/tests/crc_kunit.c
+++ b/lib/crc/tests/crc_kunit.c
@@ -266,12 +266,11 @@ crc_benchmark(struct kunit *test,
 		kunit_info(test, "len=%zu: %llu MB/s\n",
 			   len, div64_u64((u64)len * num_iters * 1000, t));
 	}
 }
 
-/* crc7_be */
-
+#if IS_REACHABLE(CONFIG_CRC7)
 static u64 crc7_be_wrapper(u64 crc, const u8 *p, size_t len)
 {
 	/*
 	 * crc7_be() left-aligns the 7-bit CRC in a u8, whereas the test wants a
 	 * right-aligned CRC (in a u64).  Convert between the conventions.
@@ -292,13 +291,13 @@ static void crc7_be_test(struct kunit *test)
 
 static void crc7_be_benchmark(struct kunit *test)
 {
 	crc_benchmark(test, crc7_be_wrapper);
 }
+#endif /* CONFIG_CRC7 */
 
-/* crc16 */
-
+#if IS_REACHABLE(CONFIG_CRC16)
 static u64 crc16_wrapper(u64 crc, const u8 *p, size_t len)
 {
 	return crc16(crc, p, len);
 }
 
@@ -316,13 +315,13 @@ static void crc16_test(struct kunit *test)
 
 static void crc16_benchmark(struct kunit *test)
 {
 	crc_benchmark(test, crc16_wrapper);
 }
+#endif /* CONFIG_CRC16 */
 
-/* crc_t10dif */
-
+#if IS_REACHABLE(CONFIG_CRC_T10DIF)
 static u64 crc_t10dif_wrapper(u64 crc, const u8 *p, size_t len)
 {
 	return crc_t10dif_update(crc, p, len);
 }
 
@@ -340,10 +339,13 @@ static void crc_t10dif_test(struct kunit *test)
 
 static void crc_t10dif_benchmark(struct kunit *test)
 {
 	crc_benchmark(test, crc_t10dif_wrapper);
 }
+#endif /* CONFIG_CRC_T10DIF */
+
+#if IS_REACHABLE(CONFIG_CRC32)
 
 /* crc32_le */
 
 static u64 crc32_le_wrapper(u64 crc, const u8 *p, size_t len)
 {
@@ -412,10 +414,13 @@ static void crc32c_test(struct kunit *test)
 
 static void crc32c_benchmark(struct kunit *test)
 {
 	crc_benchmark(test, crc32c_wrapper);
 }
+#endif /* CONFIG_CRC32 */
+
+#if IS_REACHABLE(CONFIG_CRC64)
 
 /* crc64_be */
 
 static u64 crc64_be_wrapper(u64 crc, const u8 *p, size_t len)
 {
@@ -461,28 +466,39 @@ static void crc64_nvme_test(struct kunit *test)
 
 static void crc64_nvme_benchmark(struct kunit *test)
 {
 	crc_benchmark(test, crc64_nvme_wrapper);
 }
+#endif /* CONFIG_CRC64 */
 
 static struct kunit_case crc_test_cases[] = {
+#if IS_REACHABLE(CONFIG_CRC7)
 	KUNIT_CASE(crc7_be_test),
 	KUNIT_CASE(crc7_be_benchmark),
+#endif
+#if IS_REACHABLE(CONFIG_CRC16)
 	KUNIT_CASE(crc16_test),
 	KUNIT_CASE(crc16_benchmark),
+#endif
+#if IS_REACHABLE(CONFIG_CRC_T10DIF)
 	KUNIT_CASE(crc_t10dif_test),
 	KUNIT_CASE(crc_t10dif_benchmark),
+#endif
+#if IS_REACHABLE(CONFIG_CRC32)
 	KUNIT_CASE(crc32_le_test),
 	KUNIT_CASE(crc32_le_benchmark),
 	KUNIT_CASE(crc32_be_test),
 	KUNIT_CASE(crc32_be_benchmark),
 	KUNIT_CASE(crc32c_test),
 	KUNIT_CASE(crc32c_benchmark),
+#endif
+#if IS_REACHABLE(CONFIG_CRC64)
 	KUNIT_CASE(crc64_be_test),
 	KUNIT_CASE(crc64_be_benchmark),
 	KUNIT_CASE(crc64_nvme_test),
 	KUNIT_CASE(crc64_nvme_benchmark),
+#endif
 	{},
 };
 
 static struct kunit_suite crc_test_suite = {
 	.name = "crc",
-- 
2.53.0

