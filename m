Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F108C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Jul 2022 08:09:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiGOIJy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Jul 2022 04:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiGOIJy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Jul 2022 04:09:54 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BFF47E81F;
        Fri, 15 Jul 2022 01:09:52 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oCGOR-000nHA-Q4; Fri, 15 Jul 2022 18:09:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Jul 2022 16:09:48 +0800
Date:   Fri, 15 Jul 2022 16:09:48 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason@zx2c4.com
Subject: Re: [PATCH] crypto: xor - move __crypto_xor into lib/
Message-ID: <YtEgzHuuMts0YBCz@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220709215453.262237-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> CRYPTO_LIB_CHACHA depends on CRYPTO for __crypto_xor, defined in
> crypto/algapi.c.  This is a layering violation because the dependencies
> should only go in the other direction (crypto/ => lib/crypto/).  Also
> the correct dependency would be CRYPTO_ALGAPI, not CRYPTO.  Fix this by
> moving __crypto_xor into lib/xor.c, alongside lib/memneq.c where
> __crypto_memneq was recently moved.
> 
> Note that CRYPTO_LIB_CHACHA_GENERIC selected XOR_BLOCKS, which is
> unrelated and unnecessary.  It was perhaps thought that XOR_BLOCKS was
> needed for __crypto_xor, but that's not the case.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/Kconfig     |  1 +
> crypto/algapi.c    | 71 --------------------------------------
> lib/Kconfig        |  3 ++
> lib/Makefile       |  1 +
> lib/crypto/Kconfig |  3 +-
> lib/xor.c          | 85 ++++++++++++++++++++++++++++++++++++++++++++++
> 6 files changed, 91 insertions(+), 73 deletions(-)
> create mode 100644 lib/xor.c

Now that there are two of these things (xor and memneq), please
aggregate them into a module (either as separate files linked
together or as a single file) and turn it into a tristate.

They should also be moved into lib/crypto together with their
main users as lib is way too crowded as it is.

We could then revisit that simd variable and move it in too.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
