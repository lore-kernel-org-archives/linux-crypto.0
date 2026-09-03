Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EDAB4EE869;
	Thu,  3 Sep 2026 19:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788463628; cv=none; b=Sbppym602OFFRvaHJLZsNdaLzDKcHRJ30fY/oOqmFI6ovWZltXOEC4nITtOPJ5ASYI7wBhtbxAi0ngirPLUYHElRbJvj32QVTgrXRHrXPzrIIb4j+3b9WrDGhyb+OUsVm3hiLB+4IUsqKgTY6ju9dt4i97AIsqgaWigRtk6wo0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788463628; c=relaxed/simple;
	bh=BgP8+95/6vEmrlIraHj47/zkIwElt+b1Drvj5uQW69w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B1zKsuynIa4ofiIV7gcSyM7VJLef66GiH2tC0CJ1/bWv+wIibQxxVJVspZ0TNLLMlLjMF/94OtM09G5PVnGXPtp+p9g7CDES+vH2tmNx6JuFcG7IQc+Eo6gr6Dc6dUw0k2wgR8SAIL9a20hEgq9PwMygfGtSiZ5VsTY1J8VYtZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iR+n84GJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iR+n84GJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B22F1F000E9;
	Thu,  3 Sep 2026 19:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788463620;
	bh=OvxzmwmAQY0Tv3mevNOknHbiI1QZip1if+quZm55a0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iR+n84GJ2aCL6sHqe5gvYhazIQroLXGxeWI5qlY5mq+gXYKcaimflwMa1EMJzd718
	 CVk+c5qDFzZ6DoCiHVlp8/VLy9KcYecVKSIldSNBzv9uX3rngRvu2TBVuXuBiLgIZ8
	 mvcj4wrdqh4HqM/tFS4hLHs7XuhcEn3DSz/ICeUePlrhGmoRYcVFHxd2PB+4r8OKtA
	 W8g3RXTYo1pzhv3zSw4prgEQgtjWBndz/Mf8vk6KehojQGIaIdtWBah0h2HtUv/vo0
	 iCSXm0ajhs1oNDmT7/b5aLCeCH0CKlPO57TU5VWzQRFFDcIAfMlNCe1AV5sHwF3h0o
	 0IWVUxCqNokZw==
Date: Thu, 3 Sep 2026 14:26:57 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crc: arm64: Fix const keyword in asm prototypes
Message-ID: <20260903192657.GA2344@quark>
References: <1073b77747354d8d46d8804970acd80245e4c318.1788436846.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1073b77747354d8d46d8804970acd80245e4c318.1788436846.git.geert+renesas@glider.be>

On Thu, Sep 03, 2026 at 02:03:50PM +0200, Geert Uytterhoeven wrote:
> Commit d36cebe03c3ae4ea ("lib/crc32: improve support for arch-specific
> overrides") corrected the position of the "const" keyword in the
> arch-specific funcions, and replaced "unsigned char" by "u8" for
> consistency.
> 
> Make the same change to the forward declarations for the asm
> implementations.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  lib/crc/arm64/crc32.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/lib/crc/arm64/crc32.h b/lib/crc/arm64/crc32.h
> index 1939a5dee4772972..332d9092ba2f3875 100644
> --- a/lib/crc/arm64/crc32.h
> +++ b/lib/crc/arm64/crc32.h
> @@ -7,13 +7,13 @@
>  // The minimum input length to consider the 4-way interleaved code path
>  static const size_t min_len = 1024;
>  
> -asmlinkage u32 crc32_le_arm64(u32 crc, unsigned char const *p, size_t len);
> -asmlinkage u32 crc32c_le_arm64(u32 crc, unsigned char const *p, size_t len);
> -asmlinkage u32 crc32_be_arm64(u32 crc, unsigned char const *p, size_t len);
> +asmlinkage u32 crc32_le_arm64(u32 crc, const u8 *p, size_t len);
> +asmlinkage u32 crc32c_le_arm64(u32 crc, const u8 *p, size_t len);
> +asmlinkage u32 crc32_be_arm64(u32 crc, const u8 *p, size_t len);
>  
> -asmlinkage u32 crc32_le_arm64_4way(u32 crc, unsigned char const *p, size_t len);
> -asmlinkage u32 crc32c_le_arm64_4way(u32 crc, unsigned char const *p, size_t len);
> -asmlinkage u32 crc32_be_arm64_4way(u32 crc, unsigned char const *p, size_t len);
> +asmlinkage u32 crc32_le_arm64_4way(u32 crc, const u8 *p, size_t len);
> +asmlinkage u32 crc32c_le_arm64_4way(u32 crc, const u8 *p, size_t len);
> +asmlinkage u32 crc32_be_arm64_4way(u32 crc, const u8 *p, size_t len);

It's worth cleaning this up to use the usual convention, but we
shouldn't claim that this is a "fix".

- Eric
