Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6358F25A625;
	Thu,  6 Mar 2025 17:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741281671; cv=none; b=IRufXvl143T/xdvboon3fq932u0YuG5hrJz/axuxB+fozhsW0ChUpL92Ediazs3bOqUA7IPxWKowytahrzjefwdRaufIyAvBg3qihkMZ2AP32aNLW/ijS/6LjgUMPdUmn7bvkYNquK9OYf1q4bLiDbF2yLLeN5D+QjMmi2OBnTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741281671; c=relaxed/simple;
	bh=i0ekTf1M+bd5eEWZXf6YDhkPTOgl8mRGaDK1NwV/q3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bFJOAjdtr8QvUjeibYSlIYZwSdITFjLgDPphjid7GcX7GkfBtQUk9sbZSWV4La0ZKtoqlLzx/6aqi8VcQLZkDhlkI++DRLLrTX4FK9TH7KB2+/gn94E0bJC8qqJUDhTJfd0Gh7fO2RzBR/Kgpz34ItNVrzp6xnx6zvhtbl12IFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YIKQ9I4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YIKQ9I4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E6AC4CEE0;
	Thu,  6 Mar 2025 17:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741281670;
	bh=i0ekTf1M+bd5eEWZXf6YDhkPTOgl8mRGaDK1NwV/q3k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YIKQ9I4jsrv0V8I3AwahPaVjd78I/dtipLm9M/X896M9bAQUHeydbF+TOTlG5wvSu
	 J5VFQVZ7rxvWyPPuoGIcCo/nd4e/71HF1ujYVQ1jup5u5Ys7zAns910Zn2Gntt7zp4
	 kXDCkafdKoLa9GTgEytdANH6af4Ec3XKqZ9HsFFqu+8q0gxykgxqDCgfK7R7d/F2em
	 rGcsxFcYxiJYbgw7iusBiFgf+3IMrjsNE3KbiAh573H6Qd/AXtL8wma33E6XKYlW2K
	 fAaPTK9Tw1osO0WF19oKUWKnfhlVfMmPig9MBDNrBpDhGPD7Y0sMh0b5jsmAfO9NZJ
	 Bo2VWbWgEbj5Q==
Date: Thu, 6 Mar 2025 09:21:07 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Bill Wendling <morbo@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Justin Stitt <justinstitt@google.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-crypto@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH] x86/crc32: optimize tail handling for crc32c short inputs
Message-ID: <20250306172107.GA1796@sol.localdomain>
References: <20250304213216.108925-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304213216.108925-1-ebiggers@kernel.org>

On Tue, Mar 04, 2025 at 01:32:16PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> For handling the 0 <= len < sizeof(unsigned long) bytes left at the end,
> do a 4-2-1 step-down instead of a byte-at-a-time loop.  This allows
> taking advantage of wider CRC instructions.  Note that crc32c-3way.S
> already uses this same optimization too.
> 
> crc_kunit shows an improvement of about 25% for len=127.
> 
> Suggested-by: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> This applies to
> https://web.git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

Applied to
https://web.git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
