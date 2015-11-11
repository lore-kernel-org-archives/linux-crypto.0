From: Orlando <orlcp440@gmail.com>
Subject: Re: Hardware Crypto Driver
Date: Wed, 11 Nov 2015 09:54:37 -0500
Message-ID: <CAG3F19DdmCnWPpuC6w4W8YrYU8+q8BEmgYX0DqrbPRVqC2-16A@mail.gmail.com>
References: <CAG3F19ArjmvN=hEsL67f1vH56nxVfZryV9utNCqosVT9J6FTCQ@mail.gmail.com>
	<20151111042403.GA21253@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:34979 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391AbbKKOyh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Nov 2015 09:54:37 -0500
Received: by ykba77 with SMTP id a77so51687298ykb.2
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2015 06:54:37 -0800 (PST)
In-Reply-To: <20151111042403.GA21253@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I think the main problem might be my lack of understanding how IVs are
handled by the kernel crypto framework. It seems the omap-aes.c driver
is indicating to the crypto framework that it wants IV generation to
be handled automatically by the crypto framework by filling this field
.geniv = "eseqiv". Is there a way I can tell the kernel crypto
framework to stop handling IV generation? Even if I remove the .geniv
field it gets set with a default value by the crypto framework. I have
tried .geniv = "<built-in>" but then when I make a crypto call it does
not use the driver anymore. What are the required things I must do if
I set .geniv = "<built-in>" ?

static struct crypto_alg algs[] = {
{
.cra_name = "ctr(aes)",
.cra_driver_name = "ctr-aes-omap",
.cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
 CRYPTO_ALG_KERN_DRIVER_ONLY |
 CRYPTO_ALG_ASYNC,
.cra_u.ablkcipher = {
.geniv = "eseqiv",

On Tue, Nov 10, 2015 at 11:24 PM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> Orlando <orlcp440@gmail.com> wrote:
>> Hello, I am new to the crypto framework in linux kernel and mailing
>> list in general. I am porting a driver omap-aes.c to my platform and
>> having problems with IV being modified against my will. I am doing
>> AES-128-CTR and I need the IV to increment by 1 every 16 bytes.
>> Instead some garbage IV is being returned to me after I do an encrypt
>> operation.
>>
>> I have no idea how the IV is being manipulated since the omap-aes.c
>> driver accepts and write the IV to the Hardware that comes from upper
>> layers but it never writes it back to the upper layers after doing
>> encryption.
>
> The omap-aes is probably buggy in this regard.  The crypto selftest
> system isn't currently testing this so a number of buggy drivers
> have slipped through.
>
> If you can send us a patch to fix this it would be great.  Otherwise
> I will be working through the drivers during the skcipher conversion.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
