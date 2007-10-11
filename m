From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1 take 3] HIFN 795x driver.
Date: Thu, 11 Oct 2007 16:31:02 +0400
Message-ID: <20071011123102.GA27694@2ka.mipt.ru>
References: <20071010152146.GA13379@2ka.mipt.ru> <20071011101400.GA17192@gondor.apana.org.au> <20071011104313.GA31211@2ka.mipt.ru> <20071011105202.GA17487@gondor.apana.org.au> <20071011113002.GA20119@2ka.mipt.ru> <20071011114034.GA12869@2ka.mipt.ru> <20071011115650.GB17801@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:59897 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbXJKMbK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Oct 2007 08:31:10 -0400
Content-Disposition: inline
In-Reply-To: <20071011115650.GB17801@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 11, 2007 at 07:56:50PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> On Thu, Oct 11, 2007 at 03:40:36PM +0400, Evgeniy Polyakov wrote:
> >
> > HIFN driver update to use DES weak key checks (exported in this patch).
> > 
> > Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> 
> Both patches applied.  Thanks a lot!
> 
> BTW I fixed the Kconfig to say CRYPTO_DES instead of DES.

Thanks Herbert!

-- 
	Evgeniy Polyakov
