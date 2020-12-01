Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905BFC64E7A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 15:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21B012076C
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 15:16:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ltmVNyD5";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QBKJlVkR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390203AbgLAPPw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 10:15:52 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:56046 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391549AbgLAPPu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 10:15:50 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606835708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MsXeMQ47McPWqbbEZn2X1D+kqQzuS1hMi5EWz6bK4Uk=;
        b=ltmVNyD5+BvygaqiVzK9ZDnlWMHSHNWaEdbeBa/nCER1t70kyWNVzPR0tTfKoKbuz2ckOW
        3sdqC1NViFTOc7/gUiRJxWVTA4z0T5m+F1RyfcOZ7PI8ECg7U6mkigKfSf1MhEeA1RH1CE
        N0vBE5R0qr7QH/VJWkIQ0O3xGPzHpZ14Khf3rBfSVj6+2Zba3KGkRILFLaodwxMoACYXtn
        HUBcRPQ5exM87SOYSrkOs+paa6pXvU2O61q9AKmpsDZ958x/wN0SKY4W90n44L45kkHEFS
        L9BjAmFnWRFcIwc+5ifL0EgllhsqunL84C41w2nBlx6iM2O+IQSW0LJhB1127Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606835708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MsXeMQ47McPWqbbEZn2X1D+kqQzuS1hMi5EWz6bK4Uk=;
        b=QBKJlVkRNcyH0Bclc71acDWFd6u6gDY9f+B8NvXAq9eLz9HdL+JvO4FyI1FZ8kaogqW+VB
        s9M/ut+0Uo77xIAQ==
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: crypto: sun4i-ss: error with kmap
In-Reply-To: <20201201144529.GA6786@Red>
References: <20201201130102.GA23461@Red> <87ft4phcyx.fsf@nanos.tec.linutronix.de> <20201201135252.GA9584@Red> <87y2ihfw6z.fsf@nanos.tec.linutronix.de> <20201201144529.GA6786@Red>
Date:   Tue, 01 Dec 2020 16:15:08 +0100
Message-ID: <87v9dlfthf.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 01 2020 at 15:45, Corentin Labbe wrote:
> On Tue, Dec 01, 2020 at 03:16:36PM +0100, Thomas Gleixner wrote:
> In fact the warn was a bit later so I added:
>        preempt_disable();
>         idx = arch_kmap_local_unmap_idx(kmap_local_idx(), addr);
> -       WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
> +       if (WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx)))
> +               pr_err("kunmap_local: vaddr %lx\n", (unsigned long) vaddr);
>  
>         arch_kmap_local_pre_unmap(addr);
>         pte_clear(&init_mm, addr, kmap_pte - idx);
>
> and this give kunmap_local: vaddr ffefe000

which looks like a valid one.

Can you apply the patch below and add 'ftrace_dump_on_oops' on the
command line or enable it in /proc/sys/kernel/ftrace_dump_on_oops before
starting the test.

That should spill out the trace after crashing.

Thanks,

        tglx
---
diff --git a/mm/highmem.c b/mm/highmem.c
index b49364a306b8..461fe2c26107 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -485,6 +485,7 @@ static inline bool kmap_high_unmap_local(unsigned long vaddr)
 {
 #ifdef ARCH_NEEDS_KMAP_HIGH_GET
 	if (vaddr >= PKMAP_ADDR(0) && vaddr < PKMAP_ADDR(LAST_PKMAP)) {
+		trace_printk("kunmap_high: %lx\n", vaddr);
 		kunmap_high(pte_page(pkmap_page_table[PKMAP_NR(vaddr)]));
 		return true;
 	}
@@ -520,6 +521,7 @@ void *__kmap_local_pfn_prot(unsigned long pfn, pgprot_t prot)
 	preempt_disable();
 	idx = arch_kmap_local_map_idx(kmap_local_idx_push(), pfn);
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
+	trace_printk("kmap_local_pfn: %d %lx\n", idx, (unsigned long) vaddr);
 	BUG_ON(!pte_none(*(kmap_pte - idx)));
 	pteval = pfn_pte(pfn, prot);
 	set_pte_at(&init_mm, vaddr, kmap_pte - idx, pteval);
@@ -545,8 +547,10 @@ void *__kmap_local_page_prot(struct page *page, pgprot_t prot)
 
 	/* Try kmap_high_get() if architecture has it enabled */
 	kmap = arch_kmap_local_high_get(page);
-	if (kmap)
+	if (kmap) {
+		trace_printk("kmap_local_high_get: %lx\n", (unsigned long) kmap);
 		return kmap;
+	}
 
 	return __kmap_local_pfn_prot(page_to_pfn(page), prot);
 }
@@ -578,6 +582,7 @@ void kunmap_local_indexed(void *vaddr)
 
 	preempt_disable();
 	idx = arch_kmap_local_unmap_idx(kmap_local_idx(), addr);
+	trace_printk("kunmap_local: %i %lx\n", idx, (unsigned long) vaddr);
 	WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
 
 	arch_kmap_local_pre_unmap(addr);

