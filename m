Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DED3C433FE
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Dec 2020 20:17:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06DEA2311B
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Dec 2020 20:17:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725863AbgLEURM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Dec 2020 15:17:12 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:53822 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725270AbgLEURM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Dec 2020 15:17:12 -0500
X-IronPort-AV: E=Sophos;i="5.78,395,1599516000"; 
   d="scan'208";a="481316044"
Received: from 173.121.68.85.rev.sfr.net (HELO hadrien) ([85.68.121.173])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Dec 2020 21:16:04 +0100
Date:   Sat, 5 Dec 2020 21:16:04 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     Thomas Gleixner <tglx@linutronix.de>
cc:     Corentin Labbe <clabbe.montjoie@gmail.com>,
        herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-mm@kvack.org, Andrew Morton <akpm@linuxfoundation.org>
Subject: Re: crypto: sun4i-ss: error with kmap
In-Reply-To: <87mtys8268.fsf@nanos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.22.394.2012052115430.2754@hadrien>
References: <20201201144529.GA6786@Red> <87v9dlfthf.fsf@nanos.tec.linutronix.de> <20201202195501.GA29296@Red> <877dpzexfr.fsf@nanos.tec.linutronix.de> <20201203173846.GA16207@Red> <87r1o6bh1u.fsf@nanos.tec.linutronix.de> <20201204132631.GA25321@Red>
 <874kl1bod0.fsf@nanos.tec.linutronix.de> <20201204192753.GA19782@Red> <87wnxx9tle.fsf@nanos.tec.linutronix.de> <20201205184334.GA8034@Red> <87mtys8268.fsf@nanos.tec.linutronix.de>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Sat, 5 Dec 2020, Thomas Gleixner wrote:

> Corentin,
>
> On Sat, Dec 05 2020 at 19:43, Corentin Labbe wrote:
> > On Fri, Dec 04, 2020 at 09:58:21PM +0100, Thomas Gleixner wrote:
> >> Can you please replace the debug patch with the one below and try again?
> >> That stops the trace right on the condition.
> >
> > Hello, the result could be found at http://kernel.montjoie.ovh/130739.log
>
> Thanks for providing this. This is clearly showing where stuff goes
> wrong. It starts here at 729.550001. I removed the uninteresting parts:
>
> 0d..2 147103293us : __kmap_local_page_prot <-sg_miter_next
> 0d..3 147103308us :__kmap_local_pfn_prot: kmap_local_pfn: 1 ffefd000
>
> 0d..3 147103311us : __kmap_local_page_prot <-sg_miter_next
> 0d..4 147103325us : __kmap_local_pfn_prot: kmap_local_pfn: 3 ffefb000
>
> 0d..3 147103429us : kunmap_local_indexed <-sg_miter_stop
> 0d..4 147103433us : kunmap_local_indexed: kunmap_local: 3 ffefd000
>
> So this maps two pages and unmaps the first one. That's all called from
> sun4i_ss_opti_poll() and the bug is clearly visible there:
>
> 	sg_miter_next(&mi);
> 	sg_miter_next(&mo);
>
> release_ss:
> 	sg_miter_stop(&mi);
> 	sg_miter_stop(&mo);
>
> Written by yourself :) Same issue in sun4i_ss_cipher_poll()
>
> Fix below.
>
> Julia, it might be worth to have a coccinelle check for that. It's the
> only place which got it wrong, but this goes unnoticed when code is
> e.g. only fully tested on 64bit or as in this case never tested with
> full debugging enabled. The whole kmap_atomic and kmap_local (new in
> next) family and all users like the sg_miter stuff are affected by this.

OK, thanks for the suggestion.  I will look into it.

julia

>
> Thanks,
>
>         tglx
> ---
> Subject: crypto: sun4i-ss - Fix sg_miter_stop() ordering
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Sat, 05 Dec 2020 20:17:28 +0100
>
> sun4i_ss_opti_poll() and sun4i_ss_cipher_poll() do:
>
>         sg_miter_next(&mi);
>         sg_miter_next(&mo);
> 	...
>         sg_miter_stop(&mi);
>         sg_miter_stop(&mo);
>
> which is the wrong order because sg_miter_next() maps a page with
> kmap_atomic() and sg_miter_stop() unmaps it. kmap_atomic() uses a stack
> internaly which requires that the nested map is unmapped first. As this
> uses the wrong order it triggers the warning in kunmap_local_indexed()
> which checks the to be unmapped address and subsequently crashes.
>
> This went unnoticed for 5 years because the ARM kmap_atomic()
> implementation had the warning conditional on CONFIG_DEBUG_HIGHMEM which
> was obviously never enabled when testing that driver.
>
> Flip the order to cure it.
>
> Reported-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> --- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> +++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
> @@ -109,8 +109,8 @@ static int noinline_for_stack sun4i_ss_o
>  	}
>
>  release_ss:
> -	sg_miter_stop(&mi);
>  	sg_miter_stop(&mo);
> +	sg_miter_stop(&mi);
>  	writel(0, ss->base + SS_CTL);
>  	spin_unlock_irqrestore(&ss->slock, flags);
>  	return err;
> @@ -333,8 +333,8 @@ static int sun4i_ss_cipher_poll(struct s
>  	}
>
>  release_ss:
> -	sg_miter_stop(&mi);
>  	sg_miter_stop(&mo);
> +	sg_miter_stop(&mi);
>  	writel(0, ss->base + SS_CTL);
>  	spin_unlock_irqrestore(&ss->slock, flags);
>
>
>
>
