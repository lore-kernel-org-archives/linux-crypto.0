From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: imx-rngc: simplify the power management
 definitions
Date: Thu, 18 Jan 2018 23:04:25 +1100
Message-ID: <20180118120425.GI20717@gondor.apana.org.au>
References: <1515704804-19468-1-git-send-email-martin@kaiser.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Martin Kaiser <martin@kaiser.cx>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:55454 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755322AbeARMG6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jan 2018 07:06:58 -0500
Content-Disposition: inline
In-Reply-To: <1515704804-19468-1-git-send-email-martin@kaiser.cx>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 11, 2018 at 10:06:39PM +0100, Martin Kaiser wrote:
> Use the SIMPLE_DEV_PM_OPS() macro instead of populating a struct
> dev_pm_ops directly. The suspend and resume functions will now be used
> for both hibernation and suspend to ram.
> 
> If power management is disabled, SIMPLE_DEV_PM_OPS() evaluates to
> nothing, The two functions won't be used and won't be included in the
> kernel. Mark them as __maybe_unused to clarify that this is intended
> behaviour.
> 
> With these modifications in place, we don't need the #ifdefs for power
> management any more.
> 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
