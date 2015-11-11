From: Orlando <orlcp440@gmail.com>
Subject: Re: Hardware Crypto Driver
Date: Wed, 11 Nov 2015 10:47:29 -0500
Message-ID: <CAG3F19Cq9vqOeVOd5o-+52KV_wbc7J+7SFOyaRVzV0GW9up4wA@mail.gmail.com>
References: <CAG3F19ArjmvN=hEsL67f1vH56nxVfZryV9utNCqosVT9J6FTCQ@mail.gmail.com>
	<20151111042403.GA21253@gondor.apana.org.au>
	<CAG3F19DdmCnWPpuC6w4W8YrYU8+q8BEmgYX0DqrbPRVqC2-16A@mail.gmail.com>
	<20151111150218.GA25002@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:33715 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbbKKPr3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Nov 2015 10:47:29 -0500
Received: by ykdv3 with SMTP id v3so54832100ykd.0
        for <linux-crypto@vger.kernel.org>; Wed, 11 Nov 2015 07:47:29 -0800 (PST)
In-Reply-To: <20151111150218.GA25002@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I will not be able to use your changes since I am running kernel
3.4.48 and I cannot change it for my project (embedded system).

The reason I am suspecting that the crypto framework is
generating/manipulating the IV for my driver is because when I do a
cat /proc/crypto I get two instances of the AES-CTR cipher instance
instead of one. One says

name         : ctr(aes)
driver       : ctr-aes-omap
selftest     : passed
type         : ablkcipher

which is correct and how I want it. However, there is another that
gets automagically added by the crypto framework itself called

name         : ctr(aes)
driver       : ctr-aes-omap
selftest     : passed
type         : givcipher

this second one has the flag CRYPTO_ALG_TYPE_GIVCIPHER set and I read that
CRYPTO_ALG_TYPE_GIVCIPHER  = Asynchronous multi-block cipher packed
together with an IV generator (see geniv field in the /proc/crypto
listing for the known IV generators)

as you can see, it says that it has a IV generator. I also read that I
can supply some callbacks for me to handle IV manipulation myself in
the driver by adding these fields
.cra_u.ablkcipher = {
                .givencrypt     = omap_givencrypt,
                .givdecrypt     = omap_givdecrypt,

However, they never seems be get called. It seems they are only
supported for AEAD.

givencrypt
Update the IV for encryption. With this function, a cipher
implementation may provide the function on how to update the IV for
encryption.

givdecrypt
Update the IV for decryption. This is the reverse of givencrypt

I have taken a look at others crypto hardware drivers implementation
and I do not see them manipulating or returning back the resulting IV
after the hardware operation is done. Which makes me believe the IV
incrementing/etc (CTR) is being handled by software in the kernel
crypto framework. I see the omap-aes.c driver receives the IV from the
crypto framework (comes from my user space openssl app) and writes it
into the hardware crypto engine. After the hardware finishes
encrypting the plaintext the IV has been incremented but this new IV
is not being written back into the kernel crypto framework to go back
to my user app.

What would I have to do to make sure the correct IV gets back to the user?


On Wed, Nov 11, 2015 at 10:02 AM, Herbert Xu
<herbert@gondor.apana.org.au> wrote:
> On Wed, Nov 11, 2015 at 09:54:37AM -0500, Orlando wrote:
>> I think the main problem might be my lack of understanding how IVs are
>> handled by the kernel crypto framework. It seems the omap-aes.c driver
>> is indicating to the crypto framework that it wants IV generation to
>> be handled automatically by the crypto framework by filling this field
>> .geniv = "eseqiv". Is there a way I can tell the kernel crypto
>> framework to stop handling IV generation? Even if I remove the .geniv
>> field it gets set with a default value by the crypto framework. I have
>> tried .geniv = "<built-in>" but then when I make a crypto call it does
>> not use the driver anymore. What are the required things I must do if
>> I set .geniv = "<built-in>" ?
>
> geniv is completely unrelated to this.  In fact, in the current
> kernel geniv is no longer used and I will remove it once the skcipher
> conversion is done.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
