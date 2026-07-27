Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E47E201004;
	Mon, 27 Jul 2026 00:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785112463; cv=none; b=kPw6E0rDawKHnWu/MCoC6g4f6YQhHmN7BLhm+mgz1k5mCvcmYZuCypZ0868MZMKg1ef93iclqPQN/DzC+VHwBVOnzFDuJdxepkAMcsckNewDduef3GNBLl+E5VvWWIuBuM2PKh3fT//vGStNOCX+M1OQxQPgHTud9CDaJcaoWbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785112463; c=relaxed/simple;
	bh=zus58tP39ZjCpx6PcuJ42bVLy2iDI2O9i+L5cR1UDxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TiNSacphAfMWY2TqDa7694y3VvALmpmlbm20nJSfJHFiqZgMoLmRud4Kz4Qr70FDxSGvxZCBkqPntZljaDewWu9609QhSSgkNYKut9PkeqMPHwUGA7rE5onWvEWgpWxPBr/9z9TFKy2gParVA1SDBMmsafnY/Wlv1RyCq20D/80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=jbHfKckc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="jbHfKckc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=vBaBnDUy/q/jKxHlN9TglbgjTQzhdH+4Xr5fdv/vNEQ=; 
	b=jbHfKckcJV6qIguQYTPkU3DtI0hIZMNKpZ49vdDkWFIbyA4XKGHp2w3k0+42tsYC+E2FxAua2If
	0UKi7u8UAg5wfDBYjHaG4o3NMu9BLD+T8eReCGCKB4x4B7KVmfQ78pnjEWw24VyfG7OxvjB+7hndz
	HsEg/B1GO4RIKwfpLPULJI3F2Rbb0KwjjqqXpiS95SbJ0nCE8tWStU+XWdIKxErjkA4ScpAlaVnbt
	1VERRA+pBTwdQXtFZILNTak+WEnI1Oj29NW3NJz53AMB9jEs3GzMfiSJ44q7gmeediIZV2lYmghmi
	wTFYS4NkXr9gZ6GKfkHpQY6dj2E+Wb0PXNIA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo9IQ-0000000Gyyp-0497;
	Mon, 27 Jul 2026 08:34:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 10:34:18 +1000
Date: Mon, 27 Jul 2026 10:34:18 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: omap-sham: use
 devm_platform_get_and_ioremap_resource
Message-ID: <amanip1A6Uoy3pr-@gondor.apana.org.au>
References: <20260715220013.416122-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715220013.416122-1-rosenp@gmail.com>

On Wed, Jul 15, 2026 at 03:00:13PM -0700, Rosen Penev wrote:
> Replace the open-coded omap_sham_get_res_of()/omap_sham_get_res_pdev()
> helpers and the #ifdef CONFIG_OF machinery with the managed
> devm_platform_get_and_ioremap_resource(), platform_get_irq() and
> device_get_match_data() helpers. The omap_sham_pdata_omap2 fallback is
> kept for the non-DT (legacy platform_device) case. This removes the
> manual resource copy and ioremap, simplifying probe.
> 
> Assisted-by: opencode:hy3-free
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/omap-sham.c | 104 +++++++------------------------------
>  1 file changed, 18 insertions(+), 86 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
