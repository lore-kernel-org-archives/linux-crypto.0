From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Fri, 10 Nov 2017 21:41:45 +1100
Message-ID: <20171110104145.GA25739@gondor.apana.org.au>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
 <20171103124157.GA8330@gondor.apana.org.au>
 <VI1PR0402MB33425E266579E4F3B375617498570@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171109222129.GB20824@gondor.apana.org.au>
 <VI1PR0402MB3342FFECA75AFC5556AD085498540@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171110074332.GB24384@gondor.apana.org.au>
 <VI1PR0402MB334241EA4B848E77AF8DFC2298540@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Robert Baronescu <robert.baronescu@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:35770 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751239AbdKJLXb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 06:23:31 -0500
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB334241EA4B848E77AF8DFC2298540@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 10, 2017 at 09:17:33AM +0000, Horia Geantă wrote:
>
> > I must be missing something.  In the case rem == 0, let's say
> > the original value of np is npo.  Then at the start of the loop,
> > np = npo - 1, and at the last iteration, k = npo - 2, so we do
> IIUC at the start of the loop np = npo (and not npo - 1), since np is no
> longer decremented in the rem == 0 case:
> -	np--;
> +	if (rem)
> +		np--;
> 
> > 
> > 	sg_set_buf(&sg[npo - 1], xbuf[npo - 2], PAGE_SIZE);
> > 
> and accordingly last iteration is for k = npo - 1:
>  	sg_set_buf(&sg[npo], xbuf[npo - 1], PAGE_SIZE);
> 
> > While the sg_init_table call sets the end-of-table at
> > 
> > 	sg_init_table(sg, npo + 1);
> > 
> while this marks sg[npo] as last SG table entry.

OK, we're both sort of right.  You're correct that this generates
a valid SG list in that the number of entries match the end-of-table
marking.

But the thing that prompted to check this patch in the first place
is the semantics behind it.  For the case rem == 0, it means that
buflen is a multiple of PAGE_SIZE.  In that case, the code with
your patch will create an SG list that's one page longer than
buflen.

AFAICS it should be harmless but it would still be better if we can
generate an SG list that's exactly buflen long rather than one page
longer.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
