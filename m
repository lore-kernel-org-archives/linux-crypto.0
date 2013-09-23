From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] ARM: tegra: remove tegra_chip_uid()
Date: Tue, 24 Sep 2013 06:09:21 +1000
Message-ID: <20130923200921.GD21243@gondor.apana.org.au>
References: <1379345659-9528-1-git-send-email-swarren@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Linus Walleij <linus.walleij@linaro.org>,
	Stephen Warren <swarren@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:50114 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753328Ab3IWUJb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Sep 2013 16:09:31 -0400
Content-Disposition: inline
In-Reply-To: <1379345659-9528-1-git-send-email-swarren@wwwdotorg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 16, 2013 at 09:34:19AM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
> 
> Following commit f5b38c5 "crypto: tegra - use kernel entropy instead
> of ad-hoc", this function is no longer used. It's also only accurate
> for Tegra20 and not later SoCs. So, remove it.
> 
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
