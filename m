Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84BB8C33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 13:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 575E8206D5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 13:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y1tnjYY9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgAPNVN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 08:21:13 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43868 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgAPNVN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 08:21:13 -0500
Received: by mail-wr1-f65.google.com with SMTP id d16so19128178wre.10;
        Thu, 16 Jan 2020 05:21:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tbAt5pOcctelyMI0Pw/2Boj48DssPhA/WaoryvyZ5m0=;
        b=Y1tnjYY9zApO2OQtTlDt04IWqpItEAIZ5N7I1UyRyrMF0VujSdOWoWeW23YpRJREit
         Ye7auccjOUK5vicYqb5Kybo0WeIT3zvCnpw2YhunRBvypG34tKCGQO+Am7f7xzTZmKzG
         O/CU2sLyQOWI0vysFxCMbgNRbAFQK7aw6ke/dLrtXqmXBOxY7x1mSWOtn8uIb/A5+bcO
         VSayKSZztrGF42u+FDH0K6DMs3+GPpUFxslOKs//lWPYKSNF+Vc+xUua0Top/zxAdZhO
         rQEOPlOwktWilbCv0LX37iTT08dPftP+a5KI+ymcN1qZpKbzkkhaYj8DmKqhEKoWAlck
         x1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tbAt5pOcctelyMI0Pw/2Boj48DssPhA/WaoryvyZ5m0=;
        b=pI7/AQgLgWXKo7zwk+sgBhsFRHD72+22H3PuKWCQWv7S16nMCYnQLAbJLxRVNXcKm4
         GQjZVMMrLIWKkIzNP+th/P3b+ECcwU1JdTG+3FToOUQIldTJL+GhyJyW2CQ34V67RUw+
         j1PUWh3Drv6+lhgrxB8AZechvsADvIiJOMa6xs/WVDKFtCMN3NnNGcnmT4eJ8Nzpabt5
         jXMaQUfKHNlh/2MUAii016YX+2WG12vuvn7cBRhSzdJrHxyBOWntQx4duw/Q+T/c3iCw
         pCk4e7bedZ7LkCPa2Y2Dc2Tfr+ymvoe0xaVz5x5JDUyoKI2EP46c0sCT/gk6Yol4RvKI
         R/dg==
X-Gm-Message-State: APjAAAUfp66ZxPRWY+3ZHo8I2+gxbOQ4nj7toDlWakaPbtpGEYSTbqG7
        sxnL0V8MRgpesX9+4NEJiDQ=
X-Google-Smtp-Source: APXvYqw01+GqfkH35JYXyBsSnjwvr0X4uh+5I3kzup5rww9ZVJeL67W4XhmH/pce4L5zuqrTSc5t4g==
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr3415042wrx.109.1579180870884;
        Thu, 16 Jan 2020 05:21:10 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id o15sm29681752wra.83.2020.01.16.05.21.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 05:21:09 -0800 (PST)
Date:   Thu, 16 Jan 2020 14:21:07 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "mripard@kernel.org" <mripard@kernel.org>,
        "wens@csie.org" <wens@csie.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>
Subject: Re: [PATCH RFC 06/10] crypto: engine: introduce ct
Message-ID: <20200116132107.GB26487@Red>
References: <20200114135936.32422-1-clabbe.montjoie@gmail.com>
 <20200114135936.32422-7-clabbe.montjoie@gmail.com>
 <VI1PR04MB44455F7F7830159B6ED336648C360@VI1PR04MB4445.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB44455F7F7830159B6ED336648C360@VI1PR04MB4445.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 16, 2020 at 11:34:19AM +0000, Iuliana Prodan wrote:
> On 1/14/2020 4:00 PM, Corentin Labbe wrote:
> > We will store the number of request in a batch in engine->ct.
> > This patch adds all loop to unprepare all requests of a batch.
> > 
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >   crypto/crypto_engine.c  | 30 ++++++++++++++++++------------
> >   include/crypto/engine.h |  2 ++
> >   2 files changed, 20 insertions(+), 12 deletions(-)
> > 
> > diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> > index b72873550587..591dea5ddeec 100644
> > --- a/crypto/crypto_engine.c
> > +++ b/crypto/crypto_engine.c
> > @@ -28,6 +28,7 @@ static void crypto_finalize_request(struct crypto_engine *engine,
> >   	bool finalize_cur_req = false;
> >   	int ret;
> >   	struct crypto_engine_ctx *enginectx;
> > +	int i = 0;
> >   
> >   	spin_lock_irqsave(&engine->queue_lock, flags);
> >   	if (engine->cur_reqs[0].req == req)
> You're checking here just the first request, but do the completion for 
> all? Why? Shouldn't we check for each request if it was done by hw or not?

The first request is a sort of key for the whole batch.
> 
> I've also seen that the do_one_request is called only on the first 
> request, from the batch.

Since the request are linked, this is not a problem.
But I miss this explanaition in the code.

> 
> In your driver you do the prepare/unprepare for the whole batch at once, 
> but not all drivers, who uses crypto-engine, are doing this (see virtio, 
> amlogic, stm32). And I don't know if they can...

prepare is optionnal, and unprepare is optional even if prepare is done.
Furthermore, doing prepare/unprepare is optional per request.
I have tested this serie on sun8i-ss and amlogic which dont use prepare/unprepare.

