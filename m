Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0BB4C6FD1F
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Mar 2023 09:15:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjCHJPa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Mar 2023 04:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbjCHJOv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2023 04:14:51 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5A698867;
        Wed,  8 Mar 2023 01:14:25 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pZpry-001cud-Az; Wed, 08 Mar 2023 17:13:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Mar 2023 17:13:58 +0800
Date:   Wed, 8 Mar 2023 17:13:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Subject: Re: [v5 PATCH 7/7] crypto: stm32 - Save and restore between each
 request
Message-ID: <ZAhR1h4D98bENgbO@gondor.apana.org.au>
References: <ZAVu/XHbL9IR5D3h@gondor.apana.org.au>
 <E1pZ2fs-000e27-4H@formenos.hmeau.com>
 <CACRpkdY8iN_ga0VuQ-z=8KUWaJ6=5rh2vZEwcp+oNgcBuPFk=g@mail.gmail.com>
 <ZAcNhtm/+mik1N2m@gondor.apana.org.au>
 <CACRpkdbcrCa9v82xVWtixWdDPvCu6E6Rkw-3Vg3APisdvYGwqQ@mail.gmail.com>
 <ZAf/rAbc3bMIwBcr@gondor.apana.org.au>
 <ZAgDku9htWcetafb@gondor.apana.org.au>
 <CACRpkdZ-zPZG4jK-AF2YF0wUFb8qrKBeoa4feb1qJ9SPusjv+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ-zPZG4jK-AF2YF0wUFb8qrKBeoa4feb1qJ9SPusjv+Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 08, 2023 at 10:05:14AM +0100, Linus Walleij wrote:
>
> So for Ux500 at least I suppose it would be best to inhibit .import and
> .export when using HMAC with long keys unless I can figure out exactly
> what the issue is here. I wonder if that is possible?
> Or do I have to remove it from the HMAC algos altogether?

If the hardware is buggered it's not a big deal if it's just HMAC.
Because any HMAC hash can easily be broken down into three underlying
hash operations.

But let me digest your new information first, and see if we can
figure out a way to get it to work.  If not then we could just disable
hmac (unless we can get confirmation from stm32 hardware we should
just disable it for everything in stm32) and I'll fix the generic
hmac to actually work with hardware drivers.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
