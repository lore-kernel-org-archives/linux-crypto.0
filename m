From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 01/12] arm64: neon: replace generic definition of may_use_simd()
Date: Sat, 10 Jun 2017 16:22:47 +0000
Message-ID: <1497111778-4210-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
        will.deacon@arm.com, dave.martin@arm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:35985 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752070AbdFJQXI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 12:23:08 -0400
Received: by mail-wr0-f170.google.com with SMTP id v111so58814317wrc.3
        for <linux-crypto@vger.kernel.org>; Sat, 10 Jun 2017 09:23:08 -0700 (PDT)
In-Reply-To: <1497111778-4210-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In preparation of modifying the logic that decides whether kernel mode
NEON is allowable, which is required for SVE support, introduce an
implementation of may_use_simd() that reflects the current reality, i.e.,
that SIMD is allowed in any context.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/Kbuild |  1 -
 arch/arm64/include/asm/simd.h | 24 ++++++++++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index a7a97a608033..3c469b557ee8 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -31,7 +31,6 @@ generic-y += sembuf.h
 generic-y += serial.h
 generic-y += set_memory.h
 generic-y += shmbuf.h
-generic-y += simd.h
 generic-y += sizes.h
 generic-y += socket.h
 generic-y += sockios.h
diff --git a/arch/arm64/include/asm/simd.h b/arch/arm64/include/asm/simd.h
new file mode 100644
index 000000000000..f8aa7b3a0140
--- /dev/null
+++ b/arch/arm64/include/asm/simd.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (C) 2017 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+#ifndef __ASM_SIMD_H
+#define __ASM_SIMD_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+
+/*
+ * may_use_simd - whether it is allowable at this time to issue SIMD
+ *                instructions or access the SIMD register file
+ */
+static __must_check inline bool may_use_simd(void)
+{
+	return true;
+}
+
+#endif
-- 
2.7.4
