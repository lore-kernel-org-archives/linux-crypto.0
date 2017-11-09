From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: tcrypt - fix S/G table for test_aead_speed()
Date: Fri, 10 Nov 2017 09:21:29 +1100
Message-ID: <20171109222129.GB20824@gondor.apana.org.au>
References: <1507630920-9014-1-git-send-email-robert.baronescu@nxp.com>
 <20171103124157.GA8330@gondor.apana.org.au>
 <VI1PR0402MB33425E266579E4F3B375617498570@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Robert Baronescu <robert.baronescu@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:35620 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1754565AbdKIWVf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Nov 2017 17:21:35 -0500
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB33425E266579E4F3B375617498570@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 09, 2017 at 02:37:29PM +0000, Horia Geantă wrote:
>
> >>  	sg_init_table(sg, np + 1);
> sg_mark_end() marks sg[np].
> 
> >> -	np--;
> >> +	if (rem)
> >> +		np--;
> >>  	for (k = 0; k < np; k++)
> >>  		sg_set_buf(&sg[k + 1], xbuf[k], PAGE_SIZE);
> In case rem == 0, last k value is np-1, thus sg[np-1+1] will be filled
> here with xbuf[np-1].

No, if rem == 0, then the last k value is np-2.

The whole point of the patch is to shrink the SG table by one
entry when rem == 0.  How can you shrink it without moving the
end-of-table marker?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
