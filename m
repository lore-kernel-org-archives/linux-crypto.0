Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91F114A615;
	Sun,  8 Dec 2024 13:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733664554; cv=none; b=Zj254ylMKAwm/MO8DDS32j4P3jgxEX7iQcdSIjA3VvFNYMF+0NriDYsSUhntgqRapWBlHsNKPha6QsZugu7u4ALj9/U1Io6nacokPA6e3I9F696RwCjTwcAbkxirwXcmnFzYGEmhym16EKibilIXMfpwNRm9bB0GBLR7AY0jCbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733664554; c=relaxed/simple;
	bh=qano/O+jDANLz/zTE4RjPg4yBC9eyg00FrNQyzw2zrU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MRPWeGAaSorJ+ygt3x4a36s9DqHI5D0n/HIaltGZN9joqEUzAxA5JmBWfhk2BxUSHlpDD7tmbgQGetAEE2TZ/7cJ64rMGRENG6cElVV+lb6ctPUUGOVuj/xPnYNoZiTiJpDLlSQsA2XX6hYApvzHGr5aQnKmIzqMlcsJzlt7FJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=14Q7qWMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="14Q7qWMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34B9C4CED2;
	Sun,  8 Dec 2024 13:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733664554;
	bh=qano/O+jDANLz/zTE4RjPg4yBC9eyg00FrNQyzw2zrU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=14Q7qWMzuS8N49xOJAtuAMfDvI+mNrrxLpzB4QWZ5ulbNvltCMQPxVrGd9AKDtiVy
	 TqmWtfLwQOkf3ehQmJjad3xmgCoCA/XWKImfhWhhrlhqiAFcCCuG5HZCFJpi16id2v
	 fePddpRvIF0PFixEv+2mnlP69P/jTCnwZ9chbujc=
Date: Sun, 8 Dec 2024 14:28:38 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Nilay Shroff <nilay@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, briannorris@chromium.org, kees@kernel.org,
	nathan@kernel.org, yury.norov@gmail.com,
	steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
	linux-crypto@vger.kernel.org, linux@weissschuh.net, gjoyce@ibm.com
Subject: Re: [PATCHv2] cpumask: work around false-postive stringop-overread
 errors
Message-ID: <2024120822-unnerving-childless-bf01@gregkh>
References: <20241205123413.309388-1-nilay@linux.ibm.com>
 <2024120757-lustrous-equinox-77f0@gregkh>
 <2024120710-cahoots-obituary-d32d@gregkh>
 <d81e9a7a-2209-4fb2-93fe-1fd2afece176@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d81e9a7a-2209-4fb2-93fe-1fd2afece176@linux.ibm.com>

On Sun, Dec 08, 2024 at 03:51:10PM +0530, Nilay Shroff wrote:
> 
> 
> On 12/7/24 17:14, Greg KH wrote:
> > On Sat, Dec 07, 2024 at 12:43:19PM +0100, Greg KH wrote:
> >> On Thu, Dec 05, 2024 at 06:04:09PM +0530, Nilay Shroff wrote:
> >>> While building the powerpc code using gcc 13, I came across following
> >>> errors generated for kernel/padata.c file:
> >>>
> >>>   CC      kernel/padata.o
> >>> In file included from ./include/linux/string.h:390,
> >>>                  from ./arch/powerpc/include/asm/paca.h:16,
> >>>                  from ./arch/powerpc/include/asm/current.h:13,
> >>>                  from ./include/linux/thread_info.h:23,
> >>>                  from ./include/asm-generic/preempt.h:5,
> >>>                  from ./arch/powerpc/include/generated/asm/preempt.h:1,
> >>>                  from ./include/linux/preempt.h:79,
> >>>                  from ./include/linux/spinlock.h:56,
> >>>                  from ./include/linux/swait.h:7,
> >>>                  from ./include/linux/completion.h:12,
> >>>                  from kernel/padata.c:14:
> >>> In function ‘bitmap_copy’,
> >>>     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
> >>>     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
> >>> ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
> >>>   114 | #define __underlying_memcpy     __builtin_memcpy
> >>>       |                                 ^
> >>> ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
> >>>   633 |         __underlying_##op(p, q, __fortify_size);                        \
> >>>       |         ^~~~~~~~~~~~~
> >>> ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
> >>>   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
> >>>       |                          ^~~~~~~~~~~~~~~~~~~~
> >>> ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
> >>>   259 |                 memcpy(dst, src, len);
> >>>       |                 ^~~~~~
> >>> kernel/padata.c: In function ‘__padata_set_cpumasks’:
> >>> kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
> >>>   713 |                                  cpumask_var_t pcpumask,
> >>>       |                                  ~~~~~~~~~~~~~~^~~~~~~~
> >>> In function ‘bitmap_copy’,
> >>>     inlined from ‘cpumask_copy’ at ./include/linux/cpumask.h:839:2,
> >>>     inlined from ‘__padata_set_cpumasks’ at kernel/padata.c:730:2:
> >>> ./include/linux/fortify-string.h:114:33: error: ‘__builtin_memcpy’ reading between 257 and 536870904 bytes from a region of size 256 [-Werror=stringop-overread]
> >>>   114 | #define __underlying_memcpy     __builtin_memcpy
> >>>       |                                 ^
> >>> ./include/linux/fortify-string.h:633:9: note: in expansion of macro ‘__underlying_memcpy’
> >>>   633 |         __underlying_##op(p, q, __fortify_size);                        \
> >>>       |         ^~~~~~~~~~~~~
> >>> ./include/linux/fortify-string.h:678:26: note: in expansion of macro ‘__fortify_memcpy_chk’
> >>>   678 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
> >>>       |                          ^~~~~~~~~~~~~~~~~~~~
> >>> ./include/linux/bitmap.h:259:17: note: in expansion of macro ‘memcpy’
> >>>   259 |                 memcpy(dst, src, len);
> >>>       |                 ^~~~~~
> >>> kernel/padata.c: In function ‘__padata_set_cpumasks’:
> >>> kernel/padata.c:713:48: note: source object ‘pcpumask’ of size [0, 256]
> >>>   713 |                                  cpumask_var_t pcpumask,
> >>>       |                                  ~~~~~~~~~~~~~~^~~~~~~~
> >>>
> >>> Apparently, above errors only manifests with GCC 13.x and config option
> >>> CONFIG_FORTIFY_SOURCE. Furthermore, if I use gcc 11.x or gcc 12.x then I
> >>> don't encounter above errors. Prima facie, these errors appear to be false-
> >>> positive. Brian informed me that currently some efforts are underway by
> >>> GCC developers to emit more verbose information when GCC detects string
> >>> overflow errors and that might help to further narrow down the root cause
> >>> of this error. So for now, silence these errors using -Wno-stringop-
> >>> overread gcc option while building kernel/padata.c file until we find the
> >>> root cause.
> >>
> >> I'm hitting this now on Linus's tree using gcc14 on x86-64 so this isn't
> >> just a problem with your arch.
> Thanks Greg for confirming that this is not isolated to PowerPC!!
> >>
> >> Let me try this patch locally and see if it helps...
> > 
> > Yes, fixes the build for me, so either this is a real fix, or something
> > else needs to be done for it, so I'll give a:
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > for now.
> Okay so now we've an evidence confirming that this is no longer PowerPC specific 
> issue. Hence as Yury suggested, in another mail[1], fixing this error by disabling
> stringop-overread globally for GCC13+ and CONFIG_FORTIFY_SOURCE=n, I will spin a 
> new patch and submit it.
> 
> [1] https://lore.kernel.org/all/Z1HTdtvNjm-nZSvJ@yury-ThinkPad/

That feels wrong, unless this is a compiler bug.  And if it's a compiler
bug, can we fix the compiler please or at least submit a bug to the gcc
developers?

I'm slowly moving all my boxes/builds over to using clang to build the
kernel due to rust kernel work, so I guess I can do that here as well as
I don't think this issue shows up for that compiler, right?

thanks,

greg k-h
