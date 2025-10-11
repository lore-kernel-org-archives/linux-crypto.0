Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBC2632;
	Sat, 11 Oct 2025 00:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760142364; cv=none; b=tueiI0zQdDQCbihU9prQbJBAAjS6ArTTr7ue21ma6Tnu02/TQ3KfUDq9y7+MokCsnYYgDyS2MQ9+1AeAh3S3of0a284RANcrw+G9f4SSftmAHBdtjNi+UKpro1urrG5PXOSpbWSh5Ps1R7V7YbMyVzvuaK338XA68wl26/MS9oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760142364; c=relaxed/simple;
	bh=a5wJqs0eOxV6rB7lBPt6rh8/vvfUgqZ9BRXbh1bNfAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KhspdL5UcF8G0sdftanJexIIQz8c7V2a6cjo4/8DIVTlRheBBVZeMsKWiaGLS1CyJJ2fjiTzBp3o6bOCSgT47eo4Xc733SP9eLBk5WAsIfepRQofsesfq/wCHlUU+Zayo92+YcdXxMBWMV2S6TMP2m/dbBW5Bs/+L+5QkRjibuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L4gzIHUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L4gzIHUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204A8C4CEF1;
	Sat, 11 Oct 2025 00:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760142363;
	bh=a5wJqs0eOxV6rB7lBPt6rh8/vvfUgqZ9BRXbh1bNfAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L4gzIHUASD2/NUpmVY7jeGjEt1CQSkPwkivcBznUf2iilYwrcmorh4ukLMHxr4Bm2
	 EHhaDBIQUn3sVHBKmsWtWTeR+H8KU5mpr/7M9l+1z9LKpslcYdwQYFen1vWdKH1hY2
	 Kw1fgyVmJYiA1H3o34BsRLXDX4ALRhOBgW0AKyQq7qMhiWuYyVe6cEoIgs0KmRKAub
	 nQBFqtddncQKQCVZGqfyPCT7HpackyxLoUwZS1yvkyMfdEPLKgod7OPwIQ/cJP5Gjx
	 nl/gSP/Xl1rI2Mj+ypHKziCyoaKiRLhseF4SpKr0lFi8iQwCAjJLPGsxdO6hLOItxH
	 NjNQWaRo8VHcQ==
Date: Fri, 10 Oct 2025 17:26:01 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] crypto, lib/crypto: Add SHAKE128/256 support and
 move SHA3 to lib/crypto
Message-ID: <20251011002601.GB20823@quark>
References: <20251001152826.GB1592@sol>
 <20250926141959.1272455-1-dhowells@redhat.com>
 <20250926195958.GA2163@sol>
 <2636609.1759410884@warthog.procyon.org.uk>
 <20251002162705.GB1697@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251002162705.GB1697@sol>

Hi David,

On Thu, Oct 02, 2025 at 09:27:05AM -0700, Eric Biggers wrote:
> On Thu, Oct 02, 2025 at 02:14:44PM +0100, David Howells wrote:
> > Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > > Have you had a chance to read this reply?
> > 
> > I have.
> > 
> > You held up your implementation of sha256 and sha224 as an example of how it
> > perhaps should be implemented:
> > 
> > 	It would be worth considering separating the APIs for the different
> > 	algorithms that are part of SHA-3, similar to what I did with SHA-224
> > 	and SHA-256.
> > 
> > so I have followed that.  That defines a type for each, so I'll leave it at
> > that.
> 
> In v3, you were pretty clear that you don't like the six-types solution:

Let me know if you have a new version of this patchset planned.
Otherwise I'll work on cleaning it up and finishing the remaining parts,
like incorporating the arch-optimized SHA-3 code.

- Eric
