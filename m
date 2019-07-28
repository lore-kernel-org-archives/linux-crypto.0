Return-Path: <SRS0=rw2L=VZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C19C7618F
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jul 2019 20:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6622A2070D
	for <linux-crypto@archiver.kernel.org>; Sun, 28 Jul 2019 20:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfG1Uuj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 28 Jul 2019 16:50:39 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:49728 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfG1Uui (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Jul 2019 16:50:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 1A5206063691;
        Sun, 28 Jul 2019 22:50:36 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id kXJ_7xXHcsr5; Sun, 28 Jul 2019 22:50:35 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id C6C54608F452;
        Sun, 28 Jul 2019 22:50:35 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Pl5qRPmIRfAF; Sun, 28 Jul 2019 22:50:35 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 9A2CA6063691;
        Sun, 28 Jul 2019 22:50:35 +0200 (CEST)
Date:   Sun, 28 Jul 2019 22:50:35 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     horia geanta <horia.geanta@nxp.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        david <david@sigma-star.at>, Baolin Wang <baolin.wang@linaro.org>
Message-ID: <1174635359.52770.1564347035533.JavaMail.zimbra@nod.at>
In-Reply-To: <VI1PR0402MB3485A27D2D9643F70E1873A398C10@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <839258138.49105.1564003328543.JavaMail.zimbra@nod.at> <VI1PR0402MB3485A27D2D9643F70E1873A398C10@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Subject: Re: Backlog support for CAAM?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF60 (Linux)/8.8.12_GA_3809)
Thread-Topic: Backlog support for CAAM?
Thread-Index: ARBzCkuiRpn89WxIsrxtpCssT2oQQsW0dt3g
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

----- Ursprüngliche Mail -----
> Right now we're evaluating two options:
> -reworking v5 above
> -using crypto engine (crypto/crypto_engine.c)
> 
> Ideally crypto engine should be the way to go.
> However we need to make sure performance degradation is negligible,
> which unfortunately is not case.
> 
> Currently it seems that crypto engine has an issue with sending
> multiple crypto requests from (SW) engine queue -> (HW) caam queue.
> 
> More exactly, crypto_pump_requests() performs this check:
>        /* Make sure we are not already running a request */
>        if (engine->cur_req)
>                goto out;
> 
> thus it's not possible to add more crypto requests to the caam queue
> until HW finishes the work on the current crypto request and
> calls crypto_finalize_request():
>        if (finalize_cur_req) {
>		[...]
>                engine->cur_req = NULL;

Did you consider using a hybrid approach?

Please let me sketch my idea:

- Let's have a worker thread which serves a software queue.
- The software queue is a linked list of requests.
- Upon job submission the driver checks whether the software queue is empty.
- If the software queue is empty the regular submission continues.
- Is the hardware queue full at this point, the request is put on the software
  queue and we return EBUSY.
- If upon job submission the software queue not empty, the new job is also put
  on the software queue.
- The worker thread is woken up every time a new job is put on the software
  queue and every time CAAM processed a job.

That way we can keep the fast path fast. If hardware queue not full, software queue
can be bypassed completely.
If the software queue is used once it will become empty as soon jobs are getting
submitted at a slower rate and the fast path will be used again.

What do you think?

Thanks,
//richard
