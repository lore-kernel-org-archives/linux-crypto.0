From: Stephan Mueller <sm@eperm.de>
Subject: Re: [PATCH] crypto: Add a flag allowing the self-tests to be disabled at runtime.
Date: Fri, 29 Apr 2016 12:59:57 +0200
Message-ID: <1716181.h8M5zx62aT@tauon.atsec.com>
References: <1461924463-1678-1-git-send-email-rjones@redhat.com> <1461924463-1678-2-git-send-email-rjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, corbet@lwn.net,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org
To: "Richard W.M. Jones" <rjones@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461924463-1678-2-git-send-email-rjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 29. April 2016, 11:07:43 schrieb Richard W.M. Jones:

Hi Richard,

> Running self-tests for a short-lived KVM VM takes 28ms on my laptop.
> This commit adds a flag 'cryptomgr.notests' which allows them to be
> disabled.
>=20
> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
> ---
>  Documentation/kernel-parameters.txt | 3 +++
>  crypto/testmgr.c                    | 9 +++++++++
>  2 files changed, 12 insertions(+)
>=20
> diff --git a/Documentation/kernel-parameters.txt
> b/Documentation/kernel-parameters.txt index 0b3de80..d4d5fb7 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -826,6 +826,9 @@ bytes respectively. Such letter suffixes can also=
 be
> entirely omitted. It will be ignored when crashkernel=3DX,high is not=
 used
>  			or memory reserved is below 4G.
>=20
> +	cryptomgr.notests
> +                        [KNL] Disable crypto self-tests
> +
>  	cs89x0_dma=3D	[HW,NET]
>  			Format: <dma>
>=20
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index b86883a..dc613f2 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -35,6 +35,10 @@
>=20
>  #include "internal.h"
>=20
> +static bool notests;
> +module_param(notests, bool, 0644);
> +MODULE_PARM_DESC(notests, "disable crypto self-tests");
> +
>  #ifdef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
>=20
>  /* a perfect nop */
> @@ -3868,6 +3872,11 @@ int alg_test(const char *driver, const char *a=
lg, u32
> type, u32 mask) int j;
>  	int rc;
>=20
> +	if (notests) {

What about if (!fips_enabled && notests) ?

I am not sure whether the kernel should prevent mistakes in user space.=
 A=20
mistake would be when setting fips=3D1 and notests=3D1 as the FIPS mode=
 mandates=20
the self tests.

> +		pr_info("alg: self-tests disabled\n");
> +		return 0;
> +	}
> +
>  	alg_test_descs_check_order();
>=20
>  	if ((type & CRYPTO_ALG_TYPE_MASK) =3D=3D CRYPTO_ALG_TYPE_CIPHER) {


Ciao
Stephan
--=20
| Nimm das Recht weg -                                             |
|  was ist dann der Staat noch anderes als eine gro=DFe R=E4uberbande? =
|
