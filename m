Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533293B637C;
	Fri,  9 Oct 2026 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791566705; cv=none; b=UvBhvH3vY9faKKzn8BLjIXR7aMNOLjD0t9G8s4xolpOXOPhT388o/g10Ujmmxh9JLw2r94MX7niIW0EQgU5nnbA5dh64kqVZ3Ka+ihDVjVycdW57DjHkPPtFnx5XjT7TOJNv0nXQYIy53gFklcy3Ok8ssjRzYbnARXS0U3vesng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791566705; c=relaxed/simple;
	bh=wm7fNGFyjV1R5vDO7kGkNyvvVdRi34SlT5CCQLppc6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pel3HSql1SW3BJ16ZsNXzb7lvVZmJaMVaeVthfy4L7ZOrZeFgyNbjt/5+5NIqzmJP9T5w4pWhUytcUT/4h3XdCr6eosrNSWOUZrdgp1/Er/bZWTwjJ3Z0joubjz/QEu9NNG0n9Z515AOyZeGaIOb4M3ptO1nj7aGdu6xUopP+Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AK2MwVTE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AK2MwVTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 449451F000FF;
	Fri,  9 Oct 2026 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791566703;
	bh=6Q+KdKWMLOk6qYuAYIizZqzumHkM4WBE3AxrRErW5H4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AK2MwVTELKrqLqiesBc/F+VxjVXm/2X3ofjWda6kChUuuLqOe+N8fStDnzJQpAV5g
	 gWhdHrlSEkzMwVOq9TQt50tSImGNh86RdOX06WPw+5ZvFRHEpDroTn21zvSPQySlEO
	 EABphYrkfpTqKIf2zOlAvgC2NIngX8Ld8bO/qLJuuN/ofbUnyWPXlt9hYcLAhl12tE
	 tJQuQZL9MrsKj2iG617C3GdjBXsNYQx/JZzHUg9i/iRG8STHkfsdjT0aQ9WJSTGd5U
	 gqTmmOR9Jor1GjLlyBfIGozy5gel/hZd5PG3w0DwpIV9eSBBSI0E3WrszcIBquEhPs
	 f/7VuJsZt+1YA==
Date: Fri, 9 Oct 2026 19:24:58 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] lib/crypto: poly1305: Use memzero_explicit() in
 poly1305_final()
Message-ID: <20261009172458.GA73965@quark>
References: <20261006083432.16328-1-ebiggers@kernel.org>
 <20261006122546.GB3185@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006122546.GB3185@quark>

On Tue, Oct 06, 2026 at 02:25:46PM +0200, Eric Biggers wrote:
> On Tue, Oct 06, 2026 at 10:34:32AM +0200, Eric Biggers wrote:
> > Use memzero_explicit() instead of a plain struct assignment to guarantee
> > zeroization of the 'struct poly1305_desc_ctx'.
> > 
> > Note that dead store elimination was only theoretically possible with
> > link-time optimization here.  But it's still worth fixing.
> > 
> > Fixes: a1d93064094c ("crypto: poly1305 - expose init/update/final library interface")
> > Cc: stable@vger.kernel.org
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Closes: https://sashiko.dev/#/bug/linux-c3a6bd76-f6ab-4203-892a-cd06f7aa0c34
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  lib/crypto/poly1305.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

Moved to libcrypto-fixes, since will be a fixes pull request with other
Poly1305 fixes anyway.

- Eric
