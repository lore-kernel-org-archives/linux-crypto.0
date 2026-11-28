Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795887524;
	b=ZUGdu6o20xGEcWel4wBzyCgted6iNKRW3unwfRq9bbOy0O53Sntt7Fdu3cGq7WajtITu
	 JnRMmfHBuQmbh/0LubeZRTQz8fITfSexMlyzyAfGnrgR7XLPXV6Ry7AXDExmPvDOVelj8
	 vhgnvO45OT4BbaoNfc8x2uGzjY90wj5zH4+3Grpjt1Z0jCewwGJabynyzRFbTNXlZV2NC
	 gC+ECW2SRaDQ5Dg3WMawxWeEbmz6Cme51OGy9tuvrlgUQC7V7dfQ97MBaAppRE80DC+UE
	 XAMj3kW0Sj8UBjKORf3dRwTYHXBMdBkde7cTnWD+1LWWilAEp+D7mlWA1/Hr9sBRfQg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795887524;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Ss3ZCTu7XA1ZhYeb6VBo0mrV1uUxDqZ/FutaykT3aRE=;
	b=zDVrDdKHfyWMJojT0RDixQCqa7mN8cyW+4JV/eIGOYSf9xEQZ5Kg2H23HPCc+TOIPGp0
	 gCOLXY6xBiJJy6Wk+irabDiK1C/cG4iuc8PtBIp0bn2xvK54NLT/he9+M+upcRrE7K1np
	 92l2cgXtk9gy215HQm8DcI2Kmn0bE8Z4LhffDffc6VtREOYzeOjbV6c8GRbgVZwwzVO1o
	 7lTNo191VkEVd/YqoVwCjrJQN7TJx3pZTEXcHJ3Ar9SVUzMb2kT6//Vm3IVdIutuXEbqC
	 m6xNddjRAdabT+AbGrOkRTuoLcbOLAEeRoqElmc1eXpUY4US3N/ZUdd2/EyIk3agawg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HxeDlk4n;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0ED606A321;
	Sat, 28 Nov 2026 17:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HxeDlk4n
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795887523;
	b=lpatwG25OCTGX7n/upbpr7+l/Fi2xR3fC3/3hiPW3IcKoB7iaFntGiLBl9iJ+baLRLOb
	 24Ba6mgQADehcbubtriK7NTA1HUPxDJgwKZpggWetoISDSY+WKB2hqYUkytNNtkhNWDgX
	 52epalF8ndpjRtwvsXiE+EMYk2qKBoZUZyCkE6NtqmY6qExlCXGK6LniR9rDQuHJTkQX2
	 N4gvfpnClzQwNa2I4dnEbu//31RHRDtReBWuWFsPU8HQIwXPc5+JYT1u01nGr4VHv62Fi
	 p1o4WRnGL4u0TTgj0+APCCuMUXH4n0cdO44kXa0yKBpiPplpw97EjAtjOxw9WyLz9OQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795887523;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Ss3ZCTu7XA1ZhYeb6VBo0mrV1uUxDqZ/FutaykT3aRE=;
	b=0uPCyc79NpsvdCWBK+BjYva7ER1T+UQj9srzr1vhzD/lT8pnVikT/6BGjr6UK1JetPR+
	 1MU1jxcuHLzkDuQMKC/r9kLdi0VQpim/AwwcBmdNux+mPcnKj1GIXsWjX5Rl17UEpnPOJ
	 eRNARj43cIhLfHXaS6qVx2YOP28daH+Cq4EAkz0EtRfPSLYxRrP5sC13iBEr8HEE6+E7g
	 biyvZw28EkL613K+4oQoaLNrgjwVMUlTOLAXnl+Ua7rEI8QlTC2zZ76nPgcOEXKlhCp92
	 Cmg7yYyDoFFcjIzYNb0DV4oUV3pojXpE4XhkSj2ls0bjVcspJu2GEt438kQEGKtLPhw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 55F571F00898;
	Sat, 28 Nov 2026 17:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795887523;
	bh=Ss3ZCTu7XA1ZhYeb6VBo0mrV1uUxDqZ/FutaykT3aRE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=HxeDlk4nCXErRkCwqzkR/6Bj0wUzru4USE6xvrNmiIJWsigF93tT+tgIWTKuDdw9e
	 UfZLHbM5C5nba8Bej/Ab61cwAA90jDhzXKlVu0RgskKuDmSfUSuOT6hrCWuijfO7VP
	 2KT1+o1fAAOhSkODJ7csephtXZ3JeZD85eGW/2ghBDe46mmkC1Bs2bTB6aEhovnoUS
	 qgk8iLn8R4IwmUqtSddr4t5dXLY9cx19d0dWGKilHIXyFvc1hokhCUyPAkOn/9B82Q
	 6/fX3oSUZydv1wDQOQFZd4etprwtlISq1Mlxpa0rsLkLoRI1VDkCidWhTE8m21Uu8l
	 WTPNb4VFBytcw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DF0B94E1CC;
	Sat, 28 Nov 2026 17:38:28 +0000 (UTC)
From: Arun Iyengar via B4 Relay <devnull+aiyengar1990.gmail.com@kernel.org>
Date: Sat, 28 Nov 2026 17:38:30 +0000
Subject: [PATCH v2 3/3] crypto: ecc - Add KUnit test for P-521 public key
 generation
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261128-ecc-p521-small-scalars-v2-3-0648f492bca4@gmail.com>
References: <20261128-ecc-p521-small-scalars-v2-0-0648f492bca4@gmail.com>
In-Reply-To: <20261128-ecc-p521-small-scalars-v2-0-0648f492bca4@gmail.com>
To: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@linux.win>, 
 Stefan Berger <stefanb@linux.ibm.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Erwin Pawliczek <pawliczekerwin@gmail.com>, 
 Laveesh Bansal <laveeshb@laveeshbansal.com>, 
 Arun Iyengar <aiyengar1990@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795887508; l=5021;
 i=aiyengar1990@gmail.com; s=20261110; h=from:subject:message-id;
 bh=9RQyvQkr/A2WLGr5xZoUEE44IbUDVhuj+Vnj7i9lKK0=;
 b=OfKJSsgXE0SDU/iPWggNaFSXdPSAnJhYBOMfEqEncW3eg9oLg9HqRQc/gvo4KHDxiyKYcdfm9
 +PE3+HEuM/1CkmDNTTb14VC43pKTRyOSb272FFafyWmmGuB+tvgonu4
X-Developer-Key: i=aiyengar1990@gmail.com; a=ed25519;
 pk=zXpRgUTrhaFe6jLyPqbBy3ccfkj04w0g2690Wv3mg+0=
X-Endpoint-Received: by B4 Relay for aiyengar1990@gmail.com/20261110 with
 auth_id=1480
X-Original-From: Arun Iyengar <aiyengar1990@gmail.com>
Reply-To: aiyengar1990@gmail.com
Content-Transfer-Encoding: 7bit

From: Arun Iyengar <aiyengar1990@gmail.com>

Nothing tests ecc_make_pub_key() on P-521. Add a KUnit test that
compares the public keys for k = 2, 2^259 and n - 3 with known values.
It fails without the previous two patches.

Suggested-by: Laveesh Bansal <laveeshb@laveeshbansal.com>
Signed-off-by: Arun Iyengar <aiyengar1990@gmail.com>
---
 crypto/Kconfig    | 11 +++++++
 crypto/Makefile   |  1 +
 crypto/ecc_test.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 6682ac091b38..a4c8632ef4f4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -296,6 +296,17 @@ config CRYPTO_DH_RFC7919_GROUPS
 config CRYPTO_ECC
 	tristate
 
+config CRYPTO_ECC_KUNIT_TEST
+	tristate "KUnit tests for ECC public key generation" if !KUNIT_ALL_TESTS
+	depends on KUNIT && CRYPTO_ECC
+	default KUNIT_ALL_TESTS
+	help
+	  Enable KUnit tests for ecc_make_pub_key().  The tests generate
+	  NIST P-521 public keys for small, mid-sized and large private
+	  keys and compare them with known values.
+
+	  If unsure, say N.
+
 config CRYPTO_ECDH
 	tristate "ECDH (Elliptic Curve Diffie-Hellman)"
 	select CRYPTO_ECC
diff --git a/crypto/Makefile b/crypto/Makefile
index 42a4a0d5a466..32a3d3e7fd8e 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -167,6 +167,7 @@ obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
 obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
 obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_ECC) += ecc.o
+obj-$(CONFIG_CRYPTO_ECC_KUNIT_TEST) += ecc_test.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
 
 # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124949
diff --git a/crypto/ecc_test.c b/crypto/ecc_test.c
new file mode 100644
index 000000000000..cf6522b7eea4
--- /dev/null
+++ b/crypto/ecc_test.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * KUnit tests for ecc_make_pub_key() on NIST P-521.
+ *
+ * The expected points were computed with a Python reference and checked
+ * against OpenSSL.
+ */
+#include <kunit/test.h>
+#include <linux/module.h>
+#include <crypto/ecdh.h>
+#include <crypto/internal/ecc.h>
+
+#define P521_DIGITS	ECC_CURVE_NIST_P521_DIGITS
+
+struct ecc_p521_vec {
+	const char *desc;
+	u64 k[P521_DIGITS];
+	u64 x[P521_DIGITS];
+	u64 y[P521_DIGITS];
+};
+
+static const struct ecc_p521_vec ecc_p521_vecs[] = {
+	{
+		.desc = "k = 2",
+		.k = { 2 },
+		.x = { 0xf43e3933ba6d783dull, 0xcf2fa364d60fd967ull,
+			0xaa104a3a35c5af41ull, 0xb3b204da6ef55507ull,
+			0x2c6e5505d769be97ull, 0x7403279b1ccc0635ull,
+			0x2fcb288148c28274ull, 0x3c219024277e7e68ull, 0x43ull },
+		.y = { 0x1be356d661f41b02ull, 0xeafcbe95edc0f4f7ull,
+			0x93937fa99a3248f4ull, 0xb3e377de9f251f6bull,
+			0xab21a29906c42dbbull, 0xc6b5107c4da97740ull,
+			0xa7f3eceeeed3f0b5ull, 0xbb8cc7f86db26700ull, 0xf4ull },
+	},
+	{
+		.desc = "k = 2^259",
+		.k = { [4] = 0x8ull },
+		.x = { 0xdfbfa8c0b9f59031ull, 0x683df70ba5e17023ull,
+			0x07958fdc42ce28b7ull, 0xb8965b5bc6d4dc78ull,
+			0x78441b9a6e4b4290ull, 0x3909e659ea4b4aa1ull,
+			0x9c8f59c629b6cd62ull, 0xf400a01919a026ccull, 0xcfull },
+		.y = { 0x09844edef77fa34full, 0x9da8cdc495b4acfaull,
+			0x5bb762074d52835bull, 0xc39505e29c0584e1ull,
+			0x4c9a0f296c4f318eull, 0xdd1a8f417d87f206ull,
+			0x423805cd95ec312cull, 0x21639f519304343eull, 0x92ull },
+	},
+	{
+		.desc = "k = n - 3",
+		.k = { 0xbb6fb71e91386406ull, 0x3bb5c9b8899c47aeull,
+			0x7fcc0148f709a5d0ull, 0x51868783bf2f966bull,
+			0xfffffffffffffffaull, 0xffffffffffffffffull,
+			0xffffffffffffffffull, 0xffffffffffffffffull,
+			0x1ffull },
+		.x = { 0xa5919d2ede37ad7dull, 0xaeb490862c32ea05ull,
+			0x1da6bd16b59fe21bull, 0xad3f164a3a483205ull,
+			0xe5ad7a112d7a8dd1ull, 0xb52a6e5b123d9ab9ull,
+			0xd91d6a64b5959479ull, 0x3d352443de29195dull,
+			0x1a7ull },
+		.y = { 0xa0a7735e11793f1aull, 0x0efa36436c5a6fbdull,
+			0xd2a5312e213c38f3ull, 0xd1d22b30723a8a4full,
+			0x2d0754e05caa3113ull, 0x0eaa8057d562fce8ull,
+			0x686079393547eb0dull, 0x64fc4682059d2226ull, 0xc1ull },
+	},
+};
+
+KUNIT_ARRAY_PARAM_DESC(ecc_p521, ecc_p521_vecs, desc);
+
+static void ecc_p521_make_pub_key(struct kunit *test)
+{
+	const struct ecc_p521_vec *v = test->param_value;
+	u64 pub[2 * P521_DIGITS], x[P521_DIGITS], y[P521_DIGITS];
+
+	KUNIT_ASSERT_EQ(test, ecc_make_pub_key(ECC_CURVE_NIST_P521, P521_DIGITS,
+					       v->k, pub), 0);
+	ecc_swap_digits(pub, x, P521_DIGITS);
+	ecc_swap_digits(&pub[P521_DIGITS], y, P521_DIGITS);
+	KUNIT_EXPECT_MEMEQ(test, x, v->x, sizeof(x));
+	KUNIT_EXPECT_MEMEQ(test, y, v->y, sizeof(y));
+}
+
+static struct kunit_case ecc_test_cases[] = {
+	KUNIT_CASE_PARAM(ecc_p521_make_pub_key, ecc_p521_gen_params),
+	{}
+};
+
+static struct kunit_suite ecc_test_suite = {
+	.name = "ecc",
+	.test_cases = ecc_test_cases,
+};
+
+kunit_test_suite(ecc_test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("KUnit tests for ECC public key generation");

-- 
2.55.0


