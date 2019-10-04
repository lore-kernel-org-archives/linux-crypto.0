Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3496C4360C
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:26:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD3DF21D81
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 14:26:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbfJDO0L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 10:26:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:42150 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727587AbfJDO0L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 10:26:11 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iGOX0-00075c-PG; Sat, 05 Oct 2019 00:26:07 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Oct 2019 00:26:03 +1000
Date:   Sat, 5 Oct 2019 00:26:03 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Laurent Vivier <lvivier@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] hw_random: move add_early_randomness() out of rng_mutex
Message-ID: <20191004142603.GA29787@gondor.apana.org.au>
References: <20190912133022.14870-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190912133022.14870-1-lvivier@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 12, 2019 at 03:30:22PM +0200, Laurent Vivier wrote:
>
> @@ -496,19 +510,24 @@ int hwrng_register(struct hwrng *rng)
>  			goto out_unlock;
>  	}
>  
> -	if (old_rng && !rng->init) {
> +	new_rng = rng;
> +	kref_get(&new_rng->ref);
> +out_unlock:
> +	mutex_unlock(&rng_mutex);
> +
> +	if (new_rng) {
> +		if (new_rng != old_rng || !rng->init) {

Is this really supposed to be || instead of &&?

>  		/*
>  		 * Use a new device's input to add some randomness to
>  		 * the system.  If this rng device isn't going to be
>  		 * used right away, its init function hasn't been
> -		 * called yet; so only use the randomness from devices
> -		 * that don't need an init callback.
> +		 * called yet by set_current_rng(); so only use the
> +		 * randomness from devices that don't need an init callback
>  		 */
> -		add_early_randomness(rng);
> +			add_early_randomness(new_rng);
> +		}
> +		put_rng(new_rng);
>  	}

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
