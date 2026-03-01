Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDB12737E3;
	Sun,  1 Mar 2026 04:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772337772; cv=none; b=lLIq0WhPwS/7uXxbfQKyc/IwYNsmtk41/wUDb72BlDaYVk4MrR4DpipyPQc5lcAWRkQbj2Lfy1PvEKVc2CKDvQ4e3M/xEmoW6gsMCWDXV8zg+rLa9+fXRdialkWM0bXYS//r/VgoIVwG22Be/H0Ei2wB7oqFMIhFNC6ZfKDUwAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772337772; c=relaxed/simple;
	bh=10FKGo9Yp5BwzDzRT2Td86tre6vRNALXHq9msxrH9NI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RBwaj1mAGk0QQAGXPzGrERVfOslOLQ6t9nWTKhKfK7VXIdVwJWVSNND83fLUapplhcLHX3HcfeoyQVeBP7us+WWmlNAKT3vlNS47tpltV1ZvQyBG+AdZgp94DMpnLyw5u0Vc39BdEXJyyeWCxq/J9fl8QI4LjqS76XT/G5xOkdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vP+/sWrK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vP+/sWrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF483C116C6;
	Sun,  1 Mar 2026 04:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772337772;
	bh=10FKGo9Yp5BwzDzRT2Td86tre6vRNALXHq9msxrH9NI=;
	h=From:To:Cc:Subject:Date:From;
	b=vP+/sWrKkCzWj++4T7k/L70xGyGdyOs/geSNSiaFe6xurgR3nSxIF1FQhfYFVb+hO
	 j/vLXgQuryM9ga1zoWPTCrockbPLx4QI9w4269yNRTR/eLhN2EXxgFnjImfis3Yraq
	 eP1Vgy1AnoDwEnNoVnhMSzoWUp7eppeWiTWI2uCY9DnnOxEp3tThE9Oph1deK6PSGC
	 ZPthRVEEC4xvC+voCa497htjxNbkl6ixAjiHxWYpUh1lDgJyYrkqUx09jBGnKBMWSQ
	 hXs8LVzUlxDSHRoo5wtqnOP5YTs5q8RShWPdJ07d+FJPVZEsFhnyPiuwEPPd4FFJ3k
	 GQcwhhOnNafmQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Rae Moar <raemoar63@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: tests: Add a .kunitconfig file
Date: Sat, 28 Feb 2026 20:01:40 -0800
Message-ID: <20260301040140.490310-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a .kunitconfig file to the lib/crypto/ directory so that the crypto
library tests can be run more easily using kunit.py.  Example with UML:

    tools/testing/kunit/kunit.py run --kunitconfig=lib/crypto

Example with QEMU:

    tools/testing/kunit/kunit.py run --kunitconfig=lib/crypto --arch=arm64 --make_options LLVM=1

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This is targeting libcrypto-fixes

 lib/crypto/.kunitconfig | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 lib/crypto/.kunitconfig

diff --git a/lib/crypto/.kunitconfig b/lib/crypto/.kunitconfig
new file mode 100644
index 0000000000000..197d00065b4f5
--- /dev/null
+++ b/lib/crypto/.kunitconfig
@@ -0,0 +1,34 @@
+CONFIG_KUNIT=y
+
+# These kconfig options select all the CONFIG_CRYPTO_LIB_* symbols that have a
+# corresponding KUnit test.  CONFIG_CRYPTO_LIB_* cannot be directly enabled
+# here, since they are hidden symbols.
+CONFIG_CRYPTO=y
+CONFIG_CRYPTO_ADIANTUM=y
+CONFIG_CRYPTO_BLAKE2B=y
+CONFIG_CRYPTO_CHACHA20POLY1305=y
+CONFIG_CRYPTO_HCTR2=y
+CONFIG_CRYPTO_MD5=y
+CONFIG_CRYPTO_MLDSA=y
+CONFIG_CRYPTO_SHA1=y
+CONFIG_CRYPTO_SHA256=y
+CONFIG_CRYPTO_SHA512=y
+CONFIG_CRYPTO_SHA3=y
+CONFIG_INET=y
+CONFIG_IPV6=y
+CONFIG_NET=y
+CONFIG_NETDEVICES=y
+CONFIG_WIREGUARD=y
+
+CONFIG_CRYPTO_LIB_BLAKE2B_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_BLAKE2S_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_CURVE25519_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_MD5_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_MLDSA_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_NH_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_POLY1305_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_POLYVAL_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_SHA1_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_SHA256_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_SHA512_KUNIT_TEST=y
+CONFIG_CRYPTO_LIB_SHA3_KUNIT_TEST=y

base-commit: 4478e8eeb87120c11e90041864c2233238b2155a
-- 
2.53.0

