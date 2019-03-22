Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56761C10F10
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 308792075E
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728457AbfCVNUG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:20:06 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:40721 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728243AbfCVLWG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 07:22:06 -0400
Received: from [5.158.153.52] (helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1h7IFI-0000dn-5U; Fri, 22 Mar 2019 12:21:56 +0100
Date:   Fri, 22 Mar 2019 12:21:51 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next v9 01/19] asm: simd context helper API
In-Reply-To: <20190322071122.6677-2-Jason@zx2c4.com>
Message-ID: <alpine.DEB.2.21.1903221212310.1729@nanos.tec.linutronix.de>
References: <20190322071122.6677-1-Jason@zx2c4.com> <20190322071122.6677-2-Jason@zx2c4.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason,

On Fri, 22 Mar 2019, Jason A. Donenfeld wrote:
> index 000000000000..264ed84b41d8
> --- /dev/null
> +++ b/arch/arm/include/asm/simd.h
> @@ -0,0 +1,63 @@
> +/* SPDX-License-Identifier: GPL-2.0

The SPDX identifier has to be in a separate comment line.

/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Copyright (C) 2015-2018 Jason....
 */

Yes, it looks odd, but it's defined that way.

> +static __must_check inline bool simd_use(simd_context_t *ctx)
> +{
> +	if (!(*ctx & HAVE_FULL_SIMD))
> +		return false;
> +	if (*ctx & HAVE_SIMD_IN_USE)
> +		return true;
> +	kernel_neon_begin();
> +	*ctx |= HAVE_SIMD_IN_USE;
> +	return true;
> +}

> +static __must_check inline bool simd_use(simd_context_t *ctx)
> +{
> +	if (!(*ctx & HAVE_FULL_SIMD))
> +		return false;
> +	if (*ctx & HAVE_SIMD_IN_USE)
> +		return true;
> +	kernel_neon_begin();
> +	*ctx |= HAVE_SIMD_IN_USE;
> +	return true;
> +}

> +static __must_check inline bool simd_use(simd_context_t *ctx)
> +{
> +#if !defined(CONFIG_UML)
> +	if (!(*ctx & HAVE_FULL_SIMD))
> +		return false;
> +	if (*ctx & HAVE_SIMD_IN_USE)
> +		return true;
> +	kernel_fpu_begin();
> +	*ctx |= HAVE_SIMD_IN_USE;
> +	return true;
> +#else
> +	return false;
> +#endif
> +}

So now we have 3 almost identical copies of the same thing and x86/UM
handling it differently than the ARM(64) ones.

That can be completely avoided. Untested patch below.

Thanks,

	tglx

8<-------------
--- /dev/null
+++ b/arch/arm/include/asm/simd.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+#ifndef _ASM_SIMD_H
+#define _ASM_SIMD_H
+
+#ifdef CONFIG_KERNEL_MODE_NEON
+#include <asm/neon.h>
+
+static __must_check inline bool may_use_simd(void)
+{
+	return !in_nmi() && !in_irq() && !in_serving_softirq();
+}
+
+static inline void arch_simd_end(void)
+{
+	kernel_neon_end();
+}
+
+static inline void arch_simd_begin(void)
+{
+	kernel_neon_begin();
+}
+
+#else
+#include <asm-generic/simd.h>
+#endif
+
+#endif /* _ASM_SIMD_H */
--- a/arch/arm64/include/asm/simd.h
+++ b/arch/arm64/include/asm/simd.h
@@ -1,11 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright (C) 2017 Linaro Ltd. <ard.biesheuvel@linaro.org>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License version 2 as published
- * by the Free Software Foundation.
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
+#include <linux/simd.h>
 #ifndef __ASM_SIMD_H
 #define __ASM_SIMD_H
 
@@ -16,6 +15,8 @@
 #include <linux/types.h>
 
 #ifdef CONFIG_KERNEL_MODE_NEON
+#include <asm/neon.h>
+#include <asm/simd.h>
 
 DECLARE_PER_CPU(bool, kernel_neon_busy);
 
@@ -40,12 +41,18 @@ static __must_check inline bool may_use_
 		!this_cpu_read(kernel_neon_busy);
 }
 
-#else /* ! CONFIG_KERNEL_MODE_NEON */
+static inline void arch_simd_end(void)
+{
+	kernel_neon_end();
+}
 
-static __must_check inline bool may_use_simd(void) {
-	return false;
+static inline void arch_simd_begin(void)
+{
+	kernel_neon_begin();
 }
 
-#endif /* ! CONFIG_KERNEL_MODE_NEON */
+#else
+#include <asm-generic/simd.h>
+#endif
 
 #endif
--- a/arch/x86/include/asm/simd.h
+++ b/arch/x86/include/asm/simd.h
@@ -1,4 +1,12 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#ifndef _ASM_SIMD_H
+#define _ASM_SIMD_H
+
+#ifndef CONFIG_UML
 
 #include <asm/fpu/api.h>
 
@@ -10,3 +18,21 @@ static __must_check inline bool may_use_
 {
 	return irq_fpu_usable();
 }
+
+static inline void arch_simd_begin(void)
+{
+	kernel_fpu_begin();
+}
+
+static inline void arch_simd_end(void)
+{
+	kernel_fpu_end();
+}
+
+#else
+#include <asm-generic/simd.h>
+#endif
+
+#include <linux/simd.h>
+
+#endif /* _ASM_SIMD_H */
--- a/include/asm-generic/simd.h
+++ b/include/asm-generic/simd.h
@@ -1,7 +1,12 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+#ifndef _ASM_SIMD_H
+#define _ASM_SIMD_H
+
 #include <linux/hardirq.h>
 
+#define SIMD_GENERIC	1
+
 /*
  * may_use_simd - whether it is allowable at this time to issue SIMD
  *                instructions or access the SIMD register file
@@ -13,3 +18,10 @@ static __must_check inline bool may_use_
 {
 	return !in_interrupt();
 }
+
+static inline void arch_simd_begin(void) { }
+static inline void arch_simd_end(void) { }
+
+#include <linux/simd.h>
+
+#endif /* _ASM_SIMD_H */
--- /dev/null
+++ b/include/linux/simd.h
@@ -0,0 +1,82 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#ifndef _SIMD_H
+#define _SIMD_H
+
+typedef enum {
+	HAVE_NO_SIMD		= 1 << 0,
+	HAVE_FULL_SIMD		= 1 << 1,
+	HAVE_SIMD_IN_USE	= 1 << 31
+} simd_context_t;
+
+#define DONT_USE_SIMD ((simd_context_t []){ HAVE_NO_SIMD })
+
+#include <asm/simd.h>
+
+#ifndef SIMD_GENERIC
+
+#include <linux/sched.h>
+
+static inline bool simd_relax(simd_context_t *ctx)
+{
+#ifdef CONFIG_PREEMPT
+	if ((*ctx & HAVE_SIMD_IN_USE) && need_resched()) {
+		simd_put(ctx);
+		simd_get(ctx);
+		return true;
+	}
+#endif
+	return false;
+}
+
+static inline void simd_get(simd_context_t *ctx)
+{
+	*ctx = may_use_simd() ? HAVE_FULL_SIMD : HAVE_NO_SIMD;
+}
+
+static inline void simd_put(simd_context_t *ctx)
+{
+	if (*ctx & HAVE_SIMD_IN_USE)
+		arch_simd_end();
+
+	*ctx = HAVE_NO_SIMD;
+}
+
+static __must_check inline bool simd_use(simd_context_t *ctx)
+{
+	if (!(*ctx & HAVE_FULL_SIMD))
+		return false;
+	if (*ctx & HAVE_SIMD_IN_USE)
+		return true;
+	arch_simd_begin();
+	*ctx |= HAVE_SIMD_IN_USE;
+	return true;
+}
+
+#else /* !SIMD_GENERIC */
+
+static inline bool simd_relax(simd_context_t *ctx)
+{
+	return false;
+}
+
+static inline void simd_get(simd_context_t *ctx)
+{
+	*ctx = HAVE_NO_SIMD;
+}
+
+static inline void simd_put(simd_context_t *ctx)
+{
+}
+
+static __must_check inline bool simd_use(simd_context_t *ctx)
+{
+	return false;
+}
+
+#endif /* SIMD_GENERIC */
+
+#endif /* _SIMD_H */
