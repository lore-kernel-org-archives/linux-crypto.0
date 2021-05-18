Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12FE2C433ED
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 01:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2345610CD
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 01:19:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240711AbhERBVF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 May 2021 21:21:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33594 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233019AbhERBVD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 May 2021 21:21:03 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lioOV-00047L-OL; Tue, 18 May 2021 09:19:35 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lioOQ-00022u-NR; Tue, 18 May 2021 09:19:30 +0800
Date:   Tue, 18 May 2021 09:19:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Corentin Labbe <clabbe@baylibre.com>, chohnstaedt@innominate.com,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] crypto: start to fix ixp4xx
Message-ID: <20210518011930.nywtcgualmsrx35v@gondor.apana.org.au>
References: <20210505202618.2663889-1-clabbe@baylibre.com>
 <CACRpkdbR9mt-X-Dt9uR9vGtg_EDJCk3H5Umuh2eUX-PGZ7VBfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbR9mt-X-Dt9uR9vGtg_EDJCk3H5Umuh2eUX-PGZ7VBfQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 18, 2021 at 01:53:56AM +0200, Linus Walleij wrote:
> On Wed, May 5, 2021 at 10:26 PM Corentin Labbe <clabbe@baylibre.com> wrote:
> 
> > Loading the ixp4xx crypto driver exhibits lots of error.
> > All algorithm fail selftests with different reasons.
> > This series start to fixes some of thoses problem.
> 
> Excellent! Thanks for taking over this Corentin!!
> FWIW:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> If I merge my 3 additional patches through ARM SoC
> will it work out or do I need to think about some clever
> merging strategy?

Well if your patches don't touch the drivers/crypto then there
shouldn't be any conflicts.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
