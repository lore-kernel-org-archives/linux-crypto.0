From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: crypto_ahash_setkey
Date: Wed, 23 Nov 2011 12:25:29 +0200
Message-ID: <CALLzPKasbDrAFm5JnzMeRL5isZGrZPzhq1fMf49Eng1NTTCVmQ@mail.gmail.com>
References: <CALLzPKYbbYV9keL7DAFfHVzn3SqQv3-1X+cJCp2hn2-ey9UpOw@mail.gmail.com>
	<20111123074456.GA7875@gondor.apana.org.au>
	<CALLzPKaSm9TncJc3932jxSYzp=krXRH_5wO5CFGDnCsDKvaLUQ@mail.gmail.com>
	<20111123100721.GA8774@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:2051 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab1KWKZb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Nov 2011 05:25:31 -0500
Received: by qyl16 with SMTP id 16so2575261qyl.25
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2011 02:25:30 -0800 (PST)
In-Reply-To: <20111123100721.GA8774@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 23, 2011 at 12:07 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Wed, Nov 23, 2011 at 11:08:29AM +0200, Kasatkin, Dmitry wrote:
>>
>> Yes. I know that....
>> Work queue also uses WQ_NON_REENTRANT, so it should not be any races,
>> and it should be possible to call crypto_ahash_setkey() without any problems.
>>

Ok... I found it out..
There is no magic here.
For some reason work_task is called on different CPUs simultaneously.
What is the purpose of WQ_NON_REENTRANT flag then?

- Dmitry


>> This problem happens on 64 bit kernel.
>> It does not happen on my QEMU 32 bit kernel,
>>
>> I will do some more tests...
>
> Which particular hmac(sha1) implementation are you using?
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
