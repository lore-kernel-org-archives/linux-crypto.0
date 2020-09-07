Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D17A1C433E2
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 07:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B4BE206D4
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 07:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgIGHSm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 03:18:42 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50756 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgIGHSk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 03:18:40 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kFBPs-00039V-PQ; Mon, 07 Sep 2020 17:18:17 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Sep 2020 17:18:16 +1000
Date:   Mon, 7 Sep 2020 17:18:16 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Joe Perches <joe@perches.com>,
        Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] Re: [PATCH v6 18/18] crypto: sun8i-ce: fix some
 style issue
Message-ID: <20200907071816.GA16048@gondor.apana.org.au>
References: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
 <1599217803-29755-19-git-send-email-clabbe@baylibre.com>
 <906c2ffb0ef6b2d87d6aecdf60b61833ea79e4fb.camel@perches.com>
 <20200907071617.GA11894@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200907071617.GA11894@Red>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 07, 2020 at 09:16:17AM +0200, Corentin Labbe wrote:
>
> Oh I saw the increase in checkpatch.pl but didnt saw that it was still 80 in coding-style.rst.
> Anyway as maintainer of this driver, I prefer unwrapped lines.
> 
> I let Herbert to choose to apply the serie without this last patch or not.

While lines beyond 80 characters are allowed, please don't send
patches that simply rewrite existing lines as longer ones.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
