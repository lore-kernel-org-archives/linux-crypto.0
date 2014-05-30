From: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Subject: RE: [QUESTION] Crypto queue handling
Date: Fri, 30 May 2014 13:33:06 +0000
Message-ID: <A83C99F8370D4D42BEB2D2B3153A6BBC30807A82@NASANEXD02C.na.qualcomm.com>
References: <201405261758.19425.marex@denx.de>
 <20140530093030.GC12760@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Arnd Bergmann" <arnd@arndb.de>,
	Pantelis Antoniou <panto@antoniou-consulting.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32734 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaE3NdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 May 2014 09:33:08 -0400
In-Reply-To: <20140530093030.GC12760@gondor.apana.org.au>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert:

It is nice to know that the request queue is per tfm. We are currently on android-3.10.  I believe all the drivers under drivers/crypto/   don't follow this rule.  At the minimum, our driver qcrypto does not.  Other than backlogging function, does it break anything? How critical is it to fix the driver soon?

Thanks

Regards,
Chemin  

-----Original Message-----
From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-owner@vger.kernel.org] On Behalf Of Herbert Xu
Sent: Friday, May 30, 2014 5:31 AM
To: Marek Vasut
Cc: linux-crypto@vger.kernel.org; Arnd Bergmann; Pantelis Antoniou
Subject: Re: [QUESTION] Crypto queue handling

On Mon, May 26, 2014 at 05:58:19PM +0200, Marek Vasut wrote:
> Hello,
> 
> I'm digging in crypto/algapi.c , in the crypto_enqueue_request() 
> function. I don't quite understand how the backlog mechanism should 
> work. According to [1], I suspect it should limit the amount of 
> requests in the queue to $max_qlen and allow one more request to be 
> enqueued into the $backlog ; and if there is more requests than $max_qlen, it should start dropping the requests ?
> 
> Inspecting the code, I see these situations:
> 1) qlen < max_qlen
>    -> The request is enqueued, qlen is increased , returns 
> -EINPROGRESS
> 2) qlen >= max_qlen
>    -> The crypto_enqueue_request() returns -EBUSY in this case
>    2a) request->flags has CRYPTO_TFM_REQ_MAY_BACKLOG unset
>        => Request is not enqueued , qlen is not increased
>    2b) request->flags has CRYPTO_TFM_REQ_MAY_BACKLOG set
>        => Request is enqueued , qlen is increased

The queue is per-tfm.  In this case you never want to share a tfm between two users that do not agree on whether to have backlog or not.

Cheers,
--
Email: Herbert Xu <herbert@gondor.apana.org.au> Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
