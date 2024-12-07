Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F82140E30;
	Sat,  7 Dec 2024 11:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733571887; cv=none; b=etQLru+LEwbEA8uROfPoHZx+7jnrgNQm8QsrPUKkMzqYbh5EoC1DRJx+0Vsb8Nm2BtHKJTxmMweGX1XIwIkgPcNy9fMOfOKLLFHLe8NCAXT05CWIkTSFSUNL7vzlMoyoipl8547chIjkEqyF4GisxVjOEvdEgx3941cgV3J1pRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733571887; c=relaxed/simple;
	bh=pzD+GEhU2+NKjNhpQTajOEjiaseCjjcyjSgJTaWgVDo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FiAV6H7FULmRW2/eqIeNquQeLMn5IOnGWii1eHx7ynXvNdnZvaCcySWTEhMhXvJvG47PQBaKxcSL66IMXg91lEpvV3yxu+wjVd38Jg3EgiNer/fnlh6v/qp653CoyfVVafcR3+4JKHTpZhdL9zId1/D/s4405tk95jvxrll0Nq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EN6HytxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EN6HytxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98DFC4CECD;
	Sat,  7 Dec 2024 11:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733571886;
	bh=pzD+GEhU2+NKjNhpQTajOEjiaseCjjcyjSgJTaWgVDo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EN6HytxB0EzyLdYK23OItkSn6/KjG+eLry+YakVtLSYXnMxqdVyn1xCncctYbujR0
	 ZncaVPqEzEMDonk3EQ6rNoHRSADO2bnEIu8/Pnt4mx+h0dyR+eCdik4kqhs4/mMkEN
	 frSxC6Jq4EEHyAC0X0bNDQ11ZNq7/lQ+2hNdCW0A=
Date: Sat, 7 Dec 2024 12:44:42 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, briannorris@chromium.org, kees@kernel.org,
	nathan@kernel.org, yury.norov@gmail.com,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org, linux@weissschuh.net, gjoyce@ibm.com
Subject: Re: [PATCHv2] cpumask: work around false-postive stringop-overread
 errors
Message-ID: <2024120710-cahoots-obituary-d32d@gregkh>
References: <20241205123413.309388-1-nilay@linux.ibm.com>
 <2024120757-lustrous-equinox-77f0@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2024120757-lustrous-equinox-77f0@gregkh>

On Sat, Dec 07, 2024 at 12:43:19PM +0100, Greg KH wrote:
> On Thu, Dec 05, 2024 at 06:04:09PM +0530, Nilay Shroff wrote:
> > While building the powerpc code using gcc 13, I came across following
> > errors generated for kernel/padata.c file:
> > 
> >   CC      kernel/padata.o
> > In file included from ./include/linux/string.h:390,
> >                  from ./arch/powerpc/include/asm/paca.h:16,
> >                  from ./arch/powerpc/include/asm/current.h:13,
> >                  from ./include/linux/thread_info.h:23,
> >                  from ./include/asm-generic/preempt.h:5,
> >                  from ./arch/powerpc/include/generated/asm/preempt.h:1,
> >                  from ./include/linux/preempt.h:79,
> >                  from ./include/linux/spinlock.h:56,
> >                  from ./include/linux/swait.h:7,
> >                  from ./include/linux/completion.h:12,
> >                  from kernel/padata.c:14:
> > In function ‘bitmap_copy’,
> >     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
> >     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
> > ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
> >   114 | #define __underlying_memcpy     __builtin_memcpy
> >       |                                 ^
> > ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
> >   633 |         __underlying_##op(p, q, __fortify_size);                        \
> >       |         ^~~~~~~~~~~~~
> > ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
> >   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
> >       |                          ^~~~~~~~~~~~~~~~~~~~
> > ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
> >   259 |                 memcpy(dst, src, len);
> >       |                 ^~~~~~
> > kernel/padata.c: In function ‘__padata_set_cpumasks’:
> > kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
> >   713 |                                  cpumask_var_t pcpumask,
> >       |                                  ~~~~~~~~~~~~~~^~~~~~~~
> > In function ‘bitmap_copy’,
> >     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
> >     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
> > ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
> >   114 | #define __underlying_memcpy     __builtin_memcpy
> >       |                                 ^
> > ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
> >   633 |         __underlying_##op(p, q, __fortify_size);                        \
> >       |         ^~~~~~~~~~~~~
> > ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
> >   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
> >       |                          ^~~~~~~~~~~~~~~~~~~~
> > ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
> >   259 |                 memcpy(dst, src, len);
> >       |                 ^~~~~~
> > kernel/padata.c: In function ‘__padata_set_cpumasks’:
> > kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
> >   713 |                                  cpumask_var_t pcpumask,
> >       |                                  ~~~~~~~~~~~~~~^~~~~~~~
> > 
> > Apparently, above errors only manifests with GCC 13.x and config option
> > CONFIG_FORTIFY_SOURCE. Furthermore, if I use gcc 11.x or gcc 12.x then I
> > don't encounter above errors. Prima facie, these errors appear to be false-
> > positive. Brian informed me that currently some efforts are underway by
> > GCC developers to emit more verbose information when GCC detects string
> > overflow errors and that might help to further narrow down the root cause
> > of this error. So for now, silence these errors using -Wno-stringop-
> > overread gcc option while building kernel/padata.c file until we find the
> > root cause.
> 
> I'm hitting this now on Linus's tree using gcc14 on x86-64 so this isn't
> just a problem with your arch.
> 
> Let me try this patch locally and see if it helps...

Yes, fixes the build for me, so either this is a real fix, or something
else needs to be done for it, so I'll give a:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

for now.

thanks,

greg k-h
