Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5BDA2D0C7B;
	Sat,  6 Sep 2025 21:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757194627; cv=none; b=lndpKgp3+yN4ve6YSwCsNRP3+6Nc58l927s+jqNV9LPBEx4vJcFDhMHTOalASchtPMLEe8yKprpeld5NSe1gj/EK1KJZVx2DPOEY71lDCV+JUWNCXqJRIkLzoOYoWNaMJNB58eO6OZaZLxYe5CksnWDUflsvxDlgiWX6FUJ7tWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757194627; c=relaxed/simple;
	bh=C5+a7mCYIvqBEAn5lQppE669dnFrkzWQF1zk0YiPpuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEGWK8XkTtbP6Dj16XqxkLrTYFh0qkcOnXGzGVcetGysYLbsvToySEE3Rhe9kx7a9kN84eeIBWEGEp0XFirKv+DrilENMa9Kj8MV1z5fG2GSXBaUYQCsRIigeiJyHVux52x812JyEYAWwe850mIHIhYgCuliUERDVxMFJu04M7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aN33jdNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aN33jdNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A72FC4CEF5;
	Sat,  6 Sep 2025 21:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757194627;
	bh=C5+a7mCYIvqBEAn5lQppE669dnFrkzWQF1zk0YiPpuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aN33jdNbPPWCFS3rSncFy4YrpwJkk5GYVzpu/ZqZXYHs5pb7KD6mE/1nYTW0uwBnf
	 CuHEMW/f3i3Av7mUSLDXUucUvQbO0Ifxb4QQUa2m5NldzAh1levjiV/RC8l6NH/Vlj
	 jPrKaMMPtz6zW+NFbCYz2MszvmppHiQGp6fx348XONW90N+aL3rDFM335dTfmWjwGS
	 Fu4lcw9Zezc1Fp5TVuqYxucMlguTKBQYxNUCO5MU7XlJHWnsa2wyMf6IWdZHjDTmLn
	 cQmp7bIPWl4b3bZaLUlHs7wYTXFCZ35BiAjqlyqG072Tn5Xsc9TQ5/2TUvUsp2/LDX
	 siufRL71HJrLw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Zhiqi Song <songzhiqi1@huawei.com>,
	Longfang Liu <liulongfang@huawei.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 11/12] lib/crypto: tests: Enable Curve25519 test when CRYPTO_SELFTESTS
Date: Sat,  6 Sep 2025 14:35:22 -0700
Message-ID: <20250906213523.84915-12-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250906213523.84915-1-ebiggers@kernel.org>
References: <20250906213523.84915-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the Curve25519 library has been disentangled from CRYPTO,
adding CRYPTO_SELFTESTS as a default value of
CRYPTO_LIB_CURVE25519_KUNIT_TEST no longer causes a recursive kconfig
dependency.  Do this, which makes this option consistent with the other
crypto KUnit test options in the same file.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/tests/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/tests/Kconfig b/lib/crypto/tests/Kconfig
index eaca60d3e0a36..578af717e13a7 100644
--- a/lib/crypto/tests/Kconfig
+++ b/lib/crypto/tests/Kconfig
@@ -11,11 +11,11 @@ config CRYPTO_LIB_BLAKE2S_KUNIT_TEST
 	  KUnit tests for the BLAKE2s cryptographic hash function.
 
 config CRYPTO_LIB_CURVE25519_KUNIT_TEST
 	tristate "KUnit tests for Curve25519" if !KUNIT_ALL_TESTS
 	depends on KUNIT
-	default KUNIT_ALL_TESTS
+	default KUNIT_ALL_TESTS || CRYPTO_SELFTESTS
 	select CRYPTO_LIB_BENCHMARK_VISIBLE
 	select CRYPTO_LIB_CURVE25519
 	help
 	  KUnit tests for the Curve25519 Diffie-Hellman function.
 
-- 
2.50.1

