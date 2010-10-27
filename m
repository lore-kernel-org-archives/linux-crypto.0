From: Mark Allyn <allyn@well.com>
Subject: Re: Question on structures
Date: Wed, 27 Oct 2010 11:37:24 -0700 (PDT)
Message-ID: <Pine.GSO.4.64.1010271134240.21250@well.com>
References: <20101026000736.GA6315@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.well.com ([208.17.81.207]:53013 "EHLO smtp.well.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755015Ab0J0Shb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Oct 2010 14:37:31 -0400
In-Reply-To: <20101026000736.GA6315@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


I am still confused.

I have a hardware device whose driver has its own initialization API that
accepts the space for its own format for context as well as the mode.

Would I use that api for both the algorithm init and the context init
as the format of the context is unique to the hardware that I am using?

The docs don't explain this (unless there is documentation elsewhere 
outside the kernel tree)

Truly,

Mark Allyn
Portland, Oregon
www.allyn.com
971-563-7588

On Mon, 25 Oct 2010, Herbert Xu wrote:

> Mark Allyn <allyn@well.com> wrote:
>>
>> Folks:
>>
>> Perhaps this is due to me being a neophyte . . .
>>
>> I notice that some of the structure have two different sets of functions.
>>
>> For example, the ahash_alg structure has .init and then .base.cra_init.
>> What is the difference between the two?
>
> cra_init initialises a tfm object, while init is an operation
> specific to hash algorithms --- it initialises the hash state.
>
> Cheers,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
>
