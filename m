From: "D. J. Bernstein" <djb@cr.yp.to>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: 16 Aug 2018 04:24:54 -0000
Message-ID: <20180816042454.15529.qmail@cr.yp.to>
References: <20180801072246.GA15677@sol.localdomain>
 <CAHmME9pbwj0RaX4YM9epGOSgDRNUt=GA4UzO_iKcW=Md7kG6JQ@mail.gmail.com>
 <20180814211229.GB24575@gmail.com>
 <20180815162819.22765.qmail@cr.yp.to>
 <20180815195732.GA79500@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="NzB8fVQJ5HfG6fxh"
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
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Eric Biggers writes:
> You'd probably attract more contributors if you followed established
> open source conventions.

SUPERCOP already has thousands of implementations from hundreds of
contributors. New speed records are more likely to appear in SUPERCOP
than in any other cryptographic software collection. The API is shared
by state-of-the-art benchmarks, state-of-the-art tests, three ongoing
competitions, and increasingly popular production libraries.

Am I correctly gathering from this thread that someone adding a new
implementation of a crypto primitive to the kernel has to worry about
checking the architecture and CPU features to figure out whether the
implementation will run? Wouldn't it make more sense to take this
error-prone work away from the implementor and have a robust automated
central testing mechanism, as in SUPERCOP?

Am I also correctly gathering that adding an extra implementation to the
kernel can hurt performance, unless the implementor goes to extra effort
to check for the CPUs where the previous implementation is faster---or
to build some ad-hoc timing mechanism ("raid6: using algorithm avx2x4
gen() 31737 MB/s")? Wouldn't it make more sense to take this error-prone
work away from the implementor and have a robust automated central
timing mechanism, as in SUPERCOP?

I also didn't notice anyone disputing Jason's comment about the "general
clunkiness" of the kernel's internal crypto API---but is there really no
consensus as to what the replacement API is supposed to be? Someone who
simply wants to implement some primitives has to decide on function-call
details, argue about the software location, add configuration options,
etc.? Wouldn't it make more sense to do this centrally, as in SUPERCOP?

And then there's the bigger question of how the community is organizing
ongoing work on accelerating---and auditing, and fixing, and hopefully
verifying---implementations of cryptographic primitives. Does it really
make sense that people looking for what's already been done have to go
poking around a bunch of separate libraries? Wouldn't it make more sense
to have one central collection of code, as in SUPERCOP? Is there any
fundamental obstacle to having libraries share code for primitives?

> there doesn't appear to be an official git repository for SUPERCOP,
> nor is there any mention of how to send patches, nor is there any
> COPYING or LICENSE file, nor even a README file.

https://bench.cr.yp.to/call-stream.html explains the API and submission
procedure for stream ciphers. There are similar pages for other types of
cryptographic primitives. https://bench.cr.yp.to/tips.html explains the
develop-test cycle and various useful options.

Licenses vary across implementations. There's a minimum requirement of
public distribution for verifiability of benchmark results, but it's up
to individual implementors to decide what they'll allow beyond that.
Patent status also varies; constant-time status varies; verification
status varies; code quality varies; cryptographic security varies; etc.
As I mentioned, SUPERCOP includes MD5 and Speck and RSA-512.

For comparison, where can I find an explanation of how to test kernel
crypto patches, and how fast is the develop-test cycle? Okay, I don't
have a kernel crypto patch, but I did write a kernel patch recently that
(I think) fixes some recent Lenovo ACPI stupidity:

   https://marc.info/?l=qubes-users&m=153308905514481

I'd propose this for review and upstream adoption _if_ it survives
enough tests---but what's the right test procedure? I see superficial
documentation of where to submit a patch for review, but am I really
supposed to do this before serious testing? The patch works on my
laptop, and several other people say it works, but obviously this is
missing the big question of whether the patch breaks _other_ laptops.
I see an online framework for testing, but using it looks awfully
complicated, and the level of coverage is unclear to me. Has anyone
tried to virtualize kernel testing---to capture hardware data from many
machines and then centrally simulate kernels running on those machines,
for example to check that those machines don't take certain code paths?
I suppose that people who work with the kernel all the time would know
what to do, but for me the lack of information was enough of a deterrent
that I switched to doing something else.

> Another issue is that the ChaCha code in SUPERCOP is duplicated for
> each number of rounds: 8, 12, and 20.

These are auto-generated, of course.

To understand this API detail, consider some of the possibilities for
the round counts supported by compiled code:

   * 20
   * 12
   * 8
   * caller selection from among 20 and 12 and 8
   * caller selection of any multiple of 4
   * caller selection of any multiple of 2
   * caller selection of anything

I hope that in the long term everyone is simply using 20, and then the
pure 20 is the simplest and smallest and most easily verified code, but
obviously there are other implementations today. An API with a separate
function for each round count allows any of these implementations to be
trivially benchmarked and used, whereas an API that insists on passing
the round count as an argument prohibits at least the first three and
maybe more.

> crypto_stream/chacha20/dolbeau/arm-neon/, which uses a method similar to the
> Linux implementation but it uses GCC intrinsics, so its performance will heavily
> depend on how the compiler assigns and spills registers, which can vary greatly
> depending on the compiler version and options.

Sure. The damage done by incompetent compilers is particularly clear for
in-order CPUs such as the Cortex-A7.

> I understand that Salsa20 is similar to ChaCha, and that ideas from Salsa20
> implementations often apply to ChaCha too.  But it's not always obvious what
> carries over and what doesn't; the rotation amounts can matter a lot, for
> example, as different rotations can be implemented in different ways.

This sounds backwards to me. ChaCha20 supports essentially all the
Salsa20 implementation techniques plus some extra streamlining: often a
bit less register pressure, often less data reorganization, and often
some rotation speedups.

> Nor is it always obvious which ideas from SSE2 or AVX2 implementations
> (for example) carry over to NEON implementations, as these instruction
> sets are different enough that each has its own unique quirks and
> optimizations.

Of course.

> Previously I also found that OpenSSL's ARM NEON implementation of Poly1305 is
> much faster than the implementations in SUPERCOP, as well as more
> understandable.  (I don't know the 'qhasm' language, for example.)  So from my
> perspective, I've had more luck with OpenSSL than SUPERCOP when looking for fast
> implementations of crypto algorithms.  Have you considered adding the OpenSSL
> implementations to SUPERCOP?

Almost all of the implementations in SUPERCOP were submitted by the
implementors, with a few exceptions for wrappers. Realistically, the
implementors are in the best position to check that they're getting the
expected results and to be in control of any necessary updates.

---Dan

--NzB8fVQJ5HfG6fxh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJbdPyWAAoJELDADU47DlRZRT4P/jXLMqeH1j/Ybbdd73zo/4qB
fClPLtJzSWVJJ1Um2fKf9U89HTGy34stYflHzDDI9kd4/N2JYAh4mIlN3VcJ86h5
Lb9Eld4LznYnibDWhgBGi/T1Y1MgbqG9iIEGsiq1/Pxj+JUb24vPKYPotGnucgdD
mgs46Od3jaeEfcgbRLz0ajMmfcOx7G4UX+cggJ0pXFNj9mQseHauRpQhtaeeaHg3
Dw5boLS6El/svESQYsZtAzTPuIHr40Qhg1vLL7OMIRb87/o6HrAuRFhSpcQS78Ia
BhqYuSFbSbSc6yjoE4hbWQC0pAxfubrSwxK0y1TwlTdudmqZWoNErLe5cfdD7XnR
muR6MPxc1oOpDA1xAPtr3YlVNX0uxyi4FLMOapmQkO4fprNcYWBj8ZsZAwIIj7pD
hNmbOyKgcdQoEgVSh5WKZIVsPcUoypoRgTlyMqYptD9ocu4CRv4Gmhrnj/LZmJik
Iquk8ONJoUHpPvE6yvznuvxAYHAVOYks+S52yHGyziryM/kWaIQb8y1I/B0bRxCq
WMoHAEcCX3qLP49wEsFPJ/j3O/FwX7tVDmff+mPpnFbjMHY79AYtgeZg++KNNmUG
BQAAs4fzhgppNw4zaIPrTY/KGz67j48fy4qwbwGignZMKxwDPCj+c37wTaqQrZ4r
tWDe59IVHdcpbZINi41I
=GQ+7
-----END PGP SIGNATURE-----

--NzB8fVQJ5HfG6fxh--
