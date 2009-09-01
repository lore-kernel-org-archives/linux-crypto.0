From: Jonas Meurer <jonas@freesources.org>
Subject: Re: [pkg-cryptsetup-devel] Bug#541835: crypto configuration /
 dependencies broken
Date: Tue, 1 Sep 2009 02:51:20 +0200
Message-ID: <20090901005120.GB22049@resivo.wgnet.de>
References: <20090825195852.1dfacb6c.celejar@gmail.com>
 <20090827095516.6817be1e.randy.dunlap@oracle.com>
 <20090827183500.GC24973@resivo.wgnet.de>
 <20090827123401.86cd4319.randy.dunlap@oracle.com>
 <20090828080056.GA3204@Chamillionaire.breakpoint.cc>
 <20090830153722.GA28497@Chamillionaire.breakpoint.cc>
 <20090831155200.GD7678@resivo.wgnet.de>
 <20090831211639.GA4675@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Cc: Celejar <celejar@gmail.com>,
	Randy Dunlap <randy.dunlap@oracle.com>, 541835@bugs.debian.org,
	lkml <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, control@bugs.debian.org
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx01.freesources.org ([80.237.252.149]:33985 "EHLO
	mail01.freesources.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbZIAAv2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 31 Aug 2009 20:51:28 -0400
Content-Disposition: inline
In-Reply-To: <20090831211639.GA4675@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

reopen 541835
thanks

hey,

On 31/08/2009 Sebastian Andrzej Siewior wrote:
> * Jonas Meurer | 2009-08-31 17:52:00 [+0200]:
>=20
> >> Could someone please look at initramfs to figure out why those three
> >> modules are not copied in this reduced setup?
> >
> >the reason is simply that no other crypto modules define depends on the
> >listed ones:
> Well yes, but aes cbc is placed in the new initrd. I took a look, read
> below.

as you already discovered, that's because the initramfs hook script for
cryptroot adds some crypto modules manually in debian. currently these
are dm-mod, dm-crypt, cbc, aes, sha256 and all the modules they depend
on.

> >so the following depends should be added/changed:
> >
> >- chainiv should depend o 'krng' instead of 'rng' at least
>    rng is a subsubsystem within crypto. krng is one implementation which
>    provides random numbers. So does ansi_cprng. Another implementation
>    may come.
>
> >- maybe cipher modules like aes,serpent,... should depend on 'cryptomgr'
> >  instead of 'crypto_algapi'
>    This isn't possible without dummy variables because they don't need
>    each other in first place. We could move code but crypto_algapi can
>    live without cryptomgr. However cryptomgr doesn't make sense without
>    crypto_algapi.
>    Lets say you have a VIA CPU which provides cbc(aes) in HW. So you
>    don't need cryptomgr because cbc(aes) is allready available. You need
>    aes_generic but that's another story :)
>=20
> >- crypto_algapi should depend on chainiv
>    chainiv is one possible implementation eseqiv is another one. The
>    later is used on async-hw and in 2.6.32+ on SMP afaik.
>   =20
> >these changes are pure guesses, i don't know the details. but at least
> >additional depends need to be defined for crypto modules, don't you
> >think so?
>
> We have them in Kconfig. All required modules are built and are
> available. However the things aren't that easy. The crypto subsystem is
> very flexible and undocumented and this is the problem here I think.

ok, i see the point that it's not enough to simply add some additional
dependencies in order to fix the problem. seems like an easy solution
doesn't exist.

> So this brings me to the following question: Why are you so picky and you
> don't take all of the modules? sh 2.6.30-1 on various debian archs:
> du -sh              x86_64  i386  powerpc  s390x   mips(r5k-ip32)
> crypto              720K    636K  1.1M     804K    968K
> arch/<arch>/crypto  72K     36K   0        92K     0
> driver/crypto       32K     60K   60K      0       52K
> Total               824K    732K  1.2M     896K    1020
>=20
> So all modules together have an average footprint of 941.0K. This isn't
> that much. There is no size limit on initrd unless you are on a system
> with has 32MiB or something like that :)
> With *all* those crypto modules which are selected and built you are
> able to cover all corner cases.
> I took a look at hooks/cryptroot and really and only a few modules are
> included. Right now you don't include HW cipher e.g. VIA's padlock or
> AMD's geode. If you don't load those module while openning the root
> partition (the first request), then the module is never loaded / used.
> The other unhandled case are non default ciphers like xts(aes) which one
> might use. The brand new aes implementation aesni-intel is also not be
> considered. Most modules have _generic in their name if there is
> another implementation available and <name>-arch if there is an assembly
> variant but I would prefer that this does not become part of an ABI
> where one can rely on.
>=20
> Would it be okay for you to change the way the crypto modules are picked
> and include the full set?

i don't like the idea to add _all_ crypto modules into the initramfs per
default. the size of crypto and arch/<arch>/crypto will keep on growing
for kernels which do have ship all available modules for ciphers and
implementations. i think that the initramfs should be a _minimal_
system, and detecting the required crypto modules should be possible.

alternative crypto cipher and blockcipher modules are already detected
if required, as information about these are available from the cryptroot
configuration (either luks header or cmdline options given to cryptsetup).

i added cryptomgr, chainiv and krng to the list of required modules in
/usr/share/initramfs-tools/hooks/cryptroot for now.

still i see the point that this solution has it's drawbacks. modules for
crypto hardware and cipher implementations not following the convention to
call modules <cipher>_generic and <cipher>-alias aren't detected by the
current system.

i guess the best solution would be to improve the module dependency
system. cipher meta-modules like 'aes' should depend on all available
implementations. same for ivciphers, hashs, rng implementations etc.

what do you think about it?

greetings,
 jonas

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqccAgACgkQd6lUs+JfIQJSEgCeLPRdmEUQo4lJHkAieVFAOCeW
SKYAn0qMKE0qBjwvWaDkdKC3MaGHrTO8
=5xaE
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
