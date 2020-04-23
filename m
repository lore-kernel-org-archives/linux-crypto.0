Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE8E5C54FCB
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 13:40:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEAFD20724
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 13:40:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728158AbgDWNkb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Apr 2020 09:40:31 -0400
Received: from foss.arm.com ([217.140.110.172]:40054 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728013AbgDWNkb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Apr 2020 09:40:31 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A2AC31B;
        Thu, 23 Apr 2020 06:40:30 -0700 (PDT)
Received: from gaia (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 24BBC3F6CF;
        Thu, 23 Apr 2020 06:40:29 -0700 (PDT)
Date:   Thu, 23 Apr 2020 14:40:22 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Eric Biggers <ebiggers@google.com>, Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] arm64: Open code .arch_extension
Message-ID: <20200423134022.GF4963@gaia>
References: <20200325114110.23491-1-broonie@kernel.org>
 <CAMj1kXH=g5N4ZtnZeX5N8hf9cnWVam4Htnov6qAmQwD58Wp73Q@mail.gmail.com>
 <20200325115038.GD4346@sirena.org.uk>
 <20200422180027.GH3585@gaia>
 <20200423111803.GG4808@sirena.org.uk>
 <20200423115905.GE4963@gaia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423115905.GE4963@gaia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 23, 2020 at 12:59:05PM +0100, Catalin Marinas wrote:
> On Thu, Apr 23, 2020 at 12:18:03PM +0100, Mark Brown wrote:
> > On Wed, Apr 22, 2020 at 07:00:28PM +0100, Catalin Marinas wrote:
> > > Forcing .S files to armv8.5 would not cause any problems with
> > > the base armv8.0 that the kernel image support since it shouldn't change
> > > the opcodes gas generates. The .S files would use alternatives anyway
> > > (or simply have code not called).
> > 
> > We do loose the checking that the assembler does that nobody used a
> > newer feature by mistake but yeah, shouldn't affect the output.
> 
> We may need some push/pop_arch macros to contain the supported features.
> 
> The gas documentation says that .arch_extension may be used multiple
> times to add or remove extensions. However, I couldn't find a way to
> remove memtag after adding it (tried -memtag, !memtag, empty string). So
> I may go with a '.arch armv8.0-a' as a base, followed by temporary
> setting of '.arch armv8.5-a+memtag' (and hope we don't need combinations
> of such extensions).

Quick attempt at this on top of the MTE patches:

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index e7338e129dfd..6180ac605406 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -24,10 +24,18 @@
 #include <asm/sysreg.h>
 #include <asm/thread_info.h>
 
-#ifdef CONFIG_ARM64_MTE
-	.arch		armv8.5-a
-	.arch_extension memtag
-#endif
+	/* Base architecture version for the .S files */
+	.arch	armv8-a
+
+	.macro	arm64_set_arch, arch, enable = 1
+	.if	\enable
+	.arch	\arch
+	.endif
+	.endm
+
+	.macro	arm64_reset_arch
+	.arch	armv8-a
+	.endm
 
 	.macro save_and_disable_daif, flags
 	mrs	\flags, daif
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e4ab82e543cf..df2037fc431b 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -148,6 +148,7 @@ alternative_cb_end
 	/* Check for MTE asynchronous tag check faults */
 	.macro check_mte_async_tcf, flgs, tmp
 #ifdef CONFIG_ARM64_MTE
+	arm64_set_arch armv8.5-a+memtag
 alternative_if_not ARM64_MTE
 	b	1f
 alternative_else_nop_endif
@@ -158,16 +159,19 @@ alternative_else_nop_endif
 	str	\flgs, [tsk, #TSK_TI_FLAGS]
 	msr_s	SYS_TFSRE0_EL1, xzr
 1:
+	arm64_reset_arch
 #endif
 	.endm
 
 	/* Clear the MTE asynchronous tag check faults */
 	.macro clear_mte_async_tcf
 #ifdef CONFIG_ARM64_MTE
+	arm64_set_arch armv8.5-a+memtag
 alternative_if ARM64_MTE
 	dsb	ish
 	msr_s	SYS_TFSRE0_EL1, xzr
 alternative_else_nop_endif
+	arm64_reset_arch
 #endif
 	.endm
 
diff --git a/arch/arm64/lib/clear_page.S b/arch/arm64/lib/clear_page.S
index 9f85a4cf9568..a8e26f232502 100644
--- a/arch/arm64/lib/clear_page.S
+++ b/arch/arm64/lib/clear_page.S
@@ -22,8 +22,10 @@ SYM_FUNC_START(clear_page)
 	mov	x2, #4
 	lsl	x1, x2, x1
 1:
+	arm64_set_arch armv8.5-a+memtag, IS_ENABLED(CONFIG_ARM64_MTE)
 alternative_insn "dc zva, x0", "stzgm xzr, [x0]", \
 			 ARM64_MTE, IS_ENABLED(CONFIG_ARM64_MTE), 1
+	arm64_reset_arch
 	add	x0, x0, x1
 	tst	x0, #(PAGE_SIZE - 1)
 	b.ne	1b
diff --git a/arch/arm64/lib/copy_page.S b/arch/arm64/lib/copy_page.S
index c3234175efe0..8322043e75e6 100644
--- a/arch/arm64/lib/copy_page.S
+++ b/arch/arm64/lib/copy_page.S
@@ -26,6 +26,7 @@ alternative_if ARM64_HAS_NO_HW_PREFETCH
 alternative_else_nop_endif
 
 #ifdef CONFIG_ARM64_MTE
+	arm64_set_arch armv8.5-a+memtag
 alternative_if_not ARM64_MTE
 	b	2f
 alternative_else_nop_endif
@@ -46,6 +47,7 @@ alternative_else_nop_endif
 	tst	x2, #(PAGE_SIZE - 1)
 	b.ne	1b
 2:
+	arm64_reset_arch
 #endif
 
 	ldp	x2, x3, [x1]
diff --git a/arch/arm64/lib/mte.S b/arch/arm64/lib/mte.S
index 45be04a8c73c..8f824fc62ad4 100644
--- a/arch/arm64/lib/mte.S
+++ b/arch/arm64/lib/mte.S
@@ -7,6 +7,8 @@
 #include <asm/assembler.h>
 #include <asm/mte.h>
 
+	arm64_set_arch armv8.5-a+memtag
+
 /*
  * Compare tags of two pages
  *   x0 - page1 address

-- 
Catalin
