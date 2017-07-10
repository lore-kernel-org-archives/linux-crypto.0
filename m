From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 05/13] crypto: caam/qi - handle large number of S/Gs case
Date: Mon, 10 Jul 2017 05:23:11 +0000
Message-ID: <VI1PR0401MB2591CC0F274858650B710BB898A90@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170707130523.32427-1-horia.geanta@nxp.com>
 <20170707130523.32427-6-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        "Tudor Ambarus" <tudor.ambarus@microchip.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr10086.outbound.protection.outlook.com ([40.107.1.86]:57349
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751148AbdGJFXR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Jul 2017 01:23:17 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 7/7/2017 4:06 PM, Horia Geant=E3 wrote:=0A=
> For more than 16 S/G entries, driver currently corrupts memory=0A=
> on ARMv8, see below KASAN log.=0A=
> Note: this does not reproduce on PowerPC due to different (smaller)=0A=
> cache line size - 64 bytes on PPC vs. 128 bytes on ARMv8.=0A=
> =0A=
> One such use case is one of the cbc(aes) test vectors - with 8 S/G=0A=
> entries and src !=3D dst. Driver needs 1 (IV) + 2 x 8 =3D 17 entries,=0A=
> which goes over the 16 S/G entries limit:=0A=
> (CAAM_QI_MEMCACHE_SIZE - offsetof(struct ablkcipher_edesc, sgt)) /=0A=
> sizeof(struct qm_sg_entry) =3D 256 / 16 =3D 16 S/Gs=0A=
> =0A=
> Fix this by:=0A=
> -increasing object size in caamqicache pool from 512 to 768; this means=
=0A=
> the maximum number of S/G entries grows from (at least) 16 to 32=0A=
> (again, for ARMv8 case of 128-byte cache line)=0A=
> -add checks in the driver to fail gracefully (ENOMEM) in case the 32 S/G=
=0A=
> entries limit is exceeded=0A=
=0A=
Looks like I forgot to add a check in one of the places -=0A=
ablkcipher_giv_edesc_alloc(). Will fix this in v2.=0A=
=0A=
Horia=0A=
