Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B053C1995;
	Thu,  7 May 2026 09:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778146028; cv=none; b=ZJ6v9gi+XSjHtCcjcW9hEsUadKuAmVW3zcECWEINP0jhaLP4bp4F86FY9C+NW3yNBSW85/wSC20xve+EjtbygSgv3M/3glSkBlSVr5I33Ekz+LGMk6s4T7o+RGaztmdaPgvZG+cgvNi2oQh6SRskhtOoDseGqZiZfZ9DquyZBTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778146028; c=relaxed/simple;
	bh=H1j3rZjckUfWY1oU8ov27ak1n4fQcf7tTaqPvuxAc7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jc2vZsgQA3sO3/njW9ysM/AOxTSiWYPZMRA9aOpHX/AhAx9Q9/SpMlW0C8GsnrbkwLN5Ydsbhhq3OW4yntw5zjcY1yOP9nxKNXd5B/OEOI4QsXkE3oGN+vR8AHVzifrg33qDfGKukDEukiWIVcOZ6MhSpmgUJ/xWl5cgeHxHcwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KtaScGdk; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KtaScGdk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778146026; x=1809682026;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=H1j3rZjckUfWY1oU8ov27ak1n4fQcf7tTaqPvuxAc7g=;
  b=KtaScGdkSFiILHYB7rhPT7y+YQZDGSnYhl2oHqXvQ+ap7V6Uu60SA1E+
   pHoSJAugGFpDImcTBno9vUtYv1TcjSmw4245qhTlogMsIF7x07f3548a/
   55jj2SBCK7eiwu9Ne9cKKFk0wUxVZW5sCgZa0Vxy4T8gb3GQ0nd9ZtIB1
   yVn4JJQoNCTu9DWMtTft3YTG6q9FYC47sidN0uLG9n3KNHnnJjTxFY4wJ
   aIflaxxkozHcWKHGj/kUVA5GqN2ybfEcY4AOnxwkfMxhi0d4KHuKe73KM
   g7Gj2e65/c2gVy9uzXeHS7JfKwS9NynkUd79IPb/6g7vn15dJIfRPMgDO
   w==;
X-CSE-ConnectionGUID: 4v2UArn+SbOXZQhUiptcNg==
X-CSE-MsgGUID: joJwltodQD6sGe9V6DrhEg==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="90547362"
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="90547362"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 02:27:06 -0700
X-CSE-ConnectionGUID: UnWxH9i8SvSZpuW58v9Ccw==
X-CSE-MsgGUID: 8rbZim2dSkutdIKs2aRo6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="236675054"
Received: from vpanait-mobl.ger.corp.intel.com (HELO localhost) ([10.245.245.149])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 02:27:01 -0700
Date: Thu, 7 May 2026 12:26:58 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Lukas Wunner <lukas@wunner.de>, "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <afxa4sDNoWmCHD-a@ashevche-desk.local>
References: <7e3d64a53efb28740b32d1f934e78c10086208ab.1778073318.git.lukas@wunner.de>
 <afwUYlGYZH5cSbg3@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afwUYlGYZH5cSbg3@gondor.apana.org.au>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Thu, May 07, 2026 at 12:26:10PM +0800, Herbert Xu wrote:
> On Wed, May 06, 2026 at 03:27:49PM +0200, Lukas Wunner wrote:
> >
> > Changes v1 -> v2:
> > * s/ARCH/CONFIG_ARM/, s/LLVM/CONFIG_CC_IS_GCC/ (Nathan)
> > * Add link to gcc bugzilla entry
> > * Rewrite commit message to include feedback provided by gcc maintainers
> >   and explain high stack usage with algorithm choice
> > 
> > Link to v1:
> > https://lore.kernel.org/r/abfaede9ab2e963d784fb70598ed74935f7f8d93.1775628469.git.lukas@wunner.de/
> > 
> >  crypto/Makefile | 5 +++++
> >  1 file changed, 5 insertions(+)
> 
> Sorry but v1 has already been applied.

Does it make sense to revert and apply v2?

-- 
With Best Regards,
Andy Shevchenko


