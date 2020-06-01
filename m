Return-Path: <SRS0=veUY=7O=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377FFC433DF
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 02:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A7F1206A4
	for <linux-crypto@archiver.kernel.org>; Mon,  1 Jun 2020 02:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgFACTE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 May 2020 22:19:04 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:2513 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726860AbgFACTE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 May 2020 22:19:04 -0400
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.57])
        by Forcepoint Email with ESMTP id 9893F90A4FBC51007D1C;
        Mon,  1 Jun 2020 10:19:01 +0800 (CST)
Received: from dggeme762-chm.china.huawei.com (10.3.19.108) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 1 Jun 2020 10:19:01 +0800
Received: from [10.65.91.233] (10.65.91.233) by dggeme762-chm.china.huawei.com
 (10.3.19.108) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1913.5; Mon, 1 Jun
 2020 10:19:01 +0800
Subject: Re: [PATCH] crypto: hisilicon/qm - allow smaller reads in debugfs
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20200528123703.GA1219412@mwanda>
From:   Shukun Tan <tanshukun1@huawei.com>
Message-ID: <b6da310b-e633-9f74-f7af-7791d803aaf5@huawei.com>
Date:   Mon, 1 Jun 2020 10:19:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.6.0
MIME-Version: 1.0
In-Reply-To: <20200528123703.GA1219412@mwanda>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.91.233]
X-ClientProxiedBy: dggeme719-chm.china.huawei.com (10.1.199.115) To
 dggeme762-chm.china.huawei.com (10.3.19.108)
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Dan & Zhou,

On 2020/5/28 20:37, Dan Carpenter wrote:
> Originally this code rejected any read less than 256 bytes.  There
> is no need for this artificial limit.
> 
> Also I have changed the snprintf() functions to scnprintf().  The
> difference is that snprintf() returns the number of bytes which would
> have been copied if there were enough space and scnprintf() returns the
> number of bytes which were actually copied.  It doesn't matter here
> because the strings are very short so they can't go over 256 bytes.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index a781c02251980..9c0c9f500d91d 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -1076,16 +1076,15 @@ static ssize_t qm_cmd_read(struct file *filp, char __user *buffer,
>  	if (*pos)
>  		return 0;
>  
> -	if (count < QM_DBG_READ_LEN)
> -		return -ENOSPC;
> -

I think we should keep it, maybe you are right when using 'cat', but if you use 'read'
system call this may make the user read only part of the prompt. This may break our
original design. :)

Thanks,
Shukun

> -	len = snprintf(buf, QM_DBG_READ_LEN, "%s\n",
> +	len = scnprintf(buf, QM_DBG_READ_LEN, "%s\n",
>  		       "Please echo help to cmd to get help information");
>  
> +	len = min_t(size_t, len, count);
>  	if (copy_to_user(buffer, buf, len))
>  		return -EFAULT;
>  
> -	return (*pos = len);
> +	*pos = len;
> +	return len;
>  }
>  
>  static void *qm_ctx_alloc(struct hisi_qm *qm, size_t ctx_size,
> @@ -2710,19 +2709,18 @@ static ssize_t qm_status_read(struct file *filp, char __user *buffer,
>  	if (*pos)
>  		return 0;
>  
> -	if (count < QM_DBG_READ_LEN)
> -		return -ENOSPC;
> -
>  	val = atomic_read(&qm->status.flags);
> -	len = snprintf(buf, QM_DBG_READ_LEN, "%s\n", qm_s[val]);
> +	len = scnprintf(buf, QM_DBG_READ_LEN, "%s\n", qm_s[val]);
>  	if (!len)
>  		return -EFAULT;
>  
> +	len = min_t(size_t, len, count);
>  	cp_len = copy_to_user(buffer, buf, len);
>  	if (cp_len)
>  		return -EFAULT;
>  
> -	return (*pos = len);
> +	*pos = len;
> +	return len;
>  }
>  
>  static const struct file_operations qm_status_fops = {
> 
