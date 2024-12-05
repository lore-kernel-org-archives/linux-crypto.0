Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BA12F29;
	Thu,  5 Dec 2024 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733415804; cv=none; b=mQg7gZW6aKL3OKiaocXmvdWHyTKYLOgylkULYWI1AqUe8GguuTo73hF+Qrw3xQu3pZ5PrTk3ibfpIoe2+xoeasbgZmHGN6KTZgpDDin+nnv/xM9v+FhFxixpEahBJdBf8PJcVa6siiSSRdycFaMwmsNj6I/jDDiojDpL94A1gMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733415804; c=relaxed/simple;
	bh=c0+yBONoIqUcd1CMVy7zpCy2ByCUVvJhbZ25BcKGAu8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XMKvj3FEuQ7rgQZipzJgT8n/EwYxGT1JS4IGfgvCyoBqWaVMmjcBjtySwsPBpJDxW089ckbk4Eu2cNMII4kL3qHn/6imfLayFxBDWkEe7It23MRFv4XFBW1fBhjbHeTVfGWKuTmbHHNdtUxqtj/gs1M57qOUaAbAoemIBB0iCgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F7ZlClNy; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F7ZlClNy"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2155e9dcbe7so10346815ad.3;
        Thu, 05 Dec 2024 08:23:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733415802; x=1734020602; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PAqfpGa9rVOqgLB6DL6o2jdrTjQxsGiNSTytBROs0Ek=;
        b=F7ZlClNywZuKRVARMjIZtn5md0uKdveLla1rXdFdUQVlnQt+HwFJfjq6qFxUeNCsFV
         Zz9y7puWDQ7Hy+L9Zcj7QOkQeTXK7TH/jeQBQlkSuL6b9JguTy5Ak5Gy8pFXDpN9BAn0
         BCJeJT2/wmYlgeaeQxMbMucipQgoDKFGmgXDFCoGKuocxLVGaXfcm0J2yYHMsFUMsJSb
         zil4CaEwxNTbSX1dxALFurcey58JIlcpzXONHKgdWzSfz4G5eh84rshgK6NV4OdoKjFT
         g3913LYzrKnvTj3dGnpyRJSpNT42gW0LQIYSi2ysslcAKAWSiyXjGY1mrj+2t0jrzIfn
         2Gqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733415802; x=1734020602;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PAqfpGa9rVOqgLB6DL6o2jdrTjQxsGiNSTytBROs0Ek=;
        b=bYJHcN4Dh0e3GwjGQyvSlCNYwycxyDJYm/h5rKYM4HRB9j9yp/EE/QW4OWlCg3eKys
         02mz6Q5TnMOHaJ9OZULt/6ShDVG7YP1qr0cPOvd7vt5wEwC/QSMTryHvN1F4ip1rRjgw
         ETblQYupR0HjTBJzCZlKsT8czg+GzZhRsbmfoRoqKLYWKcNDJDd0SkvjglSy9JR6wbod
         w+0G9UuYVvJ4oL8sYHKcxsaOLssxYIV7wnzIA/eM+k4edACHIcaj2uzdgwMJfcKvHvPo
         Xz+LD5Utk557n097H8It4WsRXFUliTnmgeX5hE3DjDAkEOh3Pp9EbFBOFACNXhk3fv6G
         wgmA==
X-Forwarded-Encrypted: i=1; AJvYcCWsfdmk0UtPPH6CxrHUxzEtXr+eYDgp0rAL12kAPr4BE55oKaF3UodbF03gRyYws9KP0JAXcGVs9squHeM=@vger.kernel.org
X-Gm-Message-State: AOJu0YziypD8gEqjA/k5698KDOFKsfETpeA9AZK7JGIlNDw7xrFEIVjO
	khu7XAwHkAfdfvqZfHw2mTs3DA/kiaFCy8TGxEw+o2YSNVlkzK7R
X-Gm-Gg: ASbGnctd0CljZBzF0kLN6EJph6iZPGtCMVZhKf/GOvgRw1mo1O2GyEm0Ij6FUIllCme
	vjryexepsW4amEdT39jsNe9O/0zRYMSU6gM/lTBfB63HSZul4+ifJtItPUzMGd7x9f26f20ZHMh
	HEP0JlNBpMGtZ4Bu3od3O4QLiBgkZLfUk9bVOgtmZX+M1usmJqXHZVbUvulgdG980r00XCb+TUz
	unwxWkn29OLxfzSGKjuHxx3Pa+wxl7HE56CTjuLR/5WhTwDNA==
X-Google-Smtp-Source: AGHT+IEroO5R0U2TcdcxwUI+rtXUxD/qbjXmc8dcTia4MvdthH0zGd87/f4NmgvSjATGAbNFefomeA==
X-Received: by 2002:a17:902:cf06:b0:215:352c:af5d with SMTP id d9443c01a7336-215bd11013emr135284125ad.25.1733415801562;
        Thu, 05 Dec 2024 08:23:21 -0800 (PST)
Received: from localhost ([216.228.125.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-215f8ef9fcdsm14396135ad.146.2024.12.05.08.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2024 08:23:21 -0800 (PST)
Date: Thu, 5 Dec 2024 08:23:18 -0800
From: Yury Norov <yury.norov@gmail.com>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, briannorris@chromium.org, kees@kernel.org,
	nathan@kernel.org, steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com, linux-crypto@vger.kernel.org,
	linux@weissschuh.net, gjoyce@ibm.com
Subject: Re: [PATCHv2] cpumask: work around false-postive stringop-overread
 errors
Message-ID: <Z1HTdtvNjm-nZSvJ@yury-ThinkPad>
References: <20241205123413.309388-1-nilay@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241205123413.309388-1-nilay@linux.ibm.com>

On Thu, Dec 05, 2024 at 06:04:09PM +0530, Nilay Shroff wrote:
> While building the powerpc code using gcc 13, I came across following
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
> Apparently, above errors only manifests with GCC 13.x and config option
> CONFIG_FORTIFY_SOURCE. Furthermore, if I use gcc 11.x or gcc 12.x then I
> don't encounter above errors. Prima facie, these errors appear to be false-

If it works for pre-GCC13, and likely for clang, you shouldn't disable it
for them. It should be enabled for CONFIG_FORTIFY_SOURCE=n, as well.

Check config CC_NO_ARRAY_BOUNDS for an example of how versioned flags
are implemented.

> positive. Brian informed me that currently some efforts are underway by
> GCC developers to emit more verbose information when GCC detects string
> overflow errors and that might help to further narrow down the root cause
> of this error.

I'm 100% sure that Brian is a great person and his information is
absolutely correct and complete. But this is just not how we write
commit messages.

Please avoid personal references, vague statements and news from
the future.

> So for now, silence these errors using -Wno-stringop-
> overread gcc option while building kernel/padata.c file until we find the
> root cause.

You didn't provide any evidence that this warning is specific for padata.

And indeed the subject states that this is a cpumasks-related warninig.
Cpumask is a global subsystem. If you believe that this warning is
false-positive, it may show up for any other random victim. Please
suppress it globally.

Thanks,
Yury

> 
> Link: https://lore.kernel.org/all/7cbbd751-8332-4ab2-afa7-8c353834772a@linux.ibm.com/
> Cc: briannorris@chromium.org
> Cc: kees@kernel.org
> Cc: nathan@kernel.org
> Cc: yury.norov@gmail.com
> Cc: steffen.klassert@secunet.com
> Cc: daniel.m.jordan@oracle.com
> Cc: linux-crypto@vger.kernel.org
> Cc: linux@weissschuh.net
> Cc: gjoyce@ibm.com
> Reviewed-by: Brian Norris <briannorris@chromium.org>
> Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
> ---
> Changes from v1:
>     - Fix spell error in the commit message (Brian Norris)
>     - Add commentary around change to note that changes are needed to
>       avoid false positive on gcc 13+ (Brian Norris)
>     - Add the kerenl/padata.c file maintainers (Brian Norris)     
> ---
> 
>  kernel/Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 87866b037fbe..03242d8870c7 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -120,6 +120,10 @@ obj-$(CONFIG_CFI_CLANG) += cfi.o
>  obj-$(CONFIG_PERF_EVENTS) += events/
>  
>  obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
> +
> +# Silence the false positive stringop-overread errors on GCC 13+
> +CFLAGS_padata.o += $(call cc-disable-warning, stringop-overread)
> +
>  obj-$(CONFIG_PADATA) += padata.o
>  obj-$(CONFIG_JUMP_LABEL) += jump_label.o
>  obj-$(CONFIG_CONTEXT_TRACKING) += context_tracking.o
> -- 
> 2.45.2
