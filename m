Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 162241836E5;
	Mon, 15 Jul 2024 07:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721028038; cv=none; b=IYjHIK4KXzfcEff3KhlZF6vwaiUNpNx1btcHeWJnzL+KMvV7vdvIUGyisABU54hG+CDpq5Mo+UQw+2btsjLWm3LmxPLoYsgjysTCiLzJDzSZgPPtz02iUczHZZb3g5hBiPk2MM6GzU/Ac3J5kVo1JH/6ufMuH5tMccDb14qKwFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721028038; c=relaxed/simple;
	bh=a/WIuqv1tl1tle3ziL/NH5UYypFiStw8mDYKOrs/UzM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=qdgsHlOoSvtl8NqiWJMVKULDfjL6qlgZU5E6vzWsOFEGoBakRm76cGnGkb6soZwDtR5iR7u8Fn9vMYrGAPmm7lrkp4Q3RF31tce31gwYmjRHwQQYT1FXRFibfuF9WrDmue/nbjafZT5m5zOulSwCJKatRBY00FYAQ67FZ1BKuBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46645DA7;
	Mon, 15 Jul 2024 00:21:00 -0700 (PDT)
Received: from entos-yitian-01.shanghai.arm.com (entos-yitian-01.shanghai.arm.com [10.169.206.96])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DF92C3F762;
	Mon, 15 Jul 2024 00:20:31 -0700 (PDT)
From: Jia He <justin.he@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-crypto@vger.kernel.org
Cc: Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH] crypto: arm64/poly1305 - move data to rodata section
Date: Mon, 15 Jul 2024 07:20:23 +0000
Message-Id: <20240715072023.61032-1-justin.he@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When objtool gains support for ARM in the future, it may encounter issues
disassembling the following data in the .text section: 
> .Lzeros:
> .long   0,0,0,0,0,0,0,0
> .asciz  "Poly1305 for ARMv8, CRYPTOGAMS by \@dot-asm"
> .align  2

Move it to .rodata which is a more appropriate section for read-only data.

Signed-off-by: Jia He <justin.he@arm.com>
---
Inspired by commit 1253cab8a352, although currently objtool hasn't been
supported on Arm, we should do some preparation(this patch) firstly.

 arch/arm64/crypto/poly1305-armv8.pl | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/crypto/poly1305-armv8.pl b/arch/arm64/crypto/poly1305-armv8.pl
index cbc980fb02e3..bcb70c9541e9 100644
--- a/arch/arm64/crypto/poly1305-armv8.pl
+++ b/arch/arm64/crypto/poly1305-armv8.pl
@@ -885,10 +885,13 @@ poly1305_blocks_neon:
 	ret
 .size	poly1305_blocks_neon,.-poly1305_blocks_neon
 
+.pushsection .rodata
 .align	5
 .Lzeros:
 .long	0,0,0,0,0,0,0,0
 .asciz	"Poly1305 for ARMv8, CRYPTOGAMS by \@dot-asm"
+.popsection
+
 .align	2
 #if !defined(__KERNEL__) && !defined(_WIN64)
 .comm	OPENSSL_armcap_P,4,4
-- 
2.34.1

