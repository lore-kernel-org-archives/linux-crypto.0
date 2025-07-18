Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B7EC2C9;
	Fri, 18 Jul 2025 22:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752876469; cv=none; b=XhkdyO1e4z9PRmZHF5kHjsmc2lwgUseo2nI9Or2omUNfWy4GDISKRhwNa34/xR9VrBeASUR/MKqBUatm0AhVG0+xfJ9MHg+bptVfxcQeBPPH9NWDr077zgyeM1bE0VnW/V1jNXPRrDklnH+3IT/xXvozmNDEVUYArKxhlP6vd6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752876469; c=relaxed/simple;
	bh=1CE6FSqwkeWvryzNivZ1ka0SgHoOi98KjNNJNBegE/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Qqj7zdVFyZoN/22jwaQJGD9csSLHjRXsH1TOJhAtswrt12HEM/cW+2Lrop4NWZrrlF3EDeNoUGumJE+sJaHNP4yq7LS9SRm1ODPC1LsmAsGcfQOPW0zPt2YRxpkp+wVfRHAFwW2fnSsHjVi9NLQlKv+AI3+i9XItRwyLUF0uCHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJXjgCpI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJXjgCpI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554CDC4CEEB;
	Fri, 18 Jul 2025 22:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752876468;
	bh=1CE6FSqwkeWvryzNivZ1ka0SgHoOi98KjNNJNBegE/Y=;
	h=From:To:Cc:Subject:Date:From;
	b=oJXjgCpIbic7ke/hk0PngNCG3uWEkILJVcf3B8OTheyN/vITGcfIDSj0j6uwd/w2l
	 DLz/SKzg7ImZa9o6BUT+8nkEG80zaHlefp70h6u2C8YyqjO2xCM5hn2+DlWFd0WyxB
	 dUSrTpB3cjJi7jZslFL6oDkl6CEMhYJWsHe8Hdd9Ntb0EguzT672XvJu8hLLDmWorD
	 DDxMFMJMtLKjXHHUThNUzbWTpMALLo/GUIXlEBEhPsNr4HxMA9ImT+L9Da+KS0dm3F
	 qA8/vh7HgEAQTyql2wZhOQsOxEMyoKMMKFY2shgz91if348VRs4YSXwl1zVLo87iFT
	 kWc2P8YpH0JFQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: arm64/sha512-ce: Drop compatibility macros for older binutils
Date: Fri, 18 Jul 2025 15:07:06 -0700
Message-ID: <20250718220706.475240-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the oldest supported binutils version is 2.30, the macros that
emit the SHA-512 instructions as '.inst' words are no longer needed.  So
drop them.  No change in the generated machine code.

Changed from the original patch by Ard Biesheuvel:
(https://lore.kernel.org/r/20250515142702.2592942-2-ardb+git@google.com):
 - Reduced scope to just SHA-512
 - Added comment that explains why "sha3" is used instead of "sha2"

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-next

 lib/crypto/arm64/sha512-ce-core.S | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/lib/crypto/arm64/sha512-ce-core.S b/lib/crypto/arm64/sha512-ce-core.S
index 7d870a435ea38..eaa485244af52 100644
--- a/lib/crypto/arm64/sha512-ce-core.S
+++ b/lib/crypto/arm64/sha512-ce-core.S
@@ -10,30 +10,17 @@
  */
 
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-	.irp		b,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19
-	.set		.Lq\b, \b
-	.set		.Lv\b\().2d, \b
-	.endr
-
-	.macro		sha512h, rd, rn, rm
-	.inst		0xce608000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
-	.endm
-
-	.macro		sha512h2, rd, rn, rm
-	.inst		0xce608400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
-	.endm
-
-	.macro		sha512su0, rd, rn
-	.inst		0xcec08000 | .L\rd | (.L\rn << 5)
-	.endm
-
-	.macro		sha512su1, rd, rn, rm
-	.inst		0xce608800 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
-	.endm
+	/*
+	 * While SHA-512 is part of the SHA-2 family of algorithms, the
+	 * corresponding arm64 instructions are actually part of the "sha3" CPU
+	 * feature.  (Except in binutils 2.30 through 2.42, which used "sha2".
+	 * But "sha3" implies "sha2", so "sha3" still works in those versions.)
+	 */
+	.arch		armv8-a+sha3
 
 	/*
 	 * The SHA-512 round constants
 	 */
 	.section	".rodata", "a"

base-commit: 66be847cc4c2e82fb50190b52b05b3bb0ef57999
-- 
2.50.1

