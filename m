Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0B9DC433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:22:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A452064E42
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 07:22:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhBJHWt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Feb 2021 02:22:49 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:50194 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232346AbhBJHWr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Feb 2021 02:22:47 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l9jou-0001Ez-Sb; Wed, 10 Feb 2021 18:21:54 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 10 Feb 2021 18:21:52 +1100
Date:   Wed, 10 Feb 2021 18:21:52 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jan Henrik Weinstock <jan.weinstock@rwth-aachen.de>
Cc:     mpm@selenic.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hw_random/timeriomem-rng: Fix cooldown period calculation
Message-ID: <20210210072152.GB4493@gondor.apana.org.au>
References: <947aa0ab-1f0c-44d6-943a-cf83a56ac5b8@rwthex-s2-a.rwth-ad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <947aa0ab-1f0c-44d6-943a-cf83a56ac5b8@rwthex-s2-a.rwth-ad.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Feb 01, 2021 at 04:14:59PM +0100, Jan Henrik Weinstock wrote:
> Ensure cooldown period tolerance of 1% is actually accounted for.
> 
> Signed-off-by: Jan Henrik Weinstock <jan.weinstock@rwth-aachen.de>
> ---
> 
> Before patch, if period_us was less than 100us, no extra sleep time was
> added. If it was more than 100us, only 1us extra time (and not 1%) is slept.
> 
>  drivers/char/hw_random/timeriomem-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.

BTW your patch was space corrupted so I had to apply it by hand.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
