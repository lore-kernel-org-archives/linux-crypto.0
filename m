Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F189475;
	Fri, 21 Aug 2026 00:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787270613; cv=none; b=R5QYSMoczMqiIVeoENz+kOHZaaHKEyeNqCG/1xkwIBIt1p6Og3PLSIZTiDc6b03Ty75afNu9FRWanlvKLhELf9PPw6MCyS26YC1tLSsKJ+MGLfYYaATkW7CeGm4Skl+7VjLpONTpmVYzPd4vYdSOVLxbP1GU9m9qau38X8fKRSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787270613; c=relaxed/simple;
	bh=uOVKZFnPH8o5K67dQhSo+RueQptoFuVeeYd5o/6x+7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kxL6NVHnQKKTKlaG+L8/NQ+ua87tUkf3PO/NjjBnf0n4Y9IzDKPqvgjF8Y82tRtJ3kB96aE8KF6Cn4j3UY6N6JSoHi0UjQZ/XH6Yr2Wvilg7sqTvP21p4r8vIQHNC8Kv6Ig2XG2j7bio1qr+zse9/awN7PuX/oWI068pVbN89Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q5n9wv3U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q5n9wv3U"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 332111F000E9;
	Fri, 21 Aug 2026 00:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787270611;
	bh=ZMOaH3Ifg3zYiZwwfg92Dtd+BEAAcTWCMj96C6OWaGM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Q5n9wv3UMuIVNNtVKpB/5iBO0z0hHn44PwV1f8lGZiseBX3KpLBrj8LSwLjuHfYVi
	 2xEJGYCUWNlSAoQGLMTu0n6W7+YVC0xM603C5E4M2LMnRwszD7U7apnB2DH7LyZEEy
	 MewwkKkgwnfS93c8wliAkPhSz3uStjsRkXD1RiiUjUG7vrTQRZNy8SrkUS6TqjrAvs
	 S4pQ+3I1A3ZmfLPA3mjgPM08n496rdfLcI0qvucw1QOIw6m8dvjh5j/THArm0ZQWB7
	 VwghisgiE7f9jIgvXGML7lN8Gz51GaeSryRsFA9A23jXHeHIRHwXiAxVeXF3OF9kBE
	 kYIzG0zQjDBuw==
Date: Fri, 21 Aug 2026 03:03:27 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Thomas Huth <thuth@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org,
	keyrings@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 0/3] lib/crypto: Provide a function for zeroizing
 hmac_sha1_ctx
Message-ID: <aoeVz8FsDOEP32M2@kernel.org>
References: <20260812163336.3103835-1-thuth@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812163336.3103835-1-thuth@redhat.com>

On Wed, Aug 12, 2026 at 06:33:33PM +0200, Thomas Huth wrote:
> It's maybe not worth the effort for hmac_sha1_ctx right now (since there
> is only one spot that forgot to zeroize the structure in case of errors),
> but offering a function for zeroizing the data via __cleanup might help to
> get future code into the proper shape right from the start. Thus let's
> introduce a hmac_sha1_zeroize_ctx() function now and use it in the
> appropriate spots.
> 
> Thomas Huth (3):
>   crypto: Provide a wrapper for zeroizing hmac_sha1_ctx
>   security: keys: trusted: always clear the hmac_sha1_ctx before
>     returning
>   lib/crypto: sha1: Use hmac_sha1_zeroize_ctx() instead of
>     memzero_explicit()
> 
>  include/crypto/sha1.h                     | 17 +++++++++++++++++
>  lib/crypto/sha1.c                         |  2 +-
>  security/keys/trusted-keys/trusted_tpm1.c |  2 +-
>  3 files changed, 19 insertions(+), 2 deletions(-)
> 
> -- 
> 2.55.0
> 

Looks right to me:


For 1-3:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
