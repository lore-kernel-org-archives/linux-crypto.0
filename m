Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81A0BC7EE24
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Jun 2023 09:32:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbjFFJcV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Jun 2023 05:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236198AbjFFJcQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Jun 2023 05:32:16 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F6231719;
        Tue,  6 Jun 2023 02:31:53 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q6T29-00HHnh-Kz; Tue, 06 Jun 2023 17:31:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 06 Jun 2023 17:31:21 +0800
Date:   Tue, 6 Jun 2023 17:31:21 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Conor Dooley <conor.dooley@microchip.com>,
        Linux Crypto List <linux-crypto@vger.kernel.org>,
        Huan Feng <huan.feng@starfivetech.com>,
        Jia Jie Ho <jiajie.ho@starfivetech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: [PATCH] crypto: starfive - Depend on AMBA_PL08X instead of
 selecting it
Message-ID: <ZH786WIea+k3S/jW@gondor.apana.org.au>
References: <20230522105257.562cb1ec@canb.auug.org.au>
 <ZGr6aB9uJVnyfJQ9@gondor.apana.org.au>
 <20230523103637.20175fbc@canb.auug.org.au>
 <ZGwmAp5RPqAjVMCg@gondor.apana.org.au>
 <CAMuHMdU5pBh8bk21Xrzk0Ocs7cAF+QTLn60uKOHa1z=TB6Lcuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdU5pBh8bk21Xrzk0Ocs7cAF+QTLn60uKOHa1z=TB6Lcuw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 06, 2023 at 11:12:05AM +0200, Geert Uytterhoeven wrote:
>
> > ---8<---
> > A platform option like AMBA should never be selected by a driver.
> > Use a dependency instead.
> 
> FTR:
> 
> arch/arm/mach-s3c/Kconfig.s3c64xx=config S3C64XX_PL080
> arch/arm/mach-s3c/Kconfig.s3c64xx-      def_bool DMADEVICES
> arch/arm/mach-s3c/Kconfig.s3c64xx:      select AMBA_PL08X

Well that isn't a driver I think so it might be OK?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
