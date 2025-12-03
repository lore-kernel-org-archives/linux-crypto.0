Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE79238C0A
	for <linux-crypto@vger.kernel.org>; Wed,  3 Dec 2025 17:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764782651; cv=none; b=AlirDUQhYt1XUi99dXbmiSQa5cvgkEYAMrKmAgKkZ/oZjqRYHECVHH5YbemRpOUFygPSFJhk+JUXDgx6HsWgfvK5rM1GY8qhqEYzfvUpJ1bgimzQ5sOW5jna+f0r3zDXW+Npwv176RAvNWciSjBZ0L2kwYloDP4BV1Xjsi8oVk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764782651; c=relaxed/simple;
	bh=vUvQxtjSmhgkuEwJ/G9sncL/cdAlEjwVg0Rtm293KQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FftiYqJMFVEf4WYHbebMZ7aI+nez8Z+BtdFFUriW59vC0pgp1G+BsfeSI55b+9xYCTVKCr/DkqI4tti8LwLo98NJyWgLhVUQ6iYHnAi//Bbri0IsqaBmKLrD3sQeAHhVlJXzbqjCr6UNN71/6xeWR5vqnnkWM4rbOrzG3ARPv+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LN/lxM1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LN/lxM1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A68BC4CEF5;
	Wed,  3 Dec 2025 17:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764782651;
	bh=vUvQxtjSmhgkuEwJ/G9sncL/cdAlEjwVg0Rtm293KQw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LN/lxM1JZb8WmwAY+YygAZ29C5ThudroCqwNqC7iwoH+eYHq53H9EWgJvaC1G8hrO
	 ZAjcQCZxNCnRvX3mQ4dOEMWhuJsnl94rCfLDUFRbmMZ+3ZoaddVRsuwLwYXcAuMjlD
	 vyGWPd342HOuziUPK+X4vfGOjz4BaFJO/2ZnFGy0lnNMeZd3ZIIDedYCS9BpumlvVB
	 BZj2j5vTTp9Sp39fCMmhacNBbEHLs4EE9ER4QqduwzjEgDHPxUIR6etUAjSvqWVxXy
	 j2a6JO7VD/68wvqWb0fLQLvo82twi5r/KYlgwG2Fw3Rfd4JzsiIAr3IrC3utjjgjh/
	 zNTnwTcn0Ipeg==
Date: Wed, 3 Dec 2025 17:24:06 +0000
From: Daniel Thompson <danielt@kernel.org>
To: Alejandro Colomar <alx@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de,
	ebiggers@kernel.org, kees@kernel.org, linux-crypto@vger.kernel.org,
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <aTByNvAYRhZI07cJ@aspen.lan>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>

On Tue, Dec 02, 2025 at 02:12:47AM +0100, Alejandro Colomar wrote:
> Hi,
>
> Jason said:
> > On Sat, Nov 15, 2025 at 09:11:31AM -0800, Linus Torvalds wrote:
> > > So *if* we end up using this syntax more widely, I suspect we'd want
> > > to have a macro that makes the semantics more obvious, even if it's
> > > something silly and trivial like
> > >
> > >    #define min_array_size(n) static n
> > >
> > > just so that people who aren't familiar with that crazy syntax
> > > understand what it means.
> >
> > Oh that's a good suggestion. I'll see if I can rig that up and send
> > something.
>
> Be careful about [static n].  It has implications that you're probably
> not aware of.  Also, it doesn't have some implications you might expect
> from it.
>
> -  [static n] on an argument implies __attribute__((nonnull())) on that
>    argument; it means that the argument can't be null.  You may want to
>    make sure you're using -fno-delete-null-pointer-checks if you use
>    [static n].
>
> -  [static n] implies that n>0.  You should make sure that n>0, or UB
>    would be triggered.
>
> -  [n] means two promises traditionally:
>    -  The caller will provide at least n elements.
>    -  The callee will use no more than n elements.
>    However, [static n] only carries the first promise.  According to
>    ISO C, the callee may access elements beyond that.

This description implies that [n] carries promises that [static n] does
not. However you are comparing the "traditional" behaviour (that is
well beyond the scope of the standard) on one side with ISO C behaviour
on the other.

It makes sense to compare ISO C behavior for [n] (where neither of the
above promises applies) with ISO C behaviour for [static n]...


>    GCC, as a quality implementation, enforces the second promise too,
>    but this is not portable; you should make sure that all supported
>    compilers enforces that as an extension.

... and equally it makes sense to compare the gcc/clang warnings for
[n] versus [static n] as recommended here.

However it should not be motivated by [static n] carrying few promises
than [n], especially given gcc/clang's enforcement of the promises is
a best effort static check that won't cover all cases anyway.


Daniel.
