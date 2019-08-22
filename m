Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8127DC3A59D
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 03:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 512F421848
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 03:51:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730683AbfHVDvw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 23:51:52 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58314 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730602AbfHVDvw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 23:51:52 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1i0e8V-0001hd-SS; Thu, 22 Aug 2019 13:51:44 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1i0e8V-00007a-KQ; Thu, 22 Aug 2019 13:51:43 +1000
Date:   Thu, 22 Aug 2019 13:51:43 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/2] padata: initialize usable masks to reflect offlined
 CPU
Message-ID: <20190822035143.GB32551@gondor.apana.org.au>
References: <20190809210603.20900-1-daniel.m.jordan@oracle.com>
 <20190812210200.13653-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812210200.13653-1-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Aug 12, 2019 at 05:02:00PM -0400, Daniel Jordan wrote:
> __padata_remove_cpu clears the offlined CPU from the usable masks after
> padata_alloc_pd has initialized pd->cpu, which means pd->cpu could be
> initialized to this CPU, causing padata to wait indefinitely for the
> next job in padata_get_next.
> 
> Make the usable masks reflect the offline CPU when they're established
> in padata_setup_cpumasks so pd->cpu is initialized properly.
> 
> Fixes: 6fc4dbcf0276 ("padata: Replace delayed timer with immediate workqueue in padata_reorder")
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
> 
> Hi, one more edge case.  All combinations of CPUs among
> parallel_cpumask, serial_cpumask, and CPU hotplug have now been tested
> in a 4-CPU VM, and an 8-CPU VM has run with random combinations of these
> settings for over an hour.
> 
>  kernel/padata.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)

If we modify patch 2/2 by calling this after cpu_online_mask
has been updated then this problem should go away because we
can then remove the cpumask_clear_cpu calls.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
