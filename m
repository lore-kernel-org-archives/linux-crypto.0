Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB1DC4167B
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Dec 2020 18:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EFAD22E00
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Dec 2020 18:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728162AbgLESo0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Dec 2020 13:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727039AbgLESoV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Dec 2020 13:44:21 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564DEC0613D1;
        Sat,  5 Dec 2020 10:43:40 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id h21so9945777wmb.2;
        Sat, 05 Dec 2020 10:43:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xy8pTkIM3V0NC8hsWJahqGP6V2oO9J48tUSWZxlA9uk=;
        b=ZC0wB4xOfrZGXbQAYkwSKi5ecx7lxC5Vf4+MXSsx4L7QUjRw4dfdEiQ8MIPjAiBNgn
         vGLaRLq9GDAwwVjdTIE3mb6aa8BdM5f0ozv+eGRpnvq+rMgpgoaf5eXNtd+XcdO1efkI
         q4apFVhyQ4I2JjN3jjJzcVbbnVijKtGUyNC9WtR2Ye91BioAlGYWa4M+4gCiXsmu4Eb+
         urVod55S1VNcUvoxhkXZYS/Dg+8NDwuy4KoHjDqd8APLAa5jUepNnZwhMdAo9NeXwJLc
         5MuUYSuHiB7Vf/Kplln2nrwITqqVXiajQRpn6Iu2ZUsPQ+GqGcliBEK3zoqcc9/8Mi1w
         9oJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xy8pTkIM3V0NC8hsWJahqGP6V2oO9J48tUSWZxlA9uk=;
        b=qkHllk2pMS5xXWDCsE0s/G7J6e8OQGfYe6iD4wfVoYxne2uk9FcJ+LvZL5zpH7URuI
         MbkFl5s9gMxkm+Vz+0Mmt+JLHRNt2TQgvnVvxUc7cTe1I7QN/qlnROy9l9xN8fCR1FG2
         UbAHxzcJkUwIffdFCw7YHNIpAMVFJNe4DrE3OQw888JIBBUtDNftuoPLjxx9WxA08WZ0
         weqfEHX+dn7PUDUWTFeZiMyQJmjWuaUYJpD+fEcSjBNnaZASuq8JnDQzMb22dPBaIYPq
         XIFUA7IK9N/KzCaVAx04TBvD1+wYOAiYdhN93tMH+bngnEUTLOGUIIPsKV1J+9SEL0k3
         hleA==
X-Gm-Message-State: AOAM5307BZk5RWWIGU+NqMkSbaUAJ1h52/oCLxO1p3ZE+BgIqhtQUk+X
        hjnyve+KQtAIEUv7P7Z1cls=
X-Google-Smtp-Source: ABdhPJwSK1RomPg3IX344esDcP0wSct5ZEkZlRVcgy1IeoI9W66W/Q0BTNxSa5aKL27jcKYmnyX4yQ==
X-Received: by 2002:a1c:7c09:: with SMTP id x9mr10401089wmc.98.1607193819114;
        Sat, 05 Dec 2020 10:43:39 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id j6sm8401536wrq.38.2020.12.05.10.43.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Dec 2020 10:43:38 -0800 (PST)
Date:   Sat, 5 Dec 2020 19:43:34 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>
Subject: Re: crypto: sun4i-ss: error with kmap
Message-ID: <20201205184334.GA8034@Red>
References: <20201201144529.GA6786@Red>
 <87v9dlfthf.fsf@nanos.tec.linutronix.de>
 <20201202195501.GA29296@Red>
 <877dpzexfr.fsf@nanos.tec.linutronix.de>
 <20201203173846.GA16207@Red>
 <87r1o6bh1u.fsf@nanos.tec.linutronix.de>
 <20201204132631.GA25321@Red>
 <874kl1bod0.fsf@nanos.tec.linutronix.de>
 <20201204192753.GA19782@Red>
 <87wnxx9tle.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wnxx9tle.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 04, 2020 at 09:58:21PM +0100, Thomas Gleixner wrote:
> On Fri, Dec 04 2020 at 20:27, Corentin Labbe wrote:
> > On Fri, Dec 04, 2020 at 04:08:27PM +0100, Thomas Gleixner wrote:
> >> On Fri, Dec 04 2020 at 14:26, Corentin Labbe wrote:
> >> > On Fri, Dec 04, 2020 at 12:34:05AM +0100, Thomas Gleixner wrote:
> >> >> The unmap comes from sg_miter_stop() and looking at the previous
> >> >> map/unmap cycles there are never nested maps.
> >> >> 
> >> >> [  996.943030] cryptset-316       0d..4 73943317us : __kmap_local_pfn_prot: kmap_local_pfn: 1 ffefd000
> >> >> 
> >> >> is the first event which allocates a nested map. 
> >> >> 
> >> >> So something goes south either in sg_miter or in the crypto maze.
> >> >> 
> >> >> Enabling CONFIG_DEBUG_KMAP_LOCAL and function tracing might give us more clue.
> >> >
> >> > Done, http://kernel.montjoie.ovh/130466.log
> >> 
> >> Does not provide more information with the debug enabled. So can you
> >> please enable CONFIG_FUNCTION_TRACER and add 'ftrace=function' to the
> >> command line?
> >
> > Done, http://kernel.montjoie.ovh/130490.log
> 
> Aaargh. That overwrites everything while printing out that
> warning.
> 
> Can you please replace the debug patch with the one below and try again?
> That stops the trace right on the condition.
> 
> Thanks,
> 
>         tglx
> ---
> diff --git a/mm/highmem.c b/mm/highmem.c
> index b49364a306b8..8f8862f79d23 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -485,6 +485,7 @@ static inline bool kmap_high_unmap_local(unsigned long vaddr)
>  {
>  #ifdef ARCH_NEEDS_KMAP_HIGH_GET
>  	if (vaddr >= PKMAP_ADDR(0) && vaddr < PKMAP_ADDR(LAST_PKMAP)) {
> +		trace_printk("kunmap_high: %lx\n", vaddr);
>  		kunmap_high(pte_page(pkmap_page_table[PKMAP_NR(vaddr)]));
>  		return true;
>  	}
> @@ -520,6 +521,7 @@ void *__kmap_local_pfn_prot(unsigned long pfn, pgprot_t prot)
>  	preempt_disable();
>  	idx = arch_kmap_local_map_idx(kmap_local_idx_push(), pfn);
>  	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
> +	trace_printk("kmap_local_pfn: %d %lx\n", idx, (unsigned long) vaddr);
>  	BUG_ON(!pte_none(*(kmap_pte - idx)));
>  	pteval = pfn_pte(pfn, prot);
>  	set_pte_at(&init_mm, vaddr, kmap_pte - idx, pteval);
> @@ -545,8 +547,10 @@ void *__kmap_local_page_prot(struct page *page, pgprot_t prot)
>  
>  	/* Try kmap_high_get() if architecture has it enabled */
>  	kmap = arch_kmap_local_high_get(page);
> -	if (kmap)
> +	if (kmap) {
> +		trace_printk("kmap_local_high_get: %lx\n", (unsigned long) kmap);
>  		return kmap;
> +	}
>  
>  	return __kmap_local_pfn_prot(page_to_pfn(page), prot);
>  }
> @@ -578,7 +582,11 @@ void kunmap_local_indexed(void *vaddr)
>  
>  	preempt_disable();
>  	idx = arch_kmap_local_unmap_idx(kmap_local_idx(), addr);
> -	WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
> +	trace_printk("kunmap_local: %i %lx\n", idx, (unsigned long) vaddr);
> +	if (addr != __fix_to_virt(FIX_KMAP_BEGIN + idx)) {
> +		tracing_off();
> +		BUG();
> +	}
>  
>  	arch_kmap_local_pre_unmap(addr);
>  	pte_clear(&init_mm, addr, kmap_pte - idx);
> 

Hello, the result could be found at http://kernel.montjoie.ovh/130739.log

Thanks
