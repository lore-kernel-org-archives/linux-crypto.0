Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B78249F9;
	Fri, 18 Jul 2025 10:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836391; cv=none; b=uEoaskmKH+G+4K1I/+GiZRms70b8JcMYuqe1aO4SWfERt4GKAYHwQQr+JZ/HS+9KbD9ISGz7Eg49X4uxzxCNYsWEAoRUleZlBjErdG7UF9shAeU51z5Csg7vy8afIGmevWphDGoTuN/v8SMYI1Zv1LWbikA3a8svdw6c++ATPTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836391; c=relaxed/simple;
	bh=xuyX/CuEeMl4orPPPsGHRb6ykETpEfAXJsfUTFOeNTs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8fbZT3IxT+OgiXlzOxX+tZIKpjg9kZMYTHNKKJs9xAh4xpztwFiPe8ZY4vHdOb3+9MPPlTzzu5EkyTPNzpwUmk/EWfeKBFz+7N/WyP2W3+lZ1YICYb/TctASiNSzKFDxMpKJtWEom4GxvcdT5YrHdAI7udiLK/kKGDY/2N1YiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gl6/Zd5H; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gl6/Zd5H"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZAzXiiY/YIuQ/9uY0l8462fgPlzoh4f7KxWN0ebvqKE=; b=gl6/Zd5HCQjexfoJQ5QZ7wWbAN
	hbTSGnGqU1GFUKmrbFD5jj5vmYPGtEhp2sd/JvCtZM6Ey182276LgB1rE6/Y4aUV+YP9bKd8D1GaR
	zFO93R0YQ/tC9nTkcRMnuZTdZ9Df6EvDXbhwS0lu+KiAp/tqI1sLtvSsK9OUIfEHv9h1Zgc9fUTSy
	FhsdvvJ9w0SYBxvit/U5QBdoDkz+FyLZGvo+Wpy+Ut0aSr8T8A7G2SLLgJJQxnRDa/M20K8u0rMGO
	zTuIwFdckQDDn1z7Fu0M5YEidFHCWP3HUT1OuutOK5JjiGBlgmO95iGw2o9kaSi+0Jbt6qJZK+hZB
	84nBPNsA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uciYM-007yZr-27;
	Fri, 18 Jul 2025 18:58:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 20:58:55 +1000
Date: Fri, 18 Jul 2025 20:58:55 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Hadar Gat <hadar.gat@arm.com>, Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Avi Fishman <avifishman70@gmail.com>,
	Tomer Maimon <tmaimon77@gmail.com>,
	Tali Perry <tali.perry1@gmail.com>,
	Patrick Venture <venture@google.com>, Nancy Yuen <yuenn@google.com>,
	Benjamin Fair <benjaminfair@google.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@baylibre.com>,
	Marek Vasut <marex@denx.de>,
	Gatien Chevallier <gatien.chevallier@foss.st.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
	openbmc@lists.ozlabs.org, linux-rockchip@lists.infradead.org,
	linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH 05/80] hwrng: Remove redundant
 pm_runtime_mark_last_busy() calls
Message-ID: <aHoo71TbepQD2Nsd@gondor.apana.org.au>
References: <20250704075225.3212486-1-sakari.ailus@linux.intel.com>
 <20250704075359.3217036-1-sakari.ailus@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704075359.3217036-1-sakari.ailus@linux.intel.com>

On Fri, Jul 04, 2025 at 10:53:59AM +0300, Sakari Ailus wrote:
> pm_runtime_put_autosuspend(), pm_runtime_put_sync_autosuspend(),
> pm_runtime_autosuspend() and pm_request_autosuspend() now include a call
> to pm_runtime_mark_last_busy(). Remove the now-reduntant explicit call to
> pm_runtime_mark_last_busy().
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> The cover letter of the set can be found here
> <URL:https://lore.kernel.org/linux-pm/20250704075225.3212486-1-sakari.ailus@linux.intel.com>.
> 
> In brief, this patch depends on PM runtime patches adding marking the last
> busy timestamp in autosuspend related functions. The patches are here, on
> rc2:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
>                 pm-runtime-6.17-rc1
> 
>  drivers/char/hw_random/atmel-rng.c     | 1 -
>  drivers/char/hw_random/cctrng.c        | 1 -
>  drivers/char/hw_random/mtk-rng.c       | 1 -
>  drivers/char/hw_random/npcm-rng.c      | 1 -
>  drivers/char/hw_random/omap3-rom-rng.c | 1 -
>  drivers/char/hw_random/rockchip-rng.c  | 3 ---
>  drivers/char/hw_random/stm32-rng.c     | 1 -
>  7 files changed, 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
