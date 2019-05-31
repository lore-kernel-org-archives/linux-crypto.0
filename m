Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 383D1C04AB6
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 09:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 085BA266C0
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 09:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfEaJ0r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 05:26:47 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45052 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726240AbfEaJ0r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 05:26:47 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6C9C2CF031826829C3CD;
        Fri, 31 May 2019 17:26:43 +0800 (CST)
Received: from [127.0.0.1] (10.177.19.180) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Fri, 31 May 2019
 17:26:37 +0800
Subject: Re: [PATCH] crypto: pcrypt: Fix possible deadlock in
 padata_sysfs_release
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
References: <20190531092923.4874-1-wangkefeng.wang@huawei.com>
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
Message-ID: <1b71b136-3501-db1c-834b-ba7ed1431f4d@huawei.com>
Date:   Fri, 31 May 2019 17:23:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190531092923.4874-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.177.19.180]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 2019/5/31 17:29, Kefeng Wang wrote:
> There is a deadlock issue in pcrypt_init_padata(),
>
> pcrypt_init_padata()
>     cpus_read_lock()
>       padata_free()
>         padata_sysfs_release()
>           cpus_read_lock()
>
> Narrow rcu_read_lock/unlock() and move put_online_cpus()
> before padata_free() to fix it.
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  crypto/pcrypt.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
> index 0e9ce329fd47..662228b48b70 100644
> --- a/crypto/pcrypt.c
> +++ b/crypto/pcrypt.c
> @@ -407,13 +407,14 @@ static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
>  	int ret = -ENOMEM;
>  	struct pcrypt_cpumask *mask;
>  
> -	get_online_cpus();
>  
>  	pcrypt->wq = alloc_workqueue("%s", WQ_MEM_RECLAIM | WQ_CPU_INTENSIVE,
>  				     1, name);
>  	if (!pcrypt->wq)
>  		goto err;
>  
> +	get_online_cpus();
> +
>  	pcrypt->pinst = padata_alloc_possible(pcrypt->wq);
>  	if (!pcrypt->pinst) 

Oh, forget to add put_online_cpus in this error path, will resend v2 if there is no comment.


>  		goto err_destroy_workqueue;
> @@ -448,12 +449,11 @@ static int pcrypt_init_padata(struct padata_pcrypt *pcrypt,
>  	free_cpumask_var(mask->mask);
>  	kfree(mask);
>  err_free_padata:
> +	put_online_cpus();
>  	padata_free(pcrypt->pinst);
>  err_destroy_workqueue:
>  	destroy_workqueue(pcrypt->wq);
>  err:
> -	put_online_cpus();
> -
>  	return ret;
>  }
>  

