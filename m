Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEE772E336E;
	Tue,  1 Apr 2025 03:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743478799; cv=none; b=j1kVGOQoHwcMPKPWlwFj4BlUSThuJUvv9i4K/WlCO2N+Fcx2Vo5ZUgJQvU5ax68x28VKOJ0oSrKLEH34i/06f0TVzN17ijDY+DJXE650h5SG8BOKncn74JaUBOJ3/qUCf1DvU4jkl6xlpeoaNjzuSaNXvdjz4FylvlDgmMj/PvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743478799; c=relaxed/simple;
	bh=fcGEkOdaj3dt0l/V4STlJpMK16bfZ0wwV7U1GLNE0GA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ag1rhT7qOsbaSbi7nNsw1gJPOgdAyEU0hDelmv0FteY7TWUOPRKD74LS/1m+V5DgJwh/Ffa4/nIB6FIKF5AJb1SHYhpGsw7sG1i1lsj4hdb1oxiILbP11ShwLjdxoiSXi17+a8fE9h/HdKGhB11qfCfnvOzv65OPlkhdRQ/2vY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agQbfzjd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agQbfzjd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE86C4CEE8;
	Tue,  1 Apr 2025 03:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743478798;
	bh=fcGEkOdaj3dt0l/V4STlJpMK16bfZ0wwV7U1GLNE0GA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=agQbfzjdbGsu22cHIitFDoAWfYe6mxzokFc60E28jXn+b377kSIPc0Jr4WFy2Bv35
	 522NgvvuMxnfmFGXw3MwkAADhYk3jARlw8+/mrWnLiMc4+Xt8sewIvecmyctSF32TR
	 pFDQlxkV1KicuWiOI47UwpR/qcdN9hK2/bjdBn32qwysZrgRJwfux02zwjvpLROGQa
	 g51TXPktNNfVbbOmTybhuf1yRlQ2IbX/8VxCsrRybdUSCu3cRqsliOMdR99CjsJ68N
	 MwAqtESUVnTtKUlQ1TVBs7hS1GvQos5bIyjYET90roWejQhHhyuh9m4lEq5QjzBCB9
	 zdIJPd61GyKNA==
Date: Mon, 31 Mar 2025 20:39:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Chaining is dead
Message-ID: <20250401033956.GB56851@sol.localdomain>
References: <Z5Ijqi4uSDU9noZm@gondor.apana.org.au>
 <Z-JE2HNY-Tj8qwQw@gondor.apana.org.au>
 <20250325152541.GA1661@sol.localdomain>
 <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
 <Z-N55Yjve6wTnPqm@gondor.apana.org.au>
 <Z-itc_Qd5LLn19pH@gondor.apana.org.au>
 <20250331165630.GA3893920@google.com>
 <Z-td2eIxPp-gRq7n@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-td2eIxPp-gRq7n@gondor.apana.org.au>

On Tue, Apr 01, 2025 at 11:30:33AM +0800, Herbert Xu wrote:
> On Mon, Mar 31, 2025 at 04:56:30PM +0000, Eric Biggers wrote:
> >
> > For hashing, users would need to allocate an array to hold the digest for every
> > block in the bio or folio.  That would add an additional memory allocation to
> > every I/O.  You said you'd like to fall back to a smaller buffer if the memory
> > allocation fails.  But that's silly; if we have to support that anyway, we might
> > as well do it that way only.  In which case the bio interface is pointless.
> 
> BTW, the existing verity code is hilarious.  In my test, for each
> 256KB bio, it was dividing them up into 4KB pages, and then for each
> one of them, it's looking up the correct hash in the Merkle tree.
> 
> Surely there is some locality here so if you zoom out from 4KB (or
> even 8KB with your multibuffer patch-set) to 256KB you could get all
> the correct hashes in one go, rather than 64 times.

Well, it looks up the bottom-level block before falling back to walking the full
path, and it's cached.  The cache lookup is fast compared to the actual hashing,
or at least traditionally has been.  You're right that it does often look up the
same block repeatedly, and that it's one of the things that needs to be better
optimized now that hashing is so fast that overheads like this become
significant.

- Eric
