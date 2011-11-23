From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: crypto_ahash_setkey
Date: Wed, 23 Nov 2011 11:08:29 +0200
Message-ID: <CALLzPKaSm9TncJc3932jxSYzp=krXRH_5wO5CFGDnCsDKvaLUQ@mail.gmail.com>
References: <CALLzPKYbbYV9keL7DAFfHVzn3SqQv3-1X+cJCp2hn2-ey9UpOw@mail.gmail.com>
	<20111123074456.GA7875@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63396 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757888Ab1KWJIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Nov 2011 04:08:32 -0500
Received: by qyl16 with SMTP id 16so2335196qyl.25
        for <linux-crypto@vger.kernel.org>; Wed, 23 Nov 2011 01:08:30 -0800 (PST)
In-Reply-To: <20111123074456.GA7875@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

On Wed, Nov 23, 2011 at 9:44 AM, Herbert Xu <herbert@gondor.apana.org.a=
u> wrote:
> Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:
>> Hi,
>>
>> I have noticed very odd behavior with hmac calculation on my dual
>> core, 4 HTs PC.
>> I am using async hash API to to calculate hmac over the page.
>> I am using "hmac(sha1)" and the same key to calculate different page=
s.
>>
>> I have a work queue, which calculates the hmac like...
>>
>> int()
>> {
>> =C2=A0 =C2=A0tfm =3D crypto_alloc_ahash(...);
>> }
>>
>> work_task()
>> {
>> =C2=A0 =C2=A0 crypto_ahash_setkey(tfm, key, keylen);
>> =C2=A0 =C2=A0 crypto_ahash_digest(req);
>> }
>>
>> HMAC result "sometimes" is incorrect.
>
> Is your tfm shared by multiple instances of work_task? The key
> is a property of the tfm, so you cannot have multiple users of a
> tfm all changing keys at the same time.

Yes. I know that....
Work queue also uses WQ_NON_REENTRANT, so it should not be any races,
and it should be possible to call crypto_ahash_setkey() without any pro=
blems.

This problem happens on 64 bit kernel.
It does not happen on my QEMU 32 bit kernel,

I will do some more tests...

>
> The correct usage model allowing parallel use is to dedicate a
> tfm to each key.
>

Sure.

Thanks...

> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
