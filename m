From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: dcp: Remove redundant
 platform_set_drvdata()
Date: Wed, 5 Jun 2013 16:54:10 +0800
Message-ID: <20130605085409.GE12202@gondor.apana.org.au>
References: <1369827552-28373-1-git-send-email-sachin.kamat@linaro.org>
 <51AE3E24.6000907@gmail.com>
 <CAK9yfHxDekruYdXRfDOCuwx_TDhh6rFazfKrYTgsK0xEwjvtnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tobias Rauter <tobiasrauter@gmail.com>,
	linux-crypto@vger.kernel.org
To: Sachin Kamat <sachin.kamat@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:35327 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752907Ab3FEIyP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Jun 2013 04:54:15 -0400
Content-Disposition: inline
In-Reply-To: <CAK9yfHxDekruYdXRfDOCuwx_TDhh6rFazfKrYTgsK0xEwjvtnA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 05, 2013 at 08:52:03AM +0530, Sachin Kamat wrote:
> Hi Tobias,
> 
> On 5 June 2013 00:51, Tobias Rauter <tobiasrauter@gmail.com> wrote:
> > On 29.05.2013 13:39, Sachin Kamat wrote:
> >>
> >> Commit 0998d06310 (device-core: Ensure drvdata = NULL when no
> >> driver is bound) removes the need to set driver data field to
> >> NULL.
> >>
> >> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> >> Cc: Tobias Rauter <tobias.rauter@gmail.com>
> >> ---
> >> This series compile tested against linux-next (20130529).
> >
> >
> > Hi!
> >
> > Thank you for the corrections.
> >
> > I tested this series on Freescale's evalboard with v3.10-rc4.
> 
> Thanks for testing. Perhaps Herbert could add you to "Tested-by:"
> while applying this series?

I've added the tag.  All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
