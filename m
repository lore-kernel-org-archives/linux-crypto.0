Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361D7C6379D
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 21:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3080461186
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Jul 2021 21:20:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387814AbhGSUfS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Jul 2021 16:35:18 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:33110 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387517AbhGSUNU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jul 2021 16:13:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id B89FE6169BB9;
        Mon, 19 Jul 2021 22:53:29 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id M9g_BfeqRwmD; Mon, 19 Jul 2021 22:53:29 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 5CFC9608F457;
        Mon, 19 Jul 2021 22:53:29 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bzC4bar1qBEa; Mon, 19 Jul 2021 22:53:29 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 31BFF6169BB9;
        Mon, 19 Jul 2021 22:53:29 +0200 (CEST)
Date:   Mon, 19 Jul 2021 22:53:28 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        davem <davem@davemloft.net>, horia geanta <horia.geanta@nxp.com>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Marek Vasut <marex@denx.de>, david <david@sigma-star.at>
Message-ID: <979259086.46878.1626728008847.JavaMail.zimbra@nod.at>
In-Reply-To: <2628c3a9-a337-ccee-b996-803fdfe9e1fd@seco.com>
References: <20210701185638.3437487-1-sean.anderson@seco.com> <723802567.13207.1625167719840.JavaMail.zimbra@nod.at> <dbeafb2a-e631-ad51-05b3-a775225140d6@seco.com> <2628c3a9-a337-ccee-b996-803fdfe9e1fd@seco.com>
Subject: Re: [PATCH v2 0/2] crypto: mxs_dcp: Fix an Oops on i.MX6ULL
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF90 (Linux)/8.8.12_GA_3809)
Thread-Topic: crypto: mxs_dcp: Fix an Oops on i.MX6ULL
Thread-Index: Hx63mEBJVVrE3nFBLOnyq/wnxKO8fg==
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

----- Ursprüngliche Mail -----
>>>> but got the same oops. Unfortunately, I don't have the time to
>>>> investigate this oops as well. I'd appreciate if anyone else using this
>>>> device could look into this and see if they encounter the same errors.
>>>>
>>>> [1] https://github.com/smuellerDD/libkcapi/blob/master/test/kcapi-dgst-test.sh
>>>
>>>  Can you please share your kernel .config? David or I can test on our test bed.
>>>  But will take a few days.
> 
> Were you able to reproduce these oopses?

Thanks for the reminder!
No, I was not able to reproduce.
Just tested again with Herbert's cryptodev-2.6.git repo.
I'll run the tests a few more times, maybe it just needs more time...

Thanks,
//richard
