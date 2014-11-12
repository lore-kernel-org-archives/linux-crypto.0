From: Luis Henriques <luis.henriques@canonical.com>
Subject: Re: crypto: algif - avoid excessive use of socket buffer in skcipher
Date: Wed, 12 Nov 2014 11:58:40 +0000
Message-ID: <20141112115840.GF11111@hercules>
References: <5460987C.9030007@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: stable@vger.kernel.org, herbert@gondor.apana.org.au,
	gmazyland@gmail.com, linux-crypto@vger.kernel.org
To: Ondrej Kozina <okozina@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5460987C.9030007@redhat.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 10, 2014 at 11:50:36AM +0100, Ondrej Kozina wrote:
> Hello,
>=20
> could you please add this patch (already landed in 3.18-rc1) to follo=
wing
> stable kernels:
>=20
> 3.17.x, 3.14.x, 3.12.x, 3.4.x, 3.2.x?
>=20

Thank you, I'm also queuing it for the 3.16.

Cheers,
--
Lu=EDs

> The bugfix allows usage of crypto API socket on archs with PAGE_SIZE =
>=3D 32
> KiB (I have a typo in original changelog).
>=20
> Some background for the bug (with reproducer and report from users)
> - http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg11787.h=
tml
> - http://bugzilla.redhat.com/show_bug.cgi?id=3D1160289
>=20
> Thank you
> Ondrej
>=20
> -------------------
>=20
> Upstream commit e2cffb5f493a8b431dc87124388ea59b79f0bccb
> Author: Ondrej Kozina <okozina@redhat.com>
> Date:   Mon Aug 25 11:49:54 2014 +0200
>=20
>     crypto: algif - avoid excessive use of socket buffer in skcipher
>=20
>     On archs with PAGE_SIZE >=3D 64 KiB the function skcipher_alloc_s=
gl()
>     fails with -ENOMEM no matter what user space actually requested.
>     This is caused by the fact sock_kmalloc call inside the function =
tried
>     to allocate more memory than allowed by the default kernel socket=
 buffer
>     size (kernel param net.core.optmem_max).
>=20
>     Signed-off-by: Ondrej Kozina <okozina@redhat.com>
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>=20
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index a19c027..83187f4 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -49,7 +49,7 @@ struct skcipher_ctx {
>  	struct ablkcipher_request req;
>  };
>=20
> -#define MAX_SGL_ENTS ((PAGE_SIZE - sizeof(struct skcipher_sg_list)) =
/ \
> +#define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
>  		      sizeof(struct scatterlist) - 1)
>=20
>  static inline int skcipher_sndbuf(struct sock *sk)
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
