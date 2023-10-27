Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2D29C25B47
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 10:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbjJ0Kw4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 06:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjJ0Kw4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 06:52:56 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7A911F
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 03:52:53 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qwKSO-00BeVS-Tr; Fri, 27 Oct 2023 18:52:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Oct 2023 18:52:55 +0800
Date:   Fri, 27 Oct 2023 18:52:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 00/17] crypto: stop supporting alignmask in shash
Message-ID: <ZTuWh1niYjwal6/e@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231019055343.588846-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> The alignmask support in the shash algorithm type is virtually unused
> and has no real point.  This patch series removes it in order to reduce
> API overhead and complexity.
> 
> This series does not change anything for ahash.
> 
> Eric Biggers (17):
>  crypto: sparc/crc32c - stop using the shash alignmask
>  crypto: stm32 - remove unnecessary alignmask
>  crypto: xilinx/zynqmp-sha - remove unnecessary alignmask
>  crypto: mips/crc32 - remove redundant setting of alignmask to 0
>  crypto: loongarch/crc32 - remove redundant setting of alignmask to 0
>  crypto: cbcmac - remove unnecessary alignment logic
>  crypto: cmac - remove unnecessary alignment logic
>  crypto: hmac - remove unnecessary alignment logic
>  crypto: vmac - don't set alignmask
>  crypto: xcbc - remove unnecessary alignment logic
>  crypto: shash - remove support for nonzero alignmask
>  libceph: stop checking crypto_shash_alignmask
>  crypto: drbg - stop checking crypto_shash_alignmask
>  crypto: testmgr - stop checking crypto_shash_alignmask
>  crypto: adiantum - stop using alignmask of shash_alg
>  crypto: hctr2 - stop using alignmask of shash_alg
>  crypto: shash - remove crypto_shash_alignmask
> 
> arch/loongarch/crypto/crc32-loongarch.c |   2 -
> arch/mips/crypto/crc32-mips.c           |   2 -
> arch/sparc/crypto/crc32c_glue.c         |  45 +++++----
> crypto/adiantum.c                       |   3 +-
> crypto/ccm.c                            |  17 ++--
> crypto/cmac.c                           |  39 ++------
> crypto/drbg.c                           |   2 +-
> crypto/hctr2.c                          |   3 +-
> crypto/hmac.c                           |  56 ++++-------
> crypto/shash.c                          | 128 ++----------------------
> crypto/testmgr.c                        |   5 +-
> crypto/vmac.c                           |   1 -
> crypto/xcbc.c                           |  32 ++----
> drivers/crypto/stm32/stm32-crc32.c      |   2 -
> drivers/crypto/xilinx/zynqmp-sha.c      |   1 -
> include/crypto/hash.h                   |   6 --
> net/ceph/messenger_v2.c                 |   4 -
> 17 files changed, 87 insertions(+), 261 deletions(-)
> 
> 
> base-commit: 5b90073defd1a52aa8120403d79f6e0fc10c87ee
> prerequisite-patch-id: 77bd65b07cfc27f172b1698e0c4d43d6aba7ad8f
> prerequisite-patch-id: 3ccf94d7048db0fee9407b5b5fa48554e115b56b
> prerequisite-patch-id: e447f81a392f2f3955206357d72032cf691c7e11

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
