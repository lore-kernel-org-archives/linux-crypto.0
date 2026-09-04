Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9477C449B03;
	Fri,  4 Sep 2026 09:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788515726; cv=none; b=bakGXjWglIKUIzxLkP6h1m7Ca2IU0Cl4doMoHUGV1uwLZ7QC0YFoi1LZg7oG41uKd+kXytQKFrPFJ3F9mGnCXU2VYKkx0aHWbhu1t8X682TuIEvCSH48XuFsHPfQd7zh2o0JZkJNl1oxyht5biHyO3iI3gTWyL7sP8O612+9qbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788515726; c=relaxed/simple;
	bh=sqVm10EovwIEx/ZCKTxvdIOdmcSmDoM36Cc/JF21Ty0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BY0Fbl7cG8Jz7UnZ3PPF6pcsUsUeEKlvabrnu1/v3G97tuTTgBS/ij5YGlQrcA4U/VVOSX+0Z+oMfNchujCCpuz9gOLVM0EzoqLIXPa8U6Ira3Qp49RAy4pTOPQQiqi+bXaWMeStTTrbwrU1kHboHCCBXw0z2G5sgdRrmWHBXZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=L/KyITLH; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="L/KyITLH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6o93EzZgArFEXso70k/zel9WBKSefg4X2XkOXRWKMQc=; 
	b=L/KyITLHZr1yZhJVD4DlynQK0Je1HVSDjG4vdWo5d+f28euKGjwEqnROtxJ9rubPvFFljf4p7Ty
	3ZUXkeqTIk/LDVH5z13EOwHiNfXlEYVzdLYZuEsvFYQPiSQuxJnyrkjZcxp9RT6q+GGnNAKi4P5dV
	L45sH8IHI7lRqfoLI13RoxAUpmF83bC1WTnFGwEsFW52BuFR/J9VZB2hj0jCb34Q1Q32zm5k942bB
	ADllkQvpLFyHB1LjpiV3YkNdx9q48Iyte3wRNHmKRFqQ6/VFXPMhKbTrXb8vNaf+sH2vca8lQ01Sb
	rISYWkje5i/CpLx/iXH069tuWM2vvfJcAYHQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x2Qda-0000000An7t-1KVg;
	Fri, 04 Sep 2026 17:55:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 04 Sep 2026 19:55:10 +1000
Date: Fri, 4 Sep 2026 19:55:10 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
	"David S. Miller" <davem@davemloft.net>,
	Heiko Stuebner <heiko@sntech.de>,
	"moderated list:ARM/Rockchip SoC support" <linux-arm-kernel@lists.infradead.org>,
	"open list:ARM/Rockchip SoC support" <linux-rockchip@lists.infradead.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: rockchip: pass crypto_info to irq handler
Message-ID: <apqVfhB5JHcBEHaM@gondor.apana.org.au>
References: <20260811044916.160856-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811044916.160856-1-rosenp@gmail.com>

On Mon, Aug 10, 2026 at 09:49:16PM -0700, Rosen Penev wrote:
> The irq handler takes the platform device and calls
> platform_get_drvdata() to recover the driver data.  Pass the
> driver data directly as the devm_request_irq() argument instead,
> dropping the platform_get_drvdata() call.
> 
> Assisted-by: opencode:deepseek-v4-flash-free
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/rockchip/rk3288_crypto.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
