Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BC0C7EE30
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Feb 2023 08:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbjB1I6m (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Feb 2023 03:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjB1I6l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Feb 2023 03:58:41 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA357D9F;
        Tue, 28 Feb 2023 00:58:38 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pWvoP-00GLxf-4v; Tue, 28 Feb 2023 16:58:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Feb 2023 16:58:17 +0800
Date:   Tue, 28 Feb 2023 16:58:17 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Subject: Re: [v3 PATCH] crypto: stm32 - Save and restore between each request
Message-ID: <Y/3CKeJRLvJyK5xk@gondor.apana.org.au>
References: <Y/cBB+q0Ono9j2Jy@gondor.apana.org.au>
 <20230224231430.2948-1-kunyu@nfschina.com>
 <Y/cy5wUtk10OahpO@gondor.apana.org.au>
 <CACRpkdYyB=-UnE1bmdVszSSB5ReECZ0fUoWJX6XtYbKHEe52tA@mail.gmail.com>
 <Y/c7iVW67Xhhdu8e@gondor.apana.org.au>
 <Y/hQdzsKMYgkIfMY@gondor.apana.org.au>
 <Y/yIbPBVCPx9K/0s@gondor.apana.org.au>
 <CACRpkdZC4z2Xng4=k94rmM=AFzNzTdXkvtkArMnK7afouz=7VA@mail.gmail.com>
 <CACRpkdb3xVYspjHTZ+z8Xh0mgd+Ht3VCA_F6xon90gyK-bdPhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdb3xVYspjHTZ+z8Xh0mgd+Ht3VCA_F6xon90gyK-bdPhQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 27, 2023 at 10:28:36PM +0100, Linus Walleij wrote:
> I am confused by the use of the state flag HASH_FLAGS_INIT in this
> driver.

Sorry, I was simply reusing that bit because it isn't currently
used by rctx.

Its meaning with respect to hdev is unchanged.  It keeps track of
whether the hardware state has been initalised, either through
stm32_hash_write_ctrl or by import.

Its use with rctx is new (this bit was previously unused).  The
intended meaning is that the ahash_request has received a non-
zero update.

Could you enable DEBUG and see what the dev_dbg statements print
out?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
