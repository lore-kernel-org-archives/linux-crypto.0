Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AF0183090;
	Wed, 25 Sep 2024 11:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727264214; cv=none; b=u+10YhbTGlcgc7TVuNOcPkJ+BEQbjOvsc+xFiFsQhbRcRjG44YVv/HJbOjzBsKgxtCM2TtuzN1N5QtYUnNVWyHavd6TJ4H1PQTLzNm5eOfh4Mm9si+2dxgbgicrL4kSBYb8mOlDOcLJcv7gPBufYwHoqQusMwmhpSBSAzauS6JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727264214; c=relaxed/simple;
	bh=BCRPbZGT2cytSH/WPYdWdJfSm5/GQ9nDnLyBHUbxs8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuSw4me6bsrV5mGseZImRhc+1HSDHdgH6TX5O55+gBsMZkM48zyx/UsQjzQn7fXGB02eOfrH2X37Ai9S+AhIQ6tc0zZ8uABfo14Y/l3WzT1MgYUTB/+YAtEfDUQo/27zqQK5uTlKiN/4J9uag7cGunnpsszNZoGu0F1iOiCadDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jm/oC18t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jm/oC18t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC92BC4CED7;
	Wed, 25 Sep 2024 11:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727264213;
	bh=BCRPbZGT2cytSH/WPYdWdJfSm5/GQ9nDnLyBHUbxs8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jm/oC18tNbe5zfdQTz1A3a+I0iHCL4xWfRll61oAAgvthBZSAcd7SMe0ylI76Ghd2
	 i3KBAhS6iSjFQXyr+l13fdOw5ShfvmHB9LIpzN97MDK0teLCtuMVpdj5wGbBafzeGB
	 aPRPzxVzJcVl1OjiVxkipg1cIVrSHbQYjWOXxgNOekEv3Tw/EYTZUeAbreeB3qK5hp
	 Am436ikYur1OqQ1HwVidZSXrDPHLXiCBNLlL3wl2xfc71KTDxE3QcelHDoBCyTF1SL
	 s15lufzzJuYhkLP02r0b0PV1X1lGT14svGdAXt3x+gMLmosGeMXCGfOlv9s+/rQ2j3
	 hNvcacu3LH/7w==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Fangrui Song <maskray@google.com>,
	Jan Beulich <jbeulich@suse.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	nathan@kernel.org,
	linux-crypto@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.11 006/244] crypto: x86/sha256 - Add parentheses around macros' single arguments
Date: Wed, 25 Sep 2024 07:23:47 -0400
Message-ID: <20240925113641.1297102-6-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240925113641.1297102-1-sashal@kernel.org>
References: <20240925113641.1297102-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11
Content-Transfer-Encoding: 8bit

From: Fangrui Song <maskray@google.com>

[ Upstream commit 3363c460ef726ba693704dbcd73b7e7214ccc788 ]

The macros FOUR_ROUNDS_AND_SCHED and DO_4ROUNDS rely on an
unexpected/undocumented behavior of the GNU assembler, which might
change in the future
(https://sourceware.org/bugzilla/show_bug.cgi?id=32073).

    M (1) (2) // 1 arg !? Future: 2 args
    M 1 + 2   // 1 arg !? Future: 3 args

    M 1 2     // 2 args

Add parentheses around the single arguments to support future GNU
assembler and LLVM integrated assembler (when the IsOperator hack from
the following link is dropped).

Link: https://github.com/llvm/llvm-project/commit/055006475e22014b28a070db1bff41ca15f322f0
Signed-off-by: Fangrui Song <maskray@google.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/crypto/sha256-avx2-asm.S | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 0ffb072be9561..0bbec1c75cd0b 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -592,22 +592,22 @@ SYM_TYPED_FUNC_START(sha256_transform_rorx)
 	leaq	K256+0*32(%rip), INP		## reuse INP as scratch reg
 	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
-	FOUR_ROUNDS_AND_SCHED	_XFER + 0*32
+	FOUR_ROUNDS_AND_SCHED	(_XFER + 0*32)
 
 	leaq	K256+1*32(%rip), INP
 	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
-	FOUR_ROUNDS_AND_SCHED	_XFER + 1*32
+	FOUR_ROUNDS_AND_SCHED	(_XFER + 1*32)
 
 	leaq	K256+2*32(%rip), INP
 	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 2*32+_XFER(%rsp, SRND)
-	FOUR_ROUNDS_AND_SCHED	_XFER + 2*32
+	FOUR_ROUNDS_AND_SCHED	(_XFER + 2*32)
 
 	leaq	K256+3*32(%rip), INP
 	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 3*32+_XFER(%rsp, SRND)
-	FOUR_ROUNDS_AND_SCHED	_XFER + 3*32
+	FOUR_ROUNDS_AND_SCHED	(_XFER + 3*32)
 
 	add	$4*32, SRND
 	cmp	$3*4*32, SRND
@@ -618,12 +618,12 @@ SYM_TYPED_FUNC_START(sha256_transform_rorx)
 	leaq	K256+0*32(%rip), INP
 	vpaddd	(INP, SRND), X0, XFER
 	vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
-	DO_4ROUNDS	_XFER + 0*32
+	DO_4ROUNDS	(_XFER + 0*32)
 
 	leaq	K256+1*32(%rip), INP
 	vpaddd	(INP, SRND), X1, XFER
 	vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
-	DO_4ROUNDS	_XFER + 1*32
+	DO_4ROUNDS	(_XFER + 1*32)
 	add	$2*32, SRND
 
 	vmovdqa	X2, X0
@@ -651,8 +651,8 @@ SYM_TYPED_FUNC_START(sha256_transform_rorx)
 	xor	SRND, SRND
 .align 16
 .Lloop3:
-	DO_4ROUNDS	 _XFER + 0*32 + 16
-	DO_4ROUNDS	 _XFER + 1*32 + 16
+	DO_4ROUNDS	(_XFER + 0*32 + 16)
+	DO_4ROUNDS	(_XFER + 1*32 + 16)
 	add	$2*32, SRND
 	cmp	$4*4*32, SRND
 	jb	.Lloop3
-- 
2.43.0

