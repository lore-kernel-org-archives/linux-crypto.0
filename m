Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B269C43460
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 00:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64F1F6135D
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 00:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhESAwr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 20:52:47 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:47070 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233529AbhESAwh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 20:52:37 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1ljAQZ-0003Xg-8I; Wed, 19 May 2021 08:51:11 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ljAQV-0003j5-RH; Wed, 19 May 2021 08:51:07 +0800
Date:   Wed, 19 May 2021 08:51:07 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Corentin Labbe <clabbe@baylibre.com>, chohnstaedt@innominate.com,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] crypto: start to fix ixp4xx
Message-ID: <20210519005107.m44dknz4ih233pbc@gondor.apana.org.au>
References: <20210505202618.2663889-1-clabbe@baylibre.com>
 <CACRpkdbR9mt-X-Dt9uR9vGtg_EDJCk3H5Umuh2eUX-PGZ7VBfQ@mail.gmail.com>
 <20210518011930.nywtcgualmsrx35v@gondor.apana.org.au>
 <CACRpkdbi+1tVL04HQ5Uufpw3-ORp3W4Cs1AyHrjQwJ149T8MMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbi+1tVL04HQ5Uufpw3-ORp3W4Cs1AyHrjQwJ149T8MMQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 18, 2021 at 11:36:01PM +0200, Linus Walleij wrote:
>
> Sadly they do, it's these:
> https://lore.kernel.org/linux-crypto/20210510213634.600866-1-linus.walleij@linaro.org/
> https://lore.kernel.org/linux-crypto/20210510213634.600866-2-linus.walleij@linaro.org/
> https://lore.kernel.org/linux-crypto/20210510213634.600866-3-linus.walleij@linaro.org/
> 
> I guess we could turn it around: I see if I can apply these two
> on top of the crypto tree and resend then we hope there is no
> collision in the ARM SoC tree instead.
> 
> I need to respin the series anyway so shall we try this?

Yes I think those changes are probably best routed through crypto
as the code changes are quite extensive so the potential for non-
trivial conflicts is high.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
