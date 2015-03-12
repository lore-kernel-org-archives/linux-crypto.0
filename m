From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RESEND PATCH] hwrng: omap - remove #ifdefery around PM methods
Date: Thu, 12 Mar 2015 21:20:14 +1100
Message-ID: <20150312102014.GB18614@gondor.apana.org.au>
References: <20150311210836.GA8253@dtor-ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Deepak Saxena <dsaxena@plexity.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:35676 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbbCLKUR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Mar 2015 06:20:17 -0400
Content-Disposition: inline
In-Reply-To: <20150311210836.GA8253@dtor-ws>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 11, 2015 at 02:08:36PM -0700, Dmitry Torokhov wrote:
> Instead of using #ifdefs let's mark suspend and resume methods as
> __maybe_unused which will suppress compiler warnings about them being
> unused and provide better compile coverage.
> 
> Because SIMPLE_DEV_PM_OPS() produces an empty omap_rng_pm structure in
> case of !CONFIG_PM_SLEEP neither omap_rng_suspend nor omap_rng_resume
> will end up being referenced and the change will not result in
> increasing image size.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
