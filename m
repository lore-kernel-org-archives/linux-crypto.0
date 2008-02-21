From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Thu, 21 Feb 2008 22:10:13 +0800
Message-ID: <20080221141013.GB32494@gondor.apana.org.au>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net> <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net> <20080220172620.GE27726@gondor.apana.org.au> <20080221091012.GA21291@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:37938 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752009AbYBUOK3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2008 09:10:29 -0500
Content-Disposition: inline
In-Reply-To: <20080221091012.GA21291@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 21, 2008 at 12:10:12PM +0300, Evgeniy Polyakov wrote:
>
> But req->nbytes should or should not correspond to number of bytes to be
> encrypted? HIFN driver assumes so, it can be changed to run through
> scatterlists (btw, how will it determine how many of them were
> provided?) and get full size of the request from them, but I suspected
> that req->nbytes should always be equal to number of bytes to be
> encrypted by the driver, otherwise where to get that info from?

Yes by the time the request gets to hifn req->nbytes would have
been decremented by 12 bytes which means that it is now the exact
amount of data that needs to be encrypted.

However, if you follow the scatterlist then you will see more data
available which is normal.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
