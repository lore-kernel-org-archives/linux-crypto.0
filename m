Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7734BC433B4
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 10:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B54E60FD7
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Apr 2021 10:34:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbhDBKex (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Apr 2021 06:34:53 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:54410 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229599AbhDBKex (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Apr 2021 06:34:53 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4FBbyx42HFz9ty33;
        Fri,  2 Apr 2021 12:34:49 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id XvwunlNFppuO; Fri,  2 Apr 2021 12:34:49 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FBbyx35lVz9ty2x;
        Fri,  2 Apr 2021 12:34:49 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 0E3DF8BB66;
        Fri,  2 Apr 2021 12:34:51 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id P-Pc_R-4lJcd; Fri,  2 Apr 2021 12:34:50 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 83D938BB65;
        Fri,  2 Apr 2021 12:34:50 +0200 (CEST)
Subject: Re: [PATCH] ecc: delete a useless function declaration
To:     Meng Yu <yumeng18@huawei.com>, herbert@gondor.apana.org.au,
        davem@davemloft.net
Cc:     linux-crypto@vger.kernel.org, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
References: <1617357357-11828-1-git-send-email-yumeng18@huawei.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <3fbc88c4-50ae-3ffb-14e5-0cd39d492251@csgroup.eu>
Date:   Fri, 2 Apr 2021 12:34:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <1617357357-11828-1-git-send-email-yumeng18@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



Le 02/04/2021 à 11:55, Meng Yu a écrit :
> This function declaration has been added in 'ecc_curve.h',
> delete it in 'crypto/ecc.h'.
> 
> Fixes: 14bb76768275(crypto: ecc - expose ecc curves)

Fixes tag is wrong I think, should be 4e6602916bc6

> Signed-off-by: Meng Yu <yumeng18@huawei.com>
> ---
>   crypto/ecc.h | 8 --------
>   1 file changed, 8 deletions(-)
> 
> diff --git a/crypto/ecc.h b/crypto/ecc.h
> index 46aa9bc..a006132 100644
> --- a/crypto/ecc.h
> +++ b/crypto/ecc.h
> @@ -56,14 +56,6 @@ static inline void ecc_swap_digits(const u64 *in, u64 *out, unsigned int ndigits
>   }
>   
>   /**
> - * ecc_get_curve()  - Get a curve given its curve_id
> - * @curve_id:  Id of the curve
> - *
> - * Returns pointer to the curve data, NULL if curve is not available
> - */
> -const struct ecc_curve *ecc_get_curve(unsigned int curve_id);
> -
> -/**
>    * ecc_is_key_valid() - Validate a given ECDH private key
>    *
>    * @curve_id:		id representing the curve to use
> 
