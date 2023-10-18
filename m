Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B27CDB474
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Oct 2023 01:24:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjJRBYW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Oct 2023 21:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjJRBYW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2023 21:24:22 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1897390
        for <linux-crypto@vger.kernel.org>; Tue, 17 Oct 2023 18:24:20 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qsvI3-008EVr-6f; Wed, 18 Oct 2023 09:24:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 18 Oct 2023 09:24:08 +0800
Date:   Wed, 18 Oct 2023 09:24:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
Message-ID: <ZS8zuBYdk6sa66ZB@gondor.apana.org.au>
References: <CAMj1kXH5LPib2vPgLkdzHX4gSawDSE=ij451s106_xTuT19YmA@mail.gmail.com>
 <20201215091902.GA21455@gondor.apana.org.au>
 <062a2258-fad4-2c6f-0054-b0f41786ff85@candelatech.com>
 <Y2sj84u/w/nOgKwx@gondor.apana.org.au>
 <CAMj1kXG3id6ABX=5D4H0XLmVnijHCY6whp09U5pLQr0Ftf5Gzw@mail.gmail.com>
 <6e20b593-393c-9fa1-76aa-b78951b1f2f3@candelatech.com>
 <CAMj1kXEqcPvb-uLvGLhue=6eME-6WhuPgoG+HgLH0EoZLE9aZA@mail.gmail.com>
 <32a44a29-c5f4-f5fa-496f-a9dc98d8209d@candelatech.com>
 <20231017031603.GB1907@sol.localdomain>
 <CAMj1kXFRpbGJ_nkomb88o3F5Eg9ghh+xTZgGgeD7wfC3uwSk0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFRpbGJ_nkomb88o3F5Eg9ghh+xTZgGgeD7wfC3uwSk0g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Oct 17, 2023 at 08:43:29AM +0200, Ard Biesheuvel wrote:
>
> It was rejected by Herbert on the basis that the wireless stack should
> be converted to use the async API instead.

Yes, there is no reason to special-case this one algorithm when
everything else uses the simd model.  Of course, if we can support
simd in softirqs that would be the best outcome.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
