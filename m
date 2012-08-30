From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH v7 0/8] Raid: enable talitos xor offload for improving
 performance
Date: Thu, 30 Aug 2012 06:20:05 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70FC695@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1344500375-8457-1-git-send-email-qiang.liu@freescale.com>
 <20120809170307.GG14264@ovro.caltech.edu>
 <BCB48C05FCE8BC4D9E61E841ECBE6DB70E3D47@039-SN2MPN1-013.039d.mgd.msft.net>
 <CAA9_cme4tHrx14JaSaHwgcGq79qQK5bv8E205fbC3ega5OpUiQ@mail.gmail.com>
 <BCB48C05FCE8BC4D9E61E841ECBE6DB70FC3CA@039-SN2MPN1-011.039d.mgd.msft.net>
 <1346251975.27020.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 "arnd@arndb.de" <arnd@arndb.de>, "Ira W.
 Snyder" <iws@ovro.caltech.edu>, "vinod.koul@intel.com" <vinod.koul@intel.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: Dan Williams <djbw@fb.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1346251975.27020.2.camel@localhost.localdomain>
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
> From: Dan Williams [mailto:djbw@fb.com]
> Sent: Wednesday, August 29, 2012 10:53 PM
> To: Liu Qiang-B32616
> Cc: vinod.koul@intel.com; arnd@arndb.de; herbert@gondor.apana.org.au;
> gregkh@linuxfoundation.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; linux-crypto@vger.kernel.org; Ira W. Snyder
> Subject: Re: [PATCH v7 0/8] Raid: enable talitos xor offload for
> improving performance
> 
> On Wed, 2012-08-29 at 11:15 +0000, Liu Qiang-B32616 wrote:
> > Hi Dan,
> >
> > Ping?
> > Can you apply these patches? Thanks.
> >
> 
> I'm working my way through them.
> 
> The first thing I notice is that xor_chan->desc_lock is taken
> inconsistently.  I.e. spin_lock_irqsave() in talitos_process_pending()
> and spin_lock_bh() everywhere else.  Have you run these patches with
> lockdep?
Thanks for your reply.
LOCKDEP is enabled as you suggested, there is not any info about "inconsistent lock state" displayed.
I don't know whether it's enough.

I'm confused about the attribute of DMA_INTERRUPT, my understanding is this interface is only used to trigger an interrupt (make sure all former operations are finished before switching to other channels), but fsl-dma will trigger an interrupt by "Programmed Error". I'm wondering whether other hardware are same with fsl-dma (the interrupt is a normal interrupt, but not an error) i.e. xscale-iop?
If other hardware also trigger an interrupt by an abnormal error, maybe my patch 2/8 should be reverted because it violates the rules of this attribute.

BTW, could you please reply in the patch if you have any comments. Thanks.

> 
> --
> Dan
> 
> 
