Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3218A3E8C5E;
	Fri, 22 May 2026 12:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779453285; cv=none; b=ngLxMgxmgTkDYw6Kx3G4asjHzEPRqrUa88BOe3d4Jr59V9WWyZ4ghuKmOqWvDdk4Ox58AYri/eul3cRdH423yGSKQCEfuTqaksvClxAz8KxvI0iYtm+FmPnPYK5GdNPXjzUHX0INZT0k+hCt5/0OcoD4hCQixnGJ8lrnrhdB7zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779453285; c=relaxed/simple;
	bh=oiP4HAVWyJ91VwT5O4HzBov6ubQBuBs4t0gCX1u3deg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gWcVBfqFH8oqxIZGyJGNuC1qcMT+3UvsUJhU50nRuGOjB+05LC1EXnJjwjnhSp1JHJIEnqNa2/o4RAed+uk/TtbuPsv0XKDYnGPmd2tiFqRhLaX4KuopU+p2Jw6CtFKjcrNYOoF2Lf1byTKCxNTk8s8NMcSZVXjqMZScqFiUR5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=q1HQReT5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="q1HQReT5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=nVnfsqFnVoL/LfU4unuy+gHJsKITPJBpdh8g7JEJEr0=; 
	b=q1HQReT5aHBv5V2Xko1daCAce2JEj8/XgRwSxKl++H16GPPW0ihbJIbvGgGqO5AtqdDoSywOHeY
	A9Gbr8XlkAV8FstfxxWkamrhVWc1kJ3IC0vwIdQpB6VfGk16clDaTwPIx6OgPgikC2mN08YJhSoxQ
	wJI+X9rZB3e+arNX0NtAeM3Cn+hHMbp/yg163NXeXx3S/Vp0fZujlOArl5aykx6uujrEJSTptwV7h
	ehu3FWW1fEw5XM9tdEOr3Z1+6gqkZEHsTCKr4dUx5nbQTRqa/+NE9RTrq71Mze0ksPGLQo6wtxTH7
	2UKug8qt1EepLTsOGlr1B1E9lp4z+eyM+SuA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQP59-00GSSZ-1P;
	Fri, 22 May 2026 20:34:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:34:27 +0800
Date: Fri, 22 May 2026 20:34:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, benjamin.larsson@genexis.eu, atenart@kernel.org,
	davem@davemloft.net, vschagen@icloud.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: eip93: - fix reset ring register definition
Message-ID: <ahBNU2uiasfbuHE_@gondor.apana.org.au>
References: <20260516122657.2585876-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260516122657.2585876-1-olek2@wp.pl>

On Sat, May 16, 2026 at 02:26:51PM +0200, Aleksander Jan Bajkowski wrote:
> This patch fixes a descriptor ring reset. This causes a hang in the
> driver's unload/load sequence.
> 
> Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
> Suggested-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/crypto/inside-secure/eip93/eip93-regs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
