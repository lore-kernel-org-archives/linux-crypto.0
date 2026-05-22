Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33D31D63F3;
	Fri, 22 May 2026 05:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779426825; cv=none; b=pYHS1XLD5/hGheMC9WxjqUOWSILigZFLxSCn6HaXkC0NaSWLUjgl+6zCglUcvE0GmG/Ss4bU9YuUM7MqL22GFZLcDG5q6PjYMTXPOHr8WnI/J9oAOMxLeIw/ned5HpRB0Dr4lRdQp9FKdnqxUJZjY4EgGeu6szbj56i7Xs6mxyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779426825; c=relaxed/simple;
	bh=aB5b1JHbRduyPzrFWTdq1pI8pxXMS3m1G3NNgfOE5Mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKVkxuI0SH6gHFiqgCS4Z5Sh/R/Rq+aGwYczJj1cSk0+TTHasJGVida2paPdxO6a/dW4Zgo684fCqPKqerOAlr5n0AUFy8J4WqcX76cuMfAVldOCQoPrbvA9+3z1HnagGoRIxw6qkA3z5lXpLwX2Rrt3FpNBz9/XgwmG+KupQ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OsCAsiYZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsCAsiYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02B01F000E9;
	Fri, 22 May 2026 05:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779426824;
	bh=CuN3NPWL8JRPwPmzdvch38kRGm+W8e4/QvzBbCjPUu0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OsCAsiYZ9Eg618O/ZGhQFizSQPaz0tiffmFCIvAuEZOqvHohWaXDQOmnDIhD/tOeL
	 Q5tUQfGhmRVg32uwpVZ6Cwx9/l3jXUbO3iJFZfDpJpH8ZM6XwAhjymdKcpqQVYUpeB
	 vB7ynlbwe+aVsTlxXAk/jq1reZbygtYPXp9fwPSg=
Date: Fri, 22 May 2026 07:12:56 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Goetz Goerisch <ggoerisch@gmail.com>
Cc: Paul Louvel <paul.louvel@bootlin.com>, herve.codina@bootlin.com,
	miquel.raynal@bootlin.com, stable@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH] crypto: talitos - fix rename first/last to
 first_desc/last_desc
Message-ID: <2026052212-aged-amply-7bd8@gregkh>
References: <142603430.61540.1779296295550@app.mailbox.org>
 <DIO9YUHO5VGT.3BLGH04NVJNHP@bootlin.com>
 <DIOA24QU02W5.2RSVK05RE7BJK@bootlin.com>
 <1464270648.58006.1779377119607@app.mailbox.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1464270648.58006.1779377119607@app.mailbox.org>

On Thu, May 21, 2026 at 05:25:18PM +0200, Goetz Goerisch wrote:
> Dear Paul,
> 
> Thank you for this review and feedback.
> 
> > > Instead of renaming req_ctx->last, commit 9826d1d6ed5f8 ("crypto: talitos - stop
> > > using crypto_ahash::init") should be applied. Ideally before commit
> > > 655ef638a2bc ("crypto: talitos - fix SEC1 32k ahash request limitation") to
> > > avoid any compilation breakage and ensure correctness of the code.
> > 
> > Small correction:
> > 
> > Ideally before commit 00463d5f864a ("crypto: talitos - fix SEC1 32k ahash
> > request limitation") to avoid any compilation breakage and ensure correctness of
> > the code.
> 
> I can confirm your recommendation. Appyling this commit before, fixes the problem. Please disregard my patch.
> 
> Greg could you please backport the mentioned commit to 6.6.y in the correct order for the next update?

Can you send a series of backported patches in the correct order for us
to apply, so we know to get them correct?  Trying to dig out from an
email like this is usually quite easy to get wrong :)

thanks,

greg k-h
