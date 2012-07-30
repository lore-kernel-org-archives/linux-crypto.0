From: Timur Tabi <timur@freescale.com>
Subject: Re: [linuxppc-release] [PATCH v4 7/7] fsl-dma: add memcpy self test
 interface
Date: Mon, 30 Jul 2012 12:48:41 -0500
Message-ID: <5016C8F9.7070801@freescale.com>
References: <1343380616-12126-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	"Ira W. Snyder" <iws@ovro.caltech.edu>,
	Vinod Koul <vinod.koul@intel.com>,
	<herbert@gondor.hengli.com.au>,
	Dan Williams <dan.j.williams@intel.com>,
	Li Yang <leoli@freescale.com>, <davem@davemloft.net>
To: <qiang.liu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:26171
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754421Ab2G3Rui (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Jul 2012 13:50:38 -0400
In-Reply-To: <1343380616-12126-1-git-send-email-qiang.liu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

qiang.liu@freescale.com wrote:
> 
> Add memory copy self test when probe device, fsl-dma will be disabled
> if self test failed.

Is this a real problem that can occur?  The DMA driver used to have a
self-test, but I removed it a long time ago because it was pointless.  I
don't see why we need to add another one back in.

-- 
Timur Tabi
Linux kernel developer at Freescale
