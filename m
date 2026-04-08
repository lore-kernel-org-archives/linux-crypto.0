Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38DE3D3490;
	Wed,  8 Apr 2026 14:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775658774; cv=none; b=o+H36zSInSRZH0RqQVzagLT9+lwxAtUXvoYbWGZosb3BD8tik4n1k3iytWZbA0kh07vuzX9gKmhFmSSQePMwpjjcl2/ruGvLxM396UEkefILR+du/r+s4EER9rtQWDPUqaMrQL2iav9P49/saDaqBeQ1dXb7ESRf891OWDcRh4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775658774; c=relaxed/simple;
	bh=WK6IAGk5OXKfShONq3zXcI+AMHaVUcQ0AKZj76A+z9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CeaQ7zPCvAvO1Gpglq0E6XlN01IClCAMGhXekotQVzQRVp2WiYdCXbnOqQgQvSdi9v6+0Iy1pcgfxcSlXzklorggKpkmGUgsIxwMbSiTlJ8TgCBmKm3aVBoVQSn/9dkXPp5mthwC9bXmdAIAkP5aIoxMElFcPJsrfinD+jflk1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m5epMDsm; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m5epMDsm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775658773; x=1807194773;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WK6IAGk5OXKfShONq3zXcI+AMHaVUcQ0AKZj76A+z9o=;
  b=m5epMDsmzWLnow1K2Vl/ScjlEF/Q/hYiefrWAwTltz24LXYB/n2xN2NR
   2/MMYe8XarHWKy9Mau/vxzOYti+kbYj7YPQCWCaS4h0DXolhHh+6GDBjo
   H1IyZJJaTm4TbATW8lSLJNUnFWVVCkuLFZg55qADgIoNq6BfbWHz3a0cI
   FUqngEvCLGt2JO4hYeKYeay/10KMgZMsyqYZtvylvsVCtadLy77UlssEH
   6b6czqvQrLdzak5+RDUmgJfgMXLEsFTZhWzAjEpoxnagzRXcOqzCpeGAO
   YInZVIsYCvsa5rx+605zNtnm8zEcYMtf1XNnqMD0jDGx0/0BYyWEluHLJ
   Q==;
X-CSE-ConnectionGUID: j/B1PghDTeKXG98Rq4JeQw==
X-CSE-MsgGUID: rlb8RldDS92xEkWr59dYyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11753"; a="75816537"
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="75816537"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 07:32:52 -0700
X-CSE-ConnectionGUID: w2xKx8xsRf2WQ30ZRb3Fbw==
X-CSE-MsgGUID: ZvkEKAwYSZ+h+/iOxydE+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="227489911"
Received: from vpanait-mobl.ger.corp.intel.com (HELO localhost) ([10.245.245.72])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 07:32:49 -0700
Date: Wed, 8 Apr 2026 17:32:46 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Lukas Wunner <lukas@wunner.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ignat Korchagin <ignat@linux.win>,
	Stefan Berger <stefanb@linux.ibm.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>
Subject: Re: [PATCH] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <adZnDoSi0UInrKRd@ashevche-desk.local>
References: <abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de>
 <adY8iUPrnoXDp_-g@ashevche-desk.local>
 <adZZ70lNnhoDnwok@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adZZ70lNnhoDnwok@wunner.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Apr 08, 2026 at 03:36:47PM +0200, Lukas Wunner wrote:
> On Wed, Apr 08, 2026 at 02:31:21PM +0300, Andy Shevchenko wrote:
> > On Wed, Apr 08, 2026 at 08:15:49AM +0200, Lukas Wunner wrote:
> > > Andrew reports the following build breakage of arm allmodconfig,
> > > reproducible with gcc 14.2.0 and 15.2.0:
> > > 
> > >   crypto/ecc.c: In function 'ecc_point_mult':
> > >   crypto/ecc.c:1380:1: error: the frame size of 1360 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]
> > > 
> > > gcc excessively inlines functions called by ecc_point_mult() (without
> > > there being any explicit inline declarations) and doesn't seem smart
> > > enough to stay below CONFIG_FRAME_WARN.
> > > 
> > > clang does not exhibit the issue.
> > > 
> > > The issue only occurs with CONFIG_KASAN_STACK=y because it enlarges the
> > > frame size.  This has been a controversial topic a couple of times:
> > > 
> > > https://lore.kernel.org/r/CAK8P3a3_Tdc-XVPXrJ69j3S9048uzmVJGrNcvi0T6yr6OrHkPw@mail.gmail.com/
> > > 
> > > Prevent gcc from going overboard with inlining to unbreak the build.
> > > The maximum inline limit to avoid the error is 101.  Use 100 to get a
> > > nice round number per Andrew's preference.
> > 
> > I think this is not the best solution. We still can refactor the code
> > and avoid being dependant to the (useful) kernel options.

> Refactor how?  Mark functions "noinline"?  That may negatively impact
> performance for everyone.
> 
> Note that this is a different kind of stack frame exhaustion than the one
> in drivers/mtd/chips/cfi_cmdset_0001.c:do_write_buffer():  The latter
> is a single function with lots of large local variables, whereas
> ecc_point_mult() itself has a reasonable number of variables on the stack,
> but gcc inlines numerous function calls that each increase the stack frame.

Ah, that makes the difference, thanks for elaborating!

> And gcc isn't smart enough to stop inlining when it reaches the maximum
> stack frame size allowed by CONFIG_FRAME_WARN.
> 
> It's apparently a compiler bug.  Why should we work around compiler bugs
> by refactoring the code?  The proposed patch instructs gcc to limit
> inlining and we can easily remove that once the bug is fixed.
> 
> As Arnd explains in the above-linked message, stack frame exhaustion
> in crypto/ tends to be caused by compiler bugs.  There are already two
> other workarounds for compiler bugs in crypto/Makefile, one for wp512.o
> and another for serpent_generic.o.  Amending CFLAGS is how we've dealt
> with these issues in the past, not by refactoring code.

Yeah, that's the way we may deal with the issue.

Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

-- 
With Best Regards,
Andy Shevchenko


