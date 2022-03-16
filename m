Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96640C433EF
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Mar 2022 22:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358260AbiCPWMF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Mar 2022 18:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358320AbiCPWL5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Mar 2022 18:11:57 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A2D286D4
        for <linux-crypto@vger.kernel.org>; Wed, 16 Mar 2022 15:10:19 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nUbqS-000809-IF; Thu, 17 Mar 2022 09:10:17 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 17 Mar 2022 10:10:15 +1200
Date:   Thu, 17 Mar 2022 10:10:15 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        kernel@pengutronix.de, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: algapi - Remove test larvals to fix error paths
Message-ID: <YjJgR2FxAaXNHhTa@gondor.apana.org.au>
References: <20220126145322.646723-1-p.zabel@pengutronix.de>
 <c572bf6f0b0a5d7fd3f8f0744a85eb5660a003d4.camel@pengutronix.de>
 <YjE5UCeoziA8f+Q4@gondor.apana.org.au>
 <CAMj1kXF-BdRCN-239cRHgSGM3K9EPSrRFEDJu+e6Gtri2pONaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXF-BdRCN-239cRHgSGM3K9EPSrRFEDJu+e6Gtri2pONaA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 16, 2022 at 08:23:24AM +0100, Ard Biesheuvel wrote:
>
> According to the bisect log in the other thread,
> adad556efcdd42a1d9e060cb is the culprit, which does not seem
> surprising, at is would result in the SIMD skcipher being encapsulated
> to not be available yet when the SIMD helper tries to take a reference
> to it.

It's supposed to work because any use of an algorithm prior to
the tests starting will automatically trigger the test right away.
I confirmed this by booting the kernel in qemu with AES_ARM_BS=y
and it successfully registered those algorithms and passed the
self-tests.

Someone else has already sent me a complete kconfig file which
hopefully should reproduce the crash for me.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
