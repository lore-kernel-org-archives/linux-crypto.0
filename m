From: Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Tue, 13 Jan 2009 10:34:13 +0800
Message-ID: <1231814053.5937.120.camel@yhuang-dev.sh.intel.com>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com>
	 <20090109070144.GA7358@gondor.apana.org.au>
	 <1231743310.5937.107.camel@yhuang-dev.sh.intel.com>
	 <20090112104335.GA4942@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y08IVnfpimQiUQZFICtj"
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43128 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757975AbZAMCeR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Jan 2009 21:34:17 -0500
In-Reply-To: <20090112104335.GA4942@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-y08IVnfpimQiUQZFICtj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-12 at 18:43 +0800, Herbert Xu wrote:
> On Mon, Jan 12, 2009 at 02:55:10PM +0800, Huang Ying wrote:
> >
> > I use a "shell" cbc(aes) algorithm which chooses between
> > cryptd(__cbc-aes-aesni) and __cbc-aes-aesni according to context. But
> > the struct ablkcipher_request passed in can not be used for cryptd(*).
> > This can be resolved by allocating another struct ablkcipher_request fo=
r
> > cryptd(*) for each incoming struct ablkcipher_request. But is there any
> > better solution?
>=20
> You should include that other ablkcipher_request as part of the
> context of your ablkcipher_request.
>=20
> See for example how aead embeds it.

Thank you! I take a look at gcm.c, and know how to implement it.

I have another idea, the sample code is as follow. In short, just relay
the request to cryptd_tfm, and change tfm before/after.

struct async_aes_ctx {
        struct crypto_ablkcipher *cryptd_tfm;
};

struct async_aes_req_ctx {
        struct crypto_ablkcipher *ablk_tfm;
        crypto_completion_t complete;
};

static inline struct async_aes_req_ctx *ablk_aes_req_ctx(
        struct ablkcipher_request *req,
        struct crypto_ablkcipher *ablk_tfm) {
        return ablkcipher_request_ctx(req) +
                ablk_tfm->base.crt_ablkcipher.reqsize;
}

static void ablk_complete(struct crypto_async_request *req, int err)
{
        struct ablkcipher_request *ablk_req =3D ablkcipher_request_cast(req=
);
        struct async_aes_req_ctx *req_ctx =3D
                ablk_aes_req_ctx(ablk_req, crypto_ablkcipher_reqtfm(ablk_re=
q));
        ablkcipher_request_set_tfm(ablk_req, req_ctx->ablk_tfm);
        req_ctx->complete(req, err);
}

static int ablk_encrypt(struct ablkcipher_request *req)
{
        struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
        struct async_aes_ctx *ctx =3D crypto_ablkcipher_ctx(tfm);

        if (kernel_fpu_using()) {
                struct async_aes_req_ctx *req_ctx =3D
                        ablk_aes_req_ctx(req, ctx->cryptd_tfm);
                req_ctx->ablk_tfm =3D tfm;
                ablkcipher_request_set_tfm(req, ctx->cryptd_tfm);
                req_ctx->complete =3D req->base.complete;
                req->base.complete =3D ablk_complete;
                return crypto_ablkcipher_encrypt(req);
        } else {
                struct blkcipher_desc desc;
                desc.tfm =3D cryptd_ablkcipher_child(ctx->cryptd_tfm);
                desc.info =3D req->info;
                desc.flags =3D 0;
                return crypto_blkcipher_encrypt(&desc, req->dst, req->src,
                                                req->nbytes);
        }
}

static void ablk_init_common(struct crypto_tfm *tfm,
                             struct crypto_ablkcipher *cryptd_tfm)
{
        struct async_aes_ctx *ctx =3D crypto_tfm_ctx(tfm);

        ctx->cryptd_tfm =3D cryptd_tfm;
        tfm->crt_ablkcipher.reqsize =3D cryptd_tfm->base.crt_ablkcipher.req=
size +
                sizeof(struct async_aes_req_ctx);
}

static int ablk_ecb_init(struct crypto_tfm *tfm)
{
        struct crypto_ablkcipher *cryptd_tfm;

        cryptd_tfm =3D cryptd_alloc_ablkcipher("__ecb-aes-aesni", 0, 0);
        if (IS_ERR(cryptd_tfm))
                return PTR_ERR(cryptd_tfm);
        ablk_init_common(tfm, cryptd_tfm);
        return 0;
}

Best Regards,
Huang Ying


--=-y08IVnfpimQiUQZFICtj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklr/aIACgkQKhFGF+eHlpiOJgCgjY7U5Vj5O3dTtYTdO63lg1xV
z9AAnir5MhLtiKrXJirPG7TCdKf7PZdH
=gRsG
-----END PGP SIGNATURE-----

--=-y08IVnfpimQiUQZFICtj--

