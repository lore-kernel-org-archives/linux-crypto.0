Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E9F18DB3C
	for <linux-crypto@vger.kernel.org>; Thu,  6 Mar 2025 03:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741230609; cv=none; b=soz+LMhYD+if62DRFZER4zv7KV1IgfaFmPK/RmyDyBXw6csUIzcVmhE54Bj/F1VYs9NOufQzD8veBycoHCDVhpZUQNGA0oeDKkhWoHqmIjPJwZivT+4MzGUupSCzjPwt1HQzSGnDNKp5rR3cbcrQVdCRcw/RZc+saoIwQMiKH5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741230609; c=relaxed/simple;
	bh=liFhxqEU+2dfgS7oOYtO6TAJsmGqzwk65BX/RGGQjzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nvEuOj6OfDE44JSzYVN3pxGYWZbPN7yTXCsb8iD6gKvi0Jlp/6wopg48ARnVgnKeIXPxClxYv5t8JKbpTpj/Ye0GnT9GY1mQT390lC/8nPaYcsvzCngZuccY9npwhmDE80P5D6BlXrN5giOuxSS1UPByADDQ0UBrGNrDj7pwZl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SeabvXBi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SeabvXBi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44AAC4CED1;
	Thu,  6 Mar 2025 03:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741230606;
	bh=liFhxqEU+2dfgS7oOYtO6TAJsmGqzwk65BX/RGGQjzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SeabvXBiwCNi3OiOZEXDFtq7KPozq59p0ufiSASqlCk/0vb/sOiAyTc67dXH2cfhT
	 pVSD/eeLtTGf8ckyYoAcEbYuQfLJ6m38OCy+I4XzumV3Tm7y7xSQWY5c9jaShhPwJt
	 OnJVU8s8LifQY7uJlJz/0Wv30u9Rnr6cjN7F1WqULXWUZ4OWJLzlm51adRNibEaLRc
	 x+droU3xzpYc+9xv2Spaw/Y3+97A3+NN3zSiAyx1HoZDMqANKXAu625GtbCwtHo04F
	 RU2S4Iir3ISWoxXW7MsFakYOOaLMRjy4Hb/MCa0VHm3hkciSMVzYiVJz+bw/hIt8Rd
	 HILFHwiY+JcoQ==
Date: Wed, 5 Mar 2025 19:10:05 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: scatterwalk - Change scatterwalk_next calling
 convention
Message-ID: <20250306031005.GB1592@sol.localdomain>
References: <Z8kOABHrceBW7EiK@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z8kOABHrceBW7EiK@gondor.apana.org.au>

On Thu, Mar 06, 2025 at 10:52:48AM +0800, Herbert Xu wrote:
> Rather than returning the address and storing the length into an
> argument pointer, add an address field to the walk struct and use
> that to store the address.  The length is returned directly.
> 
> Change the done functions to use this stored address instead of
> getting them from the caller.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Why?  All the callers keep track of the address anyway.  I don't see a need to
bloat the scatter_walk structure beyond a simple (sg, offset) pair.

- Eric
