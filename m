From: mancha <mancha1@zoho.com>
Subject: Re: [BUG/PATCH] kernel RNG and its secrets
Date: Wed, 18 Mar 2015 12:58:34 +0000
Message-ID: <20150318125834.GB12923@zoho.com>
References: <20150318095345.GA12923@zoho.com>
 <1426675809.2143223.241946097.20888470@webmail.messagingengine.com>
 <550959EB.4000304@iogearbox.net>
 <6407649.tbmT00FeL6@tauon>
 <1426680132.2161424.241974537.13E2EF65@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6sX45UoQRIJXqkqR"
Cc: Stephan Mueller <smueller@chronox.de>,
	Daniel Borkmann <daniel@iogearbox.net>, tytso@mit.edu,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, dborkman@redhat.com
To: Hannes Frederic Sowa <hannes@stressinduktion.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sender1.zohomail.com ([74.201.84.156]:39666 "EHLO
	sender1.zohomail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755603AbbCRNCb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Mar 2015 09:02:31 -0400
Content-Disposition: inline
In-Reply-To: <1426680132.2161424.241974537.13E2EF65@webmail.messagingengine.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2015 at 01:02:12PM +0100, Hannes Frederic Sowa wrote:
> On Wed, Mar 18, 2015, at 12:09, Stephan Mueller wrote:
> > Am Mittwoch, 18. M=C3=A4rz 2015, 11:56:43 schrieb Daniel Borkmann:
> > >On 03/18/2015 11:50 AM, Hannes Frederic Sowa wrote:
> > >> On Wed, Mar 18, 2015, at 10:53, mancha wrote:
> > >>> Hi.
> > >>>=20
> > >>> The kernel RNG introduced memzero_explicit in d4c5efdb9777 to
> > >>> protect
> > >>>=20
> > >>> memory cleansing against things like dead store optimization:
> > >>>     void memzero_explicit(void *s, size_t count)
> > >>>     {
> > >>>    =20
> > >>>             memset(s, 0, count);
> > >>>             OPTIMIZER_HIDE_VAR(s);
> > >>>    =20
> > >>>     }
> > >>>=20
> > >>> OPTIMIZER_HIDE_VAR, introduced in fe8c8a126806 to protect
> > >>> crypto_memneq>>=20
> > >>> against timing analysis, is defined when using gcc as:
> > >>>     #define OPTIMIZER_HIDE_VAR(var) __asm__ ("" : "=3Dr" (var) : "0"
> > >>>     (var))
> > >>>=20
> > >>> My tests with gcc 4.8.2 on x86 find it insufficient to prevent gcc
> > >>> from optimizing out memset (i.e. secrets remain in memory).
> > >>>=20
> > >>> Two things that do work:
> > >>>     __asm__ __volatile__ ("" : "=3Dr" (var) : "0" (var))
> > >>=20
> > >> You are correct, volatile signature should be added to
> > >> OPTIMIZER_HIDE_VAR. Because we use an output variable "=3Dr", gcc is
> > >> allowed to check if it is needed and may remove the asm statement.
> > >> Another option would be to just use var as an input variable - asm
> > >> blocks without output variables are always considered being volatile
> > >> by gcc.
> > >>=20
> > >> Can you send a patch?
> > >>=20
> > >> I don't think it is security critical, as Daniel pointed out, the
> > >> call
> > >> will happen because the function is an external call to the crypto
> > >> functions, thus the compiler has to flush memory on return.
> > >
> > >Just had a look.
> > >
> > >$ gdb vmlinux
> > >(gdb) disassemble memzero_explicit
> > >Dump of assembler code for function memzero_explicit:
> > >    0xffffffff813a18b0 <+0>:	push   %rbp
> > >    0xffffffff813a18b1 <+1>:	mov    %rsi,%rdx
> > >    0xffffffff813a18b4 <+4>:	xor    %esi,%esi
> > >    0xffffffff813a18b6 <+6>:	mov    %rsp,%rbp
> > >    0xffffffff813a18b9 <+9>:	callq  0xffffffff813a7120 <memset>
> > >    0xffffffff813a18be <+14>:	pop    %rbp
> > >    0xffffffff813a18bf <+15>:	retq
> > >End of assembler dump.
> > >
> > >(gdb) disassemble extract_entropy
> > >[...]
> > >    0xffffffff814a5000 <+304>:	sub    %r15,%rbx
> > >    0xffffffff814a5003 <+307>:	jne    0xffffffff814a4f80
> > ><extract_entropy+176> 0xffffffff814a5009 <+313>:	mov    %r12,%rdi
> > >    0xffffffff814a500c <+316>:	mov    $0xa,%esi
> > >    0xffffffff814a5011 <+321>:	callq  0xffffffff813a18b0
> > ><memzero_explicit> 0xffffffff814a5016 <+326>:	mov    -0x48(%rbp),%rax
> > >[...]
> > >
> > >I would be fine with __volatile__.
> >=20
> > Are we sure that simply adding a __volatile__ works in any case? I just=
=20
> > did a test with a simple user space app:
> >=20
> > static inline void memset_secure(void *s, int c, size_t n)
> > {
> >         memset(s, c, n);
> >         //__asm__ __volatile__("": : :"memory");
> >         __asm__ __volatile__("" : "=3Dr" (s) : "0" (s));
> > }
> >=20
>=20
> Good point, thanks!
>=20
> Of course an input or output of s does not force the memory pointed to
> by s being flushed.
>=20
>=20
> My proposal would be to add a
>=20
> #define OPTIMIZER_HIDE_MEM(ptr, len) __asm__ __volatile__ ("" : : "m"(
> ({ struct { u8 b[len]; } *p =3D (void *)ptr ; *p; }) )
>=20
> and use this in the code function.
>=20
> This is documented in gcc manual 6.43.2.5.
>=20
> Bye,
> Hannes
>=20

Hi all.

Any reason to not use __asm__ __volatile__("": : :"memory") [aka=20
barrier()]?

Or maybe __asm__ __volatile__("": :"r"(ptr) :"memory").

Cheers.

--mancha

--6sX45UoQRIJXqkqR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJVCXZ6AAoJEB4VYy8JqhaDSSoP+QEx25jxfw2uOXeW5Mi4wlES
WFoiXB3PzQ8XXh5xnJR/TZo8XkMJoonlKgnJuZ1cfgoOIuOucRxwAa3T9bmU+Udi
QZuUhnpoMYa8lKbyv4Dy7VX0ChrNQ5P1X8KlpmokM6OPZ3Na4HNo/TwiFcl+Onb6
ZICEPmUVR3Xr5s8mWaE6G7T01l+EEBXeL2IaWgnk1OQ10ZX9VyBCmPyt4bpGSTe1
g4kOE5vslycTGW8oiERnxcyrFWVxPi+5nL6hN4dbM0xcy2GPIxnUnW6k3hAia13A
wBhtPOWMSkQHj9qmZujwmlP5m0hexjxyRyMZrWeHIv4aiknNAkLj66748sJ1bmDF
/Y85pznIzX9ZVpRxXfmBvA3ebZVMPan5JFxCPV8Lm7Hl0EnznuYCbchldUkRQTlF
EyCb9+otzHFTzinG8NTsRg1FxFzrBgTOPaLpmFYYb0u2I/IVhNcYbEwVNDymI6Om
iZrkZWZjgWtjp5P83cKfAHJ3a0Jbg5t2MMK6lNFXh4Xtfo44U88MlniEJ+vxsw/2
mCQc5Qud+qvB14DW4M7Y8/etXuw6h+/+JQeqPLnH0clsoZT5aX6G2weBOE9QHocu
gZQYon3XoaULcx1OQm0INjxmMjn2J+/DGO1hp5uQGMxDL1YhcvyjIlTo5IAxkmBV
x43PrIpYNyNApFH3CUVi
=Vzp2
-----END PGP SIGNATURE-----

--6sX45UoQRIJXqkqR--
