Return-Path: <SRS0=sx3D=ZG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376C3C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 13:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13F65206E6
	for <linux-crypto@archiver.kernel.org>; Thu, 14 Nov 2019 13:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfKNNkx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Nov 2019 08:40:53 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:39050 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726980AbfKNNkx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Nov 2019 08:40:53 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B21C9F72B87BDE8CC120;
        Thu, 14 Nov 2019 21:40:51 +0800 (CST)
Received: from [127.0.0.1] (10.74.180.207) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 14 Nov 2019
 21:40:42 +0800
Subject: Re: [PATCH] crypto: hisilicon - add vfs_num module param for zip
From:   "fanghao (A)" <fanghao11@huawei.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>
References: <1573098509-72682-1-git-send-email-fanghao11@huawei.com>
Message-ID: <26205249-f512-c2d2-521b-80465723a1d4@huawei.com>
Date:   Thu, 14 Nov 2019 21:40:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.5.0
MIME-Version: 1.0
In-Reply-To: <1573098509-72682-1-git-send-email-fanghao11@huawei.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.180.207]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ÔÚ 2019/11/7 11:48, Hao Fang Ð´µÀ:
> Currently the VF can be enabled only through sysfs interface
> after module loaded, but this also needs to be done when the
> module loaded in some scenarios.
> 
> This patch adds module param vfs_num, adds hisi_zip_sriov_enable()
> in probe, and also adjusts the position of probe.
> 
> Signed-off-by: Hao Fang <fanghao11@huawei.com>
> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
> ---
>   drivers/crypto/hisilicon/zip/zip_main.c | 182 +++++++++++++++++---------------
>   1 file changed, 98 insertions(+), 84 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
> index 255b63c..e42c3a84 100644
> --- a/drivers/crypto/hisilicon/zip/zip_main.c
> +++ b/drivers/crypto/hisilicon/zip/zip_main.c
> @@ -301,6 +301,10 @@ MODULE_PARM_DESC(pf_q_num, "Number of queues in PF(v1 1-4096, v2 1-1024)");
>   static int uacce_mode;
>   module_param(uacce_mode, int, 0);
>   
> +static u32 vfs_num;
> +module_param(vfs_num, uint, 0444);
> +MODULE_PARM_DESC(vfs_num, "Number of VFs to enable(1-63)");
> +
>   static const struct pci_device_id hisi_zip_dev_ids[] = {
>   	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_ZIP_PF) },
>   	{ PCI_DEVICE(PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_ZIP_VF) },
> @@ -685,90 +689,6 @@ static int hisi_zip_pf_probe_init(struct hisi_zip *hisi_zip)
>   	return 0;
>   }
>   
> -static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> -{
> -	struct hisi_zip *hisi_zip;
> -	enum qm_hw_ver rev_id;
> -	struct hisi_qm *qm;
> -	int ret;
> -
> -	rev_id = hisi_qm_get_hw_version(pdev);
> -	if (rev_id == QM_HW_UNKNOWN)
> -		return -EINVAL;
> -
> -	hisi_zip = devm_kzalloc(&pdev->dev, sizeof(*hisi_zip), GFP_KERNEL);
> -	if (!hisi_zip)
> -		return -ENOMEM;
> -	pci_set_drvdata(pdev, hisi_zip);
> -
> -	qm = &hisi_zip->qm;
> -	qm->pdev = pdev;
> -	qm->ver = rev_id;
> -
> -	qm->sqe_size = HZIP_SQE_SIZE;
> -	qm->dev_name = hisi_zip_name;
> -	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ? QM_HW_PF :
> -								QM_HW_VF;
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
> -	ret = hisi_qm_init(qm);
> -	if (ret) {
> -		dev_err(&pdev->dev, "Failed to init qm!\n");
> -		return ret;
> -	}
> -
> -	if (qm->fun_type == QM_HW_PF) {
> -		ret = hisi_zip_pf_probe_init(hisi_zip);
> -		if (ret)
> -			return ret;
> -
> -		qm->qp_base = HZIP_PF_DEF_Q_BASE;
> -		qm->qp_num = pf_q_num;
> -	} else if (qm->fun_type == QM_HW_VF) {
> -		/*
> -		 * have no way to get qm configure in VM in v1 hardware,
> -		 * so currently force PF to uses HZIP_PF_DEF_Q_NUM, and force
> -		 * to trigger only one VF in v1 hardware.
> -		 *
> -		 * v2 hardware has no such problem.
> -		 */
> -		if (qm->ver == QM_HW_V1) {
> -			qm->qp_base = HZIP_PF_DEF_Q_NUM;
> -			qm->qp_num = HZIP_QUEUE_NUM_V1 - HZIP_PF_DEF_Q_NUM;
> -		} else if (qm->ver == QM_HW_V2)
> -			/* v2 starts to support get vft by mailbox */
> -			hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
> -	}
> -
> -	ret = hisi_qm_start(qm);
> -	if (ret)
> -		goto err_qm_uninit;
> -
> -	ret = hisi_zip_debugfs_init(hisi_zip);
> -	if (ret)
> -		dev_err(&pdev->dev, "Failed to init debugfs (%d)!\n", ret);
> -
> -	hisi_zip_add_to_list(hisi_zip);
> -
> -	return 0;
> -
> -err_qm_uninit:
> -	hisi_qm_uninit(qm);
> -	return ret;
> -}
> -
>   /* Currently we only support equal assignment */
>   static int hisi_zip_vf_q_assign(struct hisi_zip *hisi_zip, int num_vfs)
>   {
> @@ -865,6 +785,100 @@ static int hisi_zip_sriov_disable(struct pci_dev *pdev)
>   	return hisi_zip_clear_vft_config(hisi_zip);
>   }
>   
> +static int hisi_zip_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> +	struct hisi_zip *hisi_zip;
> +	enum qm_hw_ver rev_id;
> +	struct hisi_qm *qm;
> +	int ret;
> +
> +	rev_id = hisi_qm_get_hw_version(pdev);
> +	if (rev_id == QM_HW_UNKNOWN)
> +		return -EINVAL;
> +
> +	hisi_zip = devm_kzalloc(&pdev->dev, sizeof(*hisi_zip), GFP_KERNEL);
> +	if (!hisi_zip)
> +		return -ENOMEM;
> +	pci_set_drvdata(pdev, hisi_zip);
> +
> +	qm = &hisi_zip->qm;
> +	qm->pdev = pdev;
> +	qm->ver = rev_id;
> +
> +	qm->sqe_size = HZIP_SQE_SIZE;
> +	qm->dev_name = hisi_zip_name;
> +	qm->fun_type = (pdev->device == PCI_DEVICE_ID_ZIP_PF) ? QM_HW_PF :
> +								QM_HW_VF;
> +	switch (uacce_mode) {
> +	case 0:
> +		qm->use_dma_api = true;
> +		break;
> +	case 1:
> +		qm->use_dma_api = false;
> +		break;
> +	case 2:
> +		qm->use_dma_api = true;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = hisi_qm_init(qm);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Failed to init qm!\n");
> +		return ret;
> +	}
> +
> +	if (qm->fun_type == QM_HW_PF) {
> +		ret = hisi_zip_pf_probe_init(hisi_zip);
> +		if (ret)
> +			return ret;
> +
> +		qm->qp_base = HZIP_PF_DEF_Q_BASE;
> +		qm->qp_num = pf_q_num;
> +	} else if (qm->fun_type == QM_HW_VF) {
> +		/*
> +		 * have no way to get qm configure in VM in v1 hardware,
> +		 * so currently force PF to uses HZIP_PF_DEF_Q_NUM, and force
> +		 * to trigger only one VF in v1 hardware.
> +		 *
> +		 * v2 hardware has no such problem.
> +		 */
> +		if (qm->ver == QM_HW_V1) {
> +			qm->qp_base = HZIP_PF_DEF_Q_NUM;
> +			qm->qp_num = HZIP_QUEUE_NUM_V1 - HZIP_PF_DEF_Q_NUM;
> +		} else if (qm->ver == QM_HW_V2)
> +			/* v2 starts to support get vft by mailbox */
> +			hisi_qm_get_vft(qm, &qm->qp_base, &qm->qp_num);
> +	}
> +
> +	ret = hisi_qm_start(qm);
> +	if (ret)
> +		goto err_qm_uninit;
> +
> +	ret = hisi_zip_debugfs_init(hisi_zip);
> +	if (ret)
> +		dev_err(&pdev->dev, "Failed to init debugfs (%d)!\n", ret);
> +
> +	hisi_zip_add_to_list(hisi_zip);
> +
> +	if (qm->fun_type == QM_HW_PF && vfs_num > 0) {
> +		ret = hisi_zip_sriov_enable(pdev, vfs_num);
> +		if (ret < 0)
> +			goto err_remove_from_list;
> +	}
> +
> +	return 0;
> +
> +err_remove_from_list:
> +	hisi_zip_remove_from_list(hisi_zip);
> +	hisi_zip_debugfs_exit(hisi_zip);
> +	hisi_qm_stop(qm);
> +err_qm_uninit:
> +	hisi_qm_uninit(qm);
> +	return ret;
> +}
> +
>   static int hisi_zip_sriov_configure(struct pci_dev *pdev, int num_vfs)
>   {
>   	if (num_vfs == 0)
> 

Any comments for this patch?

Best,
Hao


