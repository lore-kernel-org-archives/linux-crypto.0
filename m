Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6505C43331
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F29620714
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 00:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585008948;
	bh=X08t8YQHfpY5IGftqypVB/Mi4brum3IB/0i+RRQJFJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ixix+MJ6k4+BjQ9B4reK5ulnt9DjTWp76hd1D2jWYKHJAIWIMXeIwlxFR4BVIUetg
	 MwJGg/jI9FstajCiRofTbLzixYeKaMUDvgadr4JAnz19fKJSFKwSz3kNXagP+o7soX
	 4uCezqvFR3A8yg3eMhKEIr30lLAAwO8u/jgUBq2M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbgCXAPr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:15:47 -0400
Received: from conuserg-09.nifty.com ([210.131.2.76]:29698 "EHLO
        conuserg-09.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727466AbgCXAPr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 20:15:47 -0400
Received: from grover.flets-west.jp (softbank126093102113.bbtec.net [126.93.102.113]) (authenticated)
        by conuserg-09.nifty.com with ESMTP id 02O0EHnr026701;
        Tue, 24 Mar 2020 09:14:22 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-09.nifty.com 02O0EHnr026701
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1585008862;
        bh=UbfzmShuThDos2jJGrS5JnizxL0abD5pkTprbCm3n1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fnOsECwuwSFQ5IW1Q9QE/o8CyX7lGFKpVrQQra+jNsYVaTm/xaOgQeoWIvlBNnn+A
         zn//gFbwx/yNExpUiKej5xctJ/D/lel2qM1vzYjAJGtX4denWLFdrqm/v0fkwhpypE
         bPJHIJDB5J8s7nq4arDnJVPZxQddKYQ1m+UxpUXB3otnMUVuWzRiQYfonoyChS4Eit
         AuDzTBevpOZ0WHeZU9rU9SgWPNdNvJDOeNbVwm2dOwuo8z4cTiU5xwoaI25Uvo2fp2
         KvpNLwSYrFsaecI8Q9xy9PS0LKc/0vr5CB/suJ77/gPTx8T54Y0Gec/wZlGZgd0n3n
         IkqKyb88gsOwQ==
X-Nifty-SrcIP: [126.93.102.113]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, linux-crypto@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH v2 4/9] x86: remove unneeded (CONFIG_AS_)CFI_SIGNAL_FRAME
Date:   Tue, 24 Mar 2020 09:13:53 +0900
Message-Id: <20200324001358.4520-5-masahiroy@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200324001358.4520-1-masahiroy@kernel.org>
References: <20200324001358.4520-1-masahiroy@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Commit 131484c8da97 ("x86/debug: Remove perpetually broken,
unmaintainable dwarf annotations") removes all the users of
CFI_SIGNAL_FRAME.

Remove the CFI_SIGNAL_FRAME and CONFIG_AS_CFI_SIGNAL_FRAME.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
---

Changes in v2:
  - Remove CFI_SIGNAL_FRAME entirely (per Nick)

 arch/x86/Makefile             | 6 ++----
 arch/x86/include/asm/dwarf2.h | 6 ------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 72f8f744ebd7..dd275008fc59 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -177,8 +177,6 @@ ifeq ($(ACCUMULATE_OUTGOING_ARGS), 1)
 	KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args,)
 endif
 
-# is .cfi_signal_frame supported too?
-cfi-sigframe := $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1)
 cfi-sections := $(call as-instr,.cfi_sections .debug_frame,-DCONFIG_AS_CFI_SECTIONS=1)
 
 # does binutils support specific instructions?
@@ -190,8 +188,8 @@ sha1_ni_instr :=$(call as-instr,sha1msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA1_NI=
 sha256_ni_instr :=$(call as-instr,sha256msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA256_NI=1)
 adx_instr := $(call as-instr,adox %r10$(comma)%r10,-DCONFIG_AS_ADX=1)
 
-KBUILD_AFLAGS += $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
-KBUILD_CFLAGS += $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
+KBUILD_AFLAGS += $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
+KBUILD_CFLAGS += $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
 
 KBUILD_LDFLAGS := -m elf_$(UTS_MACHINE)
 
diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 90807583cad7..f440790f09f9 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -21,12 +21,6 @@
 #define CFI_UNDEFINED		.cfi_undefined
 #define CFI_ESCAPE		.cfi_escape
 
-#ifdef CONFIG_AS_CFI_SIGNAL_FRAME
-#define CFI_SIGNAL_FRAME	.cfi_signal_frame
-#else
-#define CFI_SIGNAL_FRAME
-#endif
-
 #if defined(CONFIG_AS_CFI_SECTIONS)
 #ifndef BUILD_VDSO
 	/*
-- 
2.17.1

