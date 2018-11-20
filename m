Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:45638 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbeKTRAt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 12:00:49 -0500
Date: Tue, 20 Nov 2018 14:33:20 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: drop mask=CRYPTO_ALG_ASYNC from 'cipher' tfm
 allocations
Message-ID: <20181120063320.y4dltfpigssjlukc@gondor.apana.org.au>
References: <20181114201939.97592-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114201939.97592-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 14, 2018 at 12:19:39PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> 'cipher' algorithms (single block ciphers) are always synchronous, so
> passing CRYPTO_ALG_ASYNC in the mask to crypto_alloc_cipher() has no
> effect.  Many users therefore already don't pass it, but some still do.
> This inconsistency can cause confusion, especially since the way the
> 'mask' argument works is somewhat counterintuitive.
> 
> Thus, just remove the unneeded CRYPTO_ALG_ASYNC flags.
> 
> This patch shouldn't change any actual behavior.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/s390/crypto/aes_s390.c                               | 2 +-
>  drivers/crypto/amcc/crypto4xx_alg.c                       | 3 +--
>  drivers/crypto/ccp/ccp-crypto-aes-cmac.c                  | 4 +---
>  drivers/crypto/geode-aes.c                                | 2 +-
>  drivers/md/dm-crypt.c                                     | 2 +-
>  drivers/net/wireless/cisco/airo.c                         | 2 +-
>  drivers/staging/rtl8192e/rtllib_crypt_ccmp.c              | 2 +-
>  drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c | 2 +-
>  drivers/usb/wusbcore/crypto.c                             | 2 +-
>  net/bluetooth/smp.c                                       | 6 +++---
>  net/mac80211/wep.c                                        | 4 ++--
>  net/wireless/lib80211_crypt_ccmp.c                        | 2 +-
>  net/wireless/lib80211_crypt_tkip.c                        | 4 ++--
>  net/wireless/lib80211_crypt_wep.c                         | 4 ++--
>  14 files changed, 19 insertions(+), 22 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
