Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A08FECE58A
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6679C21D7B
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 14:18:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KmwOUiyn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfJBOR7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 10:17:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46329 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbfJBOR7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 10:17:59 -0400
Received: by mail-wr1-f65.google.com with SMTP id o18so19837721wrv.13
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 07:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aG4eoMjkkcuaDa5uAXgPjSu7DoIJsA0jc8CLt+o/aME=;
        b=KmwOUiynwj4F/XpS8h1dJDnUfpoPARmlFUS/869QtrxibLP+gpmvx9ocA6EWTjD+Qy
         wSdL8KlnCHt8i51EBXK67IU9ZUmS8//ZNQkE7YgfP/EDNpJgFAYKjkxcHYm0yfgz7026
         RAuOhyxb1mV8xlRw0DVYMKYxi8Vxk9ue4mXD+kL4QlE4MOfeY8j9YRm5OPia64MfuDyi
         fMt1KBH4Ou/ehhPEJBnW0wvz9GdBS7B/bPzrvQO6QosamlAWoatFAZljg2rfkd/XOl6t
         eDtoBhdCNguAzDTys1RYpi8PRC+qOi7N1effHgROv4fvB9+cMA1qv3Bm8E0xbdXtemeS
         ITHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aG4eoMjkkcuaDa5uAXgPjSu7DoIJsA0jc8CLt+o/aME=;
        b=TdOg39uGaJh4NOideaT/+JUodzba8Bpo5TCl7pf1/SqcyWQejWi/7fqIosd4DTm6qw
         C7XGw8TlIWAVuLVidLZTM6lYu8GKvC0nJMUyzAAoq3FQdaByYDnz2hhdu0aSYZpbSvUV
         v3S8qLDmZ5R68IxliHg1JDFRynQYhvBlkiAY8IKzttZ9gKDtAULl4gY2Mrg8e3BghVcv
         JJwlFB0BKFXQJ0xa1jzlEAtINxvTPHjQMKU3ulByyIu+SGEX3WiIOXhLd7NoCrDMPf9q
         WjozE7zHxouK36kA3BxKP+7dOmETt6uyaFJwi82bfF9nlUtZUCUVWso33foPgkRwatq1
         md+A==
X-Gm-Message-State: APjAAAWVURpHC6oB7ETsQaZ0QSZwn0DGF83p+o8nzQ3uql1IgmxNXZKg
        vvmrlV623A86tZawIE9RKEY6T7w0P+G+f1ym
X-Google-Smtp-Source: APXvYqwjknNtpL7CEMWJ90jtetwOd71VceRV3OAXvHuQdUbyKPcrixTTdqHqOmP1paGLusdHcsxg5w==
X-Received: by 2002:adf:e60d:: with SMTP id p13mr2751308wrm.298.1570025877046;
        Wed, 02 Oct 2019 07:17:57 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:f145:3252:fc29:76c9])
        by smtp.gmail.com with ESMTPSA id t13sm41078149wra.70.2019.10.02.07.17.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 07:17:56 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH v2 11/20] int128: move __uint128_t compiler test to Kconfig
Date:   Wed,  2 Oct 2019 16:17:04 +0200
Message-Id: <20191002141713.31189-12-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to use 128-bit integer arithmetic in C code, the architecture
needs to have declared support for it by setting ARCH_SUPPORTS_INT128,
and it requires a version of the toolchain that supports this at build
time. This is why all existing tests for ARCH_SUPPORTS_INT128 also test
whether __SIZEOF_INT128__ is defined, since this is only the case for
compilers that can support 128-bit integers.

Let's fold this additional test into the Kconfig declaration of
ARCH_SUPPORTS_INT128 so that we can also use the symbol in Makefiles,
e.g., to decide whether a certain object needs to be included in the
first place.

Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig | 2 +-
 arch/riscv/Kconfig | 2 +-
 arch/x86/Kconfig   | 2 +-
 crypto/ecc.c       | 2 +-
 init/Kconfig       | 4 ++++
 lib/ubsan.c        | 2 +-
 lib/ubsan.h        | 2 +-
 7 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 41a9b4257b72..a591a0673694 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -67,7 +67,7 @@ config ARM64
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_ATOMIC_RMW
-	select ARCH_SUPPORTS_INT128 if GCC_VERSION >= 50000 || CC_IS_CLANG
+	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
 	select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 8eebbc8860bb..75a6c9117622 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -164,7 +164,7 @@ config ARCH_RV32I
 config ARCH_RV64I
 	bool "RV64I"
 	select 64BIT
-	select ARCH_SUPPORTS_INT128 if GCC_VERSION >= 50000
+	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && GCC_VERSION >= 50000
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d6e1faa28c58..f4d9d1e55e5c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -24,7 +24,7 @@ config X86_64
 	depends on 64BIT
 	# Options that are inherently 64-bit kernel only:
 	select ARCH_HAS_GIGANTIC_PAGE
-	select ARCH_SUPPORTS_INT128
+	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select HAVE_ARCH_SOFT_DIRTY
 	select MODULES_USE_ELF_RELA
diff --git a/crypto/ecc.c b/crypto/ecc.c
index dfe114bc0c4a..6e6aab6c987c 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -336,7 +336,7 @@ static u64 vli_usub(u64 *result, const u64 *left, u64 right,
 static uint128_t mul_64_64(u64 left, u64 right)
 {
 	uint128_t result;
-#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
+#if defined(CONFIG_ARCH_SUPPORTS_INT128)
 	unsigned __int128 m = (unsigned __int128)left * right;
 
 	result.m_low  = m;
diff --git a/init/Kconfig b/init/Kconfig
index b4daad2bac23..020526f681c0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -785,6 +785,10 @@ config ARCH_SUPPORTS_NUMA_BALANCING
 config ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
 	bool
 
+config CC_HAS_INT128
+	def_bool y
+	depends on !$(cc-option,-D__SIZEOF_INT128__=0)
+
 #
 # For architectures that know their GCC __int128 support is sound
 #
diff --git a/lib/ubsan.c b/lib/ubsan.c
index e7d31735950d..b652cc14dd60 100644
--- a/lib/ubsan.c
+++ b/lib/ubsan.c
@@ -119,7 +119,7 @@ static void val_to_string(char *str, size_t size, struct type_descriptor *type,
 {
 	if (type_is_int(type)) {
 		if (type_bit_width(type) == 128) {
-#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
+#if defined(CONFIG_ARCH_SUPPORTS_INT128)
 			u_max val = get_unsigned_val(type, value);
 
 			scnprintf(str, size, "0x%08x%08x%08x%08x",
diff --git a/lib/ubsan.h b/lib/ubsan.h
index b8fa83864467..7b56c09473a9 100644
--- a/lib/ubsan.h
+++ b/lib/ubsan.h
@@ -78,7 +78,7 @@ struct invalid_value_data {
 	struct type_descriptor *type;
 };
 
-#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
+#if defined(CONFIG_ARCH_SUPPORTS_INT128)
 typedef __int128 s_max;
 typedef unsigned __int128 u_max;
 #else
-- 
2.20.1

