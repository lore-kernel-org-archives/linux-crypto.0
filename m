Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D889322C78;
	Sat, 14 Mar 2026 05:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773464876; cv=none; b=nFwXXqwxyVpJiU60pwhPOXGgqHsfZp6vFxKF7+6CqfklrFX5c6p3jN8xowH4xtdwR63Wx6p6nx8xW2/DwdgvfeiUMW3kGABx1z3/E2xC+1jcmORVecc0e3yfQq88ztifhQeBA/4LygP0S/Oq5NLcxR6IHQBcBbSRki/Anq0+oL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773464876; c=relaxed/simple;
	bh=iJStQSp8i5y5JQsRLdAdxfxrGCIMTCg0Ui3wA1RaJ8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cO1NSe/VnK3P9Kyyd8x7i7b8qURb9cIdEZsXO6NopbQYGzTTjjnw2MGJe1EUET0jMJ1BEsC8SVR1E5DiKENNEIJ/D4Rpw7ZgaRsOotnrG7R8bSq/e02ddQJFeH57jwB8aA+6H77n7Q3dm4VP4W7uZ8c6bOTNN3YtAviEtofPJQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gxFOH3Qa; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gxFOH3Qa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=fdfVIGo3jmA++D2GC6KppyUnOxZtSXU1VnGZJztmuxU=; 
	b=gxFOH3QacMcue+3KHu9PinPTEvVo5ss6ci0GrUeBrLkkcEu6YLEITokrKuCgbQdUvyIqbJhHzPA
	U+eZ4v0jwKFe2f7ZH/c3FaZobiG706GUCP8HRur6pXFIRvu5A8bX/9U3Dt12EZe15WBWykCT8LOzZ
	HmnU0ObLT4DWsMYK98rC0VInui4Jvl0+fvUezPzHNIYD+kyIudLtANhEz+owBRU/O6YJKfHA+zQ1H
	Ap5MfFDkHNGSAkKQV4I451+dKSi2oaXcffhVw2IQZ9+ul4btCzKDf2y/NYxvtv6qZxwJIlRhvV/ec
	Kg6yojHX3BjAX3I/o4jPPxDzdtFCyTnLl9sA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1HE3-00EL2Y-28;
	Sat, 14 Mar 2026 13:07:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 14:07:47 +0900
Date: Sat, 14 Mar 2026 14:07:47 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tycho Andersen <tycho@kernel.org>
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] crypto: ccp - simplify sev_update_firmware()
Message-ID: <abTtI1_TnYmODGxa@gondor.apana.org.au>
References: <20260302150224.786118-1-tycho@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302150224.786118-1-tycho@kernel.org>

On Mon, Mar 02, 2026 at 08:02:23AM -0700, Tycho Andersen wrote:
> From: "Tycho Andersen (AMD)" <tycho@kernel.org>
> 
> sev_do_cmd() has its own command buffer (sev->cmd_buf) with the correct
> alignment, perms, etc. that it copies the command into, so prepending it to
> the firmware data is unnecessary.
> 
> Switch sev_update_firmware() to using a stack allocated command in light of
> this copy, and drop all of the resulting pointer math.
> 
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> ---
>  drivers/crypto/ccp/sev-dev.c | 27 +++++++++------------------
>  1 file changed, 9 insertions(+), 18 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
