Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:42995 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727229AbeKIKoM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 05:44:12 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.0 \(3445.100.39\))
Subject: Re: [PATCH] crypto/simd: correctly take reqsize of wrapped skcipher
 into account
From: Qian Cai <cai@gmx.us>
In-Reply-To: <CAKv+Gu_7M+A5OiCOsOd7_e5+GH7VkrOZ33iSexd2oacyzUNKEA@mail.gmail.com>
Date: Thu, 8 Nov 2018 20:05:48 -0500
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Transfer-Encoding: 8BIT
Message-Id: <873FB29E-8809-4B3E-AE62-F5076BBCBCEC@gmx.us>
References: <20181108225516.9967-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu_7M+A5OiCOsOd7_e5+GH7VkrOZ33iSexd2oacyzUNKEA@mail.gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



> On Nov 8, 2018, at 6:33 PM, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> 
> On 8 November 2018 at 23:55, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> The simd wrapper's skcipher request context structure consists
>> of a single subrequest whose size is taken from the subordinate
>> skcipher. However, in simd_skcipher_init(), the reqsize that is
>> retrieved is not from the subordinate skcipher but from the
>> cryptd request structure, whose size is completely unrelated to
>> the actual wrapped skcipher.
>> 
>> Reported-by: Qian Cai <cai@gmx.us>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>> crypto/simd.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/crypto/simd.c b/crypto/simd.c
>> index ea7240be3001..2f3d6e897afc 100644
>> --- a/crypto/simd.c
>> +++ b/crypto/simd.c
>> @@ -125,7 +125,7 @@ static int simd_skcipher_init(struct crypto_skcipher *tfm)
>>        ctx->cryptd_tfm = cryptd_tfm;
>> 
>>        reqsize = sizeof(struct skcipher_request);
>> -       reqsize += crypto_skcipher_reqsize(&cryptd_tfm->base);
>> +       reqsize += crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm));
>> 
> 
> This should be
> 
> reqsize += max(crypto_skcipher_reqsize(&cryptd_tfm->base);
>       crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm)));
> 
> since the cryptd path in simd still needs some space in the subreq for
> the completion.
Tested-by: Qian Cai <cai@gmx.us>
