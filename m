Return-Path: <SRS0=jAnl=6H=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337CDC55191
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 02:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E84B020747
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Apr 2020 02:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726271AbgDWCbe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Apr 2020 22:31:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2873 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725781AbgDWCbe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Apr 2020 22:31:34 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 88D166779FDD7B390461;
        Thu, 23 Apr 2020 10:31:31 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 23 Apr 2020
 10:31:21 +0800
Subject: Re: [PATCH -next] crypto: hisilicon/qm - Make qm_controller_reset()
 static
To:     Zou Wei <zou_wei@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
References: <1587608556-113975-1-git-send-email-zou_wei@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5EA0FDF4.5010601@hisilicon.com>
Date:   Thu, 23 Apr 2020 10:31:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <1587608556-113975-1-git-send-email-zou_wei@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020/4/23 10:22, Zou Wei wrote:
> Fix the following sparse warning:
> 
> drivers/crypto/hisilicon/qm.c:3079:5: warning: symbol 'qm_controller_reset'
> was not declared. Should it be static?

It should be static.

> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>

Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>

Thanks,
Zhou

> ---
>  drivers/crypto/hisilicon/qm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index 80c5525..69d02cb 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -3076,7 +3076,7 @@ static int qm_controller_reset_done(struct hisi_qm *qm)
>  	return 0;
>  }
>  
> -int qm_controller_reset(struct hisi_qm *qm)
> +static int qm_controller_reset(struct hisi_qm *qm)
>  {
>  	struct pci_dev *pdev = qm->pdev;
>  	int ret;
> 

