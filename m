Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988C7C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 04:37:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236050AbiA0Ehz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 23:37:55 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60506 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbiA0Ehy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 23:37:54 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nCwXd-0007s1-BG; Thu, 27 Jan 2022 15:37:50 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Jan 2022 15:37:49 +1100
Date:   Thu, 27 Jan 2022 15:37:49 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-crypto@vger.kernel.org, kernel@pengutronix.de,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: algapi - Remove test larvals to fix error paths
Message-ID: <YfIhnSyxmGxbYwy1@gondor.apana.org.au>
References: <20220126145322.646723-1-p.zabel@pengutronix.de>
 <c572bf6f0b0a5d7fd3f8f0744a85eb5660a003d4.camel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c572bf6f0b0a5d7fd3f8f0744a85eb5660a003d4.camel@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 26, 2022 at 04:01:04PM +0100, Philipp Zabel wrote:
> On Wed, 2022-01-26 at 15:53 +0100, Philipp Zabel wrote:
> [...]
> > This can happen during cleanup if the error path is taken for a built-
> > in algorithm, before crypto_algapi_init() was called.
> 
> I see this happen on ARM with CONFIG_CRYPTO_AES_ARM_BS=y since v5.16-rc1
> because the simd_skcipher_create_compat("ecb(aes)", "ecb-aes-neonbs",
> "__ecb-aes-neonbs") call in arch/arm/crypto/aes-neonbs-glue.c returns
> -ENOENT. I believe that is the same issue as reported in [1].

Good catch.  We definitely need to fix the crash from the unregister
while the algorithm is still being referenced.

However, the fact that the simd create is failing is probably a bug
too.  Could you take a look at that aspect and whether the failure
is related to the testmgr changes in question?

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
