Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E49C433C1
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 10:30:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B43B5619FF
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Mar 2021 10:30:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229883AbhC0KaC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Mar 2021 06:30:02 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15076 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhC0KaC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Mar 2021 06:30:02 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F6w5p1VlMz1BFM8;
        Sat, 27 Mar 2021 18:27:58 +0800 (CST)
Received: from [10.67.102.118] (10.67.102.118) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Mar 2021 18:29:50 +0800
Subject: Re: [PATCH] crypto: hisilicon/sec - Fix a module parameter error
To:     <herbert@gondor.apana.org.au>, <wangzhou1@hisilicon.com>
CC:     <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1616837358-15112-1-git-send-email-liulongfang@huawei.com>
From:   liulongfang <liulongfang@huawei.com>
Message-ID: <354738e6-1c4b-66c4-ff89-ecac70d47c9e@huawei.com>
Date:   Sat, 27 Mar 2021 18:29:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1616837358-15112-1-git-send-email-liulongfang@huawei.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.118]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2021/3/27 17:29, Longfang Liu Wrote:
> ctx_q_num is a module parameter set by the user to specify the
> number of qp queues required to create a ctx.
> 
> When the number of qp queues allocated by PF or VF is less than
> the ctx_q_num, an error will be reported when ctx is initialized
> in kernel mode, which leads to the problem that the registered
> algorithms cannot be used.
> 
> Therefore, when PF or VF is initialized, if the number of qp queues
> is not enough to create a ctx, the kernel mode cannot be used,
> and there is no need to register the kernel mode algorithms.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec_main.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index b1818f7..c7b71b6 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -867,10 +867,15 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	if (ret)
>  		pci_warn(pdev, "Failed to init debugfs!\n");
>  
> -	ret = hisi_qm_alg_register(qm, &sec_devices);
> -	if (ret < 0) {
> -		pr_err("Failed to register driver to crypto.\n");
> -		goto err_qm_stop;
> +	if (qm->qp_num >= ctx_q_num) {
> +		ret = hisi_qm_alg_register(qm, &sec_devices);
> +		if (ret < 0) {
> +			pr_err("Failed to register driver to crypto.\n");
> +			goto err_qm_stop;
> +		}
> +	} else {
> +		pci_warn(qm->pdev,
> +			"Failed to use kernel mode, qp not enough!\n");
>  	}
>  
>  	if (qm->uacce) {
> 
Sorry, please don't reply to this patch, I will resend it again.
Thanks,
Longfang
