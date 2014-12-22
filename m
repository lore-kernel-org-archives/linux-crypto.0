From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Resend: [PATCH] CRYPTO: atmel_sha: remove unused shash fallback
 instance
Date: Mon, 22 Dec 2014 23:03:51 +1100
Message-ID: <20141222120351.GA21045@gondor.apana.org.au>
References: <5480E764.7030508@secomea.com>
 <5480F9F1.6000509@secomea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Svenning =?iso-8859-1?Q?S=F8rensen?= <sss@secomea.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:54143 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbaLVMD6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 22 Dec 2014 07:03:58 -0500
Content-Disposition: inline
In-Reply-To: <5480F9F1.6000509@secomea.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 05, 2014 at 01:18:57AM +0100, Svenning S=F8rensen wrote:
> [Sorry about the messed up tabs and line wraps in first post;
> I hope I managed to tame TB this time around]
>=20
> CRYPTO: atmel_sha: remove unused shash fallback instance.
>=20
> The fallback is never used, so there is no point in having it.
>=20
> The cra_exit routine can also be removed, since all it did was releas=
ing
> the fallback, along with the stub around cra_init, which just added a=
n
> unused NULL argument.
>=20
> Signed-off-by: Svenning Soerensen <sss@secomea.com>

Patch applied.
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
