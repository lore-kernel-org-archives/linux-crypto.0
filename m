From: Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] hwrng: core - Allow for multiple simultaneous active hwrng devices
Date: Tue, 09 Aug 2016 16:26:30 -0700
Message-ID: <86bn11r0bd.fsf@hiro.keithp.com>
References: <1469477255-26824-1-git-send-email-keithp@keithp.com> <20160809095058.GA6618@gondor.apana.org.au> <20160809165710.GC2013@io.lakedaemon.net> <20160809201846.GA4684@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160809201846.GA4684@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Henrique de Moraes Holschuh <hmh@hmh.eng.br> writes:

> IMHO, this is mightly annoying to use from inside a rngd-like utility in
> a race-free, safe way.  It looks to me that ioctl() would be a much
> better interface for everything but the "enabled" functionality (which
> should be reported to the rngd-like utility as open() on the real device
> failing with, e.g., ENXIO, when that source is disabled).

What information does an rngd-like program actually want? All I can
think that it would need is the stream of random data. I guess some
estimate of the entropy available would be nice, but surely it would
want to verify that in any case.

=2D-=20
=2Dkeith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBV6pmptsiGmkAAAARAQigEBAAlwu+hi/TazmjHOhBShBwse/OCzlOs9lZ
xRFw9l57XFgEQWrAQrb6t9no/Nvnw9zH16nDjLfw71k48HLG1hqLzPBBmCupsMF8
g/kJoWD3qBufhtgbBF2zEiUvgJ7bjv+q56i/US1qWltwNVUV/YWiC7uTH3qTSL2u
KfutwRhnwXNNHalZtA3PtwQP8SSjxRROsY23+nSCqg8OR5F11+nokgQ0bzQa1aSH
iRijIG7MvQUDB7Sjr65S+dh24X9tG3m1FdpHm1RiYgn/iyRpElLa3a2Tla8BVP3g
Awb6WJ9rw/hUKqBzQBH7LQQARNXRaD2XBLK2G5yr+njUqVHmm12zLXn+vyO6KU8g
5VYVwRMe1wI7vyf/p4A7bpWG3RzmLTSvGSe3NV31pj+6GhRIETdfhIFYeQQGs6Wr
8nPCsmBIeaH3eEv1vlKva6XZlmjUM9KpjaDnc+G8Pt41ugIbG9x09pxfYltWCQrW
o7Vq83vrV7fw/+WFL0yMRveu4kSrOBVIJJq5GiV+nBQB5ouRosyNRKME/+8H2ryU
cprXgRO2k9D1HARGNeuePBrHJjhijOrYIGdKuygORyiHlu0MrSH90SJZz8kOR0QK
0g8hK2ax+ixQOm6fNtxqU/XiU+Bqc4Zeyube85xjdUUd6esPQ8WSABC+jmR3UbH+
bEtVTMtwcGQ=
=MoKY
-----END PGP SIGNATURE-----
--=-=-=--
