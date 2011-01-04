From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: 2.6.37-rc7: Regression: b43: crashes in hwrng_register()
Date: Wed, 5 Jan 2011 00:06:44 +0100
Message-ID: <20110104230644.GJ27114@darkside.kls.lan>
References: <20101231003735.GA24101@gondor.apana.org.au>
 <4D1D27E7.7030301@lwfinger.net>
 <20101231022550.GA2512@darkside.kls.lan>
 <20101231024653.GA24879@gondor.apana.org.au>
 <20101231085103.GA31935@darkside.kls.lan>
 <20110104043338.GA27604@gondor.apana.org.au>
 <20110104121957.GA27114@darkside.kls.lan>
 <20110104123824.GA31557@gondor.apana.org.au>
 <20110104125722.GC27114@darkside.kls.lan>
 <20110104224238.GA4978@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BFVE2HhgxTpCzM8t"
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Matt Mackall <mpm@selenic.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from piggy.rz.tu-ilmenau.de ([141.24.4.8]:35832 "EHLO
	piggy.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833Ab1ADXHB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Jan 2011 18:07:01 -0500
Content-Disposition: inline
In-Reply-To: <20110104224238.GA4978@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--BFVE2HhgxTpCzM8t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 05, 2011 at 09:42:38AM +1100, Herbert Xu wrote:
> Can you please try this patch against vanilla to print out the
> raw output of xstore?

# ps -ef | grep 'rng[d]'
# cat /sys/devices/virtual/misc/hw_random/rng_available
via=20
# hexdump -n 16 -C /dev/hwrng
00000000  00 ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |..............=
=2E.|
00000010
#=20

kern.log meanwhile (lines numbered):
     1  Jan  4 23:56:40 ideapad kernel: [  151.714225] 0x0
     2  Jan  4 23:56:40 ideapad kernel: [  151.714236] 0xffffffff
     3  Jan  4 23:56:40 ideapad kernel: [  151.714239] 0x0
     4  Jan  4 23:56:40 ideapad kernel: [  151.714251] 0xffffffff
=2E..
   233  Jan  4 23:56:40 ideapad kernel: [  151.715967] 0x0
   234  Jan  4 23:56:40 ideapad kernel: [  151.715980] 0xffffffff
   235  Jan  4 23:56:40 ideapad kernel: [  151.715982] 0x0
   236  Jan  4 23:56:40 ideapad kernel: [  151.715995] 0xffffffff
   237  Jan  4 23:56:40 ideapad kernel: [  151.720342] 0x0
   238  Jan  4 23:56:40 ideapad kernel: [  151.720347] 0x0
   239  Jan  4 23:56:40 ideapad kernel: [  151.720361] 0x0
   240  Jan  4 23:56:40 ideapad kernel: [  151.720365] 0x0
=2E..
  8163  Jan  4 23:56:40 ideapad kernel: [  151.987049] 0x0
  8164  Jan  4 23:56:40 ideapad kernel: [  151.987061] 0x0
  8165  Jan  4 23:56:40 ideapad kernel: [  151.987063] 0x0
  8166  Jan  4 23:56:40 ideapad kernel: [  151.987075] 0x0


Mario
--=20
If her DNA was off by one percentage point, she'd be a dolphin.
                                -- Dr. Gregory House

--BFVE2HhgxTpCzM8t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTSOoBBS+e2HeSPbpAQL1jwgAlXRiDIIE+X1JDGa5IqeHJQYpHL3JurTH
GZBuZQ8Typ84z646iEaQJptVSmCV/0MaH0mWUcq1nDEtXlZ3p3OOZvQTSYDYjMBL
tu8qJc+BvGQP2nV5MVrzmCFBWBw39RXkljVLAFF2Kvsfdof4FnaWF7n8wDC+r762
31O4LC23nNer7IiLV7SIUS+x0VXyPKQg3mBxBqdzzd0M6IqC1YipSNDcdpoAXmoa
8Yo82UlClOozh/cmXcVAjvBu9xmY3wWwrhnexCAXLcgDZOWEPfzIrvK+UP+V5Bcg
7aEWnw9UBkoQnQrKrsxLcOCpFc5xWxyJvlPS/nHLqAZdNdderH7FGg==
=2Pa5
-----END PGP SIGNATURE-----

--BFVE2HhgxTpCzM8t--
