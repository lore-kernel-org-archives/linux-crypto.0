Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F39770E2;
	Fri, 18 Apr 2025 03:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744948767; cv=none; b=Gnq2eLCC6E02LhpWUNoOBoLc/VZBgOEn5cBsvHniIKymY0ljuvSaIasXGKLwr3zM63o4xKsG2ZyUn4+p5NG2EqxKqmSiiW4TWgbmLaTbtR60aR31VyqUb/2oCdmDk9WE5c9EghJeAWDx6Jetw4KbQphr+uEajL3pu6AB7qve3Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744948767; c=relaxed/simple;
	bh=zTLpLtCFatq0BP/bO1sVaapNcptTnUAKdd6tFb0ull0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QYhjYXF0WLY3W1UZorW7+X/GQWYRH9TYt5Xoaaur42t20fg7e69PgaOFQBn9jsROGdck3TvNwR0w739rEdjS4awP9aLCabPzT3VkXohSRK+lKymyiDl08zKudvdU8XEByZIetmpNc6Wi5zsalePfNDO9enHdMC9xEAQbcYVLvog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iz4qsG5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iz4qsG5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49951C4CEE2;
	Fri, 18 Apr 2025 03:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744948766;
	bh=zTLpLtCFatq0BP/bO1sVaapNcptTnUAKdd6tFb0ull0=;
	h=From:To:Cc:Subject:Date:From;
	b=Iz4qsG5bpDo45A4SVkWv5wqji4qG8oQMkZmupV6uvvHZoGGUayBdl7zYHJ4IvNuSt
	 ewk5l3qCozIVLGpWHpBFqFLv3KcdSZy1YAvk/OxrKJXleT33sRRpxkvKdXbYc5dnwt
	 YCLbn0TRWjILOz3bPlW8jVSxjrbybUcD38gKlUGBJpBeUir0Y7MavdikSULt6A2EKb
	 +dZax1QG0RsrJWHmj27/jlwEuwcFJftA+bTMQD+3+PR2ffMWtZyttQy4lJZGnP7ryo
	 /WoMN+L4gH+XMOyYlZogn5DbuZAWN4+PRCzuCjzGVddfUKpAbuay+HHvKB7BWieaCz
	 PqRFyfg6o7sCg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: lib/chacha - restore ability to remove modules
Date: Thu, 17 Apr 2025 20:59:09 -0700
Message-ID: <20250418035909.64902-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Though the module_exit functions are now no-ops, they should still be
defined, since otherwise the modules become unremovable.

Fixes: 08820553f33a ("crypto: arm/chacha - remove the redundant skcipher algorithms")
Fixes: 8c28abede16c ("crypto: arm64/chacha - remove the skcipher algorithms")
Fixes: f7915484c020 ("crypto: powerpc/chacha - remove the skcipher algorithms")
Fixes: ceba0eda8313 ("crypto: riscv/chacha - implement library instead of skcipher")
Fixes: 632ab0978f08 ("crypto: x86/chacha - remove the skcipher algorithms")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/chacha-glue.c           | 5 +++++
 arch/arm64/crypto/chacha-neon-glue.c    | 5 +++++
 arch/powerpc/crypto/chacha-p10-glue.c   | 5 +++++
 arch/riscv/crypto/chacha-riscv64-glue.c | 5 +++++
 arch/x86/crypto/chacha_glue.c           | 5 +++++
 5 files changed, 25 insertions(+)

diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
index 3a5c75c95d43b..12afb40cf1ff4 100644
--- a/arch/arm/crypto/chacha-glue.c
+++ b/arch/arm/crypto/chacha-glue.c
@@ -122,8 +122,13 @@ static int __init chacha_arm_mod_init(void)
 	}
 	return 0;
 }
 arch_initcall(chacha_arm_mod_init);
 
+static void __exit chacha_arm_mod_exit(void)
+{
+}
+module_exit(chacha_arm_mod_exit);
+
 MODULE_DESCRIPTION("ChaCha and HChaCha functions (ARM optimized)");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
index a0c336b284027..14a2836eff611 100644
--- a/arch/arm64/crypto/chacha-neon-glue.c
+++ b/arch/arm64/crypto/chacha-neon-glue.c
@@ -104,8 +104,13 @@ static int __init chacha_simd_mod_init(void)
 		static_branch_enable(&have_neon);
 	return 0;
 }
 arch_initcall(chacha_simd_mod_init);
 
+static void __exit chacha_simd_mod_exit(void)
+{
+}
+module_exit(chacha_simd_mod_exit);
+
 MODULE_DESCRIPTION("ChaCha and HChaCha functions (ARM64 optimized)");
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
diff --git a/arch/powerpc/crypto/chacha-p10-glue.c b/arch/powerpc/crypto/chacha-p10-glue.c
index 9982929573add..351ed409f9b21 100644
--- a/arch/powerpc/crypto/chacha-p10-glue.c
+++ b/arch/powerpc/crypto/chacha-p10-glue.c
@@ -87,8 +87,13 @@ static int __init chacha_p10_init(void)
 		static_branch_enable(&have_p10);
 	return 0;
 }
 arch_initcall(chacha_p10_init);
 
+static void __exit chacha_p10_exit(void)
+{
+}
+module_exit(chacha_p10_exit);
+
 MODULE_DESCRIPTION("ChaCha stream cipher (P10 accelerated)");
 MODULE_AUTHOR("Danny Tsen <dtsen@linux.ibm.com>");
 MODULE_LICENSE("GPL v2");
diff --git a/arch/riscv/crypto/chacha-riscv64-glue.c b/arch/riscv/crypto/chacha-riscv64-glue.c
index ccaab0dea383f..afc4e3be3cac2 100644
--- a/arch/riscv/crypto/chacha-riscv64-glue.c
+++ b/arch/riscv/crypto/chacha-riscv64-glue.c
@@ -62,8 +62,13 @@ static int __init riscv64_chacha_mod_init(void)
 		static_branch_enable(&use_zvkb);
 	return 0;
 }
 arch_initcall(riscv64_chacha_mod_init);
 
+static void __exit riscv64_chacha_mod_exit(void)
+{
+}
+module_exit(riscv64_chacha_mod_exit);
+
 MODULE_DESCRIPTION("ChaCha stream cipher (RISC-V optimized)");
 MODULE_AUTHOR("Jerry Shih <jerry.shih@sifive.com>");
 MODULE_LICENSE("GPL");
diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index fcc14c006bdeb..59bf63c000726 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -174,8 +174,13 @@ static int __init chacha_simd_mod_init(void)
 	}
 	return 0;
 }
 arch_initcall(chacha_simd_mod_init);
 
+static void __exit chacha_simd_mod_exit(void)
+{
+}
+module_exit(chacha_simd_mod_exit);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
 MODULE_DESCRIPTION("ChaCha and HChaCha functions (x86_64 optimized)");

base-commit: da4cb617bc7d827946cbb368034940b379a1de90
-- 
2.49.0

