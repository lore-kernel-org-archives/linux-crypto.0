From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/8] crypto: caam - Convert GCM to new AEAD interface
Date: Mon, 15 Jun 2015 20:59:51 +0800
Message-ID: <20150615125951.GA1902@gondor.apana.org.au>
References: <20150615080716.GA30753@gondor.apana.org.au>
 <E1Z4PSj-00084W-6B@gondolin.me.apana.org.au>
 <557EC610.9070309@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Marcelo Henrique Cerri <mhcerri@linux.vnet.ibm.com>,
	Fionnuala Gunter <fin@linux.vnet.ibm.com>,
	ruchika.gupta@freescale.com, cristian.stoica@freescale.com,
	NiteshNarayanLal@freescale.com, jinyanjiang@gmail.com,
	Tudor Ambarus <tudor.ambarus@freescale.com>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34716 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbbFOM7z (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 08:59:55 -0400
Content-Disposition: inline
In-Reply-To: <557EC610.9070309@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 15, 2015 at 03:33:20PM +0300, Horia Geant=C4=83 wrote:
>=20
> Testing on P2041RDB I see the following failures:
>=20
> caam_jr ffe301000.jr: 40000f10: DECO: desc idx 15: Invalid Sequence
> Command. A SEQ IN PTR OR SEQ OUT PTR Command is invalid or a SEQ KEY,
> SEQ LOAD, SEQ FIFO LOAD, or SEQ FIFO STORE decremented the input or
> output sequence length below 0. This error may result if a built-in
> PROTOCOL Command has encountered a malformed PDU.
> alg: aead: encryption failed on test 1 for rfc4106-gcm-aes-caam:
> ret=3D-1073745680
>=20
> caam_jr ffe301000.jr: 40000e10: DECO: desc idx 14: Invalid Sequence
> Command. A SEQ IN PTR OR SEQ OUT PTR Command is invalid or a SEQ KEY,
> SEQ LOAD, SEQ FIFO LOAD, or SEQ FIFO STORE decremented the input or
> output sequence length below 0. This error may result if a built-in
> PROTOCOL Command has encountered a malformed PDU.
> alg: aead: encryption failed on test 1 for rfc4543-gcm-aes-caam:
> ret=3D-1073745424

I don't really know what's happening there.

> alg: aead: Test 2 failed on encryption for gcm-aes-caam
> 00000000: ab 6e 47 d4 2c ec 13 bd f5 3a 67 b2 12 57 bd df
> 00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

But this one seems obvious.  When assoclen is zero I failed to
set VARSEQOUTLEN correctly for the cipher.

I'll try to fix this.

Thanks for the quick response!
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
