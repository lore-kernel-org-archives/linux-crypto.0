From: Patrick Steinhardt <ps@pks.im>
Subject: Re: PROBLEM: unable to decrypt LUKS partition since v4.9-rc6
 (bisected)
Date: Mon, 21 Nov 2016 08:43:49 +0100
Message-ID: <20161121074349.GA645@pks-pc>
References: <20161121065638.GA540@pks-pc>
 <20161121073400.GA6357@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56109 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752075AbcKUHnv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Nov 2016 02:43:51 -0500
Content-Disposition: inline
In-Reply-To: <20161121073400.GA6357@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 21, 2016 at 03:34:00PM +0800, Herbert Xu wrote:
> On Mon, Nov 21, 2016 at 07:56:38AM +0100, Patrick Steinhardt wrote:
> >=20
> > I'm using cryptsetup 1.7.2 via the kernel's crypto API. Since
> > version v4.9-rc6, I'm unable to decrypt my LUKS partitions
> > (aes-xts-plain64, sha512). cryptsetup simply aborts with the
> > message "No such passphrase available" after inputting the
> > passphrase.
> >=20
> > After bisecting the issue, this points to commit a8348bc (crypto:
> > algif_hash - Fix NULL hash crash with shash, 2016-11-17). After
> > reverting this particular commit, everything works correctly
> > again.
>=20
> Sorry, I screwed up that patch.  Please try the following fix.
> Thanks!
[snip]

Thanks for the fast response. Your patch fixes the problem.

Regards
Patrick

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYMqWzAAoJEBF8Z7aeq/EszFsQAINbbMrsBJdW7538a51QqXmF
einMJ8H0pYvlA+CBvBkUOYT+1jpQkkBOEgwNd6FH3P6wRdztqByBNzk/zG9maR72
mGowoDWH+Zs49LzbbQMFiHmOIe0FgH0e49fm/FzuZ/PpcuF6wcRYVBbE7hYpYkzu
+E1gaT0kume2w8P8GI6buYfR47AUK9z+qyzWPYMpaBRbbRnuQhK6jxJ3bNu8bOmN
iqmJhIAcvZtaigbaXyWziUeYjirqAlm++wSP1ewMhoMp7nCUq/Rl3erZkTC4rFp/
yXb+8X1OVRCHhdJLnVMom9bfi4bXTX8qiOrqloQ41YoEhANHYHo71H3+jzLSbCQ7
dcMR2wdQra8DR5+QULBgsg/9C7zgd4lTtoorIp6ldjArTIWS7zJeMo9J4y+mpVbK
+U1uMn9wAZDqW4oLAimE7RLsA8UNDnSsDQQK9D2BcdPQXQctexCorOmgFLi4hUC0
ar7C89HnfaBpBt7LiNV/P1zGhJiR1JeCInC8ncl06O+Z2/hvvF5TSrXOXwdE1Aux
Sk+g/1Ycoo50Y3VLzTDpT8vFhMQZD2PoJvvZVvuYmeDDpfaI+aOOHUpLMe+JrV7n
0jgUv5HFqbxagrY+nnqk1FeCcMW7kq8+VtBlAi/u/k9rwHVBbFc8H2u5T30zXs3y
EjawGy4L6cKhfVrTATU2
=atcv
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
