Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B00EC282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C94920857
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfBAHPp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:15:45 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:3262 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726092AbfBAHPp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:15:45 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1046114D7D26B31565BA;
        Fri,  1 Feb 2019 15:15:43 +0800 (CST)
Received: from [127.0.0.1] (10.63.139.185) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.408.0; Fri, 1 Feb 2019
 15:15:35 +0800
Subject: Re: [PATCH v2 2/4] crypto: hisilicon: Add queue management driver for
 HiSilicon QM module
To:     Herbert Xu <herbert@gondor.apana.org.au>
References: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
 <1548248933-149853-3-git-send-email-wangzhou1@hisilicon.com>
 <20190201052229.wnjeirur6ephew7y@gondor.apana.org.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        Hao Fang <fanghao11@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
Message-ID: <5C53F22A.2020804@hisilicon.com>
Date:   Fri, 1 Feb 2019 15:15:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.5.1
MIME-Version: 1.0
In-Reply-To: <20190201052229.wnjeirur6ephew7y@gondor.apana.org.au>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.63.139.185]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 2019/2/1 13:22, Herbert Xu wrote:
> On Wed, Jan 23, 2019 at 09:08:51PM +0800, Zhou Wang wrote:
>>
>> +/**
>> + * hisi_qp_poll() - Poll current cqe to see if a task is finished.
>> + * @qp: The qp which will poll.
>> + *
>> + * This function polls current cqe for a give qp to see if a task is finished.
>> + * Return -ETIME if timeout.
>> + */
>> +int hisi_qp_poll(struct hisi_qp *qp)
>> +{
>> +	struct qm_cqe *cqe = qp->cqe + qp->qp_status.cq_head;
>> +	struct qm_cqc *cqc = qp->cqc;
>> +	int retries = 1000;
>> +
>> +	while (!(QM_CQE_PHASE(cqe) == (cqc->dw6 & 0x1))) {
>> +		dma_rmb();
>> +		if (!--retries) {
>> +			dev_err(&qp->qm->pdev->dev, "Poll cqe failed!\n");
>> +			return -ETIME;
>> +		}
>> +		udelay(10);
>> +	}
>> +
>> +	qm_cq_head_update(qp);
>> +	atomic_dec(&qp->qp_status.used);
>> +
>> +	qm_db(qp->qm, qp->qp_id, QM_DOORBELL_CMD_CQ, qp->qp_status.cq_head, 0);
>> +	/* set c_flag */
>> +	qm_db(qp->qm, qp->qp_id, QM_DOORBELL_CMD_CQ, qp->qp_status.cq_head, 1);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(hisi_qp_poll);
> 
> Polling in softirq context is unacceptable.  Can't your hardware
> send interrupts to signal completion? What is the average speed
> of processing a single 1500-byte packet on your hardware?

Our hardware supports interrupt. In fact, implementation of compress/decompress
interface of crypto_alg in v1 was done using interrupt:

 compress/decompress:
     send task to hardware
     wait task finished(wait_for_completion_timeout)

 In irq handler:
     complete

However, there is get_cpu/put_cpu in scomp, wait and complete in above has to be
changed to poll:

 compress/decompress:
     send task to hardware
     check if task is finished

The average speed of this zip engine is 7.5GB/s, so it will take about 0.2us to
process 1500B.

Best,
Zhou

> 
> Cheers,
> 

