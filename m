Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2701BD9CE;
	Sun, 19 Apr 2026 01:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776560917; cv=none; b=ps6iKoH+nZ7ViRvZhxA2pUGekkIzxU+zI9V7m8UhK75kw1cojh0ButNw8dkbCIjDlv3QOXaBPQyb6Qfq5Zvq0loUFkZ8zeybU9XYzFqvtkxzkLaina2rG8oPev2QFGbrFG/2jKxXIL64L2Ga8Vgd6AOkmJrob8uF3+9lEJqJVn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776560917; c=relaxed/simple;
	bh=zjqqiyIJLMVQK3YeK3KmqVc4E20jaSjOag9jn8DZils=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hdsxGUVfM7AeeGTCmcI4CD77kC4hrqfvoQS6X3ZbBJ3czXSUh241fhCiqmD5AcVjAKrtWxFtIEYOeb+zruTsAkw5UxYXxZGpnoUlcZS/oZ3MdWMDeHKV+dBgAl/8m3euDnz4LKBkne132j9xvLjIQSoXNsI3bQEMX0WVIbGF7TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWXcUmfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWXcUmfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901F2C19424;
	Sun, 19 Apr 2026 01:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776560916;
	bh=zjqqiyIJLMVQK3YeK3KmqVc4E20jaSjOag9jn8DZils=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SWXcUmfxbjDNZwtrSj9KsT9voGbJ117/s0YAt3iBLLz3I66aGmmQNdKNjCVeLOIIZ
	 IfKo/taqFuX+x5ABjexZbFm3uZqAGfTu70ZHyVapLEvK8VJEIIzmvk2HV/joN95xo8
	 sLjgNkpxRYaA00qel9jQ2wM6oMdCKkIk2UZSue8Wqm15uiRrZp99fBDoLDAg5iFlhK
	 M85QugS39Z0UPqiTLdelhk+2HJJgasTfj76LsFwBiYfl/6xXHUZPoKtbvraitxiDzJ
	 jW80DEMO3FIkazqXjJRhBdOm0lJoYcHAh72rKnp2FAakjf6ffONBgKi9H9cHxVskwX
	 cF5FRyddcx9pQ==
Date: Sat, 18 Apr 2026 18:08:35 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-mips@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH] lib/crypto: mips: Drop optimized MD5 code
Message-ID: <20260419010835.GB18115@quark>
References: <20260326204824.62010-1-ebiggers@kernel.org>
 <aeQjj0J1k7siaqOF@darkstar.musicnaut.iki.fi>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeQjj0J1k7siaqOF@darkstar.musicnaut.iki.fi>

On Sun, Apr 19, 2026 at 03:36:31AM +0300, Aaro Koskinen wrote:
> Hi,
> 
> On Thu, Mar 26, 2026 at 01:48:24PM -0700, Eric Biggers wrote:
> > MD5 is obsolete.  Continuing to maintain architecture-optimized
> > implementations of MD5 is unnecessary and risky.  It diverts resources
> > from the modern algorithms that are actually important.
> > 
> > While there was demand for continuing to maintain the PowerPC optimized
> > MD5 code to accommodate userspace programs that are misusing AF_ALG
> > (https://lore.kernel.org/linux-crypto/c4191597-341d-4fd7-bc3d-13daf7666c41@csgroup.eu/),
> > no such demand has been seen for the MIPS Cavium Octeon optimized MD5
> > code.  Note that this code runs on only one particular line of SoCs.
> > 
> > Thus, let's drop it and focus effort on the more modern SHA algorithms,
> > which already have optimized code for the same SoCs.
> 
> I don't mind deleting this (I shut down all my MIPS hardware already
> in new year 2020 to start a "fresh" decade), but just for the record,
> this will probably downgrade the performance of TCP_MD5SIG which I recall
> was the original reason this code got added...

Sure, for any removal of optimized code it's always possible to
hypothesize a case where it regresses performance.  The question is
whether it actually matters and is worth keeping around.  You mentioned
that you did care about this code, but no longer do.  I think anyone who
may have cared about this in the past is likely to have had a similar
experience.

After all, the only line of SoCs that could run this code switched from
MIPS to ARM in 2016.  Meanwhile, TCP-MD5 itself is insecure and has been
superseded by TCP-AO.  (Note that TCP-AO supports HMAC-SHA1 and
HMAC-SHA256, which are still accelerated on MIPS Cavium Octeon.)

Yes, there are still people using TCP-MD5 anyway (on some platforms, not
necessarily this particular one).  But a nudge towards upgrading to
TCP-AO isn't necessarily a bad thing, either...

> Also that PowerPC case about "misusing AF_ALG" is interesting - I often do
> similar on small systems (just to save binary space and avoid duplicate
> implementation) - why AF_ALG even allows such use if it's considered
> a bug?

It's just a mistake from a long time ago (2010) that still has to be
maintained for backwards compatibility.  It's not something that would
be accepted in the kernel if it was proposed today.

- Eric
