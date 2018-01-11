From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/7] crypto: ccree: add ablkcipher support
Date: Thu, 11 Jan 2018 11:03:23 +0100
Message-ID: <2378888.JBO5RdML52@tauon.chronox.de>
References: <1515662239-1714-1-git-send-email-gilad@benyossef.com> <1515662239-1714-4-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ofir Drang <ofir.drang@arm.com>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58190 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932394AbeAKKD0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 05:03:26 -0500
In-Reply-To: <1515662239-1714-4-git-send-email-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 11. Januar 2018, 10:17:10 CET schrieb Gilad Ben-Yossef:

Hi Gilad,

> +	// verify weak keys
> +	if (ctx_p->flow_mode == S_DIN_to_DES) {
> +		if (!des_ekey(tmp, key) &&
> +		    (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_WEAK_KEY)) {
> +			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
> +			dev_dbg(dev, "weak DES key");
> +			return -EINVAL;
> +		}
> +	}
> +	if (ctx_p->cipher_mode == DRV_CIPHER_XTS &&
> +	    xts_check_key(tfm, key, keylen)) {
> +		dev_dbg(dev, "weak XTS key");
> +		return -EINVAL;
> +	}
> +	if (ctx_p->flow_mode == S_DIN_to_DES &&
> +	    keylen == DES3_EDE_KEY_SIZE &&
> +	    cc_verify_3des_keys(key, keylen)) {
> +		dev_dbg(dev, "weak 3DES key");
> +		return -EINVAL;
> +	}

For the DES key, wouldn't it make sense to use __des3_ede_setkey?

Note, I would plan to release a patch for review to change that function to 
disallow key1 == key2 or key1 == key3 or key2 == key3 in FIPS mode.

Ciao
Stephan
