Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8C9FE8FDC3
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Oct 2023 01:19:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239495AbjJDBTN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Oct 2023 21:19:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239507AbjJDBTM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2023 21:19:12 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFC1D8
        for <linux-crypto@vger.kernel.org>; Tue,  3 Oct 2023 18:19:07 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qnqX8-003JDo-78; Wed, 04 Oct 2023 09:18:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Oct 2023 09:18:42 +0800
Date:   Wed, 4 Oct 2023 09:18:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     Stefan Wahren <wahrenst@gmx.net>,
        Olivia Mackall <olivia@selenic.com>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH V2] hwrng: bcm2835: Fix hwrng throughput regression
Message-ID: <ZRy9cvCZMdo0QbIz@gondor.apana.org.au>
References: <20230905232757.36459-1-wahrenst@gmx.net>
 <ZQQ1tgDEGGXwfu/4@gondor.apana.org.au>
 <436a7e20-082f-4aa9-bfbd-703d149d5463@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <436a7e20-082f-4aa9-bfbd-703d149d5463@leemhuis.info>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 03, 2023 at 01:35:29PM +0200, Linux regression tracking (Thorsten Leemhuis) wrote:
>
> Hi Herbert, I there a strong reason why you merged this to what from
> here looks like the branch that targets the next merge window? The patch
> fixes a regression introduced during the last 12 months and thus
> normally should not wait for the next merge window. For details see
> "Expectations and best practices for fixing regressions" in
> Documentation/process/handling-regressions.rst; or if you want to hear
> it from Linus directly, check these out:
> https://lore.kernel.org/all/CAHk-=wis_qQy4oDNynNKi5b7Qhosmxtoj1jxo5wmB6SRUwQUBQ@mail.gmail.com/
> https://lore.kernel.org/all/CAHk-=wgD98pmSK3ZyHk_d9kZ2bhgN6DuNZMAJaV0WTtbkf=RDw@mail.gmail.com/

This is a one-year-old regression, and the fix is not a trivial
reversion.  So there is no urgency in pushing this out.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
