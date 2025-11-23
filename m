Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FF521ADA7;
	Sun, 23 Nov 2025 05:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763875129; cv=none; b=JG8G+uKycM3dRSCrVe3O0KlGM+rldB/6SOwTHMfGN0RXhfTFJz8s8s1OIhUm1EfeTqdzHbidXmQ2rpr/P/YlfJkOMLZQdv7FTk2JrwW9dYetaEdwjT1YzYr7zCvVuWcqmNL33Z9/Tc2TVCwI5ABvuSlqtKo0sqv2dQZp22ZCxOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763875129; c=relaxed/simple;
	bh=clwQUiI6S64EsJ+QHTu2/U+1EilKHJklRKnEFvSvibM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cy2SszTqRaN9FNFl5FSeGqVLNq1peFkrOKDTxYDblk5cZyLoUOD9XPSQjfTjvoodvsrt/mWGqfWXuplThal2tw/cxAikDU0U69TV1kBCETUt4nVD6rUL2Zrjo4iOOHgwOhm56+omnXhlF1XIGthli8+RMRK9aqtrb8tpemjKnTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HzZDo4n5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HzZDo4n5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4579CC116B1;
	Sun, 23 Nov 2025 05:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763875129;
	bh=clwQUiI6S64EsJ+QHTu2/U+1EilKHJklRKnEFvSvibM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HzZDo4n59KAnGIfeziQYsOHjGUmS9qX1WI27uhr/nUQWYzWR0kUzqiRwM31Fzd5mP
	 h0y6TEfh6G2P+vcZ1yN5/crfZZERqxo0IttWWkX4hjqMZ9GvQ9UpHM+OryzlbPV157
	 dESK5JYovgx54NlBR5yhpHR0gWhbOq/VkJC9J499lAoYx6eRMwsK+MwDxTUOdDrCbc
	 FgMY2sBnze3MRiKQTW0/2QvxpEzkujaLF7+ndtzJMWJ5Wn6HWE98VgEldCmmjpy9G8
	 rWouPWgSif88pK8bfjSQw21aJb5qU7vm91CoeIf2CLmM0CjUS73cqjrDKQ1HGT4782
	 1DgojRGkUZG1A==
Date: Sat, 22 Nov 2025 21:17:03 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/6] lib/crypto: More at_least decorations
Message-ID: <20251123051703.GB42791@sol>
References: <20251122194206.31822-1-ebiggers@kernel.org>
 <20251123040037.GA42791@sol>
 <aSKYlZMAsOoA3yko@zx2c4.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSKYlZMAsOoA3yko@zx2c4.com>

On Sun, Nov 23, 2025 at 06:16:05AM +0100, Jason A. Donenfeld wrote:
> On Sat, Nov 22, 2025 at 08:00:37PM -0800, Eric Biggers wrote:
> > We can make these crypto headers include <linux/compiler.h>.  But before
> > we do that, should we perhaps consider putting the definition of
> > 'at_least' in <linux/compiler_types.h> instead of in <linux/compiler.h>,
> > so that it becomes always available?  This is basically a core language
> > feature.  Maybe it belongs next to the definition of __counted_by, which
> > is another definition related to array bounds?
> 
> This is indeed exactly what should be done. Do you want me to make a v4
> and you can rebase -next, or do you want to just fix this up on top?
> 
> Jason

Sending out v4 would be good.  Thanks.

- Eric
