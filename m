Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0B43FF1;
	Thu, 24 Apr 2025 00:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745454178; cv=none; b=YCGx62jgcQ4MKZ7oN2oehzrd9RtiAKF2OPRBXA/X5/VmeeccIjZCTfAhEvjaFFx5FOetOJrvcTQCL902vktthjPIsy3n3nL4Cdy1IkMdrB18ZyHmqdPT3xLnWrI/6BKj3xDVxcOgz2MGstPOBt9+tkjYbsFKhjz1voZx2JhsRxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745454178; c=relaxed/simple;
	bh=ZFBOXAIbORWsFAkzzgFaWt+AYhGJY5943TVvjBEK2bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJ554XgFwKMeZ1qR4P5/3/FecPP2wImOgAG9szTsTtOKy5SzkfIlR9uii1oE1vRrErRew8f2lZL+pKEwOnbDaJIJJ6ZPJc9r43pNbJy8A0ExQwGeTyPbnsbBfGHR8EDmtPWu2nxW7hSh9PYtY5WOpBuOicf8y7zhbZUgvUN0Jus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZFdXsDN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZFdXsDN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7537C4CEEF;
	Thu, 24 Apr 2025 00:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745454177;
	bh=ZFBOXAIbORWsFAkzzgFaWt+AYhGJY5943TVvjBEK2bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZFdXsDNHKDVjYnFQcjwii87znh/fjcZYuk8V0+Dilis2HhxXx5CUtgSKZ8IIhVJY
	 uC4QZdK4HYKw+UdierpVnbqCT9PnW2AHOK0qjhITnQQ6HbRWqKY9+lVEnfUMoW/pQI
	 VcxJj1XLtYkfjcP1TKjYXDDOwVzx27aq6ui14XTc5el7CuZ3ltvh5vxjRhtmEnlHfU
	 sozbTANfyT9UNJhMA8vB/sk61/Z8le4TuYgx3kgj4SRGHo6Mij4yQZK42dQASUypxE
	 kI9LQfRwMoLgojv4Km69eD4kAOuH7ZHsbQbibujuJFHHQZuB5UM0QikYsgdEEKK6uU
	 Af2BDEoPXC6pw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 2/7] arm64/crc: drop "glue" from filenames
Date: Wed, 23 Apr 2025 17:20:33 -0700
Message-ID: <20250424002038.179114-3-ebiggers@kernel.org>
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
 arch/arm64/lib/Makefile                            | 4 ++--
 arch/arm64/lib/{crc-t10dif-glue.c => crc-t10dif.c} | 0
 arch/arm64/lib/{crc32.S => crc32-core.S}           | 0
 arch/arm64/lib/{crc32-glue.c => crc32.c}           | 0
 4 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/arm64/lib/{crc-t10dif-glue.c => crc-t10dif.c} (100%)
 rename arch/arm64/lib/{crc32.S => crc32-core.S} (100%)
 rename arch/arm64/lib/{crc32-glue.c => crc32.c} (100%)

diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 4d49dff721a84..d97e290619bc5 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -12,14 +12,14 @@ CFLAGS_REMOVE_xor-neon.o	+= $(CC_FLAGS_NO_FPU)
 endif
 
 lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
 
 obj-$(CONFIG_CRC32_ARCH) += crc32-arm64.o
-crc32-arm64-y := crc32.o crc32-glue.o
+crc32-arm64-y := crc32.o crc32-core.o
 
 obj-$(CONFIG_CRC_T10DIF_ARCH) += crc-t10dif-arm64.o
-crc-t10dif-arm64-y := crc-t10dif-glue.o crc-t10dif-core.o
+crc-t10dif-arm64-y := crc-t10dif.o crc-t10dif-core.o
 
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 
 obj-$(CONFIG_ARM64_MTE) += mte.o
 
diff --git a/arch/arm64/lib/crc-t10dif-glue.c b/arch/arm64/lib/crc-t10dif.c
similarity index 100%
rename from arch/arm64/lib/crc-t10dif-glue.c
rename to arch/arm64/lib/crc-t10dif.c
diff --git a/arch/arm64/lib/crc32.S b/arch/arm64/lib/crc32-core.S
similarity index 100%
rename from arch/arm64/lib/crc32.S
rename to arch/arm64/lib/crc32-core.S
diff --git a/arch/arm64/lib/crc32-glue.c b/arch/arm64/lib/crc32.c
similarity index 100%
rename from arch/arm64/lib/crc32-glue.c
rename to arch/arm64/lib/crc32.c
-- 
2.49.0

