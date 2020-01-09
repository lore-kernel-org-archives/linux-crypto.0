Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F435C282DD
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 17:40:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D25A20661
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 17:40:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731751AbgAIRkn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 12:40:43 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2244 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730235AbgAIRkm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 12:40:42 -0500
Received: from LHREML713-CAH.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id BB3077B600EED500EEA3;
        Thu,  9 Jan 2020 17:40:41 +0000 (GMT)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 LHREML713-CAH.china.huawei.com (10.201.108.36) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 9 Jan 2020 17:40:41 +0000
Received: from localhost (10.202.226.57) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 9 Jan 2020
 17:40:40 +0000
Date:   Thu, 9 Jan 2020 17:40:39 +0000
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Zhangfei Gao <zhangfei.gao@linaro.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <grant.likely@arm.com>, jean-philippe <jean-philippe@linaro.org>,
        "Jerome Glisse" <jglisse@redhat.com>,
        <ilias.apalodimas@linaro.org>, <francois.ozog@linaro.org>,
        <kenneth-lee-2012@foxmail.com>, Wangzhou <wangzhou1@hisilicon.com>,
        "haojian . zhuang" <haojian.zhuang@linaro.org>,
        <guodong.xu@linaro.org>, <linux-accelerators@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH v10 3/4] crypto: hisilicon - Remove module_param
 uacce_mode
Message-ID: <20200109174039.0000338c@Huawei.com>
In-Reply-To: <1576465697-27946-4-git-send-email-zhangfei.gao@linaro.org>
References: <1576465697-27946-1-git-send-email-zhangfei.gao@linaro.org>
        <1576465697-27946-4-git-send-email-zhangfei.gao@linaro.org>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.57]
X-ClientProxiedBy: lhreml711-chm.china.huawei.com (10.201.108.62) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 16 Dec 2019 11:08:16 +0800
Zhangfei Gao <zhangfei.gao@linaro.org> wrote:

> Remove the module_param uacce_mode, which is not used currently.
> 
> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>


Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/crypto/hisilicon/zip/zip_main.c | 31 ++++++-------------------------
>  1 file changed, 6 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index e1bab1a..93345f0 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -297,9 +297,6 @@ static u32 pf_q_num = HZIP_PF_DEF_Q_NUM;
>  module_param_cb(pf_q_num, &pf_q_num_ops, &pf_q_num, 0444);
>  MODULE_PARM_DESC(pf_q_num, "Number of queues in PF(v1 1-4096, v2 1-1024)");
>  
> -static int uacce_mode;
> -module_param(uacce_mode, int, 0);
> -
>  static u32 vfs_num;
>  module_param(vfs_num, uint, 0444);
>  MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63)");
> @@ -791,6 +788,7 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	pci_set_drvdata(pdev, hisi_zip);
>  
>  	qm = &hisi_zip->qm;
> +	qm->use_dma_api = true;
>  	qm->pdev = pdev;
>  	qm->ver = rev_id;
>  
> @@ -798,20 +796,6 @@ static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  	qm->dev_name = hisi_zip_name;
>  	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ? QM_HW_PF :
>  								QM_HW_VF;
> -	switch (uacce_mode) {
> -	case 0:
> -		qm->use_dma_api = true;
> -		break;
> -	case 1:
> -		qm->use_dma_api = false;
> -		break;
> -	case 2:
> -		qm->use_dma_api = true;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
>  	ret = hisi_qm_init(qm);
>  	if (ret) {
>  		dev_err(&pdev->dev, "Failed to init qm!\n");
> @@ -1010,12 +994,10 @@ static int __init hisi_zip_init(void)
>  		goto err_pci;
>  	}
>  
> -	if (uacce_mode == 0 || uacce_mode == 2) {
> -		ret = hisi_zip_register_to_crypto();
> -		if (ret < 0) {
> -			pr_err("Failed to register driver to crypto.\n");
> -			goto err_crypto;
> -		}
> +	ret = hisi_zip_register_to_crypto();
> +	if (ret < 0) {
> +		pr_err("Failed to register driver to crypto.\n");
> +		goto err_crypto;
>  	}
>  
>  	return 0;
> @@ -1030,8 +1012,7 @@ static int __init hisi_zip_init(void)
>  
>  static void __exit hisi_zip_exit(void)
>  {
> -	if (uacce_mode == 0 || uacce_mode == 2)
> -		hisi_zip_unregister_from_crypto();
> +	hisi_zip_unregister_from_crypto();
>  	pci_unregister_driver(&hisi_zip_pci_driver);
>  	hisi_zip_unregister_debugfs();
>  }


