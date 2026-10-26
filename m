Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793039815;
	b=1HMPX6qbyCFpbgMZFdsEHpru+lEJaO6i2SASNEbX5YO2CCqtdwy79ywBLK/IxMWl3AJa
	 zTeCNdaRjqMtVXvFmyQyuA1ZY7RPeDrQh3PrP7hRnQbKqFFpixp7x4UyR99smMI6dFpSD
	 8QgKqOZ6ON6D67L0I2ANLFwwZPmcT12toAcoLdfFzoItyrA0d1TIPHns/0sVtsK1X2HXm
	 5+BEJu4wU5jcBFyemwz+edGGOdPCnpNl3qfNslOl9s1Fut6jO/ONzSmwOBtx3dm2Uj6Eu
	 9+rL3Z3MkrsSCHbTWkuzDoQ+E4E9TLpbZyyAss2Q87ukOUAyvEoWNHGSm2tQyr8CKxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793039815;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ispTKMG4NngNOKG/xkORitf8CWFz8qbmhQndJ4Log6A=;
	b=qZUjuG9eC4Vxa/RE+1hrvhc4PjhbTXbpQsemZcc92ZXQRx+wyLrRQH/+uVgnl+aQ75xY
	 rye36RYedpyKiLiMBLUQ34qVty+o2RuWHAgmrDjK24IXGBq/ZXaHMxdKsS6OXM17g6vym
	 WHfShlvh2oTcPODzjoxelZbcExecWlEDgjcliO1Tj35vL4ttHBFOceyHynFmf7kyuIANc
	 Rd5NuyrgwOh7bIbG4COU4qJDw5/gShCvm0kb4FtLiPa7nzEaf2AXykAAhpu8kzWEFSEAA
	 TvQ3eBkNgqimtqI4Bc9+DGVgw9j+uE0M4tjelEpeR/Qm5FgFOXMWj4JOIFdYS9QblPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="edqXjE3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300DD606A320;
	Mon, 26 Oct 2026 18:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=edqXjE3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897941F01825;
	Mon, 26 Oct 2026 18:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793039814;
	bh=ispTKMG4NngNOKG/xkORitf8CWFz8qbmhQndJ4Log6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=edqXjE3/tnRR7039mnXrJLnS5YTB2FYS3NIENWjKOveevsOdJydktTAkdmBOxtRbt
	 29jr3mq40MzyX/IWwLHEfCz3f6MtZonhFdmRlecoA+kOATt9emL3CMGiWkbJ3Z03eJ
	 rXDlynoN1Xa06reg4fAKWujpytaneh7p1W8HNMRnj21xhuHsuiPzVT8+knLyPGlw7o
	 NSrcIrvl9noe/6Ql15+ysbBic4yZMOkQAHV6f5720iVFO8N9XtGOUJ9TrHnR5MxdoQ
	 C/adJX74WADkDjuCDUYHBmIXiXnIXBPbnf5dACLmd3JffO+rlGBNTT+rqTBBqm4y3A
	 vRlLpgFoaE5Ug==
Date: Mon, 26 Oct 2026 11:36:53 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Antonio Quartulli <antonio@mandelbit.com>
Cc: Martin Willi <martin@strongswan.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] lib/crypto: x86/chacha: Add 16-block AVX-512
 implementation
Message-ID: <20261026183653.GA1876@quark>
References: <20261025234758.3219829-1-antonio@mandelbit.com>
 <20261026003510.GA1843@sol>
 <3e2dee91-bba4-42e3-9d22-619ea54484e4@mandelbit.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3e2dee91-bba4-42e3-9d22-619ea54484e4@mandelbit.com>

On Mon, Oct 26, 2026 at 01:46:19AM +0100, Antonio Quartulli wrote:
> Patch 1 (KUnit tests and benchmark for chacha_crypt()) is independent
> of the AVX-512 code: it compares chacha_crypt() against
> chacha_block_generic() for every length up to 4100 bytes and random
> ones up to 12 KiB, with guard pages, in-place and split calls, plus the
> RFC 7539 vector.
> 
> @Eric, would you consider it on its own? It would cover Martin's series
> as well. I can resend it standalone if that's easier.

I'm interested in the KUnit test, and I'll review patch 1 when I have a
chance.  No need to resend it yet.

- Eric
