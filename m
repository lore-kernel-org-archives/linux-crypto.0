Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B668C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 13:54:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70F32207D0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 13:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbgFDNyn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 09:54:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5788 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728679AbgFDNyn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 09:54:43 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id EA76962F8E9A3388A999
        for <linux-crypto@vger.kernel.org>; Thu,  4 Jun 2020 21:54:41 +0800 (CST)
Received: from [10.63.139.185] (10.63.139.185) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Thu, 4 Jun 2020 21:54:33 +0800
Subject: Re: [PATCH] crypto: hisilicon - Cap block size at 2^31
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Shukun Tan <tanshukun1@huawei.com>
References: <20200604073750.GA30866@gondor.apana.org.au>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5ED8FD19.1010502@hisilicon.com>
Date:   Thu, 4 Jun 2020 21:54:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20200604073750.GA30866@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020/6/4 15:37, Herbert Xu wrote:
> The function hisi_acc_create_sg_pool may allocate a block of
> memory of size PAGE_SIZE * 2^(MAX_ORDER - 1).  This value may
> exceed 2^31 on ia64, which would overflow the u32.
> 
> This patch caps it at 2^31.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: d8ac7b85236b ("crypto: hisilicon - fix large sgl memory...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Fine to me, Thanks!

> 
> diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
> index 0e8c7e324fb4..725a739800b0 100644
> --- a/drivers/crypto/hisilicon/sgl.c
> +++ b/drivers/crypto/hisilicon/sgl.c
> @@ -66,7 +66,8 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
>  
>  	sgl_size = sizeof(struct acc_hw_sge) * sge_nr +
>  		   sizeof(struct hisi_acc_hw_sgl);
> -	block_size = PAGE_SIZE * (1 << (MAX_ORDER - 1));
> +	block_size = 1 << (PAGE_SHIFT + MAX_ORDER <= 32 ?
> +			   PAGE_SHIFT + MAX_ORDER - 1 : 31);
>  	sgl_num_per_block = block_size / sgl_size;
>  	block_num = count / sgl_num_per_block;
>  	remain_sgl = count % sgl_num_per_block;
> 
