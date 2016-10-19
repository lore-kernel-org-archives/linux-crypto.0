From: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Subject: provide DMA services in drivers/crypto
Date: Wed, 19 Oct 2016 13:57:45 +0000
Message-ID: <DB4PR04MB06561BC01F736652940C004FB8D20@DB4PR04MB0656.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "vinod.koul@intel.com" <vinod.koul@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-db5eur01on0063.outbound.protection.outlook.com ([104.47.2.63]:64544
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750791AbcJSX2r (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Oct 2016 19:28:47 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, Herbert,

CAAM has the ability to provide DMA services. This is helpful for platforms=
 that don't have a dedicated DMA hardware block.

In this particular example, caam being a crypto accelerator at its fundamen=
tals, where is recommended to add a caam-dma engine implementation, in driv=
ers/dma or in drivers/crypto? Are the any rules/guidelines?
I noticed that CCP already registered DMA services, the driver being held i=
n drivers/crypto.

Thanks,
ta
