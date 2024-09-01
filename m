Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6110156F33;
	Sun,  1 Sep 2024 13:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725197392; cv=none; b=Qy4sk1cuDQxns1iy2uTPcBTSujj0xXiFPW4RqA2MqYcL/Ti8Dv4bnP658TbyO43v85SnFYdlGoz+VuKWHrwEHINmWX+xQTfs1cw8SvyTGtxFnPMuvJnLunFSQ4zN197wkjIuQScY6l942N9W6sTRpmo8mWseG4M6Bpk3kzFiJ2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725197392; c=relaxed/simple;
	bh=fJV93TymRw1kv+yTPr1VEK4S6q4cyG+oEiTlEz8IwOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AaDRAppmItCDSY7qcewU7N4pxmzPul26ow9P7tm3mXf3xF7/vbJ8MUnBdlAqdzIr0TkUBsLmdBiU+0WCI6UWNnSCN0ftgN9ty2Js2dmmjEIMUzhUvxrv9p8Q8LbK/JIfVPlo6vn52g0rGaiShtFD9SOcZKFiaYQGF0cHCZFcuAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b=laTWUtBp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="laTWUtBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80392C4CEC3;
	Sun,  1 Sep 2024 13:29:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="laTWUtBp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1725197390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vwEBp5hrk7rdQEMy5bh5wOYihg5L/fxmxEtvhyFPK8M=;
	b=laTWUtBpgv/FCgSApr3ftEBjxJS2Zc+Hnj/j0n7p3WqEIoDLwPJwO3AO+e6hFon+7wFglZ
	bIsoo8FGMp/qBb2qhVG6NiVMY8O5TIMkKSgV0WGiDkz5qY7vuYyDaNgYIYDLUH7csUURVm
	mfgeNism5xWFi7Urk+hoyiIUaaVMR84=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 577f71e4 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
	Sun, 1 Sep 2024 13:29:49 +0000 (UTC)
Date: Sun, 1 Sep 2024 15:29:46 +0200
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Xi Ruoyao <xry111@xry111.site>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
	linux-crypto@vger.kernel.org, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, Jinyang He <hejinyang@loongson.cn>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v6 1/3] arch: vDSO: Add a __vdso_getrandom prototype for
 all architectures
Message-ID: <ZtRsSuBrky5KkBvk@zx2c4.com>
References: <20240901061315.15693-1-xry111@xry111.site>
 <20240901061315.15693-2-xry111@xry111.site>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240901061315.15693-2-xry111@xry111.site>

On Sun, Sep 01, 2024 at 02:13:10PM +0800, Xi Ruoyao wrote:
> Without a prototype, we'll have to add a prototype for each architecture
> implementing vDSO getrandom.  As most architectures will likely have the
> vDSO getrandom implemented in a near future, and we'd like to keep the
> declarations compatible everywhere (to ease the Glibc work), we should
> really just have one copy of the prototype.
> 
> Suggested-by: Huacai Chen <chenhuacai@kernel.org>
> Signed-off-by: Xi Ruoyao <xry111@xry111.site>
> ---
>  arch/x86/entry/vdso/vgetrandom.c | 2 --
>  include/vdso/getrandom.h         | 5 +++++
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/entry/vdso/vgetrandom.c b/arch/x86/entry/vdso/vgetrandom.c
> index 52d3c7faae2e..430862b8977c 100644
> --- a/arch/x86/entry/vdso/vgetrandom.c
> +++ b/arch/x86/entry/vdso/vgetrandom.c
> @@ -6,8 +6,6 @@
>  
>  #include "../../../../lib/vdso/getrandom.c"
>  
> -ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len);
> -
>  ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len)
>  {
>  	return __cvdso_getrandom(buffer, len, flags, opaque_state, opaque_len);
> diff --git a/include/vdso/getrandom.h b/include/vdso/getrandom.h
> index 4cf02e678f5e..08b47b002bf7 100644
> --- a/include/vdso/getrandom.h
> +++ b/include/vdso/getrandom.h
> @@ -56,4 +56,9 @@ struct vgetrandom_state {
>   */
>  extern void __arch_chacha20_blocks_nostack(u8 *dst_bytes, const u32 *key, u32 *counter, size_t nblocks);
>  
> +/**
> + * __vdso_getrandom: Prototype of vDSO getrandom.
> + */
> +extern ssize_t __vdso_getrandom(void *buffer, size_t len, unsigned int flags, void *opaque_state, size_t opaque_len);
> +

My inclination was that this isn't correct because arm64 uses __kernel_*
symbols instead, but it seems like arm handles that on their own, and
include/vdso/gettime.h follows this same format. So I'll queue this up,
possibly fixing up the comment.
