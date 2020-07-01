Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA5C6C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 07:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B766020722
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 07:01:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgGAHBS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 03:01:18 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7323 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727981AbgGAHBR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 03:01:17 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 7CD06EEF3B31F218F357;
        Wed,  1 Jul 2020 15:01:15 +0800 (CST)
Received: from [127.0.0.1] (10.74.173.29) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Wed, 1 Jul 2020
 15:01:09 +0800
Subject: Re: [PATCH 1/9] crypto: hisilicon/qm - fix wrong release after using
 strsep
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
References: <1593428948-64634-1-git-send-email-shenyang39@huawei.com>
 <1593428948-64634-2-git-send-email-shenyang39@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <xuzaibo@huawei.com>,
        <wangzhou1@hisilicon.com>
From:   "shenyang (M)" <shenyang39@huawei.com>
Message-ID: <5e8e524a-7670-549a-e551-7f4260f3794c@huawei.com>
Date:   Wed, 1 Jul 2020 15:01:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <1593428948-64634-2-git-send-email-shenyang39@huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.173.29]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/6/29 19:09, Yang Shen wrote:
> From: Sihang Chen <chensihang1@hisilicon.com>
>
> Save the string address before pass to strsep, release it at end.
> Because strsep will update the string address to point after the
> token.
>
> Fixes: c31dc9fe165d("crypto: hisilicon/qm - add DebugFS for xQC and...")
> Signed-off-by: Sihang Chen <chensihang1@huawei.com>

I'm sorry I made mistake here of the email address.
Soon I will fix this on v2.

> Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
> ---
>  drivers/crypto/hisilicon/qm.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index 9bb263c..ad0adcc 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -1429,16 +1429,17 @@ static int qm_dbg_help(struct hisi_qm *qm, char *s)
>  static int qm_cmd_write_dump(struct hisi_qm *qm, const char *cmd_buf)
>  {
>  	struct device *dev = &qm->pdev->dev;
> -	char *presult, *s;
> +	char *presult, *s, *s_tmp;
>  	int ret;
>
>  	s = kstrdup(cmd_buf, GFP_KERNEL);
>  	if (!s)
>  		return -ENOMEM;
>
> +	s_tmp = s;
>  	presult = strsep(&s, " ");
>  	if (!presult) {
> -		kfree(s);
> +		kfree(s_tmp);
>  		return -EINVAL;
>  	}
>
> @@ -1468,7 +1469,7 @@ static int qm_cmd_write_dump(struct hisi_qm *qm, const char *cmd_buf)
>  	if (ret)
>  		dev_info(dev, "Please echo help\n");
>
> -	kfree(s);
> +	kfree(s_tmp);
>
>  	return ret;
>  }
>

