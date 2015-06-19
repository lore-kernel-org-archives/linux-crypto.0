From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [v2 PATCH 6/8] crypto: caam - Convert GCM to new AEAD interface
Date: Fri, 19 Jun 2015 08:05:50 +0800
Message-ID: <20150619000550.GA6936@gondor.apana.org.au>
References: <20150616054551.GA21524@gondor.apana.org.au>
 <E1Z4jpH-0005dy-Et@gondolin.me.apana.org.au>
 <5581A826.7060907@freescale.com>
 <20150618061734.GA28418@gondor.apana.org.au>
 <5582A8FD.30705@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ruchika.gupta@freescale.com, cristian.stoica@freescale.com,
	NiteshNarayanLal@freescale.com, jinyanjiang@gmail.com,
	Tudor Ambarus <tudor.ambarus@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33641 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbbFSAGO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 20:06:14 -0400
Content-Disposition: inline
In-Reply-To: <5582A8FD.30705@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 18, 2015 at 02:18:21PM +0300, Horia Geant=C4=83 wrote:
>
> To make sure, I've tried this case on HW (with modified tcrypt tests)=
:
>=20
> caam_jr ffe301000.jr: 4000101c: DECO: desc idx 16: DECO Watchdog time=
r
> timeout error
> alg: aead: encryption failed on test 1 for rfc4106-gcm-aes-caam:
> ret=3D-1073745948
>=20
> caam_jr ffe301000.jr: 4000111c: DECO: desc idx 17: DECO Watchdog time=
r
> timeout error
> alg: aead: encryption failed on test 1 for rfc4543-gcm-aes-caam:
> ret=3D-1073746204
>=20
> The errors are reported by HW and handled by the driver.

OK as long as it doesn't cause problems for other users of caam
(that would be a DDoS) then it should be fine.

> tcrypt tests pass.
> I'll run more tests (IPsec) on my side and report back if I encounter
> any issue.

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
