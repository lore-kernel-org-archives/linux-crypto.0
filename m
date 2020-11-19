Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A1AC2D0E4
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 08:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01E9924654
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 08:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgKSIt0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Nov 2020 03:49:26 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7703 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgKSItZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Nov 2020 03:49:25 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CcCyk4tr9zkY2y;
        Thu, 19 Nov 2020 16:49:02 +0800 (CST)
Received: from [10.63.139.185] (10.63.139.185) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Thu, 19 Nov 2020 16:49:12 +0800
Subject: Re: [PATCH] crypto: hisilicon/zip - add a work_queue for zip irq
To:     Yang Shen <shenyang39@huawei.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>
References: <1605259955-17796-1-git-send-email-shenyang39@huawei.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5FB63188.5050303@hisilicon.com>
Date:   Thu, 19 Nov 2020 16:49:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <1605259955-17796-1-git-send-email-shenyang39@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2020/11/13 17:32, Yang Shen wrote:
> The patch 'irqchip/gic-v3-its: Balance initial LPI affinity across CPUs'
> set the IRQ to an uncentain CPU. If an IRQ is bound to the CPU used by the
> thread which is sending request, the throughput will be just half.
> 
> So allocate a 'work_queue' and set as 'WQ_UNBOUND' to do the back half work
> on some different CPUS.
> 
> Signed-off-by: Yang Shen <shenyang39@huawei.com>
> Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>

Reviewed-by: Zhou Wang <wangzhou1@hisilicon.com>

Thanks,
Zhou

> ---
>  drivers/crypto/hisilicon/zip/zip_main.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index 3d1524b..4fb5a32b 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -747,6 +747,8 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
> 
>  static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
>  {
> +	int ret;
> +
>  	qm->pdev = pdev;
>  	qm->ver = pdev->revision;
>  	qm->algs = "zlib\ngzip";
> @@ -772,7 +774,25 @@ static int hisi_zip_qm_init(struct hisi_qm *qm, struct pci_dev *pdev)
>  		qm->qp_num = HZIP_QUEUE_NUM_V1 - HZIP_PF_DEF_Q_NUM;
>  	}
> 
> -	return hisi_qm_init(qm);
> +	qm->wq = alloc_workqueue("%s", WQ_HIGHPRI | WQ_MEM_RECLAIM |
> +				 WQ_UNBOUND, num_online_cpus(),
> +				 pci_name(qm->pdev));
> +	if (!qm->wq) {
> +		pci_err(qm->pdev, "fail to alloc workqueue\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret = hisi_qm_init(qm);
> +	if (ret)
> +		destroy_workqueue(qm->wq);
> +
> +	return ret;
> +}
> +
> +static void hisi_zip_qm_uninit(struct hisi_qm *qm)
> +{
> +	hisi_qm_uninit(qm);
> +	destroy_workqueue(qm->wq);
>  }
> 
>  static int hisi_zip_probe_init(struct hisi_zip *hisi_zip)
> @@ -854,7 +874,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	hisi_qm_dev_err_uninit(qm);
> 
>  err_qm_uninit:
> -	hisi_qm_uninit(qm);
> +	hisi_zip_qm_uninit(qm);
> 
>  	return ret;
>  }
> @@ -872,7 +892,7 @@ static void hisi_zip_remove(struct pci_dev *pdev)
>  	hisi_zip_debugfs_exit(qm);
>  	hisi_qm_stop(qm, QM_NORMAL);
>  	hisi_qm_dev_err_uninit(qm);
> -	hisi_qm_uninit(qm);
> +	hisi_zip_qm_uninit(qm);
>  }
> 
>  static const struct pci_error_handlers hisi_zip_err_handler = {
> --
> 2.7.4
> 
> .
> 
