Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A548C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 13 May 2022 08:07:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354086AbiEMIHY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 May 2022 04:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378092AbiEMIHS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 May 2022 04:07:18 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C762354FA5;
        Fri, 13 May 2022 01:07:11 -0700 (PDT)
Received: from dggpeml500024.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L01Rl29PBz1JBG0;
        Fri, 13 May 2022 16:05:55 +0800 (CST)
Received: from dggpeml100012.china.huawei.com (7.185.36.121) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 16:07:09 +0800
Received: from [10.67.103.212] (10.67.103.212) by
 dggpeml100012.china.huawei.com (7.185.36.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 16:07:09 +0800
Subject: Re: [PATCH] crypto: hisilicon/sec - delele the flag
 CRYPTO_ALG_ALLOCATES_MEMORY
To:     <herbert@gondor.apana.org.au>
References: <20220513075542.16227-1-yekai13@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhou1@hisilicon.com>
From:   "yekai(A)" <yekai13@huawei.com>
Message-ID: <ce014c64-b25a-da31-1468-c673b3e27aad@huawei.com>
Date:   Fri, 13 May 2022 16:07:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20220513075542.16227-1-yekai13@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.212]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml100012.china.huawei.com (7.185.36.121)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2022/5/13 15:55, Kai Ye wrote:
> Should not to uses the CRYPTO_ALG_ALLOCATES_MEMORY in SEC2. The SEC2
> driver uses the pre-allocated buffers, including the src sgl pool, dst
> sgl pool and other qp ctx resources. (e.g. IV buffer, mac buffer, key
> buffer). The SEC2 driver doesn't allocate memory during request processing.
> The driver only maps software sgl to allocated hardware sgl during I/O. So
> here is fix it.
>
> Signed-off-by: Kai Ye <yekai13@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec_crypto.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/crypto/hisilicon/sec2/sec_crypto.c b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> index a91635c348b5..6eebe739893c 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_crypto.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_crypto.c
> @@ -2113,7 +2113,6 @@ static int sec_skcipher_decrypt(struct skcipher_request *sk_req)
>  		.cra_driver_name = "hisi_sec_"sec_cra_name,\
>  		.cra_priority = SEC_PRIORITY,\
>  		.cra_flags = CRYPTO_ALG_ASYNC |\
> -		 CRYPTO_ALG_ALLOCATES_MEMORY |\
>  		 CRYPTO_ALG_NEED_FALLBACK,\
>  		.cra_blocksize = blk_size,\
>  		.cra_ctxsize = sizeof(struct sec_ctx),\
> @@ -2366,7 +2365,6 @@ static int sec_aead_decrypt(struct aead_request *a_req)
>  		.cra_driver_name = "hisi_sec_"sec_cra_name,\
>  		.cra_priority = SEC_PRIORITY,\
>  		.cra_flags = CRYPTO_ALG_ASYNC |\
> -		 CRYPTO_ALG_ALLOCATES_MEMORY |\
>  		 CRYPTO_ALG_NEED_FALLBACK,\
>  		.cra_blocksize = blk_size,\
>  		.cra_ctxsize = sizeof(struct sec_ctx),\
>

Please ignore this patch, There was a title misspelled, "delete->delele"


Thanks
Kai
