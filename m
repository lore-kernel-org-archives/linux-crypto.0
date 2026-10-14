Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EDDE535FC5;
	Wed, 14 Oct 2026 15:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991773; cv=none; b=RjhD0epAmk/R6obG5no1kUXAVjU/SjXbFpaZBYP2yWYpVzdo/6vITzl0q+V/lRMA2bM9Bai5VtLWGtWCSekggIHRl0jgbQ6V9QuMHKwj7GGgf4tsxHV2a1WPh1Jkc/Db9utPli1vE6+Mv8GJ3lJKlRLYytC6BUXNmn9XPhWx4xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991773; c=relaxed/simple;
	bh=ZjI8gzGUHsqfSOwFTC5oQWZifdziwteOsWkcbxM4Y1M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=txC4Yic+XwCwDcBaZ5RBxEomyiYcfjpZAQyY7eP+6o9EQl5MGzlSmDxlRiyhpNh4B9yFEcsELCqOnGADkySvwfmQsec3qGwVkmee6HLODm+2FePFMqou4f3Tx9gBdRHeUYxKSVotG3LXCxKG0L9Eyw1B4DUOJLaU8MNXDVOCqfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eC3qXpQe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eC3qXpQe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914221F000C4;
	Wed, 14 Oct 2026 15:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791991772;
	bh=3sanjYJyBPAwiVfdmEEOUWD9Yo7/YSBsJ6XXqY86U3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eC3qXpQeI1FDby6KhL6WASkbwH465uGmxsZwNb1149OeMo6ECaRIpO4DB987bHW1e
	 gAcWWVWcu4fGAQmC/1mKftLXSBHsjhkS+Go9IQHBIZ8+NV/YXotfm7ihpI7al0sYIl
	 2MMi8HEYE8pvvrRL2Pwgx5wCL7H/PusdIjSnFxT8b1S2c0rS8sDcq2GXpANfGNb5Nl
	 EyL8TyJr7MvR917T6qcKB2PFKCLD8QsrJIZ0B2NAvP8pftDjQgRc3w77F/3MNmyso1
	 QF6I1PxSoouetFdQnMkL4PhLqEpGxBqPLWFHXHevSgquZaPRkf90UbB31jYtSkF6ru
	 ojAjGwOPiYvMg==
Date: Wed, 14 Oct 2026 17:29:09 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: vladimir@genproof.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-mips@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>
Subject: Re: [PATCH 0/5] lib/crypto: Handle large lengths in poly1305 and
 chacha20poly1305
Message-ID: <20261014152909.GA322435@quark>
References: <20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com>
 <20261013173508.GB3830@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013173508.GB3830@quark>

On Tue, Oct 13, 2026 at 07:35:08PM +0200, Eric Biggers wrote:
> Thanks!  Patches 1-3 look good.  I'm less sure about patches 4-5, since
> they go through some trouble to work around (some implementations of)
> poly1305_blocks() and chacha_crypt_arch() not taking size_t.  Wouldn't
> it make sense to convert those to size_t at the same time?

I think we should just get this out of the way by converting each
algorithm entirely to size_t.  The series
https://lore.kernel.org/r/20261014152604.323310-1-ebiggers@kernel.org
does this.

- Eric
