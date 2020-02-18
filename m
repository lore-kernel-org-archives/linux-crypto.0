Return-Path: <SRS0=0S/Q=4G=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7013BC3404B
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4864424670
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Feb 2020 19:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582055967;
	bh=j3UIKZlwavp3+EwC11Ly/4J9ZTYUGCphJQVnMqeeRzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=o14h7uPoRynRJsxhtLZdu+Dv+bAG3PB5lWAc7eol33lppmb+9AMJFXzi7wXVvJcl4
	 67GwBIXD9i+bsESpN0hbjDPtUu25MmfnUmAKLlhWgYAGrjeX0buW2VQ66gG2Q84Uoz
	 0F1Cyp94mrcdTigdUVUYA7rczwTZdDM2b4zo4AE0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgBRT70 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Feb 2020 14:59:26 -0500
Received: from foss.arm.com ([217.140.110.172]:60674 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727872AbgBRT7Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Feb 2020 14:59:25 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E7DE31B;
        Tue, 18 Feb 2020 11:59:25 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A57833F68F;
        Tue, 18 Feb 2020 11:59:24 -0800 (PST)
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
Subject: [PATCH 14/18] arm64: kvm: Modernize annotation for __bp_harden_hyp_vecs
Date:   Tue, 18 Feb 2020 19:58:38 +0000
Message-Id: <20200218195842.34156-15-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218195842.34156-1-broonie@kernel.org>
References: <20200218195842.34156-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We have recently introduced new macros for annotating assembly symbols
for things that aren't C functions, SYM_CODE_START() and SYM_CODE_END(),
in an effort to clarify and simplify our annotations of assembly files.

Using these for __bp_harden_hyp_vecs is more involved than for most symbols
as this symbol is annotated quite unusually as rather than just have the
explicit symbol we define _start and _end symbols which we then use to
compute the length. This does not play at all nicely with the new style
macros. Since the size of the vectors is a known constant which won't vary
the simplest thing to do is simply to drop the separate _start and _end
symbols and just use a #define for the size.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_mmu.h | 9 ++++-----
 arch/arm64/include/asm/mmu.h     | 4 +++-
 arch/arm64/kernel/cpu_errata.c   | 2 +-
 arch/arm64/kvm/hyp/hyp-entry.S   | 6 ++++--
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 53d846f1bfe7..b5f723cf9599 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -480,7 +480,7 @@ static inline void *kvm_get_hyp_vector(void)
 	int slot = -1;
 
 	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR) && data->fn) {
-		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs_start));
+		vect = kern_hyp_va(kvm_ksym_ref(__bp_harden_hyp_vecs));
 		slot = data->hyp_vectors_slot;
 	}
 
@@ -509,14 +509,13 @@ static inline int kvm_map_vectors(void)
 	 *  HBP +  HEL2 -> use hardened vertors and use exec mapping
 	 */
 	if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR)) {
-		__kvm_bp_vect_base = kvm_ksym_ref(__bp_harden_hyp_vecs_start);
+		__kvm_bp_vect_base = kvm_ksym_ref(__bp_harden_hyp_vecs);
 		__kvm_bp_vect_base = kern_hyp_va(__kvm_bp_vect_base);
 	}
 
 	if (cpus_have_const_cap(ARM64_HARDEN_EL2_VECTORS)) {
-		phys_addr_t vect_pa = __pa_symbol(__bp_harden_hyp_vecs_start);
-		unsigned long size = (__bp_harden_hyp_vecs_end -
-				      __bp_harden_hyp_vecs_start);
+		phys_addr_t vect_pa = __pa_symbol(__bp_harden_hyp_vecs);
+		unsigned long size = __BP_HARDEN_HYP_VECS_SZ;
 
 		/*
 		 * Always allocate a spare vector slot, as we don't
diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index e4d862420bb4..a3324d6ccbfe 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -13,6 +13,7 @@
 #define TTBR_ASID_MASK	(UL(0xffff) << 48)
 
 #define BP_HARDEN_EL2_SLOTS 4
+#define __BP_HARDEN_HYP_VECS_SZ (BP_HARDEN_EL2_SLOTS * SZ_2K)
 
 #ifndef __ASSEMBLY__
 
@@ -45,7 +46,8 @@ struct bp_hardening_data {
 
 #if (defined(CONFIG_HARDEN_BRANCH_PREDICTOR) ||	\
      defined(CONFIG_HARDEN_EL2_VECTORS))
-extern char __bp_harden_hyp_vecs_start[], __bp_harden_hyp_vecs_end[];
+
+extern char __bp_harden_hyp_vecs[];
 extern atomic_t arm64_el2_vector_last_slot;
 #endif  /* CONFIG_HARDEN_BRANCH_PREDICTOR || CONFIG_HARDEN_EL2_VECTORS */
 
diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 703ad0a84f99..0af2201cefda 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -119,7 +119,7 @@ extern char __smccc_workaround_1_smc_end[];
 static void __copy_hyp_vect_bpi(int slot, const char *hyp_vecs_start,
 				const char *hyp_vecs_end)
 {
-	void *dst = lm_alias(__bp_harden_hyp_vecs_start + slot * SZ_2K);
+	void *dst = lm_alias(__bp_harden_hyp_vecs + slot * SZ_2K);
 	int i;
 
 	for (i = 0; i < SZ_2K; i += 0x80)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 0aea8f9ab23d..1e2ab928a92f 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -312,11 +312,13 @@ alternative_cb_end
 .endm
 
 	.align	11
-ENTRY(__bp_harden_hyp_vecs_start)
+SYM_CODE_START(__bp_harden_hyp_vecs)
 	.rept BP_HARDEN_EL2_SLOTS
 	generate_vectors
 	.endr
-ENTRY(__bp_harden_hyp_vecs_end)
+1:	.org __bp_harden_hyp_vecs + __BP_HARDEN_HYP_VECS_SZ
+	.org 1b
+SYM_CODE_END(__bp_harden_hyp_vecs)
 
 	.popsection
 
-- 
2.20.1

