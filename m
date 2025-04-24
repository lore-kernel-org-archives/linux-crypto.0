Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D961433A8;
	Thu, 24 Apr 2025 00:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745454179; cv=none; b=dDD4ETk/M0r8sXqd33yCm8JClLTMHmWxNXW+OwxonmrFjTnhxQpTxR9EN1dSUlcfXlfm+88JBf7VDGbZSOmDec6IPAxK2nghFyxlUEfaFPib8nVzSDDmRZcWi1+7/4yuZ2kYOXoua/yyFj8q+jyeH4pHgKzCIO6vJ91XPuXeT6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745454179; c=relaxed/simple;
	bh=D5NU9FcmxKmWEA4XREu5in+DNWt9OzzrzEJU/bEgaCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mscfY0wLC13NOUil6K/U3aI7x+u40aT5hw30Atz498Z3+8nyNK30FHVU232keUCd/JnhCZ0rFLH1Yt2buEqJnDBkOUq/Bn9tFGB83/PEkWLbAdAOWzaAlZrm0Hu5VsdYRyDXzUdV3L+WHxk05NNQTfJnidjM1mZ7ahfmw428MDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N0PKp1HX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N0PKp1HX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EE9C4CEED;
	Thu, 24 Apr 2025 00:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745454179;
	bh=D5NU9FcmxKmWEA4XREu5in+DNWt9OzzrzEJU/bEgaCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0PKp1HXIMY3OYdi0+QNxtbOKYvHDj+XNZMJxgb4MF3xoXe6ZeLHMKvvC4RZIH4qO
	 i0tZYXuMUm/aKFnMCifDJ/wwpNleHgIV1Krt4I9CKcqPodLMBXpV3eP7n8pXsK/Mo5
	 zOthyROTuyAqdflz4JtxNSzMN7JDq7D8AlG4vAUfudwlcthNpdpeWlaHLmDi33Kj4r
	 esMpwv9MLcyTyaOA2tyQG/ZzJHP/O11zZQwSpzAmqU/eveXzTAv387y9MiAmXhGlmz
	 LZ1FdafE124aAygI+K3XM7/X220w8EaFQiwxmQTWGBs/9WqQ4wO2h8UBUZkDSsLyrn
	 kEpPI/AJpkbXQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 6/7] sparc/crc: drop "glue" from filenames
Date: Wed, 23 Apr 2025 17:20:37 -0700
Message-ID: <20250424002038.179114-7-ebiggers@kernel.org>
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
 arch/sparc/lib/Makefile                  | 2 +-
 arch/sparc/lib/{crc32_glue.c => crc32.c} | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/sparc/lib/{crc32_glue.c => crc32.c} (97%)

diff --git a/arch/sparc/lib/Makefile b/arch/sparc/lib/Makefile
index 5724d0f356eb5..ef8860eb3f3d1 100644
--- a/arch/sparc/lib/Makefile
+++ b/arch/sparc/lib/Makefile
@@ -52,6 +52,6 @@ lib-$(CONFIG_SPARC64) += mcount.o ipcsum.o xor.o hweight.o ffs.o
 
 obj-$(CONFIG_SPARC64) += iomap.o
 obj-$(CONFIG_SPARC32) += atomic32.o
 obj-$(CONFIG_SPARC64) += PeeCeeI.o
 obj-$(CONFIG_CRC32_ARCH) += crc32-sparc.o
-crc32-sparc-y := crc32_glue.o crc32c_asm.o
+crc32-sparc-y := crc32.o crc32c_asm.o
diff --git a/arch/sparc/lib/crc32_glue.c b/arch/sparc/lib/crc32.c
similarity index 97%
rename from arch/sparc/lib/crc32_glue.c
rename to arch/sparc/lib/crc32.c
index d34e7cc7e1a1e..428fd5588e936 100644
--- a/arch/sparc/lib/crc32_glue.c
+++ b/arch/sparc/lib/crc32.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
-/* Glue code for CRC32C optimized for sparc64 crypto opcodes.
+/* CRC32c (Castagnoli), sparc64 crc32c opcode accelerated
  *
  * This is based largely upon arch/x86/crypto/crc32c-intel.c
  *
  * Copyright (C) 2008 Intel Corporation
  * Authors: Austin Zhang <austin_zhang@linux.intel.com>
-- 
2.49.0

