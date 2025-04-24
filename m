Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070F22CA8;
	Thu, 24 Apr 2025 00:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745454178; cv=none; b=PaFkIuRhSFiQ+wXwAxzCFYsMWdI5DNWprRiUW+jEvM6Vy4Y+tlNLr35GL99KPclGc/e3ascXsKjcBX8G2YMvgIkfJt18VSyvpsmcnuD3UCkJLrsUJ1FSqtfJDIRhUu6hDyY4fhgpslukb+M7kvPHSBeTd1Hxv9YeLfHVsRI7/I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745454178; c=relaxed/simple;
	bh=f6qY7h7/z9HFPXtJ7uW93vPk+oRSFTdF1XATrLujF94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnjYXh9caRdjSWMgI1JshyBqPTl8iI7n4MCPj6XsAAEdebipN86/bDinAlHt9Vf143WJ5aYIzLX6jRVOaj+wnt91p9WHiFTw3F0eL6FPgpc6igOVj9z4Ke1i9Z+X2ePavTJdf3ws0VHhFvU600eNLhy4CaHGlVH9p28nTsKNuac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FGtI6i60; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGtI6i60"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA2FC4CEEA;
	Thu, 24 Apr 2025 00:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745454177;
	bh=f6qY7h7/z9HFPXtJ7uW93vPk+oRSFTdF1XATrLujF94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGtI6i60jfi/bxvrBjyZrkl3TkhvNSEysxPTGOz6UaGM8gmkSGMzhgzvxG6cSkx4I
	 IER76oYErtjvm57HPR+kvW4xbDJY3gBBtmDAx3GbteOA3X5bCfJxtdP4oWnIZg35eb
	 ovQ/1UKOZtrxFP2oaMWLLDIslp1XyosmGQAIniINOznzhAYu0wZVXys0xwjT8MpXdy
	 Xdx5pA713zOdUR53LMD0F1zwNlgTgL3FxLkHZftpvofB3xxaT0ftBfE4rME11I7H5n
	 6Kw8/d9POrLBi/0pSDx7/rhvpLc1AerJedNLcZgzxHya15q4HPa0TOx+9SfRxzrYO/
	 58NCLhKBn8IdQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 1/7] arm/crc: drop "glue" from filenames
Date: Wed, 23 Apr 2025 17:20:32 -0700
Message-ID: <20250424002038.179114-2-ebiggers@kernel.org>
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
 arch/arm/lib/Makefile                            | 4 ++--
 arch/arm/lib/{crc-t10dif-glue.c => crc-t10dif.c} | 0
 arch/arm/lib/{crc32-glue.c => crc32.c}           | 0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/arm/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
 rename arch/arm/lib/{crc32-glue.c => crc32.c} (100%)

diff --git a/arch/arm/lib/Makefile b/arch/arm/lib/Makefile
index 007874320937d..d05dd672bcd9c 100644
--- a/arch/arm/lib/Makefile
+++ b/arch/arm/lib/Makefile
@@ -45,9 +45,9 @@ ifeq ($(CONFIG_KERNEL_MODE_NEON),y)
 endif
 
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 
 obj-$(CONFIG_CRC32_ARCH) += crc32-arm.o
-crc32-arm-y := crc32-glue.o crc32-core.o
+crc32-arm-y := crc32.o crc32-core.o
 
 obj-$(CONFIG_CRC_T10DIF_ARCH) += crc-t10dif-arm.o
-crc-t10dif-arm-y := crc-t10dif-glue.o crc-t10dif-core.o
+crc-t10dif-arm-y := crc-t10dif.o crc-t10dif-core.o
diff --git a/arch/arm/lib/crc-t10dif-glue.c b/arch/arm/lib/crc-t10dif.c
similarity index 100%
rename from arch/arm/lib/crc-t10dif-glue.c
rename to arch/arm/lib/crc-t10dif.c
diff --git a/arch/arm/lib/crc32-glue.c b/arch/arm/lib/crc32.c
similarity index 100%
rename from arch/arm/lib/crc32-glue.c
rename to arch/arm/lib/crc32.c
-- 
2.49.0

