From: "Koul, Vinod" <vinod.koul@intel.com>
Subject: RE: [PATCH 0/4] add CAAM DMA memcpy driver
Date: Fri, 27 Oct 2017 11:35:57 +0000
Message-ID: <8D3F6266AEB6384E807C6FFC6FE195E333C52210@BGSMSX107.gar.corp.intel.com>
References: <20171026100008.32169-1-radu.alexe@nxp.com>
 <VI1PR0402MB33422B48B506D7FF6A894AE0985A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Cc: "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
To: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>,
        Radu Andrei Alexe <radu.alexe@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Dan Douglass <dan.douglass@nxp.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:28192 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752411AbdJ0LgD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Oct 2017 07:36:03 -0400
In-Reply-To: <VI1PR0402MB33422B48B506D7FF6A894AE0985A0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> On 10/26/2017 1:01 PM, Radu Alexe wrote:
> > This patch-set introduces a new DMA memcpy driver based on the DMA
> > capabilities of the CAAM crypto engine. Because of this dependency the
> > included commits target various parts of the kernel tree.
> I don't see the patches on any of the mail lists.
> If they are moderated, I would expect this to be mentioned in the
> MAINTAINERS file.
> 
> >
> > Patch 1.
> > Since the CAAM DMA driver is a platform driver it is enabled by a new node
> > in the device tree. This commit adds documentation for the device tree
> > bindings.
> >
> > Patch 2.
> > This patch adds the "caam-dma" node in the fsl-ls1012a.dtsi file.
> >
> > Patch 3.
> > This commit adds various capabilities in the JR driver of the CAAM that is
> > used by the CAAM DMA driver.
> >
> > Patch 4.
> > Adds the CAAM DMA memcpy driver.
> >
> > Patch 1 and 3 should be merged by the crypto maintainers, patch 2 by
> > devicetree maintainers and patch 4 by the DMA maintainers.
> I would go with all the patches through the dmaengine tree.

Good call, but no one CCed dmaengine folks on this series!

-- 
~Vinod
