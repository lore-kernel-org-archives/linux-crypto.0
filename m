Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CFCC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Nov 2022 11:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbiKNLyD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Nov 2022 06:54:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235900AbiKNLxu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Nov 2022 06:53:50 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C082BB3C
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 03:49:27 -0800 (PST)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N9nYv6xHNzqSSW
        for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2022 19:45:39 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (7.193.23.164) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 19:49:25 +0800
Received: from [10.67.101.184] (10.67.101.184) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 14 Nov 2022 19:49:25 +0800
Subject: Re: [PATCH] crypto: hisilicon/qm - add missing pci_dev_put() in
 q_num_set()
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>,
        <wangzhou1@hisilicon.com>, <herbert@gondor.apana.org.au>
References: <20221111100036.129685-1-wangxiongfeng2@huawei.com>
CC:     <linux-crypto@vger.kernel.org>, <yangyingliang@huawei.com>
From:   Weili Qian <qianweili@huawei.com>
Message-ID: <0b1c041c-4368-82d4-bbce-b964e7dd4d77@huawei.com>
Date:   Mon, 14 Nov 2022 19:49:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20221111100036.129685-1-wangxiongfeng2@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.184]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


On 2022/11/11 18:00, Xiongfeng Wang wrote:
> pci_get_device() will increase the reference count for the returned
> pci_dev. We need to use pci_dev_put() to decrease the reference count
> before q_num_set() returns.
> 
> Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
> ---
>  include/linux/hisi_acc_qm.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
> index e230c7c46110..c3618255b150 100644
> --- a/include/linux/hisi_acc_qm.h
> +++ b/include/linux/hisi_acc_qm.h
> @@ -384,14 +384,14 @@ struct hisi_qp {
>  static inline int q_num_set(const char *val, const struct kernel_param *kp,
>  			    unsigned int device)
>  {
> -	struct pci_dev *pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI,
> -					      device, NULL);
> +	struct pci_dev *pdev;
>  	u32 n, q_num;
>  	int ret;
>  
>  	if (!val)
>  		return -EINVAL;
>  
> +	pdev = pci_get_device(PCI_VENDOR_ID_HUAWEI, device, NULL);
>  	if (!pdev) {
>  		q_num = min_t(u32, QM_QNUM_V1, QM_QNUM_V2);
>  		pr_info("No device found currently, suppose queue number is %u\n",
> @@ -401,6 +401,8 @@ static inline int q_num_set(const char *val, const struct kernel_param *kp,
>  			q_num = QM_QNUM_V1;
>  		else
>  			q_num = QM_QNUM_V2;
> +
> +		pci_dev_put(pdev);
>  	}
>  
>  	ret = kstrtou32(val, 10, &n);
> 

Looks good!

Reviewed-by: Weili Qian <qianweili@huawei.com>

Thanks!
