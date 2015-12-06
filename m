From: Daniel Axtens <dja@axtens.net>
Subject: Re: crypto/nx842: Ignore queue overflow informative error
Date: Mon, 07 Dec 2015 09:57:14 +1100
Message-ID: <87bna36v91.fsf@gamma.ozlabs.ibm.com>
References: <1449388004.2096.12.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
To: Haren Myneni <haren@linux.vnet.ibm.com>,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	ddstreet@ieee.org, mpe@ellerman.id.au, pair@us.ibm.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1449388004.2096.12.camel@hbabu-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Haren Myneni <haren@linux.vnet.ibm.com> writes:

> NX842 coprocessor sets bit 3 if queue is overflow. It is just for
> information to the user. So the driver prints this informative message
> and ignores it.

What queue, and what happens when the queue overflows? It seems like
*something* would need to be done, somewhere, by someone?

I realise that as a piece of IBM hardware this is probably an incredibly
optimistic question, but is this behaviour documented publically anywhere?
(As a distant second best, is it documented internally anywhere that I
can read?)

> --- a/drivers/crypto/nx/nx-842-powernv.c
> +++ b/drivers/crypto/nx/nx-842-powernv.c
> @@ -442,6 +442,15 @@ static int nx842_powernv_function(const unsigned cha=
r *in, unsigned int inlen,
>  			     (unsigned int)ccw,
>  			     (unsigned int)be32_to_cpu(crb->ccw));
>=20=20
> +	/*
> +	 * NX842 coprocessor uses 3rd bit to report queue overflow which is
> +	 * not an error, just for information to user. So, ignore this bit.
> +	 */
> +	if (ret & ICSWX_BIT3) {
> +		pr_info_ratelimited("842 coprocessor queue overflow\n");
It doesn't look like this is done anywhere else in the file, but should
this be prefixed with something? Something like "nx-842: Coprocessor
queue overflow"?

Regards,
Daniel

> +		ret &=3D ~ICSWX_BIT3;
> +	}
> +
>  	switch (ret) {
>  	case ICSWX_INITIATED:
>  		ret =3D wait_for_csb(wmem, csb);
>
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJWZL1KAAoJEPC3R3P2I92F4sgQAJsF4q1l/tqt8V9ck5rZnjfZ
yLWbpa/N0IfSpzxsbmXz5kApiQnnkq5A8GLK89nvP23CIrGJEIny1LGJdM7FunDu
OEk+KW5pflVVSybWIAajgpH6zn8gX/c9miiQH8qxbEqDDhg19mWjEfyjDs9riAny
8evdLJnD9Tq7TuUSZgLGr/Hlb7pnNF9u4/pX09FEBvcy3enna0lcymKXiirHFS/h
waJDBs7/LGXd9eTiDqvvz75lcBfufk8F6XAq8WxOp4AtbnFB+UP/cTjEuIXry+Pc
6+PAj4JIlYHQBtzGsBPzP1HSKz98d8SpjrfRqKzTezrR/Pqp+g3BEAilDuJLuuB1
EMlLL/DTixpHqkjcs045N/QGVSmcNuNTrLAHvfeAWKNC9u3xSyKcS3ci9dUH/q/q
ZkTHmk6QjBy1K5VMGVj9hZNRY3XnZe2JaXOX8bRkFodX6J6jeOmn9M6z483Zh9kb
ZP+bjZNFApPHJV5doZuInsnJfXImGIhiCp17yS69E/C99TusQgW/nNFEyLVTXc1i
6SszCiicWp+Iov9DJcAZ+3hnAX6Xc+nkIk0LwPnMB5oQaB+stv13sYvgFHtmpRqu
UY4RzUB+NDeiQaVZuV3feAbnAz17uJMeswE8S8ruq+RjDnb5XODUIkTny5RcoSii
pyl7G4JsSvSZnPo/TnMV
=eGI3
-----END PGP SIGNATURE-----
--=-=-=--
