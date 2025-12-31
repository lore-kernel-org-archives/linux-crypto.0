Received: from bonobo.aspen.relay.mailchannels.net (bonobo.aspen.relay.mailchannels.net [23.83.221.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BA52AE99;
	Wed, 31 Dec 2025 09:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.221.22
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767174070; cv=pass; b=CDBDdIcSKM2AJ0u/XWz5vIgkQyoN++JwXC6ESGpgrypr6kFwtXzosxTNdZodzT3qMtRKk9SpxfVjloZF2QSX2uBWebTf1Z5SCB0NWGUJBuKYOV7adaPh6RRvIubZ27Ge6i2+W99wpNp6ldTBJb6tdjJTDcrBM/afX5mfoLjY4WQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767174070; c=relaxed/simple;
	bh=KSaUIgL77CYjxLfEWsrB5KlYUd87jiUBImscuVSEPbo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=r5uaied3Cgx/TCxsHH7CL0YQsSCTnMofchOLf6kmWT6ji4Z+eqtHe5fqfIIIcc2rKMkSsSuRowISbP04QpkFsHn8tlfa7tn0E90oT+hDH/Fw8k3FAGNCnmwGpGhkOCMMzfxmZitvhYCa8Jl8fuiBtPu/dqxm2lyLDPb3T7cnau0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id; spf=pass smtp.mailfrom=kriptograf.id; dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b=IEsKqqSh; arc=pass smtp.client-ip=23.83.221.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b="IEsKqqSh"
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 918A61614FD;
	Wed, 31 Dec 2025 09:25:18 +0000 (UTC)
Received: from vittoria.id.domainesia.com (100-107-79-208.trex-nlb.outbound.svc.cluster.local [100.107.79.208])
	(Authenticated sender: nlkw2k8yjw)
	by relay.mailchannels.net (Postfix) with ESMTPA id EFEDE16210C;
	Wed, 31 Dec 2025 09:25:15 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1767173118;
	b=nVCff0sWOYdkYXTt3Av/kyB1tXtykMIjIy/nWk/bYRMRCr4ixM8h3pBiyfgIys9+luF+0g
	MO5/GSHvFctq56572rhKx0ArdwzyZzILSLTap6G7fDJp4AI7CXx6MTuH5R2R8uUIaOIdlQ
	pW1Vz0WRPjnpCiOVCWhxi0GbbC07AEZJnxHaFgPoFr5g3j784rg5J+daM6/rvKQmAz9Pbp
	sNl3EvLC1JtrWZD9uoYP/0RgK6CF0hqTKltnJoOjnPzx6QYlObwRCK/fXr6pEZb4hs4w14
	mrxTErktru/hoxEc0v4dUCcRAvOz6Tj8sryiiwFxUmza1tqjb/dcVrEPT+NuLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1767173118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+36DFckqx+G1CdC60LCVJiNVSZDjLP/1mvomvNCogY4=;
	b=Ed6oXuYqhd8OohpV5qsy1jV9v7IMhyJ/2/0wL2FA/+iRRtWFpif3SoWWe7Tz2kEzCtVYVa
	Q7nxcooA3IKnFvVSYurDKLVEWqENh9Ljw062ZpCXJrU54Z628qhGSXAhamBni6xEDFYCVX
	M5IIJCp1zFpNGRefoMtA/k7yp8obJRHU/M3KYiDMWk8p3M8e+3EhO7memJWxp03+v49uEL
	pzpC6S8rmhtdMA8mCc7DaVclmOD8Y3dCooWihQC4COJrBQuqDNaJbf5HdHokY3z02jBbQb
	1xDZiPhqJwJ207dNtMoaQakogc9z9CYgxorpE4tDpnHJt5u0EZpVtttFMLJmjA==
ARC-Authentication-Results: i=1;
	rspamd-69599c6f48-klbvj;
	auth=pass smtp.auth=nlkw2k8yjw smtp.mailfrom=rusydi.makarim@kriptograf.id
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MC-Relay: Junk
X-MailChannels-SenderId: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MailChannels-Auth-Id: nlkw2k8yjw
X-Name-Sponge: 65cc109f2c9052c1_1767173118535_3237255704
X-MC-Loop-Signature: 1767173118535:1524764886
X-MC-Ingress-Time: 1767173118534
Received: from vittoria.id.domainesia.com (vittoria.id.domainesia.com
 [36.50.77.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.107.79.208 (trex/7.1.3);
	Wed, 31 Dec 2025 09:25:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kriptograf.id; s=default; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+36DFckqx+G1CdC60LCVJiNVSZDjLP/1mvomvNCogY4=; b=IEsKqqShODBbdEluX1Uzk8eU0K
	nh+G1I4+Mzqz/8iZQ6Mqqq8ncqVJBjgG2GXZojPdvgPTCNyxWuRYQ/+qH5IQNGMljJRxiddH/3O96
	4QQMYlGSfS7TB5Zj9EZERvsQAI3BH+pLQ70GTNoyG2kpkFuVJVV2oHQcYvAzlXhW6lht4F2caGmiP
	0wxlmRovjwgPb0jfk1JVAEDbC8EYF+sGCx24X63Tz5wjkYQiys+QLevIHfr8OMh4bHZrTTVwATwes
	Sv6//3oMhItNpTiezIpjVHH2hoTaiWY+n8MsNpBM/0kAKkcMeobJHUoDSOYR+wDe7Hb0Abj5OAZYq
	CmCt0n7A==;
Received: from [182.253.89.89] (port=29807 helo=Rusydis-MacBook-Air.local)
	by vittoria.id.domainesia.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99)
	(envelope-from <rusydi.makarim@kriptograf.id>)
	id 1vasSA-0000000B53Y-0HH5;
	Wed, 31 Dec 2025 16:25:12 +0700
From: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Date: Wed, 31 Dec 2025 16:25:35 +0700
Subject: [PATCH v2 1/3] lib/crypto: Add KUnit test vectors for
 Ascon-Hash256
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251231-ascon_hash256-v2-1-ffc88a0bab4d@kriptograf.id>
References: <20251231-ascon_hash256-v2-0-ffc88a0bab4d@kriptograf.id>
In-Reply-To: <20251231-ascon_hash256-v2-0-ffc88a0bab4d@kriptograf.id>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
 "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
X-Mailer: b4 0.14.3
X-AuthUser: rusydi.makarim@kriptograf.id

Add test vectors to test the implementation correctness.
The test vectors are generated using the Python reference
implementation in https://github.com/meichlseder/pyascon.
The messages are generated using the method rand_bytes()
in scripts/crypto/gen-hash-testvecs.py.

Signed-off-by: Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
---
 include/crypto/ascon_hash.h            |  84 ++++++++++++
 lib/crypto/tests/Kconfig               |   9 ++
 lib/crypto/tests/Makefile              |   1 +
 lib/crypto/tests/ascon_hash-testvecs.h | 235 +++++++++++++++++++++++++++++++++
 lib/crypto/tests/ascon_hash_kunit.c    |  33 +++++
 5 files changed, 362 insertions(+)

diff --git a/include/crypto/ascon_hash.h b/include/crypto/ascon_hash.h
new file mode 100644
index 000000000000..a99ea458a9cc
--- /dev/null
+++ b/include/crypto/ascon_hash.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common values for Ascon-Hash family of algorithms as defined in
+ * NIST SP 800-232 https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-232.pdf
+ */
+#ifndef _CRYPTO_ASCON_HASH_H_
+#define _CRYPTO_ASCON_HASH_H_
+
+#include <linux/types.h>
+
+#define ASCON_STATE_SIZE	40
+#define ASCON_STATE_WORDS	5
+
+#define ASCON_HASH256_DIGEST_SIZE	32
+#define ASCON_HASH256_BLOCK_SIZE	8
+#define ASCON_HASH256_RATE		8
+#define ASCON_HASH256_IV		0x0000080100CC0002ULL
+
+
+/*
+ * State for Ascon-p[320] permutation: 5 64-bit words
+ */
+struct ascon_state {
+	union {
+		__le64 words[ASCON_STATE_WORDS];
+		u8 bytes[ASCON_STATE_SIZE];
+		u64 native_words[ASCON_STATE_WORDS];
+	};
+};
+
+/* Internal context */
+struct __ascon_hash_ctx {
+	struct ascon_state state;
+	u8 absorb_offset;
+};
+
+/**
+ * struct ascon_hash256_ctx - Context for Ascon-Hash256
+ * @ctx: private
+ */
+struct ascon_hash256_ctx {
+	struct __ascon_hash_ctx ctx;
+};
+
+
+/**
+ * ascon_hash256_init() - Initialize a context for Ascon-Hash256
+ * @ctx: The context to initialize
+ *
+ * This begins a new Ascon-Hash256 message digest computation.
+ */
+void ascon_hash256_init(struct ascon_hash256_ctx *ctx);
+
+/**
+ * ascon_hash256_update() - Update an Ascon-Hash256 digest context with input data
+ * @ctx: The context to update; must have been initialized
+ * @in: The input data
+ * @in_len: Length of the input data in bytes
+ */
+void ascon_hash256_update(struct ascon_hash256_ctx *ctx, const u8 *in,
+			  size_t in_len);
+
+/**
+ * ascon_hash256_final() - Finish computing an Ascon-Hash256 message digest
+ * @ctx: The context to finalize; must have been initialized
+ * @out: (output) The resulting Ascon-Hash256 message digest, matching the init
+ *       function that was called.
+ */
+void ascon_hash256_final(struct ascon_hash256_ctx *ctx,
+			 u8 out[ASCON_HASH256_DIGEST_SIZE]);
+
+/**
+ * ascon_hash256() - Compute Ascon-Hash256 digest in one shot
+ * @in: The input data to be digested
+ * @in_len: Length of the input data in bytes
+ * @out: The buffer into which the digest will be stored
+ *
+ * Convenience function that computes an Ascon-Hash256 digest. Use this instead of
+ * the incremental API if you are able to provide all the input at once.
+ */
+void ascon_hash256(const u8 *in, size_t in_len,
+		   u8 out[ASCON_HASH256_DIGEST_SIZE]);
+
+#endif
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 61d435c450bb..e9d10c580ffe 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -101,6 +101,15 @@ config CRYPTO_LIB_SHA3_KUNIT_TEST
 	  including SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128 and
 	  SHAKE256.
 
+config CRYPTO_LIB_ASCON_HASH_KUNIT_TEST
+	tristate "KUnit tests for Ascon-Hash" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
+	select CRYPTO_LIB_BENCHMARK_VISIBLE
+	select CRYPTO_LIB_ASCON_HASH
+	help
+	  KUnit tests for the Ascon-Hash256 cryptographic has functions.
+
 config CRYPTO_LIB_BENCHMARK_VISIBLE
 	bool
 
diff --git a/lib/crypto/tests/Makefile b/lib/crypto/tests/Makefile
index 5109a0651925..59c4f4ef5b22 100644
--- a/lib/crypto/tests/Makefile
+++ b/lib/crypto/tests/Makefile
@@ -10,3 +10,4 @@ obj-$(CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST) += sha1_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST) += sha224_kunit.o sha256_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST) += sha384_kunit.o sha512_kunit.o
 obj-$(CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST) += sha3_kunit.o
+obj-$(CONFIG_CRYPTO_LIB_ASCON_HASH_KUNIT_TEST) += ascon_hash_kunit.o
diff --git a/lib/crypto/tests/ascon_hash-testvecs.h b/lib/crypto/tests/ascon_hash-testvecs.h
new file mode 100644
index 000000000000..b5c0edcf61e6
--- /dev/null
+++ b/lib/crypto/tests/ascon_hash-testvecs.h
@@ -0,0 +1,235 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * The test vectors are generated using the Python reference implementation
+ * in https://github.com/meichlseder/pyascon/tree/master with messages from
+ * the method rand_bytes() in scripts/crypto/gen-hash-testvecs.py
+ */
+
+static const struct {
+	size_t data_len;
+	u8 digest[ASCON_HASH256_DIGEST_SIZE];
+} hash_testvecs[] = {
+	{
+		.data_len = 0,
+		.digest = {
+			0x0b, 0x3b, 0xe5, 0x85, 0x0f, 0x2f, 0x6b, 0x98,
+			0xca, 0xf2, 0x9f, 0x8f, 0xde, 0xa8, 0x9b, 0x64,
+			0xa1, 0xfa, 0x70, 0xaa, 0x24, 0x9b, 0x8f, 0x83,
+			0x9b, 0xd5, 0x3b, 0xaa, 0x30, 0x4d, 0x92, 0xb2,
+		},
+	},
+	{
+		.data_len = 1,
+		.digest = {
+			0xb9, 0xaa, 0x10, 0x34, 0x7a, 0x2e, 0x62, 0x01,
+			0x01, 0xcf, 0xbd, 0x55, 0x8e, 0x8d, 0x85, 0xda,
+			0x97, 0xe8, 0xd0, 0x5c, 0xbf, 0xf3, 0x19, 0xf7,
+			0x54, 0xcd, 0x32, 0xc0, 0xd0, 0x06, 0x72, 0x62,
+		},
+	},
+	{
+		.data_len = 2,
+		.digest = {
+			0xd9, 0x6b, 0x24, 0xe8, 0x0e, 0xaf, 0xd7, 0x43,
+			0x02, 0x76, 0x7e, 0xc3, 0x66, 0xfa, 0x15, 0x69,
+			0xe8, 0x86, 0x3b, 0xcd, 0x3b, 0xa4, 0xda, 0x77,
+			0xf5, 0xc0, 0x9d, 0x01, 0x8e, 0x9c, 0xae, 0xcd,
+		},
+	},
+	{
+		.data_len = 3,
+		.digest = {
+			0xaa, 0x09, 0xac, 0xf6, 0x0f, 0xa1, 0x54, 0xee,
+			0x5c, 0xe6, 0xf9, 0x44, 0xa8, 0x9f, 0xdb, 0x35,
+			0x68, 0x3b, 0x85, 0x15, 0x2f, 0x54, 0x51, 0x7d,
+			0x05, 0x1e, 0xff, 0x4c, 0x23, 0xa3, 0x46, 0x59,
+		},
+	},
+	{
+		.data_len = 16,
+		.digest = {
+			0xba, 0xc9, 0x62, 0x49, 0xba, 0x78, 0x92, 0x5f,
+			0xa8, 0xa9, 0xd3, 0x47, 0x60, 0x09, 0x1e, 0xdb,
+			0x23, 0x38, 0x2f, 0x43, 0x6a, 0x0f, 0x2f, 0xc8,
+			0x33, 0x9c, 0xdb, 0x9e, 0x38, 0x8f, 0xb0, 0x8a
+		},
+	},
+	{
+		.data_len = 32,
+		.digest = {
+			0x57, 0x6c, 0x66, 0xd5, 0xac, 0x36, 0xd2, 0xda,
+			0x14, 0x4f, 0x6e, 0x84, 0xab, 0xc9, 0xd5, 0x9e,
+			0xe4, 0xb2, 0x22, 0x4a, 0x8c, 0x3c, 0xf2, 0xf3,
+			0x2d, 0xbc, 0x6c, 0x96, 0xa0, 0xd4, 0xaf, 0xd3
+		},
+	},
+	{
+		.data_len = 48,
+		.digest = {
+			0x7e, 0x2e, 0xa5, 0x76, 0x69, 0xc9, 0xf1, 0x49,
+			0xb3, 0x89, 0x53, 0xca, 0x8f, 0x27, 0x6b, 0x89,
+			0xdc, 0x92, 0x5b, 0x48, 0x90, 0x8f, 0x19, 0x7c,
+			0xf2, 0x29, 0xa9, 0xde, 0x59, 0x9e, 0x81, 0x27
+		},
+	},
+	{
+		.data_len = 49,
+		.digest = {
+			0xb5, 0x75, 0xe9, 0xd8, 0x67, 0x75, 0xe2, 0x29,
+			0x3b, 0xff, 0x82, 0x14, 0x06, 0xcf, 0x00, 0x4a,
+			0xb2, 0x53, 0x01, 0x6e, 0x03, 0x86, 0xa6, 0x69,
+			0xe3, 0x64, 0x97, 0x56, 0x25, 0x5b, 0xec, 0x4e
+		},
+	},
+	{
+		.data_len = 63,
+		.digest = {
+			0xb3, 0x37, 0xbf, 0xff, 0xf8, 0x0b, 0x2b, 0xd7,
+			0x81, 0x4c, 0xce, 0x9f, 0x4b, 0xa9, 0x71, 0x3c,
+			0x93, 0x75, 0x04, 0x2d, 0x21, 0x66, 0x10, 0x58,
+			0x38, 0x4e, 0xf5, 0xd7, 0xeb, 0xb4, 0xae, 0x62
+		},
+	},
+	{
+		.data_len = 64,
+		.digest = {
+			0x57, 0xfc, 0x23, 0x3d, 0xf3, 0x48, 0xcc, 0xd2,
+			0x41, 0x39, 0xd8, 0x1c, 0x05, 0x5b, 0xa4, 0x63,
+			0x51, 0x0a, 0x77, 0x8e, 0xb5, 0x11, 0x17, 0xd6,
+			0xeb, 0x54, 0x15, 0xae, 0xb8, 0x2d, 0xd3, 0x5f
+		},
+	},
+	{
+		.data_len = 65,
+		.digest = {
+			0xae, 0x4c, 0xaa, 0x95, 0x86, 0x9c, 0xf2, 0x79,
+			0x57, 0x9a, 0xc9, 0x62, 0x8e, 0x60, 0xc4, 0xc8,
+			0x09, 0x3c, 0xc3, 0xbb, 0xdf, 0x35, 0x96, 0x51,
+			0x5d, 0x80, 0x9a, 0x00, 0x6a, 0xfb, 0xb6, 0xa2
+		},
+	},
+	{
+		.data_len = 127,
+		.digest = {
+			0x31, 0x4f, 0xfc, 0x1f, 0xb9, 0xc7, 0x30, 0x36,
+			0xc5, 0x5c, 0x1d, 0x85, 0x50, 0x4d, 0x96, 0x57,
+			0xeb, 0x75, 0xa4, 0xe0, 0x64, 0x89, 0x84, 0xa5,
+			0x34, 0x34, 0x6d, 0x0e, 0xbb, 0x74, 0x3a, 0x48
+		},
+	},
+	{
+		.data_len = 128,
+		.digest = {
+			0x2d, 0x39, 0xbb, 0x6d, 0xef, 0x31, 0x8f, 0x5a,
+			0xec, 0x5a, 0xf5, 0x86, 0xee, 0xec, 0x26, 0x1a,
+			0xc8, 0x38, 0x40, 0xdd, 0xf0, 0xa6, 0xf0, 0x5f,
+			0xf8, 0x92, 0x14, 0x23, 0x40, 0x48, 0x1b, 0x18
+		},
+	},
+	{
+		.data_len = 129,
+		.digest = {
+			0x97, 0xfc, 0xe5, 0xca, 0xa3, 0x62, 0xae, 0xa1,
+			0x3e, 0x62, 0xd6, 0x46, 0x55, 0x50, 0x26, 0xa7,
+			0x33, 0x36, 0x87, 0x68, 0xbc, 0x26, 0x70, 0x05,
+			0x49, 0x83, 0x9c, 0x68, 0x24, 0x1c, 0x3c, 0x44
+		},
+	},
+	{
+		.data_len = 256,
+		.digest = {
+			0x7d, 0x0c, 0x6d, 0xfb, 0x6b, 0x19, 0xc1, 0xe1,
+			0xa3, 0xd4, 0x2a, 0xae, 0x5a, 0xad, 0xaa, 0xc5,
+			0xeb, 0xa6, 0xb2, 0x72, 0xc5, 0x75, 0x9f, 0x27,
+			0x12, 0xd7, 0x7b, 0xb3, 0xc5, 0xb7, 0x2a, 0xe3
+		},
+	},
+	{
+		.data_len = 511,
+		.digest = {
+			0x32, 0x12, 0xb7, 0x28, 0xc2, 0xbc, 0xe7, 0x38,
+			0x8d, 0x0e, 0x52, 0x34, 0x1a, 0xbc, 0xb0, 0xde,
+			0x45, 0x2b, 0x08, 0x41, 0x23, 0xcf, 0x32, 0x7f,
+			0xd5, 0xa7, 0x2f, 0x99, 0xc6, 0xf6, 0x54, 0x33
+		},
+	},
+	{
+		.data_len = 513,
+		.digest = {
+			0x6b, 0x15, 0x49, 0x95, 0x0d, 0xfc, 0x26, 0x1d,
+			0xc5, 0x01, 0x55, 0x5e, 0x0c, 0x7c, 0x80, 0x57,
+			0xbe, 0xce, 0x04, 0x8e, 0x8e, 0x2e, 0x8a, 0xe8,
+			0xeb, 0x2e, 0x89, 0x4b, 0x6c, 0xea, 0x78, 0x71
+		},
+	},
+	{
+		.data_len = 1000,
+		.digest = {
+			0x13, 0x16, 0x77, 0xd5, 0x37, 0x7a, 0x8a, 0x02,
+			0x68, 0xd9, 0xd5, 0x51, 0xf4, 0x08, 0x7c, 0xe0,
+			0xad, 0xa1, 0x61, 0x17, 0x15, 0x57, 0xd8, 0xb6,
+			0x55, 0xee, 0xbb, 0x96, 0xcd, 0xdd, 0xd2, 0x0d
+		},
+	},
+	{
+		.data_len = 3333,
+		.digest = {
+			0x28, 0x15, 0xde, 0x05, 0x06, 0x68, 0xbc, 0xfe,
+			0xb1, 0x07, 0x72, 0x26, 0xa2, 0x31, 0x8f, 0xe0,
+			0xe9, 0x1a, 0x36, 0x00, 0x51, 0xd8, 0x85, 0xc9,
+			0xb9, 0x67, 0x55, 0x93, 0xe3, 0x02, 0x02, 0x5c
+		},
+	},
+	{
+		.data_len = 4096,
+		.digest = {
+			0x9b, 0x12, 0x0c, 0x12, 0xca, 0x22, 0x84, 0xd3,
+			0xc1, 0x5b, 0x0f, 0x2d, 0xee, 0x58, 0xc4, 0x67,
+			0x03, 0xf7, 0x6c, 0x28, 0xfa, 0xd1, 0x5d, 0x85,
+			0xd9, 0x4b, 0x4f, 0xb2, 0x8c, 0x36, 0x35, 0x53
+		},
+	},
+	{
+		.data_len = 4128,
+		.digest = {
+			0xe4, 0x4d, 0x10, 0xb1, 0x02, 0x62, 0x86, 0xca,
+			0x65, 0x0b, 0xcd, 0xe3, 0x62, 0x96, 0x67, 0xfc,
+			0x59, 0x12, 0x1d, 0x44, 0xed, 0x7b, 0xfb, 0x87,
+			0x82, 0xca, 0xdb, 0xcb, 0xe1, 0x93, 0xaa, 0xa6
+		},
+	},
+	{
+		.data_len = 4160,
+		.digest = {
+			0xe3, 0x03, 0x5e, 0x95, 0x5d, 0xf0, 0x6b, 0xe2,
+			0x30, 0x01, 0x56, 0xf2, 0x6b, 0x18, 0x15, 0xf4,
+			0xa0, 0x42, 0x33, 0xc4, 0x0b, 0xb9, 0xc2, 0xad,
+			0x98, 0xe7, 0x53, 0x2c, 0x8e, 0x8a, 0x1c, 0x02
+		},
+	},
+	{
+		.data_len = 4224,
+		.digest = {
+			0x22, 0x2b, 0x62, 0x2c, 0x21, 0x61, 0xd1, 0x23,
+			0x92, 0x9c, 0x8d, 0x07, 0x48, 0x4a, 0x25, 0x16,
+			0x34, 0x6f, 0x74, 0x3f, 0xbe, 0xf4, 0x7c, 0x1b,
+			0xea, 0xb9, 0x2a, 0x36, 0xc7, 0x3c, 0x1a, 0x32
+		},
+	},
+	{
+		.data_len = 16384,
+		.digest = {
+			0xe9, 0xe2, 0x04, 0xa1, 0x93, 0x8a, 0x7d, 0x6b,
+			0x18, 0x64, 0x38, 0xc5, 0x88, 0x41, 0x98, 0x68,
+			0xaf, 0xc3, 0xbb, 0xa5, 0x5f, 0x92, 0x12, 0xcb,
+			0x0e, 0x31, 0xdf, 0xe9, 0xc1, 0xfb, 0x5a, 0x23
+		},
+	},
+};
+
+static const u8 hash_testvec_consolidated[ASCON_HASH256_DIGEST_SIZE] = {
+	0x48, 0xae, 0x81, 0x92, 0x91, 0xc4, 0x32, 0xba,
+	0xe4, 0x96, 0x5d, 0xb7, 0xf1, 0xb6, 0xad, 0x10,
+	0xae, 0x09, 0x4a, 0x0b, 0xe1, 0xa7, 0x59, 0xa4,
+	0xfd, 0xcb, 0x47, 0x28, 0xfc, 0x0a, 0x34, 0x26,
+};
diff --git a/lib/crypto/tests/ascon_hash_kunit.c b/lib/crypto/tests/ascon_hash_kunit.c
new file mode 100644
index 000000000000..2ca15dbab2cb
--- /dev/null
+++ b/lib/crypto/tests/ascon_hash_kunit.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2025 Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
+ */
+
+#include <crypto/ascon_hash.h>
+#include "ascon_hash-testvecs.h"
+
+#define HASH		ascon_hash256
+#define HASH_CTX	ascon_hash256_ctx
+#define HASH_SIZE	ASCON_HASH256_DIGEST_SIZE
+#define HASH_INIT	ascon_hash256_init
+#define HASH_UPDATE	ascon_hash256_update
+#define HASH_FINAL	ascon_hash256_final
+
+#include "hash-test-template.h"
+
+static struct kunit_case hash_test_cases[] = {
+	HASH_KUNIT_CASES,
+	KUNIT_CASE(benchmark_hash),
+	{},
+};
+
+static struct kunit_suite hash_test_suite = {
+	.name = "ascon_hash256",
+	.test_cases = hash_test_cases,
+	.suite_init = hash_suite_init,
+	.suite_exit = hash_suite_exit,
+};
+kunit_test_suite(hash_test_suite);
+
+MODULE_DESCRIPTION("KUnit tests and benchmark for Ascon-Hash256");
+MODULE_LICENSE("GPL");

-- 
2.52.0

