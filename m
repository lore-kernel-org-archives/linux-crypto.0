Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06DD365
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 04:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723610894; cv=none; b=WAOgEYpb2qkeb82M7i8B2PlgU8gzLalQa7TaFqLkbR7NeVSSTU1jBfssTknm9xe+VD42QPK7YwscnjoCr2Vo4pe9Q6TLWkYHPk9aMlnliiSxLCdvRoJ93tMuB5J0WP9iC7PJVIx1zdqEEXUu80zlfWgsQMxX8d7XAnEuyYsQBjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723610894; c=relaxed/simple;
	bh=wL/a0KeAtNsHevGCwJY9JM2teZyE8LAIsMmF5HMyFH4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Wuqmp/fRfdY/K6XMkCPY5zVOmgz258j8bHjastGnH4mF1khKBOZ8u8dhrhYdN02jRwzAkGul2gGuIFCk71rHDfv9OBAbfSKQi+WhZeJEBBtSaJ2NCLvJO5+yAkR1ilLs+VNJ4Dadh31QBQvBmCT2RGC9c1QlII15C7E9Nggc5lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--maskray.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ibqfj2Nm; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--maskray.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ibqfj2Nm"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-654d96c2bb5so117570747b3.2
        for <linux-crypto@vger.kernel.org>; Tue, 13 Aug 2024 21:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723610892; x=1724215692; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XRv8Qcrqidf4M4vZB4CYC860A/T/f/gL9po/MvKKEpY=;
        b=Ibqfj2Nm1Lj8e/ANYsq7wxD3Nd93CLMD5sqHPgzumYNM4MlTxbZ7qdSxtTWUT95a70
         nmlJjfxeOkpa341RFlBAOmyssas13QmC3x6u3an/d/CU1y1MRFlvUGE2fH6wfhIwHFvB
         j4ZH+nSyfBU+1WVGYg2yfcWulXsoHerNJ2/DGfUnjlxm3m8sjHYGGa6sNDva339JaS8V
         TcPw/QbzBjF8hmp2dMLFV3s+4QSWE6w9vVyP6P5+4kss6l2Lqvxgv35WxzdWMYSysyGA
         zxBGMvwN12aOG2fIzsmK9DNUg0zghRqpfb9p7bQWCxsVDIhQ/M6gXlyS8DveA/evjI91
         EwUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723610892; x=1724215692;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XRv8Qcrqidf4M4vZB4CYC860A/T/f/gL9po/MvKKEpY=;
        b=J5si+0VUqS9p1L26IeA7BLAwE5AsFJgUO0YQHIMFxU/2/NxarQBOMJzGmjZhO4kwox
         k7v3OUanPC/W1O6S5N+P/hZiGqtttYCcY4u82PcD6mz9UZVgklPYqqPFBqIZAm3X1fS3
         OEb/JXCrf1936ViABrhLXQjvzCE75Xv/Mw2/OUUyrZqThsbKqAxCY/WYbth7ky7s/kOp
         TmejqyF2m0NYyd7kFX3HL6mSSL6uSfbnO641t5XqhYQusrNkxCpYQhqMFwvecZgHEMX3
         Y5J9hgCWG6LtYtMifhatWTuZuFa0F9/TTNr0qoxH96ynFauVzJoHiLi9DZNtysuvaUX8
         EeSw==
X-Forwarded-Encrypted: i=1; AJvYcCXGI5m7ePomrEMPes6a6KnXbVpbvTpop71YRFdFZyK4qJi4X7fxs2WC11yBlMZ4wqTeYs3xkD5eHob5oSABSxLR8/Pd4rDpmcbAoPm+
X-Gm-Message-State: AOJu0YyM0MiG9BGmqnz3SYKVdCFFwxtmbdgVlPrc2eEHcC8cEWwoE01R
	bgGMZm8pigH/hvMirYOH8rAJaJyCxNZ1GVm2HdjUdsyGyfP47MCdT9TWZzoEB6pHlWf+8AZsWNq
	33oAqAw==
X-Google-Smtp-Source: AGHT+IEQGaK2Bew/+Dz+G2qEJz4GIkw33l6ehXLqIPkUArzubKD7yCQ/EizB7gE8HqKfOBksqswwPDwDF9Xq
X-Received: from maskray.svl.corp.google.com ([2620:15c:2d3:205:74b5:a459:b755:61f0])
 (user=maskray job=sendgmr) by 2002:a81:8d42:0:b0:66a:764f:e57f with SMTP id
 00721157ae682-6ac9b8ab418mr68657b3.7.1723610891742; Tue, 13 Aug 2024 21:48:11
 -0700 (PDT)
Date: Tue, 13 Aug 2024 21:48:02 -0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <20240814044802.1743286-1-maskray@google.com>
Subject: [PATCH] crypto: x86/sha256: Add parentheses around macros' single arguments
From: Fangrui Song <maskray@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, Thomas Gleixner <tglx@linutronix.de>, 
	linux-crypto@vger.kernel.org, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Jan Beulich <jbeulich@suse.com>, 
	Fangrui Song <maskray@google.com>
Content-Type: text/plain; charset="UTF-8"

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
---
 arch/x86/crypto/sha256-avx2-asm.S | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 0ffb072be956..0bbec1c75cd0 100644
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
2.46.0.76.ge559c4bf1a-goog

