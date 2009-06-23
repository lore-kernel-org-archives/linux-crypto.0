From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] pcrypt: Add pcrypt crypto parallelization
	wrapper
Date: Tue, 23 Jun 2009 17:18:52 +0800
Message-ID: <20090623091852.GA8701@gondor.apana.org.au>
References: <20090608070749.GR20366@secunet.com> <20090608071000.GT20366@secunet.com> <20090619122933.GB18631@gondor.apana.org.au> <20090623082921.GB20366@secunet.com> <20090623083438.GA8315@gondor.apana.org.au> <20090623091429.GC20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:44050 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751129AbZFWJSz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Jun 2009 05:18:55 -0400
Content-Disposition: inline
In-Reply-To: <20090623091429.GC20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 23, 2009 at 11:14:29AM +0200, Steffen Klassert wrote:
>
> I posted some numbers for the actual softirq based version with the
> first patchset, see:
> http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg03035.html

Thanks, but I was thinking of softirq numbers vs. workqueue numbers.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
