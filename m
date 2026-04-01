Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74500E555;
	Wed,  1 Apr 2026 00:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775002072; cv=none; b=TwvCC5LeMpB91s7lx+KahD9ljbMfdXUK8DWmG3uf2EXdCIdcW7RqtuoCNRDgOb482/ASpKiA/eCQYt9NQmkjT4DMmW0fJR5TwVWSvJdANDLSifzWdzL27tS6v8c4yjjyqgkv4aGgLiuHFRIV7OLLyswDesHynX3bPPGBjTaRBXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775002072; c=relaxed/simple;
	bh=uSa6SngRywqNPRUM39lw0q3opK7TOlmwGZRujqiCUMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgyUmBUYkZDw/rS6z1zI8aOG2aWRBYstm+wkHk99Xx6NzTMQ+zfFLLbCyTMXsfTrdHvpHdMLOb6n92pcuK0wV8nPAcdYTxBfoCLAtvgpdqdavKyWmCm3gNtT2R5YQ1lDtgN9SCQBvbxqNNaYu6Aws7oVgsiNGiQONFziZR2jNEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XJ8IBEgw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XJ8IBEgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14283C2BCB0;
	Wed,  1 Apr 2026 00:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775002072;
	bh=uSa6SngRywqNPRUM39lw0q3opK7TOlmwGZRujqiCUMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJ8IBEgwo/GNi2M4/AW7mMQF5q1QaE9GwYnJLyqk0QVPdcttvrfH9iHO9ftvLcXha
	 YMkLOI/ph8J5n+oMb9+ULFr9x4oClKY/MahoP9bGJlC69DSIQFiDBGuTvaZvGqw7E7
	 6cgGuVHozNi/rOUQ1l/5p3iSPvSQLcnnwjlk9ds50UnM9GQaiM+aTtqALZ3/cuHe9m
	 UDYA2Umm8/xO/PsgwXPcxgVcxoEOypHfV6cZ0Iwxg/C+ibQPckec8J5OooB3VTubcu
	 qHsDhGupLNfBHSFQcXx24DVcymcp7IAb7dKl6y47ojrUHy6mot1pd41ou5ngm5j9Bo
	 Y+c3nekPZ1vTg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 9/9] arm64: fpsimd: Remove obsolete cond_yield macro
Date: Tue, 31 Mar 2026 17:05:48 -0700
Message-ID: <20260401000548.133151-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401000548.133151-1-ebiggers@kernel.org>
References: <20260401000548.133151-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All invocations of the cond_yield macro have been removed, so remove the
macro definition as well.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/include/asm/assembler.h | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index d3d46e5f7188..9d7c9ae5ac96 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -746,32 +746,10 @@ alternative_else_nop_endif
 
 .macro set_sctlr_el2, reg
 	set_sctlr sctlr_el2, \reg
 .endm
 
-	/*
-	 * Check whether asm code should yield as soon as it is able. This is
-	 * the case if we are currently running in task context, and the
-	 * TIF_NEED_RESCHED flag is set. (Note that the TIF_NEED_RESCHED flag
-	 * is stored negated in the top word of the thread_info::preempt_count
-	 * field)
-	 */
-	.macro		cond_yield, lbl:req, tmp:req, tmp2
-#ifdef CONFIG_PREEMPT_VOLUNTARY
-	get_current_task \tmp
-	ldr		\tmp, [\tmp, #TSK_TI_PREEMPT]
-	/*
-	 * If we are serving a softirq, there is no point in yielding: the
-	 * softirq will not be preempted no matter what we do, so we should
-	 * run to completion as quickly as we can. The preempt_count field will
-	 * have BIT(SOFTIRQ_SHIFT) set in this case, so the zero check will
-	 * catch this case too.
-	 */
-	cbz		\tmp, \lbl
-#endif
-	.endm
-
 /*
  * Branch Target Identifier (BTI)
  */
 	.macro  bti, targets
 	.equ	.L__bti_targets_c, 34
-- 
2.53.0

