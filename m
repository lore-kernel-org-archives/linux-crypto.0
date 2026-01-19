Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6516E359F9F;
	Mon, 19 Jan 2026 12:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768824745; cv=none; b=TmOGQ9hQYM1vzdf65i6GGrTfVggg9L8gQhXaqLCGvRyJ8NACq6vVN9UB0aJ/2+adN5cfwU/1TmhiDQCCZof+ShbaTPXfMBtJByxsDbjRGMOl9kGDb1OSJLzJWUMeyqOhlBOgdChZTUvX7P5MvDkhkYasrwkmMZCtDxN4XPZ72Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768824745; c=relaxed/simple;
	bh=JxdKrqcZwbBmur5VMh1YFvuGxuY9Rnxf/u95XvDmwiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AXvxQQpe5LqR0ogc22DWt3ugktNThoQ+2lW5OJ7X5SYaG9hiOwOGN9wL69cMjoCO5i8TecIcW/SwH77NPkDGut9ig6J7PEaj5vWLaq76iqk1hDIEg4Pu6VQmFzM7/rWy3Uf0sFjnWPDa6LKAjS6O6N9GR4/W1Zrp/RCXzoFSHk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HnypfJ5f; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HnypfJ5f"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60ILFuJl006852;
	Mon, 19 Jan 2026 12:12:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=nABxFGD8fCdzO96PB
	9O0YHG32dHJPMYO73+OyniaqVA=; b=HnypfJ5feKVfhpIlKgD2zZ1dEU/gw/Igm
	sfLJhuU1RB4mip78lCG3cjJvz5kxDTvu5RrXUImoGqIBCnl2R0jNIwJtHLxChZLo
	gZ2wzitWGwiMynJdUGjfqK840dnIacctMReEwUmKXXfT5rPNwoKlHOQlQIFvHfqc
	uevAbOcPeTiLLtZTAh5+fxl1oWBUlP6gUKm140LXSV3tSs5PCU/j8vYTuTyUkQ28
	lWIqxWAFspxaIAb+0CxpCtJFWtO80byLEl5iXC9DxdvOAYqF8ma/WYeMWbcUvRBE
	PVdd5qz0k3+oeGpxhRbHu6Iv+0C3a/J9ZN+TMt2YxB+0K7B+Y1Zyw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4br0uf7jtt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Jan 2026 12:12:16 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60JC8w6D012029;
	Mon, 19 Jan 2026 12:12:15 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4br0uf7jtm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Jan 2026 12:12:15 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60J9qYOe016672;
	Mon, 19 Jan 2026 12:12:14 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4brn4xppr2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Jan 2026 12:12:14 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60JCCAD450856394
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 12:12:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8E67920040;
	Mon, 19 Jan 2026 12:12:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4EC712004B;
	Mon, 19 Jan 2026 12:12:10 +0000 (GMT)
Received: from ibm.com (unknown [9.111.163.233])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 19 Jan 2026 12:12:10 +0000 (GMT)
From: Holger Dengler <dengler@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>,
        David Laight <david.laight.linux@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v2 1/1] lib/crypto: tests: Add KUnit tests for AES
Date: Mon, 19 Jan 2026 13:12:10 +0100
Message-ID: <20260119121210.2662-2-dengler@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260119121210.2662-1-dengler@linux.ibm.com>
References: <20260119121210.2662-1-dengler@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: H-9uR_dk-bAm4rTYuD0gUv1pPWVb9dMq
X-Proofpoint-ORIG-GUID: fh9rn4TOvr7NWiNNQBio2Z1wR5w4gEKi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDA5NyBTYWx0ZWRfXwc3HkdqPMtwY
 cKIhFjcJnZfeVr3YAZghBk/vYMh+SNgl0ntR86j4rZItt1BUT+3bBasIRjY8+uOh+fo3qv2Db9O
 7pM5JlJ7oY6sd9yDkR+zLr4wlfdXUrWyD/DVxjhar5QaTs6vtmxQhuYNzGo+dqO/x19L5geI/sQ
 AZ6rN43b2I34q8IbWdD1Ta6nxMmwcTxd1ORtM6pbgaxS2P942xGveeOCW5JEGJRdIYm8hoJDVUr
 NLySmZFhoFwMFgOuocEirqL9Qd8dFc7PWA0DwskgzXab2OXLJBDjVC8KCVLncnTLniJWRgiV7xX
 z1OckO4fFxDdhwc/ekECkvPPn4DtEpKJH8Yqp2w2Y+exNG8G2IiPrr4flHYTBoYSk+rUvCQSgiv
 zrBo9lwfzc2bWKCViLz8XuOlF9mLXcIfwBGnzQ/Q65UrueRT+jcdr0IQItWGE8t2Yal9PNsvUMn
 qloVY5+NObTiO2fXKQA==
X-Authority-Analysis: v=2.4 cv=bopBxUai c=1 sm=1 tr=0 ts=696e1fa0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=PYnjg3YJAAAA:8 a=VnNF1IyMAAAA:8
 a=Ta3jY6XSS_yevuDS-b0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_02,2026-01-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0 impostorscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601190097

Add a KUnit test suite for AES library functions, including KAT and
benchmarks. The functional tests do a very minimal verification of the
AES operation for each key-size. The benchmarks, which are also part
of the test-suite, can be used to get some rough performance
measurements of the AES operations. The key preparation API
performance is not covered by the benchmarks.

Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
---
 lib/crypto/tests/Kconfig        |  12 +++
 lib/crypto/tests/Makefile       |   1 +
 lib/crypto/tests/aes-testvecs.h |  77 ++++++++++++++++
 lib/crypto/tests/aes_kunit.c    | 150 ++++++++++++++++++++++++++++++++
 4 files changed, 240 insertions(+)
 create mode 100644 lib/crypto/tests/aes-testvecs.h
 create mode 100644 lib/crypto/tests/aes_kunit.c

diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 4970463ea0aa..8ac06b6e2f12 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -1,5 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
+config CRYPTO_LIB_AES_KUNIT_TEST
+	tristate "KUnit tests for AES" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	select CRYPTO_LIB_AES
+	help
+	  KUnit tests for the AES library functions, including known answer
+	  tests and benchmarks for encrypt/decrypt with all key sizes. The
+	  test suite does not contain any key generation test, nor any error
+	  cases.
+
 config CRYPTO_LIB_BLAKE2B_KUNIT_TEST
 	tristate "KUnit tests for BLAKE2b" if !KUNIT_ALL_TESTS
 	depends on KUNIT
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index f4262379f56c..e0a30bdc02ac 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-or-later
 
+obj-$(CONFIG_CRYPTO_LIB_AES_KUNIT_TEST) += aes_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST) += blake2b_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST) += blake2s_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_CURVE25519_KUNIT_TEST) += curve25519_kunit.o
diff --git a/lib/crypto/tests/aes-testvecs.h b/lib/crypto/tests/aes-testvecs.h
new file mode 100644
index 000000000000..fd52d8ad7760
--- /dev/null
+++ b/lib/crypto/tests/aes-testvecs.h
@@ -0,0 +1,77 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _AES_TESTVECS_H
+#define _AES_TESTVECS_H
+
+#include <crypto/aes.h>
+
+struct aes_testvector {
+	u8 plain[AES_BLOCK_SIZE];
+	u8 cipher[AES_BLOCK_SIZE];
+	struct {
+		size_t len;
+		u8 b[32];
+	} key;
+};
+
+/*
+ * KAT test vectors from NIST.
+ * https://csrc.nist.gov/csrc/media/projects/cryptographic-standards-and-guidelines/documents/examples/aes_ecb.pdf
+ */
+static const struct aes_testvector aes128_kat = {
+	.plain = {
+		0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96,
+		0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a,
+	},
+	.cipher = {
+		0x3a, 0xd7, 0x7b, 0xb4, 0x0d, 0x7a, 0x36, 0x60,
+		0xa8, 0x9e, 0xca, 0xf3, 0x24, 0x66, 0xef, 0x97,
+	},
+	.key = {
+		.len = 16,
+		.b = {
+			0x2b, 0x7e, 0x15, 0x16, 0x28, 0xae, 0xd2, 0xa6,
+			0xab, 0xf7, 0x15, 0x88, 0x09, 0xcf, 0x4f, 0x3c,
+		},
+	},
+};
+
+static const struct aes_testvector aes192_kat = {
+	.plain = {
+		0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96,
+		0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a,
+	},
+	.cipher = {
+		0xbd, 0x33, 0x4f, 0x1d, 0x6e, 0x45, 0xf2, 0x5f,
+		0xf7, 0x12, 0xa2, 0x14, 0x57, 0x1f, 0xa5, 0xcc,
+	},
+	.key = {
+		.len = 24,
+		.b = {
+			0x8e, 0x73, 0xb0, 0xf7, 0xda, 0x0e, 0x64, 0x52,
+			0xc8, 0x10, 0xf3, 0x2b, 0x80, 0x90, 0x79, 0xe5,
+			0x62, 0xf8, 0xea, 0xd2, 0x52, 0x2c, 0x6b, 0x7b,
+		},
+	},
+};
+
+static const struct aes_testvector aes256_kat = {
+	.plain = {
+		0x6b, 0xc1, 0xbe, 0xe2, 0x2e, 0x40, 0x9f, 0x96,
+		0xe9, 0x3d, 0x7e, 0x11, 0x73, 0x93, 0x17, 0x2a,
+	},
+	.cipher = {
+		0xf3, 0xee, 0xd1, 0xbd, 0xb5, 0xd2, 0xa0, 0x3c,
+		0x06, 0x4b, 0x5a, 0x7e, 0x3d, 0xb1, 0x81, 0xf8,
+	},
+	.key = {
+		.len = 32,
+		.b = {
+			0x60, 0x3d, 0xeb, 0x10, 0x15, 0xca, 0x71, 0xbe,
+			0x2b, 0x73, 0xae, 0xf0, 0x85, 0x7d, 0x77, 0x81,
+			0x1f, 0x35, 0x2c, 0x07, 0x3b, 0x61, 0x08, 0xd7,
+			0x2d, 0x98, 0x10, 0xa3, 0x09, 0x14, 0xdf, 0xf4,
+		},
+	},
+};
+
+#endif /* _AES_TESTVECS_H */
diff --git a/lib/crypto/tests/aes_kunit.c b/lib/crypto/tests/aes_kunit.c
new file mode 100644
index 000000000000..8110d3718085
--- /dev/null
+++ b/lib/crypto/tests/aes_kunit.c
@@ -0,0 +1,150 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <kunit/test.h>
+#include <linux/preempt.h>
+#include "aes-testvecs.h"
+
+static void test_aes(struct kunit *test, const struct aes_testvector *tv,
+		     bool enc)
+{
+	struct aes_key aes_key;
+	u8 out[AES_BLOCK_SIZE];
+	const u8 *input, *expect;
+	int rc;
+
+	rc = aes_preparekey(&aes_key, tv->key.b, tv->key.len);
+	KUNIT_ASSERT_EQ(test, 0, rc);
+
+	if (enc) {
+		input = tv->plain;
+		expect = tv->cipher;
+		aes_encrypt(&aes_key, out, input);
+	} else {
+		input = tv->cipher;
+		expect = tv->plain;
+		aes_decrypt(&aes_key, out, input);
+	}
+	KUNIT_ASSERT_MEMEQ(test, out, expect, sizeof(out));
+}
+
+static __always_inline u64 time_aes_op(bool encrypt, struct aes_key *aes_key,
+				       u8 *out, const u8 *in)
+{
+	void (*aes_op)(const struct aes_key *key, u8 *out, const u8 *in);
+	u64 t;
+
+	aes_op = encrypt ? &aes_encrypt : &aes_decrypt;
+
+	preempt_disable();
+	t = ktime_get_ns();
+	aes_op(aes_key, out, in);
+	t = ktime_get_ns() - t;
+	preempt_enable();
+
+	return t;
+}
+
+static void benchmark_aes(struct kunit *test, const struct aes_testvector *tv)
+{
+	const size_t num_iters = 100;
+	struct aes_key aes_key;
+	u8 out[AES_BLOCK_SIZE];
+	u64 t, t_enc, t_dec;
+	int rc;
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))
+		kunit_skip(test, "not enabled");
+
+	rc = aes_preparekey(&aes_key, tv->key.b, tv->key.len);
+	KUNIT_ASSERT_EQ(test, 0, rc);
+
+	/* warm-up */
+	for (size_t i = 0; i < num_iters; i++) {
+		aes_encrypt(&aes_key, out, tv->plain);
+		aes_decrypt(&aes_key, out, tv->cipher);
+	}
+
+	t_enc = NSEC_PER_SEC;
+	t_dec = NSEC_PER_SEC;
+	for (size_t i = 0; i < num_iters; i++) {
+		t = time_aes_op(true, &aes_key, out, tv->plain);
+		t_enc = MIN_T(u64, t, t_enc);
+
+		t = time_aes_op(false, &aes_key, out, tv->cipher);
+		t_dec = MIN_T(u64, t, t_dec);
+	}
+
+	kunit_info(test, "enc (len=%zu): %llu MB/s", (size_t)AES_BLOCK_SIZE,
+		   div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
+			     (t_enc ?: 1)));
+	kunit_info(test, "dec (len=%zu): %llu MB/s", (size_t)AES_BLOCK_SIZE,
+		   div64_u64(AES_BLOCK_SIZE * NSEC_PER_SEC / 1000000,
+			     (t_dec ?: 1)));
+}
+
+static void test_aes128_encrypt(struct kunit *test)
+{
+	test_aes(test, &aes128_kat, true);
+}
+
+static void test_aes128_decrypt(struct kunit *test)
+{
+	test_aes(test, &aes128_kat, false);
+}
+
+static void test_aes192_encrypt(struct kunit *test)
+{
+	test_aes(test, &aes192_kat, true);
+}
+
+static void test_aes192_decrypt(struct kunit *test)
+{
+	test_aes(test, &aes192_kat, false);
+}
+
+static void test_aes256_encrypt(struct kunit *test)
+{
+	test_aes(test, &aes256_kat, true);
+}
+
+static void test_aes256_decrypt(struct kunit *test)
+{
+	test_aes(test, &aes256_kat, false);
+}
+
+static void benchmark_aes128(struct kunit *test)
+{
+	benchmark_aes(test, &aes128_kat);
+}
+
+static void benchmark_aes192(struct kunit *test)
+{
+	benchmark_aes(test, &aes192_kat);
+}
+
+static void benchmark_aes256(struct kunit *test)
+{
+	benchmark_aes(test, &aes256_kat);
+}
+
+static struct kunit_case aes_test_cases[] = {
+	KUNIT_CASE(test_aes128_encrypt),
+	KUNIT_CASE(test_aes128_decrypt),
+	KUNIT_CASE(test_aes192_encrypt),
+	KUNIT_CASE(test_aes192_decrypt),
+	KUNIT_CASE(test_aes256_encrypt),
+	KUNIT_CASE(test_aes256_decrypt),
+	KUNIT_CASE(benchmark_aes128),
+	KUNIT_CASE(benchmark_aes192),
+	KUNIT_CASE(benchmark_aes256),
+	{},
+};
+
+static struct kunit_suite aes_test_suite = {
+	.name = "aes",
+	.test_cases = aes_test_cases,
+};
+
+kunit_test_suite(aes_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark AES library");
+MODULE_LICENSE("GPL");
-- 
2.51.0

