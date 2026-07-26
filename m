Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488EF37E5F7
	for <linux-crypto@vger.kernel.org>; Sun, 26 Jul 2026 15:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785080370; cv=none; b=HwOk+vyjTCoV+MskeAjxtS6gYyn+1qAVHdZeGpgiV8Hl+F+JUq5w0NnuOj7sol3r2juaqcrVxWaJT554GH+y7uMoUuyZ5e72EldQWVg+Jg4lKnv7becKZhss+dbmqXz4vK1LFHExkWYTpqtUDqcsiwvhPjZfE4i8TaY3oGEuqhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785080370; c=relaxed/simple;
	bh=iL72KkABiKesKfq1XhZvdKEG/0Ct+oCKov/XGE0Zi3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H2Vj5NWVbHY8Q5wgw2aarqyH/dJfC9fb/lxC1UryQsdez6Ufkkr0GqeScXePvQRl+0ZiiMVMVgZrhy78mABiZmQvgh9QfmCRaq+1G/hJyef27YF8HEslC4Zr6ApK2OF12zmFgNr7XTQr3xpToBWLc7tQmHpt4vQ2XDb8Ni5Op4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CcqO/7ba; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CcqO/7ba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25711F000E9;
	Sun, 26 Jul 2026 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785080368;
	bh=vZuTm44FcGJdQZ2c+a4IFLBGkkgDg+rbCxJuQpjlBz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CcqO/7bayj8PiXKcZJculq/zSTr6cRHttFeux7/e1TTiklPFtVntvcMgHUyk8Dg1m
	 aQ0yF9cFe+dEDcQX5uh+auHxkePkYv2/hgMkA2dCK7S0+2l4qsU6LMNIxBvpECGeHD
	 TBoL9RW6IHTHArKiIMFse/Qd/F86PRJ2/+j4729E270mODEuUepPAiCZlJTlvGLU/F
	 RTS0VygWlr62G0biZZTYmFvhQX5TjpqA3DTq1jzBC5I8sz9RU7eFNZG0wBQwsgqxlq
	 3sWEKtQYcGJCc7EO7XIMP93uLbJ7Sk9BmlrlEK5YkyRC/cTjmkqjPOxY/R2nN7FQeV
	 XoLTstajlUfIA==
Date: Sun, 26 Jul 2026 08:37:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Richard Weinberger <richard@sigma-star.at>
Cc: Christoph Anton Mitterer <calestyo@scientia.org>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Milan Broz <gmazyland@gmail.com>,
	Demi Marie Obenour <demiobenour@gmail.com>
Subject: Re: AF_ALG deprecation fallout
Message-ID: <20260726153736.GA1673@sol>
References: <27816cc353731e8e5484adad7d0fc447777727d8.camel@scientia.org>
 <20260708011112.GA3890@sol>
 <4065668.hXSD6JRtRq@nailgun>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4065668.hXSD6JRtRq@nailgun>

On Sun, Jul 26, 2026 at 01:12:32PM +0200, Richard Weinberger wrote:
> On Mittwoch, 8. Juli 2026 03:11 Eric Biggers wrote:
> > Note that cryptsetup 2.8.7 will further reduce the cases in which it
> > even needs AF_ALG at all.  So just because you are using a particular
> > algorithm doesn't necessarily mean you need it in AF_ALG.
> > 
> > No algorithms have been proposed to be dropped from dm-crypt (which is
> > *not* the same thing as AF_ALG), by the way.  Given that dm-crypt allows
> > some "interesting" algorithms like RC4, DES-ECB, and even the null
> > cipher, I do think we can expect an allowlist for it at some point as
> > well.  But that would be separate.
> > 
> > I'd indeed like to remove AF_ALG entirely eventually.  But that's a long
> > term thing that would be many years from now and would occur only after
> > iwd, bluez, cryptsetup etc. have all fully migrated to userspace crypto.
> 
> Since I got already mails from alerted clients, I'd like to highlight
> one particular use case on (deeply) embedded systems and make sure
> this use case is known.
> 
> On systems with very little space, like a few megabytes of flash,
> utilizing dm-crypt with LUKS can be a challenge. Adding a crypto
> library to userspace (e.g. initramfs) is a huge burden.
> 
> cryptsetup's --with-crypto_backend=kernel helps a lot here.
> So, by completely removing AF_ALG these systems would unnecessarily
> suffer. Please keep both AF_ALG and --with-crypto_backend=kernel around.

I assume the key on these systems tends not to come from user input
(such as a passphrase).  So do you know why cryptsetup and LUKS is being
used at all, instead of just using dm-crypt directly?

Even if LUKS is used, it should be feasible to implement with neither
AF_ALG nor an external userspace crypto library, saving space over your
requested solution which bloats the kernel with AF_ALG.  Indeed, in
cryptsetup, LUKS keyslot en/decryption already falls back to a temporary
dm-crypt mapping; see lib/utils_storage_wrappers.c.  I understand this
wasn't done consistently in old versions, but in v2.8.7 it is.

For key derivation, assuming the LUKS2 defaults are used, cryptsetup
already has built-in Argon2 code, including an implementation of the
BLAKE2b hash function; see lib/crypto_backend/argon2/blake2/.

So it seems the only missing piece for LUKS is actually the metadata
checksums.  (I'll assume that 'cryptsetup benchmark' and support for
formatting a file in LUKS format as non-root users aren't needed here;
those seem to be for testing purposes.)  For LUKS2 that's SHA-256.
Built-in SHA-256 could be added to cryptsetup; this would be much
smaller than the code for AF_ALG.  Alternatively, for new volumes,
support for configuring these to use BLAKE2b could be added, simply
reusing the BLAKE2b code that is already built-in for key derivation...

So it seems quite feasible.  But I strongly suspect that direct use of
dm-crypt would be a better solution for these systems, which would
eliminate the need for cryptsetup entirely.

- Eric
