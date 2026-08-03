Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C75812E1DC
	for <linux-crypto@vger.kernel.org>; Mon,  3 Aug 2026 01:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785721849; cv=none; b=F5ivnAhmm3iA2InJasDNr62rLhY+1nIWGYtZviGjA5Td2dGu/9B827vl2yBCf2HOzp5x5onrQxAfeB6qG2/9pXL0cn6lWV1ihGHX5bIMfYLJd8uvmjk0mGpiMqz6/TOzWNodwOcFhD3SKi1TiRvUbc0Syq4q9vWS9vFy1pYu4Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785721849; c=relaxed/simple;
	bh=g3SbO2H1Kz7V7YTlB9dxcYbjRy41CyUZPbXSnOi1XyA=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=MX+1Y9/FdfeBrjFgO7/qVeaOGvPXyeue0ETuyKPhvCQpcAlSq48bdDG5NT9fJRq+dhCiWOEj85Au6PNDp7y4rVdqp0j07MG9xhrH1kBLwKsXlPdaKbl+8toq6hvDRLpsHeD+au8Pf+A/nQrN0LfTNIG40qFyJC828uWbtdC/wJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ty1tjtWD; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ty1tjtWD"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XIQkAS7wJ3IGN38QcYXnkFik0jIwI37i2rnovx3JnMo=;
	b=ty1tjtWD8nB+4aBE8sxvaiv1NG0OqMOKumX2rw7hkOoRMdbRJxPXQFFztPfKKFMh+mhFk0/0Y
	Po/STfG84ANQmzzI1dTEfcIhT2qxuNmW5bk8hZ9A3aLjV8Q4EEsWEdLUITUEwaU6L+VXSNlIClp
	WlX9AiPm/BSS9YysHKCboFI=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hCzsc4Zwvz1K9D1;
	Mon,  3 Aug 2026 09:41:08 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 564A740563;
	Mon,  3 Aug 2026 09:50:37 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 3 Aug 2026 09:50:36 +0800
Subject: Re: [PATCH] crypto: hisilicon/sec - Fix use-after-free and unchecked
 kfifo_put in sec_send_request()
To: Arbab Haider <arbabhaider649@gmail.com>, Herbert Xu
	<herbert@gondor.apana.org.au>
CC: Jonathan Cameron <Jonathan.Cameron@huawei.com>, John Garry
	<john.g.garry@oracle.com>, <linux-crypto@vger.kernel.org>
References: <20260730123718.283971-1-arbabhaider649@gmail.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <ed89244c-c309-a440-3235-2181b126924c@huawei.com>
Date: Mon, 3 Aug 2026 09:50:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260730123718.283971-1-arbabhaider649@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2026/7/30 20:37, Arbab Haider wrote:
> The capacity check in sec_alg_skcipher_crypto() only verified that the
> hardware queue could accept all elements or that the software queue had
> enough space, but failed to account for the case where the software
> queue already had pending entries. When the software queue is non-empty,
> all new entries must go to the software queue to preserve cipher
> chaining ordering, even if the hardware queue has available capacity.
> 
> This could lead to two issues:
> 
> 1. Elements silently dropped from the software queue if
>    kfifo_put() returns 0 (queue full), causing the request to never
>    complete.
> 
> 2. Use-after-free if sec_queue_send() returns -EAGAIN after some
>    elements were already queued to hardware or software — the error
>    path in sec_send_request() returns -EBUSY, and the caller's
>    err_free_elements path frees all elements, including those
>    referenced by the hardware queue or software queue.
> 
> Fix by:
> 
> - Checking the return value of kfifo_put() and returning -ENOSPC on
>   failure, with a WARN_ON_ONCE since this should not happen with the
>   corrected capacity check.
> 
> - Catching all errors from sec_queue_send() (not just -EAGAIN) with a
>   WARN_ON_ONCE, as this path is unreachable with proper capacity
>   accounting.
> 
> - Replacing the capacity check with correct logic that accounts for
>   the three possible queueing scenarios:
>   * Software queue has entries or hardware queue is non-empty: all
>     entries go to the software queue → verify software queue capacity
>     for all steps.
>   * Both queues empty: first entry goes to hardware, rest to software
>     → verify hardware can take 1 and software can take steps - 1.
>   * No software queue configured: all to hardware → verify hardware
>     capacity for all steps.
> 
> Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
> Signed-off-by: Arbab Haider <arbabhaider649@gmail.com>
> ---
>  drivers/crypto/hisilicon/sec/sec_algs.c | 51 +++++++++++++++++--------
>  1 file changed, 35 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
> index 85eecbb40e7e..6cc08e9a07d0 100644
> --- a/drivers/crypto/hisilicon/sec/sec_algs.c
> +++ b/drivers/crypto/hisilicon/sec/sec_algs.c
> @@ -402,14 +402,17 @@ static int sec_send_request(struct sec_request *sec_req, struct sec_queue *queue
>  		    (kfifo_is_empty(&queue->softqueue) &&
>  		     sec_queue_empty(queue))) {
>  			ret = sec_queue_send(queue, &el->req, sec_req);
> -			if (ret == -EAGAIN) {
> -				/* Wait unti we can send then try again */
> -				/* DEAD if here - should not happen */
> +			if (ret) {
> +				WARN_ON_ONCE(ret == -EAGAIN);
>  				ret = -EBUSY;
>  				goto err_unlock;
>  			}
>  		} else {
> -			kfifo_put(&queue->softqueue, el);
> +			if (!kfifo_put(&queue->softqueue, el)) {
> +				WARN_ON_ONCE(1);
> +				ret = -ENOSPC;
> +				goto err_unlock;
> +			}
>  		}
>  	}
>  err_unlock:
> @@ -790,28 +793,44 @@ static int sec_alg_skcipher_crypto(struct skcipher_request *skreq,
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
>
This SEC accelerator is a very old module that no longer has active users.
The primary maintainer, Jonathan, is no longer maintaining it.
Users have migrated to the new SEC2 accelerator instead.
Therefore, we have decided to remove this driver and will submit the deletion patch shortly.

Thank you.
Longfang.


