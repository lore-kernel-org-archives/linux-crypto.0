Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1A6EC4321A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 14:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71DD220665
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 14:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="WnDvxfK7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387447AbfFKOE1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 10:04:27 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:12504 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbfFKOE0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 10:04:26 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45NWvp6z72z9v0F4;
        Tue, 11 Jun 2019 16:04:22 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=WnDvxfK7; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id eCIThnGPA5aS; Tue, 11 Jun 2019 16:04:22 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45NWvp5vKxz9v0F1;
        Tue, 11 Jun 2019 16:04:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1560261862; bh=cGzgpxbRFlxcK7aezB5YmRNBHzKIp4lffWmjax6sgQQ=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WnDvxfK7qGDC5nYHUZHAeW++MRre0DOZm+yuvmuDl/P2IoU6/KuJAQhcgGcYuoS7N
         4MeefWV1hW8ekZlvU298lOyL/M5/hJ4e+O20Mqwcn/b2O9dJzp7ZXbUtJUydV06agi
         FzRUO1pqSJrLK7eCfM8hHv5yPSO6KudmKabLhTJY=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 485F98B7F4;
        Tue, 11 Jun 2019 16:04:24 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id z-vV47D7T_jZ; Tue, 11 Jun 2019 16:04:24 +0200 (CEST)
Received: from PO15451 (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 934918B75B;
        Tue, 11 Jun 2019 16:04:23 +0200 (CEST)
Subject: Re: [PATCH v1 1/5] crypto: talitos - fix ECB and CBC algs ivsize
To:     Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <cover.1559819372.git.christophe.leroy@c-s.fr>
 <c8b988faeea463b89e7d9485c9328dc65a909e8e.1559819372.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB3485627276325DEF9CC6F58798ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <bf4d6713-66a6-4d48-8b1a-32b88a3be540@c-s.fr>
Date:   Tue, 11 Jun 2019 16:04:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0402MB3485627276325DEF9CC6F58798ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 11/06/2019 à 13:52, Horia Geanta a écrit :
> On 6/6/2019 2:31 PM, Christophe Leroy wrote:
>> commit d84cc9c9524e ("crypto: talitos - fix ECB algs ivsize")
>> wrongly modified CBC algs ivsize instead of ECB aggs ivsize.
>>
>> This restore the CBC algs original ivsize of removes ECB's ones.
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> Fixes: d84cc9c9524e ("crypto: talitos - fix ECB algs ivsize")
> Initial patch is correct:
> 
> $ git show -U10 d84cc9c9524e
> [...]
> @@ -2802,21 +2802,20 @@ static struct talitos_alg_template driver_algs[] = {
>          {       .type = CRYPTO_ALG_TYPE_ABLKCIPHER,
>                  .alg.crypto = {
>                          .cra_name = "ecb(aes)",
>                          .cra_driver_name = "ecb-aes-talitos",
>                          .cra_blocksize = AES_BLOCK_SIZE,
>                          .cra_flags = CRYPTO_ALG_TYPE_ABLKCIPHER |
>                                       CRYPTO_ALG_ASYNC,
>                          .cra_ablkcipher = {
>                                  .min_keysize = AES_MIN_KEY_SIZE,
>                                  .max_keysize = AES_MAX_KEY_SIZE,
> -                               .ivsize = AES_BLOCK_SIZE,
>                                  .setkey = ablkcipher_aes_setkey,
>                          }
>                  },
> [...]
> 
> and similar for ecb(des), ecb(des3_ede).
> 
> Current patch is incorrect: it adds ivsize for ecb and removes it from cbc.

Very strange. Looks like there has been some rebase weirdness which have 
applied the patch on the wrong block at some point on my side, probably 
due to the fact that both blocks have the two previous and following 
lines identical.

I've now rebased my serie on cryptodev/master and have the same 
behaviour as you. I'll resend the series without this patch.

Christophe


> 
> Horia
> 
