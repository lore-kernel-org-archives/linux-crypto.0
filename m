Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E920F34253B;
	Sun, 22 Mar 2026 03:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774149975; cv=none; b=N4fBXlcvKbRProla08LRD85cn5qTfDsaHZTpkBJKT40V3RLRRs3jpK2+AXscD+8ewfWFnLTNWeJ6gMmVKz+2RbZdnbxtwTd1B6VQU3wVLTYy3S7a3eBy14MIhFUXhkahpOgJDm0wU45HxXMDcxVEHTXJwzvFSbcXwMqES3bCtFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774149975; c=relaxed/simple;
	bh=+BiopDhJNcSEnMguLN0qdQX1rIFAdTnVHGsgkJ98n4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZEXEwvQrYDHY/t2gxdxcoRHlCz0DKJ+qE28Sp9v61mVCKh/gX670O6LZpH7HfPErtKKsT44kkffZbAJRrFh8kwoQKmDoRKwIKHnhlmH3AKSeUiY0/P4JydTiNm4aomOmrPsMNrHZvOUbblOWGGocjW0xqjFu4ZMM8PThuIt1lgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZmqPNdFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZmqPNdFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39AE5C2BCB0;
	Sun, 22 Mar 2026 03:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774149974;
	bh=+BiopDhJNcSEnMguLN0qdQX1rIFAdTnVHGsgkJ98n4Y=;
	h=From:To:Cc:Subject:Date:From;
	b=ZmqPNdFZF2CGRgr5ewNg2Qdmmg0/nKu77Iw1IhLXgXvjbLG5a1IBsZP0pJ6Fx5iIy
	 frvOWgujsWKpXLINaoChcrzKPqWXlKXFbYeyeja1EQZglHpmk79/lM1odMt0hM/Rnk
	 LjHmeB9Cs6d46Qto0iMtGCkd6kQTv6+0nfxGfJQv3f7jGWRMJ/FH/I6zZD3IZ3DNyx
	 ODx6uEO4BYskApdMIjZSyO4H+u2NpAK8WpStkGeFjcJ9QBxXkI9x9T/biTHZv/j3oT
	 u4rk1XHNdZSzFaFFIbXV135bWZFZIqTztvf8G+FmC5+o7cRKYu2r2LJLzpv+R3Yfk2
	 k2kibVpKlJMZw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib: Move crypto library tests to Runtime Testing menu
Date: Sat, 21 Mar 2026 20:24:38 -0700
Message-ID: <20260322032438.286296-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the kconfig options for the crypto library KUnit tests appear
in the menu:

    -> Library routines
      -> Crypto library routines

However, this is the only content of "Crypto library routines".  I.e.,
it is empty when CONFIG_KUNIT=n.  This is because the crypto library
routines themselves don't have (or need to have) prompts.

Since this usually ends up as an unnecessary empty menu, let's remove
this menu and instead source the lib/crypto/tests/Kconfig file from
lib/Kconfig.debug inside the "Runtime Testing" menu:

    -> Kernel hacking
      -> Kernel Testing and Coverage
        -> Runtime Testing

This puts the prompts alongside the ones for most of the other lib/
KUnit tests.  This seems to be a much better match to how the kconfig
menus are organized.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting the libcrypto-next tree

 lib/Kconfig.debug  | 2 ++
 lib/crypto/Kconfig | 6 ------
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 93f356d2b3d9..146358530010 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -3056,10 +3056,12 @@ config HW_BREAKPOINT_KUNIT_TEST
 	help
 	  Tests for hw_breakpoint constraints accounting.
 
 	  If unsure, say N.
 
+source "lib/crypto/tests/Kconfig"
+
 config SIPHASH_KUNIT_TEST
 	tristate "Perform selftest on siphash functions" if !KUNIT_ALL_TESTS
 	depends on KUNIT
 	default KUNIT_ALL_TESTS
 	help
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 4910fe20e42a..f7a21d20e470 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -1,9 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
-menu "Crypto library routines"
-
 config CRYPTO_HASH_INFO
 	bool
 
 config CRYPTO_LIB_UTILS
 	tristate
@@ -265,9 +263,5 @@ config CRYPTO_LIB_SHA3_ARCH
 	default y if ARM64
 	default y if S390
 
 config CRYPTO_LIB_SM3
 	tristate
-
-source "lib/crypto/tests/Kconfig"
-
-endmenu
-- 
2.53.0

