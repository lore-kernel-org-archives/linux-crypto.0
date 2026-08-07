Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AACA3F23A4;
	Fri,  7 Aug 2026 22:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786140276; cv=none; b=p/IV7oecd/V2451XiBG+ON3DlCDeTOpvrYHfbRFQEPlm6KsVIG4IrX6LBwVrWsKq2RtrYOEbD54uloZbgXtQDS318FcvjMOy6sHjtHTvvrwztA5kY5bVtK0EftjuYsSCw8E0YDJVZRwJQwQOmbumzfc4UJTqpIbOGjZ3iDmRrak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786140276; c=relaxed/simple;
	bh=OJIgscExKrGGFJ3hQvHyxf+CnysAv4x4Y3pGMGyG3Qs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8dcD2Lu1PyaMss1edKSD74Y4puLaV15CGLW/X/skC+LriNRIqGMQNC8GSuc+lnADqAQUGa6v2DbhOPa5keDAJWzUdg0ea4qSdrRZUawInoCKP/+hjUFs/YV1YqmZcr8sQmuQWqtKsFlemSAv1i2IsBHRdBgC5jtIP7fTe7ImYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kX7Mg1F9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kX7Mg1F9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8760F1F000E9;
	Fri,  7 Aug 2026 22:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786140274;
	bh=E9GWry2DVfG52DXSwq2e+fI08HN4QyjkwoIlaLk0NQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kX7Mg1F9GE3NWXjrY9Phm7IK1RBRA8jNawgQEhYtjMwlxp2gZt4nX90PJEGcRuKED
	 9Z0VfuGtarSRvGR0m9xO43e3ctJNsfCiNaxC4wtd/C7h1AizMPi3I6OOnbAXlrFoLf
	 wp7FYOrEBjQw/O0tGWJMyKTnqUmMv5dPtsUrQJA8f+BqElXWFqu/3SX5/vEItmyhsg
	 3/all5Y3IWX/VE9k2+/YEehRHP+RypOjk3hFEPHQhghWfWB7QzV4hlGjLGyfeGI32X
	 /Z6uAF0yNvX2oFVKScaXLSH4XFDJGDBsFyACGt42h3EAag1mvgf2WxJZG3abguDCMf
	 B0W9MkXzbYTAA==
Date: Fri, 7 Aug 2026 15:04:33 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>
Subject: Re: [PATCH] kunit: irq: Unregister on-stack timer and work from
 debugobjects
Message-ID: <20260807220433.GA2520@quark>
References: <20260806053804.106724-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806053804.106724-1-ebiggers@kernel.org>

On Wed, Aug 05, 2026 at 10:38:04PM -0700, Eric Biggers wrote:
> In kunit_run_irq_test(), call destroy_hrtimer_on_stack() and
> destroy_work_on_stack() to unregister the hrtimer and work from the
> debugobjects infrastructure (when CONFIG_DEBUG_OBJECTS_TIMERS=y and
> CONFIG_DEBUG_OBJECTS_WORK=y) before the function returns.
> 
> Found via code review; the lack of the unregistrations didn't actually
> cause a warning, since the objects are inactive upon return anyway.  But
> they should be there, otherwise debugobjects keeps tracking the objects.
> 
> Fixes: 950a81224e8b ("lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-next

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
