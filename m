Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B54829D0E;
	Sat,  8 Feb 2025 02:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738982963; cv=none; b=ZVA5/bYjd8mhaqrhayW6hC8rF8oJoDipz9Tv5fmTjmHp8ss2KPfzjQWQuxqY3+/Is+fBwaI+/TGaTfJ1+/tfA76CDaVgJ0DGAgBoTwlVMVB78O4oz6zcf4OdFudYUgnHF1NVbefiQCu13jHH2dwAN4uoUxlGS74o5gxMQ9Sppf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738982963; c=relaxed/simple;
	bh=CcbjCnOKgUgi0bXsM96+1hSnj0FEL/khYEZSB2AazeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5hKP34P8QojSiF/f3+xaFwRY3/QwduS/g8M5GTSTYNmVp3d6Srlc2dID1/hYjL6+NMeFTsEscIZd2I1F8Pg/zE2CMdfuQenaA6kXixcwp+fxH3/FQTJZXntZQI52s2O8XoMFni3QqmwkuNLXs5C5eYA5iXx4eMgi5KygjdJEq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XHzXWgiG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XHzXWgiG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9BDFC4CED6;
	Sat,  8 Feb 2025 02:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738982963;
	bh=CcbjCnOKgUgi0bXsM96+1hSnj0FEL/khYEZSB2AazeA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHzXWgiGWT7/za6es3R66EVIPwn7nolhuIKqtLFEU/Qbkraq/6to5kCTx9rzNMRk9
	 82b+gAYRg+uSrzQSKVvghqziDRXD9KZ4X1rj3TI4nOOXuioQ/G8lFSFGUDg+U7Qwb+
	 aVIsqlfkLQ4eY099lMOtwYLJH6D/SxAvbTNbFqhNGXKMAQA+vrKBXMY8qWSLIEnJZ2
	 zYHAjd3uOi0TDKo6+Udr/uSyVg5yh7qEvY8pBsqvDKg93K96S3toNpZ27LRnPIiGWA
	 YA+Xtf9hYotEJpMPEQf4DTKz7gdmGhHkjWckziniERjljpc9J92nqcSPyAqNsFH9U3
	 L/OJUkpzLOGiA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2 1/6] mips/crc32: remove unused enums
Date: Fri,  7 Feb 2025 18:49:06 -0800
Message-ID: <20250208024911.14936-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250208024911.14936-1-ebiggers@kernel.org>
References: <20250208024911.14936-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Remove enum crc_op_size and enum crc_type, since they are never actually
used.  Tokens with the names of the enum values do appear in the file,
but they are only used for token concatenation with the preprocessor.

This prevents a conflict with the addition of crc32c() to linux/crc32.h.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/r/20250207224233.GA1261167@ax162
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/mips/lib/crc32-mips.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/mips/lib/crc32-mips.c b/arch/mips/lib/crc32-mips.c
index 083e5d693a169..100ac586aadb2 100644
--- a/arch/mips/lib/crc32-mips.c
+++ b/arch/mips/lib/crc32-mips.c
@@ -14,19 +14,10 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <asm/mipsregs.h>
 #include <linux/unaligned.h>
 
-enum crc_op_size {
-	b, h, w, d,
-};
-
-enum crc_type {
-	crc32,
-	crc32c,
-};
-
 #ifndef TOOLCHAIN_SUPPORTS_CRC
 #define _ASM_SET_CRC(OP, SZ, TYPE)					  \
 _ASM_MACRO_3R(OP, rt, rs, rt2,						  \
 	".ifnc	\\rt, \\rt2\n\t"					  \
 	".error	\"invalid operands \\\"" #OP " \\rt,\\rs,\\rt2\\\"\"\n\t" \
-- 
2.48.1

