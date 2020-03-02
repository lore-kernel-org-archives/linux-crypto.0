Return-Path: <SRS0=CDDf=4T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D72C3F2D2
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 11:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40D6320863
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 11:51:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCBLvG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Mar 2020 06:51:06 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2489 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726806AbgCBLvG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Mar 2020 06:51:06 -0500
Received: from lhreml705-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id D04E8733BB11D338FC64;
        Mon,  2 Mar 2020 11:51:04 +0000 (GMT)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml705-cah.china.huawei.com (10.201.108.46) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 2 Mar 2020 11:51:04 +0000
Received: from localhost (10.202.226.57) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 2 Mar 2020
 11:51:04 +0000
Date:   Mon, 2 Mar 2020 11:51:03 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Zaibo Xu <xuzaibo@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <qianweili@huawei.com>, <tanghui20@huawei.com>,
        <forest.zhouchang@huawei.com>, <linuxarm@huawei.com>,
        <zhangwei375@huawei.com>, <yekai13@huawei.com>,
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] crypto: hisilicon/sec2 - Add workqueue for SEC
 driver.
Message-ID: <20200302115103.00005d06@Huawei.com>
In-Reply-To: <1583129716-28382-3-git-send-email-xuzaibo@huawei.com>
References: <1583129716-28382-1-git-send-email-xuzaibo@huawei.com>
        <1583129716-28382-3-git-send-email-xuzaibo@huawei.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.57]
X-ClientProxiedBy: lhreml730-chm.china.huawei.com (10.201.108.81) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 2 Mar 2020 14:15:13 +0800
Zaibo Xu <xuzaibo@huawei.com> wrote:

> From: yekai13 <yekai13@huawei.com>
> 
> Allocate one workqueue for each QM instead of one for all QMs,
> we found the throughput of SEC engine can be increased to
> the hardware limit throughput during testing sec2 performance.
> so we added this scheme.
> 
> Signed-off-by: yekai13 <yekai13@huawei.com>
> Signed-off-by: liulongfang <liulongfang@huawei.com>

That first sign off needs fixing.  Needs to be a real name.

Also missing xuzaibo's sign offf.

A question inline that might be worth a follow up patch.

With signoffs fixed

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Thanks,

Jonathan

> ---
>  drivers/crypto/hisilicon/sec2/sec_main.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index 3767fdb..ebafc1c 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -774,12 +774,24 @@ static void sec_qm_uninit(struct hisi_qm *qm)
>  
>  static int sec_probe_init(struct hisi_qm *qm, struct sec_dev *sec)
>  {
> +	int ret;
> +
> +	qm->wq = alloc_workqueue("%s", WQ_HIGHPRI | WQ_CPU_INTENSIVE |
> +		WQ_MEM_RECLAIM | WQ_UNBOUND, num_online_cpus(),
> +		pci_name(qm->pdev));

I appreciate that you have the same parameters here as were originally in
qm.c, but I would like to fully understand why some of these flags are set.

Perhaps a comment for each of them?  I'm not sure I'd consider the work
to be done in this work queue CPU_INTENSIVE for example.

This could be a follow up patch though as not actually related to this
change.

> +	if (!qm->wq) {
> +		pci_err(qm->pdev, "fail to alloc workqueue\n");
> +		return -ENOMEM;
> +	}
> +
>  	if (qm->fun_type == QM_HW_PF) {
>  		qm->qp_base = SEC_PF_DEF_Q_BASE;
>  		qm->qp_num = pf_q_num;
>  		qm->debug.curr_qm_qp_num = pf_q_num;
>  
> -		return sec_pf_probe_init(sec);
> +		ret = sec_pf_probe_init(sec);
> +		if (ret)
> +			goto err_probe_uninit;
>  	} else if (qm->fun_type == QM_HW_VF) {
>  		/*
>  		 * have no way to get qm configure in VM in v1 hardware,
> @@ -792,18 +804,26 @@ static int sec_probe_init(struct hisi_qm *qm, struct sec_dev *sec)
>  			qm->qp_num = SEC_QUEUE_NUM_V1 - SEC_PF_DEF_Q_NUM;
>  		} else if (qm->ver == QM_HW_V2) {
>  			/* v2 starts to support get vft by mailbox */
> -			return hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
> +			ret = hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
> +			if (ret)
> +				goto err_probe_uninit;
>  		}
>  	} else {
> -		return -ENODEV;
> +		ret = -ENODEV;
> +		goto err_probe_uninit;
>  	}
>  
>  	return 0;
> +err_probe_uninit:
> +	destroy_workqueue(qm->wq);
> +	return ret;
>  }
>  
>  static void sec_probe_uninit(struct hisi_qm *qm)
>  {
>  	hisi_qm_dev_err_uninit(qm);
> +
> +	destroy_workqueue(qm->wq);
>  }
>  
>  static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)


