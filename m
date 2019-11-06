Return-Path: <SRS0=HcMk=Y6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBFCC5DF62
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 00:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11B6421929
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Nov 2019 00:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfKFAuM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 19:50:12 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:50336 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727046AbfKFAuM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 19:50:12 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 13411F21071883A3EAD7;
        Wed,  6 Nov 2019 08:50:10 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Wed, 6 Nov 2019
 08:50:04 +0800
Subject: Re: [PATCH -next] crypto: hisilicon: move label err to #ifdef
 CONFIG_NUMA
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Mao Wenan <maowenan@huawei.com>
References: <20191105143340.32950-1-maowenan@huawei.com>
 <20191105145602.GH10409@kadam>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <tanshukun1@huawei.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5DC218BB.3080001@hisilicon.com>
Date:   Wed, 6 Nov 2019 08:50:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20191105145602.GH10409@kadam>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/11/5 22:56, Dan Carpenter wrote:
> The ifdefs in this function were pretty ugly before but this makes it
> super extra ugly...  :/  There are bunch of ways to fix this nicely
> but my favourite is this:
> 
> Feel free to give me a Suggested-by tag.
> 
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index 255b63cfbe1d..1b22f0ead56e 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -105,20 +105,27 @@ static void free_list(struct list_head *head)
>  struct hisi_zip *find_zip_device(int node)
>  {
>  	struct hisi_zip *ret = NULL;
> -#ifdef CONFIG_NUMA
>  	struct hisi_zip_resource *res, *tmp;
>  	struct hisi_zip *hisi_zip;
>  	struct list_head *n;
>  	struct device *dev;
>  	LIST_HEAD(head);
>  
> +	if (!IS_ENABLED(CONFIG_NUMA)) {
> +		mutex_lock(&hisi_zip_list_lock);
> +		ret = list_first_entry(&hisi_zip_list, struct hisi_zip, list);
> +		mutex_unlock(&hisi_zip_list_lock);
> +		return ret;
> +	}
> +
>  	mutex_lock(&hisi_zip_list_lock);
>  
>  	list_for_each_entry(hisi_zip, &hisi_zip_list, list) {
>  		res = kzalloc(sizeof(*res), GFP_KERNEL);
> -		if (!res)
> -			goto err;
> -
> +		if (!res) {
> +			ret = NULL;
> +			goto done;
> +		}
>  		dev = &hisi_zip->qm.pdev->dev;
>  		res->hzip = hisi_zip;
>  		res->distance = node_distance(dev->numa_node, node);
> @@ -140,20 +147,10 @@ struct hisi_zip *find_zip_device(int node)
>  		}
>  	}
>  
> +done:
>  	free_list(&head);
> -#else
> -	mutex_lock(&hisi_zip_list_lock);
> -
> -	ret = list_first_entry(&hisi_zip_list, struct hisi_zip, list);
> -#endif
>  	mutex_unlock(&hisi_zip_list_lock);
> -
>  	return ret;
> -
> -err:
> -	free_list(&head);
> -	mutex_unlock(&hisi_zip_list_lock);
> -	return NULL;
>  }
>  
>  struct hisi_zip_hw_error {
> 
> 
> .
> 

Hi Mao and Dan,

I already posted a patch to fix this problem:
[PATCH] crypto: hisilicon - replace #ifdef with IS_ENABLED for CONFIG_NUMA

Many thanks for your help,
Zhou

