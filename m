From: Mark Allyn <allyn@well.com>
Subject: Re: Question on __crypto_alg_lookup
Date: Wed, 1 Feb 2012 21:15:01 -0800 (PST)
Message-ID: <alpine.LRH.2.02.1202012114530.21678@well.com>
References: <20120201211643.GA16557@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from newsmtp.well.com ([107.20.247.102]:55198 "EHLO newsmtp.well.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab2BBFPI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Feb 2012 00:15:08 -0500
In-Reply-To: <20120201211643.GA16557@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Thanks.

Truly,

Mark Allyn
Portland, Oregon
www.allyn.com
971-563-7588

On Thu, 2 Feb 2012, Herbert Xu wrote:

> Mark Allyn <allyn@well.com> wrote:
>>
>> Is dm-crypt supposed to work with ahash?
>
> Since it uses the shash interface, no.
>
> Someone will need to convert it over to ahash first, like what
> we have done for IPsec.
>
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
