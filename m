Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BD1FC43461
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 21:58:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E4522064B
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 21:58:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgIOV56 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 15 Sep 2020 17:57:58 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:47330 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbgIOV5q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 15 Sep 2020 17:57:46 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2020 17:57:42 EDT
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 37A1D6074029;
        Tue, 15 Sep 2020 23:50:54 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id FJeDlkGzqKO8; Tue, 15 Sep 2020 23:50:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id C0322607403C;
        Tue, 15 Sep 2020 23:50:53 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 173xIe-uMIop; Tue, 15 Sep 2020 23:50:53 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 93E5F6074029;
        Tue, 15 Sep 2020 23:50:53 +0200 (CEST)
Date:   Tue, 15 Sep 2020 23:50:53 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     horia geanta <horia.geanta@nxp.com>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        aymen sghaier <aymen.sghaier@nxp.com>,
        davem <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>, david <david@sigma-star.at>
Message-ID: <881550786.93213.1600206653402.JavaMail.zimbra@nod.at>
In-Reply-To: <ffc5254a-cecb-20b8-fca3-d2cd8486362d@nxp.com>
References: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com> <1594591536-531-3-git-send-email-iuliana.prodan@nxp.com> <CAFLxGvy0T-E-YecWbGZsDVPajuYVc8L-Uf8UCST_61+t+nfhrA@mail.gmail.com> <CAFLxGvw4zvL0N5+wChKq3=_xLuuCYLKDOyKKnKFy3UiWMUwf-g@mail.gmail.com> <ffc5254a-cecb-20b8-fca3-d2cd8486362d@nxp.com>
Subject: Re: [PATCH 2/2] crypto: caam - support tagged keys for skcipher
 algorithms
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Topic: crypto: caam - support tagged keys for skcipher algorithms
Thread-Index: SwVP6sBZjOv2Q9WeUVK81sHWwzKQnQ==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "horia geanta" <horia.geanta@nxp.com>
>>> How to use it with cryptsetup?
>>> I'm asking because it is not clear to me why you are not implementing
>>> a new kernel key type (KEYS subsystem)
>>> to utilize tagged keys.
>>> Many tools already support the keyctl userspace interface (cryptsetup,
>>> fscrypt, ...).
>> 
>> *friendly ping*
>> 
> We didn't include the key management part in this series,
> just the crypto API support for algorithms with protected keys,
> to get early feedback.
> 
> Wrt. key management:
> The NXP vendor / downstream kernel (to be included in i.MX BSP Q3 release)
> will have support for protected keys generation.
> Besides this, a dedicated ioctl-based interface will allow userspace to
> generate and export these keys. After this, user can use standard keyctl
> to add a key (as user / logon type) in the keyring, such that it would be
> available to dm-crypt.
> 
> We know that adding new ioctls is frowned upon, so before trying to upstream
> the ioctl-based solution the plan is checking the feasibility of
> extending keyctl as David Howells suggested:
> https://lore.kernel.org/lkml/8060.1533226481@warthog.procyon.org.uk
> (Note the difference b/w adding new key type - which was rejected -
> and a key "subtype extension".)

We have also a keyctl based patch series which should go upstream.
Since we also added a new keytype, it got rejected so far.

Do you have git repo with the WIP patches available?
Not that we do the work twice. :-)
Our patch series also supports DCP beside of CAAM.

Thanks,
//richard
