Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FBD41D207;
	Fri, 16 Oct 2026 07:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792135715; cv=none; b=MJ/mUbB4K49TgS48Nyh37sEREEsm8RakgPl+Uazz1+GrDabhdRlZoCDj3sh85s6k/71MGip2biEyoyct8fpBONCGQZHNQ6mkgUMaLVJ1zHH6rwVabjUmE3Iy+qR3OAOh5Ck3J6S8jfirNBw2zXfoGwU/3zQFulLv0pFuqgNjPF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792135715; c=relaxed/simple;
	bh=8xugVm1a1LgqvkMzsAb9wqV9z7r95s1sXrlrg4kRQUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RXAFVrC32m0tR8RmvESxNDzh2Nue9sU8ZapT5HJmrQmhJJg1VLWp5qSTChfAoP41N6vys1Sh4mGde4KP4Vpe2UXRSBK6ojc4A0bVTjxUCkgWPIOPHD+hx9sCSHR3zZJ2+OF+I5lcVLmIbOi0QvmgVmRkOTjXncp8V2bhAXHOt7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IUlNv2tw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IUlNv2tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08EA31F000C4;
	Fri, 16 Oct 2026 07:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792135710;
	bh=pNp2YJ+Y5SdErw6Ab/y3hbdW6rjh1/wNUfCJcAk2cKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IUlNv2twofde6OmdwgX786C3KNvkem9kuBGw1lCo2lnm+eIpsdXcfaMLk+CreWsvW
	 DsgVgHoxzAyBif6qAgd5GW9/qD6lerklm9+LuLckfyfkfaBWr7uavBKIUBCuZlkhqR
	 hBsRvePQvTeLm/9poxnL+q2Eb40Tz1F2DHxxkI6i2Kxs+7WFY7FPUh5EGPnvBxmW6F
	 GMp9tiUS5RcE/lFpzc7HwdAlIjagFtlti4+slHwJrmwoSor0zWIyFdu0k6lV/gFp1J
	 JrVKetcWrXMSX1hCxSu3hdr4Ow+81BfRouH9LFuBYTnO918q870Zv0UBDp/mrSvSyF
	 IhW/+bjVhZYTg==
Date: Fri, 16 Oct 2026 00:28:28 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: vladimir@genproof.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org
Subject: Re: [PATCH 0/2] lib/crypto: chacha: Handle lengths of 2 GiB or more
 on 32-bit arm and MIPS
Message-ID: <20261016072828.GB3049@sol>
References: <20261014-libcrypto-chacha-32bit-2gib-v1-0-e0719ca0be89@genproof.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-libcrypto-chacha-32bit-2gib-v1-0-e0719ca0be89@genproof.com>

On Wed, Oct 14, 2026 at 08:34:20PM +0000, Vladimir Kukharenko via B4 Relay wrote:
> On 32-bit arm (the scalar code) and 32-bit MIPS, the ChaCha assembly
> treats the length as signed, so lengths of 2 GiB or more are still
> mishandled after "lib/crypto: chacha: Use size_t length", since size_t
> is 32 bits there.
> 
> Patch 1 makes the arm assembly use unsigned conditions.  The MIPS
> assembly relies on the sign of the remaining length, so patch 2 instead
> limits each call to 1 GiB from C.
> 
> This applies on top of
> https://lore.kernel.org/r/20261014152604.323310-1-ebiggers@kernel.org
> Feel free to fold these into your series instead.
> 
> Tested with the lib/crypto KUnit tests in QEMU on arm (Cortex-A7 and
> Cortex-A15) and 32-bit MIPS, plus a temporary 2 GiB test on the
> Cortex-A7 and QEMU user mode runs of the MIPS assembly.
> 
> An LLM review found these bugs; I used an LLM-based assistant to write
> the patches and reviewed its work.
> 
> ---

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
