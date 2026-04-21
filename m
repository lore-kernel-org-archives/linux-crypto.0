Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D051386424;
	Tue, 21 Apr 2026 21:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776805594; cv=none; b=Unord7UlzNT+xNizllu+CZHz/DYmvLO9c82Lq+tFCiMBlHnl/XCukw+U60NGDabvLOahZWCQsWAt5TqXPY+pn3mUA/Xuw6Fglw1rVrvBzOC+jZVyvNFoOblBOdM3kUwXOWQGCQ9LOCjbe9Pzxw+lLpZn6f+ruZRr1MtvmXtIoig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776805594; c=relaxed/simple;
	bh=5BYTJ0Zc3OjmC3XMlHWGcpEgAsnrpsICqN6DyFSZFTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqGNZmIVDY915ZZ+lO6u+duxJwcV8IH9KTwW/8pJQt3K4oqJoUMUkdXF+LutXZBOsiY2gCeC7zm5TYDATJBYj5ILaLQRlYoddJ+nA1+kNwRriGrWSlvxeUe2zXG4O30PzNPuhNt6zB1ZbecnRXDwya9fBdRv0rS9MNw2U7Gs3Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLeCNXOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLeCNXOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63BBC2BCB4;
	Tue, 21 Apr 2026 21:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776805594;
	bh=5BYTJ0Zc3OjmC3XMlHWGcpEgAsnrpsICqN6DyFSZFTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLeCNXOL2XRQzw1NGuFvqY5JmCdkK0wZ2WnKB/riST0/pbXvjjz36WrG5O4qbcqO0
	 AboW60Db6aL9u/fsKqKh/cd6YQT5/Y1x/3t8nrQOSOhQsSGXA7SQX7yeP1avzmexxL
	 2Gze68YsEVWEmwNMy6o1uMJEC7e4y/WgD/jixLzj3Pb0x5hoTrn+Dw7uiSiPJn+PL9
	 JGe1sfD5hP3TN/KTpgncm6ajtvaKN21RRgC4sgvCm7LQexm2CsewJhqdVmPdfX1I9U
	 3vf6FC6nwmodQQGhxuRrDOXa2FI4ZXrTNvnF4I0osaf3k3dQqbvAI0mJj3Vy3i1um4
	 37UxJOkX/EY5w==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 1/8] lib/crc: tests: Make crc_kunit test only the enabled CRC variants
Date: Tue, 21 Apr 2026 14:05:47 -0700
Message-ID: <20260421210554.36096-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260421210554.36096-1-ebiggers@kernel.org>
References: <20260421210554.36096-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 85c9f3a2b805eb96d899da7bcc38a16459aa3c16 upstream.

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
Link: https://lore.kernel.org/r/20260306033557.250499-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crc/Kconfig           |  7 +------
 lib/crc/tests/crc_kunit.c | 28 ++++++++++++++++++++++------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
index 70e7a6016de32..9ddfd1a297576 100644
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
index 9a450e25ac811..9428cd9136253 100644
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

