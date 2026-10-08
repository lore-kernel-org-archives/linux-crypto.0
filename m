Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40757468C3E;
	Thu,  8 Oct 2026 08:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791448312; cv=none; b=O525WfYBtd5/zk5ejlFtjtTJMlCe1yUOBw01HOIwNsf9Kab7nQgNFz5FYiM4mD4DE+L/WvT/x2zzvqeZYW8yb/nMn6GXP9RBEgucMQE91NMu3fQJzbhPrfuDIocC2Pw2BYE2JoUrQ7pBlj0CK+Dgq8Icqu6XkOCLbi0BmiBiJo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791448312; c=relaxed/simple;
	bh=TUhGANlx7UoX2HyhAoz4k5uP7Vv4W0G24nD9nK7KJKY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tpQxu1y2Kt0twT62n/bxV8g9ts/q/YihwfLweUHuF+TwjOz6MvhenFjd0lgzwpChuWJFzxXQOT4Niv5AnLp7iGLqZxD8GklWWh+ctaz6BG6qMrcdWH3wjFE7T+FQyCMnGCorg3JDCelzAJDtV0viXa8EBK7QeMyCf1MzNGFs3lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=IfMF5kEO; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="IfMF5kEO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=UagUVrbSdBOzKGzY2pDlX0dFXH7FnLY3MCWxkthYFrU=; 
	b=IfMF5kEOhfEgf267uSPaosPYppa/BbWjH0czEIGCfHI/aQDGeuJUTG9Wdq4bsifwZf/4aKe3zsh
	FypUVlV7YGPkYvc8bAIpQyFKqxluJ/ddxBUcqiwxlubKK4q03z5JMxlaJhHipNHbl3MjdMpnYW94z
	FWHWhkYSdrn+2eiq52pbaakupXF4NotBDE6Uq4njG8Sh3EwBBpZ5A7ifYcKapYfCRiPYOovD8cjII
	VvvthmA4mDXxfRtoIuSKey0pdcPmnu9QcdoG/hGAyjia+K19aSOy3bac6jQMJwchRQcd3rlW+waqm
	Vip3ZWpo2Cja5/A4aWGeufbZzFCDMDJ0dmbQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xEjXN-00000001o2d-39kN;
	Thu, 08 Oct 2026 16:31:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 08 Oct 2026 19:31:37 +1100
Date: Thu, 8 Oct 2026 19:31:37 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <blum@kernel.org>
Cc: Olivia Mackall <olivia@selenic.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Linus Walleij <linusw@kernel.org>, Can Peng <pengcan@kylinos.cn>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: stm32 - reuse clock rate in
 stm32_rng_clock_freq_restrain()
Message-ID: <asdU6Vnk6-BRpXOU@gondor.apana.org.au>
References: <20261001211612.38124-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001211612.38124-2-blum@kernel.org>

On Thu, Oct 01, 2026 at 11:16:10PM +0200, Thorsten Blum wrote:
> Reuse clock_rate and avoid calling clk_get_rate() again. Remove the
> extra space before the colon while at it.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>
> ---
>  drivers/char/hw_random/stm32-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
