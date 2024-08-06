Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C600615D1;
	Tue,  6 Aug 2024 05:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722923710; cv=none; b=GKnIJ7fLimfEnukPmiCUtRL1Tl5xszeI1B1CFPmgTQqc9dot+r0C5N2IlQif9bCgCWexE5aO4j1O9/hKjkfR2Ejbb3Q+35iWYEiu2EhmkjtxDViQ1NcfZrZ4iWVySlvMcSD+EHqCmgpDXejfCpgJiUjXCtXUaUqE8BXeNc9fQFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722923710; c=relaxed/simple;
	bh=r/OxstG860TQKkSCJl419UwMF4PiKYNabXTfHM39AZI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ll8ZWHdz9hFWP04if4vdeyRNv0/52lt1IICvnhM91Q3WAvhZuAwb0uJDmWkDHB/VOZXsdiKxro9Io8FkVo7HbZ8nEymJ223svdrpqVGcj6j2kcPWltEE9PSo35GWZPITLiV0MPx0ZcBk6iWi48SMdeRq1vfFGjfKFBHsq2PjW0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B5BA106F;
	Mon,  5 Aug 2024 22:55:26 -0700 (PDT)
Received: from entos-yitian-01.shanghai.arm.com (entos-yitian-01.shanghai.arm.com [10.169.218.121])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6BC433F5A1;
	Mon,  5 Aug 2024 22:54:57 -0700 (PDT)
From: Jia He <justin.he@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Andy Polyakov <appro@cryptogams.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Jia He <justin.he@arm.com>
Subject: [PATCH v2] crypto: arm64/poly1305 - move data to rodata section
Date: Tue,  6 Aug 2024 05:54:44 +0000
Message-Id: <20240806055444.528932-1-justin.he@arm.com>
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

There is a limit on how far the label can be from the instruction, hence
use "adrp" and low 12bits offset of the label to avoid the compilation
error.

Signed-off-by: Jia He <justin.he@arm.com>
---
v2:
  - use adrp+offset to avoid compilation error(kernel test bot and Andy)
v1: https://lkml.org/lkml/2024/8/2/616

 arch/arm64/crypto/poly1305-armv8.pl | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/poly1305-armv8.pl b/arch/arm64/crypto/poly1305-armv8.pl
index cbc980fb02e3..22c9069c0650 100644
--- a/arch/arm64/crypto/poly1305-armv8.pl
+++ b/arch/arm64/crypto/poly1305-armv8.pl
@@ -473,7 +473,8 @@ poly1305_blocks_neon:
 	subs	$len,$len,#64
 	ldp	x9,x13,[$inp,#48]
 	add	$in2,$inp,#96
-	adr	$zeros,.Lzeros
+	adrp	$zeros,.Lzeros
+	add	$zeros,$zeros,#:lo12:.Lzeros
 
 	lsl	$padbit,$padbit,#24
 	add	x15,$ctx,#48
@@ -885,10 +886,13 @@ poly1305_blocks_neon:
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

