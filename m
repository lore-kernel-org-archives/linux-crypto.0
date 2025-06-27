Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8BF1FA178;
	Fri, 27 Jun 2025 19:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751051460; cv=none; b=f65LRcD3pMAvW/Hzn5DIig75BlFYd6ZMTxc5Px8XH3O6I2nJQ8gpr19/vODaTlvqHYAN66PnJ91AinrSQyQ31gk2XYOqEx6yyPIkXGp/rXc54ugnJt9MM6cTtU+H3AW9MdsXYZ5uP05d2pXqU04LHFnN8ktwB+OqAM5nJlY6wK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751051460; c=relaxed/simple;
	bh=QZiRTIlW7NLE74aUDOhyqOhz1pnacE00cL6tAh357EM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BtsUY+69MM73vxz5ECf04PP3iJBLF7ODtBk6PmJHBV2qIXvgmqF1lWdgULpKwAxtVw4msiYACVoWuLetQM32jlgZA8SwLvT5ly3TEXbKuiqdQkaLkUyzx6nJbb9qrydN8t7BL2B8J4jHrMyrS7SGZvFwrigy5/KlN/GBXzDIp3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gZ1l8wcF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gZ1l8wcF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619BDC4CEE3;
	Fri, 27 Jun 2025 19:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751051459;
	bh=QZiRTIlW7NLE74aUDOhyqOhz1pnacE00cL6tAh357EM=;
	h=From:To:Cc:Subject:Date:From;
	b=gZ1l8wcFhgJeBP3/hryq7iU4k7N+1fcXJwN2wMru8CHICE6YABwyfKMxUy6xGhvQT
	 j5BfXHyomSCG+4GoYhe7g4P24Gjvm/Ep/yq1zfQbVj/xaKf96vtYUJ4us0nTEg1eRA
	 LCeooBLEw8Z/1rvDg+qbfjjWAQPkM/wCuBt5ndNXJBOzwjXp6STxMrtgJBrNk40oXm
	 aNMklTk8jL+fAQ34ychjIrcd/8LZs5Pqez4RvhyiGIwOxmynmhkQ9Zqxd/3/faYPFO
	 0D6N7GuKRKzLylZ5kum6z4+K/5i6pabXo29oSikYPRpOLwVe5+vLEkF4L0m+G5ZWmR
	 FhYXgIjES7rJQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: x86/sha512: Drop unnecessary ANNOTATE_NOENDBR
Date: Fri, 27 Jun 2025 12:09:40 -0700
Message-ID: <20250627190940.66756-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When migrating the x86 SHA-512 assembly code to lib/crypto/, I replaced
SYM_TYPED_FUNC_START with ANNOTATE_NOENDBR.  This was intended to match
a change in the caller from an indirect call to a static call, like what
I did for SHA-256.  However, for SHA-512 I actually decided to bring the
static call up a level; see DEFINE_X86_SHA512_FN in
lib/crypto/x86/sha512.h.  Therefore, now the assembly functions are just
called via normal direct calls.  At least for SHA this seems to be the
better way to do it, and it means using ANNOTATE_NOENDBR is unnecessary.

Fixes: b82535bf96da ("lib/crypto: x86/sha512: Migrate optimized SHA-512 code to library")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next.

 lib/crypto/x86/sha512-avx-asm.S   | 2 --
 lib/crypto/x86/sha512-avx2-asm.S  | 2 --
 lib/crypto/x86/sha512-ssse3-asm.S | 2 --
 3 files changed, 6 deletions(-)

diff --git a/lib/crypto/x86/sha512-avx-asm.S b/lib/crypto/x86/sha512-avx-asm.S
index af7ea311cc945..7732aa8fd8506 100644
--- a/lib/crypto/x86/sha512-avx-asm.S
+++ b/lib/crypto/x86/sha512-avx-asm.S
@@ -46,11 +46,10 @@
 # and search for that title.
 #
 ########################################################################
 
 #include <linux/linkage.h>
-#include <linux/objtool.h>
 
 .text
 
 # Virtual Registers
 # ARG1
@@ -274,11 +273,10 @@ frame_size = frame_WK + WK_SIZE
 # The size of the message pointed to by "data" must be an integer multiple
 # of SHA512 message blocks.
 # "nblocks" is the message length in SHA512 blocks.  Must be >= 1.
 ########################################################################
 SYM_FUNC_START(sha512_transform_avx)
-	ANNOTATE_NOENDBR	# since this is called only via static_call
 
 	# Save GPRs
 	push	%rbx
 	push	%r12
 	push	%r13
diff --git a/lib/crypto/x86/sha512-avx2-asm.S b/lib/crypto/x86/sha512-avx2-asm.S
index 1302ddb5ec8cc..22bdbfd899d0f 100644
--- a/lib/crypto/x86/sha512-avx2-asm.S
+++ b/lib/crypto/x86/sha512-avx2-asm.S
@@ -48,11 +48,10 @@
 ########################################################################
 # This code schedules 1 blocks at a time, with 4 lanes per block
 ########################################################################
 
 #include <linux/linkage.h>
-#include <linux/objtool.h>
 
 .text
 
 # Virtual Registers
 Y_0 = %ymm4
@@ -566,11 +565,10 @@ frame_size = frame_CTX + CTX_SIZE
 # The size of the message pointed to by "data" must be an integer multiple
 # of SHA512 message blocks.
 # "nblocks" is the message length in SHA512 blocks.  Must be >= 1.
 ########################################################################
 SYM_FUNC_START(sha512_transform_rorx)
-	ANNOTATE_NOENDBR	# since this is called only via static_call
 
 	# Save GPRs
 	push	%rbx
 	push	%r12
 	push	%r13
diff --git a/lib/crypto/x86/sha512-ssse3-asm.S b/lib/crypto/x86/sha512-ssse3-asm.S
index 108f1accc6bc7..4cae7445b2a86 100644
--- a/lib/crypto/x86/sha512-ssse3-asm.S
+++ b/lib/crypto/x86/sha512-ssse3-asm.S
@@ -46,11 +46,10 @@
 # and search for that title.
 #
 ########################################################################
 
 #include <linux/linkage.h>
-#include <linux/objtool.h>
 
 .text
 
 # Virtual Registers
 # ARG1
@@ -273,11 +272,10 @@ frame_size = frame_WK + WK_SIZE
 # The size of the message pointed to by "data" must be an integer multiple
 # of SHA512 message blocks.
 # "nblocks" is the message length in SHA512 blocks.  Must be >= 1.
 ########################################################################
 SYM_FUNC_START(sha512_transform_ssse3)
-	ANNOTATE_NOENDBR	# since this is called only via static_call
 
 	# Save GPRs
 	push	%rbx
 	push	%r12
 	push	%r13

base-commit: d74152ec2b5106263c2a502380acfaf5954f9898
-- 
2.50.0

