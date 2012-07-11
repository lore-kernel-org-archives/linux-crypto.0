From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH 3/4] fsl-dma: support attribute of DMA_MEMORY when
 async_tx enabled
Date: Wed, 11 Jul 2012 02:27:44 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C026E@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1341899997-20879-1-git-send-email-qiang.liu@freescale.com>
 <CABE8wws80A3ne7ay+i5+WeuAnZcwLQoyM4RC7B8UMoHJknGLSQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
 Vinod Koul <vinod.koul@intel.com>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Li Yang-R58472 <r58472@freescale.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CABE8wws80A3ne7ay+i5+WeuAnZcwLQoyM4RC7B8UMoHJknGLSQ@mail.gmail.com>
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

> -----Original Message-----
> From: Dan Williams [mailto:dan.j.williams@intel.com]
> Sent: Wednesday, July 11, 2012 3:39 AM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Li Yang-
> R58472; Phillips Kim-R1AAHA; Vinod Koul
> Subject: Re: [PATCH 3/4] fsl-dma: support attribute of DMA_MEMORY when
> async_tx enabled
> 
> On Mon, Jul 9, 2012 at 10:59 PM, Qiang Liu <qiang.liu@freescale.com>
> wrote:
> > - delete attribute of DMA_INTERRUPT because fsl-dma doesn't support
> > this function, exception will be thrown if talitos is used to compute
> xor
> > at the same time;
> > - change the release process of dma descriptor for avoiding exception
> when
> > enable config NET_DMA, release dma descriptor from 1st to last second,
> the
> > last descriptor which is reserved in current descriptor register may
> not be
> > completed, race condition will be raised if free current descriptor;
> > - use spin_lock_bh to instead of spin_lock_irqsave for improving
> performance;
> >
> > A race condition which is raised when use both of talitos and dmaengine
> to
> > offload xor is because napi scheduler will sync all pending requests in
> dma
> > channels, it will affect the process of raid operations. The descriptor
> is
> > freed which is submitted just now, but async_tx must check whether this
> depend
> > tx descriptor is acked, there are poison contents in the invalid
> address,
> > then BUG_ON() is thrown, so this descriptor will be freed in the next
> time.
> >
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Vinod Koul <vinod.koul@intel.com>
> > Cc: Li Yang <leoli@freescale.com>
> > Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> > ---
> 
> From the description this sounds like 3 or 4 patches.  Can you split it
> up?
I will split this patch according to my description and resend again. Thanks. 
