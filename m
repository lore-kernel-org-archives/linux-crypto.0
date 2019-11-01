Return-Path: <SRS0=WdwO=YZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC4BCA9EC9
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 06:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BA59208CB
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Nov 2019 06:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728769AbfKAGMy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Nov 2019 02:12:54 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37760 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbfKAGMy (ORCPT <rfc822;linux-crypto@vger.kernel.orG>);
        Fri, 1 Nov 2019 02:12:54 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iQQB3-0001zW-9b; Fri, 01 Nov 2019 14:12:53 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iQQB2-0004v4-5l; Fri, 01 Nov 2019 14:12:52 +0800
Date:   Fri, 1 Nov 2019 14:12:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/5] crypto: remove blkcipher
Message-ID: <20191101061252.o5brismcbcs6dhxv@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025194113.217451-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> Now that all "blkcipher" algorithms have been converted to "skcipher",
> this series removes the blkcipher algorithm type.
> 
> The skcipher (symmetric key cipher) algorithm type was introduced a few
> years ago to replace both blkcipher and ablkcipher (synchronous and
> asynchronous block cipher).  The advantages of skcipher include:
> 
>  - A much less confusing name, since none of these algorithm types have
>    ever actually been for raw block ciphers, but rather for all
>    length-preserving encryption modes including block cipher modes of
>    operation, stream ciphers, and other length-preserving modes.
> 
>  - It unified blkcipher and ablkcipher into a single algorithm type
>    which supports both synchronous and asynchronous implementations.
>    Note, blkcipher already operated only on scatterlists, so the fact
>    that skcipher does too isn't a regression in functionality.
> 
>  - Better type safety by using struct skcipher_alg, struct
>    crypto_skcipher, etc. instead of crypto_alg, crypto_tfm, etc.
> 
>  - It sometimes simplifies the implementations of algorithms.
> 
> Also, the blkcipher API was no longer being tested.
> 
> Eric Biggers (5):
>  crypto: unify the crypto_has_skcipher*() functions
>  crypto: remove crypto_has_ablkcipher()
>  crypto: rename crypto_skcipher_type2 to crypto_skcipher_type
>  crypto: remove the "blkcipher" algorithm type
>  crypto: rename the crypto_blkcipher module and kconfig option
> 
> Documentation/crypto/api-skcipher.rst |  13 +-
> Documentation/crypto/architecture.rst |   2 -
> Documentation/crypto/devel-algos.rst  |  27 +-
> arch/arm/crypto/Kconfig               |   6 +-
> arch/arm64/crypto/Kconfig             |   8 +-
> crypto/Kconfig                        |  84 ++--
> crypto/Makefile                       |   7 +-
> crypto/api.c                          |   2 +-
> crypto/blkcipher.c                    | 548 --------------------------
> crypto/cryptd.c                       |   2 +-
> crypto/crypto_user_stat.c             |   4 -
> crypto/essiv.c                        |   6 +-
> crypto/skcipher.c                     | 124 +-----
> drivers/crypto/Kconfig                |  52 +--
> drivers/crypto/amlogic/Kconfig        |   2 +-
> drivers/crypto/caam/Kconfig           |   6 +-
> drivers/crypto/cavium/nitrox/Kconfig  |   2 +-
> drivers/crypto/ccp/Kconfig            |   2 +-
> drivers/crypto/hisilicon/Kconfig      |   2 +-
> drivers/crypto/qat/Kconfig            |   2 +-
> drivers/crypto/ux500/Kconfig          |   2 +-
> drivers/crypto/virtio/Kconfig         |   2 +-
> drivers/net/wireless/cisco/Kconfig    |   2 +-
> include/crypto/algapi.h               |  74 ----
> include/crypto/internal/skcipher.h    |  12 -
> include/crypto/skcipher.h             |  27 +-
> include/linux/crypto.h                | 426 +-------------------
> net/bluetooth/Kconfig                 |   2 +-
> net/rxrpc/Kconfig                     |   2 +-
> net/xfrm/Kconfig                      |   2 +-
> net/xfrm/xfrm_algo.c                  |   4 +-
> 31 files changed, 124 insertions(+), 1332 deletions(-)
> delete mode 100644 crypto/blkcipher.c

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
