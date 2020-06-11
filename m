Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DF50C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 10:50:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6769D207C3
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 10:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgFKKua (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 06:50:30 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:19780 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbgFKKu3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 06:50:29 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 49jLH41Wmtz9v4xj;
        Thu, 11 Jun 2020 12:50:24 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 0-ipBjlmkgFm; Thu, 11 Jun 2020 12:50:24 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 49jLH40gs9z9v4xh;
        Thu, 11 Jun 2020 12:50:24 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B871F8B850;
        Thu, 11 Jun 2020 12:50:25 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id hafyDPaiggKu; Thu, 11 Jun 2020 12:50:25 +0200 (CEST)
Received: from [10.25.210.22] (po15451.idsi0.si.c-s.fr [10.25.210.22])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 2E3468B75B;
        Thu, 11 Jun 2020 12:50:25 +0200 (CEST)
Subject: Re: [PATCH] crypto: talitos - fix ECB and CBC algs ivsize
To:     Su Kang Yin <cantona@cantona.net>, gregkh@linuxfoundation.org,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <cantona@cantona.net> <20200611100745.6513-1-cantona@cantona.net>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <718354b4-d284-8e47-4085-f45101f9ca36@csgroup.eu>
Date:   Thu, 11 Jun 2020 12:50:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200611100745.6513-1-cantona@cantona.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

Le 11/06/2020 à 12:07, Su Kang Yin a écrit :
> Patch for 4.9 upstream:
> 
> commit e1de42fdfc6a ("crypto: talitos - fix ECB algs ivsize")
> wrongly modified CBC algs ivsize instead of ECB aggs ivsize.

To make it clear and avoid this problem to happen again, please generate 
your patch with option -U8

> 
> This restore the CBC algs original ivsize of removes ECB's ones.
> 
> Signed-off-by: Su Kang Yin <cantona@cantona.net>

I think it should include a Fixes: tag.

> ---
>   drivers/crypto/talitos.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> index 8b383d3d21c2..05a35ab5595b 100644
> --- a/drivers/crypto/talitos.c
> +++ b/drivers/crypto/talitos.c
> @@ -2636,7 +2636,6 @@ static struct talitos_alg_template driver_algs[] = {
>   			.cra_ablkcipher = {
>   				.min_keysize = AES_MIN_KEY_SIZE,
>   				.max_keysize = AES_MAX_KEY_SIZE,
> -				.ivsize = AES_BLOCK_SIZE,
>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -2670,6 +2669,7 @@ static struct talitos_alg_template driver_algs[] = {
>   			.cra_ablkcipher = {
>   				.min_keysize = AES_MIN_KEY_SIZE,
>   				.max_keysize = AES_MAX_KEY_SIZE,
> +				.ivsize = AES_BLOCK_SIZE,
>   				.setkey = ablkcipher_aes_setkey,
>   			}
>   		},
> @@ -2687,7 +2687,6 @@ static struct talitos_alg_template driver_algs[] = {
>   			.cra_ablkcipher = {
>   				.min_keysize = DES_KEY_SIZE,
>   				.max_keysize = DES_KEY_SIZE,
> -				.ivsize = DES_BLOCK_SIZE,

This change has no link with e1de42fdfc6a

>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> @@ -2720,7 +2719,6 @@ static struct talitos_alg_template driver_algs[] = {
>   			.cra_ablkcipher = {
>   				.min_keysize = DES3_EDE_KEY_SIZE,
>   				.max_keysize = DES3_EDE_KEY_SIZE,
> -				.ivsize = DES3_EDE_BLOCK_SIZE,

This change has no link with e1de42fdfc6a

>   			}
>   		},
>   		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
> 

Christophe
