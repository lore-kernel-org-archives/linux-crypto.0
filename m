Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA3A2FC863;
	Fri, 17 Oct 2025 17:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760720789; cv=none; b=iFSCWm/qUUSstTmfHC+8aDms23qgVqpaDBwVfUrdU0/6ihPAFSTzWOMtHRbF+3VzWUgpHv1p/ROGQf7QDNqnIARNllY8voqNWpy9CIiSv5zcgylJkjvQRY32dAZ/cspYcTWHORfCrTq5C3oX5bo/NKcWp5ACv7ymswebfPpF8QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760720789; c=relaxed/simple;
	bh=IxOsuJ9eV4kD5BLNCDQgKv6gJY2/5S9nBRSu63LVZec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JL/jQCMYPqx8gpDImDXMSLOx6nWI3e19PhlRfKPAuvJCoa6IvrOyNmTylYvSr1Lm8uRr0dKzl6Bg47oiIGhkzw3F2uzjx2sQST186ee6pwg6kcMB6L8bur2PW4pjBqtX/fgypzAscjA1btqk5ckKnKufANs/pufhYlQoYLGo1Jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFsttR0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFsttR0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A065AC113D0;
	Fri, 17 Oct 2025 17:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760720788;
	bh=IxOsuJ9eV4kD5BLNCDQgKv6gJY2/5S9nBRSu63LVZec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QFsttR0jKWDN5HM8+UFu04Ft7wUGOnEPfMuLI7PgPya5yajETIqZ69yBUfZ07PPc7
	 Rpr07abkBlET43gaZWkGMQmgdAqVrW1gmXJ6vIo8BVLhuTqYMHK/UqLFo3UW6jt9CM
	 FtTxjyKPHyms30CfyBGxpQzgefBAtNITTRtxyycfmS+qzLj5Vqu04/ac8q85dbvhmF
	 UoE2H3FEfj4o9Gt6QX4CILfR6RuWFKtrrdUajj+k0MPrUsMv+nUQM+m4Jwx3Ahe/CD
	 E6Vj+mQsT8Q2vnJ1PzN69CUeyEKsZqjE89vbSg2BOgx3fiHEw717+woJXokI+b5EW5
	 H4l4q41O2cX+w==
Date: Fri, 17 Oct 2025 10:04:56 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v3 03/21] crypto/arm64: sm4-ce-gcm - Avoid pointless
 yield of the NEON unit
Message-ID: <20251017170456.GD1566@sol>
References: <20251008154533.3089255-23-ardb+git@google.com>
 <20251008154533.3089255-26-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008154533.3089255-26-ardb+git@google.com>

On Wed, Oct 08, 2025 at 05:45:37PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Kernel mode NEON sections are now preemptible on arm64, and so there is
> no need to yield it when calling APIs that may sleep.
> 
> Also, move the calls to kernel_neon_end() to the same scope as
> kernel_neon_begin(). This is needed for a subsequent change where a
> stack buffer is allocated transparently and passed to
> kernel_neon_begin().
> 
> While at it, simplify the logic.
> 
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> [ardb: Simplify convoluted logic]
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/sm4-ce-gcm-glue.c | 25 +++++---------------
>  1 file changed, 6 insertions(+), 19 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
