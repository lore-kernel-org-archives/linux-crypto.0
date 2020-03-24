Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C14C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA15F20714
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585008957;
	bh=lkibHm9F4rNasjAG95t2w9zsGP7F3aiRE0T7IgbxTTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=OHthYMdcYzVxWfeUer5S3qFX98mx5BIE1wLvoKK29rhGlaXhGiAK211MYYjE3pbJI
	 zeg8QNkoPuqJLQja/uVk4bqxqaxIb4igo5B7rOed/GeBgjpTSlAu0+545kHTW8umjl
	 vGhPMx1OMHODekhYlJNQEHI+5Ox6bQF3vex0fCjU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbgCXAPv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:15:51 -0400
Received: from conuserg-09.nifty.com ([210.131.2.76]:29770 "EHLO
        conuserg-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727510AbgCXAPu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 20:15:50 -0400
Received: from grover.flets-west.jp (softbank126093102113.bbtec.net [126.93.102.113]) (authenticated)
        by conuserg-09.nifty.com with ESMTP id 02O0EHns026701;
        Tue, 24 Mar 2020 09:14:23 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 02O0EHns026701
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585008863;
        bh=PXf90zEL0PBjxAqiIelC9lPpjynKaO7oTN5qSukZw9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vNHVDqn0n6+005Ynu+20MgPJrYvvF8RyIWdmGr6LWGtvMoFJyxw6Mws0aBx7XjTAH
         biGuW+2/odEx5og6G+EwC35JJcGLegJBQs0qXM+xP1RqxSdCL2rBVhgpSWm5gR3WP1
         Ns8WY4pfBnR/qQ2Hhu29fANWa2hqQa8E7+ppFkQuNL2Qy9/2hYFHp3RCyNfaAt2c0T
         VQweCj511vsWrKqxYRqhhpRdpj26L6cOnTHgylfc+07TOs3LSZNEbQiiCfx+R5jjC/
         ElnXBRqNpfZKOnwYqLp5NTY1kDAO1+1IIpSLZMPrTwr70afxxC5Ix0auF9nBeDIJTH
         pKkm+vhVSoorA==
X-Nifty-SrcIP: [126.93.102.113]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        clang-built-linux@googlegroups.com
Subject: [PATCH v2 5/9] x86: remove always-defined CONFIG_AS_CFI_SECTIONS
Date:   Tue, 24 Mar 2020 09:13:54 +0900
Message-Id: <20200324001358.4520-6-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324001358.4520-1-masahiroy@kernel.org>
References: <20200324001358.4520-1-masahiroy@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

CONFIG_AS_CFI_SECTIONS was introduced by commit 9e565292270a ("x86:
Use .cfi_sections for assembly code").

We raise the minimal supported binutils version from time to time.
The last bump was commit 1fb12b35e5ff ("kbuild: Raise the minimum
required binutils version to 2.21").

I confirmed the code in $(call as-instr,...) can be assembled by the
binutils 2.21 assembler and also by LLVM integrated assembler.

Remove CONFIG_AS_CFI_SECTIONS, which is always defined.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
---

Changes in v2: None

 arch/x86/Makefile             | 6 ++----
 arch/x86/include/asm/dwarf2.h | 2 --
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index dd275008fc59..e4a062313bb0 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -177,8 +177,6 @@ ifeq ($(ACCUMULATE_OUTGOING_ARGS), 1)
 	KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args,)
 endif
 
-cfi-sections := $(call as-instr,.cfi_sections .debug_frame,-DCONFIG_AS_CFI_SECTIONS=1)
-
 # does binutils support specific instructions?
 asinstr += $(call as-instr,pshufb %xmm0$(comma)%xmm0,-DCONFIG_AS_SSSE3=1)
 avx_instr := $(call as-instr,vxorps %ymm0$(comma)%ymm1$(comma)%ymm2,-DCONFIG_AS_AVX=1)
@@ -188,8 +186,8 @@ sha1_ni_instr :=$(call as-instr,sha1msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA1_NI=
 sha256_ni_instr :=$(call as-instr,sha256msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA256_NI=1)
 adx_instr := $(call as-instr,adox %r10$(comma)%r10,-DCONFIG_AS_ADX=1)
 
-KBUILD_AFLAGS += $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
-KBUILD_CFLAGS += $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
+KBUILD_AFLAGS += $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
+KBUILD_CFLAGS += $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
 
 KBUILD_LDFLAGS := -m elf_$(UTS_MACHINE)
 
diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index f440790f09f9..c1e0c315a622 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -21,7 +21,6 @@
 #define CFI_UNDEFINED		.cfi_undefined
 #define CFI_ESCAPE		.cfi_escape
 
-#if defined(CONFIG_AS_CFI_SECTIONS)
 #ifndef BUILD_VDSO
 	/*
 	 * Emit CFI data in .debug_frame sections, not .eh_frame sections.
@@ -38,6 +37,5 @@
 	  */
 	.cfi_sections .eh_frame, .debug_frame
 #endif
-#endif
 
 #endif /* _ASM_X86_DWARF2_H */
-- 
2.17.1

