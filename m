From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: provide DMA services in drivers/crypto
Date: Wed, 19 Oct 2016 20:24:23 +0530
Message-ID: <20161019145423.GQ2467@localhost>
References: <DB4PR04MB06561BC01F736652940C004FB8D20@DB4PR04MB0656.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>
To: Tudor-Dan Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:12537 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S942378AbcJSOp2 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Oct 2016 10:45:28 -0400
Content-Disposition: inline
In-Reply-To: <DB4PR04MB06561BC01F736652940C004FB8D20@DB4PR04MB0656.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 19, 2016 at 01:57:45PM +0000, Tudor-Dan Ambarus wrote:

Please wrap your mails within 80 chars, I have reflown below for reabability.

> Hi, Herbert,
> 
> CAAM has the ability to provide DMA services. This is helpful for
> platforms that don't have a dedicated DMA hardware block.
> 
> In this particular example, caam being a crypto accelerator at its
> fundamentals, where is recommended to add a caam-dma engine
> implementation, in drivers/dma or in drivers/crypto? Are the any
> rules/guidelines?

If the dma controller is internal to crypto, then it might be okay to be
inside the crypto driver. But if it is shared or common controller then a
dmaengine implementation would make sense..

> I noticed that CCP already registered DMA services, the driver being held
> in drivers/crypto.

I think drivers/crypto/ccp/ccp-dmaengine.c is wrong example, it should have
been in dmaengine directory. Not sure why it was addded in crypto :(

Thanks
-- 
~Vinod
