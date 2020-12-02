Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE51AC71155
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 19:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 690BF22203
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Dec 2020 19:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726961AbgLBTzr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Dec 2020 14:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgLBTzq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Dec 2020 14:55:46 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F007C0613CF;
        Wed,  2 Dec 2020 11:55:06 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id i2so5387640wrs.4;
        Wed, 02 Dec 2020 11:55:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aNoM4IqXq01bkYqDeaXvKaD1icGKLJmAsZsYIC/EEjw=;
        b=ng8PX7be85fBIRDsqYE2zkD2KjoUUeYc3nYCTOsEBVAJgWXQ0EekJzJgDH1HvMJ58j
         Cd80zkjNPVpvceNPjFfhIAB2str7ZUgMPKnEO51TgO1CGDgo9LgprsveY9uDos85Wi2M
         pJwtqo/ecUIbBcQz63XmF8c5ZP6jpT+JWwYv4k7bKX1pxW806yXYJmNsAV0TIzadjcv8
         JsuVuzHJFDjZP8P4ISkLkZ+1vih8nbcOSh3gkf6r9cWGiHGsv47TLqgOkSL414hwGcao
         Ab23pYG/DdAUuFMJKhwhc27kQN+5KdFIcs+XDjyOH2XKp/AG4FcomOnjj6SOzoysQs+x
         KsUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aNoM4IqXq01bkYqDeaXvKaD1icGKLJmAsZsYIC/EEjw=;
        b=jm8St4hYjcEMdkNGg+NyDKdYzj5v/8K0ZDm0/swfEsn10dosr5vuYM00LgnFRMPtPk
         Ln4dk5idatMOIu3Li+ALefMh7tneIgTCYj3DuheRI530xwDGH1oAvDq1fI2HDe3YzHJp
         27jDDWH0wC+tuDtoX08JSGIGwkXl4cbAqYfJOYj79jdymiDabWhee1lZr0rS7LpIrJaK
         Zu7qkMqZgPIFNCTuhtdCkXG6pTv7N458EGcbvd6il4beIODe8df7Jc/Mr8l22Fk/eapG
         KLMgePFx804BVrlzTDnNJzvO8CZr8G2FXNd4XFsVdUQtwwb8aH0YXWtesZcJEri7GwSQ
         fUWw==
X-Gm-Message-State: AOAM530L06MnLfpGqUb6CT2MCJGrHsrUMiwACHUchhg+UNyQWmdrOYo2
        57MAirPESfzmMr6sW2oryCA=
X-Google-Smtp-Source: ABdhPJwqHIvBAF/G9nJcz8Xpe9GT5cHM1NQLRanGpFHTUuVOnBsdr0JkdgVIjMsZpZ5B6JhN+dvajA==
X-Received: by 2002:adf:ec0d:: with SMTP id x13mr5482267wrn.207.1606938904915;
        Wed, 02 Dec 2020 11:55:04 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id i11sm3277356wro.85.2020.12.02.11.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 11:55:04 -0800 (PST)
Date:   Wed, 2 Dec 2020 20:55:01 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: crypto: sun4i-ss: error with kmap
Message-ID: <20201202195501.GA29296@Red>
References: <20201201130102.GA23461@Red>
 <87ft4phcyx.fsf@nanos.tec.linutronix.de>
 <20201201135252.GA9584@Red>
 <87y2ihfw6z.fsf@nanos.tec.linutronix.de>
 <20201201144529.GA6786@Red>
 <87v9dlfthf.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9dlfthf.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 01, 2020 at 04:15:08PM +0100, Thomas Gleixner wrote:
> On Tue, Dec 01 2020 at 15:45, Corentin Labbe wrote:
> > On Tue, Dec 01, 2020 at 03:16:36PM +0100, Thomas Gleixner wrote:
> > In fact the warn was a bit later so I added:
> >        preempt_disable();
> >         idx = arch_kmap_local_unmap_idx(kmap_local_idx(), addr);
> > -       WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
> > +       if (WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx)))
> > +               pr_err("kunmap_local: vaddr %lx\n", (unsigned long) vaddr);
> >  
> >         arch_kmap_local_pre_unmap(addr);
> >         pte_clear(&init_mm, addr, kmap_pte - idx);
> >
> > and this give kunmap_local: vaddr ffefe000
> 
> which looks like a valid one.
> 
> Can you apply the patch below and add 'ftrace_dump_on_oops' on the
> command line or enable it in /proc/sys/kernel/ftrace_dump_on_oops before
> starting the test.
> 
> That should spill out the trace after crashing.
> 
> Thanks,
> 
>         tglx
> ---
> diff --git a/mm/highmem.c b/mm/highmem.c
> index b49364a306b8..461fe2c26107 100644
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
> @@ -578,6 +582,7 @@ void kunmap_local_indexed(void *vaddr)
>  
>  	preempt_disable();
>  	idx = arch_kmap_local_unmap_idx(kmap_local_idx(), addr);
> +	trace_printk("kunmap_local: %i %lx\n", idx, (unsigned long) vaddr);
>  	WARN_ON_ONCE(addr != __fix_to_virt(FIX_KMAP_BEGIN + idx));
>  
>  	arch_kmap_local_pre_unmap(addr);
> 

The result could be seen at http://kernel.montjoie.ovh/129768.log
The log is 9Mb, but the ftrace dump seems not terminated, tell me if you need more.

Regards
