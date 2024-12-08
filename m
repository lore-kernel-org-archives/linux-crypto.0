Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE63A1EA65;
	Sun,  8 Dec 2024 18:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733682326; cv=none; b=EQXFmdwQ0pl8sYL3rLb99ySacAtx2q2YxxWsfIdnOvA9aJc+FE0D0PiuGJThO8gaHBQaf/imKUZSl8yEg2p0KKd/i/9prX5nqmfl3y20VioOYQsKt5T53niUqInhCWYAIl0amYty0H327puo8270AsP+CiE70TN/PxUeYeaHplE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733682326; c=relaxed/simple;
	bh=yyMfYDwMEer0TobvoSrhVLqHT7sIQ0UKYhE1itj8hJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V0Ov2Na//rXsBtm6i2ES1MM3MFWJz2DYdSxboMzEpcF1MPWOgyruPYwP0ihzZXUwcKCzW3ht1Y4OZ1eIIeXwcwUjOT6Hi6ulRyxswp6HEeUjIuBzI9fYZmQQekRzN0PMx6wTzoLKN1xcdNeUb/q3AJePTMivNWBkk0X5zXGSzXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e11jCdiQ; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e11jCdiQ"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6ef6ffcc2dcso31099477b3.1;
        Sun, 08 Dec 2024 10:25:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733682324; x=1734287124; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8Wr6ZX0JtjZ4MHsD5mtIaFcyeOeKxP3DFEk4cEbgpvk=;
        b=e11jCdiQLFoGUaKlHsXPKNnyKl3Bvno0NS89PIUiNac0HQxyPn+wRwstvD3u68i2KP
         f4ABW7Yi6yr3uwyjFMeC867M9lMzTJJNd3SFsww5bZFxOUTZjaV8uUEpVnymlvLhoP32
         fWp08yO1/BBh3AduJYf9tJAOJhfkXmbKQkF/rRp5oY0PvBdmahLalt9x5o9MSTSLZIA1
         tM62mnHCIX6cX9qaXekVHbWvgUY5tu1+fUeIIk3oE+VUY1fbnHvlxuPSRXAe8iwT3Bha
         WTLVZjr68vvWUNwnlkzzdxzZ7+n7mWYZpu9JVqqgGq04YTjk+NtsAIlq2y8yGXlAd3LY
         sW8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733682324; x=1734287124;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Wr6ZX0JtjZ4MHsD5mtIaFcyeOeKxP3DFEk4cEbgpvk=;
        b=IQ6qi8VLmpH0VH8gMOU+NGHQnpzZvi2P5KWfA6hwnnjdf9Vlp/UB5vN6/5dqDkjgBU
         /OcVJN566PAEjPLOPJ8cgS/6z42rs/+LxvDZBPTQEevhJvnfPn1xmFW8eOKETohpDd95
         ZtaQTaZPerYQPHT4tgeim3iWl1cfgskfpOkzneCFw0VpYvdXm1i3OBLYs9DDHBN1FjRT
         HUdWBnvd+YsZOiv01wn5rThLHjYteYYE2nslltThTvu2Ik24FJnXhqWzzVs6JyZRsC91
         nD/xOgDVoXpRXT6TLDrfbN/lh6ln/zLBUHnZVmlf87zrY8ucFqEhIaWFLGR5djaiDcIU
         ptEw==
X-Forwarded-Encrypted: i=1; AJvYcCXi3P7vL7r91VI75ZQEULPoQU23BnM2nGC3iAZSuYmahsI2KniMUKyTA5rNAnQQLJDiRU+uTo3S+TVShBM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3oD5mF+4kYQYej+e43/FGcoMfZFkoPrnSmDHBhnr4dITktXc7
	nGl5vnRn9C4me3lm/VAJIMSx/LkTY4hRGAoKBh7/i5wNYcZahiq8
X-Gm-Gg: ASbGncs9qIMlgYbFJT4ooDPX4SCuCR+QfUcFwZcB+e+yOlZwgQAgeXaWmBTeMhEWuvb
	AWaWVuabTnwamzxN/vM6iAIUstuAQRiwIbJETQhkHDOzYAfOxop3fOZuxx9b7ZMDr2xZufWzxNt
	RNBThmejS8b7dJcqB+FGBtl0WbVy6NPDzvzUVJDCyjd9p0UieGSP59l+akmMVXXZw7FPQ9tQOJw
	ReXGVZzMxzYtdjqHY5O5+91xW1ra9D77N9xZeav761v4bmqczI4HtnfIO1NPU64IYYdwLGGQr1M
	yx+YfB2Jiw==
X-Google-Smtp-Source: AGHT+IHXvGQnU6CGNmh99UAP9QpYFFy3ThCC519auJ81/3fE4GwhNVowrQ3hLS/eiy/AxlJ8sW9DjQ==
X-Received: by 2002:a05:690c:6307:b0:6ee:8515:6730 with SMTP id 00721157ae682-6efe3961aa4mr83421307b3.17.1733682323655;
        Sun, 08 Dec 2024 10:25:23 -0800 (PST)
Received: from localhost (c-24-129-28-254.hsd1.fl.comcast.net. [24.129.28.254])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6f010962e5csm1785667b3.92.2024.12.08.10.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Dec 2024 10:25:22 -0800 (PST)
Date: Sun, 8 Dec 2024 10:25:21 -0800
From: Yury Norov <yury.norov@gmail.com>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	briannorris@chromium.org, kees@kernel.org, gustavoars@kernel.org,
	nathan@kernel.org, steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com, gjoyce@ibm.com,
	linux-crypto@vger.kernel.org, linux@weissschuh.net
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
Message-ID: <Z1XkhhBqFYtbvQYp@yury-ThinkPad>
References: <20241208161315.730138-1-nilay@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241208161315.730138-1-nilay@linux.ibm.com>

On Sun, Dec 08, 2024 at 09:42:28PM +0530, Nilay Shroff wrote:
> While building the powerpc code using gcc 13.x, I came across following
> errors generated for kernel/padata.c file:
> 
>   CC      kernel/padata.o
> In file included from ./include/linux/string.h:390,
>                  from ./arch/powerpc/include/asm/paca.h:16,
>                  from ./arch/powerpc/include/asm/current.h:13,
>                  from ./include/linux/thread_info.h:23,
>                  from ./include/asm-generic/preempt.h:5,
>                  from ./arch/powerpc/include/generated/asm/preempt.h:1,
>                  from ./include/linux/preempt.h:79,
>                  from ./include/linux/spinlock.h:56,
>                  from ./include/linux/swait.h:7,
>                  from ./include/linux/completion.h:12,
>                  from kernel/padata.c:14:
> In function ‘bitmap_copy’,
>     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
>     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
> ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
>   114 | #define __underlying_memcpy     __builtin_memcpy
>       |                                 ^
> ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
>   633 |         __underlying_##op(p, q, __fortify_size);                        \
>       |         ^~~~~~~~~~~~~
> ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
>   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
>       |                          ^~~~~~~~~~~~~~~~~~~~
> ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
>   259 |                 memcpy(dst, src, len);
>       |                 ^~~~~~
> kernel/padata.c: In function ‘__padata_set_cpumasks’:
> kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
>   713 |                                  cpumask_var_t pcpumask,
>       |                                  ~~~~~~~~~~~~~~^~~~~~~~
> In function ‘bitmap_copy’,
>     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
>     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
> ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
>   114 | #define __underlying_memcpy     __builtin_memcpy
>       |                                 ^
> ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
>   633 |         __underlying_##op(p, q, __fortify_size);                        \
>       |         ^~~~~~~~~~~~~
> ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
>   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
>       |                          ^~~~~~~~~~~~~~~~~~~~
> ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
>   259 |                 memcpy(dst, src, len);
>       |                 ^~~~~~
> kernel/padata.c: In function ‘__padata_set_cpumasks’:
> kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
>   713 |                                  cpumask_var_t pcpumask,
>       |                                  ~~~~~~~~~~~~~~^~~~~~~~
> 
> The above error appears to be false-positive:
> >From the distro relevant config,
>     CONFIG_PPC64=y
>     CONFIG_CC_IS_GCC=y
>     CONFIG_GCC_VERSION=130301
>     CONFIG_NR_CPUS=2048
>     CONFIG_FORTIFY_SOURCE=y
> 
> >From the source code,
> unsigned long name[BITS_TO_LONGS(bits)]
> ...
> typedef struct cpumask { DECLARE_BITMAP(bits, NR_CPUS); } cpumask_t;
> typedef struct cpumask cpumask_var_t[1];
> ...
> 
> extern unsigned int nr_cpu_ids;
> ...
> static __always_inline
> void bitmap_copy(unsigned long *dst, const unsigned long *src, unsigned
> int nbits)
> {
>         unsigned int len = bitmap_size(nbits);
> 
>         if (small_const_nbits(nbits))
>                 *dst = *src;
>         else
>                 memcpy(dst, src, len);
> }
> 
> static __always_inline
> void cpumask_copy(struct cpumask *dstp, const struct cpumask *srcp)
> {
>         bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), large_cpumask_bits);
> }
> ...
> static int __padata_set_cpumasks(struct padata_instance *pinst,
>                                  cpumask_var_t pcpumask,
>                                  cpumask_var_t cbcpumask)
> {
> ...
>         cpumask_copy(pinst->cpumask.pcpu, pcpumask);
>         cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
> ...
> }
> 
> So the above statements expands to:
> memcpy(pinst->cpumask.pcpu->bits, pcpumask->bits, nr_cpu_ids)
> memcpy(pinst->cpumask.cbcpu->bits, cbcpumask->bits, nr_cpu_ids)
> 
> Now the compiler complains about "error: ‘__builtin_memcpy’ reading
> between 257 and 536870904 bytes from a region of size 256". So the
> value of nr_cpu_ids which gcc calculated is between 257 and 536870904.
> This looks strange and incorrect.

Thanks for the detour into internals. I did the same by myself, and
spent quite a lot of my time trying to understand why GCC believes
that here we're trying to access memory beyond idx == 256 and up to
a pretty random 536870904.

256 is most likely NR_CPUS/8, and that makes sense. But I have no ideas
what does this 536870904 mean. OK, it's ((u32)-64)>>3, but to me it's a
random number. I'm quite sure cpumasks machinery can't be involved in
generating it.

Well, we maybe have to spend more time on this, at least try to
understand how exactly CONFIG_FORTIFY_SOURCE is involved. But to me
it's OK to silence the warning this way. Moreover, you're pointing to
undergoing discussions.

> Later similar errors[1] were also observed on x86-64 platform using 
> gcc-14. Apparently, above errors menifests using gcc-13+ and config 
> option CONFIG_FORTIFY_SOURCE=y. Moreover, I don't encounter above 
> error when,
> - using gcc 11.x or gcc 12.x or LLVM/Clang compiler
> or
> - disabling CONFIG_FORTIFY_SOURCE option
> 
> So for now, silence above errors globally while using gcc-13+ and
> CONFIG_FORTIFY_SOURCE=y. We may later revert this change when we
> find root cause of the error. Per this  discussion[2], GCC developers
> are working to add extra diagnostics and context when this error
> menifests and that might help to find the root cause.
> 
> [1] https://lore.kernel.org/all/2024120757-lustrous-equinox-77f0@gregkh/
> [2] https://gcc.gnu.org/pipermail/gcc-patches/2024-October/666870.html
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Greg acked v2, which differs from v3 quite a lot. I would check with
him if he's still OK.

> Cc: briannorris@chromium.org
> Cc: yury.norov@gmail.com
> Cc: kees@kernel.org
> Cc: gustavoars@kernel.org
> Cc: nathan@kernel.org
> Cc: steffen.klassert@secunet.com
> Cc: daniel.m.jordan@oracle.com
> Cc: gjoyce@ibm.com
> Cc: linux-crypto@vger.kernel.org
> Cc: linux@weissschuh.net
> Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
> ---
> Changes from v2:
>     - Globally disable -Werror-stringop-overread while using gcc-13+ and
>       FORTIFY_SOURCE (Yury Norov)
>     - Updated the patch subject line to make it clear that this is
> 	  possiblt gcc error and not related to cpumask.
> Changes from v1:
>     - Fix spell error in the commit message (Brian Norris)
>     - Add commentary around change to note that changes are needed to
>       avoid false positive on gcc 13+ (Brian Norris)
>     - Add the kerenl/padata.c file maintainers (Brian Norris)
> ---
>  init/Kconfig               | 8 ++++++++
>  scripts/Makefile.extrawarn | 1 +
>  2 files changed, 9 insertions(+)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index a20e6efd3f0f..ff2f54520551 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -920,6 +920,14 @@ config CC_STRINGOP_OVERFLOW
>  	bool
>  	default y if CC_IS_GCC && !CC_NO_STRINGOP_OVERFLOW
>  
> +# Currently, disable -Wstringop-overread for gcc-13+ and FORTIFY_SOURCE globally.
> +config GCC13_NO_STRINGOP_OVERREAD
> +	def_bool y

This is an issue for GCC14 as well, as Greg mentioned, and you say the
same in the commit message. I'd name this config GCC_NO_STRINGOP_OVERREAD.

But I don't think we need this extra knob at all. Those who want to
disable CC_NO_STRINGOP_OVERREAD can disable it explicitly.

Anyways, it's minor. For cpumasks:

Acked-by: Yury Norov <yury.norov@gmail.com>

> +
> +config CC_NO_STRINGOP_OVERREAD
> +	bool
> +	default y if CC_IS_GCC && GCC_VERSION >= 130000 && GCC13_NO_STRINGOP_OVERREAD && FORTIFY_SOURCE
> +
>  #
>  # For architectures that know their GCC __int128 support is sound
>  #
> diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> index 1d13cecc7cc7..1abd41269fd0 100644
> --- a/scripts/Makefile.extrawarn
> +++ b/scripts/Makefile.extrawarn
> @@ -27,6 +27,7 @@ endif
>  KBUILD_CPPFLAGS-$(CONFIG_WERROR) += -Werror
>  KBUILD_CPPFLAGS += $(KBUILD_CPPFLAGS-y)
>  KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds
> +KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERREAD) += -Wno-stringop-overread
>  
>  ifdef CONFIG_CC_IS_CLANG
>  # The kernel builds with '-std=gnu11' so use of GNU extensions is acceptable.
> -- 
> 2.45.2
