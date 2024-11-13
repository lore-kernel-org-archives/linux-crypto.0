Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B20018FDA7
	for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2024 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731506195; cv=none; b=piFP5eh/Ov1xGcn9MK58Phu7E6HC0YrALcAJCBZBOmkGTNc1sM8nPb9dOgwH+vNqftwOIeHa9F1xA0vATzL38uWNQY6wclSm9k+JmQ+kAa2BB5/S+rXum+5aRGZ1ekRa5yp8GCWu/IuitiPfOPvw9y3ancaQObXXPUD5gI2H6y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731506195; c=relaxed/simple;
	bh=gsUS5NkYc+BSuN+B87UnPKIrPHzMI5FqQyudN3+W+4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XpmCHTzVBdH4iEOn56geBJSfJz6DA66wH3f+3mVpzT5U51tyASWg5WSHRRTI92ZHDeu1Cp45/FXAY+xHH2pucL6zuPv5EPZaGUvOi2W+ED57PqqK8R1OYjx0xj6evmmnkhXEXrrx1VepjglkgszP8tFRDvS6mxHjtNRrxgUTt/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C5IVoU1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C5IVoU1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C0BC4CEC3;
	Wed, 13 Nov 2024 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731506194;
	bh=gsUS5NkYc+BSuN+B87UnPKIrPHzMI5FqQyudN3+W+4s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C5IVoU1pGhtU2vmp91T6VWlU4stkV0YbBXR90D0DCX9lStjm6BZRycxlkUrkvu2Ut
	 nSb/xhJ7Y+1kAyW+0PEEGLvgZ6fQQuYz7F2F7ggdLtO9X+fz0nY6gk0MWQ1enrG51d
	 +f3jsI+D7+gznMbQdKRa/I8T1DrEHdZierzi9L7S2hYoTK2fQn48fw8lEl76GC46MB
	 89zKKUpx7RYBoMU2tugTqzdvn0zOAiEQv1yrBSv+rfwO4qdVfXIu1BmHZtRbsaUasi
	 Z/Hl2nO0EorddK5pwCRXlPcVeWmSb+gLrPU2GN6CGr/gZs94UjJeqMKSetvgfzzeXC
	 3O89wj+TIlxvQ==
Date: Wed, 13 Nov 2024 08:56:32 -0500
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	herbert@gondor.apana.org.au, keescook@chromium.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2 0/6] Clean up and improve ARM/arm64 CRC-T10DIF code
Message-ID: <20241113135632.GB794@quark.localdomain>
References: <20241105160859.1459261-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241105160859.1459261-8-ardb+git@google.com>

On Tue, Nov 05, 2024 at 05:09:00PM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> I realized that the generic sequence implementing 64x64 polynomial
> multiply using 8x8 PMULL instructions, which is used in the CRC-T10DIF
> code to implement a fallback version for cores that lack the 64x64 PMULL
> instruction, is not very efficient.
> 
> The folding coefficients that are used when processing the bulk of the
> data are only 16 bits wide, and so 3/4 of the partial results of all those
> 8x8->16 bit multiplications do not contribute anything to the end result.
> 
> This means we can use a much faster implementation, producing a speedup
> of 3.3x on Cortex-A72 without Crypto Extensions (Raspberry Pi 4).
> 
> The same logic can be ported to 32-bit ARM too, where it produces a
> speedup of 6.6x compared with the generic C implementation on the same
> platform.
> 
> Changes since v1:
> - fix bug introduced in refactoring
> - add asm comments to explain the fallback algorithm
> - type 'u8 *out' parameter as 'u8 out[16]'
> - avoid asm code for 16 byte inputs (a higher threshold might be more
>   appropriate but 16 is nonsensical given that the folding routine
>   returns a 16 byte output)
> 
> Ard Biesheuvel (6):
>   crypto: arm64/crct10dif - Remove obsolete chunking logic
>   crypto: arm64/crct10dif - Use faster 16x64 bit polynomial multiply
>   crypto: arm64/crct10dif - Remove remaining 64x64 PMULL fallback code
>   crypto: arm/crct10dif - Use existing mov_l macro instead of __adrl
>   crypto: arm/crct10dif - Macroify PMULL asm code
>   crypto: arm/crct10dif - Implement plain NEON variant
> 
>  arch/arm/crypto/crct10dif-ce-core.S   | 249 ++++++++++-----
>  arch/arm/crypto/crct10dif-ce-glue.c   |  55 +++-
>  arch/arm64/crypto/crct10dif-ce-core.S | 335 +++++++++-----------
>  arch/arm64/crypto/crct10dif-ce-glue.c |  48 ++-
>  4 files changed, 376 insertions(+), 311 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
