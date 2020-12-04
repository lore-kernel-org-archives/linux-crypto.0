Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1CE6C433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 07:18:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58C6820639
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Dec 2020 07:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgLDHSH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Dec 2020 02:18:07 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:32792 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725550AbgLDHSH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Dec 2020 02:18:07 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kl5LA-0006gA-VQ; Fri, 04 Dec 2020 18:17:18 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Dec 2020 18:17:16 +1100
Date:   Fri, 4 Dec 2020 18:17:16 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     linux-crypto@vger.kernel.org, geert@linux-m68k.org
Subject: Re: [PATCH] crypto: aegis128 - avoid spurious references
 crypto_aegis128_update_simd
Message-ID: <20201204071716.GA31869@gondor.apana.org.au>
References: <20201130122620.16640-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130122620.16640-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 30, 2020 at 01:26:20PM +0100, Ard Biesheuvel wrote:
> Geert reports that builds where CONFIG_CRYPTO_AEGIS128_SIMD is not set
> may still emit references to crypto_aegis128_update_simd(), which
> cannot be satisfied and therefore break the build. These references
> only exist in functions that can be optimized away, but apparently,
> the compiler is not always able to prove this.
> 
> So add some explicit checks for CONFIG_CRYPTO_AEGIS128_SIMD to help the
> compiler figure this out.
> 
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  crypto/aegis128-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
