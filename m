Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6E4477E4F;
	Wed,  6 May 2026 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778074954; cv=none; b=QkYaPvZRSvlxKfkNc6cElS9t5yfqG/o5R6UzQy6PZ6qrs60x6VnQa5R8YQikh8Lp4DDon9q68O/IJgRG9G4PV+mFHUUL457nht71OKtFlpHoV+tIpRU7IlgfZcDeyhuQNsSg9DJuoNkgHfsaN4ztgpkjXjoWIUHpYvDFRrDBx7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778074954; c=relaxed/simple;
	bh=9mQgY9EIQCOwg6x2GqwR8p1HEOTWLI2ae+55eIHovlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ao+oUS02+ojteBdW6dLiyFjfxK47aB0HXSkszyOEzdTb+Id4YG8XUZ48apDi35bA4YgsmypEKMJ/Pzt6QZLOloCZ5aBvFgsNCnBFiixNC87deyjIhX1iHZH7ndjkjsnfGRPHG78nOSAg09KtUM3Mk1XzqQ8ergFvReQtmnzIyRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lScfWarb; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lScfWarb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778074953; x=1809610953;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9mQgY9EIQCOwg6x2GqwR8p1HEOTWLI2ae+55eIHovlM=;
  b=lScfWarbYKNXVXe1ML54OdU4sxURUzCP+zq8aoUW1ilISozUZ0JtRUks
   ZoMXtkmgHtm0EKMQbMRh4868Dm70/H0tOCPi+/YAeE3aYly//0ioQzzx6
   7pzZRFJl9JAoiDAbO5jxgGnQ5TM0EJNjGFo3Cu1Yfx9iltOTgEOVNSze+
   n9zwJbeaM5IlZHQC/KvBfEfJXVltrGmS1Ac5QVf4uH3+UanaTJLWWqw6d
   98q4bWGwChSXqobMCAZz+2tNxGdrVXzuKlWVCooz2zGCQJIlfY6WYOM6d
   KLTtX/PMw91HuRFH1YegyeOIcmkGuvn4DWSDFQazQjn9Y+Nhsag83CwhB
   w==;
X-CSE-ConnectionGUID: AFIT/4L5SCuCDjNr7wUV3Q==
X-CSE-MsgGUID: 87Z9OJhIRSCZHqLljBzQmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="78934543"
X-IronPort-AV: E=Sophos;i="6.23,219,1770624000"; 
   d="scan'208";a="78934543"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 06:42:32 -0700
X-CSE-ConnectionGUID: XAmAsc2bS0+jAYvuD5cemA==
X-CSE-MsgGUID: smdzArOtTJKgrmbEtAHpTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,219,1770624000"; 
   d="scan'208";a="236052154"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.244.183])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 06:42:28 -0700
Date: Wed, 6 May 2026 16:42:25 +0300
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
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2] crypto: ecc - Unbreak the build on arm with
 CONFIG_KASAN_STACK=y
Message-ID: <aftFQUoLcQTgW_CO@ashevche-desk.local>
References: <7e3d64a53efb28740b32d1f934e78c10086208ab.1778073318.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e3d64a53efb28740b32d1f934e78c10086208ab.1778073318.git.lukas@wunner.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, May 06, 2026 at 03:27:49PM +0200, Lukas Wunner wrote:
> Andrew reports build breakage of arm allmodconfig, reproducible with gcc
> 14.2.0 and 15.2.0:
> 
>   crypto/ecc.c: In function 'ecc_point_mult':
>   crypto/ecc.c:1380:1: error: the frame size of 1360 bytes is larger than 1280 bytes [-Werror=frame-larger-than=]
> 
> gcc aggressively inlines functions called by ecc_point_mult() (without
> there being any explicit inline declarations), which pushes stack usage
> close to the limit imposed by CONFIG_FRAME_WARN.  allmodconfig implies
> CONFIG_KASAN_STACK=y, which increases the stack above that limit.
> 
> In the bugzilla entry linked below, gcc maintainers explain that gcc
> estimates extra stack usage caused by inlining, but ASAN instrumentation
> is added in post-IPA passes and thus the inlining heuristics cannot
> account for it.
> 
> It could be argued that -Werror=frame-larger-than=1280 instructs the
> compiler to avoid inlining beyond that limit lest the build breaks,
> which would imply gcc behaves incorrectly.  But gcc maintainers reject
> this notion and believe that a warning switch should never affect code
> generation, even if it is promoted to an error.
> 
> One way to unbreak the build is to limit inlining via -finline-limit=100
> or by explicitly declaring some functions noinline.  However while it
> does keep stack usage of individual functions below the limit, *total*
> stack usage increases.
> 
> A longterm solution is to refactor ecc.c for reduced stack usage.  It
> currently performs ECC point multiplication with a Montgomery ladder
> which uses co-Z (conjugate) addition to trade off memory for speed.
> The algorithm is susceptible to timing attacks and needs to be replaced
> with a constant time Montgomery ladder, which should consume less memory
> and thus resolve the stack usage issue as a side effect.
> 
> In the interim, raise the limit for ecc.c, as is already done for
> several other files in the source tree.
> 
> Constrain to gcc because clang 19.1.7 does not exhibit the issue.  It
> makes do with a 724 bytes stack frame even though it inlines almost the
> same functions as gcc.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

...

> +# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124949

Perhaps also mention the algo change as that one sounds to me even more
critical than this issue per se.

> +ifeq ($(CONFIG_ARM)$(CONFIG_KASAN_STACK)$(CONFIG_CC_IS_GCC),yyy)
> +CFLAGS_ecc.o += $(call cc-option,-Wframe-larger-than=1536)
> +endif

-- 
With Best Regards,
Andy Shevchenko


