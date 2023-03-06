Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C9FDC61DA4
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Mar 2023 04:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbjCFEhj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 5 Mar 2023 23:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCFEhj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Mar 2023 23:37:39 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBE65FF21;
        Sun,  5 Mar 2023 20:37:35 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pZ2b3-000dw7-Bm; Mon, 06 Mar 2023 12:37:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Mar 2023 12:37:13 +0800
Date:   Mon, 6 Mar 2023 12:37:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Subject: Re: [v5 PATCH 3/7] crypto: stm32 - Simplify finup
Message-ID: <ZAVt+c/1ZtCEVXAy@gondor.apana.org.au>
References: <ZAMQjOdi8GfqDUQI@gondor.apana.org.au>
 <E1pYOKH-000GYy-Rv@formenos.hmeau.com>
 <CACRpkdbVMkV1=hS38BUzhzccEH2HqUxSB44aan3e7ZcmNQ=m5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbVMkV1=hS38BUzhzccEH2HqUxSB44aan3e7ZcmNQ=m5w@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Mar 05, 2023 at 11:08:24PM +0100, Linus Walleij wrote:
>
> All tests sadly fail after this patch:
> 
> [    4.699857] stm32-hash a03c2000.hash: allocated hmac(sha256) fallback
> [    4.708231] alg: ahash: stm32-hmac-sha256 test failed (wrong
> result) on test vector 0, cfg="init+finup aligned buffer"

We're making progress.  This worked on init+update+final, but then
failed on init+finup.  So it is indeed the finup code that was
broken by my patch as I forgot to set the rctx fields to include
the new data.

I'll repost the series.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
