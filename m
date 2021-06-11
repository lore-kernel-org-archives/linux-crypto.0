Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE2FC48BD1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 07:23:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DA20610F8
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 07:23:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhFKHZM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 03:25:12 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50554 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231350AbhFKHZM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 03:25:12 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lrbVZ-0005Kl-Oy; Fri, 11 Jun 2021 15:23:13 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lrbVY-0002MN-TA; Fri, 11 Jun 2021 15:23:12 +0800
Date:   Fri, 11 Jun 2021 15:23:12 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/curve25519 - fix cpu feature checking logic
 in mod_exit
Message-ID: <20210611072312.GE23016@gondor.apana.org.au>
References: <20210603055341.24473-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603055341.24473-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 03, 2021 at 01:53:40AM -0400, Hangbin Liu wrote:
> In curve25519_mod_init() the curve25519_alg will be registered only when
> (X86_FEATURE_BMI2 && X86_FEATURE_ADX). But in curve25519_mod_exit()
> it still checks (X86_FEATURE_BMI2 || X86_FEATURE_ADX) when do crypto
> unregister. This will trigger a BUG_ON in crypto_unregister_alg() as
> alg->cra_refcnt is 0 if the cpu only supports one of X86_FEATURE_BMI2
> and X86_FEATURE_ADX.
> 
> Fixes: 07b586fe0662 ("crypto: x86/curve25519 - replace with formally verified implementation")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  arch/x86/crypto/curve25519-x86_64.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
