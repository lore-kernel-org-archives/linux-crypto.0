Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C4E7C678D5
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Mar 2023 10:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjCHKKi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Mar 2023 05:10:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjCHKKh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2023 05:10:37 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B457B111;
        Wed,  8 Mar 2023 02:10:33 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pZqkQ-001dzg-Jk; Wed, 08 Mar 2023 18:10:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 08 Mar 2023 18:10:14 +0800
Date:   Wed, 8 Mar 2023 18:10:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Subject: Re: [v5 PATCH 7/7] crypto: stm32 - Save and restore between each
 request
Message-ID: <ZAhfBmlNHUpGEwW3@gondor.apana.org.au>
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
> [    4.812106] stm32-hash a03c2000.hash: allocated hmac(sha256) fallback
> [    5.008829] stm32-hash a03c2000.hash: timeout before writing key in
> stm32_hash_xmit_cpu()
> [    5.017167] alg: ahash: stm32-hmac-sha256 final() failed with err
> -110 on test vector "random: psize=0 ksize=70", cfg="random: may_sleep
> use_final src_divs=[<fl"

Wait a second, this is an empty message.  Can you reproduce the
hang if you exclude all psize=0 test vectors?

If it's just empty messages, which we know are broken with ux500
to begin with, then we can simply not do the hash at all (doing
it and then throwing it away seems pointless).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
