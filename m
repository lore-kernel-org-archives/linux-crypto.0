From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/7] arm64: kernel: avoid executable literal pools
Date: Wed, 10 Jan 2018 12:11:36 +0000
Message-ID: <20180110121142.18291-2-ard.biesheuvel@linaro.org>
References: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au, will.deacon@arm.com,
        catalin.marinas@arm.com, marc.zyngier@arm.com,
        mark.rutland@arm.com, dann.frazier@canonical.com,
        steve.capper@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35092 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbeAJMLx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Jan 2018 07:11:53 -0500
Received: by mail-wm0-f67.google.com with SMTP id r78so1362071wme.0
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2018 04:11:53 -0800 (PST)
In-Reply-To: <20180110121142.18291-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Recent versions of GCC will emit literals into a separate .rodata section
rather than interspersed with the instruction stream. We disabled this
in commit 67dfa1751ce71 ("arm64: errata: Add -mpc-relative-literal-loads
to build flags"), because it uses adrp/add pairs to reference these
literals even when building with -mcmodel=large, which breaks module
loading when we have the mitigation for Cortex-A53 erratum #843419
enabled.

However, due to the recent discoveries regarding speculative execution,
we should avoid putting data into executable sections, to prevent
creating speculative gadgets inadvertently.

So set -mpc-relative-literal-loads only for modules, and only if the
A53 erratum is enabled.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index b481b4a7c011..bd7cb205e28a 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -26,7 +26,8 @@ ifeq ($(CONFIG_ARM64_ERRATUM_843419),y)
   ifeq ($(call ld-option, --fix-cortex-a53-843419),)
 $(warning ld does not support --fix-cortex-a53-843419; kernel may be susceptible to erratum)
   else
-LDFLAGS_vmlinux	+= --fix-cortex-a53-843419
+LDFLAGS_vmlinux		+= --fix-cortex-a53-843419
+KBUILD_CFLAGS_MODULE	+= $(call cc-option, -mpc-relative-literal-loads)
   endif
 endif
 
@@ -51,7 +52,6 @@ endif
 
 KBUILD_CFLAGS	+= -mgeneral-regs-only $(lseinstr) $(brokengasinst)
 KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables
-KBUILD_CFLAGS	+= $(call cc-option, -mpc-relative-literal-loads)
 KBUILD_AFLAGS	+= $(lseinstr) $(brokengasinst)
 
 KBUILD_CFLAGS	+= $(call cc-option,-mabi=lp64)
-- 
2.11.0
