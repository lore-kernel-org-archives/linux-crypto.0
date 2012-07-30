From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH v4 0/7] Raid: enable talitos xor offload for improving
 performance
Date: Mon, 30 Jul 2012 02:06:10 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C569F@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1343380531-11953-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Li Yang-R58472 <r58472@freescale.com>,
 Phillips Kim-R1AAHA <R1AAHA@freescale.com>
To: Liu Qiang-B32616 <B32616@freescale.com>, "linux-crypto@vger.kernel.org"
 <linux-crypto@vger.kernel.org>, "vinod.koul@intel.com"
 <vinod.koul@intel.com>, "dan.j.williams@intel.com"
 <dan.j.williams@intel.com>, "herbert@gondor.hengli.com.au"
 <herbert@gondor.hengli.com.au>, "linuxppc-dev@lists.ozlabs.org"
 <linuxppc-dev@lists.ozlabs.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1343380531-11953-1-git-send-email-qiang.liu@freescale.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

Hi,

Vinod, Dan, ping?


> -----Original Message-----
> From: linux-crypto-owner@vger.kernel.org [mailto:linux-crypto-
> owner@vger.kernel.org] On Behalf Of qiang.liu@freescale.com
> Sent: Friday, July 27, 2012 5:16 PM
> To: linux-crypto@vger.kernel.org; vinod.koul@intel.com;
> dan.j.williams@intel.com; herbert@gondor.hengli.com.au; linuxppc-
> dev@lists.ozlabs.org
> Cc: Li Yang-R58472; Phillips Kim-R1AAHA
> Subject: [PATCH v4 0/7] Raid: enable talitos xor offload for improving
> performance
> 
> Hi,
> 
> The following 7 patches enabling fsl-dma and talitos offload raid
> operations for improving raid performance and balancing CPU load.
> 
> Write performance will be improved by 25-30% tested by iozone.
> Write performance is improved about 2% after using spin_lock_bh replace
> spin_lock_irqsave.
> CPU load will be reduced by 8%.
> 
> Changes in V4:
> 	- fix an error in talitos when dest addr is same with src addr,
> dest
> 	should be freed only one time if src is same with dest addr;
> 	- correct coding style in fsl-dma according to Ira's comments;
> 	- fix a race condition in fsl-dma fsl_tx_status(), remove the
> interface
> 	which is used to free descriptors in queue ld_completed, this
> interface
> 	has been included in fsldma_cleanup_descriptor(), in v3, there is
> one
> 	place missed spin_lock protect;
> 	- split the original patch 3/4 up to 2 patches 3/7 and 4/7
> according to
> 	Li Yang's comments.
> 	- fix a warning of unitialized cookie;
> 	- add memory copy self test in fsl-dma;
> 	- add more detail description about use spin_lock_bh() to instead
> of
> 	spin_lock_irqsave() according to Timur's comments;
> 
> Changes in v3:
> 	- change release process of fsl-dma descriptor for resolve the
> 	potential race condition
> 	- add test result when use spin_lock_bh replace spin_lock_irqsave
> 	- modify the benchmark results according to the latest patch
> 
> Changes in v2:
> 	- rebase onto cryptodev tree
> 	- split the patch 3/4 up to 3 independent patches
> 	- remove the patch 4/4, the fix is not for cryptodev tree
> 
> 
> Qiang Liu (4):
>       Talitos: Support for async_tx XOR offload
>       fsl-dma: remove attribute DMA_INTERRUPT of dmaengine
>       fsl-dma: change release process of dma descriptor for supporting
> async_tx
>       fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave
> 
> Qiang Liu (7):
>       Talitos: Support for async_tx XOR offload
>       fsl-dma: remove attribute DMA_INTERRUPT of dmaengine
>       fsl-dma: change release process of dma descriptor for supporting
> async_tx
>       fsl-dma: move the function ahead of its invoke function
>       fsl-dma: use spin_lock_bh to instead of spin_lock_irqsave
>       fsl-dma: fix a warning of unitialized cookie
>       fsl-dma: add memcpy self test interface
> 
>  drivers/crypto/Kconfig   |    9 +
>  drivers/crypto/talitos.c |  413 ++++++++++++++++++++++++++++++++++
>  drivers/crypto/talitos.h |   53 +++++
>  drivers/dma/fsldma.c     |  550 +++++++++++++++++++++++++++++-----------
> ------
>  drivers/dma/fsldma.h     |    1 +
>  5 files changed, 822 insertions(+), 204 deletions(-)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
