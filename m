Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576302FD69D;
	Tue, 29 Sep 2026 22:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790722645; cv=none; b=dvXZSd7q3qLw6AFpBjotWwXXbf+FlDzVCl26sPNwW+WvvasK88P0QFrpvuHkD9RNse+/qJFY12oNor7L6NMNrhzxnV4Fa4LOQEy0UwKK8sjPRm0vV1iG178SDsrrkyD7gm+Ai7VM3h3NMAnol+5hRzU4I5q7ULjOpfm5ar8Z0Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790722645; c=relaxed/simple;
	bh=UZ7TPFnZ8PRkgPT7RwOFKd+eqi9dOQW8vw/C1tCq0As=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rNV1bkOTNo3ANHqMz+eDrfE2aSOTmHLBePg6lH898K0sA1JhzSWPm7oLR/LX9TVLoqO5TGy6Qj8V2wyzOLE8tFmmSTqldpPKpyKxWcyaAU0Hy124yytN2aF/Cak2b0xtMtpGrV+sYViF3AeuyB2faLU9kFvYP2ObwuPvt6cqZ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AQ6wV5aF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AQ6wV5aF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B252A1F000FF;
	Tue, 29 Sep 2026 22:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790722643;
	bh=R6gmglEOgAQTUpDzQVkvy6EINCAKv6cFhDk7A6AFvWg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AQ6wV5aFQ9dGJ02rCSi2IMK/2VfbRnj7slqRfgw8da3Eu1UtHvCVgKxa0D6BWtR0G
	 2yStUkln71qqZlFAgJWIoUDGRgu3tacQaXq8SFyauPVCZPc3c8MGXenSGycU4N5WEm
	 XapTDI2OgIzQs+cAETjMl9AX5+Ov7pqheNXXB9JLzderXg/DI8mvOeR5AMIZVQ2fvQ
	 BInFi6rmcS8mLC0r3gT0H4zSZPV+Qa47QZqoSZK9u4SsqI6qHGkoLI3XGEuYKw8FnM
	 0gsjm2WJDQmHr+ZKaplBZdQ1mmwEqXmC7Zr8p447yAjaIdiPavP8GLdYcjQsfdXTb2
	 cM9Wltln/cyow==
Date: Tue, 29 Sep 2026 15:57:22 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Stian Halseth <stian@itx.no>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>, linux-crypto@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: sparc/aes-xts: Add optimization using the
 AES opcodes
Message-ID: <20260929225722.GA1921@sol>
References: <20260929211218.4194135-1-stian@itx.no>
 <20260929212459.GA2843629@google.com>
 <a166f1e004b8c2d859232d87a3745f5faa480607.camel@itx.no>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a166f1e004b8c2d859232d87a3745f5faa480607.camel@itx.no>

On Tue, Sep 29, 2026 at 11:33:58PM +0200, Stian Halseth wrote:
> Hi Eric,
> 
> On Tue, 2026-09-29 at 21:24 +0000, Eric Biggers wrote:
> > 
> > It's a little late to be adding new optimized code in 7.3.  But yes,
> > full AES-XTS performance requires that it be implemented directly, so
> > we
> > should add this optimized AES-XTS code in 7.4 (assuming people still
> > care about SPARC, which I guess you do).  For 7.3 let's just suppress
> > "xts-aes-lib" on sparc.  I left it out of the patch
> > https://lore.kernel.org/linux-crypto/20260925202353.10763-1-ebiggers@kernel.org/
> > , but I guess it should be included after all.
> > 
> Completely understandable. I was considering sending two patches at
> first, one to suppress "xts-aes-lib" on sparc, and one with the
> optimized code.
>  
> You're adding the suppression? 
>
> If yes, I can test the suppression on a T7-1 and a T4-1 when you have
> it. 

It's in v3 now:
https://lore.kernel.org/linux-crypto/20260929222752.36427-1-ebiggers@kernel.org

> For 7.4 I could send a v2 on top of it that takes sparc out of the
> suppression again, without the Fixes: tag.

I suppose.  QEMU support is normally required for new crypto library
code, so that it is actually testable.  That would rule out adding any
"new" code using the SPARC crypto opcodes until support for them is
added to QEMU (https://github.com/sparclinux/issues/issues/77).

I might be willing to make an exception for AES-XTS, since otherwise for
parity with the "xts" template the library would need to gain an
implementation of AES-XTS on top of AES-ECB.  That would be annoying
since it's inefficient, and SPARC is the *only* architecture that would
need it, as on every other architecture AES-XTS was optimized properly.

Anyway, I'll be migrating the SPARC optimized AES-{ECB,CBC,CTR} into the
library too.  I'll need your help to test it, since it's completely
untestable for anyone without SPARC hardware.  (And it will soon the
only arch with that property now that even s390 is being fixed...)

- Eric
