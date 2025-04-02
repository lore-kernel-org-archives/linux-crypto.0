Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9C1D33993;
	Wed,  2 Apr 2025 17:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743614372; cv=none; b=cslhdlc5xQx8Shwa1Ry67ZMBZAqpkteSeR1+CmEM48yYXj16xSZbj/vzgPTh+IaYH2P2iqn36Rrk6Bc4FmP18+Dl+3LtidJ9Mg/q7RMOjtPeFwI1D+Ea/YiYRwkMJ/beJzcacyCQuwBxnTmUL9zy6e+x93D5fVSs+qXKf81iXMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743614372; c=relaxed/simple;
	bh=6ZAuJe7VpvzN0yn03t+NJJYfd2x2rZOrxKuVdjVr/c4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AdnqHnJlDlPgOoq1CTB1yp6TfkimqixZSPOjt319ffUObt1nv58SWYg20v5VAPxB7WRX995g8OUy6G9GkedsX9l6gBfIz1PDQUpbzoFICK55Qq6LtgeMnQU3G6wDNUAprLnfLdGLPlnrRyqgnADawmY6IXcQuwe7xzRVHDU/PHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qcp7NY/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qcp7NY/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13449C4CEDD;
	Wed,  2 Apr 2025 17:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743614372;
	bh=6ZAuJe7VpvzN0yn03t+NJJYfd2x2rZOrxKuVdjVr/c4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qcp7NY/UEHczn/meGifvCOmH+kqRAT/EYrl6oHSOaRWQbPRG6985J8GQDYLfLcAk+
	 VmkvzUYsBk3LgHWllXQ/uSib6UCpcjpP46ruHZK7MV+is/my/H6mPeAAnQH865uNCd
	 cqhZU6kHkeYtt9Z4ACIanKNGZlEDRdh2x9trTgObutVHvV5YahIfaSYz9DLBHOSqKT
	 zliJKhg+RR8kHn5xGWYghQC6Tp5CEZe55kX/f7udjbCcLMD60i33li9YYeZJO2lXeW
	 HXddhF9l3bBdeSVALT/ZeY5e0HrwLkMGdpVCWuMeZghkOeERvUrEbCyihF7U6bQkeM
	 cjpthLU77Ot9w==
Date: Wed, 2 Apr 2025 10:19:30 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2 0/9] crypto: x86 - stop using the SIMD helper
Message-ID: <20250402171930.GD1235@sol.localdomain>
References: <20250402002420.89233-1-ebiggers@kernel.org>
 <Z-yrf_9D2rV1Q136@gondor.apana.org.au>
 <CAMj1kXEx__RLBriW0kVPrKnx6+DCpq8=6F-7Tmj2Us61gvGGaw@mail.gmail.com>
 <CAMj1kXE-vo7E1U++4mAqDH2SXfc=sRZs8KganedJk5z0QF49NA@mail.gmail.com>
 <Z-zzvXbjt3xzquXb@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-zzvXbjt3xzquXb@gondor.apana.org.au>

On Wed, Apr 02, 2025 at 04:22:21PM +0800, Herbert Xu wrote:
> On Wed, Apr 02, 2025 at 09:34:30AM +0300, Ard Biesheuvel wrote:
> >
> > Ah, never mind - I see some calls on 32-bit ARM to
> > simd_skcipher_create_compat(), which have become redundant now that
> > SIMD is guaranteed to be available in softirq context.
> 
> Thanks!
> 
> We could also remove all the calls to crypto_simd_usable in the
> Crypto API hashing code, e.g., arch/arm64/crypto/sha1-ce-glue.c.
> 
> For the lib/crypto code I think we should make it a rule to
> not allow any hardirq usage just like the Crypto API.  Does
> anyone know of any uses of lib/crypto in a hardirq?

This seems premature.  crypto_shash is documented to be usable in any context.
See the "Context:" comments in include/crypto/hash.h.  Similarly, developers
expect lib/ functions to be available in any context unless otherwise
documented.

For skcipher and aead, there are more reasons why it makes sense to limit the
contexts:

- skcipher_walk_first() already explicitly errors out if in_hardirq(), which
  already prevents them from working in hardirq context in most cases
- Even if it was allowed, the skcipher and aead APIs are already difficult to
  use correctly in a hardirq
- Because of how the crypto API is designed, it's not straightforward to fall
  back to generic skcipher and aead code in no-SIMD contexts

I could see the limitation being brought into crypto_shash too, though the
crypto_shash documentation will need to be updated.  The crypto API also really
needs to be explicitly checking all its requirements.  (It's probably finally
time to add a kconfig option like CONFIG_DEBUG_CRYPTO to lib/Kconfig.debug, and
put the extra assertions under there.  Then they could be added without
impacting performance for normal users.)

IMO, doing it for lib/ too would be going too far though.  The lib/ functions
should be easy to use and not have random requirements on the calling context.
And since they're just functions, it's easy for them to fall back to the generic
functions when needed.  Also note that for very short inputs it can actually be
faster to use no-SIMD code, as that avoids the overhead of a kernel-mode SIMD
section.  So the fallback sometimes exists anyway for that.

- Eric
