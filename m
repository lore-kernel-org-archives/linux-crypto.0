Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06092D73B9;
	Fri, 25 Sep 2026 05:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790313984; cv=none; b=g7gXsT6T1fg/1AnRR/h5+EWBA+Zd1qSsgTiAbkf6fQw4Gb5yyvlshuYkrqm+JRNz5bJFNUMT64Crsjvo8FYjPzhvtUidUJ4/PLlTWDy0FeAgw94OoZPBjcOladcjbh1QTyXSK6ag2kKm9K6sPDAkeD7UKIXst+wEA3yQXPSnv/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790313984; c=relaxed/simple;
	bh=MP46wPWD8j8ODihGnKM1w/cGQIi5qrnoZHvqcqT9wW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eciH3GEtMbrRyFdeghy1WHGrHngQu7l6OtHGkFsp1mwEozaQXjF0xzfLqK53iwkEuw9SxoNQY2TD5xNJBDbQJKpocQLi5wpGfAGmsiMHO1mWf4/aENT8pX1CSlkIdqDV0Eoo6ry3ef8ZQik8d1NeJblm7jTytoqtVOSs8w1o7YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxlKoSsQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxlKoSsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B411F00893;
	Fri, 25 Sep 2026 05:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790313982;
	bh=D2dP+9qLw/W2WhQJy/yudsqVi8Y99UTYvNb8hXeqw7U=;
	h=From:To:Cc:Subject:Date;
	b=AxlKoSsQ+X+IWAAa4D75kbeOrX8+iau0y7wzFeKMQGASc0fp1KXPPQsvkcIDU+dgf
	 64ZhiZbyVD+4sqi3DoB8yCadosA+7LYpNUeuPUuh/lr53f04f5gdcW2qPNg4zyFsp6
	 Vbx5rRlwDSRHk08tMQ8YPd2kOJU5D/GK8jHSyaPoF6CNcpcxxIh1M9VoFRNQPUAZcF
	 u8fUQQ+fiEG+T/IfzlH7dYalTIlOSBiFH53arrrplsV9xrSHygl4kmPThZy0WJp9UV
	 DOMUroT9r3o0VbVX+2xQBlelVk1wC9KKsmopFH/7jmSrz4mUwrIhMuXjM/JPtQhEE9
	 SHQSB/aWEijwQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-doc@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] Documentation: libcrypto: Add additional testing information
Date: Thu, 24 Sep 2026 22:25:02 -0700
Message-ID: <20260925052502.188024-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Link to the KUnit documentation, mention the existence of the benchmarks
and how to enable them, explicitly mention that the tests can be run on
real hardware, and mention that it's often possible to clear CPU
features via the kernel command line.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is intended to be taken through libcrypto-next

 Documentation/crypto/libcrypto.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/crypto/libcrypto.rst b/Documentation/crypto/libcrypto.rst
index e911e0521597..53037e62728e 100644
--- a/Documentation/crypto/libcrypto.rst
+++ b/Documentation/crypto/libcrypto.rst
@@ -127,6 +127,8 @@ The crypto library uses standard KUnit tests.  Like many of the kernel's other
 KUnit tests, they are included in the set of tests that is run by
 ``tools/testing/kunit/kunit.py run --alltests``.
 
+For more information about KUnit, see Documentation/dev-tools/kunit/start.rst.
+
 A ``.kunitconfig`` file is also provided to run just the crypto library tests.
 For example, here's how to run them in user-mode Linux:
 
@@ -148,6 +150,17 @@ emulate the correct type of hardware for the code to be reached.
 Since correctness is essential in cryptographic code, new architecture-optimized
 code is accepted only if it can be tested in QEMU.
 
+Most of the crypto KUnit tests also include benchmarks.  To enable these, enable
+``CONFIG_CRYPTO_LIB_BENCHMARK=y`` (in addition to the tests themselves).  The
+benchmark results are printed to the kernel log when the test runs.
+
+Of course, the crypto KUnit tests can also be run on real hardware.  Note that
+it is generally still possible to test and benchmark non-default code paths in
+this case (for example, the software implementation of AES when the CPU has
+hardware-accelerated AES), since on many architectures the kernel supports
+disabling CPU features via the kernel command line.  For example, on x86,
+the ``clearcpuid=aes`` kernel command line option disables AES acceleration.
+
 Note: the crypto library also includes FIPS 140 self-tests.  These are
 lightweight, are designed specifically to meet FIPS 140 requirements, and exist
 *only* to meet those requirements.  Normal testing done by kernel developers and

base-commit: 165768bb70265b5c38cf0b73fafd75be235f8b14
-- 
2.55.0

