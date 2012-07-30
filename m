From: "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: Re: [linuxppc-release] [PATCH v4 7/7] fsl-dma: add memcpy self
 test interface
Date: Mon, 30 Jul 2012 11:33:23 -0700
Message-ID: <20120730183322.GA32504@ovro.caltech.edu>
References: <1343380616-12126-1-git-send-email-qiang.liu@freescale.com>
 <5016C8F9.7070801@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: qiang.liu@freescale.com, linux-crypto@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, Vinod Koul <vinod.koul@intel.com>,
	herbert@gondor.hengli.com.au,
	Dan Williams <dan.j.williams@intel.com>,
	Li Yang <leoli@freescale.com>, davem@davemloft.net
To: Timur Tabi <timur@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:50928 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742Ab2G3Sd0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Jul 2012 14:33:26 -0400
Content-Disposition: inline
In-Reply-To: <5016C8F9.7070801@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 30, 2012 at 12:48:41PM -0500, Timur Tabi wrote:
> qiang.liu@freescale.com wrote:
> > 
> > Add memory copy self test when probe device, fsl-dma will be disabled
> > if self test failed.
> 
> Is this a real problem that can occur?  The DMA driver used to have a
> self-test, but I removed it a long time ago because it was pointless.  I
> don't see why we need to add another one back in.
> 
> -- 
> Timur Tabi
> Linux kernel developer at Freescale
> 

I made a comment that a test suite for the async_tx API would be very
helpful in diagnosing similar problems in this and other DMA drivers.
Something standalone, similar to the drivers/dma/dmatest.c driver, using
the async_tx API.

I think this was misinterpreted into me asking that the driver have a
built-in self test.

Ira
