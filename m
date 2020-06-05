Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1691C433DF
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 01:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A84D20823
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 01:20:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgFEBT6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 21:19:58 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:2158 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725863AbgFEBT6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 21:19:58 -0400
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 049E4A98727A423C7765;
        Fri,  5 Jun 2020 09:19:55 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 5 Jun 2020 09:19:54 +0800
Received: from [10.65.91.233] (10.65.91.233) by dggeme762-chm.china.huawei.com
 (10.3.19.108) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1913.5; Fri, 5 Jun
 2020 09:19:54 +0800
Subject: Re: [PATCH v2] crypto: hisilicon - allow smaller reads in debugfs
To:     <b6da310b-e633-9f74-f7af-7791d803aaf5@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20200602135409.GA59808@mwanda>
From:   Shukun Tan <tanshukun1@huawei.com>
Message-ID: <3e9b204f-ef53-31c5-afcd-e0791224c2b0@huawei.com>
Date:   Fri, 5 Jun 2020 09:19:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.6.0
MIME-Version: 1.0
In-Reply-To: <20200602135409.GA59808@mwanda>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.91.233]
X-ClientProxiedBy: dggeme715-chm.china.huawei.com (10.1.199.111) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dan,

On 2020/6/2 21:54, Dan Carpenter wrote:
> Originally this code rejected any read less than 256 bytes.  There
> is no need for this artificial limit.  We should just use the normal
> helper functions to read a string from the kernel.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> v2: Use simple_read_from_buffer().  The v1 was slightly half arsed
> because I left the original check for:
> 
> 	if (*pos)
> 		return 0;
> 
> So it could result in partial reads.  The new code means that if you
> want to read the buffer one byte at a time, that's fine or if you want
> to read it in one 256 byte chunk that's also fine.  Plus it deletes 21
> lines of code and is a lot cleaner.
> 

In fact, In our original design, we do not hope the user do the partial reads.
Thank you for your work, but I still insist on adding this limit.

Thanks,
Shukun

>  drivers/crypto/hisilicon/qm.c | 33 ++++++---------------------------
>  1 file changed, 6 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index 9bb263cec6c30..13ccb9e29a2e1 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -1064,19 +1064,10 @@ static ssize_t qm_cmd_read(struct file *filp, char __user *buffer,
>  	char buf[QM_DBG_READ_LEN];
>  	int len;
>  
> -	if (*pos)
> -		return 0;
> -
> -	if (count < QM_DBG_READ_LEN)
> -		return -ENOSPC;
> +	len = scnprintf(buf, QM_DBG_READ_LEN, "%s\n",
> +			"Please echo help to cmd to get help information");
>  
> -	len = snprintf(buf, QM_DBG_READ_LEN, "%s\n",
> -		       "Please echo help to cmd to get help information");
> -
> -	if (copy_to_user(buffer, buf, len))
> -		return -EFAULT;
> -
> -	return (*pos = len);
> +	return simple_read_from_buffer(buffer, count, pos, buf, len);
>  }
>  
>  static void *qm_ctx_alloc(struct hisi_qm *qm, size_t ctx_size,
> @@ -2691,24 +2682,12 @@ static ssize_t qm_status_read(struct file *filp, char __user *buffer,
>  {
>  	struct hisi_qm *qm = filp->private_data;
>  	char buf[QM_DBG_READ_LEN];
> -	int val, cp_len, len;
> -
> -	if (*pos)
> -		return 0;
> -
> -	if (count < QM_DBG_READ_LEN)
> -		return -ENOSPC;
> +	int val, len;
>  
>  	val = atomic_read(&qm->status.flags);
> -	len = snprintf(buf, QM_DBG_READ_LEN, "%s\n", qm_s[val]);
> -	if (!len)
> -		return -EFAULT;
> -
> -	cp_len = copy_to_user(buffer, buf, len);
> -	if (cp_len)
> -		return -EFAULT;
> +	len = scnprintf(buf, QM_DBG_READ_LEN, "%s\n", qm_s[val]);
>  
> -	return (*pos = len);
> +	return simple_read_from_buffer(buffer, count, pos, buf, len);
>  }
>  
>  static const struct file_operations qm_status_fops = {
> 
