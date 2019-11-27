Return-Path: <SRS0=XAm+=ZT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B7BC432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 05:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4606520684
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Nov 2019 05:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfK0FM1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 00:12:27 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:42028 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbfK0FM1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 00:12:27 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iZpco-0002xs-5F; Wed, 27 Nov 2019 13:12:26 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iZpcm-0001lz-6H; Wed, 27 Nov 2019 13:12:24 +0800
Date:   Wed, 27 Nov 2019 13:12:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4] crypto: conditionalize crypto api in arch glue for
 lib code
Message-ID: <20191127051224.2rvpxen4enlxdgcz@gondor.apana.org.au>
References: <CAKv+Gu8C77SavEUfTbwVzSsCqn63k=wxUVoDUyrz0uJH62h3oQ@mail.gmail.com>
 <20191125103112.71638-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191125103112.71638-1-Jason@zx2c4.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 25, 2019 at 11:31:12AM +0100, Jason A. Donenfeld wrote:
> For glue code that's used by Zinc, the actual Crypto API functions might
> not necessarily exist, and don't need to exist either. Before this
> patch, there are valid build configurations that lead to a unbuildable
> kernel. This fixes it to conditionalize those symbols on the existence
> of the proper config entry.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> ---
> Changes v3->v4:
>   - Rebased on cryptodev-2.6.git to make merging smoother.
> Changes v2->v3:
>   - v2 was a dud, with a find and replace operation gone wild. v3 is
>     what v2 should have been.
> Changes v1->v2:
>   - Discussing with Ard on IRC, we concluded that IS_REACHABLE makes
>     more sense than IS_ENABLED.
> 
>  arch/arm/crypto/chacha-glue.c        | 26 ++++++++++++++++----------
>  arch/arm/crypto/curve25519-glue.c    |  5 +++--
>  arch/arm/crypto/poly1305-glue.c      |  9 ++++++---
>  arch/arm64/crypto/chacha-neon-glue.c |  5 +++--
>  arch/arm64/crypto/poly1305-glue.c    |  5 +++--
>  arch/mips/crypto/chacha-glue.c       |  6 ++++--
>  arch/mips/crypto/poly1305-glue.c     |  6 ++++--
>  arch/x86/crypto/blake2s-glue.c       |  6 ++++--
>  arch/x86/crypto/chacha_glue.c        |  5 +++--
>  arch/x86/crypto/curve25519-x86_64.c  |  7 ++++---
>  arch/x86/crypto/poly1305_glue.c      |  5 +++--
>  11 files changed, 53 insertions(+), 32 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
