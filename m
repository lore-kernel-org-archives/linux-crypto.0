Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20AE2EB64DA
	for <linux-crypto@archiver.kernel.org>; Sat, 24 Jun 2023 07:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjFXHrO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 24 Jun 2023 03:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjFXHrN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 24 Jun 2023 03:47:13 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4089AD3
        for <linux-crypto@vger.kernel.org>; Sat, 24 Jun 2023 00:47:10 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qCxyu-006hCq-Kf; Sat, 24 Jun 2023 15:46:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 24 Jun 2023 15:46:52 +0800
Date:   Sat, 24 Jun 2023 15:46:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: sm2 - Provide sm2_compute_z_digest when sm2 is
 disabled
Message-ID: <ZJafbEJ4SOYPEo1N@gondor.apana.org.au>
References: <202306231917.utO12sx8-lkp@intel.com>
 <ZJZ8/JifEeygojAq@gondor.apana.org.au>
 <CAMj1kXGKnusvWDV8rSUhQexeKy1e2+x2-ZXw6_6RiExvtiR_8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGKnusvWDV8rSUhQexeKy1e2+x2-ZXw6_6RiExvtiR_8A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 24, 2023 at 09:40:59AM +0200, Ard Biesheuvel wrote:
>
> How is this supposed to work when
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y but SM2 is configured as a
> module?

It will fail as it did previously.  I'm just rearranging the code.
Perhaps when another algorithm that requires a non-standard digest
comes up we can think up of a proper abstraction.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
