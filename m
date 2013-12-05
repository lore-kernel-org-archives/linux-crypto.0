From: Cristian Stoica <cristian.stoica@freescale.com>
Subject: RE: [PATCH] crypto: remove unnecessary includes
Date: Thu, 5 Dec 2013 09:10:27 +0000
Message-ID: <1628287275CAA9409F1E349DEF3C6CCE78DC8B@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1385658987-16012-1-git-send-email-cristian.stoica@freescale.com>
 <20131129020657.GA5650@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE77CB99@039-SN2MPN1-012.039d.mgd.msft.net>
 <20131129113430.GA9542@gondor.apana.org.au>
 <1628287275CAA9409F1E349DEF3C6CCE77CDBE@039-SN2MPN1-012.039d.mgd.msft.net>
 <1628287275CAA9409F1E349DEF3C6CCE78CBF0@039-SN2MPN1-012.039d.mgd.msft.net>
 <20131205082220.GB31822@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:24734
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751191Ab3LEJKf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Dec 2013 04:10:35 -0500
In-Reply-To: <20131205082220.GB31822@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> If you can't work out why authenc.c needs slab.h I don't think
> you should be submitting patches removing unnecessary header
> files.

[] 
You left out "kernel.h".

I really hoped this would not be your answer.

Yes, I'm an ignorant and yes, I ask questions. But if all you got is this type of answer, then maybe, just maybe, you should reconsider your ivory tower position.
The point is, if it's such a simple and obvious explanation, you should have said it instead of making me feel small. If it is not, then you should fix the pool of missing comments in crypto API (or should I read the obvious code instead?).
Even Linus pointed your mistakes when it was the case - or you never make mistakes?

You tried but your answer doesn't raise to the level of "kernel-locking.tmpl" one (and yes, I do get the "why" there).
For anyone else who cares, please lift me up from my ignorance.

Cristian S.
