Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C19B1DA55;
	Sat, 29 Nov 2025 01:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764380246; cv=none; b=l9lsfCBJOjabvfgAsZvgRg9tl1rqkVLHgl9+lX7ow2o02gIUIVqF62gVCTRgYwQvlEZLfhkSxAuhs6YutLazoEifnGi04S6jZG7zePJUGxf5VJ3BwxljTPY3G1rftVUnxpQDlg6m5xO28lzTOWcSUHScE+YeDvkAF0vZtE5einQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764380246; c=relaxed/simple;
	bh=32er+DQVQPZFfano/BIgK2YXfsK0Odv9J3+SZHHQcyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CLNbjBkJ49Z2UsEJ9DqGZwg8/pErw4SZK+vA5AmhzR2lUYYz9O4dCRFazuK7pxHHjmHdRutovuB6xPUwSJWCccO2O0hu7xTIrRuc0BdEzEO3qCcZc5suoeB3i+DFa3HouiOrvo2SuzfGlyru+iw2jupcwXKXs3pEP1qY3AkdVSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=1XEPpEhu; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="1XEPpEhu"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3ZCNRIDufQTQVYhYOwvW55Kzk7cvt610iYaBIkr8w80=;
	b=1XEPpEhuOKY7dqEdapAMHk8+h02fBofGQwl1bsQk6xD1YTi1xme2M9Uimc//q5ghJS4MThh8p
	AzjLHnrmN7X9+Q8SXJhxjEmw7vlh33klyQhIDANjlin1sXVWfD1IGsrVYT10iDc4j8MnPHRerpd
	aMKZ/jYmyn3ZhVFAGw+nPCM=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dJCQL1594z12LDq;
	Sat, 29 Nov 2025 09:34:50 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 60A66140144;
	Sat, 29 Nov 2025 09:37:14 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 29 Nov 2025 09:37:14 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 29 Nov 2025 09:37:13 +0800
Message-ID: <7758a29a-b035-42b3-94d6-4ec0d8471f3b@huawei.com>
Date: Sat, 29 Nov 2025 09:37:13 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/11] crypto: hisilicon/qm - add reference counting to
 queues for tfm kernel reuse
To: liulongfang <liulongfang@huawei.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>, <lizhi206@huawei.com>, <taoqi10@huawei.com>
References: <20251122074916.2793717-1-huangchenghai2@huawei.com>
 <20251122074916.2793717-8-huangchenghai2@huawei.com>
 <ffb14448-a127-317e-40a0-fec431c4cc04@huawei.com>
From: huangchenghai <huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <ffb14448-a127-317e-40a0-fec431c4cc04@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq200001.china.huawei.com (7.202.195.16)


在 2025/11/28 17:03, liulongfang 写道:
> On 2025/11/22 15:49, Chenghai Huang wrote:
>> Add reference counting to queues. When all queues are occupied, tfm
>> will reuse queues with the same algorithm type that have already
>> been allocated in the kernel. The corresponding queue will be
>> released when the reference count reaches 1.
>>
>> Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
>> Signed-off-by: Weili Qian <qianweili@huawei.com>
>> ---
>>   drivers/crypto/hisilicon/qm.c | 81 +++++++++++++++++++++++++++--------
>>   include/linux/hisi_acc_qm.h   |  1 +
>>   2 files changed, 65 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
>> index 28256f64aa3c..6ff189941300 100644
>> --- a/drivers/crypto/hisilicon/qm.c
>> +++ b/drivers/crypto/hisilicon/qm.c
>> @@ -2002,7 +2002,38 @@ static void hisi_qm_unset_hw_reset(struct hisi_qp *qp)
>>   	*addr = 0;
>>   }
>>   
>> -static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
>> +static struct hisi_qp *find_shareable_qp(struct hisi_qm *qm, u8 alg_type, bool is_in_kernel)
>> +{
>> +	struct device *dev = &qm->pdev->dev;
>> +	struct hisi_qp *share_qp = NULL;
>> +	struct hisi_qp *qp;
>> +	u32 ref_count = ~0;
>> +	int i;
>> +
>> +	if (!is_in_kernel)
>> +		goto queues_busy;
>> +
>> +	for (i = 0; i < qm->qp_num; i++) {
>> +		qp = &qm->qp_array[i];
>> +		if (qp->is_in_kernel && qp->alg_type == alg_type && qp->ref_count < ref_count) {
>> +			ref_count = qp->ref_count;
>> +			share_qp = qp;
>> +		}
>> +	}
>> +
>> +	if (share_qp) {
>> +		share_qp->ref_count++;
>> +		return share_qp;
>> +	}
>> +
>> +queues_busy:
>> +	dev_info_ratelimited(dev, "All %u queues of QM are busy and no shareable queue\n",
>> +			     qm->qp_num);
>> +	atomic64_inc(&qm->debug.dfx.create_qp_err_cnt);
>> +	return ERR_PTR(-EBUSY);
>> +}
>> +
>> +static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type, bool is_in_kernel)
>>   {
>>   	struct device *dev = &qm->pdev->dev;
>>   	struct hisi_qp *qp;
>> @@ -2013,17 +2044,14 @@ static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
>>   		return ERR_PTR(-EPERM);
>>   	}
>>   
>> -	if (qm->qp_in_used == qm->qp_num) {
>> -		dev_info_ratelimited(dev, "All %u queues of QM are busy!\n",
>> -				     qm->qp_num);
>> -		atomic64_inc(&qm->debug.dfx.create_qp_err_cnt);
>> -		return ERR_PTR(-EBUSY);
>> -	}
>> +	/* Try to find a shareable queue when all queues are busy */
>> +	if (qm->qp_in_used == qm->qp_num)
>> +		return find_shareable_qp(qm, alg_type, is_in_kernel);
>>   
>>   	qp_id = idr_alloc_cyclic(&qm->qp_idr, NULL, 0, qm->qp_num, GFP_ATOMIC);
>>   	if (qp_id < 0) {
>> -		dev_info_ratelimited(dev, "All %u queues of QM are busy!\n",
>> -				    qm->qp_num);
>> +		dev_info_ratelimited(dev, "All %u queues of QM are busy, in_used = %u!\n",
>> +				    qm->qp_num, qm->qp_in_used);
>>   		atomic64_inc(&qm->debug.dfx.create_qp_err_cnt);
>>   		return ERR_PTR(-EBUSY);
>>   	}
>> @@ -2034,10 +2062,10 @@ static struct hisi_qp *qm_create_qp_nolock(struct hisi_qm *qm, u8 alg_type)
>>   
>>   	qp->event_cb = NULL;
>>   	qp->req_cb = NULL;
>> -	qp->qp_id = qp_id;
>>   	qp->alg_type = alg_type;
>> -	qp->is_in_kernel = true;
>> +	qp->is_in_kernel = is_in_kernel;
>>   	qm->qp_in_used++;
>> +	qp->ref_count = 1;
>>   
>>   	return qp;
>>   }
>> @@ -2059,7 +2087,7 @@ static struct hisi_qp *hisi_qm_create_qp(struct hisi_qm *qm, u8 alg_type)
>>   		return ERR_PTR(ret);
>>   
>>   	down_write(&qm->qps_lock);
>> -	qp = qm_create_qp_nolock(qm, alg_type);
>> +	qp = qm_create_qp_nolock(qm, alg_type, false);
>>   	up_write(&qm->qps_lock);
>>   
>>   	if (IS_ERR(qp))
>> @@ -2458,7 +2486,6 @@ static int hisi_qm_uacce_get_queue(struct uacce_device *uacce,
>>   	qp->uacce_q = q;
>>   	qp->event_cb = qm_qp_event_notifier;
>>   	qp->pasid = arg;
>> -	qp->is_in_kernel = false;
>>   
>>   	return 0;
>>   }
>> @@ -3532,6 +3559,9 @@ static void qm_release_qp_nolock(struct hisi_qp *qp)
>>   {
>>   	struct hisi_qm *qm = qp->qm;
>>   
>> +	if (--qp->ref_count)
>> +		return;
>> +
>>   	qm->qp_in_used--;
>>   	idr_remove(&qm->qp_idr, qp->qp_id);
>>   }
>> @@ -3551,7 +3581,10 @@ void hisi_qm_free_qps(struct hisi_qp **qps, int qp_num)
>>   	down_write(&qps[0]->qm->qps_lock);
>>   
>>   	for (i = qp_num - 1; i >= 0; i--) {
>> -		qm_stop_qp_nolock(qps[i]);
>> +		if (qps[i]->ref_count == 1) {
>> +			qm_stop_qp_nolock(qps[i]);
>> +			qm_pm_put_sync(qps[i]->qm);
>> +		}
>>   		qm_release_qp_nolock(qps[i]);
>>   	}
>>   
>> @@ -3576,16 +3609,27 @@ static int qm_get_and_start_qp(struct hisi_qm *qm, int qp_num, struct hisi_qp **
>>   
>>   	down_write(&qm->qps_lock);
>>   	for (i = 0; i < qp_num; i++) {
>> -		qps[i] = qm_create_qp_nolock(qm, alg_type[i]);
>> +		qps[i] = qm_create_qp_nolock(qm, alg_type[i], true);
>>   		if (IS_ERR(qps[i])) {
>>   			goto free_qp;
>>   		}
>>   	}
>>   
>>   	for (j = 0; j < qp_num; j++) {
>> +		if (qps[j]->ref_count != 1)
>> +			continue;
> You will encounter an issue here: if a queue is reused multiple times, the reference count
> in the subsequent find_shareable_qp will automatically increase to a value greater than 1.
> In this case, the queue actually needs to be accessed using qm_start_qp_nolock,
> but it is skipped here, leading to an abnormal behavior.
>
> Thanks.
> Longfang
Thanks for the reminder, I will change `if (qps[j]->ref_count != 1)` to 
`if (atomic_read(&qps[j]->qp_status.flags) == QP_START)`.

Regards,
Chenghai
>> +
>> +		ret = qm_pm_get_sync(qm);
>> +		if (ret) {
>> +			ret = -EINVAL;
>> +			goto stop_qp;
>> +		}
>> +
>>   		ret = qm_start_qp_nolock(qps[j], 0);
>> -		if (ret)
>> +		if (ret) {
>> +			qm_pm_put_sync(qm);
>>   			goto stop_qp;
>> +		}
>>   	}
>>   	up_write(&qm->qps_lock);
>>   
>> @@ -3593,7 +3637,10 @@ static int qm_get_and_start_qp(struct hisi_qm *qm, int qp_num, struct hisi_qp **
>>   
>>   stop_qp:
>>   	for (j--; j >= 0; j--)
>> -		qm_stop_qp_nolock(qps[j]);
>> +		if (qps[j]->ref_count == 1) {
>> +			qm_stop_qp_nolock(qps[j]);
>> +			qm_pm_put_sync(qm);
>> +		}
>>   free_qp:
>>   	for (i--; i >= 0; i--)
>>   		qm_release_qp_nolock(qps[i]);
>> diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
>> index 4cf418a41fe4..26032d98e9bd 100644
>> --- a/include/linux/hisi_acc_qm.h
>> +++ b/include/linux/hisi_acc_qm.h
>> @@ -472,6 +472,7 @@ struct hisi_qp {
>>   	u16 pasid;
>>   	struct uacce_queue *uacce_q;
>>   
>> +	u32 ref_count;
>>   	spinlock_t qp_lock;
>>   	struct instance_backlog backlog;
>>   	const void **msg;
>>
