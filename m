Return-Path: <SRS0=CDDf=4T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C99CC3F2D2
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 11:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DE422086A
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 11:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgCBLyM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Mar 2020 06:54:12 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2490 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727485AbgCBLyM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Mar 2020 06:54:12 -0500
Received: from LHREML711-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 886973436FDF33285904;
        Mon,  2 Mar 2020 11:54:11 +0000 (GMT)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 LHREML711-CAH.china.huawei.com (10.201.108.34) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 2 Mar 2020 11:54:10 +0000
Received: from localhost (10.202.226.57) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 2 Mar 2020
 11:54:10 +0000
Date:   Mon, 2 Mar 2020 11:54:09 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Zaibo Xu <xuzaibo@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <qianweili@huawei.com>, <tanghui20@huawei.com>,
        <forest.zhouchang@huawei.com>, <linuxarm@huawei.com>,
        <zhangwei375@huawei.com>, <yekai13@huawei.com>,
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] crypto: hisilicon/sec2 - Add iommu status check
Message-ID: <20200302115409.0000685e@Huawei.com>
In-Reply-To: <1583129716-28382-4-git-send-email-xuzaibo@huawei.com>
References: <1583129716-28382-1-git-send-email-xuzaibo@huawei.com>
        <1583129716-28382-4-git-send-email-xuzaibo@huawei.com>
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

On Mon, 2 Mar 2020 14:15:14 +0800
Zaibo Xu <xuzaibo@huawei.com> wrote:

> From: liulongfang <liulongfang@huawei.com>
> 
> In order to improve performance of small packets (<512Bytes)
> in SMMU translation scenario,We need to identify the type of IOMMU
> in the SEC probe to process small packets by a different method.
> 
> Signed-off-by: liulongfang <liulongfang@huawei.com>
> Reviewed-by: Zaibo Xu <xuzaibo@huawei.com>

This looks like what we ended up with for the SECv1 driver.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
>  drivers/crypto/hisilicon/sec2/sec.h      |  1 +
>  drivers/crypto/hisilicon/sec2/sec_main.c | 19 +++++++++++++++++++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/drivers/crypto/hisilicon/sec2/sec.h b/drivers/crypto/hisilicon/sec2/sec.h
> index 13e2d8d..eab0d22 100644
> --- a/drivers/crypto/hisilicon/sec2/sec.h
> +++ b/drivers/crypto/hisilicon/sec2/sec.h
> @@ -165,6 +165,7 @@ struct sec_dev {
>  	struct list_head list;
>  	struct sec_debug debug;
>  	u32 ctx_q_num;
> +	bool iommu_used;
>  	u32 num_vfs;
>  	unsigned long status;
>  };
> diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
> index ebafc1c..6466d90 100644
> --- a/drivers/crypto/hisilicon/sec2/sec_main.c
> +++ b/drivers/crypto/hisilicon/sec2/sec_main.c
> @@ -7,6 +7,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/init.h>
>  #include <linux/io.h>
> +#include <linux/iommu.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/pci.h>
> @@ -826,6 +827,23 @@ static void sec_probe_uninit(struct hisi_qm *qm)
>  	destroy_workqueue(qm->wq);
>  }
>  
> +static void sec_iommu_used_check(struct sec_dev *sec)
> +{
> +	struct iommu_domain *domain;
> +	struct device *dev = &sec->qm.pdev->dev;
> +
> +	domain = iommu_get_domain_for_dev(dev);
> +
> +	/* Check if iommu is used */
> +	sec->iommu_used = false;
> +	if (domain) {
> +		if (domain->type & __IOMMU_DOMAIN_PAGING)
> +			sec->iommu_used = true;
> +		dev_info(dev, "SMMU Opened, the iommu type = %u\n",
> +			domain->type);
> +	}
> +}
> +
>  static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  {
>  	struct sec_dev *sec;
> @@ -839,6 +857,7 @@ static int sec_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	pci_set_drvdata(pdev, sec);
>  
>  	sec->ctx_q_num = ctx_q_num;
> +	sec_iommu_used_check(sec);
>  
>  	qm = &sec->qm;
>  


