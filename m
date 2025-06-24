Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3036F5680;
	Tue, 24 Jun 2025 02:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750733174; cv=none; b=kyjaAo1DgSKcLU7c6GgwpAuPBtiHRF0LjIo1LvezzUzztL8BPmr3ZFnesMmNiHXa5PVgqAB/zw3prEf/nNhzW8kFZ9PE7RJONrjJkhMxmhflcuxapZGB3RdGdu6KC8aCURRLLPeud/p212QLwLuEYCDcm87TAqa39J5e9fu9bto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750733174; c=relaxed/simple;
	bh=EjHWaD9DhlxJg5t8c7HONRRxLIGyndgE8Wf80m4Kmis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LtiakCl52Et4xMuROHO74eXetEltnemg0R0T8+Hm35BmZOaemGmgcZdrmEwVcr63zyslBSamMgK55vITzdcKTQWWHOd5r7yiBGpMFDsDE6jao5JKeXzrFQqaIWyLr03nd8FadVnjN0twL9h3uhtOGEwlQSGxcjDyN3qMUD5hUmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WQzERfzF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WQzERfzF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D782C4CEEA;
	Tue, 24 Jun 2025 02:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750733173;
	bh=EjHWaD9DhlxJg5t8c7HONRRxLIGyndgE8Wf80m4Kmis=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WQzERfzFbi9TYBsOzZGjcurc4NUiaqvGetTgbt7gXN8LrkpwG8h9Q9Wi+Lbv3FkkF
	 NuFeZx7p1CRYe+IUVZ7y0siwQIFTyDYtmJlXZlJJKLLfT2WjQ3l0bJF6zDxCVNir09
	 GtJPc7RnnNgcMe/UbGq81VTSr1kjxaPyZncK5a1Lh9aURMVA18tp/njwiBLtBa6UnS
	 zLba/PrqBsk9CgULPZ19dXd0dGT0yX/NUHXiRcK8anglUenv/MN66ZJQ6ucW7asDx3
	 IBjLiLjAVcKOo4AmG/nWUQOsd8Y3WG7gta6uQLt5Sb5kUBkYf3j5q0Z6Rgr9V/zBG8
	 7lQgQ6nP+ccXA==
Date: Mon, 23 Jun 2025 19:45:39 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld " <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, x86@kernel.org
Subject: Re: [PATCH] lib/crypto: x86/sha512: Remove unnecessary checks for
 nblocks==0
Message-ID: <20250624024539.GB7127@sol>
References: <20250621021549.105357-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250621021549.105357-1-ebiggers@kernel.org>

On Fri, Jun 20, 2025 at 07:15:49PM -0700, Eric Biggers wrote:
> Since sha512_blocks() is called only with nblocks >= 1, remove
> unnecessary checks for nblocks == 0 from the x86 SHA-512 assembly code.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/sha512-avx-asm.S   | 6 +-----
>  lib/crypto/x86/sha512-avx2-asm.S  | 5 +----
>  lib/crypto/x86/sha512-ssse3-asm.S | 6 +-----
>  3 files changed, 3 insertions(+), 14 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
