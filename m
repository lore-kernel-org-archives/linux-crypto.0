Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53405C2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EC9B2465B
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 10:41:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="esoBWxQQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbgAVKll (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 05:41:41 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37366 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729095AbgAVKll (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 05:41:41 -0500
Received: by mail-wm1-f65.google.com with SMTP id f129so6624102wmf.2;
        Wed, 22 Jan 2020 02:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fx8CxitAanlc76N9Zmq2/REx/iY6WgWzwGO6RpSpZVs=;
        b=esoBWxQQXaEGtUWg+iQT96YMTB2LHJSoHt3cWzyDB539vuV7nldYH0U9bqDRfegxw8
         ZExSe5S9pKiPz/tEDyVLvcVP1TLE+5+wXP6Bblo4iF+Fbkt9TtamRsER0TxVD1j8YQ/F
         c9gUXGA/rZsclJfIW3Ey4gNHdRVAwZkJWOhN3+ZvIBM2YsgbuQdv0adiozaU6KuF3huJ
         5+wfDBVQ2GAmzDCMwRRRjvIBsYdcU3hf+WFf+vFfpyKJ9REBANmfdHpubCRohl0DEcK+
         xyoiXCNYXxa/9tcWBgyqgSy9V5MEm85oMpON0/4XsXw9x5XaZmTWMf9l9Cbn1e54IjCl
         TAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fx8CxitAanlc76N9Zmq2/REx/iY6WgWzwGO6RpSpZVs=;
        b=pcBzGBBLzDYyiZx81vrsynx996Wf6xV2T4Zwd+LQRUd7S0MwqWYbqI3JEYelxLkWZG
         YH2/Q9eY3FqXCmlruc/bLYjD0G7GFTMItEXo1ShxgZp1RwtI8mgDGZXh5gxs4GGwPkaj
         oaiHPE7+B5+L79K+Xbks+VyuYPqzUwq6vLNI9vTFW9F32SfiE/Ss2Z9i+y2CjcybBDsD
         Ng7c36Abodfamj30MDq4z2KZup3g3ZEY7Iv5OuOEBiWe4QL4luro8KJHaCHH9ip7uF0t
         eu6fsfa6PHIurCuCQ0bwrs/o4xA9/w7leTKJz6iZ4xdwA69goynR2NL/mFl+5F4LmRse
         bOIw==
X-Gm-Message-State: APjAAAWV0d9R+WQ0fRqjWyzzAtHP9Ep8yurEyc/+5EfMBmq3v3PBIfin
        sVJjN12VrQ4SyttGLmof3VY=
X-Google-Smtp-Source: APXvYqxjzoE2dKqJ+Xj4GYDVY54bFLmZEAJOS2Sq3DdBaiRdBXwTssyMBwjQr7BLzy8gKGY5bnWhuQ==
X-Received: by 2002:a1c:9e15:: with SMTP id h21mr2308081wme.95.1579689697483;
        Wed, 22 Jan 2020 02:41:37 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id h2sm57827814wrv.66.2020.01.22.02.41.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 02:41:36 -0800 (PST)
Date:   Wed, 22 Jan 2020 11:41:34 +0100
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
Subject: Re: [RFC PATCH] Crypto-engine support for parallel requests
Message-ID: <20200122104134.GA13173@Red>
References: <1579563149-3678-1-git-send-email-iuliana.prodan@nxp.com>
 <20200121100053.GA14095@Red>
 <VI1PR04MB44454A0468073981FDA603B38C0D0@VI1PR04MB4445.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB44454A0468073981FDA603B38C0D0@VI1PR04MB4445.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 21, 2020 at 02:20:27PM +0000, Iuliana Prodan wrote:
> On 1/21/2020 12:00 PM, Corentin Labbe wrote:
> > On Tue, Jan 21, 2020 at 01:32:29AM +0200, Iuliana Prodan wrote:
> >> Added support for executing multiple requests, in parallel,
> >> for crypto engine.
> >> A no_reqs is initialized and set in the new
> >> crypto_engine_alloc_init_and_set function.
> >> Here, is also set the maximum size for crypto-engine software
> >> queue (not hardcoded anymore).
> >> On crypto_pump_requests the no_reqs is increased, until the
> >> max_no_reqs is reached, and decreased on crypto_finalize_request,
> >> or on error path (in case a prepare_request or do_one_request
> >> operation was unsuccessful).
> >>
> >> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> >> ---
> >>   crypto/crypto_engine.c  | 112 +++++++++++++++++++++++++++++++++---------------
> >>   include/crypto/engine.h |  11 +++--
> >>   2 files changed, 84 insertions(+), 39 deletions(-)
> >>
> >> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> >> index eb029ff..5219141 100644
> >> --- a/crypto/crypto_engine.c
> >> +++ b/crypto/crypto_engine.c
> >> @@ -14,6 +14,7 @@
> >>   #include "internal.h"
> >>   
> >>   #define CRYPTO_ENGINE_MAX_QLEN 10
> >> +#define CRYPTO_ENGINE_MAX_CONCURRENT_REQS 1
> >>   
> >>   /**
> >>    * crypto_finalize_request - finalize one request if the request is done
> >> @@ -22,32 +23,27 @@
> >>    * @err: error number
> >>    */
> >>   static void crypto_finalize_request(struct crypto_engine *engine,
> >> -			     struct crypto_async_request *req, int err)
> >> +				    struct crypto_async_request *req, int err)
> >>   {
> >>   	unsigned long flags;
> >> -	bool finalize_cur_req = false;
> >> +	bool finalize_req = false;
> >>   	int ret;
> >>   	struct crypto_engine_ctx *enginectx;
> >>   
> >>   	spin_lock_irqsave(&engine->queue_lock, flags);
> >> -	if (engine->cur_req == req)
> >> -		finalize_cur_req = true;
> >> +	if (engine->no_reqs > 0) {
> >> +		finalize_req = true;
> >> +		engine->no_reqs--;
> >> +	}
> >>   	spin_unlock_irqrestore(&engine->queue_lock, flags);
> >>   
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
> >> +	if (finalize_req && enginectx->op.prepare_request &&
> >> +	    enginectx->op.unprepare_request) {
> >> +		ret = enginectx->op.unprepare_request(engine, req);
> >> +		if (ret)
> >> +			dev_err(engine->dev, "failed to unprepare request\n");
> >>   	}
> >> -
> >>   	req->complete(req, err);
> >>   
> >>   	kthread_queue_work(engine->kworker, &engine->pump_requests);
> >> @@ -73,8 +69,8 @@ static void crypto_pump_requests(struct crypto_engine *engine,
> >>   
> >>   	spin_lock_irqsave(&engine->queue_lock, flags);
> >>   
> >> -	/* Make sure we are not already running a request */
> >> -	if (engine->cur_req)
> >> +	/* Make sure we have space, for more requests to run */
> >> +	if (engine->no_reqs >= engine->max_no_reqs)
> >>   		goto out;
> >>   
> >>   	/* If another context is idling then defer */
> >> @@ -108,13 +104,16 @@ static void crypto_pump_requests(struct crypto_engine *engine,
> >>   		goto out;
> >>   	}
> >>   
> >> +retry:
> >>   	/* Get the fist request from the engine queue to handle */
> >>   	backlog = crypto_get_backlog(&engine->queue);
> >>   	async_req = crypto_dequeue_request(&engine->queue);
> >>   	if (!async_req)
> >>   		goto out;
> >>   
> >> -	engine->cur_req = async_req;
> >> +	/* Increase the number of concurrent requests that are in execution */
> >> +	engine->no_reqs++;
> >> +
> >>   	if (backlog)
> >>   		backlog->complete(backlog, -EINPROGRESS);
> >>   
> >> @@ -130,7 +129,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
> >>   		ret = engine->prepare_crypt_hardware(engine);
> >>   		if (ret) {
> >>   			dev_err(engine->dev, "failed to prepare crypt hardware\n");
> >> -			goto req_err;
> >> +			goto req_err_2;
> >>   		}
> >>   	}
> >>   
> >> @@ -141,26 +140,45 @@ static void crypto_pump_requests(struct crypto_engine *engine,
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
> >> -
> >> -req_err:
> >> -	crypto_finalize_request(engine, async_req, ret);
> >> -	return;
> >>   
> >> +	/*
> >> +	 * If there is still space for concurrent requests,
> >> +	 * try and send a new one
> >> +	 */
> >> +	spin_lock_irqsave(&engine->queue_lock, flags);
> >> +	if (engine->no_reqs < engine->max_no_reqs)
> >> +		goto retry;
> > 
> > You should check if engine->queue.qlen > 0 before retry.
> > 
> >> +	goto out;
> >> +
> >> +req_err_1:
> >> +	if (enginectx->op.unprepare_request) {
> >> +		ret = enginectx->op.unprepare_request(engine, async_req);
> >> +		if (ret)
> >> +			dev_err(engine->dev, "failed to unprepare request\n");
> >> +	}
> >> +req_err_2:
> >> +	async_req->complete(async_req, ret);
> >> +	spin_lock_irqsave(&engine->queue_lock, flags);
> >> +	/*
> >> +	 * If unable to prepare or execute the request,
> >> +	 * decrease the number of concurrent requests
> >> +	 */
> >> +	engine->no_reqs--;
> >> +	goto retry;
> > 
> > You should check if engine->queue.qlen > 0 before retry.
> > 
> Here (and above) is not needed to check for qlen > 0, since on retry, 
> first thing is tryin to dequeue an async_req from crypto-engine queue. 
> In crypto_dequeue_request function is a check for qlen, that means than 
> in pump_request will goto out.
> 
> >>   out:
> >>   	spin_unlock_irqrestore(&engine->queue_lock, flags);
> >>   }
> >> @@ -386,15 +404,21 @@ int crypto_engine_stop(struct crypto_engine *engine)
> >>   EXPORT_SYMBOL_GPL(crypto_engine_stop);
> >>   
> >>   /**
> >> - * crypto_engine_alloc_init - allocate crypto hardware engine structure and
> >> - * initialize it.
> >> + * crypto_engine_alloc_init_and_set - allocate crypto hardware engine structure
> >> + * and initialize it by setting the maximum number of entries in the software
> >> + * crypto-engine queue and the maximum number of concurrent requests that can
> >> + * be executed at once.
> >>    * @dev: the device attached with one hardware engine
> >>    * @rt: whether this queue is set to run as a realtime task
> >> + * @max_no_reqs: maximum number of request that can be executed in parallel
> >> + * @qlen: maximum size of the crypto-engine queue
> >>    *
> >>    * This must be called from context that can sleep.
> >>    * Return: the crypto engine structure on success, else NULL.
> >>    */
> >> -struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
> >> +struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
> >> +						       bool rt, int max_no_reqs,
> >> +						       int qlen)
> >>   {
> >>   	struct sched_param param = { .sched_priority = MAX_RT_PRIO / 2 };
> >>   	struct crypto_engine *engine;
> >> @@ -411,12 +435,13 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
> >>   	engine->running = false;
> >>   	engine->busy = false;
> >>   	engine->idling = false;
> >> -	engine->cur_req_prepared = false;
> >>   	engine->priv_data = dev;
> >>   	snprintf(engine->name, sizeof(engine->name),
> >>   		 "%s-engine", dev_name(dev));
> >> +	engine->max_no_reqs = max_no_reqs;
> >> +	engine->no_reqs = 0;
> >>   
> >> -	crypto_init_queue(&engine->queue, CRYPTO_ENGINE_MAX_QLEN);
> >> +	crypto_init_queue(&engine->queue, qlen);
> >>   	spin_lock_init(&engine->queue_lock);
> >>   
> >>   	engine->kworker = kthread_create_worker(0, "%s", engine->name);
> >> @@ -433,6 +458,23 @@ struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt)
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
> >> +	return crypto_engine_alloc_init_and_set(dev, rt,
> >> +						CRYPTO_ENGINE_MAX_CONCURRENT_REQS,
> >> +						CRYPTO_ENGINE_MAX_QLEN);
> >> +}
> >>   EXPORT_SYMBOL_GPL(crypto_engine_alloc_init);
> >>   
> >>   /**
> >> diff --git a/include/crypto/engine.h b/include/crypto/engine.h
> >> index e29cd67..5f9a6df 100644
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
> >> @@ -38,14 +37,14 @@
> >>    * @kworker: kthread worker struct for request pump
> >>    * @pump_requests: work struct for scheduling work to the request pump
> >>    * @priv_data: the engine private data
> >> - * @cur_req: the current request which is on processing
> >> + * @max_no_reqs: maximum number of request which can be processed in parallel
> >> + * @no_reqs: current number of request which are processed in parallel
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
> >> @@ -61,7 +60,8 @@ struct crypto_engine {
> >>   	struct kthread_work             pump_requests;
> >>   
> >>   	void				*priv_data;
> >> -	struct crypto_async_request	*cur_req;
> >> +	int			max_no_reqs;
> >> +	int			no_reqs;
> >>   };
> >>   
> >>   /*
> >> @@ -102,6 +102,9 @@ void crypto_finalize_skcipher_request(struct crypto_engine *engine,
> >>   int crypto_engine_start(struct crypto_engine *engine);
> >>   int crypto_engine_stop(struct crypto_engine *engine);
> >>   struct crypto_engine *crypto_engine_alloc_init(struct device *dev, bool rt);
> >> +struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
> >> +						       bool rt, int max_no_reqs,
> >> +						       int qlen);
> >>   int crypto_engine_exit(struct crypto_engine *engine);
> >>   
> >>   #endif /* _CRYPTO_ENGINE_H */
> >> -- 
> >> 2.1.0
> >>
> > 
> > Hello
> > 
> > In your model, who is running finalize_request() ?
> finalize_request() in CAAM, and in other drivers, is called on the _done 
> callback (stm32, virtio and omap).
> 
> > In caam it seems that you have a taskqueue dedicated for that but you cannot assume that all drivers will have this.
> > I think the crypto_engine should be sufficient by itself and does not need external thread/taskqueue.
> > 
> > But in your case, it seems that you dont have the choice, since do_one_request does not "do" but simply enqueue the request in the "jobring".
> > 
> But, do_one_request it shouldn't, necessary,  execute the request. Is ok 
> to enqueue it, since we have asynchronous requests. do_one_request is 
> not blocking.
> 
> > What about adding along prepare/do_one_request/unprepare a new enqueue()/can_do_more() function ?
> > 
> > The stream will be:
> > retry:
> > optionnal prepare
> > optionnal enqueue
> > optionnal can_do_more() (goto retry)
> > optionnal do_one_request
> > 
> > then
> > finalize()
> > optionnal unprepare
> > 
> 
> I'm planning to improve crypto-engine incrementally, so I'm taking one 
> step at a time :)
> But I'm not sure if adding an enqueue operation is a good idea, since, 
> my understanding, is that do_one_request is a non-blocking operation and 
> it shouldn't execute the request.

do_one_request is a blocking operation on amlogic/sun8i-ce/sun8i-ss and the "documentation" is clear "@do_one_request: do encryption for current request".
But I agree that is a bit small for a documentation.

> 
> IMO, the crypto-engine flow should be kept simple:
> 1. a request comes to hw -> this is doing transfer_request_to_engine;
> 2. CE enqueue the requests
> 3. on pump_requests:
> 	3. a) optional prepare operation
> 	3. b) sends the reqs to hw, by do_one_request operation. To wait for 
> completion here it contradicts the asynchronous crypto API. 

There are no contradiction, the call is asynchronous for the user of the API.

> do_one_request operation has a crypto_async_request type as argument.
> Note: Step 3. b) can be done several times, depending on size of hw queue.
> 4. in driver, when req is done:
> 	4. a) optional unprepare operation
> 	4. b) crypto_finalize_request is called
> 	

Since Herbert say the same thing than me:
"Instead, we should just let the driver tell us when it is ready to accept more requests."
Let me insist on my proposal, I have updated my serie, and it should handle your case and mine.
I will send it within minutes.

Regards
