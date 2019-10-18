Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD5ECCA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC97E2089C
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731017AbfJRIE1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:04:27 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37324 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbfJRIE0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 04:04:26 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iLNF9-0001v3-Bm; Fri, 18 Oct 2019 19:04:16 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Oct 2019 19:04:15 +1100
Date:   Fri, 18 Oct 2019 19:04:15 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Subject: Re: [PATCH] crypto: arm - use Kconfig based compiler checks for
 crypto opcodes
Message-ID: <20191018080415.GF25128@gondor.apana.org.au>
References: <20191011090800.29386-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191011090800.29386-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 11, 2019 at 11:08:00AM +0200, Ard Biesheuvel wrote:
> Instead of allowing the Crypto Extensions algorithms to be selected when
> using a toolchain that does not support them, and complain about it at
> build time, use the information we have about the compiler to prevent
> them from being selected in the first place. Users that are stuck with
> a GCC version <4.8 are unlikely to care about these routines anyway, and
> it cleans up the Makefile considerably.
> 
> While at it, add explicit 'armv8-a' CPU specifiers to the code that uses
> the 'crypto-neon-fp-armv8' FPU specifier so we don't regress Clang, which
> will complain about this in version 10 and later.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  arch/arm/crypto/Kconfig             | 14 +++++++------
>  arch/arm/crypto/Makefile            | 32 ++++++-----------------------
>  arch/arm/crypto/aes-ce-core.S       |  1 +
>  arch/arm/crypto/crct10dif-ce-core.S |  2 +-
>  arch/arm/crypto/ghash-ce-core.S     |  1 +
>  arch/arm/crypto/sha1-ce-core.S      |  1 +
>  arch/arm/crypto/sha2-ce-core.S      |  1 +
>  7 files changed, 19 insertions(+), 33 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
