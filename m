From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: hash - Fix handling of small unaligned buffers
Date: Wed, 4 Aug 2010 21:48:51 +0800
Message-ID: <20100804134851.GA3884@gondor.apana.org.au>
References: <AANLkTinj0tPGa1ZVEs2JZ1Hvg9YOq7qx56LZJrOs4WPc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Szilveszter =?iso-8859-1?B?1nJk9mc=?= <slipszi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58449 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab0HDNsy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Aug 2010 09:48:54 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinj0tPGa1ZVEs2JZ1Hvg9YOq7qx56LZJrOs4WPc@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 02, 2010 at 02:45:37PM +0200, Szilveszter =D6rd=F6g wrote:
> If a scatterwalk chain contains an entry with an unaligned offset the=
n
> hash_walk_next() will cut off the next step at the next alignment poi=
nt.
>=20
> However, if the entry ends before the next alignment point then we wi=
ll want to
> process more data than it is available.
>=20
> Fix this by checking whether the next aligment point is before the en=
d of the
> current entry.
> ---
>  crypto/ahash.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index b8c59b8..f669822 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -47,8 +47,11 @@ static int hash_walk_next(struct crypto_hash_walk =
*walk)
>  	walk->data =3D crypto_kmap(walk->pg, 0);
>  	walk->data +=3D offset;
>=20
> -	if (offset & alignmask)
> -		nbytes =3D alignmask + 1 - (offset & alignmask);
> +	if (offset & alignmask) {
> +		unsigned int unaligned =3D alignmask + 1 - (offset & alignmask);
> +		if (nbytes > unaligned)
> +			nbytes =3D unaligned;
> +	}
>=20
>  	walk->entrylen -=3D nbytes;
>  	return nbytes;

The patch looks OK to me.  Dave, what do you think?

But you forgot to attach a Signed-off-by line.  Please resend
with one attached.

Thanks!
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
