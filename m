From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Subject: Re: [PATCH] crypto: skcipher - Fix skcipher_walk_aead_common
Date: Fri, 24 Nov 2017 11:53:53 +0100
Message-ID: <CAAUqJDtvTVchrm2kaU06EWDXA-KY3FLsyq-K_dRO6Hec7xqV+g@mail.gmail.com>
References: <20171123124906.15754-1-omosnacek@gmail.com> <20171124050740.GA14836@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171124050740.GA14836@gondor.apana.org.au>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

(I accidentally hit "reply" instead of "reply all", so resending)

2017-11-24 6:07 GMT+01:00 Herbert Xu <herbert@gondor.apana.org.au>:
> On Thu, Nov 23, 2017 at 01:49:06PM +0100, Ondrej Mosnacek wrote:
>> diff --git a/crypto/skcipher.c b/crypto/skcipher.c
>> index 4faa0fd53b0c..6c45ed536664 100644
>> --- a/crypto/skcipher.c
>> +++ b/crypto/skcipher.c
>> @@ -517,6 +517,9 @@ static int skcipher_walk_aead_common(struct skcipher_walk *walk,
>>       scatterwalk_copychunks(NULL, &walk->in, req->assoclen, 2);
>>       scatterwalk_copychunks(NULL, &walk->out, req->assoclen, 2);
>>
>> +     scatterwalk_done(&walk->in, 0, walk->total);
>> +     scatterwalk_done(&walk->out, 0, walk->total);
>
> That should be 1 instead of 0 for walk->out.
>
> Could you please fix and resubmit?

Since the associated data is not written, just skipped, I believe 0 is
more appropriate. scatterwalk_copychunks(..., 2) also calls
scatterwalk_pagedone() with out=0 internally.

O.M.
