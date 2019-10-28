Return-Path: <SRS0=YLdW=YV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7AECCA9EBC
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 10:36:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F90E21479
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Oct 2019 10:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="gQ5p3n8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732888AbfJ1Kg6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Oct 2019 06:36:58 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:30930 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732821AbfJ1Kg6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Oct 2019 06:36:58 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 471rkC5P31zB09ZS;
        Mon, 28 Oct 2019 11:36:51 +0100 (CET)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=gQ5p3n8u; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id HtoiVrcFoKSO; Mon, 28 Oct 2019 11:36:51 +0100 (CET)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 471rkC4Gd4zB09Zg;
        Mon, 28 Oct 2019 11:36:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1572259011; bh=CkktF4NAbt0+QaAe/+XEmO6xRyETWYPJidqV/UaYi4g=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gQ5p3n8uwGbqZg4yJM7VCNWatvChUwMheC1RCkmkEL471TZDLxL7+d7vA8wWRpiaD
         iaOYuqy2tZSHICNYfZ9Xv8dQd2ZJhNfz+1TiSwAOSf+zNAJqEK99daMykGftWPCa3b
         E2BFESaoJop5kNaSE5I0Xpa4PsXZJVqJG2rAJDH4=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 6AE428B80E;
        Mon, 28 Oct 2019 11:36:56 +0100 (CET)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Z42IZMl3TysI; Mon, 28 Oct 2019 11:36:56 +0100 (CET)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D4F168B809;
        Mon, 28 Oct 2019 11:36:55 +0100 (CET)
Subject: Re: [PATCH v2 24/27] crypto: talitos - switch to skcipher API
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
 <20191024132345.5236-25-ard.biesheuvel@linaro.org>
 <74d5c30d-d842-5bdb-ebb8-2aa47ffb5e8d@c-s.fr>
 <CAKv+Gu8V57Z2WixfYZSdT+rqsobqDYZ-Hyer6Aq9khUNeUsxmQ@mail.gmail.com>
 <be890dfd-a1aa-86e1-b1c7-99b72ad137d0@c-s.fr>
 <CAKv+Gu98fsPOZ3reGs6wXd+hzNa_pdVZ6+XDFoXhey7C39sfFw@mail.gmail.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <63c941df-ae15-733f-3b0b-35fc0ce6af51@c-s.fr>
Date:   Mon, 28 Oct 2019 11:36:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu98fsPOZ3reGs6wXd+hzNa_pdVZ6+XDFoXhey7C39sfFw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 28/10/2019 à 07:20, Ard Biesheuvel a écrit :
> On Sun, 27 Oct 2019 at 14:05, Christophe Leroy <christophe.leroy@c-s.fr> wrote:
>>
>>
>>
>> Le 27/10/2019 à 12:05, Ard Biesheuvel a écrit :
>>> On Sun, 27 Oct 2019 at 11:45, Christophe Leroy <christophe.leroy@c-s.fr> wrote:
>>>>
>>>>
>>>>
>>>> Le 24/10/2019 à 15:23, Ard Biesheuvel a écrit :
>>>>> Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interface")
>>>>> dated 20 august 2015 introduced the new skcipher API which is supposed to
>>>>> replace both blkcipher and ablkcipher. While all consumers of the API have
>>>>> been converted long ago, some producers of the ablkcipher remain, forcing
>>>>> us to keep the ablkcipher support routines alive, along with the matching
>>>>> code to expose [a]blkciphers via the skcipher API.
>>>>>
>>>>> So switch this driver to the skcipher API, allowing us to finally drop the
>>>>> blkcipher code in the near future.
>>>>>
>>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>>>
>>>> With this series, I get the following Oops at boot:
>>>>
>>>
>>> Thanks for the report.
>>>
>>> Given that the series only modifies ablkcipher implementations, it is
>>> rather curious that the crash occurs in ahash_init(). Can you confirm
>>> that the crash does not occur with this patch reverted?
>>
>> Yes I confirm.
>>
>> You changed talitos_cra_init_ahash(). talitos_init_common() is not
>> called anymore. I think that's the reason.
>>
> 
> Thanks a lot for digging into this
> 
> Does this fix things for you?

Yes it does.
Thanks.
Christophe

> 
> index c29f8c02ea05..d71d65846e47 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -3053,7 +3053,7 @@ static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
>          crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
>                                   sizeof(struct talitos_ahash_req_ctx));
> 
> -       return 0;
> +       return talitos_init_common(ctx, talitos_alg);
>   }
> 
>   static void talitos_cra_exit(struct crypto_tfm *tfm)
> 
