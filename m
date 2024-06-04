Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05100801;
	Tue,  4 Jun 2024 19:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717529145; cv=none; b=rzv5ndgc1rJrH7mkY/+mnjk1X78FLFrBwbrKzEMjsukjMVEG5VtbFo6caKgqtf854HEDZZ8RGL18Cj+l/LEV/tHEtdHmDvvM2pHs2MxH+yJ8cJECHvB/XA7LrEmWp/C7UH3PuxkHY6JRLwpk/TtUZIW8SP0dukLpmWiPw6szO8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717529145; c=relaxed/simple;
	bh=CfdX3QgpBeGkiViJGYp7o44OH979z8N7+Zs7t2WW+f4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dJaHosSxXLOImWLbK4Sc9T7+b5NBIWV3fRjqPNyCYxjbb3w48gLRHfUP3f41nX28c3swQmkwa+ee2Uuw5lZ4+JBBKg9Jr3Zv2JUsy5lkUhZmXQ9LGtJU1mqM5zP7WSEnRZtZ8QXzAbIbHAI4huMXVU1lgMcwtm1/AQdRjexx92w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4f+pTcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4f+pTcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36641C2BBFC;
	Tue,  4 Jun 2024 19:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717529144;
	bh=CfdX3QgpBeGkiViJGYp7o44OH979z8N7+Zs7t2WW+f4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A4f+pTcO0TotuaZzcRhFq6IxIsRM4Qm8d2eF2w0RCHVEGfvBUyiY26sLeUEe2H+yZ
	 gt+rOwUYrpWu7NmOPqtcgwQjhrRVFuM+pmeaMmkqPFln5SwJ5z/HtlucTFd/eiwTWk
	 VPaDNYps3o6VgZXIrGE8d4/XgTxJnCm5q/AzQgP7D+LjJScqnfEdjk+cv2s+MNDLgk
	 rA0n2GJkJeX6VJ9e1wBFVE5tF7LFKDdfyBMgYTZov8WakYIeJuoQ2h1fwXSPV0jlAC
	 041k0uANAgAnRtlSfIENmxulVOMGM7ee+vei2prIem8AOmci/IVlsIqa+Bo2EKGS6M
	 iVExfLAsdSi1Q==
Date: Tue, 4 Jun 2024 12:25:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 1/8] crypto: shash - add support for finup_mb
Message-ID: <20240604192542.GD1566@sol.localdomain>
References: <20240603183731.108986-1-ebiggers@kernel.org>
 <20240603183731.108986-2-ebiggers@kernel.org>
 <CAMj1kXHVbVhydU60zzUc8a-jVkboRz1pz0TW7Sx_5N_AvdhZdA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXHVbVhydU60zzUc8a-jVkboRz1pz0TW7Sx_5N_AvdhZdA@mail.gmail.com>

On Tue, Jun 04, 2024 at 08:55:48PM +0200, Ard Biesheuvel wrote:
> >
> > This patch takes a new approach of just adding an API
> > crypto_shash_finup_mb() that synchronously computes the hash of multiple
> > equal-length messages, starting from a common state that represents the
> > (possibly empty) common prefix shared by the messages.
> >
> 
> This is an independent optimization, right? This could be useful even
> more sequential hashing, and is not a fundamental aspect of parallel
> hashing?

If you're referring to the part about using a common starting state, that's not
an independent optimization.  Only multibuffer hashing processes multiple
messages in one call and therefore has an opportunity to share a starting
shash_desc for finup.  This isn't just an optimization but it also makes the
multibuffer hashing API and its implementation much simpler.

With single-buffer there has to be one shash_desc per message as usual.

If you're asking if crypto_shash_finup_mb() can be used even without multibuffer
hashing support, the answer is yes.  This patchset makes crypto_shash_finup_mb()
fall back to crypto_shash_finup() as needed, and this is used by fsverity and
dm-verity to have one code path that uses crypto_shash_finup_mb() instead of
separate code paths that use crypto_shash_finup_mb() and crypto_shash_finup().
This just makes things a bit simpler and isn't an optimization; note that the
fallback has to copy the shash_desc for each message beyond the first.

- Eric
