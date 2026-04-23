Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AB33BF673;
	Thu, 23 Apr 2026 09:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776936486; cv=none; b=uSFMTLapKO2BBIuwJKf6yF36hBmtrbUA/t+WVHHw2JScuoWofFV5PACEv1ts9nRqsn033y4Gxjm43FnFazZ3d0Cwrzui3w02qd+MSNNkznaRnALj7U3/lz3Em5Ua+agzjAWkDd6sGQMv21rHkyxILJFeJ8o5LJTz6TOh7UzB/6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776936486; c=relaxed/simple;
	bh=BzacJpJx6Mv7hWMuBVArx3rGcLZEAAkPx8Dw1PKSUI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hY6WntQSZGEd2+JhZ+uGI+xSiBlyRPIO7FyJ34yu8ofPT1bx6+Ik3tjQXOYl0R0S58Wxc4C5gFnOy0zE/Z8sjfYRo0v3FRlUSkJRb2A5uGejtrZlLv3WdeMg7TrXK0thtilRgor0WII7QrPDCt/b/MPYbjCL+9JumLxrHvFr3BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=HA9wc/em; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="HA9wc/em"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=Rapv8yS4wsNrL/SFFrRcNmZ3sk5XYZr49ZPPHAzwISk=; 
	b=HA9wc/emc847WK7O+aKLnmt0BhlhCK0MYcmdW6vRGEMeyTLXW9CJC8RcBJkslYEuLlIR2u3w5kz
	n86ExVfqvqESdiu/8aPZqq9vHSalykSnYBCKrTmDugKyiJCvxjS5inaYQ6nQdHgpsAZDt1GL/Y+EM
	DCaUT0teZAoMM1X/Ue0626b7/bV7ZvHyt7iqgUI6yOKmeg52DHCVM5+z3S1anLKWYWo2w8wUhw7ov
	y5ozTlTewymvmWNBr94PZwOMvPZNVIFe9wE/KpcuwBXBr5PzdjRqokNNDc9pfYw3SCd07XdScrjTK
	0zTxIgiBEJ7IFKnW3II+4asRTkJd8JQ17M0A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wFqLZ-008C8s-36;
	Thu, 23 Apr 2026 17:27:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Apr 2026 17:27:45 +0800
Date: Thu, 23 Apr 2026 17:27:45 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@kernel.org>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	"David S . Miller" <davem@davemloft.net>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ss - avoid hash and rng references
Message-ID: <aenmEQNhhw9bnxEa@gondor.apana.org.au>
References: <20260423065600.2081989-1-arnd@kernel.org>
 <aenfmxOvtHaAODqH@gondor.apana.org.au>
 <1cd6ddc3-479c-4cbf-8315-78bc53ac3a54@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cd6ddc3-479c-4cbf-8315-78bc53ac3a54@app.fastmail.com>

On Thu, Apr 23, 2026 at 11:25:19AM +0200, Arnd Bergmann wrote:
>
> Yes, I can rework the patch that way. I had considered this originally
> but decided this would end up less readable in this case because
> of the extra indentation level. The drivers already has a lot of
> #ifdef checks, so adding more of those felt more in line with the
> style used here.

If we're adding new code I prefer doing it inline instead of as
an ifdef so that we maximise compiler coverage.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
