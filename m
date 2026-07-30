Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDEB3B7B98;
	Thu, 30 Jul 2026 07:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785395704; cv=none; b=Cotx6WLfGOt8snaMyTlUTUPoKh8mHpTZ8FNSMgFdsvqgNdD1cS0YpfD+aaYO0MFvAcvsypvEYjEgoxuHdwWcscEbSkR6kDCq+FeRWywAd9iWvEvRt30tN3wED7SRSsdzpkQEY4u8q2L0iX1tP0ue/83O6OpeZRausoQ78Ni3gHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785395704; c=relaxed/simple;
	bh=6dvQ189bS/mkT4Bw/3AKKRSkFGwIv41AWEPNCwYky8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LKcVWQQzjb5A6hrsX5i+HzMRcfHZoF9yc3WDzjUDjl6781BjtEgGZJ40a3j0unPyTAolQrDB9wmDQUy2HBleTnVaLljFQHp6/ySw032o+jMQwLlvFSgd6rqyKTK0U1Y0V6h4hAPrY86SOTG4PBEqiY/OtoMXvUqxsBmnQKgYAOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iO5GBYDb; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iO5GBYDb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=iFmF3a8oKOvK6q1DBtBfnCsqzyGBkCMQxdDFka9zy1k=; 
	b=iO5GBYDbO6LQrKue3fklhxM/Xzak43I18wdmULSx2Vnjuls8/Zbo1F2Fsk9UTowhwtprPV+eOAp
	d2ZmzPWx15wUtV3QRfuLXXmxOPwLSyy8tweTixiE1+gYtL2/8IZqGEUJU0MOCYZDcpIsFM7IDRpBH
	yWj+kb1NwIkHo0RLwgK7wyhkgWCecV+EUeG21o4kVZLn2jNr2szTthv82kvfL+cZyQfmAZ0fzgmos
	Oye5xB2qhP+2o9RBMwtkcCLn6Gn5kQC8gpggPuh/ZKljtEDGJP/E8WErKO+yk3Pamb2wYSfIAB9BN
	/lSDQ99GsHaBpgXDwG0xQtlZs/3E+amAiw6g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wpKyc-00000000RXM-2VuQ;
	Thu, 30 Jul 2026 15:14:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Jul 2026 17:14:46 +1000
Date: Thu, 30 Jul 2026 17:14:46 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "lianfeng.ouyang" <lianfeng.ouyang@starfivetech.com>
Cc: Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] hwrng: starfive: rework clk/reset teardown order
 for JHB100
Message-ID: <amr55gfWKtJESwo9@gondor.apana.org.au>
References: <20260723075206.3032-1-lianfeng.ouyang@starfivetech.com>
 <20260723075206.3032-3-lianfeng.ouyang@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723075206.3032-3-lianfeng.ouyang@starfivetech.com>

On Thu, Jul 23, 2026 at 03:52:06PM +0800, lianfeng.ouyang wrote:
>
> +	if (!wait && !mutex_trylock(&trng->lock))
> +		return -EAGAIN;
> +
> +	mutex_lock(&trng->lock);

Did you actually test this? If mutex_trylock succeeds wouldn't
the subsequent mutex_lock immediately dead-lock?

Something's wrong with your patches and Sashiko couldn't apply
them at all:

https://sashiko.dev/#/patchset/20260723075206.3032-1-lianfeng.ouyang%40starfivetech.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
