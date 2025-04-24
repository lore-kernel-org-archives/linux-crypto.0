Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AEA78F2D;
	Thu, 24 Apr 2025 00:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745454180; cv=none; b=G+t/1uogNJljhex/Z7gGdUhNPl6t182wjBXxUorUrnZ+HOb68wnDOtpz7gkYeJ0yOkac25CToRz5PcdFR07YJBrSj8CNGuSLl87AoAuWq+tuAqG2743R7usqW0nrelIYq8MwCQlHIOIo++AxzLRXWOBkwZwVookjyy0bOR1iZU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745454180; c=relaxed/simple;
	bh=fLNBgB98VHmWsYsqCxuP82EHevhaDk2EjXMCqMw0UcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klhQCB1Ea9FR1DH0z/Tnz0B77EsK2Mu3FdZt1ouamklPJ1wsEN+fc50tmNq5KPvvsju9myZercirHVRuo4RLykY5vC/RROkYzWo+4kw8j1l8cCo17s1vuVM9mL9JYQ94kZdwgmzaaZuFDIPJ8oKHWosFQQpyD7aOjs7ahFuQDiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aWvr/EPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aWvr/EPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8228FC4CEEA;
	Thu, 24 Apr 2025 00:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745454179;
	bh=fLNBgB98VHmWsYsqCxuP82EHevhaDk2EjXMCqMw0UcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWvr/EPcncCLXclOTaLe63YVgnOiy+N9wim0CGWVLG5JPWdao8sIiUrgqjP211Og9
	 jPYSkEqI/LubFLgHvX/Bs8rYkIWlBfokdgGAg1NEnskSiGSHt3Nm6+IstDdT6KUUvq
	 fdgzd3OQesUexCmrJKlCoN1f3jVyfzH1CNy4mmnAHvwpQ8eDpRo/vD+7tBTlGf9Gc4
	 RK+zxG9iJwmrLDceJAjix6paW6sEefqykYt7k4iVglMQp+Eo40VZan/De8XZf8qqM3
	 LewXnECsVB/HbYP2Cod7GN060YdqJlgseAaFPHHRZF7MctsFoP+9elJbTKHFnqXqzI
	 quzBIIJ3wXqLQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 7/7] x86/crc: drop "glue" from filenames
Date: Wed, 23 Apr 2025 17:20:38 -0700
Message-ID: <20250424002038.179114-8-ebiggers@kernel.org>
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
 arch/x86/lib/Makefile                            | 6 +++---
 arch/x86/lib/{crc-t10dif-glue.c => crc-t10dif.c} | 0
 arch/x86/lib/{crc32-glue.c => crc32.c}           | 0
 arch/x86/lib/{crc64-glue.c => crc64.c}           | 0
 4 files changed, 3 insertions(+), 3 deletions(-)
 rename arch/x86/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
 rename arch/x86/lib/{crc32-glue.c => crc32.c} (100%)
 rename arch/x86/lib/{crc64-glue.c => crc64.c} (100%)

diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 1c50352eb49f9..7cf8681cba0f2 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -37,18 +37,18 @@ lib-$(CONFIG_INSTRUCTION_DECODER) += insn.o inat.o insn-eval.o
 lib-$(CONFIG_RANDOMIZE_BASE) += kaslr.o
 lib-$(CONFIG_FUNCTION_ERROR_INJECTION)	+= error-inject.o
 lib-$(CONFIG_MITIGATION_RETPOLINE) += retpoline.o
 
 obj-$(CONFIG_CRC32_ARCH) += crc32-x86.o
-crc32-x86-y := crc32-glue.o crc32-pclmul.o
+crc32-x86-y := crc32.o crc32-pclmul.o
 crc32-x86-$(CONFIG_64BIT) += crc32c-3way.o
 
 obj-$(CONFIG_CRC64_ARCH) += crc64-x86.o
-crc64-x86-y := crc64-glue.o crc64-pclmul.o
+crc64-x86-y := crc64.o crc64-pclmul.o
 
 obj-$(CONFIG_CRC_T10DIF_ARCH) += crc-t10dif-x86.o
-crc-t10dif-x86-y := crc-t10dif-glue.o crc16-msb-pclmul.o
+crc-t10dif-x86-y := crc-t10dif.o crc16-msb-pclmul.o
 
 obj-y += msr.o msr-reg.o msr-reg-export.o hweight.o
 obj-y += iomem.o
 
 ifeq ($(CONFIG_X86_32),y)
diff --git a/arch/x86/lib/crc-t10dif-glue.c b/arch/x86/lib/crc-t10dif.c
similarity index 100%
rename from arch/x86/lib/crc-t10dif-glue.c
rename to arch/x86/lib/crc-t10dif.c
diff --git a/arch/x86/lib/crc32-glue.c b/arch/x86/lib/crc32.c
similarity index 100%
rename from arch/x86/lib/crc32-glue.c
rename to arch/x86/lib/crc32.c
diff --git a/arch/x86/lib/crc64-glue.c b/arch/x86/lib/crc64.c
similarity index 100%
rename from arch/x86/lib/crc64-glue.c
rename to arch/x86/lib/crc64.c
-- 
2.49.0

