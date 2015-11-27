From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 3/4] Crypto: rockchip/crypto - add crypto driver for
 rk3288
Date: Fri, 27 Nov 2015 21:26:03 +0800
Message-ID: <20151127132603.GB29720@gondor.apana.org.au>
References: <1448430213-27203-1-git-send-email-zain.wang@rock-chips.com>
 <1448430213-27203-4-git-send-email-zain.wang@rock-chips.com>
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
Received: from helcar.hengli.com.au ([209.40.204.226]:47025 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754004AbbK0N0l (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 08:26:41 -0500
Content-Disposition: inline
In-Reply-To: <1448430213-27203-4-git-send-email-zain.wang@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 25, 2015 at 01:43:32PM +0800, Zain Wang wrote:
> Crypto driver support:
>      ecb(aes) cbc(aes) ecb(des) cbc(des) ecb(des3_ede) cbc(des3_ede)
> You can alloc tags above in your case.
> 
> And other algorithms and platforms will be added later on.
> 
> Signed-off-by: Zain Wang <zain.wang@rock-chips.com>
> Tested-by: Heiko Stuebner <heiko@sntech.de>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
