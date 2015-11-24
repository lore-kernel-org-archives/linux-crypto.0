From: Zain <zain.wang@rock-chips.com>
Subject: Re: [PATCH v4 3/4] Crypto: rockchip/crypto - add crypto driver for
 rk3288
Date: Tue, 24 Nov 2015 08:48:54 +0800
Message-ID: <5653B3F6.9080006@rock-chips.com>
References: <1447732847-30514-1-git-send-email-zain.wang@rock-chips.com>
 <1447732847-30514-4-git-send-email-zain.wang@rock-chips.com>
 <20151123125142.GA7709@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: zhengsq@rock-chips.com, hl@rock-chips.com, davem@davemloft.net,
	mturquette@baylibre.com, heiko@sntech.de, pawel.moll@arm.com,
	ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
	galak@codeaurora.org, linux@arm.linux.org.uk, mark.rutland@arm.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
	eddie.cai@rock-chips.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.133]:55301 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843AbbKXAtI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Nov 2015 19:49:08 -0500
In-Reply-To: <20151123125142.GA7709@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>



On 2015=E5=B9=B411=E6=9C=8823=E6=97=A5 20:51, Herbert Xu wrote:
> On Tue, Nov 17, 2015 at 12:00:46PM +0800, Zain Wang wrote:
>> +static void rk_ablk_hw_init(struct rk_crypto_info *dev)
>> +{
>> +	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(dev->ab=
lk_req);
>> +	struct rk_cipher_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);
>> +	u32 conf_reg =3D 0;
>> +
>> +	if (dev->mode & TDES) {
>> +		dev->mode &=3D ~TDES;
>> +		dev->mode |=3D RK_CRYPTO_TDES_FIFO_MODE |
>> +			     RK_CRYPTO_TDES_BYTESWAP_KEY |
>> +			     RK_CRYPTO_TDES_BYTESWAP_IV;
>> +		CRYPTO_WRITE(dev, RK_CRYPTO_TDES_CTRL, dev->mode);
>> +
>> +		memcpy(dev->reg + RK_CRYPTO_TDES_IV_0, dev->ablk_req->info, 8);
> Please ensure that the IV is copied back after the operation.
> I know that many existing drivers are buggy in this regard but
> they will be fixed soon and we will start enforcing this rule
> so I don't want to add any new drivers that break this rule.
Thanks your responding, I will fix it in v5.
>
> Thanks,
