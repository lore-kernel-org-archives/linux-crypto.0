Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B12EC33CB3
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 08:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC35F2465B
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 08:58:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D2H6dgrL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgA1I6w (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 03:58:52 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40205 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbgA1I6w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 03:58:52 -0500
Received: by mail-wr1-f66.google.com with SMTP id c14so15033768wrn.7;
        Tue, 28 Jan 2020 00:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zinQcYMRE/SNMf15Pj7wpG6LsP6EuMItxuApajbJrNU=;
        b=D2H6dgrLV7dsFVDtH/xMgtSQY/bnclyNUVSIink8fvlwX6VfoEzSGLC3iINRa0GWeC
         65LhW1sktUo7cs0sYNOG1OWvH5xdKPpe6bxkiYFUr5iWF8h15qceBxlXgHeaV2m9Cxva
         ArNfFPjmv/YHZDHnSc2XWp6GAhUhkSZQG/3UPn4XfIsihCd/wyUw3x3UP1pprx+OEued
         epKKYhS+Ezm9RzTVx5h+n8pl6IgvSN8yMKu03SnqgCgVIOlm2ZtTfces2cLOdpO2RBrQ
         BgtaocLZKu6m5BLmjy5KRJ5SR9FG09/BvAUb7wtJNl3ZzVtS1w0pYAZ1KEAyjZsBZ9Dn
         Lwlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=zinQcYMRE/SNMf15Pj7wpG6LsP6EuMItxuApajbJrNU=;
        b=tE6+/f6bJoldKfuKO2OD0cA3WK+rUI8K1RrIhZSZDNe2PVNMCX6g+WKWHXwJ/H7ByO
         QvgQdnJOo5ufDZQzBcr3JZg4OHuVCHjWardnaUnK//2C5Ys2KuYM67P2FZyA21eyEAyi
         bdgxIkn7gAKiJfDmFpwVuaedfbk4D3fU6gYg6RJyoa5/6tVJI74Xnl/tI78f23BBrIFo
         VPDPBf2ExlKqFpUtsN3cRda5PmhAxNzc8TGmN5SiHevfQUYkQkEvdqcbZxhH0iov94dE
         3wUWynj3ISgHHt2mgOuzl+C6YKdK5Q7jAnaccgoxe6wWvSWneROLCIStCvrkr+XDOIXX
         cs5Q==
X-Gm-Message-State: APjAAAUJozDc4i0gSvTP9lWbrBWJDgQYzlkbePGCZ56ONlcJVxZBhtFS
        w1HUIM5X8a/BzGkKxkbKHdg=
X-Google-Smtp-Source: APXvYqx1FBLFta38/FBrFiEq/AhsS/VtEA2iqwtyh6CGsHIf4/X4B4PQLpSk9K5Gn2gxobOHCQ2Zgg==
X-Received: by 2002:a5d:4687:: with SMTP id u7mr26259464wrq.176.1580201927932;
        Tue, 28 Jan 2020 00:58:47 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id e12sm24698773wrn.56.2020.01.28.00.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 00:58:47 -0800 (PST)
Date:   Tue, 28 Jan 2020 09:58:45 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Baolin Wang <baolin.wang@linaro.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Ripard <mripard@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: engine - support for parallel requests
Message-ID: <20200128085845.GB10493@Red>
References: <1580163425-13266-1-git-send-email-iuliana.prodan@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580163425-13266-1-git-send-email-iuliana.prodan@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 28, 2020 at 12:17:05AM +0200, Iuliana Prodan wrote:
> Added support for executing multiple requests, in parallel,
> for crypto engine.
> A new callback is added, can_enqueue_hardware, which asks the
> driver if the hardware has free space, to enqueue a new request.
> The new crypto_engine_alloc_init_and_set function, initialize
> crypto-engine, sets the maximum size for crypto-engine software
> queue (not hardcoded anymore) and the can_enqueue_hardware callback.
> On crypto_pump_requests, if can_enqueue_hardware callback returns true,
> a new request is send to hardware, until there is no space and the
> callback returns false.
> 
> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> 
> ---
> Changes since V0 (RFC):
> 	- removed max_no_req and no_req, as the number of request that
> 	  can be processed in parallel;
> 	- added a new callback, can_enqueue_hardware, to check whether
> 	  the hardware can process a new request. 
> ---
> 
>  crypto/crypto_engine.c  | 105 ++++++++++++++++++++++++++++++------------------
>  include/crypto/engine.h |  10 +++--
>  2 files changed, 71 insertions(+), 44 deletions(-)
> 
> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> index eb029ff..ee3a610 100644
> --- a/crypto/crypto_engine.c
> +++ b/crypto/crypto_engine.c
> @@ -22,32 +22,18 @@
>   * @err: error number
>   */
>  static void crypto_finalize_request(struct crypto_engine *engine,
> -			     struct crypto_async_request *req, int err)
> +				    struct crypto_async_request *req, int err)
>  {
> -	unsigned long flags;
> -	bool finalize_cur_req = false;
>  	int ret;
>  	struct crypto_engine_ctx *enginectx;
>  
> -	spin_lock_irqsave(&engine->queue_lock, flags);
> -	if (engine->cur_req == req)
> -		finalize_cur_req = true;
> -	spin_unlock_irqrestore(&engine->queue_lock, flags);
> -
> -	if (finalize_cur_req) {
> -		enginectx = crypto_tfm_ctx(req->tfm);
> -		if (engine->cur_req_prepared &&
> -		    enginectx->op.unprepare_request) {
> -			ret = enginectx->op.unprepare_request(engine, req);
> -			if (ret)
> -				dev_err(engine->dev, "failed to unprepare request\n");
> -		}
> -		spin_lock_irqsave(&engine->queue_lock, flags);
> -		engine->cur_req = NULL;
> -		engine->cur_req_prepared = false;
> -		spin_unlock_irqrestore(&engine->queue_lock, flags);
> +	enginectx = crypto_tfm_ctx(req->tfm);
> +	if (enginectx->op.prepare_request &&
> +	    enginectx->op.unprepare_request) {
> +		ret = enginectx->op.unprepare_request(engine, req);
> +		if (ret)
> +			dev_err(engine->dev, "failed to unprepare request\n");
>  	}
> -
>  	req->complete(req, err);
>  
>  	kthread_queue_work(engine->kworker, &engine->pump_requests);
> @@ -73,10 +59,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
>  
>  	spin_lock_irqsave(&engine->queue_lock, flags);
>  
> -	/* Make sure we are not already running a request */
> -	if (engine->cur_req)
> -		goto out;
> -
>  	/* If another context is idling then defer */
>  	if (engine->idling) {
>  		kthread_queue_work(engine->kworker, &engine->pump_requests);
> @@ -108,13 +90,18 @@ static void crypto_pump_requests(struct crypto_engine *engine,
>  		goto out;
>  	}
>  
> +start_request:
> +	/* If hw is busy, do not send any request */
> +	if (engine->can_enqueue_hardware &&
> +	    !engine->can_enqueue_hardware(engine->dev))
> +		goto out;
> +
>  	/* Get the fist request from the engine queue to handle */
>  	backlog = crypto_get_backlog(&engine->queue);
>  	async_req = crypto_dequeue_request(&engine->queue);
>  	if (!async_req)
>  		goto out;
>  
> -	engine->cur_req = async_req;
>  	if (backlog)
>  		backlog->complete(backlog, -EINPROGRESS);
>  
> @@ -130,7 +117,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
>  		ret = engine->prepare_crypt_hardware(engine);
>  		if (ret) {
>  			dev_err(engine->dev, "failed to prepare crypt hardware\n");
> -			goto req_err;
> +			goto req_err_2;
>  		}
>  	}
>  
> @@ -141,26 +128,38 @@ static void crypto_pump_requests(struct crypto_engine *engine,
>  		if (ret) {
>  			dev_err(engine->dev, "failed to prepare request: %d\n",
>  				ret);
> -			goto req_err;
> +			goto req_err_2;
>  		}
> -		engine->cur_req_prepared = true;
>  	}
>  	if (!enginectx->op.do_one_request) {
>  		dev_err(engine->dev, "failed to do request\n");
>  		ret = -EINVAL;
> -		goto req_err;
> +		goto req_err_1;
>  	}
> +
>  	ret = enginectx->op.do_one_request(engine, async_req);
>  	if (ret) {
>  		dev_err(engine->dev, "Failed to do one request from queue: %d\n", ret);
> -		goto req_err;
> +		goto req_err_1;
>  	}
> -	return;
>  
> -req_err:
> -	crypto_finalize_request(engine, async_req, ret);
> -	return;
> +	goto retry;
> +
> +req_err_1:
> +	if (enginectx->op.unprepare_request) {
> +		ret = enginectx->op.unprepare_request(engine, async_req);
> +		if (ret)
> +			dev_err(engine->dev, "failed to unprepare request\n");
> +	}
> +req_err_2:
> +	async_req->complete(async_req, ret);
>  
> +retry:
> +	if (engine->can_enqueue_hardware) {
> +		spin_lock_irqsave(&engine->queue_lock, flags);
> +		goto start_request;
> +	}
> +	return;
>  out:
>  	spin_unlock_irqrestore(&engine->queue_lock, flags);
>  }
> @@ -386,15 +385,25 @@ int crypto_engine_stop(struct crypto_engine *engine)
>  EXPORT_SYMBOL_GPL(crypto_engine_stop);
>  
>  /**
> - * crypto_engine_alloc_init - allocate crypto hardware engine structure and
> - * initialize it.
> + * crypto_engine_alloc_init_and_set - allocate crypto hardware engine structure
> + * and initialize it by setting the maximum number of entries in the software
> + * crypto-engine queue.
>   * @dev: the device attached with one hardware engine
> + * @cbk: pointer to a callback function to be invoked when pumping requests
> + *       to check whether the hardware can process a new request.
> + *       This has the form:
> + *       callback(struct device *dev)
> + *       where:
> + *       @dev: contains the device that processed this response.
>   * @rt: whether this queue is set to run as a realtime task
> + * @qlen: maximum size of the crypto-engine queue
>   *
>   * This must be called from context that can sleep.
>   * Return: the crypto engine structure on success, else NULL.
>   */
> -struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
> +struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
> +						       bool (*cbk)(struct device *dev),
> +						       bool rt, int qlen)
>  {
>  	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
>  	struct crypto_engine *engine;
> @@ -411,12 +420,12 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
>  	engine->running = false;
>  	engine->busy = false;
>  	engine->idling = false;
> -	engine->cur_req_prepared = false;
>  	engine->priv_data = dev;
> +	engine->can_enqueue_hardware = cbk;
>  	snprintf(engine->name, sizeof(engine->name),
>  		 "%s-engine", dev_name(dev));
>  
> -	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
> +	crypto_init_queue(&engine->queue, qlen);
>  	spin_lock_init(&engine->queue_lock);
>  
>  	engine->kworker = kthread_create_worker(0, "%s", engine->name);
> @@ -433,6 +442,22 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
>  
>  	return engine;
>  }
> +EXPORT_SYMBOL_GPL(crypto_engine_alloc_init_and_set);
> +
> +/**
> + * crypto_engine_alloc_init - allocate crypto hardware engine structure and
> + * initialize it.
> + * @dev: the device attached with one hardware engine
> + * @rt: whether this queue is set to run as a realtime task
> + *
> + * This must be called from context that can sleep.
> + * Return: the crypto engine structure on success, else NULL.
> + */
> +struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
> +{
> +	return crypto_engine_alloc_init_and_set(dev, NULL, rt,
> +						CRYPTO_ENGINE_MAX_QLEN);
> +}
>  EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
>  
>  /**
> diff --git a/include/crypto/engine.h b/include/crypto/engine.h
> index e29cd67..15d1150 100644
> --- a/include/crypto/engine.h
> +++ b/include/crypto/engine.h
> @@ -24,7 +24,6 @@
>   * @idling: the engine is entering idle state
>   * @busy: request pump is busy
>   * @running: the engine is on working
> - * @cur_req_prepared: current request is prepared
>   * @list: link with the global crypto engine list
>   * @queue_lock: spinlock to syncronise access to request queue
>   * @queue: the crypto queue of the engine
> @@ -35,17 +34,17 @@
>   * @unprepare_crypt_hardware: there are currently no more requests on the
>   * queue so the subsystem notifies the driver that it may relax the
>   * hardware by issuing this call
> + * @can_enqueue_hardware: callback to check whether the hardware can process
> + * a new request
>   * @kworker: kthread worker struct for request pump
>   * @pump_requests: work struct for scheduling work to the request pump
>   * @priv_data: the engine private data
> - * @cur_req: the current request which is on processing
>   */
>  struct crypto_engine {
>  	char			name[ENGINE_NAME_LEN];
>  	bool			idling;
>  	bool			busy;
>  	bool			running;
> -	bool			cur_req_prepared;
>  
>  	struct list_head	list;
>  	spinlock_t		queue_lock;
> @@ -56,12 +55,12 @@ struct crypto_engine {
>  
>  	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
>  	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
> +	bool (*can_enqueue_hardware)(struct device *dev);
>  
>  	struct kthread_worker           *kworker;
>  	struct kthread_work             pump_requests;
>  
>  	void				*priv_data;
> -	struct crypto_async_request	*cur_req;
>  };
>  
>  /*
> @@ -102,6 +101,9 @@ void crypto_finalize_skcipher_request(struct crypto_engine *engine,
>  int crypto_engine_start(struct crypto_engine *engine);
>  int crypto_engine_stop(struct crypto_engine *engine);
>  struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
> +struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
> +						       bool (*cbk)(struct device *dev),
> +						       bool rt, int qlen);
>  int crypto_engine_exit(struct crypto_engine *engine);
>  
>  #endif /* _CRYPTO_ENGINE_H */
> -- 
> 2.1.0
> 


Hello

For someone which said "I'm planning to improve crypto-engine incrementally", this is lot of change in one.
You could have used my first 4 patchs which clean crypto_engine (for getting rid of cur_req_prepared/cur_req for example).

Furthermore, the callback should not be registred at init, but should be part of the struct crypto_engine_op.
And the callback need to have the crypto engine itself as parameter, in case the driver own more than one crypto engine.
In my serie I added also the current request for giving more hint on the current state and let the driver do the right decision.

Regards
