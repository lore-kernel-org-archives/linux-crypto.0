From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] crypto: rng.c: Cleaning up missing null-terminate in
 conjunction with strncpy
Date: Sun, 27 Jul 2014 14:14:00 +0200
Message-ID: <CAFo99gYq6euP7q=czdBEsXKass7JAHQTv6cBHJti=PKWTgBYog@mail.gmail.com>
References: <1406384308-2269-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <B1C69CE0-CA18-4853-B4EB-15B0D0F107E7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: Neil Horman <nhorman@tuxdriver.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Mark D Rustad <mrustad@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:48660 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaG0MOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 27 Jul 2014 08:14:21 -0400
Received: by mail-oi0-f43.google.com with SMTP id u20so5024329oif.16
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jul 2014 05:14:21 -0700 (PDT)
In-Reply-To: <B1C69CE0-CA18-4853-B4EB-15B0D0F107E7@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2014-07-27 4:35 GMT+02:00 Mark D Rustad <mrustad@gmail.com>:
> Rickard,
>
> On Jul 26, 2014, at 7:18 AM, Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:
>
>> Replacing strncpy with strlcpy to avoid strings that lacks null terminate.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>> crypto/rng.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/crypto/rng.c b/crypto/rng.c
>> index e0a25c2..c3d4fb3 100644
>> --- a/crypto/rng.c
>> +++ b/crypto/rng.c
>> @@ -65,7 +65,7 @@ static int crypto_rng_report(struct sk_buff *skb, struct crypto_alg *alg)
>> {
>>       struct crypto_report_rng rrng;
>>
>> -     strncpy(rrng.type, "rng", sizeof(rrng.type));
>> +     strlcpy(rrng.type, "rng", sizeof(rrng.type));
>>
>>       rrng.seedsize = alg->cra_rng.seedsize;
>
> Not to pick on this patch in particular, but you need to be careful about changing strncpy to strlcpy. Although strlcpy ensures termination, it does not prevent information leakage - strncpy ensures that the entire destination buffer is written. When leakage is a concern, it is better to use strncpy and then to store a zero in the last location of the buffer to ensure termination.
>
> These "simple" transformations can be risky - and many of these do not represent any sort of problem when the source is smaller than the destination. I hope information leakage is being considered.
>


Hi Mark

You clearly have a point there! Information leakage is not something I
think about very often otherwise.

It is really unbelievable that C messed up when trying to make a
better solution to strcpy. strncpy doing something completely new with
zeroes whole size but still does not guarantee a terminating null
character. And strlcpy that works great as a replacement for strcpy,
but really can not replace strncpy in all cases.  Incredibly stupid!
:-(

But ok, I'll submit a [Patch V2] with foo[sizeof(foo) - 1] = '\ 0'
on all under crypto/  then  ?


Kind regards
Rickard Strandqvist
