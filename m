Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A195918B47E
	for <linux-crypto@vger.kernel.org>; Thu, 29 Aug 2024 21:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724968446; cv=none; b=goy0u9eBn8v240y8NDTU3ifhcvUBO07+0kT+kdlfGxyXQiV7YW19biaCBD2oyMFWBxcFL4BBSH1q7EFxYK041ENSaP3avNid/2Rp4TbEhilDs9Y8Rq6eVy6V/X6gME76yRJ/wqseTHJVnyAG37IJsy/ywbJdy5Lx3juLYYYg/wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724968446; c=relaxed/simple;
	bh=VSf9lBepvKlhGDHu/xDYs8tQ20lRAHKY61GmFFScatE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TU6Ly3naq+Mh+rwXhKCJq/0pf6rSJWKvpf2X8QzHyuKboHltqMiKAzHHBrdiqBtnY32U+w+o/KF6I2KgLxZr0gfRYY0KSVhmpOKRK2VrUNb+En+8qQOa6FI6JvIPZoVVymcnJ6X5CD96QViWCBfegHWXDd8NeRi7oWjp+jTCDHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ubc6NZb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ubc6NZb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DB2C4CEC1;
	Thu, 29 Aug 2024 21:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724968446;
	bh=VSf9lBepvKlhGDHu/xDYs8tQ20lRAHKY61GmFFScatE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ubc6NZb2GZ370cGoH33/CWQe7iCJpZgOt/Vprc2uJ/Sems1vEhcRYs4pVG8l9wPcC
	 IUOe4sIzA5cFM2rmFA2/Jqhdj6sCf0QUsLhZPUkQ3L7RslMATAbETLAt++SZurXUHA
	 B98q+/7j+M0wdGKQXdr/kni0gQ59L6JkcaEs77fEEIR/JW2hCNMx5mS1G71BivlJaq
	 Jk6P0As6TJhTNmYIAe9GhGQDhzrV1A7JgR9xLBUDpqiLNYv9Oiw+h1B+RLE56n1v5m
	 imwknTqkrM3BV1T1k+nQxb25OYkW2jSG6Cvp8FYgGr9CfAyOWEo/WrfjpPuO1ruHEW
	 iAtIuwgTmH1Vw==
Date: Thu, 29 Aug 2024 21:54:04 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Hannes Reinecke <hare@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/9] crypto,fs: Separate out hkdf_extract() and
 hkdf_expand()
Message-ID: <20240829215404.GA3058135@google.com>
References: <20240813111512.135634-1-hare@kernel.org>
 <20240813111512.135634-2-hare@kernel.org>
 <20240827175225.GA2049@sol.localdomain>
 <0697a6c9-85a3-4f56-879c-b096fb5072b8@suse.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0697a6c9-85a3-4f56-879c-b096fb5072b8@suse.de>

On Thu, Aug 29, 2024 at 12:39:33PM +0200, Hannes Reinecke wrote:
> On 8/27/24 19:52, Eric Biggers wrote:
> > On Tue, Aug 13, 2024 at 01:15:04PM +0200, Hannes Reinecke wrote:
> > > Separate out the HKDF functions into a separate module to
> > > to make them available to other callers.
> > > And add a testsuite to the module with test vectors
> > > from RFC 5869 to ensure the integrity of the algorithm.
> [ .. ]
> > > +	desc->tfm = hmac_tfm;
> > > +
> > > +	for (i = 0; i < okmlen; i += hashlen) {
> > > +
> > > +		err = crypto_shash_init(desc);
> > > +		if (err)
> > > +			goto out;
> > > +
> > > +		if (prev) {
> > > +			err = crypto_shash_update(desc, prev, hashlen);
> > > +			if (err)
> > > +				goto out;
> > > +		}
> > > +
> > > +		if (info && infolen) {
> > 
> > 'if (infolen)' instead of 'if (info && infolen)'.  The latter is a bad practice
> > because it can hide bugs.
> > 
> Do I need to set a 'WARN_ON(!info)' (or something) in this case? Or are the
> '->update' callbacks expected to handle it themselves?

No, if someone does pass NULL with a nonzero length there will be a crash.  But
the same will happen with another invalid pointer that is not NULL.  It's just a
bad practice to insert random NULL checks like this because it can hide bugs.
Really a call like info=NULL, infolen=10 is ambiguous --- you've made it
silently override infolen to 0 but how do you know the caller wanted that?

> > > +#ifdef CONFIG_CRYPTO_HKDF
> > > +int hkdf_extract(struct crypto_shash *hmac_tfm, const u8 *ikm,
> > > +		 unsigned int ikmlen, const u8 *salt, unsigned int saltlen,
> > > +		 u8 *prk);
> > > +int hkdf_expand(struct crypto_shash *hmac_tfm,
> > > +		const u8 *info, unsigned int infolen,
> > > +		u8 *okm, unsigned int okmlen);
> > > +#else
> > > +static inline int hkdf_extract(struct crypto_shash *hmac_tfm,
> > > +			       const u8 *ikm, unsigned int ikmlen,
> > > +			       const u8 *salt, unsigned int saltlen,
> > > +			       u8 *prk)
> > > +{
> > > +	return -ENOTSUP;
> > > +}
> > > +static inline int hkdf_expand(struct crypto_shash *hmac_tfm,
> > > +			      const u8 *info, unsigned int infolen,
> > > +			      u8 *okm, unsigned int okmlen)
> > > +{
> > > +	return -ENOTSUP;
> > > +}
> > > +#endif
> > > +#endif
> > 
> > This header is missing <crypto/hash.h> which it depends on.
> > 
> > Also the !CONFIG_CRYPTO_HKDF stubs are unnecessary and should not be included.
> > 
> But that would mean that every call to '#include <crypto/hkdf.h>' would need
> to be encapsulated by 'CONFIG_CRYPTO_HKDF' (or the file itself is
> conditionally compiled on that symbol).

No, it doesn't mean that.  As long as the functions are not called when
!CONFIG_CRYPTO_HKDF, it doesn't hurt to have declarations of them.

- Eric
