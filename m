From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] hwrng: omap - remove #ifdefery around PM methods
Date: Thu, 12 Mar 2015 08:00:35 +1100
Message-ID: <20150311210034.GA10537@gondor.apana.org.au>
References: <1425922598-16538-1-git-send-email-dmitry.torokhov@gmail.com>
 <1425922598-16538-2-git-send-email-dmitry.torokhov@gmail.com>
 <20150311105957.GA5351@gondor.apana.org.au>
 <20150311154407.GA37516@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Deepak Saxena <dsaxena@plexity.net>,
	linux-kernel@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:37769 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbbCKVAj (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2015 17:00:39 -0400
Content-Disposition: inline
In-Reply-To: <20150311154407.GA37516@dtor-ws>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 11, 2015 at 08:44:07AM -0700, Dmitry Torokhov wrote:
> 
> SIMPLE_DEV_PM_OPS() produces an empty omap_rng_pm structure in case of
> !CONFIG_PM_SLEEP so neither omap_rng_suspend nor omap_rng_resume will
> end up being referenced.

OK, could you please resend this patch?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
