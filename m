Return-Path: <SRS0=LmLS=26=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 170ADC32771
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD06220678
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Jan 2020 05:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbgAIFO5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Jan 2020 00:14:57 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40444 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgAIFO5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Jan 2020 00:14:57 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1ipQ9n-0003Jh-P1; Thu, 09 Jan 2020 13:14:55 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ipQ9n-0003Xb-Jn; Thu, 09 Jan 2020 13:14:55 +0800
Date:   Thu, 9 Jan 2020 13:14:55 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 00/28] crypto: template instantiation cleanup
Message-ID: <20200109051455.migjpad2zileme3e@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200103035908.12048-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
Organization: Core
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> Hello,
> 
> This series makes all crypto templates initialize their spawns (i.e.
> their "inner algorithms") in a consistent way, using a consistent set of
> crypto_grab_*() helper functions.  skcipher, aead, and akcipher spawns
> already used this approach, but shash, ahash, and cipher spawns were
> being initialized differently -- causing confusion and unnecessary code.
> 
> As long as it's introducing new crypto_grab_*() functions, this series
> also takes the opportunity to first improve the existing ones to take
> the instance pointer as a parameter, so that all callers don't have to
> store it temporarily to crypto_spawn::inst.
> 
> Finally, this series also makes two changes that allow simplifying the
> error handling in template ->create() functions: (1) crypto_drop_spawn()
> is made a no-op on uninitialized instances, and (2) crypto_grab_spawn()
> is made to handle an ERR_PTR() name.
> 
> Taking advantage of these two changes, this series also simplifies the
> error handling in the template ->create() functions which were being
> updated anyway to use a new crypto_grab_*() function.  But to keep this
> series manageable, simplifying error handling in the remaining templates
> is left for later.
> 
> This series is an internal cleanup only; there are no changes for users
> of the crypto API.  I've tested that all the templates still get
> instantiated correctly and that errors seem to be handled properly.
> 
> Changed v1 => v2:
> 
>  - Made crypto_grab_cipher() an inline function in order to fix a
>    linkage error reported by the kbuild test robot.
> 
>  - Made the error paths use a style 'goto err_free_inst;' rather than
>    'goto out;' in order to be more robust against bugs where an error
>    code accidentally isn't set (which has been a problem in the past).
> 
>  - Cleaned up a couple minor things I missed in
>    skcipher_alloc_instance_simple() during the conversion to
>    crypto_cipher_spawn.
> 
> Eric Biggers (28):
>  crypto: algapi - make crypto_drop_spawn() a no-op on uninitialized
>    spawns
>  crypto: algapi - make crypto_grab_spawn() handle an ERR_PTR() name
>  crypto: shash - make struct shash_instance be the full size
>  crypto: ahash - make struct ahash_instance be the full size
>  crypto: skcipher - pass instance to crypto_grab_skcipher()
>  crypto: aead - pass instance to crypto_grab_aead()
>  crypto: akcipher - pass instance to crypto_grab_akcipher()
>  crypto: algapi - pass instance to crypto_grab_spawn()
>  crypto: shash - introduce crypto_grab_shash()
>  crypto: ahash - introduce crypto_grab_ahash()
>  crypto: cipher - introduce crypto_cipher_spawn and
>    crypto_grab_cipher()
>  crypto: adiantum - use crypto_grab_{cipher,shash} and simplify error
>    paths
>  crypto: cryptd - use crypto_grab_shash() and simplify error paths
>  crypto: hmac - use crypto_grab_shash() and simplify error paths
>  crypto: authenc - use crypto_grab_ahash() and simplify error paths
>  crypto: authencesn - use crypto_grab_ahash() and simplify error paths
>  crypto: gcm - use crypto_grab_ahash() and simplify error paths
>  crypto: ccm - use crypto_grab_ahash() and simplify error paths
>  crypto: chacha20poly1305 - use crypto_grab_ahash() and simplify error
>    paths
>  crypto: skcipher - use crypto_grab_cipher() and simplify error paths
>  crypto: cbcmac - use crypto_grab_cipher() and simplify error paths
>  crypto: cmac - use crypto_grab_cipher() and simplify error paths
>  crypto: vmac - use crypto_grab_cipher() and simplify error paths
>  crypto: xcbc - use crypto_grab_cipher() and simplify error paths
>  crypto: cipher - make crypto_spawn_cipher() take a crypto_cipher_spawn
>  crypto: algapi - remove obsoleted instance creation helpers
>  crypto: ahash - unexport crypto_ahash_type
>  crypto: algapi - fold crypto_init_spawn() into crypto_grab_spawn()
> 
> crypto/adiantum.c                  |  90 ++++++++---------------
> crypto/aead.c                      |   7 +-
> crypto/ahash.c                     |  39 ++++------
> crypto/akcipher.c                  |   7 +-
> crypto/algapi.c                    |  99 +++++--------------------
> crypto/authenc.c                   |  58 +++++----------
> crypto/authencesn.c                |  58 +++++----------
> crypto/ccm.c                       | 111 ++++++++++++-----------------
> crypto/chacha20poly1305.c          |  89 ++++++++---------------
> crypto/cmac.c                      |  35 +++++----
> crypto/cryptd.c                    |  76 ++++++--------------
> crypto/ctr.c                       |   4 +-
> crypto/cts.c                       |   9 +--
> crypto/essiv.c                     |  16 ++---
> crypto/gcm.c                       |  77 ++++++++------------
> crypto/geniv.c                     |   4 +-
> crypto/hmac.c                      |  33 +++++----
> crypto/lrw.c                       |  15 ++--
> crypto/pcrypt.c                    |   5 +-
> crypto/rsa-pkcs1pad.c              |   8 ++-
> crypto/shash.c                     |  28 +++-----
> crypto/skcipher.c                  |  46 +++++-------
> crypto/vmac.c                      |  35 +++++----
> crypto/xcbc.c                      |  40 +++++------
> crypto/xts.c                       |   9 +--
> include/crypto/algapi.h            |  64 ++++++++---------
> include/crypto/internal/aead.h     |  11 +--
> include/crypto/internal/akcipher.h |  12 +---
> include/crypto/internal/hash.h     |  70 +++++++++---------
> include/crypto/internal/skcipher.h |  15 ++--
> 30 files changed, 427 insertions(+), 743 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
