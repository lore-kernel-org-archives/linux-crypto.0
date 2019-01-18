Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48496 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfARK5S (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 05:57:18 -0500
Date: Fri, 18 Jan 2019 18:57:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 00/11] crypto: misc fixes/cleanups
Message-ID: <20190118105717.rnel2yq3tetefts6@gondor.apana.org.au>
References: <20190110201802.82442-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190110201802.82442-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 10, 2019 at 12:17:51PM -0800, Eric Biggers wrote:
> Some more miscellaneous crypto fixes and cleanups:
> 
> - Patch 1-6: fix sparse warnings in 6 files.
> - Patch 7: fix unaligned memory access in tgr192.
> - Patch 8-11: a few other cleanups.
> 
> Eric Biggers (11):
>   crypto: gcm - use correct endianness type in gcm_hash_len()
>   crypto: rsa-pkcs1pad - include <crypto/internal/rsa.h>
>   crypto: streebog - use correct endianness type
>   crypto: testmgr - handle endianness correctly in alg_test_crc32c()
>   crypto: user - forward declare crypto_nlsk
>   crypto: x86/aesni-gcm - make 'struct aesni_gcm_tfm_s' static const
>   crypto: tgr192 - fix unaligned memory access
>   crypto: stat - remove unused mutex
>   crypto: af_alg - make some functions static
>   crypto: af_alg - use list_for_each_entry() in af_alg_count_tsgl()
>   crypto: af_alg - remove redundant initializations of sk_family
> 
>  arch/x86/crypto/aesni-intel_glue.c   | 34 +++++++++++-----------------
>  crypto/af_alg.c                      | 33 ++++++++++-----------------
>  crypto/crypto_user_stat.c            |  4 ----
>  crypto/gcm.c                         |  2 +-
>  crypto/rsa-pkcs1pad.c                |  1 +
>  crypto/streebog_generic.c            |  2 +-
>  crypto/testmgr.c                     | 10 ++++----
>  crypto/tgr192.c                      |  6 ++---
>  include/crypto/if_alg.h              |  7 ------
>  include/crypto/internal/cryptouser.h |  2 ++
>  include/crypto/streebog.h            |  2 +-
>  11 files changed, 39 insertions(+), 64 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
