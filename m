Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCCE92AD0C
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 22:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774996382; cv=none; b=W+j8418XlFQg5+x9Jd/dgbnIxkAILpOhVIXpQC8Nuy8GnT1GiASAduZgBKG1EVv0gT+xSaWSJkevDN/xC0b+S8J24OBK3dsnH7kbBI2Mq52nftAKWAA9dpCasHQSEuH0XQeTJLerIZX5X3CtVixtbrDayUlJqkcmEruDYZyxYBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774996382; c=relaxed/simple;
	bh=RJQkS8bUU8ttoMMCwjfNIsTwajwii9xgzqJ9jw17VAE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZOzUSgqNx39wRDpmKOfbUurFN8fL5vbpzbydL8q3ooJXbjM/PSzB7lvOZy/S/EhLEl51QnC8Bzq/teF8pCqhu0H+SP+/+M+z/apRILrZzEK+rm80GM5fuKb0pEH2HJKTiJmTAedKBZ9ZFo+w8YttYmv0s8aBNGPhYnPGiOg4JhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cbHRqBeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cbHRqBeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2879BC2BC9E;
	Tue, 31 Mar 2026 22:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774996382;
	bh=RJQkS8bUU8ttoMMCwjfNIsTwajwii9xgzqJ9jw17VAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cbHRqBeSoYgfTE3DFt478XB2sAGrHwnP3pluE0g7KfKYO5IyjPKzQKNda8WfNYPdP
	 T74vQZvwx/hci0GdiDSYVGQymjvfK7uYKFnMwhgoXGdG6Spc6TRT1wTRuk/iGUsjvp
	 6EV+s9GR0S4JBMhefTroJ3sQtMZWBRlTurBSwI9WMsnYvcPoUuFlsBkye/a2184IYF
	 p/hB8wfG7lNzS/bZ2nSURnlrRK7Z/5M7nX6xBoZ37fuenrMGxRqLJG0MbKNGQcLWlW
	 fmoXHS1x03HVb7OYB49waYYKROPVWmDvPovBlXEV86XsxnN8kK54+C9GMaj1vHLJeU
	 ka5cwaAPBkakw==
Date: Tue, 31 Mar 2026 15:33:00 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Demian Shulhan <demyansh@gmail.com>
Subject: Re: [PATCH 1/5] lib/crc: arm64: Drop unnecessary chunking logic from
 crc64
Message-ID: <20260331223300.GA45047@quark>
References: <20260330144630.33026-7-ardb@kernel.org>
 <20260330144630.33026-8-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330144630.33026-8-ardb@kernel.org>

On Mon, Mar 30, 2026 at 04:46:32PM +0200, Ard Biesheuvel wrote:
> On arm64, kernel mode NEON executes with preemption enabled, so there is
> no need to chunk the input by hand.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

There's still similar "chunking" in other arm64 code:

    $ git grep -E 'SZ_4K|cond_yield' lib/crypto/arm64
    lib/crypto/arm64/chacha.h:              unsigned int todo = min_t(unsigned int, bytes, SZ_4K);
    lib/crypto/arm64/poly1305.h:                    unsigned int todo = min_t(unsigned int, len, SZ_4K);
    lib/crypto/arm64/sha1-ce-core.S:        cond_yield      1f, x5, x6
    lib/crypto/arm64/sha256-ce.S:   cond_yield      1f, x5, x6
    lib/crypto/arm64/sha3-ce-core.S:        cond_yield 4f, x8, x9
    lib/crypto/arm64/sha512-ce-core.S:      cond_yield      3f, x4, x5

I thought it was still sticking around, despite kernel-mode NEON now
being preemptible on arm64, because of CONFIG_PREEMPT_VOLUNTARY.

However, I see that support for CONFIG_PREEMPT_VOLUNTARY was recently
removed on arm64.  So that's what finally makes this no longer needed,
and we can now clean up these other cases too, right?

(Though, I can't find where the voluntary preemption points actually
were.  So maybe they weren't actually there anyway.)

- Eric
