Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615A9178CDE;
	Sat, 26 Oct 2024 06:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925889; cv=none; b=tPZD+LEAJC2tdY5KiayaypMR9Gfa4hnXLz1ABvtEy41RBY96tQmyzZqzH0hAqW0Hg8FrnYLaiU3AnJE41XiG9euFbJpnr/Oout0ZSzcposWVcz0bcQwUuHndn0ADNLFwshfz0BQe+/TT9MONlTkHd8WLKmir4tM4s5IEL55suX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925889; c=relaxed/simple;
	bh=ehjlccegeqAznK3YtFxHa4YMv/c6q7URcRGfamjN8os=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dg6evD2WDnwLgZYTxf/OClHjnyUMKghEpAOynrHSIR1O3ZBAtTtStXGy5oFXqmH2Wt+NQN9nRZwruNcOGmG4Hkmy7vWsZ9aOJF/+/eqm1ot4oyTLRy3EDP/zvjyS/JntnKJP0HtrTVJiolwt+oo6t7xZr66zuyEDLdD5DzPBDOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VvUEh39G; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VvUEh39G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WmbkO/M1ksqD8dcPP4V0kRzHXBQ/i/QNQ3fByAU03I8=; b=VvUEh39GDhvH6IgM0Jjr9i39FK
	JQdLB1OnOOJXNFWGmURPaFDxp02icPHncbmdIhb/iLTLxR6utpP6eqafbboch1kt7GVeKs9X/ETsJ
	sGGFqcxEF74ZEezIChA/I7qY0ktLae3ye/NV7Qt2uwUVWQuO9KnvAoQZCxNYY/Oss0d9QrYyz66FO
	iIY17G6dPmLePHwVkDblbhD7WhfGIpcpTlGP0huTXaCVpsmQmHLjqVskOpMvBIMaKOA2zoEGzflln
	VT1cFD4alObBzqw2pfPJc1HDmxcU4Ac7kQ9ASoLagFghH46fv/8ZeRvgdGPNA8k2owuebjEpDImcH
	3nJwHsbA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4akK-00CFyc-1g;
	Sat, 26 Oct 2024 14:58:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:58:00 +0800
Date: Sat, 26 Oct 2024 14:58:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: drbg - Use str_true_false() and
 str_enabled_disabled() helpers
Message-ID: <ZxyS-BPQ-EITExwU@gondor.apana.org.au>
References: <20241016135727.76180-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016135727.76180-2-thorsten.blum@linux.dev>

On Wed, Oct 16, 2024 at 03:57:28PM +0200, Thorsten Blum wrote:
> Remove hard-coded strings by using the helper functions str_true_false()
> and str_enabled_disabled().
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/drbg.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
