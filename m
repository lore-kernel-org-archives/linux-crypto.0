From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: prefix module autoloading with "crypto-"
Date: Mon, 17 Nov 2014 23:09:26 +0800
Message-ID: <20141117150926.GA1968@gondor.apana.org.au>
References: <20141114213459.GA3832@www.outflux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141114213459.GA3832@www.outflux.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 14, 2014 at 01:34:59PM -0800, Kees Cook wrote:
> This prefixes all crypto module loading with "crypto-" so we never ru=
n
> the risk of exposing module auto-loading to userspace via a crypto AP=
I,
> as demonstrated by Mathias Krause:
>=20
> https://lkml.org/lkml/2013/3/4/70
>=20
> Signed-off-by: Kees Cook <keescook@chromium.org>

Sorry but this doesn't build for me:

  CC [M]  drivers/crypto/qat/qat_common/adf_ctl_drv.o
drivers/crypto/qat/qat_common/adf_ctl_drv.c:490:21: error: expected dec=
laration specifiers or =E2=80=98...=E2=80=99 before string constant
make[3]: *** [drivers/crypto/qat/qat_common/adf_ctl_drv.o] Error 1
make[2]: *** [drivers/crypto/qat/qat_common] Error 2
make[1]: *** [drivers/crypto/qat] Error 2
make[1]: *** Waiting for unfinished jobs....

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
