Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2084EC4708D
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Dec 2022 10:39:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiLGKj5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Dec 2022 05:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiLGKjz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Dec 2022 05:39:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E7EB96
        for <linux-crypto@vger.kernel.org>; Wed,  7 Dec 2022 02:39:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25C5A612B7
        for <linux-crypto@vger.kernel.org>; Wed,  7 Dec 2022 10:39:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E7AC433D7;
        Wed,  7 Dec 2022 10:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670409593;
        bh=36YqQnOtNbUcTuWjMaDed0znfLGCdnAv3m9xyuWbSXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpOntchcb/BjKuYFzbkI72PcqkLOWGTs7yWmlHb9uwAyP5eAuhImrbOILLECobrnf
         kmAaRTu0MPFpgM81RRY4onOsdSOVYph+clKOcWO1giiRWif17+6TMGUukd07+5ag/6
         Zeg1an9p1WXRLlscvhS1a8X7CLgFX2xeWpV+KN7Dy0ysW0pYkT6Gi1CE+jbKUczirk
         8xWGhn93hGxziAGpKT4ggR9FTIAktPKG+is4liHzCe2eE/PLlUSTB79iOX0nEeNWOg
         Ik7/bigwdF4IvVc8Ho7PRz2A6/5mgvkVbAUgLYtrRckNh2F0Y4ZPZFbNVlE4b1Gp/z
         Caq8pnfQnfW9A==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk
Cc:     linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH v2 2/2] ARM: permit non-nested kernel mode NEON in softirq context
Date:   Wed,  7 Dec 2022 11:39:36 +0100
Message-Id: <20221207103936.2198407-3-ardb@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221207103936.2198407-1-ardb@kernel.org>
References: <20221207103936.2198407-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2672; i=ardb@kernel.org; h=from:subject; bh=36YqQnOtNbUcTuWjMaDed0znfLGCdnAv3m9xyuWbSXQ=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBjkG1nbMBKGcpxvDP1xaATdLbbvNcgx0uP63Vp8/Kd oyMBLy+JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY5BtZwAKCRDDTyI5ktmPJFr7C/ 4zG0d1Qfu4iWKy50r3Mru2HgU59zvrANrytytJUxsNJGc3Y7Cuc17Qd++YkZRhLSRWJrDAw4MBjty4 w/yZeVXQc6FB042MvUV4+n5MZQdeLH2KUqOZmNbhQdmGz18gma779rpMkeTaPOmBB4EYtiab6tuL0T VUbR2GAWQoS+WEnE5vgoa5ERpuVqo4U2DmDVwzFH0aZDtD7cuNoQc7wDdGgkhZdIn4C4UHfzlx8Ml2 sBvGdpbfMo3h46cHDbIqAcybT1TiL4FSkDFgU0ILnATv09/5MVyDAcd46BxQCj6kJshIAFBE9af8v/ h2JuUPqF+pVOSDTHh98E7IJMCC2lriAKAnWoUETboNJfltSSIuU3e+X07Dxl9bl6qpE18NcQFt7v1W 4bHaigetdBQ6YqElgqx7PI2r8qB+d6pbgJKCqDs535Eh0YNH/I1QtnWXGLAAFQMG1W/vD0V2BWSIKm 84CXN0WRxWxqB4lWgV2+Tw4IZA78xHUguyiFrl9pJCjl8=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We currently only permit kernel mode NEON in process context, to avoid
the need to preserve/restore the NEON register file when taking an
exception while running in the kernel.

Like we did on arm64, we can relax this restriction substantially, by
permitting kernel mode NEON from softirq context, while ensuring that
softirq processing is disabled when the NEON is being used in task
context. This guarantees that only NEON context belonging to user space
needs to be preserved and restored, which is already taken care of.

This is especially relevant for network encryption, where incoming
frames are typically handled in softirq context, and deferring software
decryption to a kernel thread or falling back to C code are both
undesirable from a performance PoV.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/simd.h |  8 ++++++++
 arch/arm/vfp/vfpmodule.c    | 13 ++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/simd.h b/arch/arm/include/asm/simd.h
new file mode 100644
index 0000000000000000..82191dbd7e78a036
--- /dev/null
+++ b/arch/arm/include/asm/simd.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/hardirq.h>
+
+static __must_check inline bool may_use_simd(void)
+{
+	return IS_ENABLED(CONFIG_KERNEL_MODE_NEON) && !in_hardirq();
+}
diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 8f5bc672b4aac04a..4e1a786df76df157 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -723,12 +723,12 @@ void kernel_neon_begin(void)
 	local_bh_disable();
 
 	/*
-	 * Kernel mode NEON is only allowed outside of interrupt context
-	 * with preemption disabled. This will make sure that the kernel
-	 * mode NEON register contents never need to be preserved.
+	 * Kernel mode NEON is only allowed outside of hardirq context with
+	 * preemption and softirq processing disabled. This will make sure that
+	 * the kernel mode NEON register contents never need to be preserved.
 	 */
-	BUG_ON(in_interrupt());
-	cpu = get_cpu();
+	BUG_ON(in_hardirq());
+	cpu = __smp_processor_id();
 
 	fpexc = fmrx(FPEXC) | FPEXC_EN;
 	fmxr(FPEXC, fpexc);
@@ -744,7 +744,6 @@ void kernel_neon_begin(void)
 		vfp_save_state(vfp_current_hw_state[cpu], fpexc);
 #endif
 	vfp_current_hw_state[cpu] = NULL;
-	local_bh_enable();
 }
 EXPORT_SYMBOL(kernel_neon_begin);
 
@@ -752,7 +751,7 @@ void kernel_neon_end(void)
 {
 	/* Disable the NEON/VFP unit. */
 	fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
-	put_cpu();
+	local_bh_enable();
 }
 EXPORT_SYMBOL(kernel_neon_end);
 
-- 
2.35.1

