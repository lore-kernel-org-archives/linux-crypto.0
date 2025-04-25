Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B95F81E;
	Fri, 25 Apr 2025 00:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745540613; cv=none; b=Cyf96yxtNAo8S5/tn1vyoZCzHDLsQfP+IlOtqg4axfBVCCGWRIR2udiYyfccHhBGXaf7mq8M6UqQw9wtPJbv8PmIxyPozm3XqdmGWCmNAGrn1kWtO2lNENPwH83BXObDktn70P2HIv3O7pYnH/17h/+9yRRlGzpuSyiu3CakF9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745540613; c=relaxed/simple;
	bh=UEkSo+BagKkIVRMMe9pgkrGMxtdYLmVfK4/QgaOoRvc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Ex84vSnwWi0eXVM1WNg35JPUhIuCTWuU60oK1zPvYhEu0cALN9+d3Jd5a0fEBkGD9mvJHZ5JO+4giHIuNB/X34HJ9i3A9ePn0A7KGbyj+90lIItFZ7LN7+LH08/EfFqX3DHMN48FDj4Rx2IhTX42YX+DXXWSGzDv5HQk41w8R/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUarwgPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUarwgPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC6CC4CEE3;
	Fri, 25 Apr 2025 00:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745540612;
	bh=UEkSo+BagKkIVRMMe9pgkrGMxtdYLmVfK4/QgaOoRvc=;
	h=From:Date:Subject:To:Cc:From;
	b=pUarwgPxg10MK0UdQ+n5BCmMishwDRNdqKKtmZeSwy6yosN15zyV66BLSRDZi5A3c
	 yVKMHZZzjcPoaTAJlS3aJBbN3RbJtDAlMxvqvthKXy3RD4ayvHKrha1/fo9OcfQHxq
	 y7p3Ui7hk/Mm4qo9Aui0h5LGGGoYcAD3AX1BjZjgVC+bWmpXfVuc+PIbBPy645vLsk
	 +KV3W7aTXxXHLe9iZPp+6GvbYbRheGZDd2kiLKlCP9S8dqK9184eXrNyta7wElhwM4
	 FTPshbqWhVU5pc0It3lqahAGYR/TDUNf7wxEMMQkU0TwwNjZvcrEDK4Pblvz2ty7Yo
	 WclNOcBljsHiQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 24 Apr 2025 17:23:22 -0700
Subject: [PATCH] riscv: crypto - Use SYM_FUNC_START for functions only
 called directly
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250424-riscv-crypto-fix-cfi-build-v1-1-2d7516737379@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPnVCmgC/x3M0QpAQBBA0V/RPJtai8SvyIMds0wJzSKSf7d5P
 HW7DwRW4QBN8oDyKUHWJSJLE6CpX0ZGGaLBGluawhaoEuhE0nvbV/RyIXlBd8g8YF1WlSfnXW5
 6iINNOQb/vO3e9wM6U9lmbAAAAA==
X-Change-ID: 20250424-riscv-crypto-fix-cfi-build-9577fcbfb30a
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4387; i=nathan@kernel.org;
 h=from:subject:message-id; bh=UEkSo+BagKkIVRMMe9pgkrGMxtdYLmVfK4/QgaOoRvc=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBlc15gdXliefvD94bbcI7N/HPy2dd+jWCa5aMaq2Ts9a
 s1lVgb/7ChlYRDjYpAVU2Spfqx63NBwzlnGG6cmwcxhZQIZwsDFKQATsT3MyPCbPehTSr3+2ZsP
 Dqa6ymWJap1UdSs98Nj92LItsl/2GDsy/JXjmSl+buulJcuLYzcv6JwlNPsIf8TCyuOJttM9u2w
 2GjECAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After some recent changes to the RISC-V crypto code that turned some
indirect function calls into direct ones, builds with CONFIG_CFI_CLANG
fail with:

  ld.lld: error: undefined symbol: __kcfi_typeid_sm3_transform_zvksh_zvkb
  >>> referenced by arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.o:(.text+0x2) in archive vmlinux.a

  ld.lld: error: undefined symbol: __kcfi_typeid_sha512_transform_zvknhb_zvkb
  >>> referenced by arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.o:(.text+0x2) in archive vmlinux.a

  ld.lld: error: undefined symbol: __kcfi_typeid_sha256_transform_zvknha_or_zvknhb_zvkb
  >>> referenced by arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.o:(.text+0x2) in archive vmlinux.a

As these functions are no longer indirectly called (i.e., have their
address taken), the compiler will not emit __kcfi_typeid symbols for
them but SYM_TYPED_FUNC_START expects these to exist at link time.

Switch the definitions of these functions to use SYM_FUNC_START, as they
no longer need kCFI type information since they are only called
directly.

Fixes: 1523eaed0ac5 ("crypto: riscv/sm3 - Use API partial block handling")
Fixes: 561aab1104d8 ("crypto: riscv/sha512 - Use API partial block handling")
Fixes: e6c5597badf2 ("crypto: riscv/sha256 - Use API partial block handling")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.S | 4 ++--
 arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.S           | 4 ++--
 arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.S               | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.S b/arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.S
index 8ebcc17de4dc..f1f5779e4732 100644
--- a/arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.S
+++ b/arch/riscv/crypto/sha256-riscv64-zvknha_or_zvknhb-zvkb.S
@@ -43,7 +43,7 @@
 // - RISC-V Vector SHA-2 Secure Hash extension ('Zvknha' or 'Zvknhb')
 // - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
 
-#include <linux/cfi_types.h>
+#include <linux/linkage.h>
 
 .text
 .option arch, +zvknha, +zvkb
@@ -108,7 +108,7 @@
 
 // void sha256_transform_zvknha_or_zvknhb_zvkb(u32 state[8], const u8 *data,
 //					       int num_blocks);
-SYM_TYPED_FUNC_START(sha256_transform_zvknha_or_zvknhb_zvkb)
+SYM_FUNC_START(sha256_transform_zvknha_or_zvknhb_zvkb)
 
 	// Load the round constants into K0-K15.
 	vsetivli	zero, 4, e32, m1, ta, ma
diff --git a/arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.S b/arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.S
index 3a9ae210f915..89f4a10d12dd 100644
--- a/arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.S
+++ b/arch/riscv/crypto/sha512-riscv64-zvknhb-zvkb.S
@@ -43,7 +43,7 @@
 // - RISC-V Vector SHA-2 Secure Hash extension ('Zvknhb')
 // - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
 
-#include <linux/cfi_types.h>
+#include <linux/linkage.h>
 
 .text
 .option arch, +zvknhb, +zvkb
@@ -95,7 +95,7 @@
 
 // void sha512_transform_zvknhb_zvkb(u64 state[8], const u8 *data,
 //				     int num_blocks);
-SYM_TYPED_FUNC_START(sha512_transform_zvknhb_zvkb)
+SYM_FUNC_START(sha512_transform_zvknhb_zvkb)
 
 	// Setup mask for the vmerge to replace the first word (idx==0) in
 	// message scheduling.  There are 4 words, so an 8-bit mask suffices.
diff --git a/arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.S b/arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.S
index a2b65d961c04..4fe754846f65 100644
--- a/arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.S
+++ b/arch/riscv/crypto/sm3-riscv64-zvksh-zvkb.S
@@ -43,7 +43,7 @@
 // - RISC-V Vector SM3 Secure Hash extension ('Zvksh')
 // - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
 
-#include <linux/cfi_types.h>
+#include <linux/linkage.h>
 
 .text
 .option arch, +zvksh, +zvkb
@@ -81,7 +81,7 @@
 .endm
 
 // void sm3_transform_zvksh_zvkb(u32 state[8], const u8 *data, int num_blocks);
-SYM_TYPED_FUNC_START(sm3_transform_zvksh_zvkb)
+SYM_FUNC_START(sm3_transform_zvksh_zvkb)
 
 	// Load the state and endian-swap each 32-bit word.
 	vsetivli	zero, 8, e32, m2, ta, ma

---
base-commit: 63dc06cd12f980e304158888485a26ae2be7f371
change-id: 20250424-riscv-crypto-fix-cfi-build-9577fcbfb30a

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

