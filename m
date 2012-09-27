From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: talitos fixes for 3.6-rc7
Date: Wed, 26 Sep 2012 22:25:40 -0700
Message-ID: <20120927052539.GA22160@gondor.apana.org.au>
References: <1348080820-22250-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kim Phillips <kim.phillips@freescale.com>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:55850 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754555Ab2I0FZn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Sep 2012 01:25:43 -0400
Content-Disposition: inline
In-Reply-To: <1348080820-22250-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 19, 2012 at 09:53:37PM +0300, Horia Geanta wrote:
> Hi Herbert,
> 
> I know these patches come late and might not be included in 3.6.
> But two of them are already sitting in cryptodev tree for some time.
> (Don't know where my head was :/).

I'm hesitant to put these patches in at this stage.  For the
problems fixed by them do we have simpler fixes for 3.6? For
example, by reverting changesets that introduced the issue if
it's a regression, or disabling the buggy functionality?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
