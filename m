Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793293834;
	b=S2l39Yhn2Pp0pN1i7Etj94h22ScBsSdr1ZyZI4vecs+vD9vX0wgCGrROBbcLWkd2w3Ln
	 VmTcKdREp0NDl1W8JdzwLKKeyMKapvbWT0LLMzK/zvthtL23bE+8T/aEg2l1pdOaXpvCC
	 y5HaLq/CZ/JHsWiD1MgjVRmSHwyZUyxwIYtX5L2iwWa3f6G3sX8mGuakBPvxfVWo4+VXC
	 wUfkjddyDGl/TGwzm9yjpuRi2FckDhMhyQZpWi5KxjT/j2zdb3cO1Z9KrC0WGBAsnwTzq
	 kQdGFzSe3IBjS3lSx6hhvrfwFM4VwMRKR/Tmo1ngDVMmSt8ikeDmFcw9COE8eeL9y/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793293834;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=9KomCOaSA+/T1xTuIFwMvLCBcQ7qcWxyP7y13U0/F7c=;
	b=YeLvwJODrvno5H6hcUAt7lw2K1KSESsBv+EgHMGrbqx7ECa8iwyzWiveIJisqajgxMFd
	 0jPuQvyzeR8I9naCRPnF5x/iRWgFIksBzlfB2QYL0s+fflL+U2S9WlmphmExFz2N+LZfG
	 FHLOzCxIesePGnhTPnAxsusxITCjEsndHYstcMdxOP/FbFlcOoTRPngurOfkJuQ+5cq8+
	 qqcLKz/rX21HbDqq3x/IiH1FWeckcPGcJ02mWgWSpZU9yq8OPejha256YfX9hxrx0IrMf
	 eo3RKseySioQcBFMTkPSp8o4n0NMUeq7yGZpfW8zBcdr54gdOxfLWciJU4F4RyV4X2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=knc1mCl6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF912606A31A
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=knc1mCl6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7BB1F01816;
	Thu, 29 Oct 2026 17:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793293833;
	bh=9KomCOaSA+/T1xTuIFwMvLCBcQ7qcWxyP7y13U0/F7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=knc1mCl64Od/xMRAuFOt80MJsRIWYB4juiYLrAW/vsNnRxOQ0IVZ6IRoIwu47lI7O
	 gGqw/icA7C6TB2ujPDN+/Pa9YQwJ94u01ft7hmCEnqd3+SjlgDQ+eKmIevcG09H36m
	 qqc354jiot/SZ6zAyYXekdZht+2swVDmp5ys0mIKjXDTkwiWfOf0tgI1DhgmRXMeqS
	 D40ZvUXAurzn6ijunoSCpvONezamV4YJKwhaJdJRCgIe2f5CBb7RC1TKCR5w3uLT5V
	 xpYnG8/O2miMkeCVzfKYdKTdKpefnVnoRllakPSjsTPUm7GcgqjXuz1w60ZiNvu2WH
	 hJxDRShDE4gyw==
Date: Thu, 29 Oct 2026 10:10:31 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] lib/crypto: powerpc/poly1305: Remove BROKEN
 implementation
Message-ID: <20261029171031.GC1862@quark>
References: <20261029063522.124421-1-ebiggers@kernel.org>
 <7c8500c2-4b59-40e2-a227-b488f1336fef@app.fastmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c8500c2-4b59-40e2-a227-b488f1336fef@app.fastmail.com>

On Thu, Oct 29, 2026 at 10:42:40AM +0100, Ard Biesheuvel wrote:
> On Thu, 29 Oct 2026, at 07:35, Eric Biggers wrote:
> > The PowerPC implementation of Poly1305 has been marked as BROKEN for
> > well over a year, since commit bc8169003b41 ("crypto: powerpc/poly1305 -
> > add depends on BROKEN for now").  So, it's not being built or used.
> >
> > The justification for marking it BROKEN was that it didn't work in
> > softirq context.  That still fully applies.
> >
> > However, it turns out the assembly file actually also contains logic
> > bugs that make it compute incorrect Poly1305 values in some cases.  This
> > is shown by it failing the test case test_poly1305_split_update_carry
> > (if "depends on BROKEN" is removed).  The cause of that appears to be a
> > lost carry bit in Carry_reduction.  However, there also appears to be a
> > bug in do_final_update where it incorrectly assumes v6 is fully reduced.
> >
> > In addition, poly1305_emit_64 contains a secret-dependent branch.
> >
> > Let's just drop this code.  A fixed version can be reconsidered later.
> >
> > Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> > ---
> >  lib/crypto/Kconfig                     |    6 +-
> >  lib/crypto/Makefile                    |    2 -
> >  lib/crypto/powerpc/poly1305-p10le_64.S | 1076 ------------------------
> >  lib/crypto/powerpc/poly1305.h          |   76 --
> >  4 files changed, 1 insertion(+), 1159 deletions(-)
> >  delete mode 100644 lib/crypto/powerpc/poly1305-p10le_64.S
> >  delete mode 100644 lib/crypto/powerpc/poly1305.h
> >
> 
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
