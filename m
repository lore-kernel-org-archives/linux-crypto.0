Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D30CCDB47E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 05:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233497AbjJTFxC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 01:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbjJTFxC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 01:53:02 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C64D1A6
        for <linux-crypto@vger.kernel.org>; Thu, 19 Oct 2023 22:52:57 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qtiRI-0097Yc-Le; Fri, 20 Oct 2023 13:52:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Oct 2023 13:52:58 +0800
Date:   Fri, 20 Oct 2023 13:52:58 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/4] crypto: adiantum optimizations
Message-ID: <ZTIVuuUYkIDmyKE4@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231010055946.263981-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> This series slightly improves the performance of adiantum encryption and
> decryption on single-page messages.
> 
> Eric Biggers (4):
>  crypto: adiantum - add fast path for single-page messages
>  crypto: arm/nhpoly1305 - implement ->digest
>  crypto: arm64/nhpoly1305 - implement ->digest
>  crypto: x86/nhpoly1305 - implement ->digest
> 
> arch/arm/crypto/nhpoly1305-neon-glue.c   |  9 ++++
> arch/arm64/crypto/nhpoly1305-neon-glue.c |  9 ++++
> arch/x86/crypto/nhpoly1305-avx2-glue.c   |  9 ++++
> arch/x86/crypto/nhpoly1305-sse2-glue.c   |  9 ++++
> crypto/adiantum.c                        | 65 +++++++++++++++++-------
> 5 files changed, 83 insertions(+), 18 deletions(-)
> 
> base-commit: 8468516f9f93a41dc65158b6428a1a1039c68f20

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
