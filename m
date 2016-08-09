From: Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] hwrng: core - Allow for multiple simultaneous active hwrng devices
Date: Tue, 09 Aug 2016 12:01:13 -0700
Message-ID: <86shudrcli.fsf@hiro.keithp.com>
References: <1469477255-26824-1-git-send-email-keithp@keithp.com> <20160809095058.GA6618@gondor.apana.org.au> <20160809165710.GC2013@io.lakedaemon.net> <86y445rfiq.fsf@hiro.keithp.com> <20160809182620.GF2013@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from home.keithp.com ([63.227.221.253]:39562 "EHLO elaine.keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbcHITBR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 15:01:17 -0400
In-Reply-To: <20160809182620.GF2013@io.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jason Cooper <jason@lakedaemon.net> writes:

> On another thread, regarding the ath9k-rng (actually just the adc
> registers), Henrique asked about per-source knobs.  My suggestion
> follows from that.

I'd do that with the source-specific driver instead of attempting to
route controls through hwrng. Anything else seems like 'ioctl' to me.

> Sure, but /dev/hwrng is a user interface.  Typically to rngd, but not
> necessarily.  We need to make sure it's behavior is consistent with
> existing expectations.

Hrm. Maybe /dev/hwrng should use a different policy than how we feed
/dev/random -- we could use the existing behaviour for /dev/hwrng, but
use a round-robin for /dev/random. That way, the latest device would
always end up in /dev/hwrng (unless configured otherwise), and we'd
still use all of the available sources to help stir the kernel entropy
pool.

> We shouldn't attach first-probed to /dev/hwrng, because that may not be
> what the user is expecting.  If I bought a raw entropy source, and knew
> nothing of the proposed multi-source interfaces, I'd expect the USB
> dongle to be attached to /dev/hwrng.  Despite the fact that my pcie wifi
> card was probed first and has adc registers providing an entropy source.

That seems like a fragile interface as it depends on discovery order,
but it is what we have currently.

The chaoskey driver also exposes it's own device; that provides a simple
way to ensure that the application is getting bits from the desired
entropy source.

> I'm not sure how we ensure that.  Perhaps an 'environmental' flag in the
> hw_random source attributes?  Or a 'not-designed-to-be-an-rng' flag? :)
> Maybe those would be /dev/envrng[0-9]...

Or some set of query ioctls on /dev/hwrng[0-9]+ that would provide
information about the capabilities of the underlying device.

There are lots of things we could do, I guess the question I have is how
much of this would applications actually use effectively? You're
probably right that /dev/hwrng should point at a single source and not
change though; otherwise figuring out what the quality of the bits
you're getting isn't possible.x

=2D-=20
=2Dkeith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBV6ooedsiGmkAAAARAQhQtw/6AwT9ga1hEYtYoa2tqtzo5hIQoYoDcFPk
QKBzZpzZovSgLckvXsVk6iqAHRcKxENDO12C+SjEAwdnxTxsOr3wTsiK0N0NNmsY
/U+bGyyclR28feaSOpDghT7fTcob8hyE8CYLi8Va64keswMr2r3PM3OTCpKjg4j/
tNPz7PwSyx9ZkIgSrfzSLVHuhgLLlADbdpKKL4sQyxbmaJVJvcGU7gBkxEn3FLPO
cOp5MNNRGk9TBrtVmYCm5e/s0PtqUuXCR6ek75rftHSWz2/ghGeAlePyYYOjap44
cilJFtGXIsIEvtEzfqhTFgCocaonlPU3q9E/5UGhqb3jX05cE2ZiLqApxmn0ApNO
HopVjl8YAXDIhrGj3s+rAVN1iB60H4oXZqDlsHfSVUlclNJkvzy4WwLnbv8Wl9Uf
fGOGUKwiKfQX+as/VyUm7NNlEduD1DakEkDZbiXixdlYatvfjadY0mIaAJKrySoU
lygQs3fT7sS5l8J8WzU/W1WVNJaDNTEC+j6xh/FmXcJMHB6wO4xQJCTsbZR3F4Lg
C/wpajb4GojappdDQsj3RKNVWjKLeFi4HYspqDFQnT03MQeLn2FOte6PswaKUuOu
lxW5ZZbSyoBC+8SA2lrKAt9jcLt40Rama2wQ3hihOGGabIFtyMJbVYQyZ/cPKNMY
4PaKy0+4unQ=
=viNv
-----END PGP SIGNATURE-----
--=-=-=--
