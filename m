Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A439466B73;
	Wed,  6 May 2026 14:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778076229; cv=none; b=Cyr685xDsNRKEtEjIwK7yLbzhJwheW4eWjrm9Q8HRL7jfSU0NVT0XjOwDywxeNt7bpaPBqRVOXbNzqMWRU+EIArjZh9jy6MAqijvxwC63o1DuG/3NBgSOFn6FbF+WgX4xXyQMDRD/RUDbyrH47ES7FaIx2F98fiQ2tdwNWkGuVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778076229; c=relaxed/simple;
	bh=6N2hkinZipOCGLaYnX6AVbvWmm9c6ZxQLYB+AgrLToM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHNwUAyXIjMBVQcelTSXmLksixpr6MwTLerzLMRG4SxZYSS+mKMnBJ5Ke8vDC1JU7Ds6QCo2C/93/1JAqu08YYoMD8ThWhGJEtWGJ9Xa3ClX8TWk/aS8UATY8ade+LXRdDNbP3JGcEHxsaU8mTwFsyeDSXabe78QvwocsLJc56w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jTF0UEJ5; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jTF0UEJ5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778076228; x=1809612228;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6N2hkinZipOCGLaYnX6AVbvWmm9c6ZxQLYB+AgrLToM=;
  b=jTF0UEJ5iKHSDBKt1RXfrQnraeaY5IwkUtdeK+OlcbL7TKJ1622YbPLP
   iDSdmUWah78C75M5tREq531itWs8DegSEEIugCFRudAIsUDyXI51ScYuj
   FvRWtv02TenX2wfAY1jwOeColekwHeQ6BEck6IGUHqk4djEGAYFVmWL0T
   sGh1LB1stpHk83AcJl06dy5yUpVt5KcY2/S/rNYy0sED4Mm7ue1AzeaqZ
   HG8lONgBsb8wZwRH8uX1qa7385UTPbQk/wJw4IGBgmHQwoAP8rJwJlj/V
   PQ//1nLeSdmvPQ3CZ13HLNmR+fhj1X2rHFoX5ROLDj/JhTYMXCQ5YhDVH
   A==;
X-CSE-ConnectionGUID: IejNgLAPThmmmOPBTAoLxA==
X-CSE-MsgGUID: Pee1Jhb4Q1OijzsQClSZIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="82852575"
X-IronPort-AV: E=Sophos;i="6.23,219,1770624000"; 
   d="scan'208";a="82852575"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 07:03:47 -0700
X-CSE-ConnectionGUID: 6ejNQ5EFQamukT1w4lSfyw==
X-CSE-MsgGUID: /IAFwLB0RpyfV5fZzyeaDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,219,1770624000"; 
   d="scan'208";a="259845554"
Received: from abityuts-desk.ger.corp.intel.com (HELO localhost) ([10.245.244.183])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 07:03:42 -0700
Date: Wed, 6 May 2026 17:03:39 +0300
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
Message-ID: <aftKOz5tjymZFG0e@ashevche-desk.local>
References: <7e3d64a53efb28740b32d1f934e78c10086208ab.1778073318.git.lukas@wunner.de>
 <aftFQUoLcQTgW_CO@ashevche-desk.local>
 <aftIhnaK7RKCO6F7@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aftIhnaK7RKCO6F7@wunner.de>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, May 06, 2026 at 03:56:22PM +0200, Lukas Wunner wrote:
> On Wed, May 06, 2026 at 04:42:25PM +0300, Andy Shevchenko wrote:
> > On Wed, May 06, 2026 at 03:27:49PM +0200, Lukas Wunner wrote:
> > > A longterm solution is to refactor ecc.c for reduced stack usage.  It
> > > currently performs ECC point multiplication with a Montgomery ladder
> > > which uses co-Z (conjugate) addition to trade off memory for speed.
> > > The algorithm is susceptible to timing attacks and needs to be replaced
> > > with a constant time Montgomery ladder, which should consume less memory
> > > and thus resolve the stack usage issue as a side effect.

[...]

> > > +# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=124949
> > 
> > Perhaps also mention the algo change as that one sounds to me even more
> > critical than this issue per se.
> 
> Hm, but it's already mentioned above in the commit message?

Commit message != Makefile (or any other in-tree file).

But if you think that this is enough, I am not going to object, it would just
require a few steps to get that from the line in file.

-- 
With Best Regards,
Andy Shevchenko


