Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DBC1F03D7;
	Tue,  4 Mar 2025 22:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741127996; cv=none; b=ms46WLXlTU3Fkv203UyPVHOvS9lIR/Fkw3wA9nQmzH6biwTFLGpiamcex9/MWsMkrVAWqzkfIuaZbqodezLTurLmKRiOIL+V3yhapPI7ueIHGOTDHtx7cfGYwGWKHEmA/HfaSXv/NDXIMBxXqymIICsRNSHJbJqYyuWdvybT4Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741127996; c=relaxed/simple;
	bh=7qAMWlTZSUGYnrpQeXf/tvCWgGc66bLuuMYxvxMpdso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IynP4qqZaqsp7bCxc0eaO7b/FZorKHSJmdbUmQifYAHgDUOzdrqnkKeYlCzLm28kWNImk/GZ78/VI9Ju/BMOaVMPPgAFD4JLYssQHSevW07v3TevltpxpvEBYiHWd7A4xK3RN45qYAQIsdJMT0wAcuT/ug9/WwKxO0a250OyYL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uiXwSLOd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uiXwSLOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38CC6C4CEE5;
	Tue,  4 Mar 2025 22:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741127995;
	bh=7qAMWlTZSUGYnrpQeXf/tvCWgGc66bLuuMYxvxMpdso=;
	h=From:To:Cc:Subject:Date:From;
	b=uiXwSLOdhGJNqn77iq0n8ivd7MYY11voX9LX/rMpq1BbYolGcpUm9nrfHW/5um7f9
	 jvSAEACt2Smonz3sClKE/CVzAGCRippsqZ2cn+uQMfHFb/F1zbMi43xlDsq55irLh8
	 fqfScETwsq+cZvsWwOHVzQgX6JsrsCesGj+ri0s953kaoCKjeKU+SP6X/MK+gOAdRO
	 1ODsOrYh81Q9IzVHqlSuH7GtxKPwj4wrgRl/Dl0kQOhteyFkN24rHU3x2dGCygr0Yw
	 gKWm6ECmO5KVaCrTVSArgEjmMuT14TLFOYF6SygM1D/WpUggcbyKooBqKVTj1ratKA
	 QgwA8Qs/k8RLQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH] lib/crc_kunit.c: add test and benchmark for crc7_be()
Date: Tue,  4 Mar 2025 14:39:43 -0800
Message-ID: <20250304223943.157493-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Wire up crc7_be() to crc_kunit.  Previously it had no test.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/Kconfig.debug |  1 +
 lib/crc_kunit.c   | 35 +++++++++++++++++++++++++++++++++--
 2 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 1af972a92d06f..141855e9d8c43 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2850,10 +2850,11 @@ config HW_BREAKPOINT_KUNIT_TEST
 
 config CRC_KUNIT_TEST
 	tristate "KUnit tests for CRC functions" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
+	select CRC7
 	select CRC16
 	select CRC_T10DIF
 	select CRC32
 	select CRC64
 	help
diff --git a/lib/crc_kunit.c b/lib/crc_kunit.c
index 40b4b41f21847..0e15eb244b20a 100644
--- a/lib/crc_kunit.c
+++ b/lib/crc_kunit.c
@@ -5,10 +5,11 @@
  * Copyright 2024 Google LLC
  *
  * Author: Eric Biggers <ebiggers@google.com>
  */
 #include <kunit/test.h>
+#include <linux/crc7.h>
 #include <linux/crc16.h>
 #include <linux/crc-t10dif.h>
 #include <linux/crc32.h>
 #include <linux/crc32c.h>
 #include <linux/crc64.h>
@@ -30,12 +31,13 @@ static size_t test_buflen;
  *	polynomial coefficients in each byte), false if it's a "big endian" CRC
  *	(natural mapping between bits and polynomial coefficients in each byte)
  * @poly: The generator polynomial with the highest-order term omitted.
  *	  Bit-reversed if @le is true.
  * @func: The function to compute a CRC.  The type signature uses u64 so that it
- *	  can fit any CRC up to CRC-64.  The function is expected to *not*
- *	  invert the CRC at the beginning and end.
+ *	  can fit any CRC up to CRC-64.  The CRC is passed in, and is expected
+ *	  to be returned in, the least significant bits of the u64.  The
+ *	  function is expected to *not* invert the CRC at the beginning and end.
  * @combine_func: Optional function to combine two CRCs.
  */
 struct crc_variant {
 	int bits;
 	bool le;
@@ -250,10 +252,37 @@ crc_benchmark(struct kunit *test,
 		kunit_info(test, "len=%zu: %llu MB/s\n",
 			   len, div64_u64((u64)len * num_iters * 1000, t));
 	}
 }
 
+/* crc7_be */
+
+static u64 crc7_be_wrapper(u64 crc, const u8 *p, size_t len)
+{
+	/*
+	 * crc7_be() left-aligns the 7-bit CRC in a u8, whereas the test wants a
+	 * right-aligned CRC (in a u64).  Convert between the conventions.
+	 */
+	return crc7_be(crc << 1, p, len) >> 1;
+}
+
+static const struct crc_variant crc_variant_crc7_be = {
+	.bits = 7,
+	.poly = 0x9,
+	.func = crc7_be_wrapper,
+};
+
+static void crc7_be_test(struct kunit *test)
+{
+	crc_test(test, &crc_variant_crc7_be);
+}
+
+static void crc7_be_benchmark(struct kunit *test)
+{
+	crc_benchmark(test, crc7_be_wrapper);
+}
+
 /* crc16 */
 
 static u64 crc16_wrapper(u64 crc, const u8 *p, size_t len)
 {
 	return crc16(crc, p, len);
@@ -432,10 +461,12 @@ static void crc64_nvme_benchmark(struct kunit *test)
 {
 	crc_benchmark(test, crc64_nvme_wrapper);
 }
 
 static struct kunit_case crc_test_cases[] = {
+	KUNIT_CASE(crc7_be_test),
+	KUNIT_CASE(crc7_be_benchmark),
 	KUNIT_CASE(crc16_test),
 	KUNIT_CASE(crc16_benchmark),
 	KUNIT_CASE(crc_t10dif_test),
 	KUNIT_CASE(crc_t10dif_benchmark),
 	KUNIT_CASE(crc32_le_test),

base-commit: 13f3d13d88b5dcba104a204fcbee61c75f8407d0
-- 
2.48.1

