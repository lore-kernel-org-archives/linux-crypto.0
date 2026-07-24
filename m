Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694CF376A17;
	Fri, 24 Jul 2026 13:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784901186; cv=none; b=JOBR204OZg/1o8SAEi32CGYor18Ietd8pin+Gb79OOorxmg/MWoh1RsVG5BWgcwQ9jREQJHoliEtVNhRZygFXkrdltX48VU7bEelUFFYNuY89A4406DQnsMkCHPnP+26m+rWclyIVWGXNIRapx1qXIDduzmJ5/kOh1waH1/pdXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784901186; c=relaxed/simple;
	bh=mf0zgGeSG4/2qWgYVF4mbM73/fxIxd0XFf7tIhR6b8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uHhU0zLaaXkZjSyttUPHDqRzFd6LFJ8vwM6uTz8yQ2x3KQVowALLNegf5Bz/C3WAh2Je4DvBKakVCku4Sm0XDOmy4z+RWb1rNwEafSaz6G6U22Jz+cd/jvL0ouCHJh0JxS9hmy2VSlCQJEPi+8k9mIpqrsZlyqgu+C6PmSz481s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DVHAf0IX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DVHAf0IX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88DA1F000E9;
	Fri, 24 Jul 2026 13:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784901183;
	bh=uNvIwIL0F+WGb1cP296osJ4ZZdbCodbHqraWe1YZzog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DVHAf0IXKut/rgOXRCr3U1pceg9fxuVvhvImCQ8KNMSrzvzTohQO0zFfyZCm9Q01l
	 jS1KjX/6eVwf5/LlLcZqa2go7vFFK80H5kHCOiKl2L48aj2OZr80Z0jh6H+lGDSKe5
	 Efbp/ZC6xCjRdfROMt+CDOOgI0eCWKhr5bx8Y8dfA8vXRNETYrY70iHYHEZl0tAi3c
	 4aT74NHW297AKS0BK+/NbrnvXEzc843AXm6BV3fARrdzI4RTzqzJb7MHbkzpRkjAWF
	 /pu0N8OzWMFnrePzg1FAO+TRKwgxdDyAsXa+6FsXcx3KnIWK4QdbNliRaWnTLz8BYr
	 N0+oN4yQmMIMA==
Date: Fri, 24 Jul 2026 06:51:11 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sumit Garg <sumit.garg@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] crypto: qce - Remove driver
Message-ID: <20260724135111.GA1876@sol>
References: <20260724050645.223799-1-ebiggers@kernel.org>
 <amM22cX7KTqyOoOk@sumit-xelite>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amM22cX7KTqyOoOk@sumit-xelite>

On Fri, Jul 24, 2026 at 03:26:41PM +0530, Sumit Garg wrote:
> Hi Eric,
> 
> On Thu, Jul 23, 2026 at 10:06:45PM -0700, Eric Biggers wrote:
> > This obsolete driver was already marked as BROKEN.  However, keeping
> > BROKEN code around in the tree is unnecessary and causes problems.  It's
> > much better to just remove it entirely.  Let's do that.
> > 
> > Crypto acceleration remains well-supported on Qualcomm SoCs via the
> > Qualcomm Inline Crypto Engine and the ARMv8 Crypto Extensions, which are
> > what Linux actually uses in practice.  The obsolete QCE driver is a
> > dead-end approach.  It's extremely slow and just doesn't work well.
> 
> Not sure why only performance is seen as the major driver to drop crypto
> accelerators from kernel

Maybe you missed all the other reasons I gave too.

> while neglecting the security use-cases they support as well like:
> 
> - Support for hardware backed keys
> - Support for secure media playback use-cases

The QCE driver doesn't support these features.  So they aren't relevant
to this patch.

> I know it's not good to add functionality based on a prospective
> future use-cases but at the same time dropping functionality for it to be
> added again is just too much unnecessary churn.

This conflates current functionality, which doesn't meet upstream kernel
inclusion standards, with mostly-unrelated speculative future
functionality.  Anything new should just start from a clean slate with
just what is actually needed.

> I am sure you are aware about support for hardware backed key use-cases
> for many of those crypto accelerators. NXP CAAM engine is one such
> example.

The CAAM driver does register a "cbc(paes)" algorithm with the crypto
API (i.e., CBC-AES with a hardware backed key).  However, there's no
upstream user of that algorithm as far as I can tell.

But this is unrelated to this patch, which is for the QCE driver.

- Eric
