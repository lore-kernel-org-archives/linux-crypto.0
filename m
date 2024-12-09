Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4B5199E84;
	Mon,  9 Dec 2024 20:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733774586; cv=none; b=VHjUQT/kC+cVEx+LHfqZkDbGyTPMxTA75dwGL+yBS0kKAVNRetdTGC//8Ejo1xlvRYY2qz8F2Lj09rUdTG+KdQzFVytC8iezMxlltsNV6qa5blFvLKJyA5eYIC43wzyF3gD56yfZVpKF3UcbW0AKqzrqLbbriPSMtwwRw7dfsRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733774586; c=relaxed/simple;
	bh=9u8xk4MVZjE+I/KmhhxlHUJLDsygTkdptb4/MiVBuxo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gg9SPyBH6EHgS0I1bHrMkLaPlvNHUXsxYY4rL7jlYDfBD9E05KfJ8waH8bIy+tj6LQAv5gC3T1W4irMmerfJyZLnrfqCn3xz81hMSsjOipr+4nFtNtMfTSAGsA7A+F2Jl0Yu5Rwtfc3Ds918cxzA51LEkJnQdJHn5asrQgOGj78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHOd5B1I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHOd5B1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A131C4CEDF;
	Mon,  9 Dec 2024 20:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733774585;
	bh=9u8xk4MVZjE+I/KmhhxlHUJLDsygTkdptb4/MiVBuxo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jHOd5B1IEei7aAFajLNzTzLacvccQX4fmtk8G541ZumOpJx031vdP3BPgRurQYR+0
	 uJhhZBZg2+Ioy/ImLgu/+aqZoeuNXLFCrc/cy9Cx26GslAG13o/GFTLsZTdqEjl76t
	 4kh+a3Pxzt+yeHcQvZDfg4+LXSjLUs+WrbYoGo1tEM3Epho5quFRPDdk2rTXyld7tP
	 Ry4N5juOeUIYLmSMlIia0qx4YYcxvKuOk24XTIfNebfSHPdHLLpWJnLgTIeSjHzWxy
	 Zjof6Esy6fBVfKcF19IYdyAzJ1U6teIIODq9ILepW+8Q2tJ2HUjav6g2ML3H0SVGcf
	 ey5n2L1ekaEKw==
Date: Mon, 9 Dec 2024 13:03:00 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Nilay Shroff <nilay@linux.ibm.com>, linux-kernel@vger.kernel.org,
	briannorris@chromium.org, yury.norov@gmail.com, kees@kernel.org,
	gustavoars@kernel.org, steffen.klassert@secunet.com,
	daniel.m.jordan@oracle.com, gjoyce@ibm.com,
	linux-crypto@vger.kernel.org, linux@weissschuh.net
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
Message-ID: <20241209200300.GB1597021@ax162>
References: <20241208161315.730138-1-nilay@linux.ibm.com>
 <2024120938-kilogram-granite-9a53@gregkh>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024120938-kilogram-granite-9a53@gregkh>

On Mon, Dec 09, 2024 at 07:45:51AM +0100, Greg Kroah-Hartman wrote:
> > diff --git a/scripts/Makefile.extrawarn b/scripts/Makefile.extrawarn
> > index 1d13cecc7cc7..1abd41269fd0 100644
> > --- a/scripts/Makefile.extrawarn
> > +++ b/scripts/Makefile.extrawarn
> > @@ -27,6 +27,7 @@ endif
> >  KBUILD_CPPFLAGS-$(CONFIG_WERROR) += -Werror
> >  KBUILD_CPPFLAGS += $(KBUILD_CPPFLAGS-y)
> >  KBUILD_CFLAGS-$(CONFIG_CC_NO_ARRAY_BOUNDS) += -Wno-array-bounds
> > +KBUILD_CFLAGS-$(CONFIG_CC_NO_STRINGOP_OVERREAD) += -Wno-stringop-overread
> 
> I don't want this disabled for all files in the kernel, we only have one
> that this is a problem for.  I think you disable this, the whole fortify
> logic is disabled which is not the goal, why not just force the fortify
> feature OFF if we have a "bad compiler" that can not support it?

I am glad we agree that disabling -Wstringop-overread for the kernel
entirely is the wrong way to approach this but I think that turning off
ALL of FORTIFY_SOURCE for these compiler versions (which are some of the
latest available) is also the wrong approach, especially in this current
situation where it seems like it is unreasonable to expect the compiler
not to warn about a potential overread here with the amount of
information available to it but maybe I am misunderstanding something
here:

https://lore.kernel.org/20241209193558.GA1597021@ax162/

If it is not possible to shut the compiler up by changing the source to
be more robust, I think we should strongly consider disabling it in
directly in cpumask_copy() using the __diag infrastructure. I think it
is underutilized as a solution to warnings like this.

> And it's odd that we are the only 2 people hitting it, has everyone else
> just given up on gcc and moved on to using clang?

Maybe people are not using CONFIG_WERROR=y and W=e when hitting this so
they do not notice? It also only became visible in 6.12 because of the
'inline' -> '__always_inline' changes in bitmap.h and cpumask.h, since
prior to that, the size of the objects being passed to memcpy() were not
known, so FORTIFY could not catch them (another +1 for that change).
From what I can tell, it also requires a CONFIG_NR_CPUS value of 256 or
greater, otherwise large_cpumask_bits is NR_CPUS, a compile time
constant.

Fedora clearly sees this though but it does not break their builds so I
am guessing they have not reported it upstream yet?

https://koji.fedoraproject.org/koji/taskinfo?taskID=126644404
https://kojipkgs.fedoraproject.org//work/tasks/4404/126644404/build.log

For the record, clang has no warning like this because with how clang is
currently architectured, the vast majority of warnings happen in the
front end, where there is usually not enough reliable information
available to make these kind of warnings be accurate, at least from my
understanding.

Cheers,
Nathan
