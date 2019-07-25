Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F018DC7618B
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 08:12:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB1CF22BED
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 08:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389388AbfGYIMP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 04:12:15 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:59606 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389111AbfGYIMP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 04:12:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id BD9C26089339;
        Thu, 25 Jul 2019 10:12:12 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id RsQOETWTvbA6; Thu, 25 Jul 2019 10:12:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id AFA7C6089354;
        Thu, 25 Jul 2019 10:12:11 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OFrMpuoYOZ2A; Thu, 25 Jul 2019 10:12:11 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 814006089339;
        Thu, 25 Jul 2019 10:12:11 +0200 (CEST)
Date:   Thu, 25 Jul 2019 10:12:11 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     horia geanta <horia.geanta@nxp.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        david <david@sigma-star.at>, Baolin Wang <baolin.wang@linaro.org>
Message-ID: <471357890.49724.1564042331372.JavaMail.zimbra@nod.at>
In-Reply-To: <VI1PR0402MB3485A27D2D9643F70E1873A398C10@VI1PR0402MB3485.eurprd04.prod.outlook.com>
References: <839258138.49105.1564003328543.JavaMail.zimbra@nod.at> <VI1PR0402MB3485A27D2D9643F70E1873A398C10@VI1PR0402MB3485.eurprd04.prod.outlook.com>
Subject: Re: Backlog support for CAAM?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF60 (Linux)/8.8.12_GA_3809)
Thread-Topic: Backlog support for CAAM?
Thread-Index: ARBzCkuiRpn89WxIsrxtpCssT2oQQvbJgxkU
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "horia geanta" <horia.geanta@nxp.com>
> An: "richard" <richard@nod.at>, "Linux Crypto Mailing List" <linux-crypto@vger.kernel.org>, "linux-kernel"
> <linux-kernel@vger.kernel.org>
> CC: "aymen sghaier" <aymen.sghaier@nxp.com>, "david" <david@sigma-star.at>, "Baolin Wang" <baolin.wang@linaro.org>
> Gesendet: Donnerstag, 25. Juli 2019 07:57:28
> Betreff: Re: Backlog support for CAAM?

> On 7/25/2019 12:22 AM, Richard Weinberger wrote:
>> Hi!
>> 
>> Recently I had the pleasure to debug a lockup on a imx6 based platform.
>> It turned out that the lockup was caused by the CAAM driver because it
>> just returns -EBUSY upon a full job ring.
>> 
>> Then I found commits:
>> 0618764cb25f ("dm crypt: fix deadlock when async crypto algorithm returns
>> -EBUSY")
>> c0403ec0bb5a ("Revert "dm crypt: fix deadlock when async crypto algorithm
>> returns -EBUSY"")
>> 
> Truly sorry for the inconvenience.

No need to worry. Nobody got hurt. :-)

> Indeed this is a caam driver issue, and not a dm-crypt one.
> 
>> Is there a reason why the driver has still no proper backlog support?
>> 
> We've been rejected a few times or the implementation had performance issues:
> v1: https://patchwork.kernel.org/patch/7144701
> v2: https://patchwork.kernel.org/patch/7199241
> v3: https://patchwork.kernel.org/patch/7221941
> v4: https://patchwork.kernel.org/patch/7230241
> v5: https://patchwork.kernel.org/patch/9033121
> 
> and we haven't been persistent enough.
> 
>> If it is just a matter of -ENOPATCH, I have some cycles left an can help.
>> But before working on this topic I'd like to figure what the current state
>> or plans are. :-)
>> 
> Right now we're evaluating two options:
> -reworking v5 above
> -using crypto engine (crypto/crypto_engine.c)

I'll look into that to get a better understanding.

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

Let me also dig into this.
Thanks for all the pointers!

Thanks,
//richard
