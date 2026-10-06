Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1BA83E8330;
	Tue,  6 Oct 2026 12:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791289553; cv=none; b=tOyOjXOSLitH2473Z2Yke4RuwZ3BXPMhnFhEyPv8bn0ZPTkJURlL58+juBaZCTxPKVWKmINwoxJekeDhDNDQVv0H/laBMu7KeS7REH5CYIxB2dJUyJgDE/DPJP+PXMcfHn7CNlBblR0G2VNEy1IyaYjyArnHb6PEl2i1oKjxIrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791289553; c=relaxed/simple;
	bh=5H73/Z6sPEsge/eG1IdDIHETN9ZipQAXkMlSy49tG+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KWgxiWb4MfET5pZmhtovs4TcfFVT7+Ty130iU1xKIYf1JU22LUalyaSefAOlMv49UvxWWXGx8uAKb7EX/qC1AotSTKycfUUcjZ9oEsHjbt5N1y+0k0WneKRyX8hHnZaBOiEI82mrmOP4RbMFySu6MLrSzkxAIe8H+EmrWrNnJM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C5fmMLHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C5fmMLHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 807521F000FF;
	Tue,  6 Oct 2026 12:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791289551;
	bh=p+mFRfnTk3spTB2omQZgsPm2EG76Mrdx84AEl8OfAMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C5fmMLHYOuHwizsfJ27d7dSOWEi2/S2Ytj/KrFPPeegB+E/DTNSr4CayPrIUe+cPN
	 LMH9rn2/cps+fCUB7pxzH9ZUHdCY58xmRJwQ6FeFhGMTIPLK5iAjy622QXEZGHq8H3
	 n+ZbeCmNSd63vXXSa9JBh+71kd6n5xGVVWmweJKzbIUGi7Y4z/SUHU93MQ/2eVlDDt
	 vJamTPHhHwjVUCSAcjFpgKz8mw39irLdl06YwJ/eCy2BBJuE44jbeFawlR42fbBZNf
	 a5Sws1kn7QEge5KfqoOKv27PwGME7teB0KnPQDI4Z9ygUDFkqNlrQVtAS9DDE1KsF+
	 qqXfTaEQ66h2Q==
Date: Tue, 6 Oct 2026 14:25:46 +0200
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH] lib/crypto: poly1305: Use memzero_explicit() in
 poly1305_final()
Message-ID: <20261006122546.GB3185@quark>
References: <20261006083432.16328-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006083432.16328-1-ebiggers@kernel.org>

On Tue, Oct 06, 2026 at 10:34:32AM +0200, Eric Biggers wrote:
> Use memzero_explicit() instead of a plain struct assignment to guarantee
> zeroization of the 'struct poly1305_desc_ctx'.
> 
> Note that dead store elimination was only theoretically possible with
> link-time optimization here.  But it's still worth fixing.
> 
> Fixes: a1d93064094c ("crypto: poly1305 - expose init/update/final library interface")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/bug/linux-c3a6bd76-f6ab-4203-892a-cd06f7aa0c34
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/poly1305.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
