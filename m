From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Fri, 10 Nov 2017 18:43:32 +1100
Message-ID: <20171110074332.GB24384@gondor.apana.org.au>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
 <20171103124157.GA8330@gondor.apana.org.au>
 <VI1PR0402MB33425E266579E4F3B375617498570@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20171109222129.GB20824@gondor.apana.org.au>
 <VI1PR0402MB3342FFECA75AFC5556AD085498540@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Robert Baronescu <robert.baronescu@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:35728 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1750793AbdKJHnk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 02:43:40 -0500
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3342FFECA75AFC5556AD085498540@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Nov 10, 2017 at 06:37:22AM +0000, Horia Geantă wrote:
> On 11/10/2017 12:21 AM, Herbert Xu wrote:
> > On Thu, Nov 09, 2017 at 02:37:29PM +0000, Horia Geantă wrote:
> >>
> >>>>  	sg_init_table(sg, np + 1);
> >> sg_mark_end() marks sg[np].
> >>
> >>>> -	np--;
> >>>> +	if (rem)
> >>>> +		np--;
> >>>>  	for (k = 0; k < np; k++)
> >>>>  		sg_set_buf(&sg[k + 1], xbuf[k], PAGE_SIZE);
> >> In case rem == 0, last k value is np-1, thus sg[np-1+1] will be filled
> >> here with xbuf[np-1].
> > 
> > No, if rem == 0, then the last k value is np-2.
> > 
> Notice that np-- above the for loop is done conditionally, so in the for
> loop k takes values in [0, np-1].
> This means the for loop fills sg[1]...sg[np].

I must be missing something.  In the case rem == 0, let's say
the original value of np is npo.  Then at the start of the loop,
np = npo - 1, and at the last iteration, k = npo - 2, so we do

	sg_set_buf(&sg[npo - 1], xbuf[npo - 2], PAGE_SIZE);

While the sg_init_table call sets the end-of-table at

	sg_init_table(sg, npo + 1);

I can't see how this can be right.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
