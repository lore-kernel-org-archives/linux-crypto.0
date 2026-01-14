Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DDD39C63B;
	Wed, 14 Jan 2026 15:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768404712; cv=none; b=lwrrBctJ56BK/3TaqsYq9XtjAw2XxS/poVqboJU+fr6YiUrZVnpvzo7PzefDXW/Wqy+gpAhnee98MifP7jBTTpgPs6XjIi2f/ElnMCXK2ikumN5jbAG1Jqqs0bewKNeMlueyrUPeN6oUzGRp3BReaxfKvxuZvIL9AgBTPW1+BRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768404712; c=relaxed/simple;
	bh=dGdXpEKLIFgzRYHsZh8zzc0oI/PRowjOI/g5pKc1XjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaqY9Sy68ik+IHjp2o1J25V8AHVAE+WFCzo3YwClBDyxe8A/b+DMbXqZ3Xoh2MJEwjXcW9sRRr+W7rbtH6QN1+gt6LvjGqNTAeVOHf2pzMiq8wAPapJwyybP9TM3WFMUgs/IAEXeZ/1vKTHQOU8YKcQa6bWTi5QNilTPw/xoSVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FSXYpGo4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FSXYpGo4"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60E5MIkx028100;
	Wed, 14 Jan 2026 15:31:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=HOInVU+/uFdwUhpNK
	m/2hNi1ppgGj9Ff+hjqX+RLSuE=; b=FSXYpGo4Ir1fgkd9cTF+qiWFvnO7KcevZ
	KqcNfgPG88uVSl8dhJiui5mMviF4uCyS5YN3yTfRD+ucEquxXdNzLhYtRg9i9rnm
	8DaDcFy5LjL0DglzvEIP/cD2pg94uX4u0leroaPh13ZW1yQyw9lJn3/DtleTUq7r
	Wh5SZ+eFnIJVvoaKx1KHX1mtFoIKmgX1rj2gykbhnNVi2WsNIKxH8W6ZqwHPvW6e
	hLPB2wMG/0c9scBcuS3P0wZwYnoq4B8fJW1A+ZoykQybDWAum1gYapdGbIsh3oHX
	xr0Tm2gmlrPG/inwJKmfuvamy6aMJBmW00mgjA3ZYZBPYzQLfBPLw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bkc6h9vau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 15:31:44 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60EEVVTn025848;
	Wed, 14 Jan 2026 15:31:43 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm2kkjtdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 Jan 2026 15:31:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60EFVdkG51052932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 15:31:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA4DE20040;
	Wed, 14 Jan 2026 15:31:39 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B6682004D;
	Wed, 14 Jan 2026 15:31:39 +0000 (GMT)
Received: from ibm.com (unknown [9.111.193.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 14 Jan 2026 15:31:39 +0000 (GMT)
From: Holger Dengler <dengler@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <freude@linux.ibm.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Holger Dengler <dengler@linux.ibm.com>
Subject: [RFC PATCH 1/1] lib/crypto: tests: Add KUnit tests for AES
Date: Wed, 14 Jan 2026 16:31:38 +0100
Message-ID: <20260114153138.4896-2-dengler@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260114153138.4896-1-dengler@linux.ibm.com>
References: <20260112192035.10427-35-ebiggers@kernel.org>
 <20260114153138.4896-1-dengler@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AK1aCC0y28pKioiLumGefR-EWs4-p0Pe
X-Proofpoint-ORIG-GUID: AK1aCC0y28pKioiLumGefR-EWs4-p0Pe
X-Authority-Analysis: v=2.4 cv=TaibdBQh c=1 sm=1 tr=0 ts=6967b6e0 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=j5hiYDS-JR5WEbQJau0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDEyOCBTYWx0ZWRfX/yAfkZx12cem
 rQ0ISNrqL9qDt1W5wrVESn22w/MpZu4xRmKjsd72WOMIwcLP+uiOtHdprnnxLdBoEhxJZBccPq2
 ncrTbKV93Uh1i5+Oh4fKQMR4IoaKU2qQQdMP6K+hBCpu96i3CTBN2Zt+jsU9Tprf24ySFr8b2H4
 BFRo4T3YeIHIor3CBs/Ltn6lQ+omDRqTqrrrbNTNIJdUvZdW0wHQF77kX+zXPZh1HYo7rAxcjLu
 vr6uo80pZE6E7Q0M9z/5SYjbS5xqxzsc6nznnQ1rFAAi6AmQXNjlpljig95DftBDb1v4pWB2nUi
 M4YKlkGR/ZZVCAeE7+UDZmDQcOq14rM7Hw4geHg3UwN85BG+znRyJ+Yp1ahWRV+jltoJu52psCP
 l4jYASmiNjlgDrHm+hPschbU3bVSI3XDwhMk9WBAEde0pY2uwfNSLZb+epmbJjl7vOqhGjfyjmL
 OhHabzOUH12q6/28jhQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_04,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 impostorscore=0 bulkscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601140128

Add a KUnit test suite for AES library functions, including KAT and
benchmarks.

Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
---
 lib/crypto/tests/Kconfig        |  12 ++++
 lib/crypto/tests/Makefile       |   1 +
 lib/crypto/tests/aes-testvecs.h |  78 ++++++++++++++++++++++
 lib/crypto/tests/aes_kunit.c    | 115 ++++++++++++++++++++++++++++++++
 4 files changed, 206 insertions(+)
 create mode 100644 lib/crypto/tests/aes-testvecs.h
 create mode 100644 lib/crypto/tests/aes_kunit.c

diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 4970463ea0aa..f34e79093275 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -118,6 +118,18 @@ config CRYPTO_LIB_SHA3_KUNIT_TEST
 	  including SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128 and
 	  SHAKE256.
 
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
 config CRYPTO_LIB_BENCHMARK_VISIBLE
 	bool
 
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index f4262379f56c..72234e965cdc 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST) += sha1_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST) += sha224_kunit.o sha256_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST) += sha384_kunit.o sha512_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST) += sha3_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_AES_KUNIT_TEST) += aes_kunit.o
diff --git a/lib/crypto/tests/aes-testvecs.h b/lib/crypto/tests/aes-testvecs.h
new file mode 100644
index 000000000000..2bfa646ff2e5
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
+struct kat {
+	u8 plain[AES_BLOCK_SIZE];
+	u8 cipher[AES_BLOCK_SIZE];
+	struct {
+		size_t len;
+		u8 b[32];
+	} key;
+};
+
+static const struct kat AES128_KAT = {
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
+static const struct kat AES192_KAT = {
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
+static const struct kat AES256_KAT = {
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
index 000000000000..057ddc3a1b1f
--- /dev/null
+++ b/lib/crypto/tests/aes_kunit.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <kunit/test.h>
+
+#include "aes-testvecs.h"
+
+#define AES_KAT(bits, func, from, to)				\
+static void aes##bits##_kat_##func(struct kunit *test)		\
+{								\
+	const u8 *in = AES##bits##_KAT.from;			\
+	u8 out[AES_BLOCK_SIZE];					\
+	struct aes_key aes_key;					\
+								\
+	if (aes_preparekey(&aes_key, AES##bits##_KAT.key.b,	\
+			   AES##bits##_KAT.key.len))		\
+		kunit_skip(test, "no key");			\
+								\
+	aes_##func(&aes_key, out, in);				\
+	KUNIT_ASSERT_MEMEQ(test, out, AES##bits##_KAT.to,	\
+			   sizeof(out));			\
+}
+
+#define KB		(1024)
+#define MB		(KB * KB)
+#define NS_PER_SEC	(1000000000ULL)
+
+#define AES_BENCHMARK(bits)					\
+static void aes##bits##_benchmark(struct kunit *test)		\
+{								\
+	const size_t num_iters = 10000000;			\
+	const u8 *cipher = AES##bits##_KAT.cipher;		\
+	const u8 *plain = AES##bits##_KAT.plain;		\
+	u8 out[AES_BLOCK_SIZE];					\
+	struct aes_key aes_key;					\
+	u64 t_enc, t_dec;					\
+								\
+	if (!IS_ENABLED(CONFIG_CRYPTO_LIB_BENCHMARK))		\
+		kunit_skip(test, "not enabled");		\
+								\
+	if (aes_preparekey(&aes_key, AES##bits##_KAT.key.b,	\
+			   AES##bits##_KAT.key.len))		\
+		kunit_skip(test, "no key");			\
+								\
+	/* warm-up enc */					\
+	for (size_t i = 0; i < 1000; i++)			\
+		aes_encrypt(&aes_key, out, plain);		\
+								\
+	preempt_disable();					\
+	t_enc = ktime_get_ns();					\
+								\
+	for (size_t i = 0; i < num_iters; i++)			\
+		aes_encrypt(&aes_key, out, plain);		\
+								\
+	t_enc = ktime_get_ns() - t_enc;				\
+	preempt_enable();					\
+								\
+	/* warm-up dec */					\
+	for (size_t i = 0; i < 1000; i++)			\
+		aes_decrypt(&aes_key, out, cipher);		\
+								\
+	preempt_disable();					\
+	t_dec = ktime_get_ns();					\
+								\
+	for (size_t i = 0; i < num_iters; i++)			\
+		aes_decrypt(&aes_key, out, cipher);		\
+								\
+	t_dec = ktime_get_ns() - t_dec;				\
+	preempt_enable();					\
+								\
+	kunit_info(test, "enc (iter. %zu, duration %lluns)",	\
+		   num_iters, t_enc);				\
+	kunit_info(test, "enc (len=%zu): %llu MB/s",		\
+		   (size_t)AES_BLOCK_SIZE,			\
+		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NS_PER_SEC, \
+			     (t_enc ?: 1) * MB));		\
+								\
+	kunit_info(test, "dec (iter. %zu, duration %lluns)",	\
+		   num_iters, t_dec);				\
+	kunit_info(test, "dec (len=%zu): %llu MB/s",		\
+		   (size_t)AES_BLOCK_SIZE,			\
+		   div64_u64((u64)AES_BLOCK_SIZE * num_iters * NS_PER_SEC, \
+			     (t_dec ?: 1) * MB));		\
+}
+
+AES_KAT(128, encrypt, plain, cipher);
+AES_KAT(192, encrypt, plain, cipher);
+AES_KAT(256, encrypt, plain, cipher);
+AES_KAT(128, decrypt, cipher, plain);
+AES_KAT(192, decrypt, cipher, plain);
+AES_KAT(256, decrypt, cipher, plain);
+AES_BENCHMARK(128);
+AES_BENCHMARK(192);
+AES_BENCHMARK(256);
+
+static struct kunit_case aes_test_cases[] = {
+	KUNIT_CASE(aes128_kat_encrypt),
+	KUNIT_CASE(aes128_kat_decrypt),
+	KUNIT_CASE(aes192_kat_encrypt),
+	KUNIT_CASE(aes192_kat_decrypt),
+	KUNIT_CASE(aes256_kat_encrypt),
+	KUNIT_CASE(aes256_kat_decrypt),
+	KUNIT_CASE(aes128_benchmark),
+	KUNIT_CASE(aes192_benchmark),
+	KUNIT_CASE(aes256_benchmark),
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

