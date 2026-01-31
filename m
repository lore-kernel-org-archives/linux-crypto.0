Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D95623A566;
	Sat, 31 Jan 2026 02:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769827708; cv=none; b=GNbKbec6dmig0MZMw8bJEu9h6X1tcLhxWnK/JmlygTCKdkcENigG1g1KCeDZnMr/D11Iur3ENLxBnuVtdUwYL2HrCQ7kKGGc3N52rIhiztv4Jju0bc3v05WtT7W8cLXwuSSD2sm7LVyIiXcDOURQ/TzrBxuDchfg9G2Zkm4lj6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769827708; c=relaxed/simple;
	bh=xB4GPsw70MLRoqlmW81dCHr8v6g+QVtaNoVVsNSWMHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvUwTcR8QJYkBQlRALHRyLlm0RvaidgojaW/g75Xm2rYVgD1PWcShHztKq0wPGmY7UQccpt0y2OMcBHK03N7cxM+4Td8owrnPrGduzJ5sEtUyiaboXg8DF6WNZ06Swwt8SRd04/6Jvv3NsuE4fcC3Y8c+tx2ZGhXMwrjwRkN/wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=tR1Oo71R; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="tR1Oo71R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ukxXi4zhad6/j2DRawSz6lsJzAFmzLHj4owMxb/Vd60=; 
	b=tR1Oo71RiIkttFIYp8iuzzYv7bnnn0MptaO8EQqZpGYhCC2yXVB+ju4VL7VgtOkMmmv21P7f5lM
	EpceMgevt+9OmXoCSAaYavKEjyzsp51gMPSjrIKjRsi2xJ6U/53TDmcL6yrm5kum2682qRyuVFRgB
	DgolwlubD4sUycQbZbiC7BoS4k5mPniIedYF9r8WrvXAW4pQjFX7k/zu/Op9GiTKF8m596q36HPUS
	X3FImIf11wKX6YV9rinTL8ElSHqrQsa9L64yXm0Ngwsmh0ocPsDvUa+d+lHqC5SDY8HP83sNc2IGF
	JR40d3lAj66v5SQOW/REb85+uPrcN9yG9DUg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vm11w-003RrO-2V;
	Sat, 31 Jan 2026 10:48:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 31 Jan 2026 10:48:12 +0800
Date: Sat, 31 Jan 2026 10:48:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: omap - Use sysfs_emit in sysfs show functions
Message-ID: <aX1tbHTaMSyYzdR9@gondor.apana.org.au>
References: <20260109123640.170491-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109123640.170491-1-thorsten.blum@linux.dev>

On Fri, Jan 09, 2026 at 01:36:40PM +0100, Thorsten Blum wrote:
> Replace sprintf() with sysfs_emit() in sysfs show functions.
> sysfs_emit() is preferred to format sysfs output as it provides better
> bounds checking.  No functional changes.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/omap-aes.c  | 3 ++-
>  drivers/crypto/omap-sham.c | 5 +++--
>  2 files changed, 5 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
