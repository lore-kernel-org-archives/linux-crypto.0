Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1E51879
	for <linux-crypto@vger.kernel.org>; Sat,  6 Apr 2024 00:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712363286; cv=none; b=HtPIhaKEty311i7eXGut3d3Prm4MmHGXfEKRLXly5f/Ke9DEMIwolwaNDZ+OdU4hCacwdKOnbprfDuZrBx+Clkp1fBxUDPffWr5XQtwTOlcUrSXVgNL95+cZb1Tb+5NjBFyMA6+vpnj6Wudbsp8wiBu2Y0ZMI7qnysnFhqGirAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712363286; c=relaxed/simple;
	bh=IK2GT9BV3++m+qSw9PNeNHZP43zJpPO86nVMwRDr8+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+LImcbRk3a9RbG7jV/0gZNTdAucBOZ9qI1WKB2+gemysxXgfw6VCbtSZU6Ti4QabDdCCMNwvgt/T+APqGs+lEEG8/DXxHxKBActtZIWSK56ZhsoUSCEQSoJtO/+qe3l/mdLWSH3pLRyt5QzkHwt+ZLrcFw7uAD5qYJp8irbhpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YR23UDKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YR23UDKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A3EC43399;
	Sat,  6 Apr 2024 00:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712363286;
	bh=IK2GT9BV3++m+qSw9PNeNHZP43zJpPO86nVMwRDr8+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YR23UDKd99WMDqwJL9gOdPjj+GlLnXewTH1UHaINs5ihpRKQNdXhlnpjXpgjvQtjg
	 EUCFiADFJMp0OAUPaJI2ikM33Mlv4iUHlMnpSif7mrVSIKkoyNATQPxuDH1xs3cDA6
	 H2KgH/wgT0IzWtgxNaw0oSLqZ4lDUAhbYWZReGrRNpNCDB/6feV37/5veWlPZGLuFS
	 LndCkRgWV6TvbvEqBA7OkC+/7g1HrgFhDmZJQ+m4h8tufZ8EhAbat0d7u4RgCzwTiC
	 OLmM0WAJIGcZMAZtOzBPF1ViHweeB93LMPCNHP0uzJ04kx0xhTG8i5IKZhq3Tar2/B
	 GJSTSmEKSlj/A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: x86@kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: [PATCH 2/3] crypto: x86/sha256-avx2 - add missing vzeroupper
Date: Fri,  5 Apr 2024 20:26:09 -0400
Message-ID: <20240406002610.37202-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240406002610.37202-1-ebiggers@kernel.org>
References: <20240406002610.37202-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since sha256_transform_rorx() uses ymm registers, execute vzeroupper
before returning from it.  This is necessary to avoid reducing the
performance of SSE code.

Fixes: d34a460092d8 ("crypto: sha256 - Optimized sha256 x86_64 routine using AVX2's RORX instructions")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/sha256-avx2-asm.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
index 9918212faf91..0ffb072be956 100644
--- a/arch/x86/crypto/sha256-avx2-asm.S
+++ b/arch/x86/crypto/sha256-avx2-asm.S
@@ -714,10 +714,11 @@ SYM_TYPED_FUNC_START(sha256_transform_rorx)
 	popq	%r15
 	popq	%r14
 	popq	%r13
 	popq	%r12
 	popq	%rbx
+	vzeroupper
 	RET
 SYM_FUNC_END(sha256_transform_rorx)
 
 .section	.rodata.cst512.K256, "aM", @progbits, 512
 .align 64
-- 
2.44.0

