From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: linux-next/drivers/crypto/atmel-aes.c:282: possible missing
 break ?
Date: Tue, 19 Jan 2016 09:05:43 +0800
Message-ID: <20160119010542.GA5813@gondor.apana.org.au>
References: <DUB128-W8218FB17B6FF976EA4B2C49CC00@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: David Binderman <dcb314@hotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36901 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391AbcASBFt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Jan 2016 20:05:49 -0500
Content-Disposition: inline
In-Reply-To: <DUB128-W8218FB17B6FF976EA4B2C49CC00@phx.gbl>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 18, 2016 at 03:41:46PM +0000, David Binderman wrote:
> Hello there,
>=20
> [linux-next/drivers/crypto/atmel-aes.c:285]: (warning) Buffer 'tmp' i=
s being written before its old content has been used. 'break;' missing?
>=20
> =A0=A0=A0 case AES_GCMHR(3):
> =A0=A0=A0=A0=A0=A0=A0 snprintf(tmp, sz, "GCMHR[%u]", (offset - AES_GC=
MHR(0))>> 2);
>=20
> =A0=A0=A0 default:
> =A0=A0=A0=A0=A0=A0=A0 snprintf(tmp, sz, "0x%02x", offset);
> =A0=A0=A0=A0=A0=A0=A0 break;

Indeed.  Thanks!

---8<---
Subject: crypto: atmel-aes - Add missing break to atmel_aes_reg_name

The debug function atmel_aes_reg_name was missing a break for
AES_GCMHR.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
index 5621612..6dd3317 100644
--- a/drivers/crypto/atmel-aes.c
+++ b/drivers/crypto/atmel-aes.c
@@ -280,6 +280,7 @@ static const char *atmel_aes_reg_name(u32 offset, c=
har *tmp, size_t sz)
 	case AES_GCMHR(2):
 	case AES_GCMHR(3):
 		snprintf(tmp, sz, "GCMHR[%u]", (offset - AES_GCMHR(0)) >> 2);
+		break;
=20
 	default:
 		snprintf(tmp, sz, "0x%02x", offset);
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
