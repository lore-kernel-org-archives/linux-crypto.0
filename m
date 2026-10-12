Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BECD135A53;
	Mon, 12 Oct 2026 03:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791775164; cv=none; b=Y1Lv+NWR7FNDkCn8dyD8oEkfLxarqGImaRw5qVnTf8PCON+9c77xO+flR5H4CXdxL13u8YFwhsVkjtmMcZa9W6lObp/h7hHfNtyW0R4k4uhegD/I4+ygtXaoxBTRj28jZubTr9avXBkWsl0mmO00wnLcLFzrS1DF1RuRLTTEr6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791775164; c=relaxed/simple;
	bh=XI3HOXLgYYYo9T2K41J9F1jvmxYlzw5a08uXZYR2K/g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NI45srtK2E6DH36v6+jPV6Uj2NFN17mX8GsQV5XyhK6ba2vk2H4gjRtkieuiTpVVZlX3usH3TBRiXkWxPcWczTZPehZqG2yj0GlEq/cXJ4RNkCrtJPH1n1FyHrDyTt6ZtQTWxIACXR6TVGKm7JDMDiCYi4SQg9VlC6DSYv0Vj7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ILa9lzHL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ILa9lzHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB661F0089B;
	Mon, 12 Oct 2026 03:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791775162;
	bh=xFH3XSsdAEjCBs6d+khIbPn/UOj37pBjqAzm5pVCVjE=;
	h=From:To:Cc:Subject:Date;
	b=ILa9lzHL+z9O6OPxKvPdm+P2wqi+n+JHiE7tvkflmDh2z8l5EQUNv0O0PURZ1/o64
	 xTD50OwwtPQ5ljbdHfgYFb1HyWXvJvIS1HVVe3SSjsGgcXf94YtJHEmi6XfwwGSbeG
	 NumITTeH7CCMVB8OThvxvHD+gpV+kebeOvY6aW2TCrIGWw6G11ktMJvYYWhnp2pxrs
	 z1EWRzPZzShfCnOyMY0YQB+63yGDeaQOlYvCzpihVgMir8mpeXfaDSL3wEyQnrbPIA
	 8gpLO0T69qrz8Lw2r1yDzeJl/lvKU/EJaJf5nF5rzpsU8HFUmXwv/t403d/+Q0eNz1
	 2dZ1mgm96OuAg==
From: Kees Cook <kees@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <kees@kernel.org>,
	Taehee Yoo <ap420073@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-crypto@vger.kernel.org,
	llvm@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] crypto: x86/aria - Take the address of each asm function in one file
Date: Sun, 11 Oct 2026 20:19:21 -0700
Message-ID: <20261012031920.i.329-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7595; i=kees@kernel.org; h=from:subject:message-id; bh=XI3HOXLgYYYo9T2K41J9F1jvmxYlzw5a08uXZYR2K/g=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlnAndMzuBMN5T++bbyYPSXic9/ymw+Zb4ue/GPiVq5M xLnaHJzd5SyMIhxMciKKbIE2bnHuXi8bQ93n6sIM4eVCWQIAxenAExE+SEjw/bNz+VDpRN7A8+9 eTR/XnLDjtbmU0Uc3JevJR/gNtxylIOR4cPEAhXVST7blrbxb1kcq6Iu7lneOMn/yu27Vknzj8g f4wMA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

A Clang Full LTO bug[1] was fixed in Clang 23 where multiple .o files
performing an address-take of the same asm-originating typeid weak symbols
would have those symbols get completely removed instead of just keeping
one, seen at link time:

  ld.lld: error: undefined symbol: __kcfi_typeid_aria_aesni_avx_encrypt_16way
  >>> referenced by aria-aesni-avx-asm_64.S:962
  >>>               vmlinux.o:(__cfi_aria_aesni_avx_encrypt_16way)

As a work-around for earlier Clang, add aria_avx_setup_16way_ops() and
aria_avx2_setup_32way_ops(), exported by the glue that owns each tier's
asm functions, and fill all three tables with them, so that each asm
function has its address taken in only one file.

Build tested ARCH=x86_64 with the kernel test robot's randconfig
(CONFIG_LTO_CLANG_FULL=y, CONFIG_CFI=y, and all three ARIA drivers built
in) and W=1, with Clang 22.1.8 and Clang 24.0.0git: vmlinux.o defines all
fifteen __kcfi_typeid_aria_* symbols, and vmlinux links. Without this
change, Clang 22.1.8 fails to link it as above, and Clang 24.0.0git,
which has the LLVM fix, links it.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606041643.GyTZgCk1-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202606122021.pA9TozrA-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202608100432.yIX7TckM-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202610112311.o9XQsWsa-lkp@intel.com/
Link: https://github.com/llvm/llvm-project/pull/204025 [1]
Assisted-by: LLM
Signed-off-by: Kees Cook <kees@kernel.org>
---
 arch/x86/crypto/aria-avx.h              |  3 +++
 arch/x86/crypto/aria_aesni_avx2_glue.c  | 35 ++++++++++++++-----------
 arch/x86/crypto/aria_aesni_avx_glue.c   | 29 +++++++++++++-------
 arch/x86/crypto/aria_gfni_avx512_glue.c |  8 ++----
 4 files changed, 45 insertions(+), 30 deletions(-)

diff --git a/arch/x86/crypto/aria-avx.h b/arch/x86/crypto/aria-avx.h
index 6e1b2d8a31ed..0fff24861088 100644
--- a/arch/x86/crypto/aria-avx.h
+++ b/arch/x86/crypto/aria-avx.h
@@ -59,4 +59,7 @@ struct aria_avx_ops {
 
 
 };
+
+void aria_avx_setup_16way_ops(struct aria_avx_ops *ops, bool use_gfni);
+void aria_avx2_setup_32way_ops(struct aria_avx_ops *ops, bool use_gfni);
 #endif
diff --git a/arch/x86/crypto/aria_aesni_avx2_glue.c b/arch/x86/crypto/aria_aesni_avx2_glue.c
index 1487a49bfbac..65c850601f49 100644
--- a/arch/x86/crypto/aria_aesni_avx2_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx2_glue.c
@@ -37,6 +37,24 @@ asmlinkage void aria_aesni_avx2_gfni_ctr_crypt_32way(const void *ctx, u8 *dst,
 						     u8 *keystream, u8 *iv);
 EXPORT_SYMBOL_GPL(aria_aesni_avx2_gfni_ctr_crypt_32way);
 
+/*
+ * Set up function pointers for the AVX 32-way asm functions for both this
+ * module and the the higher-tier modules.
+ */
+void aria_avx2_setup_32way_ops(struct aria_avx_ops *ops, bool use_gfni)
+{
+	if (use_gfni) {
+		ops->aria_encrypt_32way = aria_aesni_avx2_gfni_encrypt_32way;
+		ops->aria_decrypt_32way = aria_aesni_avx2_gfni_decrypt_32way;
+		ops->aria_ctr_crypt_32way = aria_aesni_avx2_gfni_ctr_crypt_32way;
+	} else {
+		ops->aria_encrypt_32way = aria_aesni_avx2_encrypt_32way;
+		ops->aria_decrypt_32way = aria_aesni_avx2_decrypt_32way;
+		ops->aria_ctr_crypt_32way = aria_aesni_avx2_ctr_crypt_32way;
+	}
+}
+EXPORT_SYMBOL_GPL(aria_avx2_setup_32way_ops);
+
 static struct aria_avx_ops aria_ops;
 
 struct aria_avx2_request_ctx {
@@ -211,21 +229,8 @@ static int __init aria_avx2_init(void)
 		return -ENODEV;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_GFNI)) {
-		aria_ops.aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
-		aria_ops.aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
-		aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
-		aria_ops.aria_encrypt_32way = aria_aesni_avx2_gfni_encrypt_32way;
-		aria_ops.aria_decrypt_32way = aria_aesni_avx2_gfni_decrypt_32way;
-		aria_ops.aria_ctr_crypt_32way = aria_aesni_avx2_gfni_ctr_crypt_32way;
-	} else {
-		aria_ops.aria_encrypt_16way = aria_aesni_avx_encrypt_16way;
-		aria_ops.aria_decrypt_16way = aria_aesni_avx_decrypt_16way;
-		aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_ctr_crypt_16way;
-		aria_ops.aria_encrypt_32way = aria_aesni_avx2_encrypt_32way;
-		aria_ops.aria_decrypt_32way = aria_aesni_avx2_decrypt_32way;
-		aria_ops.aria_ctr_crypt_32way = aria_aesni_avx2_ctr_crypt_32way;
-	}
+	aria_avx_setup_16way_ops(&aria_ops, boot_cpu_has(X86_FEATURE_GFNI));
+	aria_avx2_setup_32way_ops(&aria_ops, boot_cpu_has(X86_FEATURE_GFNI));
 
 	return crypto_register_skciphers(aria_algs, ARRAY_SIZE(aria_algs));
 }
diff --git a/arch/x86/crypto/aria_aesni_avx_glue.c b/arch/x86/crypto/aria_aesni_avx_glue.c
index e4e3d78915a5..07baf5a27143 100644
--- a/arch/x86/crypto/aria_aesni_avx_glue.c
+++ b/arch/x86/crypto/aria_aesni_avx_glue.c
@@ -39,6 +39,25 @@ EXPORT_SYMBOL_GPL(aria_aesni_avx_gfni_ctr_crypt_16way);
 
 static struct aria_avx_ops aria_ops;
 
+/*
+ * Set up function pointers for the AVX 16-way asm functions for both this
+ * module's own dispatch table and the higher-tier (AVX2, GFNI/AVX-512)
+ * modules.
+ */
+void aria_avx_setup_16way_ops(struct aria_avx_ops *ops, bool use_gfni)
+{
+	if (use_gfni) {
+		ops->aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
+		ops->aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
+		ops->aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
+	} else {
+		ops->aria_encrypt_16way = aria_aesni_avx_encrypt_16way;
+		ops->aria_decrypt_16way = aria_aesni_avx_decrypt_16way;
+		ops->aria_ctr_crypt_16way = aria_aesni_avx_ctr_crypt_16way;
+	}
+}
+EXPORT_SYMBOL_GPL(aria_avx_setup_16way_ops);
+
 struct aria_avx_request_ctx {
 	u8 keystream[ARIA_AESNI_PARALLEL_BLOCK_SIZE];
 };
@@ -197,15 +216,7 @@ static int __init aria_avx_init(void)
 		return -ENODEV;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_GFNI)) {
-		aria_ops.aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
-		aria_ops.aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
-		aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
-	} else {
-		aria_ops.aria_encrypt_16way = aria_aesni_avx_encrypt_16way;
-		aria_ops.aria_decrypt_16way = aria_aesni_avx_decrypt_16way;
-		aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_ctr_crypt_16way;
-	}
+	aria_avx_setup_16way_ops(&aria_ops, boot_cpu_has(X86_FEATURE_GFNI));
 
 	return crypto_register_skciphers(aria_algs, ARRAY_SIZE(aria_algs));
 }
diff --git a/arch/x86/crypto/aria_gfni_avx512_glue.c b/arch/x86/crypto/aria_gfni_avx512_glue.c
index 363cbf4399cc..1eccfceae314 100644
--- a/arch/x86/crypto/aria_gfni_avx512_glue.c
+++ b/arch/x86/crypto/aria_gfni_avx512_glue.c
@@ -214,12 +214,8 @@ static int __init aria_avx512_init(void)
 		return -ENODEV;
 	}
 
-	aria_ops.aria_encrypt_16way = aria_aesni_avx_gfni_encrypt_16way;
-	aria_ops.aria_decrypt_16way = aria_aesni_avx_gfni_decrypt_16way;
-	aria_ops.aria_ctr_crypt_16way = aria_aesni_avx_gfni_ctr_crypt_16way;
-	aria_ops.aria_encrypt_32way = aria_aesni_avx2_gfni_encrypt_32way;
-	aria_ops.aria_decrypt_32way = aria_aesni_avx2_gfni_decrypt_32way;
-	aria_ops.aria_ctr_crypt_32way = aria_aesni_avx2_gfni_ctr_crypt_32way;
+	aria_avx_setup_16way_ops(&aria_ops, true);
+	aria_avx2_setup_32way_ops(&aria_ops, true);
 	aria_ops.aria_encrypt_64way = aria_gfni_avx512_encrypt_64way;
 	aria_ops.aria_decrypt_64way = aria_gfni_avx512_decrypt_64way;
 	aria_ops.aria_ctr_crypt_64way = aria_gfni_avx512_ctr_crypt_64way;
-- 
2.55.0

