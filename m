Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C532627AC54;
	Thu,  1 Jan 2026 21:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767301578; cv=none; b=SQetfAwfHj11DnobLY0E6r3VEICSBIGmEqvBrxHmt5deXaZTegIu4n5V4GIIEpFRKzrHqgiCzc38x51TQG1ymW/w60VPDPZfoA+r6EkC6K/BTuWpAe9WYOiVAnfGcNIArqN4fE/KZIkOzUKWBW4ktbR1ZfD0VHhdek8ag+WQ+s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767301578; c=relaxed/simple;
	bh=oYZ8qN7r/Vce8vyh0wt64dIntHwYfuvzlNnHfe4bxIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jiBASCYJXn6+1qUK0elaoaQGhfDBApIYu8CTtjeL84ZH5ORwXVJ0qz8rLQBkFOhlRIIRG4koRPirKPJzBhecpaTw0CulQKUYSD7TMj7/yKDjI7XJf9VZ6twhFH/BMgpV0zJgY8O9WJs78f8LT7Qk9k35/U53yFgAjOdq2jajZCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6ef21rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6ef21rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1200FC4CEF7;
	Thu,  1 Jan 2026 21:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767301578;
	bh=oYZ8qN7r/Vce8vyh0wt64dIntHwYfuvzlNnHfe4bxIg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i6ef21rz9LGykSMSL5Krw6aO1G9snHyR6AGXfkn20QR8vpBSrdNf2Fvbp8Ja+PjHq
	 BupvOXSQHojH7ZALfeHtMCE2yliJDk164JUws3MqY0qj1qX0prGUVP8avS6uASfMIg
	 c7a1E/qNT2rQupdLASfNArOR3sIsjbIVUrXTyoDiPehcnSstnMnoYWNt5+T7966gIh
	 /hEzkCK2o1n0uAXFpR/CHHUiBHQj7SwIKTyudpTseQslaxlmpfhRJ+Syrx/LGbJx4C
	 uStgQGmgAGZD5dCmWzraxb/8OuOzWV3aa5vMfCD0/S6ypFhljnmQX4pTf12di/8jmZ
	 rTJEQJDBs6/4A==
Date: Thu, 1 Jan 2026 13:06:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] Implementation of Ascon-Hash256
Message-ID: <20260101210602.GA6718@sol>
References: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
 <20251215201932.GC10539@google.com>
 <7920c742b3be0723119e19e323dc92bc@kriptograf.id>
 <20251216180245.GD10539@google.com>
 <bb05699bc7922bb3668082367b4750f2@kriptograf.id>
 <20251217040617.GA3424@sol>
 <aVTq6HaRr4G2gmho@Rusydis-MacBook-Air.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aVTq6HaRr4G2gmho@Rusydis-MacBook-Air.local>

On Wed, Dec 31, 2025 at 04:20:40PM +0700, Rusydi H. Makarim wrote:
> On Tue, Dec 16, 2025 at 08:06:17PM -0800, Eric Biggers wrote:
> > On Wed, Dec 17, 2025 at 10:33:22AM +0700, Rusydi H. Makarim wrote:
> > > On 2025-12-17 01:02, Eric Biggers wrote:
> > > > On Tue, Dec 16, 2025 at 01:27:17PM +0700, Rusydi H. Makarim wrote:
> > > > > While no direct in-kernel use as of now
> > > > 
> > > > Thanks for confirming.  We only add algorithms when there is a real
> > > > user, so it's best to hold off on this for now.
> > > > 
> > > > - Eric
> > > 
> > > Rather than leaving this work idle, would it be better to move the
> > > implementation entirely into the Crypto API ?
> > 
> > No, that's actually the most problematic part because it would put it in
> > the name-based registry and become impossible to change later.
> > 
> > There's a large maintenance cost to supporting algorithms.  We've
> > learned this the hard way.  In the past the requirements to add new
> > algorithms to the kernel were much more relaxed, and as a result, the
> > Linux kernel community has ended up wasting lots of time maintaining
> > unused, unnecessary, or insecure code.
> > 
> > Just recently I removed a couple algorithms (keywrap and vmac).  Looking
> > back in more detail, there was actually never any use case presented for
> > their inclusion, and they were never used.  So all the effort spent
> > reviewing and maintaining that code was just wasted.  We could have just
> > never added them in the first place and saved tons of time.
> 
> Looking at both lib/crypto/ and crypto/ directories, I initially did not
> have an impression that mandatory in-kernel use of a cryptographic hash
> function is a strict requirement for its inclusion in the linux kernel.

It's no different from any other Linux kernel feature.

> On the other hand, I am also keen to see its possible use cases in the linux
> kernel. Ascon-Hash256 specifically can be an alternative to SHA-256. For
> instance, it can be an additional option of hash function in fs-verity for
> processors with no SHA256 dedicated instructions. If that something that
> interests you, I am open for further discussion.

I haven't actually seen any demand for alternative hash functions in
fs-verity.  Though, dm-verity is sometimes used with BLAKE2b for the
reason you mention.  But this also means the kernel crypto subsystem
already has alternatives to SHA-256.  With that being the case, it's not
clear that adding another one would bring anything new to the table.
How does the performance compare with BLAKE2s and BLAKE2b?

- Eric
