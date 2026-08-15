Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B4A284B37;
	Sat, 15 Aug 2026 01:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786756840; cv=none; b=fTSm3DBbgcxk/PejE7qBlIF38aa3PlmzVqU7YeqFVBQ7F2XHf4eiq3PTSPhhhLmnL6yy+MeUhXyPho0hx7SHaBB5SuQVHSuIy+fky0D/xUrAoG38LtqoIuT+6A0zHhpVXAOXcWfMUaiA+LRLAfL+kC7HYsGkoB/QDG33XeSNr6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786756840; c=relaxed/simple;
	bh=mZxPHWIHP5JTkkHZmRLgYytobDiTTPdETr+O4nYU5lw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u5grvUuw3WEoNPiZHCSduvMHmy7r8wMi78yXzoFPPT8duvK9R4yU6JZygvv4OYhBzPLQneIMcbqvdNBajbFnqWzxVA5fKK5II6BW5pcRdc17ScDPU/qavimf0Cu25P6sMkWCTCY3KYq/jMDTvRCZGAPxuX7ReG9CiKfBozSCO9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=W/x0KZSa; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="W/x0KZSa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=xt5PtSeLYlLIx3Mn5jqRqeXE+UdKaRVwp9ALI3beCOE=; 
	b=W/x0KZSaI9by+q7A3jp0xayM0DEk8uEVBt817VN/jYgRf7IEDccg0j8p/6P8Cv3Hxc4yOXX9jVB
	YDgozbecXSYaC8qmCQcnKca+X/zaePlMjMZDmI+/hcTOUNbsk/QS8W/EDmMM8mrEJyJCg3JZQaBph
	Fc7UYM38qQhahxxhYtdZUQIunskvkoTyHrvSjZBjRwsHPmh3i/0nflVpFuaIQnNOJfGSmT3EXJVgz
	0KIVqbVN681+gN72qgip9OKaTfhnndGGSk+/fdNmytPa/mh+xCbvqctAZZ59bkS0e76OmyS5zBimP
	IRIt/0tByw7qKiFS4C1nge97pH77q05XYmsQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wv34a-000000054rt-3lxl;
	Sat, 15 Aug 2026 09:20:33 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Aug 2026 11:20:32 +1000
Date: Sat, 15 Aug 2026 11:20:32 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ccree: fix autosuspend cleanup during teardown
Message-ID: <an--4DCWClWpPJwB@gondor.apana.org.au>
References: <20260808091734.2727295-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260808091734.2727295-1-lgs201920130244@gmail.com>

On Sat, Aug 08, 2026 at 05:17:34PM +0800, Guangshuo Li wrote:
>
> diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_driver.c
> index 061e68a31c36..b127ec64a087 100644
> --- a/drivers/crypto/ccree/cc_driver.c
> +++ b/drivers/crypto/ccree/cc_driver.c
> @@ -567,6 +567,7 @@ static int init_cc_resources(struct platform_device *plat_dev)
>  post_regs_err:
>  	fini_cc_regs(new_drvdata);
>  post_pm_err:
> +	pm_runtime_dont_use_autosuspend(dev);
>  	pm_runtime_put_noidle(dev);
>  	pm_runtime_disable(dev);
>  	pm_runtime_set_suspended(dev);

Sashiko is asking about the order of these pm_runtime calls, could
you please investigate?

https://sashiko.dev/#/patchset/20260808091734.2727295-1-lgs201920130244%40gmail.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
