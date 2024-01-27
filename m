Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5FA7F;
	Sat, 27 Jan 2024 09:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706346084; cv=none; b=d0hwB7fXPiWNHCVRpklKI3/tICWf+EdBopwaNkYg4DMH9SSbTwgOjEecP02zY++Gn5c1WtMFtWW6WV0OKRGGGf8S92PAedxyDb6ki0obBx/2xL0f/GvpySybYuIGlheG0O505TqslwY4Fbnilz0PYZSyaW9VtQC8Y64/QOrwvH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706346084; c=relaxed/simple;
	bh=hpNFNF09+4R9C/NT6J2wtQJfi2pvjGg8peeFOWYXxjU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EGMxw4f1VmpcWHIlBTijqgYuQkQW8mp1cudzArBhm6gijuv6Rma5u6Pl3AqNN/C/g7aBa5AaoDDA/GbmOuwKxysEZTyKPgsP1BAnQ4P/cIBANQnomGG7S4N4y7Vr75Q5IxqbxSEvRJuLPdS6aqDALQTSem8YMkhA3/+nnCPP72o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H68dCSkY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H68dCSkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BCAC433F1;
	Sat, 27 Jan 2024 09:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706346083;
	bh=hpNFNF09+4R9C/NT6J2wtQJfi2pvjGg8peeFOWYXxjU=;
	h=From:To:Cc:Subject:Date:From;
	b=H68dCSkYteFymi0Fxr4ZLnTtDfhc3iBgtp7a90RfidyQYu69r1r6CihH13IS38xKA
	 7Y6lvWBv2gcFEyLZ7+znoLsJ18B01ysbSi7TqxpUNXJDjWLhRejbBDgMlFauFXh4ho
	 PgX1lKteFbkEBIRK/boTZP8jxy8/KPzdwQ8qfbuK5SkmfjbayN6IDNPQrhOI0VvkMJ
	 NGevEz43xgBNX1hKceUzic8Bw2t3RuDqq3ZNOQxH75u0u5SfE8UY/gIOE4ozUeGeuB
	 LszLbDcljUQ2hOZ4ZAmeCkoYlvD5m4F4pw116jSOeoKtfeSDfZIdObP++x9JedU1FS
	 k2tgGoKo1zjrQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-riscv@lists.infradead.org
Cc: linux-crypto@vger.kernel.org,
	llvm@lists.linux.dev,
	Brandon Wu <brandon.wu@sifive.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] RISC-V: fix check for zvkb with tip-of-tree clang
Date: Sat, 27 Jan 2024 01:00:54 -0800
Message-ID: <20240127090055.124336-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

LLVM commit 8e01042da9d3 ("[RISCV] Add missing dependency check for Zvkb
(#79467)") broke the check used by the TOOLCHAIN_HAS_VECTOR_CRYPTO
kconfig symbol because it made zvkb start depending on v or zve*.  Fix
this by specifying both v and zvkb when checking for support for zvkb.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index b49016bb5077b..912fff31492b9 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -581,21 +581,21 @@ config TOOLCHAIN_HAS_ZBB
 	default y
 	depends on !64BIT || $(cc-option,-mabi=lp64 -march=rv64ima_zbb)
 	depends on !32BIT || $(cc-option,-mabi=ilp32 -march=rv32ima_zbb)
 	depends on LLD_VERSION >= 150000 || LD_VERSION >= 23900
 	depends on AS_HAS_OPTION_ARCH
 
 # This symbol indicates that the toolchain supports all v1.0 vector crypto
 # extensions, including Zvk*, Zvbb, and Zvbc.  LLVM added all of these at once.
 # binutils added all except Zvkb, then added Zvkb.  So we just check for Zvkb.
 config TOOLCHAIN_HAS_VECTOR_CRYPTO
-	def_bool $(as-instr, .option arch$(comma) +zvkb)
+	def_bool $(as-instr, .option arch$(comma) +v$(comma) +zvkb)
 	depends on AS_HAS_OPTION_ARCH
 
 config RISCV_ISA_ZBB
 	bool "Zbb extension support for bit manipulation instructions"
 	depends on TOOLCHAIN_HAS_ZBB
 	depends on MMU
 	depends on RISCV_ALTERNATIVE
 	default y
 	help
 	   Adds support to dynamically detect the presence of the ZBB

base-commit: cb4ede926134a65bc3bf90ed58dace8451d7e759
-- 
2.43.0

