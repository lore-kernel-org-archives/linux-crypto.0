Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 613A4C2D0DB
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 15:58:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32AD924683
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 15:58:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q/wO+PfO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgA1P6F (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jan 2020 10:58:05 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41178 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgA1P6F (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jan 2020 10:58:05 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so16614300wrw.8;
        Tue, 28 Jan 2020 07:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FWPp9fyEDHyhawe1t49VObba7gl1SqL8FrQT/ryGVAI=;
        b=q/wO+PfO+FJAbmdRbe5TTat4LCNumuP61pWivJVRm4UlO1Pt0jyE78fSz472H6vaIp
         vZpw3Jd0LJoMKK725DxMrorGozM8U96NJjgdnd0eUGu3ljsSvzkYdA3Cn/+MqU3/sAm2
         NhPmiQ9I95+MPKFKtvtUTAoJBDSb5R8vgatIF/i/GVHV1+31qX8jfvOEWGcwX3tkqQxt
         LihRqy6Pa5vsqcpLbvDpfbjloAxEPKem41hE3tGf3+zb8NghFfBRz0+s2EHga/CfqVDO
         E1QishhiZp9Cn34ts67GZES4qZ4ncyIIEspmxfvb34wyMvXAYn8hsghiUL8NHQ6Y5BDj
         X4Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FWPp9fyEDHyhawe1t49VObba7gl1SqL8FrQT/ryGVAI=;
        b=KQXMswxfyCSJJ7ZgyJsPdLVyOECOt+0XzGIr2R0Lu/BfIH9wnI3saNqBLEPWHIp01p
         JrhuHBT9av7n+SH+/KcjM+OJDupjew2+H8pLnAi6j35E9QOlFH4umDEfBWbC07ULvkSz
         AHDu96QZbRl6GYgW+BySL88g9M3J/OiIZqhDaiqs3shT9hqQ4ObGTAp9pvRgdxYKTP+Q
         Ob0iFDr2CAmVWIV2LemsS/4lzU5gNxninXwyieWbf4VdDMgR7hxkh2fAkUimT8fF6tk8
         uC8pxqYF3b8iI2wbaAouduQRBVlZ2MAeaGi7lfxKB1979pLq8Jf39AR7kAZSwlbs6i/g
         aKMQ==
X-Gm-Message-State: APjAAAW3Kzt/Q54g+tgaj+F8b2BuDFqYbnC5d/7glzmIGg0YpIIh3Uac
        qbLymmAvZTkqddH3w5P0vjU=
X-Google-Smtp-Source: APXvYqzAo+vH+VwcOVJsIvK6o+ainqPBvzuhLyEHXWg4iWVQoesQZk1f9TDSxMN1ghStxMRWhTiHzQ==
X-Received: by 2002:a5d:6151:: with SMTP id y17mr28941387wrt.110.1580227083068;
        Tue, 28 Jan 2020 07:58:03 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id i8sm26328713wro.47.2020.01.28.07.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 07:58:02 -0800 (PST)
Date:   Tue, 28 Jan 2020 16:58:00 +0100
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
Message-ID: <20200128155800.GB17295@Red>
References: <20200122104528.30084-1-clabbe.montjoie@gmail.com>
 <20200122104528.30084-2-clabbe.montjoie@gmail.com>
 <VI1PR0402MB3485B787EA6BCDD5A5600BAA980A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3485B787EA6BCDD5A5600BAA980A0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 28, 2020 at 03:50:14PM +0000, Horia Geanta wrote:
> On 1/22/2020 12:46 PM, Corentin Labbe wrote:
> > Some bykeshedding are unnecessary since a workqueue can only be executed
> > one by one.
> > This behaviour is documented in:
> > - kernel/kthread.c: comment of kthread_worker_fn()
> > - Documentation/core-api/workqueue.rst: the functions associated with the work items one after the other
> [...]
> > @@ -73,16 +73,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
> >  
> >  	spin_lock_irqsave(&engine->queue_lock, flags);
> >  
> > -	/* Make sure we are not already running a request */
> > -	if (engine->cur_req)
> > -		goto out;
> > -
> This check is here for a good reason, namely because crypto engine
> cannot currently handle multiple crypto requests being in "flight"
> in parallel.
> 
> More exactly, if this check is removed the following sequence could occur:
> crypto_pump_work() -> crypto_pump_requests() -> .do_one_request(areq1)
> crypto_pump_work() -> crypto_pump_requests() -> .do_one_request(areq2)
> crypto_finalize_request(areq1)
> crypto_finalize_request(areq2)
> 

As explained in the commitlog, crypto_pump_work() cannot be ran twice.

Regards
