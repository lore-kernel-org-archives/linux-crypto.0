Return-Path: <SRS0=FyHQ=TQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8DEC04AB4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 13:32:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2ED4A21743
	for <linux-crypto@archiver.kernel.org>; Thu, 16 May 2019 13:32:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="NYTHLKBb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfEPNcl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 May 2019 09:32:41 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:34384 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727069AbfEPNcl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 May 2019 09:32:41 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 454XRB1clVz9v6X8;
        Thu, 16 May 2019 15:32:38 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=NYTHLKBb; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id YJ2fH7KAqsev; Thu, 16 May 2019 15:32:38 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 454XRB0P2lz9v6Ws;
        Thu, 16 May 2019 15:32:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1558013558; bh=nnbDu0Oncip1B1EfAee0nXXH/Y+D1kJM8P3yAxFONt8=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=NYTHLKBbYT+1AyjfBvVrBs+aVvT0yZrGdfDLlEw5m4ZSeWGjsy+j5C8Rusba+uXOC
         09reBIj2aW5astgucBs6dszCpYVWDkiKv45TJDO8zpM3srgNKS6m2t+8G0AO9TDr7d
         IHd0d8/WPeVC1xcTGhPFZEP3SMAbOwY5Zqi5GKIY=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 743F98B831;
        Thu, 16 May 2019 15:32:39 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id MI1hq9bTdmn3; Thu, 16 May 2019 15:32:39 +0200 (CEST)
Received: from PO15451 (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id D33418B82A;
        Thu, 16 May 2019 15:32:38 +0200 (CEST)
Subject: Re: [PATCH] crypto: talitos - fix skcipher failure due to wrong
 output IV
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <a5b0d31d8fc9fc9bc2b69baa5330466090825a39.1557923113.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB34858D80A15D4B55F64570E398090@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <29db3f20-f931-efc6-02a8-fe160ab8b484@c-s.fr>
 <20190516023050.GA23200@sol.localdomain>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <593f51b1-8c51-1994-623d-f5a591891d8a@c-s.fr>
Date:   Thu, 16 May 2019 15:32:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190516023050.GA23200@sol.localdomain>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 16/05/2019 à 04:30, Eric Biggers a écrit :
> On Wed, May 15, 2019 at 08:49:48PM +0200, Christophe Leroy wrote:
>>
>>
>> Le 15/05/2019 à 16:05, Horia Geanta a écrit :
>>> On 5/15/2019 3:29 PM, Christophe Leroy wrote:
>>>> Selftests report the following:
>>>>
>>>> [    2.984845] alg: skcipher: cbc-aes-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
>>>> [    2.995377] 00000000: 3d af ba 42 9d 9e b4 30 b4 22 da 80 2c 9f ac 41
>>>> [    3.032673] alg: skcipher: cbc-des-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
>>>> [    3.043185] 00000000: fe dc ba 98 76 54 32 10
>>>> [    3.063238] alg: skcipher: cbc-3des-talitos encryption test failed (wrong output IV) on test vector 0, cfg="in-place"
>>>> [    3.073818] 00000000: 7d 33 88 93 0f 93 b2 42
>>>>
>>>> This above dumps show that the actual output IV is indeed the input IV.
>>>> This is due to the IV not being copied back into the request.
>>>>
>>>> This patch fixes that.
>>>>
>>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>> Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
>>
>> It's missing a Fixes: tag and a Cc: to stable.
>>
>> I'll resend tomorrow.
>>
>>>
>>> While here, could you please check ecb mode (which by definition does not have
>>> an IV) is behaving correctly?
>>> Looking in driver_algs[] list of crypto algorithms supported by talitos,
>>> ecb(aes,des,3des) are declared with ivsize != 0.
>>
>> According to /proc/crypto, test are passed for ecb.
>>
> 
> Did you try enabling CONFIG_CRYPTO_MANAGER_EXTRA_TESTS?  There is now a check
> that the driver's ivsize matches the generic implementation's:
> 
>          if (ivsize != crypto_skcipher_ivsize(generic_tfm)) {
>                  pr_err("alg: skcipher: ivsize for %s (%u) doesn't match generic impl (%u)\n",
>                         driver, ivsize, crypto_skcipher_ivsize(generic_tfm));
>                  err = -EINVAL;
>                  goto out;
>          }
> 
> For ECB that means the ivsize must be 0.
> 
> AFAICS the talitos driver even accesses the IV for ECB, which is wrong; and the
> only reason this isn't crashing the self-tests already is that they are confused
> by the declared ivsize being nonzero so they don't pass NULL as they should.
> 

Ok, thanks. I'll try and run EXTRA TESTS as soon as I get the current 
test all fixed.

For the time being, I'm having a problem that I'm a bit lost with:

AEAD decryption fails at the moment for out-of-line tests, and the 
reason is that the ICV (used to do the SW compare with the expected one) 
is generated after the decrypted data.
It works perfectly when src == dst, because the src has space for it, 
but when the dst is different, the dst length is smaller so the ICV is 
generated outside the sg list, and the comparison fails because the 
comparison is done with the last bytes of the last segment of dst sg 
list (which corresponds to the end of decrypted data in that case).

What I'm having hard time with it that it seems that when the sg list 
has several elements, it uses an out of line area for generating the ICV 
but not when the sg list has only one element. I'm really wondering why.

Thanks
Christophe
