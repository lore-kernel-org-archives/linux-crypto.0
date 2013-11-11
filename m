From: Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [PATCH RESEND] crypto: make sure *blkcipher_walk_init properly initialises walk
Date: Mon, 11 Nov 2013 12:26:38 +0100
Message-ID: <xa1t61rzyya9.fsf@mina86.com>
References: <1384108681-23519-1-git-send-email-mpn@google.com> <20131111012809.GA5091@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:38832 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910Ab3KKL0q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Nov 2013 06:26:46 -0500
Received: by mail-ee0-f47.google.com with SMTP id c13so2330187eek.6
        for <linux-crypto@vger.kernel.org>; Mon, 11 Nov 2013 03:26:45 -0800 (PST)
In-Reply-To: <20131111012809.GA5091@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11 2013, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Nack.  The field flags is used as a bit-field and all bits other
> than those initialised that you see are used internally by the
> walker function and will be initialised on demand.
>
> Please do not just rely on tools such as coverity and actually
> read the code when submitting patches.

I have read the code which is why I concluded that it is safe to replace
the bit operations with a simple assignment.  Since, as you described,
all other bit fields are initialised on demand anyway, there is no harm
in setting them to zero here.  Especially since I see no advantages of
the current approach, but instead see two disadvantages: longer machine
code (load-modiy-store vs. store) and confusion of tools such as
Coverity.

But of course, if you want it as it is, I won't be bothering you.

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSgL7uAAoJECBgQBJQdR/0nxYP/2mR7DEkC9yE4zKXb5CK5eCH
hfwoCzCInvcBP0M6fM0aNRyDMpoOKF8lAoOUb/5CYyoPrdxFzh5R2xx4kPsK76cn
rO9zmhez4uQsuqT6tlolk/l51koVa/uQq4VPjZaZKigd+1G+2mwyzVjs8Zh+biGO
2O5xzXF6U3aV26JGdtfpY/DEZENxr505VfI2UGXUUFjWEg8TrWFcJN80/1HXTkOC
irP+6b8oG4HsnRhWHMEUmVrJzq1ZOiytiMMjglCOmz3Y9xYnHHXs2LxE1FJpB5TC
JTrw5mCcbMI0GC77/KOoJsT6w/gOgdKTUh5uJfg/W3Y8s0oZSFIjd2idnqkIzXAt
ZlCrKbPsqS5h2iWucMTc7iiSiKC0yjO1M44uXIna+qF2uD5QDZwvJlJ8hxQrgOKu
+auA6kOQMkx7yJX243on6qjnxjGMfOesjTVqndvdPlnhWUBrkOdaStzzdPj2nZjG
36ttn1x4UwqYh3BuJpU5NW29vV8xtxfpldwE65327o0n4WpmhrUt4D4ZB8nQGaOb
eH7a9ibraG8ddl8ZLC141wEhpsHa03fs1FEv5GLnY8rO4A8+djzfGN+1oiIUy7PP
UdicxpThacxSBU6R0yyHPvcYXeks8jFYp3t/FCVkRyLL1ezXL4AzME7Hcb6U0NQB
B2i9G0t47QTh8JOLKTmo
=jUH5
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
