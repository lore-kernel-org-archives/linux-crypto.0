Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE471DB346;
	Mon,  9 Jun 2025 22:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749509139; cv=none; b=qAdzPfSQb/hmJF1Pky6OOjt/PnBFe/mWVKj123XLiHbuwvHeuJdvSo64E40GaTN8J/WJtkNQYBOATefHv29r/3R/0RolZrKSXmyGPYVWR0JAqcmZSWjy02cjjlhFyItrLfVSVTvSqH/PU0lx+51zGM+yihmHbv/pjp1W0ALuIIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749509139; c=relaxed/simple;
	bh=WFQYQD8RAjjcA8Sk2MicveepzUETmW1VGCWSzHQgapQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=DT3FdTjzGGffCCczP8HbtsQ1Cyo1YwjVHO9uH8M1JqApA4aUY9LEfD0gndPzIS1M4hKO7WaIQt1oYfVPfjgrJBvisM4KW0WivpMisD2LGobVhk1gmvln1HTKqh/33M7O1zDsxo1PU4zamK68fXi8SLHbptx9ZwOzibMVLKlkHeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZB3Oltx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZB3Oltx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EEB2C4CEEB;
	Mon,  9 Jun 2025 22:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749509139;
	bh=WFQYQD8RAjjcA8Sk2MicveepzUETmW1VGCWSzHQgapQ=;
	h=From:Date:Subject:To:Cc:From;
	b=EZB3OltxnH29a1ZJADXn4iEaWBi2PYdgKJL9Cm8Iv+9TP5bYzP/f0wivBAiuRSXkz
	 /WqE4ecGaw4+IZZzTcHQ5O4lEduvbzsj6YYIWFNzBreF0zwtLG9ZEo+2bMs5v2EebS
	 VGFK3o3QkZSDKH6pdUBnJ31RMvQNiHJzPQZmD1ROSclVqlvXTimTphUvgLte4S0Y0B
	 8Ajh4VNNaLCos2ZNd8KfTkDV5UB3rNXKZ6WrwPC12IBMF/RtDEct2dZBJmVD/wy0Xf
	 F5J+NAJ24rCjNyYOc5asRBcKONn5IVSf6bZ+LKMNsGTuEtjnnaiBfrMK57XFfDkP18
	 GuradEParqlZQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 09 Jun 2025 15:45:20 -0700
Subject: [PATCH] crypto: lib/curve25519-hacl64 - Disable KASAN with
 clang-17 and older
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250609-curve25519-hacl64-disable-kasan-clang-v1-1-08ea0ac5ccff@kernel.org>
X-B4-Tracking: v=1; b=H4sIAP9jR2gC/x2NQQrDIBAAvxL23AW10WK/UnrYmrVZKra4JBRC/
 h7JcQ4zs4FyE1a4Dxs0XkXlWzvYywBppvpmlKkzOOO8CSZiWtrKznsbcaZUwoiTKL0K44eUKqb
 SLcyUA8fb1Xoeobd+jbP8z8/jue8HpD1xfXcAAAA=
X-Change-ID: 20250609-curve25519-hacl64-disable-kasan-clang-faf6e97315e4
To: Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2678; i=nathan@kernel.org;
 h=from:subject:message-id; bh=WFQYQD8RAjjcA8Sk2MicveepzUETmW1VGCWSzHQgapQ=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnuKYIeZy0/z2New7rglMrVzLVsx20Wt7glbzo0ITfkH
 LP17BvJHaUsDGJcDLJiiizVj1WPGxrOOct449QkmDmsTCBDGLg4BWAi5XcYGV5Lfkrlv7pivXV8
 w8XE7pvb+fMP8zLYPVQ8/k0gpNF3ngkjw0MjCb1PJRL70pOvOb2qXXrpsH2t4K198z4tNlt44nC
 6FjMA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After commit 6f110a5e4f99 ("Disable SLUB_TINY for build testing"), which
causes CONFIG_KASAN to be enabled in allmodconfig again, arm64
allmodconfig builds with clang-17 and older show an instance of
-Wframe-larger-than (which breaks the build with CONFIG_WERROR=y):

  lib/crypto/curve25519-hacl64.c:757:6: error: stack frame size (2336) exceeds limit (2048) in 'curve25519_generic' [-Werror,-Wframe-larger-than]
    757 | void curve25519_generic(u8 mypublic[CURVE25519_KEY_SIZE],
        |      ^

When KASAN is disabled, the stack usage is roughly quartered:

  lib/crypto/curve25519-hacl64.c:757:6: error: stack frame size (608) exceeds limit (128) in 'curve25519_generic' [-Werror,-Wframe-larger-than]
    757 | void curve25519_generic(u8 mypublic[CURVE25519_KEY_SIZE],
        |      ^

Using '-Rpass-analysis=stack-frame-layout' shows the following variables
and many, many 8-byte spills when KASAN is enabled:

  Offset: [SP-144], Type: Variable, Align: 8, Size: 40
  Offset: [SP-464], Type: Variable, Align: 8, Size: 320
  Offset: [SP-784], Type: Variable, Align: 8, Size: 320
  Offset: [SP-864], Type: Variable, Align: 32, Size: 80
  Offset: [SP-896], Type: Variable, Align: 32, Size: 32
  Offset: [SP-1016], Type: Variable, Align: 8, Size: 120

When KASAN is disabled, there are still spills but not at many and the
variables list is smaller:

  Offset: [SP-192], Type: Variable, Align: 32, Size: 80
  Offset: [SP-224], Type: Variable, Align: 32, Size: 32
  Offset: [SP-344], Type: Variable, Align: 8, Size: 120

Disable KASAN for this file when using clang-17 or older to avoid
blowing out the stack, clearing up the warning.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 lib/crypto/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 3e79283b617d..18664127ecd6 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -35,6 +35,10 @@ obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC)	+= libcurve25519-generic.o
 libcurve25519-generic-y				:= curve25519-fiat32.o
 libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
 libcurve25519-generic-y				+= curve25519-generic.o
+# clang versions prior to 18 may blow out the stack with KASAN
+ifeq ($(call clang-min-version, 180000),)
+KASAN_SANITIZE_curve25519-hacl64.o := n
+endif
 
 obj-$(CONFIG_CRYPTO_LIB_CURVE25519)		+= libcurve25519.o
 libcurve25519-y					+= curve25519.o

---
base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
change-id: 20250609-curve25519-hacl64-disable-kasan-clang-faf6e97315e4

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

