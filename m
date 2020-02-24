Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27A1C35670
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 01:14:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 784A120675
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 01:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgBXBOe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 23 Feb 2020 20:14:34 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11100 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727167AbgBXBOd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 23 Feb 2020 20:14:33 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id B8FFD31DE262BD82582E;
        Mon, 24 Feb 2020 09:14:31 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Mon, 24 Feb 2020
 09:14:27 +0800
Subject: Re: [PATCH] crypto: hisilicon: remove redundant assignment of pointer
 ctx
To:     Colin King <colin.king@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
References: <20200222142409.141057-1-colin.king@canonical.com>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <e0133b58-5acc-5706-c369-6eeacf1c67a6@huawei.com>
Date:   Mon, 24 Feb 2020 09:14:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200222142409.141057-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


Yes, thank you!


On 2020/2/22 22:24, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Pointer ctx is being re-assigned with the same value as it
> was initialized with. The second assignment is redundant and
> can be removed.
>
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/crypto/hisilicon/sec2/sec_crypto.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> index a2cfcc9ccd94..acd15507eb8a 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> @@ -447,7 +447,6 @@ static int sec_skcipher_init(struct crypto_skcipher *tfm)
>   	struct sec_ctx *ctx = crypto_skcipher_ctx(tfm);
>   	int ret;
>   
> -	ctx = crypto_skcipher_ctx(tfm);
>   	ctx->alg_type = SEC_SKCIPHER;
>   	crypto_skcipher_set_reqsize(tfm, sizeof(struct sec_req));
>   	ctx->c_ctx.ivsize = crypto_skcipher_ivsize(tfm);


