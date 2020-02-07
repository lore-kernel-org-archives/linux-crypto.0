Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08672C352A2
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 12:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3F9220838
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 12:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p14V7iD5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgBGMR3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 07:17:29 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35644 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgBGMR3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 07:17:29 -0500
Received: by mail-wr1-f65.google.com with SMTP id w12so2455893wrt.2;
        Fri, 07 Feb 2020 04:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=14BCez9Md8qjMVgprwHOmq3SMfh9WR/fd6ynsVwnQHM=;
        b=p14V7iD564ngsVqBUQJI1q6/pp9IxFCc75PikyQ+k4eJagKSVUPQdWAagnIHdTnBBV
         WBD5xKvjWEqg9YL2zehqyl5VZpBBLRf0lfI5/7KEUFU2sPbFa9dJeEJnGZUOwypfq7hL
         ksNZ/iaQ9MUvtSWAWep5YXIbcdg37P04XKtOLVUcnWZ2NnVBzxbqWDVs3xTe5Mah1gAh
         3gfiRiChU3+2mxlGsWnRm2xO+qLBXoyg665L1C/WI0bJ0/MpoHwEeECqiA+jT7Qi8LT+
         iqom3ccSnXd6k6XmtxDZi1N1efN4G5ouCA7IK6Ocq2m63CPBOLHttAnK76uoWh5yGlBV
         WVPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=14BCez9Md8qjMVgprwHOmq3SMfh9WR/fd6ynsVwnQHM=;
        b=k20d4izR7aCuu0rjoFdfiH9v9VfmOb/avPgMrg7AQZjuaz2vpCVRK7/+xqp9tGZRag
         HwXnn309zSJ1I37dsolafr9za2cotmqJ5BHdDeXmWv9EB0wkTqgb/GLGQKYOx9aTK9/T
         CUD2x0rn6P2kG+8H6LXT7/m/K6kb9Lh2Xt70OXGwHL26fpHNnxpIBvGtixrvKX/5o17C
         Pk8M+90ZzwLZ6gzpSYi+M+zf9mSaVxlRVV6V3NrCkmZjL9mWreN+W/dqgCF10CNMDy3/
         gvS9yAfFBdQ2i3FB7dupx2oB2tiXKzUfwl0NJUCJoj8EdryYzxDVerZaiOuU5Ikn5Iuj
         LhnQ==
X-Gm-Message-State: APjAAAW7t7j2AkSEpAtMW1DwGuPu5tZ4bPGpjYtgLE7xfazMDmiKsdMC
        Rg2tRZveXhMgDU82z63EGLE=
X-Google-Smtp-Source: APXvYqwd1KlpxD8gC5hOi1tP09C3sPfcfdaGnwHeyiZvdpKqsCaDfK/KoFL/V9SqLOMlJSv+Z8k8gA==
X-Received: by 2002:adf:ee43:: with SMTP id w3mr4441395wro.339.1581077845933;
        Fri, 07 Feb 2020 04:17:25 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 18sm3047895wmf.1.2020.02.07.04.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 04:17:25 -0800 (PST)
Date:   Fri, 7 Feb 2020 13:17:23 +0100
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
Subject: Re: [PATCH v2 1/2] crypto: engine - support for parallel requests
Message-ID: <20200207121723.GB10979@Red>
References: <1580819660-30211-1-git-send-email-iuliana.prodan@nxp.com>
 <1580819660-30211-2-git-send-email-iuliana.prodan@nxp.com>
 <20200205191128.GA32606@Red>
 <AM0PR04MB71711FEFD0738893772BE3198C1C0@AM0PR04MB7171.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB71711FEFD0738893772BE3198C1C0@AM0PR04MB7171.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 07, 2020 at 11:26:38AM +0000, Iuliana Prodan wrote:
> On 2/5/2020 9:11 PM, Corentin Labbe wrote:
> > On Tue, Feb 04, 2020 at 02:34:19PM +0200, Iuliana Prodan wrote:
> >> Added support for executing multiple requests, in parallel,
> >> for crypto engine.
> >> A new callback is added, can_enqueue_more, which asks the
> >> driver if the hardware has free space, to enqueue a new request.
> >> The new crypto_engine_alloc_init_and_set function, initialize
> >> crypto-engine, sets the maximum size for crypto-engine software
> >> queue (not hardcoded anymore) and the can_enqueue_more callback.
> >> On crypto_pump_requests, if can_enqueue_more callback returns true,
> >> a new request is send to hardware, until there is no space and the
> >> callback returns false.
> >>
> >> Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
> >> ---
> >>   crypto/crypto_engine.c  | 106 ++++++++++++++++++++++++++++++------------------
> >>   include/crypto/engine.h |  10 +++--
> >>   2 files changed, 72 insertions(+), 44 deletions(-)
> >>
> >> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> >> index eb029ff..aba934f 100644
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
> > 
> > Hello
> > 
> > Your patch has the same problem than mine reported by Horia.
> > If a queue has more than one request, a first crypto_pump_requests() will send a request and for drivers which do not block on do_one_request() crypto_pump_requests() will end.
> > Then another crypto_pump_requests() will fire sending a second request while the driver does not support that.
> 
> > So we need to replace engine->cur_req by another locking mechanism.
> > Perhaps the cleaner is to add a "request count" (increased when do_one_request, decreased in crypto_finalize_request)
> > I know that the early version have that and it was removed, but I do not see any better way.
> > 
> 
> The "request count" I've change it to can_enqueue_more, so the hw can 
> "answer" if it can enqueue or not.
> 
> I'll (re)add the cur_req in crypto-engine.
> If the new callback, can_enqueue_more, is not implemented the crypto- 
> engine will work as before - will send requests to hardware, one-by-one, 
> on crypto_pump_requests, and complete it, on crypto_finalize_request, 
> and so on.
> 

But if the crypto_engine use can_enqueue_more, cur_req is a lie, so the name should be changed (or this fact need to be heavy documented on each of its occurence).
