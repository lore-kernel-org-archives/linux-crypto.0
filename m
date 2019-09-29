Return-Path: <SRS0=xDoY=XY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D67EC352A9
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D3BF2196E
	for <linux-crypto@archiver.kernel.org>; Sun, 29 Sep 2019 17:39:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TlalrYyf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730350AbfI2RjW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 29 Sep 2019 13:39:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51492 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730120AbfI2RjS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 29 Sep 2019 13:39:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id 7so10780183wme.1
        for <linux-crypto@vger.kernel.org>; Sun, 29 Sep 2019 10:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5d/ZKH6nBX0my5cG4izp5fBEt7WBkczBGaXtkFvAuQk=;
        b=TlalrYyfJxj0YBF8FYCxk129NR83oLscTRTtDelLf/jM57BADCT7vCx3wx/M4TaANH
         z7dHYFyyrO9zfUNHThfU9A5N/XfLzB/0Nl8w7lLXdsIGdU53mRv5XwVMrAtURRH6M0Bi
         tsbq3uOGOp3tiGqhdT2En15CPyCbhtHz/FF15EsX2iPC84VZ5Q+sdZ0Wc0/8bb3CA0sI
         l+sTtOwJWJwcKBYlg6uZP9YyO0/J16qjMK7B5pugm/GVGvPVy8h9T3wZ2zLvT9Eyl15Z
         yV4nLeHXtcOGFDS591+8R0gcrgtV62aASSrJupzSQOFk288k2Dv7ScA3nbQZD2X/X66v
         zM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5d/ZKH6nBX0my5cG4izp5fBEt7WBkczBGaXtkFvAuQk=;
        b=bPTQSeFiUswbtZOLwlE/tCO3AxedzvdElT580xDfWIK6Dd0/cpcjpG83tWo0IQGP3y
         EHAvaBcjinK0D8VUETqHYLI73+S/dGP5eqh2SuHDVSJ3Jb/igDaifhz4Vl4QoxPmV/TT
         otKzLffmYMrVKEBQF97n0zm1li2Kxmpuhy+M+OJPmFMkuMtgsa5jFyVsPDp/MPgS3i9U
         B/PfybYVpUTH4AoRuEfxN/aAiXtWVxwztz86wYqvqwEOjVtoD6Pl6qTK7ywd+ilLvadB
         s54bZ9jccDEGkh5AdyHtxO3GEy3JY8qmIzCwNwEmcfoQoThDXncZBFb7ek4fEC+jOWQ9
         TTaA==
X-Gm-Message-State: APjAAAVJ80wKGgo7T73DnnVWsinWROJoWKVfmC/dS7Z+zYp6xcbaH/Kk
        8JzUP6pPT7IsOHdSPh9alwNlzq10bAYqi8kf
X-Google-Smtp-Source: APXvYqyxicDuFx1OEfg7GuNaInByNWRhWR710oIKNlBYTrWePh7z2VfAmJWaPnqZ4Sn0YjiRUhbRPg==
X-Received: by 2002:a7b:c182:: with SMTP id y2mr14179243wmi.156.1569778755308;
        Sun, 29 Sep 2019 10:39:15 -0700 (PDT)
Received: from e123331-lin.nice.arm.com (bar06-5-82-246-156-241.fbx.proxad.net. [82.246.156.241])
        by smtp.gmail.com with ESMTPSA id q192sm17339779wme.23.2019.09.29.10.39.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Sep 2019 10:39:14 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
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
        Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [RFC PATCH 09/20] int128: move __uint128_t compiler test to Kconfig
Date:   Sun, 29 Sep 2019 19:38:39 +0200
Message-Id: <20190929173850.26055-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
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
index 3adcec05b1f6..a0f764e2f299 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -69,7 +69,7 @@ config ARM64
 	select ARCH_USE_QUEUED_SPINLOCKS
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_ATOMIC_RMW
-	select ARCH_SUPPORTS_INT128 if GCC_VERSION >= 50000 || CC_IS_CLANG
+	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
 	select ARCH_SUPPORTS_NUMA_BALANCING
 	select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
 	select ARCH_WANT_FRAME_POINTERS
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 59a4727ecd6c..99be78ac7b33 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -127,7 +127,7 @@ config ARCH_RV32I
 config ARCH_RV64I
 	bool "RV64I"
 	select 64BIT
-	select ARCH_SUPPORTS_INT128 if GCC_VERSION >= 50000
+	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && GCC_VERSION >= 50000
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_FTRACE_MCOUNT_RECORD
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 222855cc0158..97f74a2e1cf3 100644
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
index bd7d650d4a99..f5566a985b9e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -780,6 +780,10 @@ config ARCH_SUPPORTS_NUMA_BALANCING
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
2.17.1

