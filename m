Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B5B5C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 18:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 004196103D
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Nov 2021 18:18:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbhKLSVn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 12 Nov 2021 13:21:43 -0500
Received: from foss.arm.com ([217.140.110.172]:43140 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235265AbhKLSVn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Nov 2021 13:21:43 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D43E8D6E;
        Fri, 12 Nov 2021 10:18:51 -0800 (PST)
Received: from e120937-lin (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C9B863F718;
        Fri, 12 Nov 2021 10:18:50 -0800 (PST)
Date:   Fri, 12 Nov 2021 18:18:39 +0000
From:   Cristian Marussi <cristian.marussi@arm.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     gilad@benyossef.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree - remove redundant 'flush_workqueue()'
 calls
Message-ID: <20211112181839.GA6655@e120937-lin>
References: <2a313cc6de53c492db10e29c6444d8e6f2529689.1636735696.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a313cc6de53c492db10e29c6444d8e6f2529689.1636735696.git.christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 12, 2021 at 05:49:23PM +0100, Christophe JAILLET wrote:
> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
> 
> Remove the redundant 'flush_workqueue()' calls.
> 
> This was generated with coccinelle:

Hi Cristophe,

> 
> @@
> expression E;
> @@
> - 	flush_workqueue(E);
> 	destroy_workqueue(E);
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

LGTM.

Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>

Thanks,
Cristian

> ---
>  drivers/crypto/ccree/cc_request_mgr.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccree/cc_request_mgr.c b/drivers/crypto/ccree/cc_request_mgr.c
> index 33fb27745d52..887162df50f9 100644
> --- a/drivers/crypto/ccree/cc_request_mgr.c
> +++ b/drivers/crypto/ccree/cc_request_mgr.c
> @@ -101,7 +101,6 @@ void cc_req_mgr_fini(struct cc_drvdata *drvdata)
>  	dev_dbg(dev, "max_used_sw_slots=%d\n", req_mgr_h->max_used_sw_slots);
>  
>  #ifdef COMP_IN_WQ
> -	flush_workqueue(req_mgr_h->workq);
>  	destroy_workqueue(req_mgr_h->workq);
>  #else
>  	/* Kill tasklet */
> -- 
> 2.30.2
> 
