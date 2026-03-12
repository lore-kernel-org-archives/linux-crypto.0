Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910E03AD517;
	Thu, 12 Mar 2026 21:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773352528; cv=none; b=XE0x4L4p4KJkSKmes9NojZ2tYiGk5YAqWntuhE4oVWU5kJRe8OuMG+wioLlhT1QdfyANp59qWuXZGj9mX22NbyN1y9xfdTbuVzbnvKNm0/GkOLaNiHqbo/cMDILnGGVlCA6ADDdSBfnztB3mzixd+BrZX7+Io4JV8X54utaASnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773352528; c=relaxed/simple;
	bh=PY8Vc2H7sMOf74CZVsffNTtIJTqcYv+W/EtbSsEfFKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rc/kXp4ER1O7/Z2jfvrwMpjnDCckCVOWr3EhWsM56TkEALmmhNKdIOUntAtMsTbnL0nTROc4stE+cykQgVm6A/mFyDCdgVDYq67NnyrItT9tVyccJBqoH4qNSWCM+9lIWVXHkc6bWj+1mDxKVkDSbpw7Q1bk0EcXWmLjQXkk7U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkLNkbzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkLNkbzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5363C2BC86;
	Thu, 12 Mar 2026 21:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773352528;
	bh=PY8Vc2H7sMOf74CZVsffNTtIJTqcYv+W/EtbSsEfFKM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GkLNkbzmjF7l3ZjKuY8gMyuQ3SwjNLgCEQ1pZ7H94B+gKAINO4KBcmS0/iyAKteF/
	 xJk3LD+ergcCNr762nNva3t8u2e1a19tQelDAYPNUiYtSm1H/3YUFW8XSvwgQcVWOP
	 gIwE71sjR/yWLn4nTo7tlAN2JdRbbTiKm8maNP+jsA6CV+nWnxTvwyilarI8nb4Jgw
	 jyy0NP8huayF6x/Y3JjJT1/avhRRvg/KWo8gNAlhlFjirkNLToqgbFyhTrqu01WEeD
	 3uUrZGCX2NtGFqj/6gbpiRViWzCswgquTXn6T2WQUOYse25yt4GisRl5AbOCrLYD18
	 WmotPaLRNklyg==
Date: Thu, 12 Mar 2026 14:55:26 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] lib: crypto: fix comments for count_leading_zeros()
Message-ID: <20260312215526.GB4805@quark>
References: <20260312161133.249374-1-ynorov@nvidia.com>
 <abLnLIRf6z8nh_Pu@ashevche-desk.local>
 <abLrHz5BRojkcoxM@yury>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abLrHz5BRojkcoxM@yury>

On Thu, Mar 12, 2026 at 12:34:39PM -0400, Yury Norov wrote:
> On Thu, Mar 12, 2026 at 06:17:48PM +0200, Andy Shevchenko wrote:
> > On Thu, Mar 12, 2026 at 12:11:32PM -0400, Yury Norov wrote:
> > > count_leading_zeros() is based on fls(), which is defined for x == 0,
> > > contrary to ffs() family. The comment in crypto/mpi erroneously states
> > > that the function may return undef in such case.
> > > 
> > > Fix the comment together with the outdated function signature, and now
> > > that COUNT_LEADING_ZEROS_0 is not referenced in the codebase, get rid of
> > > it too.
> > 
> > FWIW,
> > Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> Thanks, it worth!
> 
> Applied for testing in -next.
> 
> Thanks,
> Yury

Acked-by: Eric Biggers <ebiggers@kernel.org>

- Eric
