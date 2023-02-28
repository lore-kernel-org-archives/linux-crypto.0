Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10307C64EC7
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Feb 2023 09:23:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjB1JXl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Feb 2023 04:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjB1JXg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Feb 2023 04:23:36 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06736E8;
        Tue, 28 Feb 2023 01:23:34 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pWwCZ-00GMRI-T8; Tue, 28 Feb 2023 17:23:16 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Feb 2023 17:23:15 +0800
Date:   Tue, 28 Feb 2023 17:23:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Subject: Re: [v3 PATCH] crypto: stm32 - Save and restore between each request
Message-ID: <Y/3IA4OjmUmjMgh1@gondor.apana.org.au>
References: <Y/cBB+q0Ono9j2Jy@gondor.apana.org.au>
 <20230224231430.2948-1-kunyu@nfschina.com>
 <Y/cy5wUtk10OahpO@gondor.apana.org.au>
 <CACRpkdYyB=-UnE1bmdVszSSB5ReECZ0fUoWJX6XtYbKHEe52tA@mail.gmail.com>
 <Y/c7iVW67Xhhdu8e@gondor.apana.org.au>
 <Y/hQdzsKMYgkIfMY@gondor.apana.org.au>
 <Y/yIbPBVCPx9K/0s@gondor.apana.org.au>
 <CACRpkdZC4z2Xng4=k94rmM=AFzNzTdXkvtkArMnK7afouz=7VA@mail.gmail.com>
 <Y/3FYZJeLE7DVPBf@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/3FYZJeLE7DVPBf@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 28, 2023 at 05:12:01PM +0800, Herbert Xu wrote:
>
> What about the non-hmac algorithms? Do they pass or fail? If they
> fail what's the kernel dmesg?

I can see a problem with hmac.  The hmac key state wasn't stored
in the rctx so it gets repeatedly written to the hardware on each
operation, resulting in a bogus digest.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
