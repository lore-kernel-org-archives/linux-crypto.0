From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH v4 04/14] crypto: ecc - don't be selfish on pubkeys
Date: Sun, 28 May 2017 17:22:30 +0000
Message-ID: <VI1PR0401MB25914061D5FFCB13C047A1E798F20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
 <1495696696-22580-5-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Tudor Ambarus <tudor.ambarus@microchip.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        "giovanni.cabiddu@intel.com" <giovanni.cabiddu@intel.com>,
        "salvatore.benedetto@intel.com" <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-eopbgr30073.outbound.protection.outlook.com ([40.107.3.73]:25776
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750908AbdE1RWf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 May 2017 13:22:35 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5/25/2017 10:18 AM, Tudor Ambarus wrote:=0A=
> Rename ecdh_make_pub_key() to ecc_make_pub_key().=0A=
> This function might as well be used by ecdsa.=0A=
=0A=
Where exactly is ecdsa used in the kernel?=0A=
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg23235.html=0A=
=0A=
Thanks,=0A=
Horia=0A=
