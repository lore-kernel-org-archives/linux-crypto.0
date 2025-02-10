Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A1324CEC7;
	Mon, 10 Feb 2025 21:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739221708; cv=none; b=naCA5Jmv8c/p0nCKraWekPCswU4P7RKR69BziSwGqkE+5E7jhfEzGLbDmXC7QHwKFHkNqbd9TtYyGOUBHwZ/TEkYQ/3Fo8CjRAltTmF7uV+cpWsYX5sIoKc1Fx8pjHNTiLeHjBebClw+PNn6rwjIxbZ8Qf5LNk0Od0c81GQh9T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739221708; c=relaxed/simple;
	bh=nsxZH2SZD6vTc8N+B/oWNv6Vdg6Hj3DHXRV3PAe46vc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t1cGc8Z7dL+xa8L6SZTuJyIOdlNjOKrRSoG0CLaORhzgrx+mPza1BsaBxY1UjIAGAqtwIh7IxOArkbeilT2H1Ii5h4VUiCCTQz44o8Thvn1SQomMnKNCmVstuZqoHqPQ/tesjWITVdEtNv+PUOQi7h3uLBG9v3ReHelanydJo9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UQtgnRH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UQtgnRH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50B32C4CEE4;
	Mon, 10 Feb 2025 21:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739221707;
	bh=nsxZH2SZD6vTc8N+B/oWNv6Vdg6Hj3DHXRV3PAe46vc=;
	h=From:To:Cc:Subject:Date:From;
	b=UQtgnRH4s3CKHz0SHD0M++eehUkq5UNPt97T4BeUpbmE3vLVZqrXHLXfm6wy8iNZC
	 eHlLZIjxQwFBigwE3R5PqYoc1pe3yX4xtA7IT4ZbxPsH4tAknXuS0gKQyJIgKGx7xK
	 zy0QzY93cWOQvfho26u/SuLqzHJ5ixymGtU8zPR44rcA0A4VGqUaE6Uo/SXJtorziW
	 cxJxnZXuOwmukbGyT6maLmG/d0W2VNQwF/0Z27vrRs+WVVYiMB8MRQyed+9al2PEii
	 7lo5z3qjwX2COVChdsBr7EbiHlJrpRXHKlZ+sYLGBNZ3QMQCuxqZyVSaWCEyx1JBlb
	 xHkGj8a1cKAkg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	x86@kernel.org
Subject: [PATCH] x86/crc32: improve crc32c_arch() code generation with clang
Date: Mon, 10 Feb 2025 13:07:41 -0800
Message-ID: <20250210210741.471725-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

crc32c_arch() is affected by
https://github.com/llvm/llvm-project/issues/20571 where clang
unnecessarily spills the inputs to "rm"-constrained operands to the
stack.  Replace "rm" with ASM_INPUT_RM which partially works around this
by expanding to "r" when the compiler is clang.  This results in better
code generation with clang, though still not optimal.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---

This applies to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

 arch/x86/lib/crc32-glue.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/crc32-glue.c b/arch/x86/lib/crc32-glue.c
index 9c3f9c1b7bb9..4b4721176799 100644
--- a/arch/x86/lib/crc32-glue.c
+++ b/arch/x86/lib/crc32-glue.c
@@ -53,14 +53,14 @@ u32 crc32c_arch(u32 crc, const u8 *p, size_t len)
 		return crc;
 	}
 
 	for (num_longs = len / sizeof(unsigned long);
 	     num_longs != 0; num_longs--, p += sizeof(unsigned long))
-		asm(CRC32_INST : "+r" (crc) : "rm" (*(unsigned long *)p));
+		asm(CRC32_INST : "+r" (crc) : ASM_INPUT_RM (*(unsigned long *)p));
 
 	for (len %= sizeof(unsigned long); len; len--, p++)
-		asm("crc32b %1, %0" : "+r" (crc) : "rm" (*p));
+		asm("crc32b %1, %0" : "+r" (crc) : ASM_INPUT_RM (*p));
 
 	return crc;
 }
 EXPORT_SYMBOL(crc32c_arch);
 

base-commit: 4ffd50862d41e5aaf2e749efa354afaa1317c309
-- 
2.48.1

