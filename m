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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2335EC33C9E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 08:40:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEDB020663
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 08:40:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s/LpWYEI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgA1Ikq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 03:40:46 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51695 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgA1Ikq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 03:40:46 -0500
Received: by mail-wm1-f66.google.com with SMTP id t23so1532734wmi.1;
        Tue, 28 Jan 2020 00:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=CY0t0Jh4KmNVk3ml8hjXW8Vdas/J0r5nTkeZF74pSy0=;
        b=s/LpWYEIcfGMYj16YRbqin5Jwv6iYr8gbOvilsGF5E0NS2RZAtMwaA1QgmEQYJer9l
         4ljNiptvd8t9Ch8FcAtJMGOpsZC7Bk7cAq3uEWy1XgHr05QqOkG6/Z6FAc7pG4YfH7/f
         y9qhiHNjmpiPoEq73qxiikV+5Ddl2RuzTXiI9MNBrQpPAQtdZb+B3rJl8wIXq8z0Nx3E
         +sVt1BFSfbt6uPe8R6WoRQ2YkRtvFsJmeyPNmYHYoRXj1G+qvKS6+DUj+TcOhTLsJ5IF
         nErwzIEFNvxk5WUgdwfBJoaDEgVql8oToASv3JMQT5Ey6g/Pgpv9BMAeN6vhVLAV2gW/
         5xkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=CY0t0Jh4KmNVk3ml8hjXW8Vdas/J0r5nTkeZF74pSy0=;
        b=Mf10ywzAQdNJO3INEn/+Ala9PeqQQcwGOXsXV2j6ibB29EPvhjXzYZ4jUmMqSaWD77
         cOXU7PoiFlqJSQd5py6InFJ9jmmkHR3+6OpPSOAZvWBffxDZc0kjKcCynkROQByR/pky
         qkad1pv+V+uesDMmCjidFs1JIrO36C0MZO5HR2r6Wp/7s2EQVgQwbkdoj4xSxd42wdqh
         wHd9V3yVaVUs4fpC2hF9S0oliSsB6itGUKr1ubePE2BqaZI9Snj2lWkkdhBimy4W3KFG
         U8L4Xb5DBa809UxfZn/AMa+d7cqLkbnDuKHNke+C4uY/Lb2npCMw256Sm2XMJi+7/JqI
         3SSg==
X-Gm-Message-State: APjAAAUzXWzulactpAFu6YPesyiPG4ng5e5BUiPPP25Tu7VXI40hPbqr
        7YAdKz2NceVxzvQpmg3VCWE=
X-Google-Smtp-Source: APXvYqydtAPMTd8VYXMiKc/zqY0XzwWworu4R59xBUl28EjN007x2C/d4Omf/55dw5k8RxiP/TVZCQ==
X-Received: by 2002:a1c:81d3:: with SMTP id c202mr3533111wmd.14.1580200843638;
        Tue, 28 Jan 2020 00:40:43 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id d16sm28065304wrg.27.2020.01.28.00.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 00:40:42 -0800 (PST)
Date:   Tue, 28 Jan 2020 09:40:41 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "wens@csie.org" <wens@csie.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH 5/9] crypto: engine: add enqueue_request/can_do_more
Message-ID: <20200128084041.GA10493@Red>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
 <20200122104528.30084-6-clabbe.montjoie@gmail.com>
 <AM0PR04MB717155300E3575C07D31E1D08C0B0@AM0PR04MB7171.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AM0PR04MB717155300E3575C07D31E1D08C0B0@AM0PR04MB7171.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 27, 2020 at 10:58:36PM +0000, Iuliana Prodan wrote:
> On 1/22/2020 12:45 PM, Corentin Labbe wrote:
> > This patchs adds two new function wrapper in crypto_engine.
> > - enqueue_request() for drivers enqueuing request to hardware.
> > - can_queue_more() for letting drivers to tell if they can
> > enqueue/prepare more.
> > 
> > Since some drivers (like caam) only enqueue request without "doing"
> > them, do_one_request() is now optional.
> > 
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >   crypto/crypto_engine.c  | 25 ++++++++++++++++++++++---
> >   include/crypto/engine.h | 14 ++++++++------
> >   2 files changed, 30 insertions(+), 9 deletions(-)
> > 
> > diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> > index 5bcb1e740fd9..4a28548c49aa 100644
> > --- a/crypto/crypto_engine.c
> > +++ b/crypto/crypto_engine.c
> > @@ -83,6 +83,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
> >   		goto out;
> >   	}
> >   
> > +retry:
> >   	/* Get the fist request from the engine queue to handle */
> >   	backlog = crypto_get_backlog(&engine->queue);
> >   	async_req = crypto_dequeue_request(&engine->queue);
> > @@ -118,10 +119,28 @@ static void crypto_pump_requests(struct crypto_engine *engine,
> >   			goto req_err2;
> >   		}
> >   	}
> > +
> > +	if (enginectx->op.enqueue_request) {
> > +		ret = enginectx->op.enqueue_request(engine, async_req);
> > +		if (ret) {
> > +			dev_err(engine->dev, "failed to enqueue request: %d\n",
> > +				ret);
> > +			goto req_err;
> > +		}
> > +	}
> > +	if (enginectx->op.can_queue_more && engine->queue.qlen > 0) {
> > +		ret = enginectx->op.can_queue_more(engine, async_req);
> > +		if (ret > 0) {
> > +			spin_lock_irqsave(&engine->queue_lock, flags);
> > +			goto retry;
> > +		}
> > +		if (ret < 0) {
> > +			dev_err(engine->dev, "failed to call can_queue_more\n");
> > +			/* TODO */
> > +		}
> > +	}
> >   	if (!enginectx->op.do_one_request) {
> > -		dev_err(engine->dev, "failed to do request\n");
> > -		ret = -EINVAL;
> > -		goto req_err;
> > +		return;
> >   	}
> >   	ret = enginectx->op.do_one_request(engine, async_req);
> >   	if (ret) {
> > diff --git a/include/crypto/engine.h b/include/crypto/engine.h
> > index 03d9f9ec1cea..8ab9d26e30fe 100644
> > --- a/include/crypto/engine.h
> > +++ b/include/crypto/engine.h
> > @@ -63,14 +63,16 @@ struct crypto_engine {
> >    * @prepare__request: do some prepare if need before handle the current request
> >    * @unprepare_request: undo any work done by prepare_request()
> >    * @do_one_request: do encryption for current request
> > + * @enqueue_request:	Enqueue the request in the hardware
> > + * @can_queue_more:	if this function return > 0, it will tell the crypto
> > + * 	engine that more space are availlable for prepare/enqueue request
> >    */
> >   struct crypto_engine_op {
> > -	int (*prepare_request)(struct crypto_engine *engine,
> > -			       void *areq);
> > -	int (*unprepare_request)(struct crypto_engine *engine,
> > -				 void *areq);
> > -	int (*do_one_request)(struct crypto_engine *engine,
> > -			      void *areq);
> > +	int (*prepare_request)(struct crypto_engine *engine, void *areq);
> > +	int (*unprepare_request)(struct crypto_engine *engine, void *areq);
> > +	int (*do_one_request)(struct crypto_engine *engine, void *areq);
> > +	int (*enqueue_request)(struct crypto_engine *engine, void *areq);
> > +	int (*can_queue_more)(struct crypto_engine *engine, void *areq);
> >   };
> 
> As I mentioned in another thread [1], these crypto-engine patches (#1 - 
> #5) imply modifications in all the drivers that use crypto-engine.
> It's not backwards compatible.

This is wrong. This is false.
AS I HAVE ALREADY SAID, I have tested and didnt see any behavour change in the current user of crypto engine.
I have tested my serie with omap, virtio, amlogic, sun8i-ss, sun8i-ce and didnt see any change in behavour WITHOUT CHANGING them.
I resaid, I didnt touch omap, virtio, etc...
Only stm32 is not tested because simply there are not board with this driver enabled.

I have also tested your serie which adds support for crypto engine to caam, and the crash is the same with/without my serie.
So no behavour change.

> Your changes imply that do_one_request executes the request & waits for 
> completion and enqueue_request sends it to hardware. That means that all 
> the other drivers need to be modify, to implement enqueue_request, 
> instead of do_one_request. They need to be compliant with the new 
> changes, new API. Otherwise, they are not using crypto-engine right, 
> don't you think?
> 

My change imply nothing, current user work the same.
But if they want, they COULD switch to enqueue_request().

> Also, do_one_request it shouldn’t be blocking. We got this confirmation 
> from Herbert [2].

Re-read what Herbert said, "It certainly shouldn't be blocking in the general case." But that means it could.
But this wont change my patch since both behavour are supported.

> 
> [1] 
> https://lore.kernel.org/lkml/VI1PR04MB44455343230CBA7400D21C998C0C0@VI1PR04MB4445.eurprd04.prod.outlook.com/
> [2] 
> https://lore.kernel.org/lkml/20200122144134.axqpwx65j7xysyy3@gondor.apana.org.au/
