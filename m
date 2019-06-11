Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65CDC4321A
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 17:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A16F320896
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560275996;
	bh=RIvt6aFwbzoPJ/O4E8G+pHOOUutW3QegOcElFotzJEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=IofEZERuaxVYLjZaDcFoKfv6Eja+I4/2EXLebsI4aMgyvCHwPDbp1ZQqXkVR7Gtz1
	 JP64YPFGfpp5uu99s4/y0KKe6xo9kd1CQopUqpwVXbtLyY74PNkq9nzwaUQHfgQlmf
	 Bnbx9v/miCXsAw2r2gR/MNjOcwC6WEaKRIc8cnvc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405972AbfFKR74 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 13:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406702AbfFKR7z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 13:59:55 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF68C2086D;
        Tue, 11 Jun 2019 17:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560275995;
        bh=RIvt6aFwbzoPJ/O4E8G+pHOOUutW3QegOcElFotzJEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TU8D9iBBu0IHWSFq5XfEoSvZsAR5tps/qUdvgwHUg8ZWHxOL0CeLU/44LIIo4hfGr
         4U9/xjEh2rfJxwLacPNd0ldTwZ3dDCY5SiEHNdkRP3KWUgfhEMHMsK6L5mh2sEbz8h
         +5bOx3xNjQ3STnalhV+8tEUyBJsX+Ltf2rECAK6s=
Date:   Tue, 11 Jun 2019 10:59:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3 3/7] net/lib80211: move WEP handling to ARC4 library
 code
Message-ID: <20190611175952.GC66728@gmail.com>
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
 <20190611134750.2974-4-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611134750.2974-4-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 11, 2019 at 03:47:46PM +0200, Ard Biesheuvel wrote:
> The crypto API abstraction is not very useful for invoking ciphers
> directly, especially in the case of arc4, which only has a generic
> implementation in C. So let's invoke the library code directly.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  net/wireless/Kconfig              |  1 +
>  net/wireless/lib80211_crypt_wep.c | 49 +++++---------------
>  2 files changed, 13 insertions(+), 37 deletions(-)
> 
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> index 6310ddede220..6d9c48cea07e 100644
> --- a/net/wireless/Kconfig
> +++ b/net/wireless/Kconfig
> @@ -213,6 +213,7 @@ config LIB80211
>  
>  config LIB80211_CRYPT_WEP
>  	tristate
> +	select CRYPTO_LIB_ARC4
>  
>  config LIB80211_CRYPT_CCMP
>  	tristate
> diff --git a/net/wireless/lib80211_crypt_wep.c b/net/wireless/lib80211_crypt_wep.c
> index 20c1ad63ad44..9a4e4653fe64 100644
> --- a/net/wireless/lib80211_crypt_wep.c
> +++ b/net/wireless/lib80211_crypt_wep.c
> @@ -11,6 +11,7 @@
>   */
>  
>  #include <linux/err.h>
> +#include <linux/fips.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
> @@ -22,7 +23,7 @@
>  
>  #include <net/lib80211.h>
>  
> -#include <linux/crypto.h>
> +#include <crypto/arc4.h>
>  #include <linux/crc32.h>
>  
>  MODULE_AUTHOR("Jouni Malinen");
> @@ -35,51 +36,30 @@ struct lib80211_wep_data {
>  	u8 key[WEP_KEY_LEN + 1];
>  	u8 key_len;
>  	u8 key_idx;
> -	struct crypto_cipher *tx_tfm;
> -	struct crypto_cipher *rx_tfm;
> +	struct arc4_ctx tx_ctx;
> +	struct arc4_ctx rx_ctx;
>  };
>  
>  static void *lib80211_wep_init(int keyidx)
>  {
>  	struct lib80211_wep_data *priv;
>  
> +	if (fips_enabled)
> +		return NULL;
> +
>  	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
>  	if (priv == NULL)
> -		goto fail;
> +		return NULL;
>  	priv->key_idx = keyidx;
>  
> -	priv->tx_tfm = crypto_alloc_cipher("arc4", 0, 0);
> -	if (IS_ERR(priv->tx_tfm)) {
> -		priv->tx_tfm = NULL;
> -		goto fail;
> -	}
> -
> -	priv->rx_tfm = crypto_alloc_cipher("arc4", 0, 0);
> -	if (IS_ERR(priv->rx_tfm)) {
> -		priv->rx_tfm = NULL;
> -		goto fail;
> -	}
>  	/* start WEP IV from a random value */
>  	get_random_bytes(&priv->iv, 4);
>  
>  	return priv;
> -
> -      fail:
> -	if (priv) {
> -		crypto_free_cipher(priv->tx_tfm);
> -		crypto_free_cipher(priv->rx_tfm);
> -		kfree(priv);
> -	}
> -	return NULL;
>  }
>  
>  static void lib80211_wep_deinit(void *priv)
>  {
> -	struct lib80211_wep_data *_priv = priv;
> -	if (_priv) {
> -		crypto_free_cipher(_priv->tx_tfm);
> -		crypto_free_cipher(_priv->rx_tfm);
> -	}
>  	kfree(priv);
>  }

How about changing lib80211_wep_deinit() to use kzfree()?  As a result of
changing to the ARC4 library, the arc4_ctx is no longer zeroed.  Of course it's
not any worse than it was before since the raw key is already in
lib80211_wep_data too, but it really ought to be kzfree()...

- Eric
