Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7C8C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Nov 2022 03:52:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKIDwZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 22:52:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKIDwY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 22:52:24 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326A2165AE
        for <linux-crypto@vger.kernel.org>; Tue,  8 Nov 2022 19:52:22 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1osc7q-00BoUK-Va; Wed, 09 Nov 2022 11:52:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 09 Nov 2022 11:52:19 +0800
Date:   Wed, 9 Nov 2022 11:52:19 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ben Greear <greearb@candelatech.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
Message-ID: <Y2sj84u/w/nOgKwx@gondor.apana.org.au>
References: <20201210024342.GA26428@gondor.apana.org.au>
 <e02fe07e-8cb6-f889-3228-60e4fabf4e40@candelatech.com>
 <CAMj1kXF05XZtyakdpLixpP9Lroy0D3_gEcY2SFbSshD8ERUU7w@mail.gmail.com>
 <20201210111427.GA28014@gondor.apana.org.au>
 <CAMj1kXG39GgsTeNBbX7_oaK+f-awPyL8NxJ7R+fyOBjL4c5xMw@mail.gmail.com>
 <20201210121627.GB28441@gondor.apana.org.au>
 <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
 <CAMj1kXH5LPib2vPgLkdzHX4gSawDSE=ij451s106_xTuT19YmA@mail.gmail.com>
 <20201215091902.GA21455@gondor.apana.org.au>
 <062a2258-fad4-2c6f-0054-b0f41786ff85@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <062a2258-fad4-2c6f-0054-b0f41786ff85@candelatech.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Nov 08, 2022 at 10:50:48AM -0800, Ben Greear wrote:
>
> While rebasing my patches onto 6.1-rc4, I noticed my aesni for ccm(aes) patch didn't apply cleanly,
> and I found this patch described below is applied now.  Does this upstream patch mean that aesni is already
> supported upstream now?  Or is it specific to whatever xctr is?  If so,
> any chance the patch is wanted upstream now?

AFAICS the xctr patch has nothing to do with what you were trying
to achieve with wireless.  My objection still stands with regards
to wireless, we should patch wireless to use the async crypto
interface and not hack around it in the Crypto API.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
