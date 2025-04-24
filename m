Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEB31E51D;
	Thu, 24 Apr 2025 00:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745454179; cv=none; b=i2ehtGpkXXyn9MUcy0S4MkUh8OgZfQV0GdRENseAX8ObmyxJaskBEY1TUhOHe1w1ixEP/TnihFtegizD5XVl8CHtCNXbQvGnQGJBUmgfvY/D4034Wsx1bDTqDLQ15aLisH0q4UJC2xsjldLW0k+a0FEmG8mKsn8hd1apVePd8aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745454179; c=relaxed/simple;
	bh=Up5/ryL8wH2Q6sqbHVYBM9bv82MTpfPmfOyPPhXlSTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhqrQYE9Hcdb+OigXeZsLtV0lV05k/xwCo9lKvChgqv/lR8aIavGKy43GMFeHvOHG6ZZnE+JSIEI1m4x6ooumd+ixjcd9Uq5qsqc7a+emngCgEfRw65WgZOSthQ3OeXwZpgOF6xDrq143WYpPaX7DM+ZvBDYraMGaUAwMPzyQpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=meb78kAZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="meb78kAZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF59C4CEE3;
	Thu, 24 Apr 2025 00:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745454178;
	bh=Up5/ryL8wH2Q6sqbHVYBM9bv82MTpfPmfOyPPhXlSTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meb78kAZg/xXyofHK642o1nJilPUui1hWwQEiQcEAZp40YHq2X+2iFfOzuUmsuRi9
	 /3ffaGxEzDvJ+4CHOJL+uBQ6odaBfJuVxNhw+2MXAr0Jao1aTTVF7+CDM6Gu3kNc07
	 vdQ9diSFeZab1xfjE/0X2hR44LA7XGtyI1qsuafq+uRffibBIzSfwGVpBw5TVJuua4
	 QgDLXyUF11mB8KnDES3NoRHYmKLy5TeQMZ0GiXqGkPLwGhx+ngG1whg8WzeDDc1h8e
	 f0SpLtEG+ndGMrAYamUBqpo63QNSFe8fTHJQErtouHSb8QV8aPD+YkoTsNTHdQ52uw
	 CRjoZgSmWkOWQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 3/7] powerpc/crc: drop "glue" from filenames
Date: Wed, 23 Apr 2025 17:20:34 -0700
Message-ID: <20250424002038.179114-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250424002038.179114-1-ebiggers@kernel.org>
References: <20250424002038.179114-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

The use of the term "glue" in filenames is a Crypto API-ism that rarely
shows up elsewhere in lib/ or arch/*/lib/.  I think adopting it there
was a mistake.  The library just uses standard functions, so the amount
of code that could be considered "glue" is quite small.  And while often
the C functions just wrap the assembly functions, there are also cases
like crc32c_arch() in arch/x86/lib/crc32-glue.c that blur the line by
in-lining the actual implementation into the C function.  That's not
"glue code", but rather the actual code.

Therefore, let's drop "glue" from the filenames and instead use e.g.
crc32.c instead of crc32-glue.c.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/powerpc/lib/Makefile                            | 4 ++--
 arch/powerpc/lib/{crc-t10dif-glue.c => crc-t10dif.c} | 0
 arch/powerpc/lib/{crc32-glue.c => crc32.c}           | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/powerpc/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
 rename arch/powerpc/lib/{crc32-glue.c => crc32.c} (100%)

diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index dd8a4b52a0ccb..27f8a01438603 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -77,11 +77,11 @@ obj-$(CONFIG_ALTIVEC)	+= xor_vmx.o xor_vmx_glue.o
 CFLAGS_xor_vmx.o += -mhard-float -maltivec $(call cc-option,-mabi=altivec)
 # Enable <altivec.h>
 CFLAGS_xor_vmx.o += -isystem $(shell $(CC) -print-file-name=include)
 
 obj-$(CONFIG_CRC32_ARCH) += crc32-powerpc.o
-crc32-powerpc-y := crc32-glue.o crc32c-vpmsum_asm.o
+crc32-powerpc-y := crc32.o crc32c-vpmsum_asm.o
 
 obj-$(CONFIG_CRC_T10DIF_ARCH) += crc-t10dif-powerpc.o
-crc-t10dif-powerpc-y := crc-t10dif-glue.o crct10dif-vpmsum_asm.o
+crc-t10dif-powerpc-y := crc-t10dif.o crct10dif-vpmsum_asm.o
 
 obj-$(CONFIG_PPC64) += $(obj64-y)
diff --git a/arch/powerpc/lib/crc-t10dif-glue.c b/arch/powerpc/lib/crc-t10dif.c
similarity index 100%
rename from arch/powerpc/lib/crc-t10dif-glue.c
rename to arch/powerpc/lib/crc-t10dif.c
diff --git a/arch/powerpc/lib/crc32-glue.c b/arch/powerpc/lib/crc32.c
similarity index 100%
rename from arch/powerpc/lib/crc32-glue.c
rename to arch/powerpc/lib/crc32.c
-- 
2.49.0

