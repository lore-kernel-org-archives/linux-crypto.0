Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CA8C64EC7
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Mar 2023 01:31:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCABbQ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Feb 2023 20:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbjCABbO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Feb 2023 20:31:14 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A7A22A23;
        Tue, 28 Feb 2023 17:31:11 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pXBIt-00Gi56-8m; Wed, 01 Mar 2023 09:30:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 01 Mar 2023 09:30:47 +0800
Date:   Wed, 1 Mar 2023 09:30:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Subject: Re: [v4 PATCH] crypto: stm32 - Save and restore between each request
Message-ID: <Y/6qx0DcaOL+cBy6@gondor.apana.org.au>
References: <Y/cy5wUtk10OahpO@gondor.apana.org.au>
 <CACRpkdYyB=-UnE1bmdVszSSB5ReECZ0fUoWJX6XtYbKHEe52tA@mail.gmail.com>
 <Y/c7iVW67Xhhdu8e@gondor.apana.org.au>
 <Y/hQdzsKMYgkIfMY@gondor.apana.org.au>
 <Y/yIbPBVCPx9K/0s@gondor.apana.org.au>
 <CACRpkdZC4z2Xng4=k94rmM=AFzNzTdXkvtkArMnK7afouz=7VA@mail.gmail.com>
 <Y/3FYZJeLE7DVPBf@gondor.apana.org.au>
 <Y/3IA4OjmUmjMgh1@gondor.apana.org.au>
 <Y/3N6zFOZeehJQ/p@gondor.apana.org.au>
 <CACRpkdZ3rCsOWqooNkPL6m7vZ2Z2Frh2sdxruKhrS0t3QHcSKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ3rCsOWqooNkPL6m7vZ2Z2Frh2sdxruKhrS0t3QHcSKw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 28, 2023 at 09:50:55PM +0100, Linus Walleij wrote:
> 
> OK I tested this, sadly the same results.
> 
> Notice though: the HMAC versions fail on test vector 0 and
> the non-MAC:ed fail on vector 1, so I guess that means test
> vector 0 works with those?

Hah, test vector 0 for sha256 is an empty message.  While test
vector 1 is the same as test vector 0 for hmac(sha256).

So I guess at least the fallback is still working :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
