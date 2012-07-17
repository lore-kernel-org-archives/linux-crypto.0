From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH v3 0/4] Raid: enable talitos xor offload for improving
 performance
Date: Tue, 17 Jul 2012 04:01:57 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C2735@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1342411636-29770-1-git-send-email-qiang.liu@freescale.com>
 <20120716200423.830d174e69fc0aafb40d2858@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	Li Yang-R58472 <r58472@freescale.com>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>
To: Phillips Kim-R1AAHA <R1AAHA@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:27755
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750695Ab2GQECE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Jul 2012 00:02:04 -0400
In-Reply-To: <20120716200423.830d174e69fc0aafb40d2858@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: Phillips Kim-R1AAHA
> Sent: Tuesday, July 17, 2012 9:04 AM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Li Yang-
> R58472; dan.j.williams@intel.com; herbert@gondor.hengli.com.au
> Subject: Re: [PATCH v3 0/4] Raid: enable talitos xor offload for
> improving performance
> 
> On Mon, 16 Jul 2012 12:07:16 +0800
> Qiang Liu <qiang.liu@freescale.com> wrote:
> 
> >  drivers/crypto/Kconfig   |    9 +
> >  drivers/crypto/talitos.c |  410
> +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/crypto/talitos.h |   53 ++++++
> >  drivers/dma/fsldma.c     |  436 +++++++++++++++++++++++++-------------
> --------
> >  drivers/dma/fsldma.h     |    1 +
> >  5 files changed, 708 insertions(+), 201 deletions(-)
> 
> Given the pending talitos patches, this patchseries doesn't apply
> cleanly:  can you rebase onto [1], which is based on Herbert's
> cryptodev tree and contain's Horia's four patches?  They didn't get
> any negative comments, so I assume eventually they will be applied,
> and doing so will make Herbert's life easier.
> 
> I applied the series on Herbert's cryptodev, and while fsldma
> already had this build warning:
> 
> drivers/dma/fsldma.c: In function 'fsl_dma_tx_submit':
> drivers/dma/fsldma.c:636:2: warning: 'cookie' may be used uninitialized
> in this function [-Wuninitialized]
Kim, I will fix it in an another separate patch.

> 
> this patchseries introduces a new one:
> 
> drivers/dma/fsldma.c: In function 'dma_do_tasklet':
> drivers/dma/fsldma.c:1134:16: warning: unused variable 'flags' [-Wunused-
> variable]
Sorry, my bad. I will correct it in v4 5/6 (according to Li Yang's comments,
v3 3/4 should be split up). Thanks.

> 
> I'll wait for a re-post, after these and Ira's comments are
> addressed, before trying to test again.
I agree, I think his comments is very important.

> 
> Thanks,
> 
> Kim
> 
> [1] git://git.freescale.com/crypto/cryptodev.git
