Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1112DEB64D9
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Jun 2023 04:09:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjF2EJT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Jun 2023 00:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbjF2EIe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jun 2023 00:08:34 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403572D56;
        Wed, 28 Jun 2023 21:06:45 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qEivI-008Qt0-WE; Thu, 29 Jun 2023 12:06:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 29 Jun 2023 12:06:24 +0800
Date:   Thu, 29 Jun 2023 12:06:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kees Cook <keescook@chromium.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Arnaud Ebalard <arno@natisbad.org>,
        Srujana Challa <schalla@marvell.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Subject: Re: Build error in crypto/marvell/cesa/cipher.c
Message-ID: <ZJ0DQCCqTqcvNxLi@gondor.apana.org.au>
References: <CAHk-=whXn0YTojV=+J8B-r8KLvNtqc2JtCa4a_bdhf+=GN5OOw@mail.gmail.com>
 <202306282038.C3A12326A@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202306282038.C3A12326A@keescook>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jun 28, 2023 at 08:48:19PM -0700, Kees Cook wrote:
>
> This was fixed very recently here:
> https://lore.kernel.org/all/20230523083313.899332-1-arnd@kernel.org/
> and Herbert took it.
> 
> I assume the crypto tree hasn't been merged yet?

Yes it's in cryptodev:

https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=efbc7764c4446566edb76ca05e903b5905673d2e

Now that this seems to be causing build failures, I'll add it to the
crypto tree.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
