From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: qat: Fix random config build warnings
Date: Wed, 25 Jun 2014 21:36:58 +0800
Message-ID: <20140625133658.GA10122@gondor.apana.org.au>
References: <20140624221833.3872.65930.stgit@tstruk-mobl1.intel.com>
 <20140624221924.3872.42454.stgit@tstruk-mobl1.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: davem@davemloft.net, bruce.w.allan@intel.com,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:35965 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbaFYNhS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Jun 2014 09:37:18 -0400
Content-Disposition: inline
In-Reply-To: <20140624221924.3872.42454.stgit@tstruk-mobl1.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 24, 2014 at 03:19:24PM -0700, Tadeusz Struk wrote:
> Fix random config build warnings:
>=20
> Implicit-function-declaration =E2=80=98__raw_writel=E2=80=99
> Cast to pointer from integer of different size [-Wint-to-pointer-cast=
]
>=20
> Reviewed-by: Bruce Allan <bruce.w.allan@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  drivers/crypto/qat/qat_common/adf_accel_devices.h |    1 +
>  drivers/crypto/qat/qat_common/qat_algs.c          |    6 +++---
>  2 files changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/driv=
ers/crypto/qat/qat_common/adf_accel_devices.h
> index f3206d9..9282381 100644
> --- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
> +++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
> @@ -50,6 +50,7 @@
>  #include <linux/atomic.h>
>  #include <linux/list.h>
>  #include <linux/proc_fs.h>
> +#include <linux/io.h>
>  #include "adf_cfg_common.h"
> =20
>  #define PCI_VENDOR_ID_INTEL 0x8086
> diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypt=
o/qat/qat_common/qat_algs.c
> index 193b753..c4e8010 100644
> --- a/drivers/crypto/qat/qat_common/qat_algs.c
> +++ b/drivers/crypto/qat/qat_common/qat_algs.c
> @@ -745,7 +745,7 @@ void qat_alg_callback(void *resp)
>  {
>  	struct icp_qat_fw_la_resp *qat_resp =3D resp;
>  	struct qat_crypto_request *qat_req =3D
> -			(void *)(dma_addr_t)qat_resp->opaque_data;
> +				(void *)(__force long)qat_resp->opaque_data;

Why not just get rid of the (__force long) altogether?

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
