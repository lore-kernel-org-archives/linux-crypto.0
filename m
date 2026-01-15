Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4159C3BFE3B;
	Thu, 15 Jan 2026 18:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768502323; cv=none; b=bD9RDRhCBP8TMvKMeAQO1sduJ2zyXhM8Jij3S2Vs+zqT9M2Dhb347dj2pOv6WUpALjWxOP/9LDc3VODqF20y7Zz+THcTqoVSMSn411TzYq/0SvM+6rgZJ+fJPw/qL9XfvXTN+RATO0L+qMlMlDD9cf9CGBI8ZjHfUDsEITDQyjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768502323; c=relaxed/simple;
	bh=i11X3lJtpLmbhSpXh+xc5oSA4lz+19V1GZOH0BvqpZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Exe7gQpwxyTq9ZIJ8qUaTDUX0vrAwwWECaM0SS2de/IJEzEJDX+TDNpoHsnWborbkfyFGt0N9gqLp0ytYfmy/JqhFefpC3nWlzM4iPNHN7bcntQegpgYZVRD3/1DtZ18g7cS+HEbbwpVVKuN2cEedyGYS3uANgtqp8Kd892VwM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eqyL3ehE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eqyL3ehE"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60FCVg60026352;
	Thu, 15 Jan 2026 18:38:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZdCGyz2WxNW29ylX5
	R6iwSO9S6vjzaKu1oSh6rnR950=; b=eqyL3ehEDpYzdZNkzF3iLGwkEXmhT9oMM
	o69Zihd+XnMK7mVA7ngkKoqTRgGkrbeXWiVpcgtuHz6b2Vg193nffp6pdeaYu5h2
	SishvPMzBWW6fYbf/WFlaQKIZCVXtf+gsiyrrfyPMWuDBFmqIhSHDheR36OxE1jh
	6xY/FnBwVfPI6ry0d6fzyJJ4U+EqSfMNZScS0qlR6Z0w6lJYiaHrsK3Vy8FbwbS6
	ziLPKJPIPlL4dOtqVT/+f9hoaWscBXN8Bi4WZFjUTAc7KO6WRsHVhuYo1VPTP4mc
	PCoAcU9EIQuU+5Iugz1lqDSJyZMVH/fxsKUABf9COeJd7p8VbGa7A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bpja4ms89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 18:38:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60FGswq5002493;
	Thu, 15 Jan 2026 18:38:36 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bm13t1yab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 18:38:35 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60FIcWIa21365088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:38:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24FEC20040;
	Thu, 15 Jan 2026 18:38:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF0892004B;
	Thu, 15 Jan 2026 18:38:31 +0000 (GMT)
Received: from ibm.com (unknown [9.111.195.181])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Jan 2026 18:38:31 +0000 (GMT)
From: Holger Dengler <dengler@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v1 1/1] lib/crypto: tests: Add KUnit tests for AES
Date: Thu, 15 Jan 2026 19:38:31 +0100
Message-ID: <20260115183831.72010-2-dengler@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260115183831.72010-1-dengler@linux.ibm.com>
References: <20260115183831.72010-1-dengler@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MSBTYWx0ZWRfX+Tb80PvA1vWg
 2Z+EilSzWRJPOw6+q4kcFPAa76II8vM2GyLTtD1xb+d+/TdNl81ZNBE+/WvULofLHBdOUGUuBH5
 skSTKluI3WnuhKS39ca74GtxzzEp6qRJJ0x1p1si5gJNF4BWjGxY8B9BkOG2K5PtsE2gmhzJS/w
 OsHPUegaPHpwtCuNTvB0xXhGk6ONIOUIyyQFY0WcGCD35SffkzQ1XVpmPW37Oq9BXeLlvbnY+1O
 qE+UO8PB5VQjfbOmM5Sm1EAGD8bPzvj3jYFc8wUAsAbbA3Vy2QByXqe6kApW3LXdXldXwcX7++2
 rSaFUrdxy6uGaVjHaJPckg7s34MtYj8JMdb8ol03n6+fKCTP1LzCcZSbx+3YvU3ZGfrSUyJ2xej
 0ZXnhN3yq/SXIwuAzmNcVW+MhK1foRwH7z89gxUnjrth80LlaFX6rTL5x2/OfMgCviNyiLblh3Q
 lAtOQPX77+j5W8hT/6g==
X-Proofpoint-ORIG-GUID: A8kxT9_sFNBmfiv__L_QqYLfJbZUNEp5
X-Proofpoint-GUID: A8kxT9_sFNBmfiv__L_QqYLfJbZUNEp5
X-Authority-Analysis: v=2.4 cv=U4afzOru c=1 sm=1 tr=0 ts=6969342c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=jeVjreTILBP5xtG7Lc8A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601150141

Add a KUnit test suite for AES library functions, including KAT and
benchmarks.

Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
---
 lib/crypto/tests/Kconfig        |  12 +++
 lib/crypto/tests/Makefile       |   1 +
 lib/crypto/tests/aes-testvecs.h |  78 +++++++++++++++++
 lib/crypto/tests/aes_kunit.c    | 149 ++++++++++++++++++++++++++++++++
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
index 000000000000..dfa528db7f02
--- /dev/null
+++ b/lib/crypto/tests/aes-testvecs.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _AES_TESTVECS_H
+#define _AES_TESTVECS_H
+
+#include <crypto/aes.h>
+
+struct buf {
+	size_t blen;
+	u8 b[];
+};
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
index 000000000000..1f4a4f53f553
--- /dev/null
+++ b/lib/crypto/tests/aes_kunit.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <kunit/test.h>
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
+static void benchmark_aes(struct kunit *test, const struct aes_testvector *tv)
+{
+	const size_t num_iters = 10000000;
+	u8 out[AES_BLOCK_SIZE];
+	struct aes_key aes_key;
+	u64 t_enc, t_dec;
+	int rc;
+
+	if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))
+		kunit_skip(test, "not enabled");
+
+	rc = aes_preparekey(&aes_key, tv->key.b, tv->key.len);
+	KUNIT_ASSERT_EQ(test, 0, rc);
+
+	/* warm-up enc */
+	for (size_t i = 0; i < 1000; i++)
+		aes_encrypt(&aes_key, out, tv->plain);
+
+	preempt_disable();
+	t_enc = ktime_get_ns();
+
+	for (size_t i = 0; i < num_iters; i++)
+		aes_encrypt(&aes_key, out, tv->plain);
+
+	t_enc = ktime_get_ns() - t_enc;
+	preempt_enable();
+
+	/* warm-up dec */
+	for (size_t i = 0; i < 1000; i++)
+		aes_decrypt(&aes_key, out, tv->cipher);
+
+	preempt_disable();
+	t_dec = ktime_get_ns();
+
+	for (size_t i = 0; i < num_iters; i++)
+		aes_decrypt(&aes_key, out, tv->cipher);
+
+	t_dec = ktime_get_ns() - t_dec;
+	preempt_enable();
+
+	kunit_info(test, "enc (iter. %zu, duration %lluns)",
+		   num_iters, t_enc);
+	kunit_info(test, "enc (len=%zu): %llu MB/s",
+		   (size_t)AES_BLOCK_SIZE,
+		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NSEC_PER_SEC,
+			     (t_enc ?: 1) * SZ_1M));
+
+	kunit_info(test, "dec (iter. %zu, duration %lluns)",
+		   num_iters, t_dec);
+	kunit_info(test, "dec (len=%zu): %llu MB/s",
+		   (size_t)AES_BLOCK_SIZE,
+		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NSEC_PER_SEC,
+			     (t_dec ?: 1) * SZ_1M));
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
+MODULE_DESCRIPTION("KUnit tests and benchmark aes library");
+MODULE_LICENSE("GPL");
-- 
2.51.0

