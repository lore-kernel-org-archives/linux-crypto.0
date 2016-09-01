From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] crypto: arm/ghash-ce - add missing async import/export
Date: Thu, 1 Sep 2016 16:14:22 +0100
Message-ID: <CAKv+Gu8yEDbQS651Q3-GbQw+AwJfqvH1WHKa-LUE4=43NwyWSw@mail.gmail.com>
References: <1472469594-27315-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160831144135.GB26616@gondor.apana.org.au> <CAKv+Gu8tr3kq9gYpJjNeKvt-PDsnBUb1FZqxOeNBfuF+J6hCzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35020 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755416AbcIAPOY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 11:14:24 -0400
Received: by mail-it0-f49.google.com with SMTP id e124so108474142ith.0
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2016 08:14:23 -0700 (PDT)
In-Reply-To: <CAKv+Gu8tr3kq9gYpJjNeKvt-PDsnBUb1FZqxOeNBfuF+J6hCzA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 1 September 2016 at 14:19, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 31 August 2016 at 15:41, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> On Mon, Aug 29, 2016 at 12:19:53PM +0100, Ard Biesheuvel wrote:
>>> Since commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero"),
>>> all ahash drivers are required to implement import()/export(), and must have
>>> a non-zero statesize. Fix this for the ARM Crypto Extensions GHASH
>>> implementation.
>>>
>>> Fixes: 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> ---
>>>  arch/arm/crypto/ghash-ce-glue.c | 26 ++++++++++++++++++++++++++
>>>  1 file changed, 26 insertions(+)
>>>
>>> diff --git a/arch/arm/crypto/ghash-ce-glue.c b/arch/arm/crypto/ghash-ce-glue.c
>>> index 1568cb5cd870..212aaa715fdb 100644
>>> --- a/arch/arm/crypto/ghash-ce-glue.c
>>> +++ b/arch/arm/crypto/ghash-ce-glue.c
>>> @@ -220,6 +220,29 @@ static int ghash_async_digest(struct ahash_request *req)
>>>       }
>>>  }
>>>
>>> +static int ghash_async_import(struct ahash_request *req, const void *in)
>>> +{
>>> +     struct ahash_request *cryptd_req = ahash_request_ctx(req);
>>> +     struct shash_desc *desc = cryptd_shash_desc(cryptd_req);
>>> +     struct ghash_desc_ctx *dctx = shash_desc_ctx(desc);
>>> +
>>> +     ghash_async_init(req);
>>
>> Is this really needed?
>>
>
> Actually, yes, and more. I could not find in the documentation whether
> the .import() hook requires .init() to be called first, but based on
> the test case in testmgr.c, it appears that is not the case.
>
> This means that the stuff that occurs in .init() to establish the
> relation between this desc and its child transform needs to be copied
> here as well. In fact, the only way I could make this work is by
> adding it to cryptd's import() routines as well, otherwise the test
> crashes reliably.
>
>>> +     *dctx = *(const struct ghash_desc_ctx *)in;
>>
>> I'd prefer to call the underlying shash import/export functions
>> like we do in cryptd.
>>
>

I managed to track down why this issue seems specific to ARM (i.e.,
why it does not affect the x86 clmul-ni driver as well)

The culprit appears to be that the .cra_name of the internal shash is
"ghash", (and not "__ghash" like in the x86 case) which causes the
test code to run the test on not only the public ahash, but also on
the internal cryptd() encapsulated shash, and also on the internal
shash itself.

However, that does not answer the question whether .init() must be
called before .import() [which the test code does not do]. If not,
then please disregard my v2, and I will followup with a patch that
renames ghash to __ghash (but .import() will still require the .init()
bits as well). Given that these internal shashes/ahashes are in fact
callable, and calling .import() will result in a crash, I suppose
duplicating some of the init() code in .import() makes sense
regardless.
