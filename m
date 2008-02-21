From: Patrick McHardy <kaber@trash.net>
Subject: Re: HIFN+IPsec crashes in current -git
Date: Thu, 21 Feb 2008 15:20:45 +0100
Message-ID: <47BD88BD.2030305@trash.net>
References: <E1JRLsx-0003Yz-00@gondolin.me.apana.org.au> <47BB036D.7090701@trash.net> <20080220005329.GA21565@gondor.apana.org.au> <47BC1E12.9050201@trash.net> <20080220172620.GE27726@gondor.apana.org.au> <20080221091012.GA21291@2ka.mipt.ru> <20080221141013.GB32494@gondor.apana.org.au> <20080221141803.GB24779@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:42503 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752064AbYBUOVG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Feb 2008 09:21:06 -0500
In-Reply-To: <20080221141803.GB24779@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Evgeniy Polyakov wrote:
> Hi Herbert.
> 
> On Thu, Feb 21, 2008 at 10:10:13PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
>> Yes by the time the request gets to hifn req->nbytes would have
>> been decremented by 12 bytes which means that it is now the exact
>> amount of data that needs to be encrypted.
>>
>> However, if you follow the scatterlist then you will see more data
>> available which is normal.
> 
> Argh, I see.
> 
> Then following patch should help.
> 
> Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
> 
> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> index dfbf24c..81b8f2f 100644
> --- a/drivers/crypto/hifn_795x.c
> +++ b/drivers/crypto/hifn_795x.c
> @@ -1544,7 +1544,10 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
>  
>  			kunmap_atomic(daddr, KM_SOFTIRQ0);
>  		} else {
> -			nbytes -= src->length;
> +			if (src->length > nbytes)
> +				nbytes = 0;
> +			else
> +				nbytes -= src->length;
>  			idx++;
>  		}
>  

Almost I guess :) There are similar loops in hifn_setup_session().
Additionally we need to check that the return value of ablkcipher_walk()
is not a negative errno code.
