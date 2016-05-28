From: Aaron Zauner <azet@azet.org>
Subject: Re: AES-NI: slower than aes-generic?
Date: Sat, 28 May 2016 07:28:25 +0700
Message-ID: <FEA29793-B67A-4C0D-A904-909A62BB3E65@azet.org>
References: <1567400.ZMFoPuCv2K@tauon.atsec.com> <CACXcFmnFn_BDv_xLra-gfSTsOP-diTwtvU4_TndLAv+WuXG4DQ@mail.gmail.com> <4972668.UQ1QRNriDb@positron.chronox.de>
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Content-Type: multipart/signed; boundary="Apple-Mail=_46181A95-5A30-4C0E-8374-73A12AEB1990"; protocol="application/pgp-signature"; micalg=pgp-sha512
Cc: Sandy Harris <sandyinchina@gmail.com>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	linux-crypto@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:33708 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055AbcE1A2h (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 May 2016 20:28:37 -0400
Received: by mail-pa0-f65.google.com with SMTP id f8so14287663pag.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 May 2016 17:28:36 -0700 (PDT)
In-Reply-To: <4972668.UQ1QRNriDb@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--Apple-Mail=_46181A95-5A30-4C0E-8374-73A12AEB1990
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Heya,

> On 27 May 2016, at 01:49, Stephan Mueller <smueller@chronox.de> wrote:
> Then, the use of the DRBG offers users to choose between a Hash/HMAC =
and CTR
> implementation to suit their needs. The DRBG code is agnostic of the
> underlying cipher. So, you could even use Blowfish instead of AES or =
whirlpool
> instead of SHA -- these changes are just one entry in drbg_cores[] =
away
> without any code change.

That's a really nice change and something I've been thinking about for a =
couple of months as well. Then I came across tytso's ChaCha patches to =
urandom and was thinking ISA dependent switches between ciphers would =
make sense, i.e. you get AESNI performance when there's support.

> Finally, the LRNG code is completely agnostic of the underlying =
deterministic
> RNG. You only need a replacement of two small functions to invoke the =
seeding
> and generate operation of a DRNG. So, if one wants a Chacha20, he can =
have it.
> If one wants X9.31, he can have it. See section 2.8.3 [1] -- note, =
that DRNG
> does not even need to be a kernel crypto API registered =
implementation.

It's valid criticism that the number of algorithms should be limited. =
Algorithmic agility is an issue and has caused many real-world security =
problems in protocols liberally granting crypto primitives to be chosen =
by the user isn't a good idea. We should think about algorithms that =
make sense. E.g. TLS 1.3 and HTTP/2 have been moving into this =
direction. TLS 1.3 will only allow a couple off cipher-suites as opposed =
to combinatorial explosion with previous iterations of the protocol.

I'd suggest sticking to AES-CTR and ChaCha20 for DRNG designs. That =
should fit almost all platforms with great performance, keep code-base =
small etc.

There's now heavily optimised assembly in OpenSSL for ChaCha20 if you =
want to take a look: =
https://github.com/openssl/openssl/tree/master/crypto/chacha/asm
But as mentioned in the ChaCha/urandom thread: architecture specific =
optimisation may be painful and error-prone.

> Bottom line, I want to give folks a full flexibility. That said, the =
LRNG code
> is more of a logic to collect entropy and maintain two DRNG types =
which are
> seeded according to a defined schedule than it is a tightly integrated =
RNG.
>=20
> Also, I am not so sure that simply taking a cipher, sprinkling some
> backtracking logic on it implies you have a good DRNG. As of now, I =
have not
> seen assessments from others for the Chacha20 DRNG approach. I =
personally
> would think that the Chacha20 approach from Ted is good. Yet others =
may have a
> more conservative approach of using a DRNG implementation that has =
been
> reviewed by a lot of folks.
>=20
> [1] http://www.chronox.de/lrng/doc/lrng.pdf

Currently reading that paper, it seems like a solid approach.

I don't like the approach that user-space programs may modify entropy. =
It's a myth that `haveged` etc. provide more security, and EGDs have =
been barely audited, usually written as academic work and have been =
completely unmaintained. I regularly end up in randomness[sic!] =
discussions with core language maintainers [0] [1] - they seem to have =
little understanding of what's going on in the kernel and either use =
/dev/random as a seed or a Userspace RNG (most of which aren't =
particularly safe to begin with -- OpenSSL is not fork safe [2] [3], a =
recent paper found weaknesses in the OpenSSL RNG at low entropy state =
leaking secrets [4] et cetera). This seems to be mostly the case because =
of the infamous `random(4)` man-page. With end-users (protocol =
implementers, core language designers,..) always pointing to upstream, =
which - of course - is the Linux kernel.

I can't really tell from the paper if /dev/random would still be =
blocking in some cases? If so that's unfortunate.

Thanks for your work on this,
Aaron

[0] https://bugs.ruby-lang.org/issues/9569
[1] https://github.com/nodejs/node/issues/5798
[2] =
https://emboss.github.io/blog/2013/08/21/openssl-prng-is-not-really-fork-s=
afe/
[3] https://wiki.openssl.org/index.php/Random_fork-safety
[4] https://eprint.iacr.org/2016/367.pdf

--Apple-Mail=_46181A95-5A30-4C0E-8374-73A12AEB1990
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCgAGBQJXSOYrAAoJEOTbZJL9ubXVdw0P/0krtPrL+v+wkyRi3kNZGNhf
nYT5P4UwG1TBMiN2Tlc7A/HCY24l0uDsqFVTWWK2dBOP089r4oQy/7wyUQQt9raH
tSkIYjaObowqv2iO/eqJw/MoQMGOpjlGva0ZvpVscUjeMFq+G0W/jY+UoLJFEkgP
IP1KjJlZ8nGwQuSBonGXymCFBFvHc+TT6Lnw1m48U1f44E0L89Eh+ZWCjwf9xWeT
Dso7MY/osNz+DW+cJ0Mb86/nhRfy8uTVtcIy31VHSbvM+Il7NtQNspH8aWxa0eMW
4w7IOE7vDspsXxYrbv9i2TE+LJDukyRaal7+2b6hVceGmr5h6S6eJroVdfmWYIWb
LLCU+rnD44AudgB0XuMGGSun0GYnxPXbpozdXlYeEJD+E7T28vtXUDz5PUWIe7Js
AMtF9easduYOguFf6ZD4vzm8jS0lSrdOQ30O2UyG4zXIeSKgVq52fh4vRjgW2iV2
NOqTBH1ht4w2Ex3D2xca5hjNAPYJUuKemcoxW1aq6HdrWaSRh5K8wW3Gn0oHHoKB
zmVi6CCzOOs4oBO06ZsPb293xmtnpZitsGEFaq0kzTqlvIH+HSAIQNHlcgTEFRrM
5Uoxy3LPXhEinPApeSvdcgwtySK+sfeKiEV/kVspQZT1+P2IL+Ti0pccyNQNiSWl
+/Uc1ZfkTcPNbj24sJNH
=QxiD
-----END PGP SIGNATURE-----

--Apple-Mail=_46181A95-5A30-4C0E-8374-73A12AEB1990--
