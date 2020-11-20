Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0977AC5519F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 06:57:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1DCA21D7E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Nov 2020 06:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgKTG5Y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Nov 2020 01:57:24 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:34208 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726421AbgKTG5Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Nov 2020 01:57:24 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kg0MA-0007kc-02; Fri, 20 Nov 2020 17:57:19 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Nov 2020 17:57:17 +1100
Date:   Fri, 20 Nov 2020 17:57:17 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Christian Lamparter <chunkeey@gmail.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] crypto: crypto4xx - Replace bitwise OR with logical OR
 in crypto4xx_build_pd
Message-ID: <20201120065717.GD20581@gondor.apana.org.au>
References: <20201112200702.1664905-1-natechancellor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112200702.1664905-1-natechancellor@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 12, 2020 at 01:07:02PM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
> drivers/crypto/amcc/crypto4xx_core.c:921:60: warning: operator '?:' has
> lower precedence than '|'; '|' will be evaluated first
> [-Wbitwise-conditional-parentheses]
>                  (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
>                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^
> drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
> around the '|' expression to silence this warning
>                  (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
>                                                                          ^
>                                                                         )
> drivers/crypto/amcc/crypto4xx_core.c:921:60: note: place parentheses
> around the '?:' expression to evaluate it first
>                  (crypto_tfm_alg_type(req->tfm) == CRYPTO_ALG_TYPE_AEAD) ?
>                                                                          ^
>                  (
> 1 warning generated.
> 
> It looks like this should have been a logical OR so that
> PD_CTL_HASH_FINAL gets added to the w bitmask if crypto_tfm_alg_type
> is either CRYPTO_ALG_TYPE_AHASH or CRYPTO_ALG_TYPE_AEAD. Change the
> operator so that everything works properly.
> 
> Fixes: 4b5b79998af6 ("crypto: crypto4xx - fix stalls under heavy load")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1198
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
