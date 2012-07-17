From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH v3 0/4] Raid: enable talitos xor offload for improving
 performance
Date: Mon, 16 Jul 2012 20:04:23 -0500
Message-ID: <20120716200423.830d174e69fc0aafb40d2858@freescale.com>
References: <1342411636-29770-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
	<leoli@freescale.com>, <dan.j.williams@intel.com>,
	<herbert@gondor.hengli.com.au>
To: Qiang Liu <qiang.liu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:30679
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753772Ab2GQBG1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Jul 2012 21:06:27 -0400
In-Reply-To: <1342411636-29770-1-git-send-email-qiang.liu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 16 Jul 2012 12:07:16 +0800
Qiang Liu <qiang.liu@freescale.com> wrote:

>  drivers/crypto/Kconfig   |    9 +
>  drivers/crypto/talitos.c |  410 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/crypto/talitos.h |   53 ++++++
>  drivers/dma/fsldma.c     |  436 +++++++++++++++++++++++++---------------------
>  drivers/dma/fsldma.h     |    1 +
>  5 files changed, 708 insertions(+), 201 deletions(-)

Given the pending talitos patches, this patchseries doesn't apply
cleanly:  can you rebase onto [1], which is based on Herbert's
cryptodev tree and contain's Horia's four patches?  They didn't get
any negative comments, so I assume eventually they will be applied,
and doing so will make Herbert's life easier.

I applied the series on Herbert's cryptodev, and while fsldma
already had this build warning:

drivers/dma/fsldma.c: In function 'fsl_dma_tx_submit':
drivers/dma/fsldma.c:636:2: warning: 'cookie' may be used uninitialized in this function [-Wuninitialized]

this patchseries introduces a new one:

drivers/dma/fsldma.c: In function 'dma_do_tasklet':
drivers/dma/fsldma.c:1134:16: warning: unused variable 'flags' [-Wunused-variable]

I'll wait for a re-post, after these and Ira's comments are
addressed, before trying to test again.

Thanks,

Kim

[1] git://git.freescale.com/crypto/cryptodev.git
