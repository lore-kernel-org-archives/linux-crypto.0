Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF99C22F76E;
	Wed, 23 Apr 2025 23:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745450411; cv=none; b=gfXHNT3Cq8cj1mkOVGZ3SXQGkj3sqmCcNiplJLzkbQ+xEpV6EFHd+tlOxeHSxV5XKQWM+spdt3w14h/xmaaeGJbVWUjGvW4UFjEKkJQVosbxnXzwI6cQzuI8qSVmp0PlEWwIz/rlJwcQxOihZbnCBQ7n1IhWz92CTfPp4Tz3Z+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745450411; c=relaxed/simple;
	bh=3uiOWncMcQog+VeVlYybOO33xn1I8xxSJCTzt66iHJ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LSB3tw/nUp9wWpHSTOFzifT6eY65Dk3vVw5OR2Thvj81114CUws5sbo8eu1JYr17sJ+Jcz8hq4s3txztn8cK5L1FbsHsyAghrZlf6DfC32OF3lHV8A3aiYAkogbdoLjA1LdqOi//7AeHUyGPi8lkJfo5XvG10jCqHR2xcGyvLlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K0hfRwkz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K0hfRwkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D01AC4CEE2;
	Wed, 23 Apr 2025 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745450410;
	bh=3uiOWncMcQog+VeVlYybOO33xn1I8xxSJCTzt66iHJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K0hfRwkzf3Lbq8g002WF5rnmccGF66P/Gou9gm059CMvfHYlMOJGG1jEDgjZRGuVF
	 2T7NC0Bm1X1kaw08uFzcheUWFQN5d/cUOLn8xzMYzcaCJbqwef9Kaa0WXQG80KDDuw
	 iopLK9XgfIDPn5K58qinqP2/ZUAmkSJANt2CCodDI8Zcih2dCc01ViC9xUIvNGZ8Pb
	 QqEpjZxuHV9kuA/dx3ykYdLmS0BzURDeQJsDta0GoDl1HMvsoAw4qQsj8QUOqh832W
	 BHd2TLRzTXi4VjZC5RNdJjulGZVfm15dFsXBu6cxeIAbiliQIizqxUNKcFFSZdz6/d
	 rI1ejKCKVTSAQ==
Date: Wed, 23 Apr 2025 16:20:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/9] crypto: tcrypt - remove CRYPTO_TEST from
 defconfigs
Message-ID: <20250423232008.GA2305@sol.localdomain>
References: <20250422152151.3691-1-ebiggers@kernel.org>
 <20250422152151.3691-2-ebiggers@kernel.org>
 <CAMuHMdX5XKmeVABxeDv4shrUy2yt6WrMV2hxVPZ5OUe0uWUY6w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdX5XKmeVABxeDv4shrUy2yt6WrMV2hxVPZ5OUe0uWUY6w@mail.gmail.com>

On Wed, Apr 23, 2025 at 08:49:24AM +0200, Geert Uytterhoeven wrote:
> Hi Eric,
> 
> (replaying my response to v1, which I wrote before I noticed there was a v2)
> 
> On Tue, 22 Apr 2025 at 17:23, Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > CONFIG_CRYPTO_TEST enables a benchmarking module that is only really
> > useful for developers working on the crypto subsystem.  It is in a bunch
> > of defconfigs.  But as with most of the other crypto options that tend
> > to be randomly set in defconfigs, it is unlikely that much thought was
> > put into these, especially when placed in "production" defconfigs.
> > Clear it out of the defconfigs for now.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Thanks for your patch!
> 
> All of these are modular, so I don't think it's a big issue, even on
> "production" defconfigs. It just means the test is available when
> someone feels the urge to run it.
> Hence I try to make all tests available as modules in m68k defconfigs.
> 
> Gr{oetje,eeting}s,
> 

Okay, but again note that this option isn't the actual crypto tests.  It's a
benchmark.  Patch #2 renames CONFIG_CRYPTO_TEST to CONFIG_CRYPTO_BENCHMARK
accordingly.  The actual crypto tests are not modular and are controlled by the
inverted option CONFIG_CRYPTO_MANAGER_DISABLE_TESTS, changed to
CONFIG_CRYPTO_SELFTESTS by patch #5.  CONFIG_CRYPTO_TEST did used to be the
actual tests, but that changed in 2008, and no one ever fixed it.

Due to the renaming I'd need to update the defconfigs anyway, and I figured just
clearing out the option is the right choice in most cases.  Hence this patch.
But if you do understand what this option does and think it should be kept in as
CONFIG_CRYPTO_BENCHMARK=m, we can do that instead (for all defconfigs that had
it, presumably?).

- Eric
