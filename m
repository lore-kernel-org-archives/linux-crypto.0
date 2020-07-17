Return-Path: <SRS0=/E9c=A4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF2D1C433E2
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 07:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A83C920704
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Jul 2020 07:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgGQHQv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Jul 2020 03:16:51 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:45068 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726113AbgGQHQv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Jul 2020 03:16:51 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id DB4F6A595D59FC99BA9F;
        Fri, 17 Jul 2020 15:16:48 +0800 (CST)
Received: from [127.0.0.1] (10.74.173.29) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Jul 2020
 15:16:42 +0800
Subject: Re: [Patch v2 8/9] crypto: hisilicon/qm - fix the process of register
 algorithms to crypto
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1593587995-7391-1-git-send-email-shenyang39@huawei.com>
 <1593587995-7391-9-git-send-email-shenyang39@huawei.com>
 <20200709053619.GA5637@gondor.apana.org.au>
 <4e79b1ce-2b2a-7db3-dc55-380c2229657a@huawei.com>
 <20200709120259.GA11508@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <xuzaibo@huawei.com>, <wangzhou1@hisilicon.com>
From:   "shenyang (M)" <shenyang39@huawei.com>
Message-ID: <7bf55d0c-76c3-8a39-4e75-7dbb393cbf82@huawei.com>
Date:   Fri, 17 Jul 2020 15:16:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200709120259.GA11508@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.173.29]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/7/9 20:02, Herbert Xu wrote:
> On Thu, Jul 09, 2020 at 07:05:11PM +0800, shenyang (M) wrote:
>>
>> Yes, this patch just fixes the bug for 'hisi_zip'. As for 'hisi_hpre'
>> and 'hisi_sec2', this patch doesn't change the logic.
>> We have noticed the problem you say, and the patch is prepared. We fix
>> this in 'hisi_qm', and you will see it soon.
>
> I cannot accept a clearly buggy patch.  So please fix this and
> resubmit.
>
> Thanks,
>

Here I give a example of hisi_hpre.ko. When the user unbind or remove
the driver, the driver checks whether the current device is stopped.

--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -903,9 +903,11 @@ static void hpre_remove(struct pci_dev *pdev)
  	struct hisi_qm *qm = pci_get_drvdata(pdev);
  	int ret;

+	hisi_qm_wait_task_finish(qm, &hpre_devices);
+
  	hisi_qm_alg_unregister(qm, &hpre_devices);
  	if (qm->fun_type == QM_HW_PF && qm->vfs_num) {
-		ret = hisi_qm_sriov_disable(pdev);
+		ret = hisi_qm_sriov_disable(pdev, qm->is_frozen);
  		if (ret) {
  			pci_err(pdev, "Disable SRIOV fail!\n");
  			return;

This patch will be add on V3.

And in 'hisi_qm_alg_unregister', the driver will only unregister
algorithm when remove the last device.

So here the algorithm will be unregistered only when nobody holds
a reference count on it.

Thanks,
Yang

