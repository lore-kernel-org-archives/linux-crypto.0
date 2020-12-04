Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D54DC433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 20:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4E3522B4E
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 20:59:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgLDU7F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Dec 2020 15:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgLDU7E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Dec 2020 15:59:04 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6FDC0613D1;
        Fri,  4 Dec 2020 12:58:24 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607115502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rXljD59g1oVzJ9jF+FjoI9sRZm03SEV2p7bFgHFt2DM=;
        b=gt3Mr97/2vciv5YdoyaFRsmoYE/JGQYVgEhXOS2jFNU4afDXtiJJQI8FWmNpgJ6232PVlM
        GF791/vksstqewuQU46P6xpGfZ8T+iLIccS+vR4lTC/23LjbTn7pMJTl+1UL6bsZV88292
        3DbVKsgQLL6la4/SVV1xF2parMH1WoDTG08eytykPyy4lHp0gmoovXm2klpgAUkBTyWFsH
        TP0Ql8ntELb1pWzWt0u8yKP6hJr1eKH5TUttYLzWO4wEF6OxRJAVNxyO2Hn+ON7dCU0E/G
        Fj09D1Ioe4mtWW/RXmXUKbiw3J4XwGvdpNN9JyLT4v64tXxiNGWhXnAuHfBlaQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607115502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rXljD59g1oVzJ9jF+FjoI9sRZm03SEV2p7bFgHFt2DM=;
        b=Ycrbek5/gf/49CBynySmzpUCfaHCA9bnz4vO95QH88mYYX/3lLMxH3GqpBELPbH+wvXO3a
        9mGaGDJXqV59A6DQ==
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>
Subject: Re: crypto: sun4i-ss: error with kmap
In-Reply-To: <20201204192753.GA19782@Red>
References: <20201201135252.GA9584@Red> <87y2ihfw6z.fsf@nanos.tec.linutronix.de> <20201201144529.GA6786@Red> <87v9dlfthf.fsf@nanos.tec.linutronix.de> <20201202195501.GA29296@Red> <877dpzexfr.fsf@nanos.tec.linutronix.de> <20201203173846.GA16207@Red> <87r1o6bh1u.fsf@nanos.tec.linutronix.de> <20201204132631.GA25321@Red> <874kl1bod0.fsf@nanos.tec.linutronix.de> <20201204192753.GA19782@Red>
Date:   Fri, 04 Dec 2020 21:58:21 +0100
Message-ID: <87wnxx9tle.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 04 2020 at 20:27, Corentin Labbe wrote:
> On Fri, Dec 04, 2020 at 04:08:27PM +0100, Thomas Gleixner wrote:
>> On Fri, Dec 04 2020 at 14:26, Corentin Labbe wrote:
>> > On Fri, Dec 04, 2020 at 12:34:05AM +0100, Thomas Gleixner wrote:
>> >> The unmap comes from sg_miter_stop() and looking at the previous
>> >> map/unmap cycles there are never nested maps.
>> >> 
>> >> [  996.943030] cryptset-316       0d..4 73943317us : __kmap_local_pfn_prot: kmap_local_pfn: 1 ffefd000
>> >> 
>> >> is the first event which allocates a nested map. 
>> >> 
>> >> So something goes south either in sg_miter or in the crypto maze.
>> >> 
>> >> Enabling CONFIG_DEBUG_KMAP_LOCAL and function tracing might give us more clue.
>> >
>> > Done, http://kernel.montjoie.ovh/130466.log
>> 
>> Does not provide more information with the debug enabled. So can you
>> please enable CONFIG_FUNCTION_TRACER and add 'ftrace=function' to the
>> command line?
>
> Done, http://kernel.montjoie.ovh/130490.log

Aaargh. That overwrites everything while printing out that
warning.

Can you please replace the debug patch with the one below and try again?
That stops the trace right on the condition.

Thanks,

        tglx
---
diff --git a/mm/highmem.c b/mm/highmem.c
index b49364a306b8..8f8862f79d23 100644
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
@@ -578,7 +582,11 @@ void kunmap_local_indexed(void *vaddr)
 
 	preempt_disable();
 	idx = arch_kmap_local_unmap_idx(kmap_local_idx(), addr);
-	WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
+	trace_printk("kunmap_local: %i %lx\n", idx, (unsigned long) vaddr);
+	if (addr != __fix_to_virt(FIX_KMAP_BEGIN + idx)) {
+		tracing_off();
+		BUG();
+	}
 
 	arch_kmap_local_pre_unmap(addr);
 	pte_clear(&init_mm, addr, kmap_pte - idx);

