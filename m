Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A118EC7EE25
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Jun 2023 09:13:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241386AbjFIJNw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Jun 2023 05:13:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241277AbjFIJN1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Jun 2023 05:13:27 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40AD5243
        for <linux-crypto@vger.kernel.org>; Fri,  9 Jun 2023 02:09:05 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q7Y5U-000w8M-Cq; Fri, 09 Jun 2023 17:07:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Jun 2023 17:07:16 +0800
Date:   Fri, 9 Jun 2023 17:07:16 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Damian Muszynski <damian.muszynski@intel.com>
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: Re: [PATCH] crypto: qat - add internal timer for qat 4xxx
Message-ID: <ZILrxDmxkHyIZ1Sw@gondor.apana.org.au>
References: <20230601091340.12626-1-damian.muszynski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601091340.12626-1-damian.muszynski@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 01, 2023 at 11:13:40AM +0200, Damian Muszynski wrote:
>
> +static void timer_handler(struct timer_list *tl)
> +{
> +	struct adf_timer *timer_ctx = from_timer(timer_ctx, tl, timer);
> +	unsigned long timeout_val = adf_get_next_timeout();
> +
> +	/* Schedule a work queue to send admin request */
> +	adf_misc_wq_queue_work(&timer_ctx->timer_bh);
> +
> +	timer_ctx->cnt++;
> +	mod_timer(tl, timeout_val);
> +}

So the timer simply schedules a work.  Could you use a delayed
work instead?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
