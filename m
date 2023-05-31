Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E052C77B7A
	for <linux-crypto@archiver.kernel.org>; Wed, 31 May 2023 10:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbjEaK6l (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 May 2023 06:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbjEaK6k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 May 2023 06:58:40 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3CD3107;
        Wed, 31 May 2023 03:58:37 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1q4JWs-00FEVF-8S; Wed, 31 May 2023 18:58:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 31 May 2023 18:58:10 +0800
Date:   Wed, 31 May 2023 18:58:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kees Cook <keescook@chromium.org>
Cc:     arno@natisbad.org, arnd@kernel.org, schalla@marvell.com,
        bbrezillon@kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: marvell/cesa - Fix type mismatch warning
Message-ID: <ZHcoQvWnzO0c1Cp9@gondor.apana.org.au>
References: <20230523083313.899332-1-arnd@kernel.org>
 <168548692863.1302890.6789778742527600870.b4-ty@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168548692863.1302890.6789778742527600870.b4-ty@chromium.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 30, 2023 at 03:48:49PM -0700, Kees Cook wrote:
> On Tue, 23 May 2023 10:33:04 +0200, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> > 
> > Commit df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3") uncovered
> > a type mismatch in cesa 3des support that leads to a memcpy beyond the
> > end of a structure:
> > 
> > In function 'fortify_memcpy_chk',
> >     inlined from 'mv_cesa_des3_ede_setkey' at drivers/crypto/marvell/cesa/cipher.c:307:2:
> > include/linux/fortify-string.h:583:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
> >   583 |                         __write_overflow_field(p_size_field, size);
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > 
> > [...]
> 
> Applied to for-next/hardening, thanks!
> 
> [1/1] crypto: marvell/cesa - Fix type mismatch warning
>       https://git.kernel.org/kees/c/37f3abddda8d

Why did you apply it to your tree? This patch makes sense on its
own regardless of the fortify changes.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
