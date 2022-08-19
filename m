Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7295FC32771
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Aug 2022 10:59:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347036AbiHSK7l (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Aug 2022 06:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348435AbiHSK7k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Aug 2022 06:59:40 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E094ADABB3;
        Fri, 19 Aug 2022 03:59:39 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oOzix-00CpWa-TF; Fri, 19 Aug 2022 20:59:37 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Aug 2022 18:59:35 +0800
Date:   Fri, 19 Aug 2022 18:59:35 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason@zx2c4.com
Subject: Re: [PATCH v3 0/3] crypto: lib - create utils module
Message-ID: <Yv9tFwCbMPXqUir5@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725183636.97326-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> Create a utils module in lib/crypto/, and move __crypto_memneq,
> __crypto_xor, and crypto_simd_disabled_for_test into it.
> 
> This supersedes "crypto: xor - move __crypto_xor into lib/"
> (https://lore.kernel.org/linux-crypto/20220709215453.262237-1-ebiggers@kernel.org/T/#u).
> 
> Changed v2 => v3:
>   - Added missing MODULE_LICENSE
>   - Dropped patch "crypto: lib - move crypto_simd_disabled_for_test
>     into utils"
>   - Added patch "crypto: lib - remove __HAVE_ARCH_CRYPTO_MEMNEQ"
> 
> Eric Biggers (3):
>  crypto: lib - create utils module and move __crypto_memneq into it
>  crypto: lib - move __crypto_xor into utils
>  crypto: lib - remove __HAVE_ARCH_CRYPTO_MEMNEQ
> 
> crypto/Kconfig            |  2 +-
> crypto/algapi.c           | 71 -------------------------------
> lib/Kconfig               |  3 --
> lib/Makefile              |  1 -
> lib/crypto/Kconfig        |  8 ++--
> lib/crypto/Makefile       |  3 ++
> lib/{ => crypto}/memneq.c |  7 +---
> lib/crypto/utils.c        | 88 +++++++++++++++++++++++++++++++++++++++
> 8 files changed, 99 insertions(+), 84 deletions(-)
> rename lib/{ => crypto}/memneq.c (98%)
> create mode 100644 lib/crypto/utils.c
> 
> 
> base-commit: 9d2bb9a74b2877f100637d6ab5685bcd33c69d44

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
