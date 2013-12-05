From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: RE: [PATCH] crypto: remove unnecessary includes
Date: Thu, 5 Dec 2013 08:14:55 +0000
Message-ID: <1628287275CAA9409F1E349DEF3C6CCE78CBF0@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
 <20131129020657.GA5650@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE77CB99@039-SN2MPN1-012.039d.mgd.msft.net>
 <20131129113430.GA9542@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE77CDBE@039-SN2MPN1-012.039d.mgd.msft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Cristian Stoica <cristian.stoica@freescale.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db9lp0248.outbound.messaging.microsoft.com ([213.199.154.248]:5548
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753546Ab3LEIPB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Dec 2013 03:15:01 -0500
In-Reply-To: <1628287275CAA9409F1E349DEF3C6CCE77CDBE@039-SN2MPN1-012.039d.mgd.msft.net>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

Your original response was terse and left me more puzzled. Do you have a sensible explanation why some includes should be kept in the source even they serve no purpose during the build?

Thanks,

Cristian S.



> > Just because it compiles it doesn't meant that the files you
> > removed are unnecessary.
> >
> > The only file that is really unnecessary here is spinlock.h.
> >
> []
> OK then, but let's reverse the question. In a construct similar to
> authenc.c, what would be the purpose of slab.h and kernel.h?
> (That leads to the next question which is - what is the purpose of those
> files in authenc.c?)
