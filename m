Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB01823C8C7;
	Fri,  7 Feb 2025 22:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738968158; cv=none; b=doXMlN6WHbf/8RF/+ohG0BHwn5PdhXgvUnC6WndrTW2so4nDrfauFuKsG6Zg8qJ4a/i6++IT9seAnfW3x6yrjDGqmhdrA1HNLw516DRVqzGm9Ev4l52VW5oYfKWyf5OevOwSmdcUxG+m3Dwcbk+zUaZF4pF1f347P61P7T693HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738968158; c=relaxed/simple;
	bh=e6N1reNA5jmP9vbOOxyHDPx2quiPc7yFdLI+JjMkcvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FTeq2iFmR9cCdt+N8PP6ZTfoXsuDvrlMtnf8rW/IstJESsRx1V2RQrywUY86+HGgQ+5LD4pEgeP1Tfc5k9P+sL54H6Q/ZTZSNxPe/auYFCb8mCabqhFYALN7Qtw9DEaJdHsZmjfchjN3KiTWjDZe5pnAZyrIkTKX+3qjLi540IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m64O1MmC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m64O1MmC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4BBC4CED1;
	Fri,  7 Feb 2025 22:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738968157;
	bh=e6N1reNA5jmP9vbOOxyHDPx2quiPc7yFdLI+JjMkcvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m64O1MmCjViLXEUOc4/59wfBwgY+MC9SSxmKFja8tsAWK4r4InIj2elpJzQTtWjK/
	 K0YFG1El/qhpDWv1SyxwQFeQE+ZXN/A8jqVy+f0aJ4EmoW/EQfTeBnbULTe3TsEgcq
	 QbSUen08E3DF6jjip+YNwqj/kc75a1aM+cmq0TO+iLyBxclUneyfaB8dkRk0q6enpR
	 O3qG45jU6J6YMIRag/rjokMjEgYDVob/C7O2KrNt1Ll/FD+JgRtdn+1GpZZaFSBQ1g
	 VkCHlT6jkXqAycokERPT5zoEdnGeLhwuZ14aY+aAWvqiaqdgTWMkXPr0+yqxHFUa0m
	 gVk0YdG2emBVQ==
Date: Fri, 7 Feb 2025 15:42:33 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 3/5] lib/crc32: standardize on crc32c() name for
 Castagnoli CRC32
Message-ID: <20250207224233.GA1261167@ax162>
References: <20250205005403.136082-1-ebiggers@kernel.org>
 <20250205005403.136082-4-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205005403.136082-4-ebiggers@kernel.org>

Hi Eric,

On Tue, Feb 04, 2025 at 04:54:01PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> For historical reasons, the Castagnoli CRC32 is available under 3 names:
> crc32c(), crc32c_le(), __crc32c_le().  Most callers use crc32c().  The
> more verbose versions are not really warranted; there is no "_be"
> version that the "_le" version needs to be differentiated from, and the
> leading underscores are pointless.
> 
> Therefore, let's standardize on just crc32c().  Remove the other two
> names, and update callers accordingly.
> 
> Specifically, the new crc32c() comes from what was previously
> __crc32c_le(), so compared to the old crc32c() it now takes a size_t
> length rather than unsigned int, and it's now in linux/crc32.h instead
> of just linux/crc32c.h (which includes linux/crc32.h).
> 
> Later patches will also rename __crc32c_le_combine(), crc32c_le_base(),
> and crc32c_le_arch().
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
...
> diff --git a/include/linux/crc32.h b/include/linux/crc32.h
> index 61a7ec29d6338..bc39b023eac0f 100644
> --- a/include/linux/crc32.h
> +++ b/include/linux/crc32.h
> @@ -27,12 +27,11 @@ static inline u32 crc32_be(u32 crc, const void *p, size_t len)
>  	if (IS_ENABLED(CONFIG_CRC32_ARCH))
>  		return crc32_be_arch(crc, p, len);
>  	return crc32_be_base(crc, p, len);
>  }
>  
> -/* TODO: leading underscores should be dropped once callers have been updated */
> -static inline u32 __crc32c_le(u32 crc, const void *p, size_t len)
> +static inline u32 crc32c(u32 crc, const void *p, size_t len)
>  {
>  	if (IS_ENABLED(CONFIG_CRC32_ARCH))
>  		return crc32c_le_arch(crc, p, len);
>  	return crc32c_le_base(crc, p, len);
>  }

I think this rename is responsible for a build failure I see with an
ARCH=mips configuration on current -next:

  $ make -skj"$(nproc)" ARCH=mips CROSS_COMPILE=mips-linux- mrproper 32r6_defconfig arch/mips/lib/crc32-mips.o
  arch/mips/lib/crc32-mips.c:25:9: error: 'crc32c' redeclared as different kind of symbol
     25 |         crc32c,
        |         ^~~~~~
  In file included from arch/mips/lib/crc32-mips.c:12:
  include/linux/crc32.h:32:19: note: previous definition of 'crc32c' with type 'u32(u32,  const void *, size_t)' {aka 'unsigned int(unsigned int,  const void *, unsigned int)'}
     32 | static inline u32 crc32c(u32 crc, const void *p, size_t len)
        |                   ^~~~~~

Cheers,
Nathan
