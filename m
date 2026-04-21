Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4083DE424;
	Tue, 21 Apr 2026 21:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776805597; cv=none; b=Co3UdtSbckgD+QySA0EGrwugeefKA9+Ur1tZsJHRSZKLMNscr+837hnzpS2sT+n79Yp9tY7pi9SCAkTkKHuumhWuKnsQcv2Stw3MEWg4ioJXFAhPxaYAyWavBUWynVY7uoTBEBVODAR2M1NN4HIqHcawPiUgaqrvXjFdjhnqlrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776805597; c=relaxed/simple;
	bh=90Z8eieK59EzJIvOe2GIfl7kBwBhV74MbZqtv67aE+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bnSQ43JWOIy79fMQneqfqYeDtB+7OfS1Qp5kzWCtVo74Ls/Va7zK92PPRuV6BVOlz+tmVI3ugoSo254cohbUsLjsYOZz+Fj3rXUThn1OfOcux/HAAZAoY0RY7DrlaYNF6AbQQH1v9gwTylL2hDvjyU8FfgiN0FLzKtcgCA+thjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3+uh0tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3+uh0tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9435FC2BCB0;
	Tue, 21 Apr 2026 21:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776805596;
	bh=90Z8eieK59EzJIvOe2GIfl7kBwBhV74MbZqtv67aE+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N3+uh0tul63P9r/YeCCZHFLC2ouDIn7NlzWYAGIDTAxhgb5DmvNkO+mwj14NEs1g8
	 J2KWKczBP08KPqTz4LUm6k4tocBLsIAJlbFFWIxjJBdYETA3z2+SUIL3DGT7e1wNrE
	 L5U1km/sQ9O8wpRXdbvX66TKvb8zYpbTV0oZk8Eds0toXZxjOp0T5xYsCzCc9muAs7
	 Axl4c8gG/IyEg6jn6dfRk1v8GJOnFeKJ4BY9kthi9DEFLCT7M2ZBHk8aTE5ncI92WD
	 v50BqxKseUcJOM06FfW07sckvF+HOEsVPVvmNKpXWdc9NZ+kM3uOYW+ZA5ps1D6N7A
	 6q0ErBtR0kHXw==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 6/8] lib/crypto: tests: Introduce CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
Date: Tue, 21 Apr 2026 14:05:52 -0700
Message-ID: <20260421210554.36096-7-ebiggers@kernel.org>
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

commit ed1767442d919f57aaf83d69c33853da2644d902 upstream.

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

Link: https://lore.kernel.org/r/20260314035927.51351-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/.kunitconfig  | 14 +-------------
 lib/crypto/tests/Kconfig | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
index e38ccb5a4327e..2edc7fc23aab7 100644
--- a/lib/crypto/.kunitconfig
+++ b/lib/crypto/.kunitconfig
@@ -1,20 +1,8 @@
 CONFIG_KUNIT=y
 
-# These kconfig options select all the CONFIG_CRYPTO_LIB_* symbols that have a
-# corresponding KUnit test.  Those symbols cannot be directly enabled here,
-# since they are hidden symbols.
-CONFIG_CRYPTO=y
-CONFIG_CRYPTO_MD5=y
-CONFIG_CRYPTO_SHA1=y
-CONFIG_CRYPTO_SHA256=y
-CONFIG_CRYPTO_SHA512=y
-CONFIG_INET=y
-CONFIG_IPV6=y
-CONFIG_NET=y
-CONFIG_NETDEVICES=y
-CONFIG_WIREGUARD=y
+CONFIG_CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT=y
 
 CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_CURVE25519_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_MD5_KUNIT_TEST=y
 CONFIG_CRYPTO_LIB_POLY1305_KUNIT_TEST=y
diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index 7f033f4c14918..73200134916e8 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -64,10 +64,28 @@ config CRYPTO_LIB_SHA512_KUNIT_TEST
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	help
 	  KUnit tests for the SHA-384 and SHA-512 cryptographic hash functions
 	  and their corresponding HMACs.
 
+config CRYPTO_LIB_ENABLE_ALL_FOR_KUNIT
+	tristate "Enable all crypto library code for KUnit tests"
+	depends on KUNIT
+	select CRYPTO_LIB_CURVE25519
+	select CRYPTO_LIB_MD5
+	select CRYPTO_LIB_POLY1305
+	select CRYPTO_LIB_SHA1
+	select CRYPTO_LIB_SHA256
+	select CRYPTO_LIB_SHA512
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

