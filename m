Return-Path: <SRS0=EdI7=3L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C93C2D0DB
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 13:30:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7038205F4
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Jan 2020 13:30:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EoYfJOtq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729760AbgAVNWL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Jan 2020 08:22:11 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36964 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730421AbgAVNWK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Jan 2020 08:22:10 -0500
Received: by mail-wm1-f68.google.com with SMTP id f129so7187367wmf.2;
        Wed, 22 Jan 2020 05:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2G0pgtzq+Lyj/tGzjq3LHj1TlXfbz2J/exRt4E8NcoI=;
        b=EoYfJOtqT1cvIhcZu50Re8efHWPTlV/mhYqH62yB30rVbD/9qaJkE0niw6a6eXi+WY
         3IUShAgPgHoYjqVrhPdq9aIkmi9rM2b7zb0t+okoEbq8Ofga8Py+EqiPrq3HjVLcvBrE
         d4G1X7/1gxDg7Yt4XRkTMA3ZBz3kO9SSKZpEklU4Xx+GgJC7ipX2Lj/zLa8lD8QAKKDn
         n+GYq6am7vFMXY5V/TtdVqs0gEUEDrLkuqQKX8g5GfnF/Ama+nOexiVSOcF9y+/y3H7T
         Sb/JkEOBDSvL6IPjiYmp8Qalqfut7DXs5pI7sxdUR0IPMojUKnunCIWJuISh4dYXvQ9t
         Z8pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2G0pgtzq+Lyj/tGzjq3LHj1TlXfbz2J/exRt4E8NcoI=;
        b=FpWWjoncfwaAdee3uygC7YKeCPtRYbOdYcnGtd2zBcp+eAe3ZG0VlfARDTXZcPZ7Qm
         LlD+GU/mRk//KV4lbVz425bRaUCB9lXWZq0+uvCGZEtRtBqCNFRHxp00MkKEjfcUUR5Y
         78LYt1tHc7QCHItUZfoYrnXnIwXDibKBVtkcyKhmV8hv7M/7KMSIvfdzfLsigNgbvPcy
         gRjKrJN2aewkfHmVefEcUZ7PsK23eUIr2L0foTVzHyqzoAYdF6qKQ9Cx7JpZAnJwvwvs
         SfnP4VLWphC3Ejc8+Pm43Kr3oiW0FJJXcyZ32OKXERVAn1o12cI1uerbmVe2bIx03VbC
         EJMQ==
X-Gm-Message-State: APjAAAWrpryWEIkyFqlCcxFIhPuO/Z5YFvfvshltmCSHRqKUnc1Osous
        X5SIVAImEEZ5XIm3hf4sA6k=
X-Google-Smtp-Source: APXvYqwVmd49homZNLcif21Pl96KhzwdqnbIZPWV5d5YJZmk2GbwM4qbHiOnm046xvUkIk46vO3NJg==
X-Received: by 2002:a05:600c:1003:: with SMTP id c3mr3019534wmc.120.1579699328068;
        Wed, 22 Jan 2020 05:22:08 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id p18sm4071624wmb.8.2020.01.22.05.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 05:22:06 -0800 (PST)
Date:   Wed, 22 Jan 2020 14:22:04 +0100
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
Message-ID: <20200122132204.GB13173@Red>
References: <1579563149-3678-1-git-send-email-iuliana.prodan@nxp.com>
 <20200121100053.GA14095@Red>
 <VI1PR04MB44454A0468073981FDA603B38C0D0@VI1PR04MB4445.eurprd04.prod.outlook.com>
 <20200122104134.GA13173@Red>
 <VI1PR04MB44455343230CBA7400D21C998C0C0@VI1PR04MB4445.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB44455343230CBA7400D21C998C0C0@VI1PR04MB4445.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 22, 2020 at 12:29:22PM +0000, Iuliana Prodan wrote:
> On 1/22/2020 12:41 PM, Corentin Labbe wrote:
> > On Tue, Jan 21, 2020 at 02:20:27PM +0000, Iuliana Prodan wrote:
> >> On 1/21/2020 12:00 PM, Corentin Labbe wrote:
> >>> On Tue, Jan 21, 2020 at 01:32:29AM +0200, Iuliana Prodan wrote:
> >>>> Added support for executing multiple requests, in parallel,
> >>>> for crypto engine.
> >>>> A no_reqs is initialized and set in the new
> >>>> crypto_engine_alloc_init_and_set function.
> >>>> 
> >>>>
> >>>
> >>> Hello
> >>>
> >>> In your model, who is running finalize_request() ?
> >> finalize_request() in CAAM, and in other drivers, is called on the _done
> >> callback (stm32, virtio and omap).
> >>
> >>> In caam it seems that you have a taskqueue dedicated for that but you cannot assume that all drivers will have this.
> >>> I think the crypto_engine should be sufficient by itself and does not need external thread/taskqueue.
> >>>
> >>> But in your case, it seems that you dont have the choice, since do_one_request does not "do" but simply enqueue the request in the "jobring".
> >>>
> >> But, do_one_request it shouldn't, necessary,  execute the request. Is ok
> >> to enqueue it, since we have asynchronous requests. do_one_request is
> >> not blocking.
> >>
> >>> What about adding along prepare/do_one_request/unprepare a new enqueue()/can_do_more() function ?
> >>>
> >>> The stream will be:
> >>> retry:
> >>> optionnal prepare
> >>> optionnal enqueue
> >>> optionnal can_do_more() (goto retry)
> >>> optionnal do_one_request
> >>>
> >>> then
> >>> finalize()
> >>> optionnal unprepare
> >>>
> >>
> >> I'm planning to improve crypto-engine incrementally, so I'm taking one
> >> step at a time :)
> >> But I'm not sure if adding an enqueue operation is a good idea, since,
> >> my understanding, is that do_one_request is a non-blocking operation and
> >> it shouldn't execute the request.
> > 
> > do_one_request is a blocking operation on amlogic/sun8i-ce/sun8i-ss and the "documentation" is clear "@do_one_request: do encryption for current request".
> > But I agree that is a bit small for a documentation.
> > 
> 
> Herbert, Baolin,
> 
> What do you think about do_one_requet operation: is blocking or not?
> 
> There are several drivers (stm32, omap, virtio, caam) that include 
> crypto-engine, and uses do_one_request as non-blocking, only the ones 
> mentioned and implemented by Corentin use do_one_request as blocking.
> 
> >>
> >> IMO, the crypto-engine flow should be kept simple:
> >> 1. a request comes to hw -> this is doing transfer_request_to_engine;
> >> 2. CE enqueue the requests
> >> 3. on pump_requests:
> >> 	3. a) optional prepare operation
> >> 	3. b) sends the reqs to hw, by do_one_request operation. To wait for
> >> completion here it contradicts the asynchronous crypto API.
> > 
> > There are no contradiction, the call is asynchronous for the user of the API.
> > 
> >> do_one_request operation has a crypto_async_request type as argument.
> >> Note: Step 3. b) can be done several times, depending on size of hw queue.
> >> 4. in driver, when req is done:
> >> 	4. a) optional unprepare operation
> >> 	4. b) crypto_finalize_request is called
> >> 	
> > 
> > Since Herbert say the same thing than me:
> > "Instead, we should just let the driver tell us when it is ready to accept more requests."
> > Let me insist on my proposal, I have updated my serie, and it should handle your case and mine.
> > I will send it within minutes.
> > 
> 
> Corentin,
> 
> In your new proposal, a few patches include my modifications. The others 
> include a solution that fits your drivers very well, but implies 
> modifications in all the other 4 drivers. It's not backwards compatible.
> I believe it can be done better, so we won't need to modify, _at all_, 
> the other drivers.

Others driver should work the same, I dont see what changes they need.
As I said, I tested caam with my changes, it works the same.
Please show me what changes they need to continue to work and proof that they are broken with my changes.

> 
> I'm working on a new version for my RFC, that has the can_enqueue_more, 
> as Herbert suggested, but I would really want to know how 
> crypto-engine's do_one_request was thought: blocking or non-blocking?

We know that both way works, so this is not really a problem.
