Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB1627C84B;
	Sat, 22 Nov 2025 20:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763841847; cv=none; b=dY2643auJqB5cyok25NFj9j+KAMZEtL8NKGOhMQOUH69pnoV+VEU/wrm6b0WlC3NPjr2zqDD4j1jvrWfK22HRN13VaFB82JjUBR8zpqJ/tGaP8RpLqH/Gz2dMCLzuvHKTLxlxkINxqqB7EqaP6pVIazFrgGZhOElsyYRQX2U29A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763841847; c=relaxed/simple;
	bh=QFyhjQf1/UtnGNQLYjfiqhZLLKYiFxKp7r+cJOl5kgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fVp7WVcqOpp67KkdLlk62HP40zXIj5Dq2ugATLEaN3oGCZBdLrqhNOgfrvBRa7b/xkTmHy9Bei2qRbHtJcYD/fjuSMQvC/OUadVcPQqO0YUXzbpwf2jtFz2tjnxgQ/A4OKAtj/utF/JdS2FaDbggAlgNtOy5b+hZx35LI8ocXLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T0vc76Yd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T0vc76Yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964A1C4CEF5;
	Sat, 22 Nov 2025 20:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763841844;
	bh=QFyhjQf1/UtnGNQLYjfiqhZLLKYiFxKp7r+cJOl5kgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T0vc76YdXc5FHwXZw3mavFyjX+g9LtP5LASkd8GKb4P4wp9J/u5+BQg2LWwRu4/i6
	 /wQ1Sd1obxexpXEJg+80u1/LMu16WERGpczsqSXf7ApNYAuLr8De1FvuzCsBPVrO3n
	 hM9lv+viYJODe5aUQQ5X3SrBL7YRG21DnFxYKI2LVlp0/SAC+BjURjluMm/azgDktP
	 6pn4nywuomBVhq3+thQG7MAaJbdxCK+J8wlRXVSKpKR9w9Gv116AQYCfGrbv9KuUGJ
	 2jnaMS3eeUlXd5Dz7+BZ4B65O33PHCRRHLF4QaZSeLtiA1M+5FY4fHBF5TmoazRxFD
	 PEbruf25USaaw==
Date: Sat, 22 Nov 2025 12:04:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: blake2b: Limit frame size workaround to GCC
 < 12.2 on i386
Message-ID: <20251122200402.GD5803@quark>
References: <20251122105530.441350-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122105530.441350-2-thorsten.blum@linux.dev>

On Sat, Nov 22, 2025 at 11:55:31AM +0100, Thorsten Blum wrote:
> The GCC bug only occurred on i386 and has been resolved since GCC 12.2.
> Limit the frame size workaround to GCC < 12.2 on i386.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  lib/crypto/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
> index b5346cebbb55..5ee36a231484 100644
> --- a/lib/crypto/Makefile
> +++ b/lib/crypto/Makefile
> @@ -33,7 +33,11 @@ obj-$(CONFIG_CRYPTO_LIB_GF128MUL)		+= gf128mul.o
>  
>  obj-$(CONFIG_CRYPTO_LIB_BLAKE2B) += libblake2b.o
>  libblake2b-y := blake2b.o
> +ifeq ($(CONFIG_X86_32),y)
> +ifeq ($(CONFIG_CC_IS_GCC)_$(call gcc-min-version, 120200),y_)
>  CFLAGS_blake2b.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
> +endif # CONFIG_CC_IS_GCC
> +endif # CONFIG_X86_32

How about we do it without the nested ifeq?

ifeq ($(CONFIG_X86_32)$(CONFIG_CC_IS_GCC)_$(call gcc-min-version, 120200),yy_)
CFLAGS_blake2b.o := -Wframe-larger-than=4096 #  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105930
endif

Also, according to the bugreport this was a regression in gcc 12.  With
it having been fixed in 12.2, i.e. within the same gcc release series,
is this workaround still worth carrying at all?

- Eric
