Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB479C3F2CD
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 01:38:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B49EB21D56
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 01:38:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgCCBir (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Mar 2020 20:38:47 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11134 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726773AbgCCBir (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Mar 2020 20:38:47 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id D4BF1EF4F5747829B44C;
        Tue,  3 Mar 2020 09:38:43 +0800 (CST)
Received: from [127.0.0.1] (10.67.101.242) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Tue, 3 Mar 2020
 09:38:37 +0800
Subject: Re: [PATCH v2 1/5] crypto: hisilicon - Use one workqueue per qm
 instead of per qp
To:     Jonathan Cameron <Jonathan.Cameron@Huawei.com>
References: <1583129716-28382-1-git-send-email-xuzaibo@huawei.com>
 <1583129716-28382-2-git-send-email-xuzaibo@huawei.com>
 <20200302113946.000062f0@Huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <qianweili@huawei.com>, <tanghui20@huawei.com>,
        <forest.zhouchang@huawei.com>, <linuxarm@huawei.com>,
        <zhangwei375@huawei.com>, <yekai13@huawei.com>,
        <linux-crypto@vger.kernel.org>
From:   Xu Zaibo <xuzaibo@huawei.com>
Message-ID: <4f1eae2f-c22a-0e65-e080-c0a473d91b7b@huawei.com>
Date:   Tue, 3 Mar 2020 09:38:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20200302113946.000062f0@Huawei.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.101.242]
X-CFilter-Loop: Reflected
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,
On 2020/3/2 19:39, Jonathan Cameron wrote:
> On Mon, 2 Mar 2020 14:15:12 +0800
> Zaibo Xu <xuzaibo@huawei.com> wrote:
>
>> From: Shukun Tan <tanshukun1@huawei.com>
>>
>> Because so many work queues are not needed. Using one workqueue
>> per QM will reduce the number of kworker threads as well as
>> reducing usage of CPU.This would not degrade any performance.
>>
>> Signed-off-by: Shukun Tan <tanshukun1@huawei.com>
> Hi, this is more or less fine I think other than:
>
> 1) Needs a sign off from xuzaibo to reflect the handling of the patch.
Okay
> 2) The description doesn't mention that we aren't actually creating the
>     per QM workqueue in this patch (it comes later in the series)
yes, will add description.
> 3) The fallback to the system workqueue needs documentation inline.
>
> So tidy those up for v3 and I'm happy.
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>
Okay, no problem.
>
>> ---
>>   drivers/crypto/hisilicon/qm.c | 38 +++++++++++++++-----------------------
>>   drivers/crypto/hisilicon/qm.h |  5 +++--
>>   2 files changed, 18 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
>> index ad7146a..13b0a6f 100644
>> --- a/drivers/crypto/hisilicon/qm.c
>> +++ b/drivers/crypto/hisilicon/qm.c
>> @@ -494,17 +494,9 @@ static void qm_poll_qp(struct hisi_qp *qp, struct hisi_qm *qm)
>>   	}
>>   }
>>   
>> -static void qm_qp_work_func(struct work_struct *work)
>> +static void qm_work_process(struct work_struct *work)
>>   {
>> -	struct hisi_qp *qp;
>> -
>> -	qp = container_of(work, struct hisi_qp, work);
>> -	qm_poll_qp(qp, qp->qm);
>> -}
>> -
>> -static irqreturn_t qm_irq_handler(int irq, void *data)
>> -{
>> -	struct hisi_qm *qm = data;
>> +	struct hisi_qm *qm = container_of(work, struct hisi_qm, work);
>>   	struct qm_eqe *eqe = qm->eqe + qm->status.eq_head;
>>   	struct hisi_qp *qp;
>>   	int eqe_num = 0;
>> @@ -513,7 +505,7 @@ static irqreturn_t qm_irq_handler(int irq, void *data)
>>   		eqe_num++;
>>   		qp = qm_to_hisi_qp(qm, eqe);
>>   		if (qp)
>> -			queue_work(qp->wq, &qp->work);
>> +			qm_poll_qp(qp, qm);
>>   
>>   		if (qm->status.eq_head == QM_Q_DEPTH - 1) {
>>   			qm->status.eqc_phase = !qm->status.eqc_phase;
>> @@ -531,6 +523,16 @@ static irqreturn_t qm_irq_handler(int irq, void *data)
>>   	}
>>   
>>   	qm_db(qm, 0, QM_DOORBELL_CMD_EQ, qm->status.eq_head, 0);
>> +}
>> +
>> +static irqreturn_t do_qm_irq(int irq, void *data)
>> +{
>> +	struct hisi_qm *qm = (struct hisi_qm *)data;
>> +
>> +	if (qm->wq)
>> +		queue_work(qm->wq, &qm->work);
>> +	else
>> +		schedule_work(&qm->work);
> This subtle difference between these two could do with an explanatory
> comment.
>
> >From an initial look I'm not actually seeing qm->wq being set anywhere?
> Ah it's in a later patch. Please add comment to say that in the introduction.
Agree, will add comments here in V3.

Thanks,

Zaibo

.
>
>
>
>
>
>>   
>>   	return IRQ_HANDLED;
>>   }
>> @@ -540,7 +542,7 @@ static irqreturn_t qm_irq(int irq, void *data)
>>   	struct hisi_qm *qm = data;
>>   
>>   	if (readl(qm->io_base + QM_VF_EQ_INT_SOURCE))
>> -		return qm_irq_handler(irq, data);
>> +		return do_qm_irq(irq, data);
>>   
>>   	dev_err(&qm->pdev->dev, "invalid int source\n");
>>   	qm_db(qm, 0, QM_DOORBELL_CMD_EQ, qm->status.eq_head, 0);
>> @@ -1159,20 +1161,9 @@ struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
>>   
>>   	qp->qp_id = qp_id;
>>   	qp->alg_type = alg_type;
>> -	INIT_WORK(&qp->work, qm_qp_work_func);
>> -	qp->wq = alloc_workqueue("hisi_qm", WQ_UNBOUND | WQ_HIGHPRI |
>> -				 WQ_CPU_INTENSIVE | WQ_MEM_RECLAIM, 0);
>> -	if (!qp->wq) {
>> -		ret = -EFAULT;
>> -		goto err_free_qp_mem;
>> -	}
>>   
>>   	return qp;
>>   
>> -err_free_qp_mem:
>> -	if (qm->use_dma_api)
>> -		dma_free_coherent(dev, qp->qdma.size, qp->qdma.va,
>> -				  qp->qdma.dma);
>>   err_clear_bit:
>>   	write_lock(&qm->qps_lock);
>>   	qm->qp_array[qp_id] = NULL;
>> @@ -1704,6 +1695,7 @@ int hisi_qm_init(struct hisi_qm *qm)
>>   	qm->qp_in_used = 0;
>>   	mutex_init(&qm->mailbox_lock);
>>   	rwlock_init(&qm->qps_lock);
>> +	INIT_WORK(&qm->work, qm_work_process);
>>   
>>   	dev_dbg(dev, "init qm %s with %s\n", pdev->is_physfn ? "pf" : "vf",
>>   		qm->use_dma_api ? "dma api" : "iommu api");
>> diff --git a/drivers/crypto/hisilicon/qm.h b/drivers/crypto/hisilicon/qm.h
>> index 1a4f208..c72c2e6 100644
>> --- a/drivers/crypto/hisilicon/qm.h
>> +++ b/drivers/crypto/hisilicon/qm.h
>> @@ -183,6 +183,9 @@ struct hisi_qm {
>>   	u32 error_mask;
>>   	u32 msi_mask;
>>   
>> +	struct workqueue_struct *wq;
>> +	struct work_struct work;
>> +
>>   	const char *algs;
>>   	bool use_dma_api;
>>   	bool use_sva;
>> @@ -219,8 +222,6 @@ struct hisi_qp {
>>   	void *qp_ctx;
>>   	void (*req_cb)(struct hisi_qp *qp, void *data);
>>   	void (*event_cb)(struct hisi_qp *qp);
>> -	struct work_struct work;
>> -	struct workqueue_struct *wq;
>>   
>>   	struct hisi_qm *qm;
>>   	u16 pasid;
>
> .
>


