Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E62DC32771
	for <linux-crypto@archiver.kernel.org>; Sun, 18 Sep 2022 03:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiIRDRJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Sep 2022 23:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiIRDRC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Sep 2022 23:17:02 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B763B286F5;
        Sat, 17 Sep 2022 20:16:58 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oZknZ-005gkf-5Q; Sun, 18 Sep 2022 13:16:50 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sun, 18 Sep 2022 11:16:49 +0800
Date:   Sun, 18 Sep 2022 11:16:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>
Subject: Re: [PATCH v3 10/16] crypto: ux500/hash: Implement .export and
 .import
Message-ID: <YyaNoXLcMAaBrpTY@gondor.apana.org.au>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
 <20220816140049.102306-11-linus.walleij@linaro.org>
 <YwdBIfASgGMDONx4@gondor.apana.org.au>
 <CACRpkdaNBvXvoHHUYfkAGSH1c7w0nER6yOgL9pB7OaXZL6b6_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaNBvXvoHHUYfkAGSH1c7w0nER6yOgL9pB7OaXZL6b6_w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 13, 2022 at 09:14:55PM +0200, Linus Walleij wrote:
>
> I see the problem.
> 
> Do you think we could merge patches 1 thru 9 for this kernel
> cycle though to lower my patch stack? I can resend just those
> if you like.

I had a look through 1-9 but quite a few seem like they were part
of the import/export rework.  For example, I think patch 8 would
actually break multiple hash attempts in parallel.

Could you plesae go through them and repost the ones that make
sense on their own?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
