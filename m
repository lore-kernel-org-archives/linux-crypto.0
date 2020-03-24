Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ED60C4332B
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D971420714
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585008970;
	bh=M3i+esipc/7RxjC4LIZ1nh9blbZcFkjp/UfIDebVeM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TALzrC+kcd/6CJc+DQ3ZRCSNqFZ3E+5fogy8RbJczt8qZluBaVJjXYEL6ZWiALeMZ
	 zyyvimyluhDJfl7K25gLRDD7KY1Mf2nj8C+D8u58p+AD93NdEAgxUvR5qceuzAuZvc
	 xqxNWdBJ1dKPiMSEWPIsag5YriZAvq9bQV8BYyHw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgCXAQK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:16:10 -0400
Received: from conuserg-09.nifty.com ([210.131.2.76]:30312 "EHLO
        conuserg-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgCXAQK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 20:16:10 -0400
Received: from grover.flets-west.jp (softbank126093102113.bbtec.net [126.93.102.113]) (authenticated)
        by conuserg-09.nifty.com with ESMTP id 02O0EHnt026701;
        Tue, 24 Mar 2020 09:14:24 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 02O0EHnt026701
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585008864;
        bh=R0STIziFjPNP3E34qfzmQ6u1ZNlYmWgDS8/ChcGBd/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hpHQGA+nZfdPtj8G28GbRdvidfq5s2iIfLA0qB3v6lkhLGJ5/UpJKa0hDNawptDiI
         35m6TF68KRZ66hcbFhbykObdb2I+BjXji9sE+e6fYLbKA2Grn1OJ7vqLkPnDEAWDeP
         bu77UxPrdatwSNjKUhNnj6eZ4zZpBYuIauZ/MpF/dlOR6Gl+pcXPm1ODp4hzVLIwGK
         1BGbRCH/QtYv/YFyLHAH552H6e4PVjx+8HzWFWZLFGrHuZHlyMCHYpHbPjF/ytmM/q
         X2zAtRe9jnDrwLPfVel2dIE7zhwAxncOqvGdwG8ayj0DNB8UI8iroJ1BxsAeoERna/
         6wpRTLa7qHA/w==
X-Nifty-SrcIP: [126.93.102.113]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        clang-built-linux@googlegroups.com
Subject: [PATCH v2 6/9] x86: remove always-defined CONFIG_AS_SSSE3
Date:   Tue, 24 Mar 2020 09:13:55 +0900
Message-Id: <20200324001358.4520-7-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324001358.4520-1-masahiroy@kernel.org>
References: <20200324001358.4520-1-masahiroy@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CONFIG_AS_SSSE3 was introduced by commit 75aaf4c3e6a4 ("x86/raid6:
correctly check for assembler capabilities").

We raise the minimal supported binutils version from time to time.
The last bump was commit 1fb12b35e5ff ("kbuild: Raise the minimum
required binutils version to 2.21").

I confirmed the code in $(call as-instr,...) can be assembled by the
binutils 2.21 assembler and also by LLVM integrated assembler.

Remove CONFIG_AS_SSSE3, which is always defined.

I added ifdef CONFIG_X86 to lib/raid6/algos.c to avoid link errors
on non-x86 architectures.

lib/raid6/algos.c is built not only for the kernel but also for
testing the library code from userspace. I added -DCONFIG_X86 to
lib/raid6/test/Makefile to cator to this usecase.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
---

Changes in v2:
  - add ifdef CONFIG_X86 to fix build errors on non-x86 arches

 arch/x86/Makefile              | 5 ++---
 arch/x86/crypto/blake2s-core.S | 2 --
 lib/raid6/algos.c              | 2 +-
 lib/raid6/recov_ssse3.c        | 6 ------
 lib/raid6/test/Makefile        | 4 +---
 5 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index e4a062313bb0..94f89612e024 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -178,7 +178,6 @@ ifeq ($(ACCUMULATE_OUTGOING_ARGS), 1)
 endif
 
 # does binutils support specific instructions?
-asinstr += $(call as-instr,pshufb %xmm0$(comma)%xmm0,-DCONFIG_AS_SSSE3=1)
 avx_instr := $(call as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
 avx2_instr :=$(call as-instr,vpbroadcastb %xmm0$(comma)%ymm1,-DCONFIG_AS_AVX2=1)
 avx512_instr :=$(call as-instr,vpmovm2b %k1$(comma)%zmm5,-DCONFIG_AS_AVX512=1)
@@ -186,8 +185,8 @@ sha1_ni_instr :=$(call as-instr,sha1msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA1_NI=
 sha256_ni_instr :=$(call as-instr,sha256msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA256_NI=1)
 adx_instr := $(call as-instr,adox %r10$(comma)%r10,-DCONFIG_AS_ADX=1)
 
-KBUILD_AFLAGS += $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
-KBUILD_CFLAGS += $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
+KBUILD_AFLAGS += $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
+KBUILD_CFLAGS += $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
 
 KBUILD_LDFLAGS := -m elf_$(UTS_MACHINE)
 
diff --git a/arch/x86/crypto/blake2s-core.S b/arch/x86/crypto/blake2s-core.S
index 24910b766bdd..2ca79974f819 100644
--- a/arch/x86/crypto/blake2s-core.S
+++ b/arch/x86/crypto/blake2s-core.S
@@ -46,7 +46,6 @@ SIGMA2:
 #endif /* CONFIG_AS_AVX512 */
 
 .text
-#ifdef CONFIG_AS_SSSE3
 SYM_FUNC_START(blake2s_compress_ssse3)
 	testq		%rdx,%rdx
 	je		.Lendofloop
@@ -174,7 +173,6 @@ SYM_FUNC_START(blake2s_compress_ssse3)
 .Lendofloop:
 	ret
 SYM_FUNC_END(blake2s_compress_ssse3)
-#endif /* CONFIG_AS_SSSE3 */
 
 #ifdef CONFIG_AS_AVX512
 SYM_FUNC_START(blake2s_compress_avx512)
diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index bf1b4765c8f6..df08664d3432 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -97,13 +97,13 @@ void (*raid6_datap_recov)(int, size_t, int, void **);
 EXPORT_SYMBOL_GPL(raid6_datap_recov);
 
 const struct raid6_recov_calls *const raid6_recov_algos[] = {
+#ifdef CONFIG_X86
 #ifdef CONFIG_AS_AVX512
 	&raid6_recov_avx512,
 #endif
 #ifdef CONFIG_AS_AVX2
 	&raid6_recov_avx2,
 #endif
-#ifdef CONFIG_AS_SSSE3
 	&raid6_recov_ssse3,
 #endif
 #ifdef CONFIG_S390
diff --git a/lib/raid6/recov_ssse3.c b/lib/raid6/recov_ssse3.c
index 1de97d2405d0..4bfa3c6b60de 100644
--- a/lib/raid6/recov_ssse3.c
+++ b/lib/raid6/recov_ssse3.c
@@ -3,8 +3,6 @@
  * Copyright (C) 2012 Intel Corporation
  */
 
-#ifdef CONFIG_AS_SSSE3
-
 #include <linux/raid/pq.h>
 #include "x86.h"
 
@@ -328,7 +326,3 @@ const struct raid6_recov_calls raid6_recov_ssse3 = {
 #endif
 	.priority = 1,
 };
-
-#else
-#warning "your version of binutils lacks SSSE3 support"
-#endif
diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
index b9e6c3648be1..60021319ac78 100644
--- a/lib/raid6/test/Makefile
+++ b/lib/raid6/test/Makefile
@@ -34,9 +34,7 @@ endif
 
 ifeq ($(IS_X86),yes)
         OBJS   += mmx.o sse1.o sse2.o avx2.o recov_ssse3.o recov_avx2.o avx512.o recov_avx512.o
-        CFLAGS += $(shell echo "pshufb %xmm0, %xmm0" |		\
-                    gcc -c -x assembler - >/dev/null 2>&1 &&	\
-                    rm ./-.o && echo -DCONFIG_AS_SSSE3=1)
+        CFLAGS += -DCONFIG_X86
         CFLAGS += $(shell echo "vpbroadcastb %xmm0, %ymm1" |	\
                     gcc -c -x assembler - >/dev/null 2>&1 &&	\
                     rm ./-.o && echo -DCONFIG_AS_AVX2=1)
-- 
2.17.1

