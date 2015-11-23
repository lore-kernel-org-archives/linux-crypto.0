From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 3/4] Crypto: rockchip/crypto - add crypto driver for
 rk3288
Date: Mon, 23 Nov 2015 20:51:42 +0800
Message-ID: <20151123125142.GA7709@gondor.apana.org.au>
References: <1447732847-30514-1-git-send-email-zain.wang@rock-chips.com>
 <1447732847-30514-4-git-send-email-zain.wang@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: zhengsq@rock-chips.com, hl@rock-chips.com, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: Zain Wang <zain.wang@rock-chips.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59302 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbbKWMwY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Nov 2015 07:52:24 -0500
Content-Disposition: inline
In-Reply-To: <1447732847-30514-4-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 17, 2015 at 12:00:46PM +0800, Zain Wang wrote:
>
> +static void rk_ablk_hw_init(struct rk_crypto_info *dev)
> +{
> +	struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(dev->ablk_req);
> +	struct rk_cipher_ctx *ctx = crypto_ablkcipher_ctx(tfm);
> +	u32 conf_reg = 0;
> +
> +	if (dev->mode & TDES) {
> +		dev->mode &= ~TDES;
> +		dev->mode |= RK_CRYPTO_TDES_FIFO_MODE |
> +			     RK_CRYPTO_TDES_BYTESWAP_KEY |
> +			     RK_CRYPTO_TDES_BYTESWAP_IV;
> +		CRYPTO_WRITE(dev, RK_CRYPTO_TDES_CTRL, dev->mode);
> +
> +		memcpy(dev->reg + RK_CRYPTO_TDES_IV_0, dev->ablk_req->info, 8);

Please ensure that the IV is copied back after the operation.
I know that many existing drivers are buggy in this regard but
they will be fixed soon and we will start enforcing this rule
so I don't want to add any new drivers that break this rule.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
