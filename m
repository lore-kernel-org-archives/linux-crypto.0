From: Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: Re: crypto: hang in crypto_larval_lookup
Date: Fri, 24 Feb 2017 20:44:00 -0300
Message-ID: <20170224234400.GA2758@gallifrey>
References: <02b80c39-0fd5-b7bd-39da-07e5d71abbad@linux.vnet.ibm.com>
 <20170223111957.GA14000@gondor.apana.org.au>
 <20170223113909.GA14090@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Cc: Harald Freudenberger <freude@linux.vnet.ibm.com>,
        linux-crypto@vger.kernel.org, schwidefsky@de.ibm.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f175.google.com ([209.85.220.175]:34205 "EHLO
        mail-qk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdBXXoJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Feb 2017 18:44:09 -0500
Received: by mail-qk0-f175.google.com with SMTP id s186so31768218qkb.1
        for <linux-crypto@vger.kernel.org>; Fri, 24 Feb 2017 15:44:08 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170223113909.GA14090@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 23, 2017 at 07:39:09PM +0800, Herbert Xu wrote:
> On Thu, Feb 23, 2017 at 07:19:57PM +0800, Herbert Xu wrote:
> > Harald Freudenberger <freude@linux.vnet.ibm.com> wrote:
> > >=20
> > > Hello all
> > >=20
> > > I am currently following a hang at modprobe aes_s390 where
> > > crypto_register_alg() does not come back for the xts(aes) algorithm.
> > >=20
> > > The registration is waiting forever in algapi.c crypto_wait_for_test(=
) but
> > > the completion never occurs. The cryptomgr is triggering a test via
> > > kthread_run to invoce cryptomgr_probe and this thread is calling the
> > > create() function of the xts template (file xts.c). Following this th=
read
> > > it comes down to api.c crypto_larval_lookup(name=3D"aes") which is fi=
rst
> > > requesting the module "crypto-aes" via request_module() successful an=
d then
> > > blocking forever in requesting the module "crypto-aes-all".
> > >=20
> > > The xts(aes) has at registration CRYPTO_ALG_NEED_FALLBACK flag on.
> > >=20
> > > This problem is seen since about 6 weeks now, first only on the linux=
 next
> > > kernel. Now it appers on the 4.10-rc kernels as well. And I still hav=
e no
> > > idea on how this could be fixed or what's wrong with just the xts
> > > registration (ecb, cbc, ctr work fine).
> > >=20
> > > Any ideas or hints?
> >=20
> > Sorry, my fault.  I should've converted all the fallback users of
> > the old blkcipher interface over to skcipher before converting the
> > core algorithms to skcipher.
> >=20
> > I'll send a patch.
>=20
> Hmm, actually looks like I did convert this one :)
>=20
> Do you have ECB enabled in your configuration? XTS doesn't work
> without it.  Currently the Kconfig is missing a select on ECB so
> it could stop the generic XTS from loading.
>=20
> However, you seem to be stuck on straight AES which quite strange.
> The reason is that s390 crypto registers AES as the first thing so
> it should already be available.
>=20
> The fact that it hangs is expected because it's trying to find
> an acceptable AES implementation and in doing so it's loading
> s390-aes again.
>=20
> So we need to get to the bottom of why there is no acceptable
> "aes" registered.  Can you check /proc/crypto to see if the simple
> aes cipher is correctly registered (passing the selftest) after
> it hangs?

This is probably caused by the way that the xts template is handling the
underline algorithm selection.

In the create function in crypto/xts.c:

	static int create(struct crypto_template *tmpl, struct rtattr **tb)
	{
	...
		crypto_set_skcipher_spawn(&ctx->spawn, skcipher_crypto_instance(inst));
		err =3D crypto_grab_skcipher(&ctx->spawn, cipher_name, 0,
					   crypto_requires_sync(algt->type,
								algt->mask));
		if (err =3D=3D -ENOENT) {
			err =3D -ENAMETOOLONG;
			if (snprintf(ctx->name, CRYPTO_MAX_ALG_NAME, "ecb(%s)",
				     cipher_name) >=3D CRYPTO_MAX_ALG_NAME)
				goto err_free_inst;

			err =3D crypto_grab_skcipher(&ctx->spawn, ctx->name, 0,
						   crypto_requires_sync(algt->type,
									algt->mask));
		}
	...

Then when the aes_s390 driver tries to allocate its fallback based on
its name ("xts(aes)"), the xts template will first look for an skcipher
"aes" algorithm, that doesn't exist. And because of that
crypto_larval_lookup will try to load the correspondent alias. Also,
since the template does not use the requested flag
CRYPTO_ALG_NEED_FALLBACK when it selects the underline algorithm, the
-all alias is also requested.

A simple workaround is to try the ecb algorithm before the original
algorithm. However this still can lead to the same problem when no ecb
implementation is available, not even by the driver itself.

Another improvement that can be useful is to honor the requested
CRYPTO_ALG_NEED_FALLBACK flag when selecting the underline algorithm.
It's very likely that the aes_s390 driver will end up using the
following chain of fallback algorithms:

xts-aes-s390 -> xts(ecb-aes-s390) -> xts(ecb(aes-s390)) ->
xts(ecb(aes-generic))

A similar scenario occurs for the vmx-crypto driver.

>=20
> You could also print out the type/mask in crypto_larval_lookup
> to see if perhaps the caller is asking for something unreasonable.
>=20
> Thanks,
> --=20
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/1111
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--=20
Regards,
Marcelo


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJYsMVAAAoJEM8aS8c01e1HnvkH/Rtr3yRt9r2hUXPluD3RFa9E
Let5KoJEOFUGb+ScITFkplqzX8QK/7RMITC2Z6f0YlAFEQCq1TxQu1S6Ho+61K0h
DN5rkj8aAkN1Nvj7uFl0lVT/GfEfdhD2m/tKWKbadOYOfvF/3EwMV9yzrlS4OFkq
JVaYv49zf/Y8pF5bHdeXRyudwGDOMyrdGOmLIi5RNrJGMJGvYCeifwOsj+41d5+C
uos0pxQILb0z9lXlKs0wAQevaVjsQL7695PISX080AEs5yyCkP+klc2jx4hOHZ0p
MS8SBGEtQ16N5CQJKPR0564R/xaEchSTY7CPypeBfxY3PNhf9PE/YEQEqGjORbE=
=AF3m
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
