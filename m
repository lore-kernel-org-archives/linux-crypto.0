From: Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] hwrng: core - Allow for multiple simultaneous active hwrng devices
Date: Tue, 09 Aug 2016 10:58:05 -0700
Message-ID: <86y445rfiq.fsf@hiro.keithp.com>
References: <1469477255-26824-1-git-send-email-keithp@keithp.com> <20160809095058.GA6618@gondor.apana.org.au> <20160809165710.GC2013@io.lakedaemon.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jason Cooper <jason@lakedaemon.net>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from home.keithp.com ([63.227.221.253]:38968 "EHLO elaine.keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932272AbcHIR6J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 13:58:09 -0400
In-Reply-To: <20160809165710.GC2013@io.lakedaemon.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jason Cooper <jason@lakedaemon.net> writes:

> Perhaps a /dev/hwrng[0-9] per rng?  That would lend itself nicely to a
> sysfs interface for per device quality, rate, and enabled attributes.
> e.g. /sys/class/hw_random/hwrng0/{device/,quality,rate,enabled}

I was interested in the data being provided for /dev/random; that seems
like the most important interface to me.  But, exposing all of the
devices using consistent names does seem like a useful idea at some
level.

> /dev/hwrng could pull from the one with the highest quality, or user
> specified for backwards compatibility.

I like the notion of using all of them in turn; if one of them turns out
to be broken, you're still stirring in data from the others. After all,
the quality metric is provided by the device, we aren't doing any
analysis on the data to determine it independently.

=2D-=20
=2Dkeith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBV6oZrtsiGmkAAAARAQj/7xAAm8CfO23sCpo/KpV4GO64SIi5PPybHLZY
wwK6DfFYyZDssCrvzQNJcmAvrUSKPeuEShW/89kYNf/bMhGIr5l7uGG+CORWutlL
mnuMn01ZUf8ziFNthLBcgg7wctUFYlVp6XAcRxnP76dwCi+Rh3AZReVIdWUmTNVE
evZAZoRY1IGmJaw2EskLrGEypwrljiA5QTTXYtU//+PBEQrh0FjBmzMrdrFUgdS7
AGwlFBl8HIHeeQR8MLPCp0eHe0A7N9s94iXGPotI8ILBMq8TUBRg3PMVdePwMkWe
MLKw4GuUJBT8zMxvm4FjDYkqlg8OGY1XGI9Qt4dA6L8sZGF0u3z7oRyv4PVS/hVq
SzMF6Pjfr0DH5z66oFKx7SzPFibodbchgBnSFU1gP81d7g4N9TvyCpV3meJfL6lC
lxeQfeS+WSnEC1S3piu2PSAkVAx6SdytfwtUv3j1hmwy75dFwdSAdSU4mmnfdEnu
FFv55Df7c3tZTPOvxl6GtuQuRTF+y2hYiLkNNL9eqtC/Xq2fLSOMpX44E9T7MmRd
G2lSVd2MDrnLDiDXHscy25FBGUZ9Tmfhb7vTkK4lcaGjKSQNd6icnszukBnUnNce
doIFeY6zBN49Hff1g/Ags7WAFathba7u/KK+DqnskhOxhluZIrUNG0aYu7HfO7v8
hPfrHDYsE2M=
=QdVH
-----END PGP SIGNATURE-----
--=-=-=--
