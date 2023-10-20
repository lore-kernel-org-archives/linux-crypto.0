Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0712C001DF
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 19:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjJTTql (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 15:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbjJTTql (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 15:46:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4755FD57
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 12:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697831156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zi49cheY5QdrwKbyQeFhoDniHU46O0K8By4g9e4pkJY=;
        b=JRD7XIaVeLZOkRlCDpexdsZxlg8H47fs59jENSFU2QpqvzHh7L/u0YvtPp/GGUI3d1xFPV
        2WfnfF8viWTzR8e89eZpYcx1kHmCHWUPohX8IfoXmXPWQ3lG6yEFHf4w1zNkYXfNHgcWU4
        4yUTlVwzUkJMx1w+AUDlXtW+I3ErAfQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-27-tMmXX9DWN0-9uvlAJlgdhA-1; Fri, 20 Oct 2023 15:45:42 -0400
X-MC-Unique: tMmXX9DWN0-9uvlAJlgdhA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78CB1802896;
        Fri, 20 Oct 2023 19:45:42 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72BF12026D4C;
        Fri, 20 Oct 2023 19:45:42 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
        id 5DD5C30C0521; Fri, 20 Oct 2023 19:45:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
        by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 5B4513FB77;
        Fri, 20 Oct 2023 21:45:42 +0200 (CEST)
Date:   Fri, 20 Oct 2023 21:45:42 +0200 (CEST)
From:   Mikulas Patocka <mpatocka@redhat.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com
Subject: Re: [PATCH] crypto: qat - fix deadlock in backlog processing
In-Reply-To: <20231020153330.70845-1-giovanni.cabiddu@intel.com>
Message-ID: <4fddb73b-65ad-688b-6659-f583ac036af@redhat.com>
References: <20231020153330.70845-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On Fri, 20 Oct 2023, Giovanni Cabiddu wrote:

> If a request has the flag CRYPTO_TFM_REQ_MAY_BACKLOG set, the function
> qat_alg_send_message_maybacklog(), enqueues it in a backlog list if
> either (1) there is already at least one request in the backlog list, or
> (2) the HW ring is nearly full or (3) the enqueue to the HW ring fails.
> If an interrupt occurs right before the lock in qat_alg_backlog_req() is
> taken and the backlog queue is being emptied, then there is no request
> in the HW queues that can trigger a subsequent interrupt that can clear
> the backlog queue. In addition subsequent requests are enqueued to the
> backlog list and not sent to the hardware.
> 
> Fix it by holding the lock while taking the decision if the request
> needs to be included in the backlog queue or not. This synchronizes the
> flow with the interrupt handler that drains the backlog queue.
> 
> For performance reasons, the logic has been changed to try to enqueue
> first without holding the lock.
> 
> Fixes: 386823839732 ("crypto: qat - add backlog mechanism")
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Closes: https://lore.kernel.org/all/af9581e2-58f9-cc19-428f-6f18f1f83d54@redhat.com/T/
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

> ---
>  .../intel/qat/qat_common/qat_algs_send.c      | 46 ++++++++++---------
>  1 file changed, 25 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/crypto/intel/qat/qat_common/qat_algs_send.c b/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> index bb80455b3e81..b97b678823a9 100644
> --- a/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> +++ b/drivers/crypto/intel/qat/qat_common/qat_algs_send.c
> @@ -40,40 +40,44 @@ void qat_alg_send_backlog(struct qat_instance_backlog *backlog)
>  	spin_unlock_bh(&backlog->lock);
>  }
>  
> -static void qat_alg_backlog_req(struct qat_alg_req *req,
> -				struct qat_instance_backlog *backlog)
> -{
> -	INIT_LIST_HEAD(&req->list);
> -
> -	spin_lock_bh(&backlog->lock);
> -	list_add_tail(&req->list, &backlog->list);
> -	spin_unlock_bh(&backlog->lock);
> -}
> -
> -static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
> +static bool qat_alg_try_enqueue(struct qat_alg_req *req)
>  {
>  	struct qat_instance_backlog *backlog = req->backlog;
>  	struct adf_etr_ring_data *tx_ring = req->tx_ring;
>  	u32 *fw_req = req->fw_req;
>  
> -	/* If any request is already backlogged, then add to backlog list */
> +	/* Check if any request is already backlogged */
>  	if (!list_empty(&backlog->list))
> -		goto enqueue;
> +		return false;
>  
> -	/* If ring is nearly full, then add to backlog list */
> +	/* Check if ring is nearly full */
>  	if (adf_ring_nearly_full(tx_ring))
> -		goto enqueue;
> +		return false;
>  
> -	/* If adding request to HW ring fails, then add to backlog list */
> +	/* Try to enqueue to HW ring */
>  	if (adf_send_message(tx_ring, fw_req))
> -		goto enqueue;
> +		return false;
>  
> -	return -EINPROGRESS;
> +	return true;
> +}
>  
> -enqueue:
> -	qat_alg_backlog_req(req, backlog);
>  
> -	return -EBUSY;
> +static int qat_alg_send_message_maybacklog(struct qat_alg_req *req)
> +{
> +	struct qat_instance_backlog *backlog = req->backlog;
> +	int ret = -EINPROGRESS;
> +
> +	if (qat_alg_try_enqueue(req))
> +		return ret;
> +
> +	spin_lock_bh(&backlog->lock);
> +	if (!qat_alg_try_enqueue(req)) {
> +		list_add_tail(&req->list, &backlog->list);
> +		ret = -EBUSY;
> +	}
> +	spin_unlock_bh(&backlog->lock);
> +
> +	return ret;
>  }
>  
>  int qat_alg_send_message(struct qat_alg_req *req)
> 
> base-commit: 2ce0d7cbc00a0fc65bb26203efed7ecdc98ba849
> -- 
> 2.41.0
> 

