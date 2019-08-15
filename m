Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA2FEC433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 05:15:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAF85206C2
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 05:15:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbfHOFP3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 01:15:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:57056 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726008AbfHOFP3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 01:15:29 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hy86b-0005BL-Bk; Thu, 15 Aug 2019 15:15:21 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hy86Y-0006W0-7R; Thu, 15 Aug 2019 15:15:18 +1000
Date:   Thu, 15 Aug 2019 15:15:18 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] padata: always acquire cpu_hotplug_lock before
 pinst->lock
Message-ID: <20190815051518.GB24982@gondor.apana.org.au>
References: <20190809192857.26585-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809192857.26585-1-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 09, 2019 at 03:28:56PM -0400, Daniel Jordan wrote:
> On a 5.2 kernel, lockdep complains when offlining a CPU and writing to a
> parallel_cpumask sysfs file.
> 
>   echo 0 > /sys/devices/system/cpu/cpu1/online
>   echo ff > /sys/kernel/pcrypt/pencrypt/parallel_cpumask
> 
>   ======================================================
>   WARNING: possible circular locking dependency detected
>   5.2.0-padata-base+ #19 Not tainted
>   ------------------------------------------------------
>   cpuhp/1/13 is trying to acquire lock:
>   ...  (&pinst->lock){+.+.}, at: padata_cpu_prep_down+0x37/0x70
> 
>   but task is already holding lock:
>   ...  (cpuhp_state-down){+.+.}, at: cpuhp_thread_fun+0x34/0x240
> 
>   which lock already depends on the new lock.
> 
> padata doesn't take cpu_hotplug_lock and pinst->lock in a consistent
> order.  Which should be first?  CPU hotplug calls into padata with
> cpu_hotplug_lock already held, so it should have priority.

Yeah this is clearly a bug but I think we need tackle something
else first.
 
> diff --git a/kernel/padata.c b/kernel/padata.c
> index b60cc3dcee58..d056276a96ce 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -487,9 +487,7 @@ static void __padata_stop(struct padata_instance *pinst)
>  
>  	synchronize_rcu();
>  
> -	get_online_cpus();
>  	padata_flush_queues(pinst->pd);
> -	put_online_cpus();
>  }

As I pointed earlier, the whole concept of flushing the queues is
suspect.  So we should tackle that first and it may obviate the need
to do get_online_cpus completely if the flush call disappears.

My main worry is that you're adding an extra lock around synchronize_rcu
and that is always something that should be done only after careful
investigation.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
