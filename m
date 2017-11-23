From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 2/2] crypto: caam - add Derived Key Protocol (DKP) support
Date: Thu, 23 Nov 2017 08:50:42 +0000
Message-ID: <VI1PR0402MB334260EF8266A0C33BEA61E898210@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <20171110143349.8394-1-horia.geanta@nxp.com>
 <20171110143349.8394-2-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0075.outbound.protection.outlook.com ([104.47.1.75]:7040
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752179AbdKWIur (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Nov 2017 03:50:47 -0500
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/10/2017 4:34 PM, Horia Geant=E3 wrote:=0A=
> Offload split key generation in CAAM engine, using DKP.=0A=
> DKP is supported starting with Era 6.=0A=
> =0A=
> Note that the way assoclen is transmitted from the job descriptor=0A=
> to the shared descriptor changes - DPOVRD register is used instead=0A=
> of MATH3 (where available), since DKP protocol thrashes the MATH=0A=
> registers.=0A=
> =0A=
> Signed-off-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
When CAAM Job Ring platform devices are configured to go through ARM=0A=
SMMU, errors are reported:=0A=
arm-smmu 5000000.iommu: Unhandled context fault: fsr=3D0x402,=0A=
iova=3D0xffffffef9000, fsynr=3D0x3, cb=3D1=0A=
=0A=
This is due to incorrect DMA mapping direction for the buffers where=0A=
keys are stored, they have to change from DMA_TO_DEVICE to=0A=
DMA_BIDIRECTIONAL - with DKP keys are initially written by CPU and then=0A=
overwritten by the crypto engine.=0A=
=0A=
Will follow up with v2 shortly.=0A=
=0A=
Thanks,=0A=
Horia=0A=
