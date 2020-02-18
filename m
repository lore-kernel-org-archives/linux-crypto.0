Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995E7C3404B
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7419B21D56
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 20:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582056425;
	bh=uzY3qNW/TVXxIDrEpfAtWbrR6Pu6D9xU+6+meqsenkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TM4RBUjCRyjry4/DBoZEaaeKJHU5Z2UbC7UPm7s+QnUozq3eJxE1miwseNSmViuMv
	 ITrkYFYQwHRN0kzqusUDub5IzIymSQJ+B8eX3UXeOl3Ehf+4jVBKqY6gQwteQgwNR+
	 +nFNi7Ss1+KI4dWy6r+He6tyPaNjZpa1XXDWcBF4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgBRUHE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 15:07:04 -0500
Received: from foss.arm.com ([217.140.110.172]:60694 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbgBRT71 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:27 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 673131045;
        Tue, 18 Feb 2020 11:59:27 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE5963F68F;
        Tue, 18 Feb 2020 11:59:26 -0800 (PST)
From:   Mark Brown <broonie@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>
Subject: [PATCH 15/18] arm64: kvm: Modernize __smccc_workaround_1_smc_start annotations
Date:   Tue, 18 Feb 2020 19:58:39 +0000
Message-Id: <20200218195842.34156-16-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218195842.34156-1-broonie@kernel.org>
References: <20200218195842.34156-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In an effort to clarify and simplify the annotation of assembly functions
in the kernel new macros have been introduced. These replace ENTRY and
ENDPROC with separate annotations for standard C callable functions,
data and code with different calling conventions.

Using these for __smccc_workaround_1_smc is more involved than for most
symbols as this symbol is annotated quite unusually, rather than just have
the explicit symbol we define _start and _end symbols which we then use to
compute the length. This does not play at all nicely with the new style
macros. Instead define a constant for the size of the function and use that
in both the C code and for .org based size checks in the assembly code.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h |  4 ++++
 arch/arm64/kernel/cpu_errata.c   | 14 ++++++--------
 arch/arm64/kvm/hyp/hyp-entry.S   |  6 ++++--
 3 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 44a243754c1b..7c7eeeaab9fa 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -36,6 +36,8 @@
  */
 #define KVM_VECTOR_PREAMBLE	(2 * AARCH64_INSN_SIZE)
 
+#define __SMCCC_WORKAROUND_1_SMC_SZ 36
+
 #ifndef __ASSEMBLY__
 
 #include <linux/mm.h>
@@ -75,6 +77,8 @@ extern void __vgic_v3_init_lrs(void);
 
 extern u32 __kvm_get_mdcr_el2(void);
 
+extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
+
 /* Home-grown __this_cpu_{ptr,read} variants that always work at HYP */
 #define __hyp_this_cpu_ptr(sym)						\
 	({								\
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 0af2201cefda..6a2ca339741c 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -11,6 +11,7 @@
 #include <asm/cpu.h>
 #include <asm/cputype.h>
 #include <asm/cpufeature.h>
+#include <asm/kvm_asm.h>
 #include <asm/smp_plat.h>
 
 static bool __maybe_unused
@@ -113,9 +114,6 @@ atomic_t arm64_el2_vector_last_slot = ATOMIC_INIT(-1);
 DEFINE_PER_CPU_READ_MOSTLY(struct bp_hardening_data, bp_hardening_data);
 
 #ifdef CONFIG_KVM_INDIRECT_VECTORS
-extern char __smccc_workaround_1_smc_start[];
-extern char __smccc_workaround_1_smc_end[];
-
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
 {
@@ -163,9 +161,6 @@ static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 	raw_spin_unlock(&bp_lock);
 }
 #else
-#define __smccc_workaround_1_smc_start		NULL
-#define __smccc_workaround_1_smc_end		NULL
-
 static void install_bp_hardening_cb(bp_hardening_cb_t fn,
 				      const char *hyp_vecs_start,
 				      const char *hyp_vecs_end)
@@ -239,11 +234,14 @@ static int detect_harden_bp_fw(void)
 		smccc_end = NULL;
 		break;
 
+#if IS_ENABLED(CONFIG_KVM_ARM_HOST)
 	case SMCCC_CONDUIT_SMC:
 		cb = call_smc_arch_workaround_1;
-		smccc_start = __smccc_workaround_1_smc_start;
-		smccc_end = __smccc_workaround_1_smc_end;
+		smccc_start = __smccc_workaround_1_smc;
+		smccc_end = __smccc_workaround_1_smc +
+			__SMCCC_WORKAROUND_1_SMC_SZ;
 		break;
+#endif
 
 	default:
 		return -1;
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 1e2ab928a92f..c2a13ab3c471 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -322,7 +322,7 @@ SYM_CODE_END(__bp_harden_hyp_vecs)
 
 	.popsection
 
-ENTRY(__smccc_workaround_1_smc_start)
+SYM_CODE_START(__smccc_workaround_1_smc)
 	esb
 	sub	sp, sp, #(8 * 4)
 	stp	x2, x3, [sp, #(8 * 0)]
@@ -332,5 +332,7 @@ ENTRY(__smccc_workaround_1_smc_start)
 	ldp	x2, x3, [sp, #(8 * 0)]
 	ldp	x0, x1, [sp, #(8 * 2)]
 	add	sp, sp, #(8 * 4)
-ENTRY(__smccc_workaround_1_smc_end)
+1:	.org __smccc_workaround_1_smc + __SMCCC_WORKAROUND_1_SMC_SZ
+	.org 1b
+SYM_CODE_END(__smccc_workaround_1_smc)
 #endif
-- 
2.20.1

