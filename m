Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ADBD2F361B
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 01:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785721008; cv=none; b=SZUor8x5YYzmUCi6E4+d3vnwSG+c6VhmXHLlf4uPcwX02WHE9PL93zci4MJzD3W3iLStjeIF/G+nu8zK/juoriR9lx7oLTbR79QZj2t3j+MQp7gyAOtJ3wH9mCN7geCsoE3ZM9d4FU3Nl2ObA7x6clph8z13B/rwBow4dcOaLoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785721008; c=relaxed/simple;
	bh=zl6prXAoiQfSnz4PVETw7Q8v5DHIjxSc548ueHqdb70=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=g34BhvHLAKpUiPqKyIrqHb1t1J0mTYKZ4hPR/H69jMwfU034EmHHLameIJHkfcrgACdZsyMI9LUn6uCNzteihekm0+aroTRgCdZ7VGvLEs2lMGrAH8NMb9Al9Mq4s8Uym3oZ6ROrTW1G+GoXcs4GiRqvooLHNwA7fFgQKC8EdRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=hb4Obn03; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="hb4Obn03"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cdKlUqZoYTQ7+WqNi1rwHxRc3QNXU8fhkw7DOeAYAx0=;
	b=hb4Obn03VBDEeu7UeEtCwx9k4tGffm6Ra3NYQUJdx/dUsS1wFqirEetw2AxFSP1mWYyXgWlG1
	O/mqlXKtgiexGD6sZnKfpu5uNS5NIY34TPs8ZDUOAEJwqcMhRrc/9v8W8H5e6VeIxUsFiwusOCG
	Mp9RhiZlyrHg+yovS0sXPWM=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hCzYF2725z1T4MG;
	Mon,  3 Aug 2026 09:26:57 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 7204240538;
	Mon,  3 Aug 2026 09:36:34 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 3 Aug 2026 09:36:33 +0800
Subject: Re: [PATCH] crypto: hisilicon/sec - Fix element drop and UAF in
 sec_send_request()
To: Arbab Haider <arbabhaider649@gmail.com>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: Jonathan Cameron <Jonathan.Cameron@huawei.com>, John Garry
	<john.g.garry@oracle.com>, <linux-crypto@vger.kernel.org>
References: <20260730215449.299311-1-arbabhaider649@gmail.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <66d7ad30-5110-8a95-b1d2-30bdefd30b3f@huawei.com>
Date: Mon, 3 Aug 2026 09:36:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260730215449.299311-1-arbabhaider649@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2026/7/31 5:54, Arbab Haider wrote:
> The capacity check in sec_alg_skcipher_crypto() only verified that the
> hardware queue could accept all steps or that the softqueue had
> capacity, but failed to account for the case where softqueue already
> has pending entries. When softqueue is non-empty, all new entries must
> go to softqueue (to preserve cipher chaining ordering), even if the
> hardware queue has available capacity.
> 
> This means the check could pass via hardware capacity, yet the first
> element goes to hardware and subsequent elements go to softqueue —
> which might be full. kfifo_put() silently returns 0 on a full fifo,
> so those elements are dropped and the request never completes.
> 
> Fix by:
> 
> - Replacing the capacity check with correct logic that accounts
>   for all three queueing scenarios.
> 
> - Making sec_send_request() void and checking both sec_queue_send()
>   and kfifo_put() with WARN_ON_ONCE. A return value is not returned
>   to the caller because a mid-loop error after partial queuing would
>   cause the caller's err_free_elements path to free elements still
>   referenced by the hardware shadow array or softqueue (UAF). The
>   corrected capacity check guarantees these paths are unreachable.
> 
> Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
> Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
> ---
>  drivers/crypto/hisilicon/sec/sec_algs.c | 65 ++++++++++++++-----------
>  1 file changed, 37 insertions(+), 28 deletions(-)
>

This SEC accelerator is a very old module that no longer has active users.
The primary maintainer, Jonathan, is no longer maintaining it.
Users have migrated to the new SEC2 accelerator instead.
Therefore, we have decided to remove this driver and will submit the deletion patch shortly.

Thank you.
Longfang.

> diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
> index 85eecbb40e7e..ce1dd95455ff 100644
> --- a/drivers/crypto/hisilicon/sec/sec_algs.c
> +++ b/drivers/crypto/hisilicon/sec/sec_algs.c
> @@ -381,10 +381,9 @@ static void sec_alg_free_el(struct sec_request_el *el,
>  }
>  
>  /* queuelock must be held */
> -static int sec_send_request(struct sec_request *sec_req, struct sec_queue *queue)
> +static void sec_send_request(struct sec_request *sec_req, struct sec_queue *queue)
>  {
>  	struct sec_request_el *el, *temp;
> -	int ret = 0;
>  
>  	mutex_lock(&sec_req->lock);
>  	list_for_each_entry_safe(el, temp, &sec_req->elements, head) {
> @@ -401,21 +400,17 @@ static int sec_send_request(struct sec_request *sec_req, struct sec_queue *queue
>  		if (!queue->havesoftqueue ||
>  		    (kfifo_is_empty(&queue->softqueue) &&
>  		     sec_queue_empty(queue))) {
> -			ret = sec_queue_send(queue, &el->req, sec_req);
> -			if (ret == -EAGAIN) {
> -				/* Wait unti we can send then try again */
> -				/* DEAD if here - should not happen */
> -				ret = -EBUSY;
> -				goto err_unlock;
> -			}
> +			if (WARN_ON_ONCE(sec_queue_send(queue, &el->req,
> +							sec_req)))
> +				/* Should not happen with proper capacity check */
> +				;
>  		} else {
> -			kfifo_put(&queue->softqueue, el);
> +			if (WARN_ON_ONCE(!kfifo_put(&queue->softqueue, el)))
> +				/* Should not happen with proper capacity check */
> +				;
>  		}
>  	}
> -err_unlock:
>  	mutex_unlock(&sec_req->lock);
> -
> -	return ret;
>  }
>  
>  static void sec_skcipher_alg_callback(struct sec_bd_info *sec_resp,
> @@ -790,28 +785,44 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
>  
>  	/*
>  	 * Only attempt to queue if the whole lot can fit in the queue -
> -	 * we can't successfully cleanup after a partial queing so this
> +	 * we can't successfully cleanup after a partial queuing so this
>  	 * must succeed or fail atomically.
>  	 *
> -	 * Big hammer test of both software and hardware queues - could be
> -	 * more refined but this is unlikely to happen so no need.
> +	 * When the softqueue has pending entries, all new entries must
> +	 * go to the softqueue to preserve ordering.  When both queues
> +	 * are empty the first entry goes to hardware and the rest to
> +	 * the softqueue (if enabled).
>  	 */
>  
>  	/* Grab a big lock for a long time to avoid concurrency issues */
>  	spin_lock_bh(&queue->queuelock);
>  
>  	/*
> -	 * Can go on to queue if we have space in either:
> -	 * 1) The hardware queue and no software queue
> -	 * 2) The software queue
> -	 * AND there is nothing in the backlog.  If there is backlog we
> -	 * have to only queue to the backlog queue and return busy.
> +	 * Can go on to queue if we have space for everything upfront.
> +	 * If there is backlog we must queue to the backlog and return busy.
>  	 */
> -	if ((!sec_queue_can_enqueue(queue, steps) &&
> -	     (!queue->havesoftqueue ||
> -	      kfifo_avail(&queue->softqueue) > steps)) ||
> -	    !list_empty(&ctx->backlog)) {
> +	if (!list_empty(&ctx->backlog)) {
>  		ret = -EBUSY;
> +		goto backlog;
> +	}
> +
> +	if (!queue->havesoftqueue) {
> +		if (!sec_queue_can_enqueue(queue, steps))
> +			ret = -EBUSY;
> +	} else if (!kfifo_is_empty(&queue->softqueue) ||
> +		   !sec_queue_empty(queue)) {
> +		/* All entries must go to the softqueue */
> +		if (kfifo_avail(&queue->softqueue) <= steps)
> +			ret = -EBUSY;
> +	} else {
> +		/* First to hardware, rest to softqueue */
> +		if (!sec_queue_can_enqueue(queue, 1) ||
> +		    kfifo_avail(&queue->softqueue) < steps - 1)
> +			ret = -EBUSY;
> +	}
> +
> +	if (ret) {
> +backlog:
>  		if ((skreq->base.flags & CRYPTO_TFM_REQ_MAY_BACKLOG)) {
>  			list_add_tail(&sec_req->backlog_head, &ctx->backlog);
>  			spin_unlock_bh(&queue->queuelock);
> @@ -821,10 +832,8 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
>  		spin_unlock_bh(&queue->queuelock);
>  		goto err_free_elements;
>  	}
> -	ret = sec_send_request(sec_req, queue);
> +	sec_send_request(sec_req, queue);
>  	spin_unlock_bh(&queue->queuelock);
> -	if (ret)
> -		goto err_free_elements;
>  
>  	ret = -EINPROGRESS;
>  out:
> 
