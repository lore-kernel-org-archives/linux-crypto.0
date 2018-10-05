From: "D. J. Bernstein" <djb@cr.yp.to>
Subject: Re: [PATCH net-next v6 19/23] zinc: Curve25519 ARM implementation
Date: 5 Oct 2018 15:05:38 -0000
Message-ID: <20181005150538.17006.qmail@cr.yp.to>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180925145622.29959-20-Jason@zx2c4.com>
 <CAKv+Gu9FLDRLxHReKcveZYHNYerR5Y2pZd9gn-hWrU0jb2KgfA@mail.gmail.com>
 <CAHmME9rp0Fi5ObK5oi8FHj1_nK5hP4T2Bq7_dAmzq4OQ0mp0uw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Peter Schwabe <peter@cryptojedi.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

For the in-order ARM Cortex-A8 (the target for this code), adjacent
multiply-add instructions forward summands quickly. A simple in-order
dot-product computation has no latency problems, while interleaving
computations, as suggested in this thread, creates problems. Also, on
this microarchitecture, occasional ARM instructions run in parallel with
NEON, so trying to manually eliminate ARM instructions through global
pointer tracking wouldn't gain speed; it would simply create unnecessary
code-maintenance problems.

See https://cr.yp.to/papers.html#neoncrypto for analysis of the
performance of---and remaining bottlenecks in---this code. Further
speedups should be possible on this microarchitecture, but, for anyone
interested in this, I recommend focusing on building a cycle-accurate
simulator (e.g., fixing inaccuracies in the Sobole simulator) first.

Of course, there are other ARM microarchitectures, and there are many
cases where different microarchitectures prefer different optimizations.
The kernel already has boot-time benchmarks for different optimizations
for raid6, and should do the same for crypto code, so that implementors
can focus on each microarchitecture separately rather than living in the
barbaric world of having to choose which CPUs to favor.

---Dan

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbt33CAAoJELDADU47DlRZPQwP/RX2uAhuaumOVvp9njd8n0zY
92cmL/mUx10TUsw/u76ryVjvdDkRd/8BAOtNQ5dYqLReiNcMqCX7keWe7F9myXWO
/LsobUdU28F4Q2iP0a7TwZIzKyxwQzHUnHsAl0tydsWoX0Nb2bs8gbpkf4AJ4BWr
41WDxiynGZezl7FUcXA0RgdxDMdFZxYXSw6wRDUscFs7MfOaDO9nvhNYRWVn+lNZ
DDnTCO3YPLc2qe5uPcH/CVOj+CIBVOd9uzO7ggmBqNfBWyYzKebu4xyY1bg8GXJa
Xj4y0ob+plAf427Svz5X2br4t2Lwg4VSrQ1kU3qXfCY46D1DJKraeKbLeiKijB6N
5vpxl1nKBvMyIQHr6dE/Q7qOvasYZuvKd+A/xv2wUwQxkdTI2u1tz+Oa2BkS2zyR
Oukto1kIYcfq8BlWxCIItjholBY5opfCA3tT1QdghBWILZwMN9IVGyb4kkCdxdcX
Py/DkEY2Cen90LNO5UT+3g4g/D/ALTwAvATg3U1JKgJfti6zQKLxUMQcmEiV4qky
aFcR1mpPoxwttoNd4s9zA1WFWBl6dCQjMhqhOvM3rBwByJyum0SQFqyx+F9P5Cpv
LM5V4MMVng8rGcF/E99FeVSPcdLAa8TjYfFqTfbe/hhFLJcvQ1PtdHeP8oSMvhqM
1IA4fIdgtto2qD3k37Kr
=AM3C
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
