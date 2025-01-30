Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BA814900F;
	Thu, 30 Jan 2025 03:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738209294; cv=none; b=LzylPzSXCJQDn07lmSg5MMX8SmD/QtyATZsp6iDC8sin/DbVDKGwt8n+vi424114aFQSYnWJpqTY2Wwc2h6cBvfQAc1ZAoUvrUs3oZ3IyQqojnCuFq9fdykZ1hzfCCCKzzUOvZFDJgNS5vAd3p3azF3CQp7j/HXP1N2rMQA0PH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738209294; c=relaxed/simple;
	bh=ChZeGWewWWuvMusgIkj7sawm5gXtvRFO1sjNHB5gPgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pq6tQsfUaKY3QzPQcOntz8vejLGPSWD1wLkaEs67RyFn6tUaJMWgCRZQiYkEQ2wQVc61pdDEQ7B5RWkR7gwgQOqlgpMVgl5DBsZeiMJ6fa3h68YxlpC6zSTbdwby+f2A3YAgzdDd5qOpsGJo/1mdbSfpE55gJux+hz4CA8Ct8Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LX2GkZAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LX2GkZAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D01C4CEE1;
	Thu, 30 Jan 2025 03:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738209294;
	bh=ChZeGWewWWuvMusgIkj7sawm5gXtvRFO1sjNHB5gPgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LX2GkZAi6qrwFP5DySbxJKlbJwiEt89skwEnghrWWMf6yL4MUtsSPQmk+e5ldbma1
	 3JS1049SOj9BUPt5eszU7nvJHi0ajzBCw8tw/rmy7W2Qsdxp/pebBfjeun8tMlEe8i
	 nhwep5qYNQNAaMMRydBgzARvDlKMFcO31a9fplS1dhht6sM64uDwfWbg9sGjsb1in+
	 xApNTSk7Jk92M6mH1ZpOXItpHfTC67cOch4S1CGYFul4tfK8qOQQiUYRt8FtptY07b
	 P9+U6iEG5yPCzqQAoJiPasglxdm3lZOTfhDKnkYbByKVtPKlq5zpvSIw8h5Cd5Tl3u
	 q1KsVNTwQ62og==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 04/11] lib/crc_kunit.c: add test and benchmark for CRC64-NVME
Date: Wed, 29 Jan 2025 19:51:23 -0800
Message-ID: <20250130035130.180676-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130035130.180676-1-ebiggers@kernel.org>
References: <20250130035130.180676-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Wire up crc64_nvme() to the new CRC unit test and benchmark.

This replaces and improves on the test coverage that was lost by
removing this CRC variant from the crypto API.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/crc_kunit.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/lib/crc_kunit.c b/lib/crc_kunit.c
index 6a61d4b5fd45..1e82fcf9489e 100644
--- a/lib/crc_kunit.c
+++ b/lib/crc_kunit.c
@@ -30,11 +30,12 @@ static size_t test_buflen;
  *	polynomial coefficients in each byte), false if it's a "big endian" CRC
  *	(natural mapping between bits and polynomial coefficients in each byte)
  * @poly: The generator polynomial with the highest-order term omitted.
  *	  Bit-reversed if @le is true.
  * @func: The function to compute a CRC.  The type signature uses u64 so that it
- *	  can fit any CRC up to CRC-64.
+ *	  can fit any CRC up to CRC-64.  The function is expected to *not*
+ *	  invert the CRC at the beginning and end.
  * @combine_func: Optional function to combine two CRCs.
  */
 struct crc_variant {
 	int bits;
 	bool le;
@@ -405,10 +406,35 @@ static void crc64_be_test(struct kunit *test)
 static void crc64_be_benchmark(struct kunit *test)
 {
 	crc_benchmark(test, crc64_be_wrapper);
 }
 
+/* crc64_nvme */
+
+static u64 crc64_nvme_wrapper(u64 crc, const u8 *p, size_t len)
+{
+	/* The inversions that crc64_nvme() does have to be undone here. */
+	return ~crc64_nvme(~crc, p, len);
+}
+
+static const struct crc_variant crc_variant_crc64_nvme = {
+	.bits = 64,
+	.le = true,
+	.poly = 0x9a6c9329ac4bc9b5,
+	.func = crc64_nvme_wrapper,
+};
+
+static void crc64_nvme_test(struct kunit *test)
+{
+	crc_test(test, &crc_variant_crc64_nvme);
+}
+
+static void crc64_nvme_benchmark(struct kunit *test)
+{
+	crc_benchmark(test, crc64_nvme_wrapper);
+}
+
 static struct kunit_case crc_test_cases[] = {
 	KUNIT_CASE(crc16_test),
 	KUNIT_CASE(crc16_benchmark),
 	KUNIT_CASE(crc_t10dif_test),
 	KUNIT_CASE(crc_t10dif_benchmark),
@@ -418,10 +444,12 @@ static struct kunit_case crc_test_cases[] = {
 	KUNIT_CASE(crc32_be_benchmark),
 	KUNIT_CASE(crc32c_test),
 	KUNIT_CASE(crc32c_benchmark),
 	KUNIT_CASE(crc64_be_test),
 	KUNIT_CASE(crc64_be_benchmark),
+	KUNIT_CASE(crc64_nvme_test),
+	KUNIT_CASE(crc64_nvme_benchmark),
 	{},
 };
 
 static struct kunit_suite crc_test_suite = {
 	.name = "crc",
-- 
2.48.1

