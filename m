From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH v7 6/8] fsl-dma: use spin_lock_bh to instead of
 spin_lock_irqsave
Date: Tue, 4 Sep 2012 12:39:58 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70FFB92@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1344500582-11110-1-git-send-email-qiang.liu@freescale.com>
 <CAA9_cmeFamCX1u+z3fP_gxAqe83JFbY9Beqpqgb-PjRoJ8BrWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
 "arnd@arndb.de" <arnd@arndb.de>, "vinod.koul@intel.com" <vinod.koul@intel.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 Tabi Timur-B04825 <B04825@freescale.com>,
 Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "davem@davemloft.net" <davem@davemloft.net>,
 Li Yang-R58472 <r58472@freescale.com>
To: Dan Williams <djbw@fb.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <CAA9_cmeFamCX1u+z3fP_gxAqe83JFbY9Beqpqgb-PjRoJ8BrWA@mail.gmail.com>
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
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On
> Behalf Of Dan Williams
> Sent: Sunday, September 02, 2012 4:41 PM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; linux-
> kernel@vger.kernel.org; vinod.koul@intel.com; Phillips Kim-R1AAHA;
> herbert@gondor.hengli.com.au; davem@davemloft.net; arnd@arndb.de;
> gregkh@linuxfoundation.org; Li Yang-R58472; Tabi Timur-B04825
> Subject: Re: [PATCH v7 6/8] fsl-dma: use spin_lock_bh to instead of
> spin_lock_irqsave
> 
> On Thu, Aug 9, 2012 at 1:23 AM,  <qiang.liu@freescale.com> wrote:
> > From: Qiang Liu <qiang.liu@freescale.com>
> >
> > The use of spin_lock_irqsave() is a stronger locking mechanism than is
> > required throughout the driver. The minimum locking required should be
> > used instead. Interrupts will be turned off and context will be saved,
> > there is needless to use irqsave.
> >
> > Change all instances of spin_lock_irqsave() to spin_lock_bh().
> > All manipulation of protected fields is done using tasklet context or
> > weaker, which makes spin_lock_bh() the correct choice.
> 
> It seems you are coordinating fsl-dma copy and talitos xor operations.
>  It looks like fsl-dma will be called through
> talitos_process_pending()->dma_run_dependencies(), which is
> potentially called in hard irq context.
> 
> This all comes back to the need to fix raid offload to manage the
> channels explicitly rather than the current dependency chains.
So you mean I must implement talitos_run_dependencies() and fsldma_run_dependencies()? Invoke async_tx->callback() respectively.
How about avoiding irq context in talitos?

> 
> --
> Dan
