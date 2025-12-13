Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C70B4C92
	for <linux-crypto@vger.kernel.org>; Sat, 13 Dec 2025 20:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765656296; cv=none; b=HUQerpMIQMCpem0+aODtaMTjXbj2fo+GT7Y4IeeTRFiscdikaoQirNZdqE/qydBUYvFphsTnPQ+koStpYWGnNyl60MlvjRfDZasRJ737xN1NTmRgffScFwEKRGJSCnuBMbtqzsBQJe2wSZVXtfQ+kOBXxYZ6irH2Segga8kDBew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765656296; c=relaxed/simple;
	bh=nqpAMDp9L8z/K4KeuAFtzqElLYOoxABXdQX9ssfD8x8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aCTLzdwuJZpkQqN8d/I8MoL82HFyZV/0euTd1DxyARW8NXoO3YRNTZrMYXgpbLr1XYzZbndtFVSxnOwDCKa02zVZkGo/272+ad3I4rHh5kR/n8/lVpbKPGREQaIQSH/R9q1tBEk+19LuPw+8HPYQeM04NBuxiMAPkm5vBDGSaK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C963iVhp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C963iVhp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50148C4CEF7;
	Sat, 13 Dec 2025 20:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765656296;
	bh=nqpAMDp9L8z/K4KeuAFtzqElLYOoxABXdQX9ssfD8x8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C963iVhp7aD0MU0+3dz5dGR8rD5xjlqX4F/yQCBRGEt22GY+wgAyvza23v/LSlH//
	 ETbhvWOKirAdKeq8aPzd1AqhjOZzAI7izm6klWgq787HxAAZ2iLd9/f9VFHKvfeJoP
	 zTs4oxIvdyjHlzsBBQ6HkEbR0OdInQe0A/P5apra1h0HxzNd5YszRJDtLy9Ox+EC1J
	 8dSraFkzHRYVcNURbJ2tzNFAjtEMcZIph1MoYYfMDDGcK1uSqbAEG16XOo2oYHw1DG
	 8M7MW8Bmtvq32evECWRm92JCupyHQFwRQs1nUKLZFaNP/HVVvi7sPAUbOfXCvbVbdo
	 EjZw83bOvisnQ==
Date: Sat, 13 Dec 2025 21:04:51 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Daniel Thompson <danielt@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de, 
	ebiggers@kernel.org, kees@kernel.org, linux-crypto@vger.kernel.org, 
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <cdd6s2sdtt3zltqh4rwmq5x6hmbagmulbbzcqw7oizh7x6c3h4@tymlaio7fmxy>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <aTByNvAYRhZI07cJ@aspen.lan>
 <o3yq4m3ihmynvcrrp6u2xshngxtgso2cqrdhfazyxxm7udvs46@wzyl6qu4lmqt>
 <aTLlPhIAbQZqOVjb@aspen.lan>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vluwsu5mlblujz3p"
Content-Disposition: inline
In-Reply-To: <aTLlPhIAbQZqOVjb@aspen.lan>


--vluwsu5mlblujz3p
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Daniel Thompson <danielt@kernel.org>
Cc: jason@zx2c4.com, ardb+git@google.com, ardb@kernel.org, arnd@arndb.de, 
	ebiggers@kernel.org, kees@kernel.org, linux-crypto@vger.kernel.org, 
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH] libcrypto/chachapoly: Use strict typing for fixed
 size array arguments
Message-ID: <cdd6s2sdtt3zltqh4rwmq5x6hmbagmulbbzcqw7oizh7x6c3h4@tymlaio7fmxy>
References: <aRi6zrH3sGyTZcmf@zx2c4.com>
 <sjyh6hnw54pwzwyzegoaq3lu7g7hnvneq3bkc5cvno7chnfkv5@lz4dwbsv3zsf>
 <aTByNvAYRhZI07cJ@aspen.lan>
 <o3yq4m3ihmynvcrrp6u2xshngxtgso2cqrdhfazyxxm7udvs46@wzyl6qu4lmqt>
 <aTLlPhIAbQZqOVjb@aspen.lan>
MIME-Version: 1.0
In-Reply-To: <aTLlPhIAbQZqOVjb@aspen.lan>

Hi Daniel,

On Fri, Dec 05, 2025 at 01:59:26PM +0000, Daniel Thompson wrote:
> On Wed, Dec 03, 2025 at 07:01:39PM +0100, Alejandro Colomar wrote:
> > Hi Daniel,
> >
> > On Wed, Dec 03, 2025 at 05:24:06PM +0000, Daniel Thompson wrote:
> > [...]
> > > > Be careful about [static n].  It has implications that you're proba=
bly
> > > > not aware of.  Also, it doesn't have some implications you might ex=
pect
> > > > from it.
> > > >
> > > > -  [static n] on an argument implies __attribute__((nonnull())) on =
that
> > > >    argument; it means that the argument can't be null.  You may wan=
t to
> > > >    make sure you're using -fno-delete-null-pointer-checks if you use
> > > >    [static n].
> > > >
> > > > -  [static n] implies that n>0.  You should make sure that n>0, or =
UB
> > > >    would be triggered.
> > > >
> > > > -  [n] means two promises traditionally:
> > > >    -  The caller will provide at least n elements.
> > > >    -  The callee will use no more than n elements.
> > > >    However, [static n] only carries the first promise.  According to
> > > >    ISO C, the callee may access elements beyond that.
> > >
> > > This description implies that [n] carries promises that [static n] do=
es
> > > not. However you are comparing the "traditional" behaviour (that is
> > > well beyond the scope of the standard) on one side with ISO C behavio=
ur
> > > on the other.
> > >
> > > It makes sense to compare ISO C behavior for [n] (where neither of the
> > > above promises applies) with ISO C behaviour for [static n]...
> >
> > Clang seems to implement the ISO C behavior, so in retrospective, the
> > comparison I did seems appropriate.  By moving from the GCC/traditional
> > behavior to the Clang/ISO one, a project would be lowering quality.
>=20
> I'm still rather dubious about confusing the optimization opportunities
> afforded by the ISO C standard with the diagnostic messages that both
> gcc and clang can produce (and are beyond the scope of the standard).

I think the ISO C standard should not support any syntax that allows
optimizations without diagnostics.  Those are huge footguns.

We already have experience in GCC with __attribute__((__nonnull__())).
A better would look like 'const', and should diagnose any violations at
compile time.

Then, ISO C added 'restrict', which is another case of optimizations
without diagnostics.  See also:
<https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D112833>.

And [static n] is essentially the same kind of bad stuff.  In fact, it
implies __attribute__((__nonnull__())), so that should tell enough.

At least, the GCC attribute is not part of the type system.  It's bad,
but it doesn't claim to be good.  But having [static n] as if it were
part of the type system, but then using it for optimizations, that's
just evil.

> However, let's agree to disagree on that, since it doesn't change the
> outcome: it *is* useful to compare the behaviour of the two compilers.

Okay.

> > Plus, there's still the issues about n>0 and nonnullness.
> >
> > The only reason why it makes some sense to use [static n] in the kernel
> > is because it's moving from no-rules to some rules.  But the real
> > problem here is that the kernel needs to turn GCC's -Wstringop-overflow
> > off, and that's what the kernel do some effort to re-enable.
> >
> > If you show a minimal reproducer of what the problem is with
> > -Wstringop-overflow, I may be able to help with that.
>=20
> I'm not 100% caught up on the history but I think this was the issue
> that prompted -Wstringop-overflow to be disabled by default (and
> includes a minimal reproducer):
> https://gcc.gnu.org/bugzilla/show_bug.cgi?id=3D113214

Ahhh, sanitizers.  Yeah, sanitizers are usually bad for diagnostics.

> > In general, [static n] is bogus and never to be used, except temporarily
> > while other issues get fixed, like in this case.
> >
> > > >    GCC, as a quality implementation, enforces the second promise to=
o,
> > > >    but this is not portable; you should make sure that all supported
> > > >    compilers enforces that as an extension.
> > >
> > > ... and equally it makes sense to compare the gcc/clang warnings for
> > > [n] versus [static n] as recommended here.
> >
> > Clang is really bad at both [n] and [static n].  If you need to rely on
> > clang for array bounds, you're screwed.
>=20
> What do you mean by clang is really bad at [static n]?

GCC gives more diagnostics for [static n] than Clang.

> Most of this
> thread is based on the observation that clang gives *useful*
> diagnostics for [static n] that are not issued for [n].

Clang is even worse at [n] than at [static n], but it's bad at both.

> > > However it should not be motivated by [static n] carrying few promises
> > > than [n], especially given gcc/clang's enforcement of the promises is
> > > a best effort static check that won't cover all cases anyway.
> >
> > GCC is quite good at those diagnostics; it might not cover all cases,
> > but that's better than what ISO or Clang will promise.
>=20
> gcc certainly can generate warnings we don't get with clang, so it's
> just a question of whether the false positives are enough to stop it
> from being quite good!
>=20
> I was curious is anything has changed in the last two years so I
> compiled v6.18 allmodconfig with -Wstringop-overflow (without the
> thread sanitizer which causes the known problem mentioned above
> right the way up to gcc-15.2). I ran check across five architectures
> (arm64, arm, riscv, s390 & x86) since we know there have been
> architecture dependant differences. Not all the builds have gone
> through but unless there are regressions in newer compilers then
> I've only seen two -Wstringop-overflow warnings.
>=20
> First is a clear false positive (of the "if something impossible
> happens then something bad might happen" variety) which, happily, is
> only triggered on gcc-12/aarch64 and appears to be fixed from gcc-13
> onward.
>=20
> Second isn't a kernel bug but it's arguably not a false positive
> either. I think it could be reasonably fixed with source code changes.
> See https://elixir.bootlin.com/linux/v6.18/source/net/sctp/auth.c#L645
>=20
> Overall I'll look a little deeper to try and see if there are any
> other ways to break -Werror builds with gcc-13 or later.

Thanks for researching this!  That would be very useful!  Please CC me
if you write any patches about this; I'm interested.


Have a lovely night!
Alex

>=20
>=20
> Daniel.

--=20
<https://www.alejandro-colomar.es>

--vluwsu5mlblujz3p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmk9xt4ACgkQ64mZXMKQ
wqnxyw//df9rQIsfCgDjKIsS2KoQWJqC5UNdOAv7trPVyfipwsMhUvC3pk+/kZiv
eOCiE0PE3RMZC1Wd7KU/Wj0j8hX5EidQ+BGky/aR6qa+dGn74XYk7rFUWmbhvaIv
gTGUIS0ehYBH/wqQAUPOtoDJztt0K3hKuZyX4+93I9O6I7xNJbDAASnfxtunmbJa
/VkSNhp7yReLTGXeBrFSWc/aJVRJpUVoVYBV+b7e0Jvaz9sXVvmyf3zvUVQq4BAV
gGbZ0Jh/iWKec2pACc8twDKM7VpBhBtHVMs5Kp/yP7qHYl8QEw+NsbZ8nlQAA5B0
/+XncoNxieov3RluyJrarwcrT7TYk+upfA0h475WIyjuiXCo/EUspSRmeNZb1V27
20X86I0RRhwBmclGWACgE/fLHXMkTCMWs8SeqiRqkpYrEETfJkFNHjMm1DY3Dhp5
alO37duGVUK6p7VlarxgbL4w7d5V6fzjE8d2Q8XvHcSbsRACn3ZE7jizPV3RQO6+
7hv0iA/PuVJGwaTVa4+SIkayJqzqH/4Vw6ZveJbL9TF5beY5NR2F/MFeqMSqBNX0
A9kdxiYTW5H4B3SFRmq6rJ5IRI/gCSkZ0ZTiQ9hFPbiFMmHC/RAP8e4NTINihHR1
DG8Mh8jFBfWiPi1nX6W555y5ggsScAcLCF9onSpsBlvgDz9gZek=
=imYF
-----END PGP SIGNATURE-----

--vluwsu5mlblujz3p--
