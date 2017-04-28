From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: talitos: Extend max key length for
 SHA384/512-HMAC
Date: Fri, 28 Apr 2017 11:08:31 +0000
Message-ID: <VI1PR0401MB259114A07C3644B4552A0A9998130@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170427154046.GA5041@darwin.bork.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
To: Martin Hicks <mort@bork.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr40082.outbound.protection.outlook.com ([40.107.4.82]:35648
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1032305AbdD1LIf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Apr 2017 07:08:35 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 4/27/2017 6:46 PM, Martin Hicks wrote:=0A=
> =0A=
> The max keysize for both of these is 128, not 96.  Before, with keysizes=
=0A=
> over 96, the memcpy in ahash_setkey() would overwrite memory beyond the=
=0A=
> key field.=0A=
> =0A=
While here, what about aead_setkey()?=0A=
AFAICT, TALITOS_MAX_KEY_SIZE value has been incorrect since forever; it=0A=
does not cover the maximum values of encryption key + authentication key=0A=
for authenc algorithms.=0A=
=0A=
So, based on algorithms currently registered, I think this should be:=0A=
#define TALITOS_MAX_KEY_SIZE		(AES_MAX_KEY_SIZE + \=0A=
					 SHA512_BLOCK_SIZE)=0A=
=0A=
=0A=
> Signed-off-by: Martin Hicks <mort@bork.org>=0A=
Cc: stable@vger.kernel.org # 3.6+=0A=
Fixes: 357fb60502ede ("crypto: talitos - add sha224, sha384 and sha512=0A=
to existing AEAD algorithms")=0A=
=0A=
> ---=0A=
>  drivers/crypto/talitos.c |    2 +-=0A=
>  1 file changed, 1 insertion(+), 1 deletion(-)=0A=
> =0A=
> diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c=0A=
> index 0bba6a1..97dc85e 100644=0A=
> --- a/drivers/crypto/talitos.c=0A=
> +++ b/drivers/crypto/talitos.c=0A=
> @@ -816,7 +816,7 @@ static void talitos_unregister_rng(struct device *dev=
)=0A=
>   * HMAC_SNOOP_NO_AFEA (HSNA) instead of type IPSEC_ESP=0A=
>   */=0A=
>  #define TALITOS_CRA_PRIORITY_AEAD_HSNA	(TALITOS_CRA_PRIORITY - 1)=0A=
> -#define TALITOS_MAX_KEY_SIZE		96=0A=
> +#define TALITOS_MAX_KEY_SIZE		SHA512_BLOCK_SIZE /* SHA512 has the larges=
t keysize input */=0A=
>  #define TALITOS_MAX_IV_LENGTH		16 /* max of AES_BLOCK_SIZE, DES3_EDE_BLO=
CK_SIZE */=0A=
>  =0A=
>  struct talitos_ctx {=0A=
> =0A=
=0A=
