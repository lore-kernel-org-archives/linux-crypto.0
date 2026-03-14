Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715EE324718;
	Sat, 14 Mar 2026 17:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773511124; cv=none; b=DwJXwyPeKWLIMmvnp5LF1p71BDV70EUUPo9PoUQHuxvxvBClHFnAQJLVlpwg3EoYoosUMTHTEAQ+3Co9iaRv5grgTCMtD5iLRaMYgwBufOisMUqCKmvq6GYJTBSmC80TUjaCIWdQT948t/PgrJChBiCDyknc8mQdJnN7StK4yW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773511124; c=relaxed/simple;
	bh=LywMY+JgQOoqvYnuILk1SbJlfvjgB43wfskpy5/iCeY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hf1f5E7G+bCF3XZoLc+N0eAQs1Ch+Ldb7A+mRE/DkOjHiaUaZkeJpksXkeelfVPZ6y2qntQlDppWYHB8cQoCacV8IrJAV+ZV9+SBf1suWQ29OByVlmVmXA/klqhTW5/xZeUraqPuK9tjSGXKECnPfioP9X8JpgdSKbUz9+QmwG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gOLq+2bS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gOLq+2bS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AA5C116C6;
	Sat, 14 Mar 2026 17:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773511124;
	bh=LywMY+JgQOoqvYnuILk1SbJlfvjgB43wfskpy5/iCeY=;
	h=From:To:Cc:Subject:Date:From;
	b=gOLq+2bSXKngpGELKWOh6uHJ9c4pUOvNi0cSGD3XfMSTZ/3u9CYQbpx6oG8EPQCu0
	 TSA2T/gyOITQi8r8D/E5l9/L1GYzN+LfGpqeZ/2WDMFiTW1c9+ngWYar3MNVg5fXO7
	 0ZJ/1OeL6huFICS7aBOYxnz/f5wgKxB2pvJhTTyboGEmOotpHK1/AJrAxnDdMwjXwF
	 WrUwbM+ISlcuiMpf3nS6GggTKwpyLlvWsv78JG5sU/xnM7wKMz0l21WU/rdPSx7Ntx
	 ETf9zel+3CRcSBQVP679j8o/zYf8KGW4LXlyz0OYgkEiNHOVsn4uJrxTJLW+XXqgCk
	 D5Enco2E+Ks2A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crc: arm64: Drop check for CONFIG_KERNEL_MODE_NEON
Date: Sat, 14 Mar 2026 10:57:44 -0700
Message-ID: <20260314175744.30620-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CONFIG_KERNEL_MODE_NEON is always enabled on arm64, and it always has
been since its introduction in 2013.  Given that and the fact that the
usefulness of kernel-mode NEON has only been increasing over time,
checking for this option in arm64-specific code is unnecessary.  Remove
this check from lib/crc/ to simplify the code and prevent any future
bugs where e.g. code gets disabled due to a typo in this logic.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting crc-next
(https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next)

 lib/crc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
index cca228879bb5a..52e216f397468 100644
--- a/lib/crc/Kconfig
+++ b/lib/crc/Kconfig
@@ -46,11 +46,11 @@ config CRC_T10DIF
 
 config CRC_T10DIF_ARCH
 	bool
 	depends on CRC_T10DIF && CRC_OPTIMIZATIONS
 	default y if ARM && KERNEL_MODE_NEON
-	default y if ARM64 && KERNEL_MODE_NEON
+	default y if ARM64
 	default y if PPC64 && ALTIVEC
 	default y if RISCV && RISCV_ISA_ZBC
 	default y if X86
 
 config CRC32

base-commit: c13cee2fc7f137dd25ed50c63eddcc578624f204
-- 
2.53.0

