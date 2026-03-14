Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706EF330648;
	Sat, 14 Mar 2026 04:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773460853; cv=none; b=fTP4V4aNT+ZmkV8/i3+sSA5Sxd12pgUvoT3ij4v3Mn5TR0ZwV2kY5usAa/J29zWE8UTZytG5PJR9CBpBd+QMvDz1+dqqNSxQNw5qOAQzMgU4zN0MFSRAZpBSsWUmKVY3C5s3KEy/vs4ozJe8189z5P6XbuOlNNDk1ql2EUWXt/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773460853; c=relaxed/simple;
	bh=eJEdHxb7wqpv6OJOeYBu63lyT1vpviJwicSmyCqQBM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdMWSkxzuUwJ5GC/gD44HOm0ErfguWKQgIoqJHrxC6B9g3HrGjpD5v0nzUsvK6KCZOC6/vIzCV3BZPvHapZTz/LJllGeSzXej+wdgAA10OomW5J1FK4d6WRU1xQvybkbZD7M/v1fQlIZcD0rT5VHRMBFX3i7viep0Ox5Y6EIIMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEjyfYsW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEjyfYsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C82AC2BC9E;
	Sat, 14 Mar 2026 04:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773460852;
	bh=eJEdHxb7wqpv6OJOeYBu63lyT1vpviJwicSmyCqQBM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEjyfYsWoDSD8+MphiJPWUzBeJ4ISCkI4Nt5l+gXZj/x480GYHoAjY70KvcY24siG
	 IrUPENFxBmHp4lOJfZlG+x7UpUiylFEy/hXmZ7GE7YDM6ZePdbFgxnLuStCN0f5SSd
	 +oApZykStNh1gnGZ41NgopEmjjX0FZ3o+RMK4TJtc9xR2bbndIqA2RLtgURqMWls7j
	 feqpJctpyh3bTUv0iMe4v1kbe9jl19IiGU4XPsncye79QEqiYtIIHEwMQAMatAKzgk
	 3+SLIEX4kQo0f5xtXPvUBQMlUcXqKO0Tu4P7MuysDQQY7Kpf6MiP+Wt75SaR/7aeRE
	 bdnJUfa/j90DA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Brendan Higgins Brendan Higgins <brendan.higgins@linux.devbrendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>,
	Rae Moar <raemoar63@gmail.comRaeMoarraemoar63@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/2] lib/crypto: tests: Introduce CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
Date: Fri, 13 Mar 2026 20:59:26 -0700
Message-ID: <20260314035927.51351-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260314035927.51351-1-ebiggers@kernel.org>
References: <20260314035927.51351-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For kunit.py to run all the crypto library tests when passed the
--alltests option, tools/testing/kunit/configs/all_tests.config needs to
enable options that satisfy the test dependencies.

This is the same as what lib/crypto/.kunitconfig already does.
However, the strategy that lib/crypto/.kunitconfig currently uses to
select all the hidden library options isn't going to scale up well when
it needs to be repeated in two places.

Instead let's go ahead and introduce an option
CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT that depends on KUNIT and selects all
the crypto library options that have corresponding KUnit tests.

Update lib/crypto/.kunitconfig to use this option.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/.kunitconfig  | 22 +---------------------
 lib/crypto/tests/Kconfig | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+), 21 deletions(-)

diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
index 8cfd213bded9b..63a592731d1dc 100644
--- a/lib/crypto/.kunitconfig
+++ b/lib/crypto/.kunitconfig
@@ -1,28 +1,8 @@
 CONFIG_KUNIT=y
 
-# These kconfig options select all the CONFIG_CRYPTO_LIB_* symbols that have a
-# corresponding KUnit test.  Those symbols cannot be directly enabled here,
-# since they are hidden symbols.
-CONFIG_CRYPTO=y
-CONFIG_CRYPTO_ADIANTUM=y
-CONFIG_CRYPTO_AES=y
-CONFIG_CRYPTO_BLAKE2B=y
-CONFIG_CRYPTO_CHACHA20POLY1305=y
-CONFIG_CRYPTO_CMAC=y
-CONFIG_CRYPTO_HCTR2=y
-CONFIG_CRYPTO_MD5=y
-CONFIG_CRYPTO_MLDSA=y
-CONFIG_CRYPTO_SHA1=y
-CONFIG_CRYPTO_SHA256=y
-CONFIG_CRYPTO_SHA512=y
-CONFIG_CRYPTO_SHA3=y
-CONFIG_INET=y
-CONFIG_IPV6=y
-CONFIG_NET=y
-CONFIG_NETDEVICES=y
-CONFIG_WIREGUARD=y
+CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT=y
 
 CONFIG_CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_CURVE25519_KUNIT_TEST=y
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 0d71de3da15d7..caab7fdbdfdef 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -114,10 +114,34 @@ config CRYPTO_LIB_SHA3_KUNIT_TEST
 	help
 	  KUnit tests for the SHA3 cryptographic hash and XOF functions,
 	  including SHA3-224, SHA3-256, SHA3-384, SHA3-512, SHAKE128 and
 	  SHAKE256.
 
+config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
+	tristate "Enable all crypto library code for KUnit tests"
+	depends on KUNIT
+	select CRYPTO_LIB_AES_CBC_MACS
+	select CRYPTO_LIB_BLAKE2B
+	select CRYPTO_LIB_CURVE25519
+	select CRYPTO_LIB_MD5
+	select CRYPTO_LIB_MLDSA
+	select CRYPTO_LIB_NH
+	select CRYPTO_LIB_POLY1305
+	select CRYPTO_LIB_POLYVAL
+	select CRYPTO_LIB_SHA1
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
+	select CRYPTO_LIB_SHA3
+	help
+	  Enable all the crypto library code that has KUnit tests.
+
+	  Enable this only if you'd like to test all the crypto library code,
+	  even code that wouldn't otherwise need to be built.
+
+	  You'll still need to enable the tests themselves, either individually
+	  or using KUNIT_ALL_TESTS.
+
 config CRYPTO_LIB_BENCHMARK_VISIBLE
 	bool
 
 config CRYPTO_LIB_BENCHMARK
 	bool "Include benchmarks in KUnit tests for cryptographic functions"
-- 
2.53.0

