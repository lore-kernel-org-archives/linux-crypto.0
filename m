From: "D. J. Bernstein" <djb@cr.yp.to>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: 15 Aug 2018 16:28:19 -0000
Message-ID: <20180815162819.22765.qmail@cr.yp.to>
References: <20180801072246.GA15677@sol.localdomain>
 <CAHmME9pbwj0RaX4YM9epGOSgDRNUt=GA4UzO_iKcW=Md7kG6JQ@mail.gmail.com>
 <20180814211229.GB24575@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
To: Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Tanja Lange <tanja@hyperelliptic.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Eric Biggers writes:
> I've also written a scalar ChaCha20 implementation (no NEON instructions!) that
> is 12.2 cpb on one block at a time on Cortex-A7, taking advantage of the free
> rotates; that would be useful for the single permutation used to compute
> XChaCha's subkey, and also for the ends of messages.

This is also how ends of messages are handled in the 2012 implementation
crypto_stream/salsa20/armneon6 (see "mainloop1") inside the SUPERCOP
benchmarking framework:

   https://bench.cr.yp.to/supercop.html

This code is marginally different from Eric's new code because the
occasional loads and stores are scheduled for the Cortex-A8 rather than
the Cortex-A7, and because it's Salsa20 rather than ChaCha20.

The bigger picture is that there are 63 implementations of Salsa20 and
ChaCha20 in SUPERCOP from 10 authors showing various implementation
techniques, including all the techniques that have been mentioned in
this thread; and centralized benchmarks on (e.g.)

   https://bench.cr.yp.to/results-stream.html#amd64-kizomba
   https://bench.cr.yp.to/web-impl/amd64-kizomba-crypto_stream-salsa20.html

showing what's fastest on various platforms, using well-developed
benchmarking tools that produce repeatable, meaningful measurements.
There are also various papers explaining the main techniques.

Of course it's possible that new code will do better, especially on
platforms with different performance characteristics from the platforms
previously targeted. Contributing new implementations to SUPERCOP is
easy---which is why SUPERCOP already has thousands of implementations of
hundreds of cryptographic functions---and is a more effective way to
advertise speedups than adding code merely to (e.g.) the Linux kernel.
Infrastructure is centralized in SUPERCOP to minimize per-implementation
work. There's no risk of being rejected on the basis of cryptographic
concerns (MD5, Speck, and RSA-512 are included in the benchmarks) or
code-style concerns. Users can then decide which implementations best
meet their requirements.

"Do better" seems to be what's happened for the Cortex-A7. The best
SUPERCOP speeds (from code targeting the Cortex-A8 etc.) are 13.42
cycles/byte for 4096 bytes for ChaCha20; 12.2, 11.9, and 11.3 sound
noticeably better. The Cortex-A7 is an interesting case because it's
simultaneously (1) widely deployed---more than a billion units sold---
but (2) poorly documented. If you want to know, e.g., which instructions
can dual-issue with loads/FPU moves/..., then you won't be able to find
anything from ARM giving the answer. I've started building an automated
tool to compute the full CPU pipeline structure from benchmarks, but
this isn't ready yet.

---Dan

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbdFSjAAoJELDADU47DlRZx2AP/RPp9lNbsncPgB7DLSLAdI8c
Cl+s9exWiSyjkS1SyNS82dfhMfLyf0vQfNRX6ZHqCYjXz8ZMQWpilLu4xr/yG4Wh
/Yro8BLeKdjsQOj29f7xGFCX9fv9fUa9Ouyk7myHt4LhEehJ3sl6WhL15WUQjROS
OTAQftllNNL/0Xzj0sl1nxmZPlrAqT4HjLiB9t5XhT59jJPXPcZrFpOEPbKrRyRN
61cOXOxXqlaIdpsck4hEMLdHlPESN31NP1m/xwNUwnFBM79dFSxSZ/E/Qbwt6hq5
0FMJ0BRvlgugxnmS91dfz1h3rezOBfwQcLfbk0sylVOamj3YD+x/uc9Fbi/jorTu
WO1EBwIOkAeL0I+4/kqb0MTf227ScKHiyanwSGzVZbMo14odKmMVP94MKF/90cdS
EgG6I4joMjphvnsGRwrbfmAkwCpBvoap2orhZ8+hecsiOp/Oc4BWsjD2MMsw6HWd
l5VcjEU+MB8VHbB78rU4scNwXpjwcgKJn09lb1J1ZrDPZfeFrZBaomnbtM9YQzPa
4OYgwFiYzVEInrpl3ZFzTh5JR6yeoERAI/zvietVUWqebFhviEWXWanP9v9VqpJy
VjPheFHh7DLB3rT7VSp5lKi3RejmbiKIZ/zqqapQ0o7xSxEokD9UcRhJ6Eq7O6IO
HjT0De/Y053XN9gvXftk
=fS0C
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
