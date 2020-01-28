Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85D77C2D0DB
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 16:55:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55052214AF
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 16:55:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RT/MqUsr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgA1Qzj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 11:55:39 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33200 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgA1Qzj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 11:55:39 -0500
Received: by mail-wm1-f65.google.com with SMTP id m10so2213801wmc.0;
        Tue, 28 Jan 2020 08:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WCgG7MXtK+EadBs68VzLrnD51numFaQTp+Nf00N2Sac=;
        b=RT/MqUsrLMJMTlJLSdTpe5SrIjHzDcNYhB65LuMHGbpgW5xF3y/8DJJMuX45zauCMJ
         bM4sR7Worug+qMce3gtMcCYUWgxbClKOQNWiQPAQD8SgC1ivfBPxlAs2B++TNobJj0/m
         gI94unUUlyNwlsqDUGu6BNMo9IJKNtNnVzlqk/tSVzd51Z8Zy+8+tL0ogx4j62PoOAuB
         DJ25cWKO28c0OySBXqWSrlR/FqnbTh9ZLgGEsT5y4cZ3ovoBblD0M7+F47Sw9IjyL0FU
         o1vQr3BqT8TFEHapR1Qrsd4sU/TAI0wzV/dD5XbgUsxGoAwV94g2ovrA78elVdZmGQvZ
         rmVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WCgG7MXtK+EadBs68VzLrnD51numFaQTp+Nf00N2Sac=;
        b=Y5h0bX/I8EyeYRpOeLBlevGTAhtRGlUqCMUDxdi6lD0UgjvKalKCqQbw8DJdPebqTP
         T1sYuZEIg9qisYsDRgvncmI5nqK/Zh2Lz/N5qMqB51mjav8RGKguN+xFU132AdhOzC3h
         +6qL1fAz/hyFNkFVnUVM2AdUggKElDcJsCR2pmtuqqtP/9nbzU8VZh41ly2Wdia85dSe
         TtOaEcE/1rYnC8+0oCWtMfmsdPi2fF156TcL3GHPcJC3YgKSCa85rn2kdc4fnlUIxcbo
         LQH7O3MGJXEbYgf8uPtPLzjiFgJmyUOyeNyY+YpBAxHzzSOGOaQXEfEa7dYJSCUqoGbQ
         ewCA==
X-Gm-Message-State: APjAAAUsrn/ptR8SF670icfTiVJDUIlSlwO7gHYrnuBVQ4HtRXR0SvpY
        PwvWsLzZKJX9c6Y/FKyO6wE=
X-Google-Smtp-Source: APXvYqxOIb8IvrpKKK65gJyI7ywFbGmllhSO+jZl55f0JV88LAgtEGsIIYILGXAMELx+9KCRr/8Ysw==
X-Received: by 2002:a05:600c:2c08:: with SMTP id q8mr6221103wmg.45.1580230537494;
        Tue, 28 Jan 2020 08:55:37 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id 16sm3745279wmi.0.2020.01.28.08.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 08:55:36 -0800 (PST)
Date:   Tue, 28 Jan 2020 17:55:34 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "wens@csie.org" <wens@csie.org>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] crypto: engine: workqueue can only be processed one
 by one
Message-ID: <20200128165534.GA11610@Red>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
 <20200122104528.30084-2-clabbe.montjoie@gmail.com>
 <VI1PR0402MB3485B787EA6BCDD5A5600BAA980A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20200128155800.GB17295@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128155800.GB17295@Red>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 28, 2020 at 04:58:00PM +0100, Corentin Labbe wrote:
> On Tue, Jan 28, 2020 at 03:50:14PM +0000, Horia Geanta wrote:
> > On 1/22/2020 12:46 PM, Corentin Labbe wrote:
> > > Some bykeshedding are unnecessary since a workqueue can only be executed
> > > one by one.
> > > This behaviour is documented in:
> > > - kernel/kthread.c: comment of kthread_worker_fn()
> > > - Documentation/core-api/workqueue.rst: the functions associated with the work items one after the other
> > [...]
> > > @@ -73,16 +73,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
> > >  
> > >  	spin_lock_irqsave(&engine->queue_lock, flags);
> > >  
> > > -	/* Make sure we are not already running a request */
> > > -	if (engine->cur_req)
> > > -		goto out;
> > > -
> > This check is here for a good reason, namely because crypto engine
> > cannot currently handle multiple crypto requests being in "flight"
> > in parallel.
> > 
> > More exactly, if this check is removed the following sequence could occur:
> > crypto_pump_work() -> crypto_pump_requests() -> .do_one_request(areq1)
> > crypto_pump_work() -> crypto_pump_requests() -> .do_one_request(areq2)
> > crypto_finalize_request(areq1)
> > crypto_finalize_request(areq2)
> > 
> 
> As explained in the commitlog, crypto_pump_work() cannot be ran twice.
> 

Sorry, I have misunderstood and wrongly answered.

Right since some driver does not block on do_one_request(), crypto_pump_work() can be ran one after one and so launch two request.

So this patch is bad.

Regards
