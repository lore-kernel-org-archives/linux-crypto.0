Return-Path: <SRS0=4UkV=XO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED80C4CECE
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 06:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A59B921927
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Sep 2019 06:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387649AbfISGMm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Sep 2019 02:12:42 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38634 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387646AbfISGMm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Sep 2019 02:12:42 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 28B1F52A7D8C5FEA9B88;
        Thu, 19 Sep 2019 14:12:40 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Sep 2019
 14:12:29 +0800
Subject: Re: [PATCH] crypto: hisilicon - Fix return value check in
 hisi_zip_acompress()
To:     Yunfeng Ye <yeyunfeng@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
References: <23be2eb5-8256-0c19-aef9-994974d11c9d@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5D831C63.9020500@hisilicon.com>
Date:   Thu, 19 Sep 2019 14:12:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <23be2eb5-8256-0c19-aef9-994974d11c9d@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/9/16 14:38, Yunfeng Ye wrote:
> The return valude of add_comp_head() is int, but @head_size is size_t,
> which is a unsigned type.
> 
> 	size_t head_size;
> 	...
> 	if (head_size < 0)  // it will never work
> 		return -ENOMEM
> 
> Modify the type of @head_size to int, then change the type to size_t
> when invoke hisi_zip_create_req() as a parameter.

Acked-by: Zhou Wang <wangzhou1@hisilicon.com>

This is a bug, thinks for your fix!

Best,
Zhou

> 
> Fixes: 62c455ca853e ("crypto: hisilicon - add HiSilicon ZIP accelerator support")
> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
> ---
>  drivers/crypto/hisilicon/zip/zip_crypto.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/zip/zip_crypto.c b/drivers/crypto/hisilicon/zip/zip_crypto.c
> index 5a3f84d..5902354 100644
> --- a/drivers/crypto/hisilicon/zip/zip_crypto.c
> +++ b/drivers/crypto/hisilicon/zip/zip_crypto.c
> @@ -559,7 +559,7 @@ static int hisi_zip_acompress(struct acomp_req *acomp_req)
>  	struct hisi_zip_ctx *ctx = crypto_tfm_ctx(acomp_req->base.tfm);
>  	struct hisi_zip_qp_ctx *qp_ctx = &ctx->qp_ctx[QPC_COMP];
>  	struct hisi_zip_req *req;
> -	size_t head_size;
> +	int head_size;
>  	int ret;
> 
>  	/* let's output compression head now */
> @@ -567,7 +567,7 @@ static int hisi_zip_acompress(struct acomp_req *acomp_req)
>  	if (head_size < 0)
>  		return -ENOMEM;
> 
> -	req = hisi_zip_create_req(acomp_req, qp_ctx, head_size, true);
> +	req = hisi_zip_create_req(acomp_req, qp_ctx, (size_t)head_size, true);
>  	if (IS_ERR(req))
>  		return PTR_ERR(req);
> 

