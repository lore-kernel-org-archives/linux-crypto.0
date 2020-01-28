Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D64C2D0DB
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 13:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94A2022522
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 13:28:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V6CQDTgT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgA1N2T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 08:28:19 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44377 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgA1N2S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 08:28:18 -0500
Received: by mail-wr1-f66.google.com with SMTP id q10so16010705wrm.11;
        Tue, 28 Jan 2020 05:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vWF9Pq5JrdPSNZ4XKf1HSoWxI2EvUWW/WuJwz50sf5k=;
        b=V6CQDTgTPP7b/RiPU9ILJzfBXLSjomB65eDcGvLwtywcStnd5EYweE3v4W29cQemND
         om5TMGOG8+UOv21O+tLBxutek5uHWMN4UkobxMsL6ywRmo/iC5u9cUEqnhjh8P3RLynK
         mBQUQgyIvIdxNwGZc+MwXOui/4FpxXaxDWAeE8fC9REYFg0BxgVOy00uoxGhXKw8a3k6
         wB6lTvWlOcpQ5QrxxVY7+qNIp7mbKOpoQI9ALtn2Ujgs9XQI2uzo9hcCVNZDfMfpQXLp
         dLPtiTxpS/Sg4Yf8A3ZnHPm6uYrUWeHo73ql+AD3mbbx44WnWzsktYar3Ti3ao38CgyO
         8MKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vWF9Pq5JrdPSNZ4XKf1HSoWxI2EvUWW/WuJwz50sf5k=;
        b=B6wi2q7yuJIebwxZ/btzCmH0T8MwnLX5BQSR60v9ah4FkkYbUvz33o2/N7rJ2mPY0D
         RTTQyAV7ndufNeV2BdkJIqUov01ir4Np5AnVwsw5tFpZK2V9SbaPgnU3qL9r0LIGEDG+
         tIpbYPuG9BX3DRnUypHjYHo9pnw8PudvWgl8X50PFoyfebSA3m+gqmMXQupFHMPf0oUE
         LEv5M/C/cfuJS9Hcsx2MCbn0jy/j2Yk2wE+vOnNSgdjLhSgSdBqKOf7RuQeG7qbuuXmF
         viMbQ7nHOYprc94Ofclsq6UeP0B1puIP84TysSrVUfWFRU/qSTB7cCsI1xuOodVXr3K6
         s0dw==
X-Gm-Message-State: APjAAAU+7o3idsHJUVDQY4JI9XDFPIOI5PVOSgikv41Lm9+wKFPnaogX
        igYIbzCXvhmAzQc5OB79MWU=
X-Google-Smtp-Source: APXvYqwdWHDMUCChsnDCvyUUGKyUCMnE4IKWyZIdW0K4UTEbLRWORJQSwda3zlPt1mwemEjZL3P5XQ==
X-Received: by 2002:adf:e58d:: with SMTP id l13mr28798600wrm.135.1580218095384;
        Tue, 28 Jan 2020 05:28:15 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id z3sm25494799wrs.94.2020.01.28.05.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 05:28:11 -0800 (PST)
Date:   Tue, 28 Jan 2020 14:28:09 +0100
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
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] crypto: engine - support for parallel requests
Message-ID: <20200128132809.GA17295@Red>
References: <1580163425-13266-1-git-send-email-iuliana.prodan@nxp.com>
 <20200128085845.GB10493@Red>
 <AM0PR04MB71718DED6BD597DD2FE023298C0A0@AM0PR04MB7171.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB71718DED6BD597DD2FE023298C0A0@AM0PR04MB7171.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 28, 2020 at 11:01:13AM +0000, Iuliana Prodan wrote:
> On 1/28/2020 10:58 AM, Corentin Labbe wrote:
> > On Tue, Jan 28, 2020 at 12:17:05AM +0200, Iuliana Prodan wrote:
> >> Added support for executing multiple requests, in parallel,
> >> for crypto engine.
> >> A new callback is added, can_enqueue_hardware, which asks the
> >> driver if the hardware has free space, to enqueue a new request.
> >> The new crypto_engine_alloc_init_and_set function, initialize
> >> crypto-engine, sets the maximum size for crypto-engine software
> >> queue (not hardcoded anymore) and the can_enqueue_hardware callback.
> >> On crypto_pump_requests, if can_enqueue_hardware callback returns true,
> >> a new request is send to hardware, until there is no space and the
> >> callback returns false.
> >>
> >> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> >>
> >> ---
> >> Changes since V0 (RFC):
> >> 	- removed max_no_req and no_req, as the number of request that
> >> 	  can be processed in parallel;
> >> 	- added a new callback, can_enqueue_hardware, to check whether
> >> 	  the hardware can process a new request.
> >> ---
> >>
> >>   crypto/crypto_engine.c  | 105 ++++++++++++++++++++++++++++++------------------
> >>   include/crypto/engine.h |  10 +++--
> >>   2 files changed, 71 insertions(+), 44 deletions(-)
> >>
> >> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> >> index eb029ff..ee3a610 100644
> >> --- a/crypto/crypto_engine.c
> >> +++ b/crypto/crypto_engine.c
> >> @@ -22,32 +22,18 @@
> >>    * @err: error number
> >>    */
> >>   static void crypto_finalize_request(struct crypto_engine *engine,
> >> -			     struct crypto_async_request *req, int err)
> >> +				    struct crypto_async_request *req, int err)
> >>   {
> >> -	unsigned long flags;
> >> -	bool finalize_cur_req = false;
> >>   	int ret;
> >>   	struct crypto_engine_ctx *enginectx;
> >>   
> >> -	spin_lock_irqsave(&engine->queue_lock, flags);
> >> -	if (engine->cur_req == req)
> >> -		finalize_cur_req = true;
> >> -	spin_unlock_irqrestore(&engine->queue_lock, flags);
> >> -
> >> -	if (finalize_cur_req) {
> >> -		enginectx = crypto_tfm_ctx(req->tfm);
> >> -		if (engine->cur_req_prepared &&
> >> -		    enginectx->op.unprepare_request) {
> >> -			ret = enginectx->op.unprepare_request(engine, req);
> >> -			if (ret)
> >> -				dev_err(engine->dev, "failed to unprepare request\n");
> >> -		}
> >> -		spin_lock_irqsave(&engine->queue_lock, flags);
> >> -		engine->cur_req = NULL;
> >> -		engine->cur_req_prepared = false;
> >> -		spin_unlock_irqrestore(&engine->queue_lock, flags);
> >> +	enginectx = crypto_tfm_ctx(req->tfm);
> >> +	if (enginectx->op.prepare_request &&
> >> +	    enginectx->op.unprepare_request) {
> >> +		ret = enginectx->op.unprepare_request(engine, req);
> >> +		if (ret)
> >> +			dev_err(engine->dev, "failed to unprepare request\n");
> >>   	}
> >> -
> >>   	req->complete(req, err);
> >>   
> >>   	kthread_queue_work(engine->kworker, &engine->pump_requests);
> >> @@ -73,10 +59,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
> >>   
> >>   	spin_lock_irqsave(&engine->queue_lock, flags);
> >>   
> >> -	/* Make sure we are not already running a request */
> >> -	if (engine->cur_req)
> >> -		goto out;
> >> -
> >>   	/* If another context is idling then defer */
> >>   	if (engine->idling) {
> >>   		kthread_queue_work(engine->kworker, &engine->pump_requests);
> >> @@ -108,13 +90,18 @@ static void crypto_pump_requests(struct crypto_engine *engine,
> >>   		goto out;
> >>   	}
> >>   
> >> +start_request:
> >> +	/* If hw is busy, do not send any request */
> >> +	if (engine->can_enqueue_hardware &&
> >> +	    !engine->can_enqueue_hardware(engine->dev))
> >> +		goto out;
> >> +
> >>   	/* Get the fist request from the engine queue to handle */
> >>   	backlog = crypto_get_backlog(&engine->queue);
> >>   	async_req = crypto_dequeue_request(&engine->queue);
> >>   	if (!async_req)
> >>   		goto out;
> >>   
> >> -	engine->cur_req = async_req;
> >>   	if (backlog)
> >>   		backlog->complete(backlog, -EINPROGRESS);
> >>   
> >> @@ -130,7 +117,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
> >>   		ret = engine->prepare_crypt_hardware(engine);
> >>   		if (ret) {
> >>   			dev_err(engine->dev, "failed to prepare crypt hardware\n");
> >> -			goto req_err;
> >> +			goto req_err_2;
> >>   		}
> >>   	}
> >>   
> >> @@ -141,26 +128,38 @@ static void crypto_pump_requests(struct crypto_engine *engine,
> >>   		if (ret) {
> >>   			dev_err(engine->dev, "failed to prepare request: %d\n",
> >>   				ret);
> >> -			goto req_err;
> >> +			goto req_err_2;
> >>   		}
> >> -		engine->cur_req_prepared = true;
> >>   	}
> >>   	if (!enginectx->op.do_one_request) {
> >>   		dev_err(engine->dev, "failed to do request\n");
> >>   		ret = -EINVAL;
> >> -		goto req_err;
> >> +		goto req_err_1;
> >>   	}
> >> +
> >>   	ret = enginectx->op.do_one_request(engine, async_req);
> >>   	if (ret) {
> >>   		dev_err(engine->dev, "Failed to do one request from queue: %d\n", ret);
> >> -		goto req_err;
> >> +		goto req_err_1;
> >>   	}
> >> -	return;
> >>   
> >> -req_err:
> >> -	crypto_finalize_request(engine, async_req, ret);
> >> -	return;
> >> +	goto retry;
> >> +
> >> +req_err_1:
> >> +	if (enginectx->op.unprepare_request) {
> >> +		ret = enginectx->op.unprepare_request(engine, async_req);
> >> +		if (ret)
> >> +			dev_err(engine->dev, "failed to unprepare request\n");
> >> +	}
> >> +req_err_2:
> >> +	async_req->complete(async_req, ret);
> >>   
> >> +retry:
> >> +	if (engine->can_enqueue_hardware) {
> >> +		spin_lock_irqsave(&engine->queue_lock, flags);
> >> +		goto start_request;
> >> +	}
> >> +	return;
> >>   out:
> >>   	spin_unlock_irqrestore(&engine->queue_lock, flags);
> >>   }
> >> @@ -386,15 +385,25 @@ int crypto_engine_stop(struct crypto_engine *engine)
> >>   EXPORT_SYMBOL_GPL(crypto_engine_stop);
> >>   
> >>   /**
> >> - * crypto_engine_alloc_init - allocate crypto hardware engine structure and
> >> - * initialize it.
> >> + * crypto_engine_alloc_init_and_set - allocate crypto hardware engine structure
> >> + * and initialize it by setting the maximum number of entries in the software
> >> + * crypto-engine queue.
> >>    * @dev: the device attached with one hardware engine
> >> + * @cbk: pointer to a callback function to be invoked when pumping requests
> >> + *       to check whether the hardware can process a new request.
> >> + *       This has the form:
> >> + *       callback(struct device *dev)
> >> + *       where:
> >> + *       @dev: contains the device that processed this response.
> >>    * @rt: whether this queue is set to run as a realtime task
> >> + * @qlen: maximum size of the crypto-engine queue
> >>    *
> >>    * This must be called from context that can sleep.
> >>    * Return: the crypto engine structure on success, else NULL.
> >>    */
> >> -struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
> >> +struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
> >> +						       bool (*cbk)(struct device *dev),
> >> +						       bool rt, int qlen)
> >>   {
> >>   	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
> >>   	struct crypto_engine *engine;
> >> @@ -411,12 +420,12 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
> >>   	engine->running = false;
> >>   	engine->busy = false;
> >>   	engine->idling = false;
> >> -	engine->cur_req_prepared = false;
> >>   	engine->priv_data = dev;
> >> +	engine->can_enqueue_hardware = cbk;
> >>   	snprintf(engine->name, sizeof(engine->name),
> >>   		 "%s-engine", dev_name(dev));
> >>   
> >> -	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
> >> +	crypto_init_queue(&engine->queue, qlen);
> >>   	spin_lock_init(&engine->queue_lock);
> >>   
> >>   	engine->kworker = kthread_create_worker(0, "%s", engine->name);
> >> @@ -433,6 +442,22 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
> >>   
> >>   	return engine;
> >>   }
> >> +EXPORT_SYMBOL_GPL(crypto_engine_alloc_init_and_set);
> >> +
> >> +/**
> >> + * crypto_engine_alloc_init - allocate crypto hardware engine structure and
> >> + * initialize it.
> >> + * @dev: the device attached with one hardware engine
> >> + * @rt: whether this queue is set to run as a realtime task
> >> + *
> >> + * This must be called from context that can sleep.
> >> + * Return: the crypto engine structure on success, else NULL.
> >> + */
> >> +struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
> >> +{
> >> +	return crypto_engine_alloc_init_and_set(dev, NULL, rt,
> >> +						CRYPTO_ENGINE_MAX_QLEN);
> >> +}
> >>   EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
> >>   
> >>   /**
> >> diff --git a/include/crypto/engine.h b/include/crypto/engine.h
> >> index e29cd67..15d1150 100644
> >> --- a/include/crypto/engine.h
> >> +++ b/include/crypto/engine.h
> >> @@ -24,7 +24,6 @@
> >>    * @idling: the engine is entering idle state
> >>    * @busy: request pump is busy
> >>    * @running: the engine is on working
> >> - * @cur_req_prepared: current request is prepared
> >>    * @list: link with the global crypto engine list
> >>    * @queue_lock: spinlock to syncronise access to request queue
> >>    * @queue: the crypto queue of the engine
> >> @@ -35,17 +34,17 @@
> >>    * @unprepare_crypt_hardware: there are currently no more requests on the
> >>    * queue so the subsystem notifies the driver that it may relax the
> >>    * hardware by issuing this call
> >> + * @can_enqueue_hardware: callback to check whether the hardware can process
> >> + * a new request
> >>    * @kworker: kthread worker struct for request pump
> >>    * @pump_requests: work struct for scheduling work to the request pump
> >>    * @priv_data: the engine private data
> >> - * @cur_req: the current request which is on processing
> >>    */
> >>   struct crypto_engine {
> >>   	char			name[ENGINE_NAME_LEN];
> >>   	bool			idling;
> >>   	bool			busy;
> >>   	bool			running;
> >> -	bool			cur_req_prepared;
> >>   
> >>   	struct list_head	list;
> >>   	spinlock_t		queue_lock;
> >> @@ -56,12 +55,12 @@ struct crypto_engine {
> >>   
> >>   	int (*prepare_crypt_hardware)(struct crypto_engine *engine);
> >>   	int (*unprepare_crypt_hardware)(struct crypto_engine *engine);
> >> +	bool (*can_enqueue_hardware)(struct device *dev);
> >>   
> >>   	struct kthread_worker           *kworker;
> >>   	struct kthread_work             pump_requests;
> >>   
> >>   	void				*priv_data;
> >> -	struct crypto_async_request	*cur_req;
> >>   };
> >>   
> >>   /*
> >> @@ -102,6 +101,9 @@ void crypto_finalize_skcipher_request(struct crypto_engine *engine,
> >>   int crypto_engine_start(struct crypto_engine *engine);
> >>   int crypto_engine_stop(struct crypto_engine *engine);
> >>   struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
> >> +struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
> >> +						       bool (*cbk)(struct device *dev),
> >> +						       bool rt, int qlen);
> >>   int crypto_engine_exit(struct crypto_engine *engine);
> >>   
> >>   #endif /* _CRYPTO_ENGINE_H */
> >> -- 
> >> 2.1.0
> >>
> > 
> > 
> > Hello
> > 
> > For someone which said "I'm planning to improve crypto-engine incrementally", this is lot of change in one.
> > You could have used my first 4 patchs which clean crypto_engine (for getting rid of cur_req_prepared/cur_req for example).
> > 
> 
> The number of patches is something debatable!
> Your first patches were already in my RFC!
> This patch adds support for independent requests by adding a check for 
> hardware availability. Removing current request (cur_req) means we need 
> to add something else to break from the loop we have in pump_requests(). 
> I didn't see how I could split it in several commits, but I don't see 
> this as a big deal.
> We can split it any way we/Herbert agree on.
> 
> > Furthermore, the callback should not be registred at init, but should be part of the struct crypto_engine_op.
> 
> We need to check if we can enqueue a new request before dequeuing the 
> request from crypto-engine's queue.
> 
> > And the callback need to have the crypto engine itself as parameter, in case the driver own more than one crypto engine.
> I can add crypto-engine as argument if you consider it useful.
> 
> > In my serie I added also the current request for giving more hint on the current state and let the driver do the right decision.
> > 
> If you refer to linked requests, this is something specific for your 
> case/driver. I'm not handling this case, here.

That's the point, while I am trying to bring the change to support every case, you continue other each iteration to support only yours.

So I will stop here and wait to see what Herbert will think.

Regards
