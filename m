From: Binoy Jayan <binoy.jayan@linaro.org>
Subject: Re: [RFC PATCH] crypto: Add IV generation algorithms
Date: Tue, 29 Nov 2016 10:15:40 +0530
Message-ID: <CAHv-k_93FRosd4GeW3NB6fPmjYUNZoe+p+i4ZnwBQqB605bxUA@mail.gmail.com>
References: <1479723009-11113-1-git-send-email-binoy.jayan@linaro.org>
 <1479723009-11113-2-git-send-email-binoy.jayan@linaro.org> <20161128124722.GB2257@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:36066 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752592AbcK2Epl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Nov 2016 23:45:41 -0500
Received: by mail-ua0-f176.google.com with SMTP id b35so166436450uaa.3
        for <linux-crypto@vger.kernel.org>; Mon, 28 Nov 2016 20:45:41 -0800 (PST)
In-Reply-To: <20161128124722.GB2257@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 28 November 2016 at 18:17, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Nov 21, 2016 at 03:40:09PM +0530, Binoy Jayan wrote:
>> Currently, the iv generation algorithms are implemented in dm-crypt.c.
>> The goal is to move these algorithms from the dm layer to the kernel
>> crypto layer by implementing them as template ciphers so they can be used
>> in relation with algorithms like aes, and with multiple modes like cbc,
>> ecb etc. As part of this patchset, the iv-generation code is moved from the
>> dm layer to the crypto layer. The dm-layer can later be optimized to
>> encrypt larger block sizes in a single call to the crypto engine. The iv
>> generation algorithms implemented in geniv.c includes plain, plain64,
>> essiv, benbi, null, lmk and tcw. These templates are to be configured
>> and has to be invoked as:
>>
>> crypto_alloc_skcipher("plain(cbc(aes))", 0, 0);
>> crypto_alloc_skcipher("essiv(cbc(aes))", 0, 0);
>> ...
>>
>> from the dm layer.
>>
>> Signed-off-by: Binoy Jayan <binoy.jayan@linaro.org>
>
> Thanks a lot for working on this!
>
>> +static int crypto_geniv_set_ctx(struct crypto_skcipher *cipher,
>> +                             void *newctx, unsigned int len)
>> +{
>> +     struct geniv_ctx *ctx = crypto_skcipher_ctx(cipher);
>> +     /*
>> +      * TODO:
>> +      * Do we really need this API or can we append the context
>> +      * 'struct geniv_ctx' to the cipher from dm-crypt and use
>> +      * the same here.
>> +      */
>> +     memcpy(ctx, (char *) newctx, len);
>> +     return geniv_setkey_init_ctx(&ctx->data);
>> +}
>
> I think we should be able to do without adding another API for this.
> Can we instead put the information into the key and/or the IV?
>
> Also it would really help if you could attach a patch for dm-crypt
> that goes along with this (it doesn't have to be complete or
> functional, just showing how this is meant to be used)


Hi Herbert,

Thank you for the reply. The dm-crypt changes are also included as
part of this patchset. It has been tested for functionality as well.
More information can be found in the cover letter including the test
procedure etc.

https://lkml.org/lkml/2016/11/21/168

Thanks,
Binoy
