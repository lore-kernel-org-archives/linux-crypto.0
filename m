Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37861C84A1;
	Fri, 11 Jul 2025 21:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752269319; cv=none; b=D213f2TQtpkL3yEoIXiwqNwmWJ873TqijtRwxLO5k0yZgwW8aIpCP/cdG+1l1psXVB2HFLJ+C+3P2IlOFCXKT81EBDPs3kEylkNsmSUJGuyk+C3pYoCxUV0kh4nzIDvdIOQtH8M6WV8HxhwavbZMOK3sVaX4ixh78hZigoOcamw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752269319; c=relaxed/simple;
	bh=mgTFc9Ih57nI00XG3MdTUbxlxI73VXPHE562WpIzZ6w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dbcjPCg3+G1fjn0lf3Lo+QVjZdfp0tdJSWmem4wMWgzI7i3VGhMok5iWxcRSMZuKPFm1bexNzQLMauXraz5hPIZg4XnHO5Lc2ktABOwaWtZJNNffAv6e6L3XO2RgsPRdj5efTWVWCUOvQ+pqhA9wg+TKvlvEIfHPoimQpDboq2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YdqyT2bL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YdqyT2bL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42E6C4CEED;
	Fri, 11 Jul 2025 21:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752269319;
	bh=mgTFc9Ih57nI00XG3MdTUbxlxI73VXPHE562WpIzZ6w=;
	h=From:To:Cc:Subject:Date:From;
	b=YdqyT2bLFSoqRKKLyy+oKI0+QiaZ7ntkAP684LSrI0CT9ydHdbREd3ve1gIcFZQyL
	 SNDwM0v4hZ+rEFq9Zp/qqCUJm5FBTIGNRWp4iYIEXteRVJ86ikhQ1+uRdvoToqJD1u
	 mN8i91sQ3pdVVOc5eJ4ZWJftdAuc1uXxMsV+p/K8OCXS83joqb2PdPC4R2ic29RWvc
	 ZASkAi2H+wu8Y1qgKfJqRa1XBTns230biniXdzBv3WqbXsQI2sFl+eXHCoqt6za7XS
	 vIBtRYplwHIE9xtwevn1pbmJ2JRghzm/Cy/SSiNCvQCoPSyCaMS0wmQSlRbyW60A29
	 GUDD2JBR0LJbw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Arnd Bergmann <arnd@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] lib/crypto: arm/poly1305: Remove unneeded empty weak function
Date: Fri, 11 Jul 2025 14:28:22 -0700
Message-ID: <20250711212822.6372-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix poly1305-armv4.pl to not do '.globl poly1305_blocks_neon' when
poly1305_blocks_neon() is not defined.  Then, remove the empty __weak
definition of poly1305_blocks_neon(), which was still needed only
because of that unnecessary globl statement.  (It also used to be needed
because the compiler could generate calls to it when
CONFIG_KERNEL_MODE_NEON=n, but that has been fixed.)

Thanks to Arnd Bergmann for reporting that the globl statement in the
asm file was still depending on the weak symbol.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm/poly1305-armv4.pl | 2 +-
 lib/crypto/arm/poly1305-glue.c   | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/lib/crypto/arm/poly1305-armv4.pl b/lib/crypto/arm/poly1305-armv4.pl
index d57c6e2fc84a5..dd7a996361a71 100644
--- a/lib/crypto/arm/poly1305-armv4.pl
+++ b/lib/crypto/arm/poly1305-armv4.pl
@@ -44,11 +44,10 @@ $code.=<<___;
 # define __ARM_ARCH__ __LINUX_ARM_ARCH__
 # define __ARM_MAX_ARCH__ __LINUX_ARM_ARCH__
 # define poly1305_init   poly1305_block_init_arch
 # define poly1305_blocks poly1305_blocks_arm
 # define poly1305_emit   poly1305_emit_arch
-.globl	poly1305_blocks_neon
 #endif
 
 #if defined(__thumb2__)
 .syntax	unified
 .thumb
@@ -720,10 +719,11 @@ poly1305_init_neon:
 
 .Lno_init_neon:
 	ret				@ bx	lr
 .size	poly1305_init_neon,.-poly1305_init_neon
 
+.globl	poly1305_blocks_neon
 .type	poly1305_blocks_neon,%function
 .align	5
 poly1305_blocks_neon:
 .Lpoly1305_blocks_neon:
 	ldr	ip,[$ctx,#36]		@ is_base2_26
diff --git a/lib/crypto/arm/poly1305-glue.c b/lib/crypto/arm/poly1305-glue.c
index 2603b0771f2c4..5b65b840c1666 100644
--- a/lib/crypto/arm/poly1305-glue.c
+++ b/lib/crypto/arm/poly1305-glue.c
@@ -25,15 +25,10 @@ asmlinkage void poly1305_blocks_neon(struct poly1305_block_state *state,
 asmlinkage void poly1305_emit_arch(const struct poly1305_state *state,
 				   u8 digest[POLY1305_DIGEST_SIZE],
 				   const u32 nonce[4]);
 EXPORT_SYMBOL_GPL(poly1305_emit_arch);
 
-void __weak poly1305_blocks_neon(struct poly1305_block_state *state,
-				 const u8 *src, u32 len, u32 hibit)
-{
-}
-
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
 void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 			  unsigned int len, u32 padbit)
 {

base-commit: 57b15e9260a31438e91cf83dbfcb63333b24c684
-- 
2.50.1

