Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3791EC3A59D
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 03:50:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 09D78206DD
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 03:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730419AbfHVDuR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 23:50:17 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58306 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728470AbfHVDuR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 23:50:17 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1i0e6z-0001gC-EW; Thu, 22 Aug 2019 13:50:09 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1i0e6v-00007I-Cu; Thu, 22 Aug 2019 13:50:05 +1000
Date:   Thu, 22 Aug 2019 13:50:05 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] padata: validate cpumask without removed CPU during
 offline
Message-ID: <20190822035005.GA32551@gondor.apana.org.au>
References: <20190809192857.26585-2-daniel.m.jordan@oracle.com>
 <20190809210603.20900-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809210603.20900-1-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 09, 2019 at 05:06:03PM -0400, Daniel Jordan wrote:
>
> diff --git a/kernel/padata.c b/kernel/padata.c
> index d056276a96ce..01460ea1d160 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -702,10 +702,7 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
>  	struct parallel_data *pd = NULL;
>  
>  	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
> -
> -		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
> -		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
> -			__padata_stop(pinst);
> +		__padata_stop(pinst);
>  
>  		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
>  				     pinst->cpumask.cbcpu);
> @@ -716,6 +713,9 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
>  
>  		cpumask_clear_cpu(cpu, pd->cpumask.cbcpu);
>  		cpumask_clear_cpu(cpu, pd->cpumask.pcpu);
> +		if (padata_validate_cpumask(pinst, pd->cpumask.pcpu) &&
> +		    padata_validate_cpumask(pinst, pd->cpumask.cbcpu))
> +			__padata_start(pinst);
>  	}

I looked back at the original code and in fact the original
assumption is to call this after cpu_online_mask has been modified.

So I suspect we need to change the state at which this is called
by CPU hotplug.  IOW the commit that broke this is 30e92153b4e6.

This would also allow us to get rid of the two cpumask_clear_cpu
calls on pd->cpumask which is just bogus as you should only ever
modify the pd->cpumask prior to the padata_repalce call (because
the readers are not serialised with respect to this).

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
