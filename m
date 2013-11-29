From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: RE: [PATCH] crypto: remove unnecessary includes
Date: Fri, 29 Nov 2013 12:07:07 +0000
Message-ID: <1628287275CAA9409F1E349DEF3C6CCE77CDBE@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
 <20131129020657.GA5650@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE77CB99@039-SN2MPN1-012.039d.mgd.msft.net>
 <20131129113430.GA9542@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:8835
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751813Ab3K2MHM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Nov 2013 07:07:12 -0500
In-Reply-To: <20131129113430.GA9542@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> On Fri, Nov 29, 2013 at 08:49:42AM +0000, Cristian Stoica wrote:
> > >From what I could see there is nothing from those includes that is
> used inside authenc.c.
> > The build passes without them.
> 
> Just because it compiles it doesn't meant that the files you
> removed are unnecessary.
> 
> The only file that is really unnecessary here is spinlock.h.
> 
[] 
OK then, but let's reverse the question. In a construct similar to authenc.c, what would be the purpose of slab.h and kernel.h?
(That leads to the next question which is - what is the purpose of those files in authenc.c?)

Thanks,
Cristian S.
