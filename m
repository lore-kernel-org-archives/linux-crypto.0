Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE2912E61;
	Tue, 11 Jun 2024 20:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718137932; cv=none; b=FCFA2fbQbxnH37X/+7a1Q0Xkeg/AXJmkEXg7k4Qx8wkx5l3DCfZR0JHuwI8PdG6hq7SzVFzBer8dMjTF31H+4foHfeZW2FWvi8ARfTKOZMTRJdphj0ws3lUkG/aglvrOpbC4/rV3IWx5ZRkP3zWzFrQ/G5K6IX3BRAcAMktbiuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718137932; c=relaxed/simple;
	bh=G8ObqV4GF1j+oexJE9NDUI3l/V6Cek7aJDyNu1zlm9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qbezBctzYzGu/uH+bikVne1iMomqgTGbltFtMn5uz6JIObqz3YQLg2I+AZSZPFxF+FQ95HmTQ7qVG2CzShj5gE/qy9wCz4Yd/7OX1QgV4ZG5aKM+3MQJwWxT/7eac2kXygHE15OBqrw3A9gnw6KHfzegxgIQWYYHO/L+wlF7lBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ITi6r1cQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ITi6r1cQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C199C2BD10;
	Tue, 11 Jun 2024 20:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718137931;
	bh=G8ObqV4GF1j+oexJE9NDUI3l/V6Cek7aJDyNu1zlm9o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ITi6r1cQKPeOmmodbECro67RGdiyNgpUQXFCIr/0smWwsxuIYn9Xy4mw4YVBstr9m
	 gwOXW+aMNgxwWKlPP3+G7lJ+uUb6R6Ucy3ApqkiEJN1oAK+sq3Kht4M1HN9dtJJD/L
	 vHfWynXI/OKQrluEnLQ5WrdUqadNP7RaNR9mu66RgaKT8ZDlR5u6fuKUEOgbmIeKFS
	 F9QYV9+98uh94NzcPP8cwSBa3MGFfZr6RiMwvCP57VdC3YgllZyLZx+EiNJPx2gfgu
	 7F1ZhKmfa2Bs3gUR0ckol1DgXS6LR86VGjwjo0d6lPWJe+N82YwApaSHld/JO9UIXX
	 aYjWziC/8YcTA==
Date: Tue, 11 Jun 2024 13:32:09 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev, dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Tim Chen <tim.c.chen@linux.intel.com>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <20240611203209.GB128642@sol.localdomain>
References: <ZmFL-AXZ8lphOCUC@gondor.apana.org.au>
 <CAMj1kXHLt6v03qkpKfwbN34oyeeCnJb=tpG4GvTn6E1cJQRTOw@mail.gmail.com>
 <ZmFmiWZAposV5N1O@gondor.apana.org.au>
 <CAMj1kXFt_E9ghN7GfpYHR4-yaLsz_J-D1Nc3XsVqUamZ6yXHGQ@mail.gmail.com>
 <ZmFucW37DI6P6iYL@gondor.apana.org.au>
 <CAMj1kXEpw5b3Rpfe+sRKbQQqVfgWjO_GsGd-EyFvB4_8Bk8T0Q@mail.gmail.com>
 <ZmF-JHxCfMRuR05G@gondor.apana.org.au>
 <20240610164258.GA3269@sol.localdomain>
 <Zmhrh1nodUE-O6Jj@gondor.apana.org.au>
 <ZmhvnBsqKe7AakY-@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmhvnBsqKe7AakY-@gondor.apana.org.au>

On Tue, Jun 11, 2024 at 11:39:08PM +0800, Herbert Xu wrote:
> On Tue, Jun 11, 2024 at 11:21:43PM +0800, Herbert Xu wrote:
> >
> > Therefore if we switched to a linked-list API networking could
> > give us the buffers with minimal changes.
> 
> BTW, this is not just about parallelising hashing.  Just as one of
> the most significant benefits of GSO does not come from hardware
> offload, but rather the amortisation of (network) stack overhead.
> IOW you're traversing a very deep stack once instead of 40 times
> (this is the factor for 64K vs MTU, if we extend beyond 64K (which
> we absolute should do) the benefit would increase as well).
> 
> The same should apply to the Crypto API.  So even if this was a
> purely software solution with no assembly code at all, it may well
> improve GCM performance (at least for users able to feed us bulk
> data, like networking).
> 

At best this would save an indirect call per message, if the underlying
algorithm explicitly added support for it and the user of the API migrated to
the multi-request model.  This alone doesn't seem worth the effort of migrating
to multi-request, especially considering the many other already-possible
optimizations that would not require API changes or migrating users to
multi-request.  The x86_64 AES-GCM is pretty well optimized now after my recent
patches, but there's still an indirect call associated with the use of the SIMD
helper which could be eliminated, saving one per message (already as much as we
could hope to get from multi-request).  authenc on the other hand is almost
totally unoptimized, as I mentioned before; it makes little sense to talk about
any sort of multi-request optimization for it at this point.

- Eric
