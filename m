Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DB72AE6D;
	Thu, 12 Jun 2025 05:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749707264; cv=none; b=Sw2InG4sY6EA4YrMP6z5bi5NoXWBxvY1NQUKKi7moVXijPqdZ7UoBBg2uoBuDiHBRS39lp5ZxUWSHpLE0wliXVZrtk9VcWs/sI3bKoERlpClPZeF72TDJnU7ZsYJNYLzDCzwcWzi//gDFtY7+KwG55s7lf6KKtisOyf8mSFh0J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749707264; c=relaxed/simple;
	bh=bpBqj2lArlhtrojMCZjnpyUXmwKWEvp6eVmI7nnSBvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jOR3ass9NQcU1OFVK/Zlb2oault4Fo7/kpY7wqAsMeDG/jUQMzpzn+w6VFqWDTxly88QusTsME+YOjwOXAXsfYEfAxjgGKaFeBlx1DRWOFGvrdgL5qqWI5QsGN/4bEYP1jVpdOY4WU1dlW0T1XrFLLGlRe1LC/HQTpCoU+nScKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAgfC+6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAgfC+6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0758C4CEEA;
	Thu, 12 Jun 2025 05:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749707264;
	bh=bpBqj2lArlhtrojMCZjnpyUXmwKWEvp6eVmI7nnSBvo=;
	h=From:To:Cc:Subject:Date:From;
	b=TAgfC+6Cn7HPhSDeiiCI+B08BTYx2qMHEqbqAXFwVGE4onY/q5jmIiHNKKqcbU6HR
	 /u4C4WH9gMbg/oswsb8h8r40m78/w6BEx0c1QJwqMC8shZzXNBPxJyOTRJxo5v6V8R
	 2eYr9714oUlSpJW6xP3tk/acKsYFPmbd9uHcBGZvmz8h3Gzypolw9El9op7Fbl8H2J
	 xEGns+jl7TsgHMpwdBDEhJqhWH510lOhkUVM17b6kGWOBhUpDDFF6/cVBU3yaRUUu5
	 6z45L3fp2HLK81VnYbE3dtLAXXFdDxWccqZLW0y6OZFh3FevrtQe6XIxZTS0P5FyA+
	 gw7iXh9IlVFrQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld " <Jason@zx2c4.com>,
	x86@kernel.org
Subject: [PATCH] lib/crc: re-disable optimized CRC code on user-mode Linux
Date: Wed, 11 Jun 2025 22:45:14 -0700
Message-ID: <20250612054514.142728-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The reorganization of lib/crc/ unintentionally enabled the x86-optimized
CRC64 code on user-mode Linux.  (It's enabled when CONFIG_X86_64, which
is set by arch/x86/um/Kconfig.  Note that this is a different option
from the "normal" CONFIG_X86_64 which is defined in arch/x86/Kconfig.)
Since this is not being taken into account, a build error results:

    CC      lib/crc/crc64-main.o
    cc1: error: ./lib/crc/um: No such file or directory [-Werror=missing-include-dirs]
    lib/crc/crc64-main.c:58:10: fatal error: crc64.h: No such file or directory
       58 | #include "crc64.h" /* $(SRCARCH)/crc64.h */
          |          ^~~~~~~~~
    compilation terminated.
    cc1: all warnings being treated as errors

Fix this by re-disabling the optimized CRC code on user-mode Linux.

Fixes: e2fd1883971d ("lib/crc: prepare for arch-optimized code in subdirs of lib/crc/")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 lib/crc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/crc/Kconfig b/lib/crc/Kconfig
index 5858b3acc6630..70e7a6016de32 100644
--- a/lib/crc/Kconfig
+++ b/lib/crc/Kconfig
@@ -85,10 +85,11 @@ config CRC64_ARCH
 	default y if RISCV && RISCV_ISA_ZBC && 64BIT
 	default y if X86_64
 
 config CRC_OPTIMIZATIONS
 	bool "Enable optimized CRC implementations" if EXPERT
+	depends on !UML
 	default y
 	help
 	  Disabling this option reduces code size slightly by disabling the
 	  architecture-optimized implementations of any CRC variants that are
 	  enabled.  CRC checksumming performance may get much slower.

base-commit: 7234baeec076d4c2ac05d160ed8cdb2f2d033069
-- 
2.49.0

