Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14BA2A1CA;
	Fri, 26 Sep 2025 21:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758921335; cv=none; b=HvdtOmt1fsjSLzun8+ePDRcFhNiSd8Wz9lXj9QIZTx9tAogflfqjPbBrwUOgQa5j6OWpd//qlrkkFjIbyyrr0WEYEjKAIkmFwV6m5ZzynabErR4yTrFlY07e0Zk3GIFsEq1MDbFBDAkOoMGJEbVkIrb6I9CW/IVcyjkVq35gpRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758921335; c=relaxed/simple;
	bh=okQjjj0joKJ+Opzp56EoeGNEw0QQMKtvlGMUDRv47hU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AANJude8n1FN9LemRfydZiNM8SShFz2hfVI/sSnrbTq+1DNDvfIqTbTZnMqCMDsWD7u3wYjKp3IIWoyRoKqxl79wOXnxX0jDs19CVNQqpeLMlZ9l+HZguthAbJwjEITtcAie+sIdFodE2NA13Kbm7Mbfw6UJ4t2mTc/mRi8hlOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sZ80b6jK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sZ80b6jK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25527C4CEF7;
	Fri, 26 Sep 2025 21:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758921335;
	bh=okQjjj0joKJ+Opzp56EoeGNEw0QQMKtvlGMUDRv47hU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sZ80b6jKS+H/2smtekY+MZCh/uUzx2BR8PgXw+pgwhoMTLx233ECCYryYpBuI9Mal
	 ToEydgoJnb9GzU5AnkkItIrYeXLHCRmrmM/cKQq6BtYaNQyj1nvAyH5/mwWwhwZogy
	 nvvNxnDy/hJZ+uVAcUYBWtmncaWajii+D9rh9GMKsMAlcK/sUrk3j9zKtRBKFz0O8v
	 fH+4Z88PYXe1dKeXHsyp5KjS55C7cm/HbrxPmiEs1EnPcGUvBD9bOH0jaNLyVcrs89
	 5U3K969qHh9ltiYrFVI9sDRwcdhkZxU9z8wQ5lxhnrWyTl78UySyyvalJ4lK6NkBl/
	 aF8i6HrHL3Qew==
Date: Fri, 26 Sep 2025 14:14:15 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/8] crypto/sha3: Add SHAKE128/256 support
Message-ID: <20250926211415.GC2163@sol>
References: <20250926141959.1272455-1-dhowells@redhat.com>
 <20250926141959.1272455-8-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926141959.1272455-8-dhowells@redhat.com>

On Fri, Sep 26, 2025 at 03:19:50PM +0100, David Howells wrote:
> SHAKE128/256 'digest' algos need to be available for the ML-DSA pre-digest,
> which is a selectable algorithm and need to be available through the same
> API as, say, SHA3-512 and SHA512 both.  Resqueezability (probably) isn't
> required for this and they'll produce the default number of bytes as the
> digest size.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Eric Biggers <ebiggers@kernel.org>
> cc: Jason A. Donenfeld <Jason@zx2c4.com>
> cc: Ard Biesheuvel <ardb@kernel.org>
> cc: Herbert Xu <herbert@gondor.apana.org.au>
> cc: Stephan Mueller <smueller@chronox.de>
> cc: linux-crypto@vger.kernel.org
> ---
>  crypto/sha3_generic.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)

I recommend holding off on this part until you have a try at using the
SHAKE library API directly.  The dispatch to different algorithms could
be done in the calling code.  This patch would also limit the ML-DSA
code to fixed-size SHAKE outputs; is that really going to be enough?

- Eric
