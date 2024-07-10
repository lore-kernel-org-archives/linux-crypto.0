Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278031B809;
	Wed, 10 Jul 2024 18:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720635259; cv=none; b=XMckIJYFPYdK+UpIwoz6MiEpNH+4dd2aVQidMAZVCS4PsOgW2PCpK7q0XZeyKIACBwOIWhSxr4ILlqF89EL1mpXfltWYbx1MdPjL8X2Ji4L9gea+mbFsGXfMMYTCx8R2/pBFBW7KhHAa2oQdlBJAlFav7Esm1VnrcnmP6HSymkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720635259; c=relaxed/simple;
	bh=PqIZtFDhIR4aNKnB7bdK7qEmMFV28vA12grouRhrCnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ttOh6mH1aGsWIrXWcaq+lQIgSzU6lLyXDHcNdFW0uR8CUKR4hDFItlzn6ypN54ssV7RaVf1m2l8D3LXp6demnusU5h44IwgUvB0TNBuxU1Nakb3JACjn3xoY4KJqMSzlqA+34avCSRE3GTs1VbZsPhW6b/QG7P/K+iIHaNwP4pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pXtalsw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pXtalsw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F361C32781;
	Wed, 10 Jul 2024 18:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720635258;
	bh=PqIZtFDhIR4aNKnB7bdK7qEmMFV28vA12grouRhrCnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pXtalsw5iz8YAtDSUtRUcz4U6SUkkNsO4Hf5KtdpaeGDbwgs+RyjdqS6FoxUmsB0K
	 cMvP+ctndr/FXvGNX9oGmuY6nJ6bVrTQ8WnTipRBPmhtvXWxdfNGKkPkNpnC1PBLPX
	 nwmq3tbWxkN+n1ls9p6daaNXmZsaiFo/Z5A6HsmY0doaX9q2Es6eBSM1P0R8jLO9mp
	 WFW+9v/mXfPqnyc5YFPhD2x8rQzr7zdnfZ7jTjTnKiZ8SUy+2UQjcUccLQdG9prqGG
	 kDefCRJns6BEqbA062CRlvdXw0YiQCqPDQKXg3NDDiVTWWKdZ+Rm84+j2XLkcN89YY
	 VDhcHs72ML4/w==
Date: Wed, 10 Jul 2024 18:14:17 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mike Snitzer <snitzer@kernel.org>,
	Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH v5 00/15] Optimize dm-verity and fsverity using
 multibuffer hashing
Message-ID: <20240710181417.GA58377@google.com>
References: <20240611034822.36603-1-ebiggers@kernel.org>
 <7097bafd-e146-99a5-7f86-369e8e2b080@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7097bafd-e146-99a5-7f86-369e8e2b080@redhat.com>

On Wed, Jul 10, 2024 at 12:54:24PM +0200, Mikulas Patocka wrote:
> Hi
> 
> I'd like to ask what's the status of this patchset.
> 
> Will Herbert accept it? What's the planned kernel version where it will 
> appear?
> 
> Mikulas

It's blocked by Herbert wanting to design the multibuffer hashing API in a more
complex way that doesn't make sense.  See the previous discussions.  I don't
know when Herbert will change his mind, so for now I've shifted my focus to the
Android kernels.  (In the mean time, the improvements that don't depend on the
actual multibuffer hashing API still make sense to apply upstream, though.)

- Eric
