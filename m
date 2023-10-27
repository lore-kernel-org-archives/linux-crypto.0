Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB699C25B47
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Oct 2023 10:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345689AbjJ0K4Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Oct 2023 06:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345598AbjJ0K4Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2023 06:56:24 -0400
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE634192
        for <linux-crypto@vger.kernel.org>; Fri, 27 Oct 2023 03:56:20 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qwKVk-00BedY-Kt; Fri, 27 Oct 2023 18:56:17 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Oct 2023 18:56:22 +0800
Date:   Fri, 27 Oct 2023 18:56:22 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 00/30] crypto: reduce ahash API overhead
Message-ID: <ZTuXVjsHfychD5RY@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231022081100.123613-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> This patch series first removes the alignmask support from ahash.  As is
> the case with shash, the alignmask support of ahash has no real point.
> Removing it reduces API overhead and complexity.
> 
> Second, this patch series optimizes the common case where the ahash API
> uses an shash algorithm, by eliminating unnecessary indirect calls.
> 
> This series can be retrieved from git at
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> tag "crypto-ahash-2023-10-22".  Note that it depends on my other series
> "crypto: stop supporting alignmask in shash"
> (https://lore.kernel.org/r/20231019055343.588846-1-ebiggers@kernel.org).
> 
> Patch 1 cleans up after removal of alignmask support from shash.
> 
> Patches 2-12 make drivers stop setting an alignmask for ahashes.
> 
> Patch 13 removes alignmask support from ahash.
> 
> Patches 14-23 remove checks of ahash alignmasks that became unnecessary.
> 
> Patches 24-25 are other ahash related cleanups.
> 
> Patches 26-29 prepare for optimizing the ahash-using-shash case.
> 
> Patches 30 optimizes the ahash-using-shash case.
> 
> Eric Biggers (30):
>  crypto: shash - remove crypto_shash_ctx_aligned()
>  crypto: sun4i-ss - remove unnecessary alignmask for ahashes
>  crypto: sun8i-ce - remove unnecessary alignmask for ahashes
>  crypto: sun8i-ss - remove unnecessary alignmask for ahashes
>  crypto: atmel - remove unnecessary alignmask for ahashes
>  crypto: artpec6 - stop setting alignmask for ahashes
>  crypto: mxs-dcp - remove unnecessary alignmask for ahashes
>  crypto: s5p-sss - remove unnecessary alignmask for ahashes
>  crypto: talitos - remove unnecessary alignmask for ahashes
>  crypto: omap-sham - stop setting alignmask for ahashes
>  crypto: rockchip - remove unnecessary alignmask for ahashes
>  crypto: starfive - remove unnecessary alignmask for ahashes
>  crypto: stm32 - remove unnecessary alignmask for ahashes
>  crypto: ahash - remove support for nonzero alignmask
>  crypto: authenc - stop using alignmask of ahash
>  crypto: authencesn - stop using alignmask of ahash
>  crypto: testmgr - stop checking crypto_ahash_alignmask
>  net: ipv4: stop checking crypto_ahash_alignmask
>  net: ipv6: stop checking crypto_ahash_alignmask
>  crypto: ccm - stop using alignmask of ahash
>  crypto: chacha20poly1305 - stop using alignmask of ahash
>  crypto: gcm - stop using alignmask of ahash
>  crypto: ahash - remove crypto_ahash_alignmask
>  crypto: ahash - remove struct ahash_request_priv
>  crypto: ahash - improve file comment
>  crypto: chelsio - stop using crypto_ahash::init
>  crypto: talitos - stop using crypto_ahash::init
>  crypto: hash - move "ahash wrapping shash" functions to ahash.c
>  crypto: ahash - check for shash type instead of not ahash type
>  crypto: ahash - optimize performance when wrapping shash
> 
> Documentation/crypto/devel-algos.rst          |   4 +-
> crypto/ahash.c                                | 406 +++++++++++-------
> crypto/authenc.c                              |  12 +-
> crypto/authencesn.c                           |  20 +-
> crypto/ccm.c                                  |   3 +-
> crypto/chacha20poly1305.c                     |   3 +-
> crypto/gcm.c                                  |   3 +-
> crypto/hash.h                                 |  14 +-
> crypto/shash.c                                | 205 +--------
> crypto/testmgr.c                              |   9 +-
> .../crypto/allwinner/sun4i-ss/sun4i-ss-core.c |   2 -
> .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c |   6 -
> .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |   5 -
> drivers/crypto/atmel-sha.c                    |   2 -
> drivers/crypto/axis/artpec6_crypto.c          |   3 -
> drivers/crypto/chelsio/chcr_algo.c            |   9 +-
> drivers/crypto/mxs-dcp.c                      |   2 -
> drivers/crypto/omap-sham.c                    |  16 +-
> drivers/crypto/rockchip/rk3288_crypto_ahash.c |   3 -
> drivers/crypto/s5p-sss.c                      |   6 -
> drivers/crypto/starfive/jh7110-hash.c         |  13 +-
> drivers/crypto/stm32/stm32-hash.c             |  20 -
> drivers/crypto/talitos.c                      |  17 +-
> include/crypto/algapi.h                       |   5 -
> include/crypto/hash.h                         |  74 +---
> include/crypto/internal/hash.h                |   9 +-
> include/linux/crypto.h                        |  27 +-
> net/ipv4/ah4.c                                |  17 +-
> net/ipv6/ah6.c                                |  17 +-
> 29 files changed, 339 insertions(+), 593 deletions(-)
> 
> 
> base-commit: a2786e8bdd0242d7f00abf452a572de7464d177b
> prerequisite-patch-id: e447f81a392f2f3955206357d72032cf691c7e11
> prerequisite-patch-id: 71947e05e23fb176da3ca898720b9e3332e891d7
> prerequisite-patch-id: 98d070bdaf3cfaf88553ab707cc3bfe85371c006
> prerequisite-patch-id: 9e4287b71c1129edb1ba162e2a1f641a9ac4385f
> prerequisite-patch-id: 22a4cda4ae529854e55627c55d3f35b035871f3b
> prerequisite-patch-id: f67b194e37338a4715850686b2f02bbf0a47cbe1
> prerequisite-patch-id: bcb547f4c9be4b022b824f9bff6b919b2d37d60f
> prerequisite-patch-id: 20a8c2663a94c2d49217c5158a6bc588881fb9ad
> prerequisite-patch-id: e45e43c487d75c87fd713a5ef57a584cf947950e
> prerequisite-patch-id: bb211c1b59f73b22319aee6fafd14b07bc5d1460
> prerequisite-patch-id: 5f033ce643ba7d1f219dee490abd21e1e0958a51
> prerequisite-patch-id: 2173122570085246d5f4e5d3c4a920f7b7c528f9
> prerequisite-patch-id: 3fe1bc3b93e9502f874c485c5f2e39eec4899222
> prerequisite-patch-id: 982ed5e31a6616f9788d4641c3757342e9f15576
> prerequisite-patch-id: 6a207af4a7044cc47ab3f797e9c865fdbdb5d20c
> prerequisite-patch-id: f34ad579025354af65a73c1497dc967e2e834a55
> prerequisite-patch-id: 5ad384179da558ff3359baabda588731ed2e90a4
> prerequisite-patch-id: d3d243977afb4f574fb289eddf0e71becda1ae2b

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
