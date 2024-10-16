Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB301D89FD;
	Wed, 16 Oct 2024 21:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729115558; cv=none; b=gNcjJ+UJ0RZBNWXc900yCrRHSEm2z8NaiEE+A0qhh27AhO+EQZAOQaWEoxnHyc+S3Pu+ra7LZqMAdvZJevz6xrEMHGOb0ka2h+3UlMtRyNtSDstO8vojoUv7EyHkNsoMWqYmRairbQ0UIQCBXO5dB5j9kPAWYtdUZ3GyESVjO4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729115558; c=relaxed/simple;
	bh=5tc1+82dp6wDe1R4Y7etxIIb810WNhycOeeJf1JlQOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKd7DT/w2hftILMtUYcRiZAKX272zNsivkioF39vU6B/ulVnekzXhB9Xg/+nAzlh8c21l3s6pBVV4YycNaR6hTyfDuQq49TCYC2kaCFX3JWLIpWupWMCnxeQBkjEvpJrCjj1rdiL2o6iIm5TM2iiCd91d57q4+s8ywD2uNi1T4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hDPsV29+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hDPsV29+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDE4C4CECF;
	Wed, 16 Oct 2024 21:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729115557;
	bh=5tc1+82dp6wDe1R4Y7etxIIb810WNhycOeeJf1JlQOE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hDPsV29+EOm/ykfCjAsueOv7DoLTPE4U0loqcER2iuqKZiI6QHGOj3TtMlKsCgnwy
	 y3DQF7YygsKF/7QQCGIK1IQrPCNyxSl6InmpA0hM48nZrY+pNYH1aGPRwBofUgDrCW
	 sc6OVe/571EutZXrhKX5xKPH00IN1/1ZvPbIWTNzjzudvgp/QeQR+p7Vfs4dMG12uy
	 APbFiFVjelbLehAZavKop2ikrr77OwthCl6TgTcu7xDnxPBQ4ElfSXQu5YpyifSvzJ
	 9XCv9FHLxeacIFA18pgyxyptaztTK2Ozm8sMYGbm9lGXPYx2heIwYdDQWvVSs/thhR
	 lTXoFH7AEEOfA==
Date: Wed, 16 Oct 2024 14:52:35 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	will@kernel.org, catalin.marinas@arm.com,
	Ard Biesheuvel <ardb@kernel.org>, Kees Cook <kees@kernel.org>
Subject: Re: [PATCH v2 1/2] arm64/lib: Handle CRC-32 alternative in C code
Message-ID: <20241016215235.GB1742@sol.localdomain>
References: <20241016192640.406255-4-ardb+git@google.com>
 <20241016192640.406255-5-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241016192640.406255-5-ardb+git@google.com>

On Wed, Oct 16, 2024 at 09:26:42PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> In preparation for adding another code path for performing CRC-32, move
> the alternative patching for ARM64_HAS_CRC32 into C code. The logic for
> deciding whether to use this new code path will be implemented in C too.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/lib/Makefile     |  2 +-
>  arch/arm64/lib/crc32-glue.c | 34 ++++++++++++++++++++
>  arch/arm64/lib/crc32.S      | 21 ++++--------
>  3 files changed, 41 insertions(+), 16 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
