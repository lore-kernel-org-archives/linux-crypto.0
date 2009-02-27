From: Huang Ying <ying.huang@intel.com>
Subject: Re: Bug of dm-crypt?
Date: Fri, 27 Feb 2009 17:46:53 +0800
Message-ID: <1235728013.6204.139.camel@yhuang-dev.sh.intel.com>
References: <1235712716.6204.100.camel@yhuang-dev.sh.intel.com>
	 <20090227054147.GA22159@gondor.apana.org.au>  <49A7A71E.50702@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ecLmkjQIuQlB3mvqbKe9"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:56858 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092AbZB0Jq5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Feb 2009 04:46:57 -0500
In-Reply-To: <49A7A71E.50702@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-ecLmkjQIuQlB3mvqbKe9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Milan,

On Fri, 2009-02-27 at 16:41 +0800, Milan Broz wrote:
> Herbert Xu wrote:
> > On Fri, Feb 27, 2009 at 01:31:56PM +0800, Huang Ying wrote:
> >> I had ever heard from you that the only thing guaranteed in the
> >> completion function of async ablkcipher cryption is the req->data has
> >> the value you set before. The request pointer itself may be changed. B=
ut
> >> in dm-crypt, I found they rely on request pointer in completion
> >> function: kcryptd_async_done. This makes my AES-NI cryptd usage panic.
> >>
> >> Do you think that is a bug?
> >=20
> > Absolutely.
> >=20
> > It should use cc->req instead.
>=20
> ok, I'll check it and try to fix that.=20
>=20
> Can you send me backtrace from that panic?

The panic backtrace is just some random kernel page fault or general
protection fault, because the freed pointer is not the allocated one.

> What's wrong in async callback now - mempool_free using async_req directl=
y?

Yes. I have a fix by storing real allocated async_req in
async_req->data. Can you help me to review that?

> (Btw in some previous discussuion I asked if cryptd can be used
> for some kind of parallel speedup for dm-crypt in async mode and response
> was that cryptd "is only meant to be a demo showing how an async
> implementation should be written".
>=20
> So this changed to real working thread for AES-NI?)

Yes. Now AES-NI uses it. And because a Per-CPU thread implementation is
used for cryptd, it can be used to speedup dm-crypt in some situation
too I think.

Best Regards,
Huang Ying


--=-ecLmkjQIuQlB3mvqbKe9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmntoQACgkQKhFGF+eHlpgVrgCggyM7Vvd4YWPI5OT4kaIlBWqw
nVEAn3EqEJt66bsM35Ew5zQCsmeIm4j0
=+qbn
-----END PGP SIGNATURE-----

--=-ecLmkjQIuQlB3mvqbKe9--

