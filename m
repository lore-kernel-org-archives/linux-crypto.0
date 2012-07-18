From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH v3 3/4] fsl-dma: change release process of dma
 descriptor for supporting async_tx
Date: Wed, 18 Jul 2012 03:31:49 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C2CF8@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1342411709-29895-1-git-send-email-qiang.liu@freescale.com>
 <20120716200124.GD1227@ovro.caltech.edu>
 <BCB48C05FCE8BC4D9E61E841ECBE6DB70C283D@039-SN2MPN1-011.039d.mgd.msft.net>
 <20120717161653.GA20669@ovro.caltech.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============2246862812048194811=="
Cc: Li Yang-R58472 <r58472@freescale.com>, Vinod Koul <vinod.koul@intel.com>,
 Phillips Kim-R1AAHA <R1AAHA@freescale.com>,
 "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "davem@davemloft.net" <davem@davemloft.net>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>, Dan Williams
 <dan.j.williams@intel.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <20120717161653.GA20669@ovro.caltech.edu>
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

--===============2246862812048194811==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_BCB48C05FCE8BC4D9E61E841ECBE6DB70C2CF8039SN2MPN1011039d_"

--_000_BCB48C05FCE8BC4D9E61E841ECBE6DB70C2CF8039SN2MPN1011039d_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Ira,

My comments inline.

Hi Ira and Dan,

Here is a introduction about my scenario of this case.

My case is use async_tx API to offload raid5,
Use fsl-talitos to compute parity calculation, fsl-dma to process memcpy.

What bug occurred to me?
Exception is thrown by BUG_ON(async_tx_ack_test(depend_tx)) in async_tx_sub=
mit().

TASK =3D ee1a94a0[1390] 'md0_raid5' THREAD: ecf40000 CPU: 0
GPR00: 00000001 ecf41ca0 ee44/921a94a0 0000003f 00000001 c00593e4 00000000 =
00000001
GPR08: 00000000 a7a7a7a7 00000001 045/920000002 42028042 100a38d4 ed576d98 =
00000000
GPR16: ed5a11b0 00000000 2b162000 00000200 046/920000000 2d555000 ed3015e8 =
c15a7aa0
GPR24: 00000000 c155fc40 00000000 ecb63220 ecf41d28 e47/92f640bb0 ef640c30 =
ecf41ca0
NIP [c02b048c] async_tx_submit+0x6c/0x2b4
LR [c02b068c] async_tx_submit+0x26c/0x2b4
Call Trace:
[ecf41ca0] [c02b068c] async_tx_submit+0x26c/0x2b448/92 (unreliable)
[ecf41cd0] [c02b0a4c] async_memcpy+0x240/0x25c
[ecf41d20] [c0421064] async_copy_data+0xa0/0x17c
[ecf41d70] [c0421cf4] __raid_run_ops+0x874/0xe10
[ecf41df0] [c0426ee4] handle_stripe+0x820/0x25e8
[ecf41e90] [c0429080] raid5d+0x3d4/0x5b4
[ecf41f40] [c04329b8] md_thread+0x138/0x16c
[ecf41f90] [c008277c] kthread+0x8c/0x90
[ecf41ff0] [c0011630] kernel_thread+0x4c/0x68

What is the root cause of this bug?
The async_tx descriptor(depend_tx) is free'ed before async_tx_submit ack it=
.
That means async_tx descriptor should be acked before it's free'ed. In othe=
r
word, only ack'ed async_tx descriptor should be free'ed by dma engine.

How to fix it?
Add a queue ld_completed, move all completed descriptors in this queue, fre=
e
these descriptors at a proper time (these descriptors also should be acked)=
.

Dan, do you think my understand about "ack" is right? Thanks.

- Qiang

> -----Original Message-----
> From: Ira W. Snyder [mailto:iws@ovro.caltech.edu]
> Sent: Wednesday, July 18, 2012 12:17 AM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Phillips
> Kim-R1AAHA; herbert@gondor.hengli.com.au; davem@davemloft.net; Dan
> Williams; Vinod Koul; Li Yang-R58472
> Subject: Re: [PATCH v3 3/4] fsl-dma: change release process of dma
> descriptor for supporting async_tx
>
> On Tue, Jul 17, 2012 at 07:06:33AM +0000, Liu Qiang-B32616 wrote:
> > > -----Original Message-----
> > > From: Ira W. Snyder [mailto:iws@ovro.caltech.edu]
> > > Sent: Tuesday, July 17, 2012 4:01 AM
> > > To: Liu Qiang-B32616
> > > Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org;
> Phillips
> > > Kim-R1AAHA; herbert@gondor.hengli.com.au; davem@davemloft.net; Dan
> > > Williams; Vinod Koul; Li Yang-R58472
> > > Subject: Re: [PATCH v3 3/4] fsl-dma: change release process of dma
> > > descriptor for supporting async_tx
> > >
> > > On Mon, Jul 16, 2012 at 12:08:29PM +0800, Qiang Liu wrote:
> > > > Fix the potential risk when enable config NET_DMA and ASYNC_TX.
> > > > Async_tx is lack of support in current release process of dma
> > > > descriptor, all descriptors will be released whatever is acked or
> > > > no-acked by async_tx, so there is a potential race condition when
> dma
> > > > engine is uesd by others clients (e.g. when enable NET_DMA to
> offload
> > > TCP).
> > > >
> > > > In our case, a race condition which is raised when use both of
> talitos
> > > > and dmaengine to offload xor is because napi scheduler will sync
> all
> > > > pending requests in dma channels, it affects the process of raid
> > > > operations due to ack_tx is not checked in fsl dma. The no-acked
> > > > descriptor is freed which is submitted just now, as a dependent tx,
> > > > this freed descriptor trigger
> > > > BUG_ON(async_tx_test_ack(depend_tx)) in async_tx_submit().
> > > >
> > > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > > Cc: Vinod Koul <vinod.koul@intel.com>
> > > > Cc: Li Yang <leoli@freescale.com>
> > > > Cc: Ira W. Snyder <iws@ovro.caltech.edu>
> > > > Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> > > > ---
> > > >  drivers/dma/fsldma.c |  378 +++++++++++++++++++++++++++++---------
> ----
> > > -------
> > > >  drivers/dma/fsldma.h |    1 +
> > > >  2 files changed, 225 insertions(+), 154 deletions(-)
> > > >
> > > > diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c index
> > > > 4f2f212..4ee1b8f 100644
> > > > --- a/drivers/dma/fsldma.c
> > > > +++ b/drivers/dma/fsldma.c
> > > > @@ -400,6 +400,217 @@ out_splice:
> > > >         list_splice_tail_init(&desc->tx_list, &chan->ld_pending);  =
}
> > > >
> > > > +/**
> > > > + * fsl_chan_xfer_ld_queue - transfer any pending transactions
> > > > + * @chan : Freescale DMA channel
> > > > + *
> > > > + * HARDWARE STATE: idle
> > > > + * LOCKING: must hold chan->desc_lock  */ static void
> > > > +fsl_chan_xfer_ld_queue(struct fsldma_chan *chan) {
> > > > +       struct fsl_desc_sw *desc;
> > > > +
> > > > +       /*
> > > > +        * If the list of pending descriptors is empty, then we
> > > > +        * don't need to do any work at all
> > > > +        */
> > > > +       if (list_empty(&chan->ld_pending)) {
> > > > +               chan_dbg(chan, "no pending LDs\n");
> > > > +               return;
> > > > +       }
> > > > +
> > > > +       /*
> > > > +        * The DMA controller is not idle, which means that the
> interrupt
> > > > +        * handler will start any queued transactions when it runs
> after
> > > > +        * this transaction finishes
> > > > +        */
> > > > +       if (!chan->idle) {
> > > > +               chan_dbg(chan, "DMA controller still busy\n");
> > > > +               return;
> > > > +       }
> > > > +
> > > > +       /*
> > > > +        * If there are some link descriptors which have not been
> > > > +        * transferred, we need to start the controller
> > > > +        */
> > > > +
> > > > +       /*
> > > > +        * Move all elements from the queue of pending transactions
> > > > +        * onto the list of running transactions
> > > > +        */
> > > > +       chan_dbg(chan, "idle, starting controller\n");
> > > > +       desc =3D list_first_entry(&chan->ld_pending, struct fsl_des=
c_sw,
> > > node);
> > > > +       list_splice_tail_init(&chan->ld_pending, &chan->ld_running)=
;
> > > > +
> > > > +       /*
> > > > +        * The 85xx DMA controller doesn't clear the channel start
> bit
> > > > +        * automatically at the end of a transfer. Therefore we mus=
t
> clear
> > > > +        * it in software before starting the transfer.
> > > > +        */
> > > > +       if ((chan->feature & FSL_DMA_IP_MASK) =3D=3D FSL_DMA_IP_85X=
X) {
> > > > +               u32 mode;
> > > > +
> > > > +               mode =3D DMA_IN(chan, &chan->regs->mr, 32);
> > > > +               mode &=3D ~FSL_DMA_MR_CS;
> > > > +               DMA_OUT(chan, &chan->regs->mr, mode, 32);
> > > > +       }
> > > > +
> > > > +       /*
> > > > +        * Program the descriptor's address into the DMA controller=
,
> > > > +        * then start the DMA transaction
> > > > +        */
> > > > +       set_cdar(chan, desc->async_tx.phys);
> > > > +       get_cdar(chan);
> > > > +
> > > > +       dma_start(chan);
> > > > +       chan->idle =3D false;
> > > > +}
> > > > +
> > >
> > > Please add a note about the locking requirements here, and for the
> other
> > > new functions you've added.
> > >
> > > You call this function from two places:
> > >
> > > 1) fsldma_cleanup_descriptor() - called with mod->desc_lock held
> > > 2) fsl_tx_status() - WITHOUT mod->desc_lock held
> > >
> > > One of them is definitely wrong, and I'd bet that it is #2. You're
> > > modifying ld_completed without a lock.
> > Yes, My bad, I will correct it.
> >
> > >
> > > > +static int
> > > > +fsldma_clean_completed_descriptor(struct fsldma_chan *chan) {
> > > > +       struct fsl_desc_sw *desc, *_desc;
> > > > +
> > > > +       /* Run the callback for each descriptor, in order */
> > > > +       list_for_each_entry_safe(desc, _desc, &chan->ld_completed,
> node) {
> > > > +
> > > > +               if (async_tx_test_ack(&desc->async_tx)) {
> > > > +                       /* Remove from the list of transactions */
> > > > +                       list_del(&desc->node);
> > > > +#ifdef FSL_DMA_LD_DEBUG
> > > > +                       chan_dbg(chan, "LD %p free\n", desc); #endi=
f
> > > > +                       dma_pool_free(chan->desc_pool, desc,
> > > > +                                       desc->async_tx.phys);
> > > > +               }
> > > > +       }
> > > > +
> > > > +       return 0;
> > > > +}
> > > > +
> > > > +/**
> > > > + * fsldma_run_tx_complete_actions - cleanup and free a single link
> > > > +descriptor
> > > > + * @chan: Freescale DMA channel
> > > > + * @desc: descriptor to cleanup and free
> > > > + * @cookie: Freescale DMA transaction identifier
> > > > + *
> > > > + * This function is used on a descriptor which has been executed
> by
> > > > +the DMA
> > > > + * controller. It will run any callbacks, submit any dependencies,
> > > > +and then
> > > > + * free the descriptor.
> > > > + */
> > > > +static dma_cookie_t fsldma_run_tx_complete_actions(struct
> fsl_desc_sw
> > > *desc,
> > > > +               struct fsldma_chan *chan, dma_cookie_t cookie) {
> > > > +       struct dma_async_tx_descriptor *txd =3D &desc->async_tx;
> > > > +       struct device *dev =3D chan->common.device->dev;
> > > > +       dma_addr_t src =3D get_desc_src(chan, desc);
> > > > +       dma_addr_t dst =3D get_desc_dst(chan, desc);
> > > > +       u32 len =3D get_desc_cnt(chan, desc);
> > > > +
> > > > +       BUG_ON(txd->cookie < 0);
> > > > +
> > > > +       if (txd->cookie > 0) {
> > > > +               cookie =3D txd->cookie;
> > > > +
> > > > +               /* Run the link descriptor callback function */
> > > > +               if (txd->callback) {
> > > > +#ifdef FSL_DMA_LD_DEBUG
> > > > +                       chan_dbg(chan, "LD %p callback\n", desc); #=
endif
> > > > +                       txd->callback(txd->callback_param);
> > > > +               }
> > > > +
> > > > +               /* Unmap the dst buffer, if requested */
> > > > +               if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
> > > > +                       if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGL=
E)
> > > > +                               dma_unmap_single(dev, dst, len,
> DMA_FROM_DEVICE);
> > > > +                       else
> > > > +                               dma_unmap_page(dev, dst, len,
> DMA_FROM_DEVICE);
> > > > +               }
> > > > +
> > > > +               /* Unmap the src buffer, if requested */
> > > > +               if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
> > > > +                       if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE=
)
> > > > +                               dma_unmap_single(dev, src, len,
> DMA_TO_DEVICE);
> > > > +                       else
> > > > +                               dma_unmap_page(dev, src, len,
> DMA_TO_DEVICE);
> > > > +               }
> > > > +       }
> > > > +
> > > > +       /* Run any dependencies */
> > > > +       dma_run_dependencies(txd);
> > > > +
> > > > +       return cookie;
> > > > +}
> > > > +
> > > > +static int
> > > > +fsldma_clean_running_descriptor(struct fsl_desc_sw *desc,
> > > > +                       struct fsldma_chan *chan)
> > > > +{
> > > > +       /* Remove from the list of transactions */
> > > > +       list_del(&desc->node);
> > > > +       /* the client is allowed to attach dependent operations
> > > > +        * until 'ack' is set
> > > > +        */
> > >
> > > This comment is does not follow the coding style. It should be:
> > >
> > > /*
> > >  * the client is allowed to attech dependent operations
> > >  * until 'ack' is set
> > >  */
> > Fine, I will correct it in v4. Include another 2 places related to
> coding style.
> > Thanks.
> >
> > >
> > > > +       if (!async_tx_test_ack(&desc->async_tx)) {
> > > > +               /* move this slot to the completed */
> > >
> > > Perhaps a better comment would be:
> > >
> > > Move this descriptor to the list of descriptors which is complete,
> but
> > > still awaiting the 'ack' bit to be set.
> > Accept.
> >
> > >
> > > > +               list_add_tail(&desc->node, &chan->ld_completed);
> > > > +               return 0;
> > > > +       }
> > > > +
> > > > +       dma_pool_free(chan->desc_pool, desc,
> > > > +                       desc->async_tx.phys);
> > >
> > > This should all be on one line. It is less than 80 characters wide.
> > >
> > Accept.
> >
> > > > +       return 0;
> > > > +}
> > > > +
> > >
> > > Locking notes please.
> > I will add it in v4, please check. Thanks.
> >
> > >
> > > > +static void fsldma_cleanup_descriptor(struct fsldma_chan *chan) {
> > > > +       struct fsl_desc_sw *desc, *_desc;
> > > > +       dma_cookie_t cookie =3D 0;
> > > > +       dma_addr_t curr_phys =3D get_cdar(chan);
> > > > +       int idle =3D dma_is_idle(chan);
> > > > +       int seen_current =3D 0;
> > > > +
> > > > +       fsldma_clean_completed_descriptor(chan);
> > > > +
> > > > +       /* Run the callback for each descriptor, in order */
> > > > +       list_for_each_entry_safe(desc, _desc, &chan->ld_running, no=
de)
> {
> > > > +               /* do not advance past the current descriptor loade=
d
> into the
> > > > +                * hardware channel, subsequent descriptors are eit=
her
> in
> > > > +                * process or have not been submitted
> > > > +                */
> > >
> > > Coding style.
> > >
> > > > +               if (seen_current)
> > > > +                       break;
> > > > +
> > > > +               /* stop the search if we reach the current descript=
or
> and the
> > > > +                * channel is busy
> > > > +                */
> > >
> > > Coding style.
> > >
> > > > +               if (desc->async_tx.phys =3D=3D curr_phys) {
> > > > +                       seen_current =3D 1;
> > > > +                       if (!idle)
> > > > +                               break;
> > > > +               }
> > > > +
> > >
> > > This trick where you try to look at the hardware state to determine
> how
> > > much to clean up has been a source of headaches in the past versions
> of
> > > this driver.
> > I know a little about the history of this driver. Could you tell me
> what kind
> > headaches in the past versions, I can have a test and fix it in my
> patch. And
> > I also think use current phys addr should be more explicit.
> > Thanks.
> >
>
> It has been a very long time since I last worked on this code, but I
> will try to remember.
>
> I remember one problem where the currently running descriptor was free'd
> while the hardware was still executing it.
>
> There was another related problem where the DMA hardware would lock up,
> and it is impossible to recover without a hard reset. The CB (channel
> busy) bit gets stuck on, and the running transfer never completes. This
> may have been due to a programming issue in a user of the DMAEngine API,
> and not this driver itself. I don't remember for sure anymore.
>
> Our current system here at work has 120 boards with this DMA controller.
> Each one runs 100+ DMA operations per second, 24/7/365. They've been
> online for more than two years. I know for sure that the current code
> doesn't lock up the DMA controller. :)
>
> I think your bug is real, and needs to be fixed. I'm just trying to make
> sure I understand the change, so it won't break other users. I'm only
> trying to help.
Thanks for your information. I will do more explanation of my idea in the
following answer.
Could you provide some sample code for reproduce bug, I don't know dmatest.=
c
whether is enough. I will add dma self test in fsldma.c.

>
> > >
> > > It is much easier to reason about the state of the hardware and avoid
> > > race conditions if you complete entire blocks of descriptors after
> the
> > > hardware interrupts you to tell you it is finished.
> > In current driver, it's ok, but there is a potential issue when enable
> > async_tx api. How can you determine these descriptors in ld_running
> whether
> > have been completed in fsl_tx_status()? (I mean in my patch.)
> >
>
> I think your idea using an ld_completed list for descriptors which have
> been run by the hardware, but not yet 'ack'ed by software is fine.
>
> Would something similar to the following work?
>
> ld_pending: build a list of descriptors until issue_pending() is called.
> This is exactly what it does now, no changes needed.
Yes, no changes.

>
> ld_running: this list of descriptors is currently executing. Mostly
> unchanged from how it works now.
Yes, no changes.
I will add descriptions about all new interfaces.

>
> When you get an interrupt, you know the descriptors in ld_running are
> finished. Update the cookie to the highest number from ld_running. Free
> the descriptors which have been 'ack'ed immediately. Move the ones which
> are not 'ack'ed onto ld_completed. As part of this process, you should
> run dma_run_dependencies() and callbacks as needed.
Right, below is new implement of dma_do_tasklet();
First, dma_do_tasklet()
        -> fsldma_cleanup_descriptor()
                -> fsldma_clean_completed_descriptor(), free the descriptor=
s which has been ack'ed (I mean in queue ld_completed, not include other qu=
eues);
Second, transverse the queue ld_running
        -> fsldma_run_tx_complete_actions(), find the last descriptor which=
 is completed, update the cookie to the highest number, run callback, unmap=
 dma pages, and run dma_run_dependencies();
        -> fsldma_clean_running_descriptor(), move this descriptor from ld_=
running to ld_completed.
Last,
        -> fsl_chan_xfer_ld_queue(), submit much more descriptors from ld_p=
ending to ld_running.
I hope my description is clear enough.

>
> I think that this solves the problem you are seeing, which is that
> descriptors which have not been 'ack'ed are free'd.
>
> If this is unclear, I can write some code to demonstrate. If you could
> write a small test driver, similar to drivers/dma/dmatest.c, which tests
> the async_tx API without any extra hardware needed, I can run it. I have
> never used the async_tx API before.
Your description is clear, I agree with you, I will add fsldma self test in
the file.

>
> > >
> > > This is the philosophy employed by the driver before your
> modifications:
> > > ld_pending: a block of descriptors which is ready to run as soon as
> the
> > > hardware becomes idle.
> > > ld_running: a block of descriptors which is being executed by the
> > > hardware.
> > These 2 lists are not enough, async_tx descriptors must be kept order
> as
> > expected of its submitter, we only can process the descriptor which has
> been
> > acked by async_tx api, but not free all descriptors in ld_running.
> > For example,
> > Step 1, in async_tx memcpy api,
> > tx2 =3D device->device_prep_dma_memcpy(...),
> > tx2->depend_tx =3D tx1;
> > step 2, in async_tx submit api,
> > async_tx_submit() will check tx2->depend_tx whether has been acked,
> > unfortunately, tx2->depend_tx is freed before step 2 (dma channels is
> flushed
> > by other drivers), the contents of tx2->depend_tx is set to
> POOL_POISON_FREED
> > if DMAPOOL_DEBUG is enabled (illegal pointer will be used if disable
> this config
> > option);
> > step 3, BUG_ON(async_tx_test_ack(depend_tx)) is triggered.
> >
> > For resolve this potential risk, first, ack flag must be checked in dma
> driver,
> > second, ld_completed is added to restore all descriptors which have
> been acked
> > and completed.
> > In my following answer, most of all are around this idea.
> >
> > >
> > > > +               cookie =3D fsldma_run_tx_complete_actions(desc, cha=
n,
> cookie);
> > > > +
> > > > +               if (fsldma_clean_running_descriptor(desc, chan))
> > > > +                       break;
> > > > +
> > > > +       }
> > > > +
> > > > +       /*
> > > > +        * Start any pending transactions automatically
> > > > +        *
> > > > +        * In the ideal case, we keep the DMA controller busy while
> we go
> > > > +        * ahead and free the descriptors below.
> > > > +        */
> > > > +       fsl_chan_xfer_ld_queue(chan);
> > > > +
> > > > +       if (cookie > 0)
> > > > +               chan->common.completed_cookie =3D cookie; }
> > > > +
> > > >  static dma_cookie_t fsl_dma_tx_submit(struct
> dma_async_tx_descriptor
> > > > *tx)  {
> > > >         struct fsldma_chan *chan =3D to_fsl_chan(tx->chan); @@ -534=
,8
> +745,10
> > > > @@ static void fsl_dma_free_chan_resources(struct dma_chan *dchan)
> > > >
> > > >         chan_dbg(chan, "free all channel resources\n");
> > > >         spin_lock_irqsave(&chan->desc_lock, flags);
> > > > +       fsldma_cleanup_descriptor(chan);
> > > >         fsldma_free_desc_list(chan, &chan->ld_pending);
> > > >         fsldma_free_desc_list(chan, &chan->ld_running);
> > > > +       fsldma_free_desc_list(chan, &chan->ld_completed);
> > > >         spin_unlock_irqrestore(&chan->desc_lock, flags);
> > > >
> > > >         dma_pool_destroy(chan->desc_pool);
> > > > @@ -811,124 +1024,6 @@ static int fsl_dma_device_control(struct
> > > > dma_chan *dchan,  }
> > > >
> > > >  /**
> > > > - * fsldma_cleanup_descriptor - cleanup and free a single link
> > > > descriptor
> > > > - * @chan: Freescale DMA channel
> > > > - * @desc: descriptor to cleanup and free
> > > > - *
> > > > - * This function is used on a descriptor which has been executed
> by
> > > > the DMA
> > > > - * controller. It will run any callbacks, submit any dependencies,
> > > > and then
> > > > - * free the descriptor.
> > > > - */
> > > > -static void fsldma_cleanup_descriptor(struct fsldma_chan *chan,
> > > > -                                     struct fsl_desc_sw *desc)
> > > > -{
> > > > -       struct dma_async_tx_descriptor *txd =3D &desc->async_tx;
> > > > -       struct device *dev =3D chan->common.device->dev;
> > > > -       dma_addr_t src =3D get_desc_src(chan, desc);
> > > > -       dma_addr_t dst =3D get_desc_dst(chan, desc);
> > > > -       u32 len =3D get_desc_cnt(chan, desc);
> > > > -
> > > > -       /* Run the link descriptor callback function */
> > > > -       if (txd->callback) {
> > > > -#ifdef FSL_DMA_LD_DEBUG
> > > > -               chan_dbg(chan, "LD %p callback\n", desc);
> > > > -#endif
> > > > -               txd->callback(txd->callback_param);
> > > > -       }
> > > > -
> > > > -       /* Run any dependencies */
> > > > -       dma_run_dependencies(txd);
> > > > -
> > > > -       /* Unmap the dst buffer, if requested */
> > > > -       if (!(txd->flags & DMA_COMPL_SKIP_DEST_UNMAP)) {
> > > > -               if (txd->flags & DMA_COMPL_DEST_UNMAP_SINGLE)
> > > > -                       dma_unmap_single(dev, dst, len, DMA_FROM_DE=
VICE);
> > > > -               else
> > > > -                       dma_unmap_page(dev, dst, len, DMA_FROM_DEVI=
CE);
> > > > -       }
> > > > -
> > > > -       /* Unmap the src buffer, if requested */
> > > > -       if (!(txd->flags & DMA_COMPL_SKIP_SRC_UNMAP)) {
> > > > -               if (txd->flags & DMA_COMPL_SRC_UNMAP_SINGLE)
> > > > -                       dma_unmap_single(dev, src, len, DMA_TO_DEVI=
CE);
> > > > -               else
> > > > -                       dma_unmap_page(dev, src, len, DMA_TO_DEVICE=
);
> > > > -       }
> > > > -
> > > > -#ifdef FSL_DMA_LD_DEBUG
> > > > -       chan_dbg(chan, "LD %p free\n", desc);
> > > > -#endif
> > > > -       dma_pool_free(chan->desc_pool, desc, txd->phys);
> > > > -}
> > > > -
> > > > -/**
> > > > - * fsl_chan_xfer_ld_queue - transfer any pending transactions
> > > > - * @chan : Freescale DMA channel
> > > > - *
> > > > - * HARDWARE STATE: idle
> > > > - * LOCKING: must hold chan->desc_lock
> > > > - */
> > > > -static void fsl_chan_xfer_ld_queue(struct fsldma_chan *chan) -{
> > > > -       struct fsl_desc_sw *desc;
> > > > -
> > > > -       /*
> > > > -        * If the list of pending descriptors is empty, then we
> > > > -        * don't need to do any work at all
> > > > -        */
> > > > -       if (list_empty(&chan->ld_pending)) {
> > > > -               chan_dbg(chan, "no pending LDs\n");
> > > > -               return;
> > > > -       }
> > > > -
> > > > -       /*
> > > > -        * The DMA controller is not idle, which means that the
> interrupt
> > > > -        * handler will start any queued transactions when it runs
> after
> > > > -        * this transaction finishes
> > > > -        */
> > > > -       if (!chan->idle) {
> > > > -               chan_dbg(chan, "DMA controller still busy\n");
> > > > -               return;
> > > > -       }
> > > > -
> > > > -       /*
> > > > -        * If there are some link descriptors which have not been
> > > > -        * transferred, we need to start the controller
> > > > -        */
> > > > -
> > > > -       /*
> > > > -        * Move all elements from the queue of pending transactions
> > > > -        * onto the list of running transactions
> > > > -        */
> > > > -       chan_dbg(chan, "idle, starting controller\n");
> > > > -       desc =3D list_first_entry(&chan->ld_pending, struct fsl_des=
c_sw,
> > > node);
> > > > -       list_splice_tail_init(&chan->ld_pending, &chan->ld_running)=
;
> > > > -
> > > > -       /*
> > > > -        * The 85xx DMA controller doesn't clear the channel start
> bit
> > > > -        * automatically at the end of a transfer. Therefore we mus=
t
> clear
> > > > -        * it in software before starting the transfer.
> > > > -        */
> > > > -       if ((chan->feature & FSL_DMA_IP_MASK) =3D=3D FSL_DMA_IP_85X=
X) {
> > > > -               u32 mode;
> > > > -
> > > > -               mode =3D DMA_IN(chan, &chan->regs->mr, 32);
> > > > -               mode &=3D ~FSL_DMA_MR_CS;
> > > > -               DMA_OUT(chan, &chan->regs->mr, mode, 32);
> > > > -       }
> > > > -
> > > > -       /*
> > > > -        * Program the descriptor's address into the DMA controller=
,
> > > > -        * then start the DMA transaction
> > > > -        */
> > > > -       set_cdar(chan, desc->async_tx.phys);
> > > > -       get_cdar(chan);
> > > > -
> > > > -       dma_start(chan);
> > > > -       chan->idle =3D false;
> > > > -}
> > > > -
> > > > -/**
> > > >   * fsl_dma_memcpy_issue_pending - Issue the DMA start command
> > > >   * @chan : Freescale DMA channel
> > > >   */
> > > > @@ -954,11 +1049,17 @@ static enum dma_status fsl_tx_status(struct
> > > dma_chan *dchan,
> > > >         enum dma_status ret;
> > > >         unsigned long flags;
> > > >
> > > > -       spin_lock_irqsave(&chan->desc_lock, flags);
> > > >         ret =3D dma_cookie_status(dchan, cookie, txstate);
> > > > +       if (ret =3D=3D DMA_SUCCESS) {
> > > > +               fsldma_clean_completed_descriptor(chan);
> > > > +               return ret;
> > > > +       }
> > > > +
> > > > +       spin_lock_irqsave(&chan->desc_lock, flags);
> > > > +       fsldma_cleanup_descriptor(chan);
> > >
> > > You've made status from a very quick operation (compare two cookies)
> into
> > > a potentially long running operation. It may now run callbacks, unmap
> > > pages, etc.
> > Yes, that's right, callbacks and unmap pages will be invoked if DMA
> status
> > is not DMA_SUCCESS.
> >
> > >
> > > I note that Documentation/crypto/async-tx-api.txt section 3.6
> > > "Constraints" does say that async_*() functions cannot be called from
> IRQ
> > > context. However, the DMAEngine API itself does not have anything to
> say
> > > about IRQ context.
> > >
> > > I expect fsl_tx_status() to be quick, and not potentially call other
> > > arbitrary code.
> > fsl_tx_status() is not in IRQ context. It's reasonable to unmap pages
> and
> > run dependency of descriptor as fsldma_run_tx_complete_actions() does.
> >
>
> I looked at several other DMAEngine API drivers. Some of them do run
> dependencies and callbacks from tx_status(). You are correct, this is
> fine.
>
> > >
> > > Is it possible to leave this function unchanged?
> > According to my knowledge, it is unlikely to be left unchanged, or it
> will violate
> > the design of this interface. If DMA status is not DMA_SUCCESS, that
> means there
> > are new descriptors completed, we should move them to ld_completed, and
> do actions
> > to its async_tx descriptors, then dma descriptor will be freed at
> another time.
> > Most of my idea is from iop-adma.c, the original interface is not align
> with it.
> > Async_tx flags (expecially ack_test) is not considered when dma
> descriptor is freed,
> > so some random errors happened, I think you must familiar with this
> history.
> > As an important "synchronization flag", async_tx api must control the
> order of tx
> > descriptor. Dma driver also should make sure keeping order when free
> the descriptor.
> > That's the reason why I add ld_completed list.
> >
>
> Is it possible to put the descriptors into three different states?
>
> 1) ld_pending: ready to run, but not yet executed on the hardware
>
> Descriptors move to #2 through either dma_async_issue_pending() or by
> the interrupt which happens when the hardware completes executing a set
> of DMA descriptors.
>
> 2) ld_running: currently executing on the hardware
>
> Descriptors move to #3 through the interrupt which happens when the
> hardware completes executing a set of DMA descriptors.
>
> Dependencies and callbacks are executed as the descriptors are moved
> onto ld_completed.
>
> 3) ld_completed: finished executing on the hardware, but not yet 'ack'ed
>
> When they have been 'ack'ed, the descriptors are free'd.
>
>
> As noted above, I think I could code this up fairly quickly if this
> explanation is unclear.
Totally right. I think you understand my idea.

>
> Also note that I may not understand your bug completely, and my idea may
> be completely wrong!
I hope you've already understand my issue:)
Thanks.

>
> Ira
>
> > >
> > > Also note that if you leave this function unchanged, the locking
> error
> > > pointed out above (fsldma_clean_completed_descriptor() is not called
> with
> > > the lock held) goes away.
> > I know. Thanks.
> >
> > >
> > > >         spin_unlock_irqrestore(&chan->desc_lock, flags);
> > > >
> > > > -       return ret;
> > > > +       return dma_cookie_status(dchan, cookie, txstate);
> > > >  }
> > > >
> > > >
> > > > /*-----------------------------------------------------------------
> ---
> > > > --------*/ @@ -1035,53 +1136,21 @@ static irqreturn_t
> > > > fsldma_chan_irq(int irq, void *data)  static void
> > > > dma_do_tasklet(unsigned long data)  {
> > > >         struct fsldma_chan *chan =3D (struct fsldma_chan *)data;
> > > > -       struct fsl_desc_sw *desc, *_desc;
> > > > -       LIST_HEAD(ld_cleanup);
> > > >         unsigned long flags;
> > > >
> > > >         chan_dbg(chan, "tasklet entry\n");
> > > >
> > > >         spin_lock_irqsave(&chan->desc_lock, flags);
> > > >
> > > > -       /* update the cookie if we have some descriptors to cleanup
> */
> > > > -       if (!list_empty(&chan->ld_running)) {
> > > > -               dma_cookie_t cookie;
> > > > -
> > > > -               desc =3D to_fsl_desc(chan->ld_running.prev);
> > > > -               cookie =3D desc->async_tx.cookie;
> > > > -               dma_cookie_complete(&desc->async_tx);
> > > > -
> > > > -               chan_dbg(chan, "completed_cookie=3D%d\n", cookie);
> > > > -       }
> > > > -
> > > > -       /*
> > > > -        * move the descriptors to a temporary list so we can drop
> the lock
> > > > -        * during the entire cleanup operation
> > > > -        */
> > > > -       list_splice_tail_init(&chan->ld_running, &ld_cleanup);
> > > > +       /* Run all cleanup for this descriptor */
> > > > +       fsldma_cleanup_descriptor(chan);
> > > >
> > > >         /* the hardware is now idle and ready for more */
> > > >         chan->idle =3D true;
> > > >
> > > > -       /*
> > > > -        * Start any pending transactions automatically
> > > > -        *
> > > > -        * In the ideal case, we keep the DMA controller busy while
> we go
> > > > -        * ahead and free the descriptors below.
> > > > -        */
> > > >         fsl_chan_xfer_ld_queue(chan);
> > > >         spin_unlock_irqrestore(&chan->desc_lock, flags);
> > > >
> > > > -       /* Run the callback for each descriptor, in order */
> > > > -       list_for_each_entry_safe(desc, _desc, &ld_cleanup, node) {
> > > > -
> > > > -               /* Remove from the list of transactions */
> > > > -               list_del(&desc->node);
> > > > -
> > > > -               /* Run all cleanup for this descriptor */
> > > > -               fsldma_cleanup_descriptor(chan, desc);
> > > > -       }
> > > > -
> > > >         chan_dbg(chan, "tasklet exit\n");
> > > >  }
> > > >
> > > > @@ -1262,6 +1331,7 @@ static int __devinit
> fsl_dma_chan_probe(struct
> > > fsldma_device *fdev,
> > > >         spin_lock_init(&chan->desc_lock);
> > > >         INIT_LIST_HEAD(&chan->ld_pending);
> > > >         INIT_LIST_HEAD(&chan->ld_running);
> > > > +       INIT_LIST_HEAD(&chan->ld_completed);
> > > >         chan->idle =3D true;
> > > >
> > > >         chan->common.device =3D &fdev->common; diff --git
> > > > a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h index
> f5c3879..7ede908
> > > > 100644
> > > > --- a/drivers/dma/fsldma.h
> > > > +++ b/drivers/dma/fsldma.h
> > > > @@ -140,6 +140,7 @@ struct fsldma_chan {
> > > >         spinlock_t desc_lock;           /* Descriptor operation loc=
k */
> > > >         struct list_head ld_pending;    /* Link descriptors queue *=
/
> > > >         struct list_head ld_running;    /* Link descriptors queue *=
/
> > > > +       struct list_head ld_completed;  /* Link descriptors queue
> */
> > > >         struct dma_chan common;         /* DMA common channel */
> > > >         struct dma_pool *desc_pool;     /* Descriptors pool */
> > > >         struct device *dev;             /* Channel device */
> > > > --
> > > > 1.7.5.1
> > > >
> > > >
> >
> >



--_000_BCB48C05FCE8BC4D9E61E841ECBE6DB70C2CF8039SN2MPN1011039d_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dus-ascii"=
>
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from rtf -->
<style><!-- .EmailQuote { margin-left: 1pt; padding-left: 4pt; border-left:=
 #800000 2px solid; } --></style>
</head>
<body>
<font face=3D"Consolas" size=3D"2"><span style=3D"font-size:10.5pt;">
<div>Hi Ira,</div>
<div>&nbsp;</div>
<div>My comments inline.</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>Hi Ira and Dan,</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>Here is a introduction about my scenario of this case.</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>My case is use async_tx API to offload raid5,</div>
<div>Use fsl-talitos to compute parity calculation, fsl-dma to process memc=
py.</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>What bug occurred to me?</div>
<div>Exception is thrown by BUG_ON(async_tx_ack_test(depend_tx)) in async_t=
x_submit().</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>TASK =3D ee1a94a0[1390] 'md0_raid5' THREAD: ecf40000 CPU: 0</div>
<div>GPR00: 00000001 ecf41ca0 ee44/921a94a0 0000003f 00000001 c00593e4 0000=
0000 00000001 </div>
<div>GPR08: 00000000 a7a7a7a7 00000001 045/920000002 42028042 100a38d4 ed57=
6d98 00000000 </div>
<div>GPR16: ed5a11b0 00000000 2b162000 00000200 046/920000000 2d555000 ed30=
15e8 c15a7aa0 </div>
<div>GPR24: 00000000 c155fc40 00000000 ecb63220 ecf41d28 e47/92f640bb0 ef64=
0c30 ecf41ca0 </div>
<div>NIP [c02b048c] async_tx_submit&#43;0x6c/0x2b4</div>
<div>LR [c02b068c] async_tx_submit&#43;0x26c/0x2b4</div>
<div>Call Trace:</div>
<div>[ecf41ca0] [c02b068c] async_tx_submit&#43;0x26c/0x2b448/92 (unreliable=
)</div>
<div>[ecf41cd0] [c02b0a4c] async_memcpy&#43;0x240/0x25c</div>
<div>[ecf41d20] [c0421064] async_copy_data&#43;0xa0/0x17c</div>
<div>[ecf41d70] [c0421cf4] __raid_run_ops&#43;0x874/0xe10</div>
<div>[ecf41df0] [c0426ee4] handle_stripe&#43;0x820/0x25e8</div>
<div>[ecf41e90] [c0429080] raid5d&#43;0x3d4/0x5b4</div>
<div>[ecf41f40] [c04329b8] md_thread&#43;0x138/0x16c</div>
<div>[ecf41f90] [c008277c] kthread&#43;0x8c/0x90</div>
<div>[ecf41ff0] [c0011630] kernel_thread&#43;0x4c/0x68</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>What is the root cause of this bug?</div>
<div>The async_tx descriptor(depend_tx) is free'ed before async_tx_submit a=
ck it.</div>
<div>That means async_tx descriptor should be acked before it's free'ed. In=
 other</div>
<div>word, only ack'ed async_tx descriptor should be free'ed by dma engine.=
</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>How to fix it?</div>
<div>Add a queue ld_completed, move all completed descriptors in this queue=
, free</div>
<div>these descriptors at a proper time (these descriptors also should be a=
cked).</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>Dan, do you think my understand about &quot;ack&quot; is right? Thanks=
. </div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>- Qiang</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>&gt; -----Original Message-----</div>
<div>&gt; From: Ira W. Snyder [<a href=3D"mailto:iws@ovro.caltech.edu">mail=
to:iws@ovro.caltech.edu</a>]</div>
<div>&gt; Sent: Wednesday, July 18, 2012 12:17 AM</div>
<div>&gt; To: Liu Qiang-B32616</div>
<div>&gt; Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; =
Phillips</div>
<div>&gt; Kim-R1AAHA; herbert@gondor.hengli.com.au; davem@davemloft.net; Da=
n</div>
<div>&gt; Williams; Vinod Koul; Li Yang-R58472</div>
<div>&gt; Subject: Re: [PATCH v3 3/4] fsl-dma: change release process of dm=
a</div>
<div>&gt; descriptor for supporting async_tx</div>
<div>&gt; </div>
<div>&gt; On Tue, Jul 17, 2012 at 07:06:33AM &#43;0000, Liu Qiang-B32616 wr=
ote:</div>
<div>&gt; &gt; &gt; -----Original Message-----</div>
<div>&gt; &gt; &gt; From: Ira W. Snyder [<a href=3D"mailto:iws@ovro.caltech=
.edu">mailto:iws@ovro.caltech.edu</a>]</div>
<div>&gt; &gt; &gt; Sent: Tuesday, July 17, 2012 4:01 AM</div>
<div>&gt; &gt; &gt; To: Liu Qiang-B32616</div>
<div>&gt; &gt; &gt; Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.oz=
labs.org;</div>
<div>&gt; Phillips</div>
<div>&gt; &gt; &gt; Kim-R1AAHA; herbert@gondor.hengli.com.au; davem@davemlo=
ft.net; Dan</div>
<div>&gt; &gt; &gt; Williams; Vinod Koul; Li Yang-R58472</div>
<div>&gt; &gt; &gt; Subject: Re: [PATCH v3 3/4] fsl-dma: change release pro=
cess of dma</div>
<div>&gt; &gt; &gt; descriptor for supporting async_tx</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; On Mon, Jul 16, 2012 at 12:08:29PM &#43;0800, Qiang Liu=
 wrote:</div>
<div>&gt; &gt; &gt; &gt; Fix the potential risk when enable config NET_DMA =
and ASYNC_TX.</div>
<div>&gt; &gt; &gt; &gt; Async_tx is lack of support in current release pro=
cess of dma</div>
<div>&gt; &gt; &gt; &gt; descriptor, all descriptors will be released whate=
ver is acked or</div>
<div>&gt; &gt; &gt; &gt; no-acked by async_tx, so there is a potential race=
 condition when</div>
<div>&gt; dma</div>
<div>&gt; &gt; &gt; &gt; engine is uesd by others clients (e.g. when enable=
 NET_DMA to</div>
<div>&gt; offload</div>
<div>&gt; &gt; &gt; TCP).</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; In our case, a race condition which is raised when=
 use both of</div>
<div>&gt; talitos</div>
<div>&gt; &gt; &gt; &gt; and dmaengine to offload xor is because napi sched=
uler will sync</div>
<div>&gt; all</div>
<div>&gt; &gt; &gt; &gt; pending requests in dma channels, it affects the p=
rocess of raid</div>
<div>&gt; &gt; &gt; &gt; operations due to ack_tx is not checked in fsl dma=
. The no-acked</div>
<div>&gt; &gt; &gt; &gt; descriptor is freed which is submitted just now, a=
s a dependent tx,</div>
<div>&gt; &gt; &gt; &gt; this freed descriptor trigger</div>
<div>&gt; &gt; &gt; &gt; BUG_ON(async_tx_test_ack(depend_tx)) in async_tx_s=
ubmit().</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; Cc: Dan Williams &lt;dan.j.williams@intel.com&gt;<=
/div>
<div>&gt; &gt; &gt; &gt; Cc: Vinod Koul &lt;vinod.koul@intel.com&gt;</div>
<div>&gt; &gt; &gt; &gt; Cc: Li Yang &lt;leoli@freescale.com&gt;</div>
<div>&gt; &gt; &gt; &gt; Cc: Ira W. Snyder &lt;iws@ovro.caltech.edu&gt;</di=
v>
<div>&gt; &gt; &gt; &gt; Signed-off-by: Qiang Liu &lt;qiang.liu@freescale.c=
om&gt;</div>
<div>&gt; &gt; &gt; &gt; ---</div>
<div>&gt; &gt; &gt; &gt;&nbsp; drivers/dma/fsldma.c |&nbsp; 378 &#43;&#43;&=
#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&=
#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;&#43;---------</div>
<div>&gt; ----</div>
<div>&gt; &gt; &gt; -------</div>
<div>&gt; &gt; &gt; &gt;&nbsp; drivers/dma/fsldma.h |&nbsp;&nbsp;&nbsp; 1 &=
#43;</div>
<div>&gt; &gt; &gt; &gt;&nbsp; 2 files changed, 225 insertions(&#43;), 154 =
deletions(-)</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; diff --git a/drivers/dma/fsldma.c b/drivers/dma/fs=
ldma.c index</div>
<div>&gt; &gt; &gt; &gt; 4f2f212..4ee1b8f 100644</div>
<div>&gt; &gt; &gt; &gt; --- a/drivers/dma/fsldma.c</div>
<div>&gt; &gt; &gt; &gt; &#43;&#43;&#43; b/drivers/dma/fsldma.c</div>
<div>&gt; &gt; &gt; &gt; @@ -400,6 &#43;400,217 @@ out_splice:</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; list_splice_tail_init(&amp;desc-&gt;tx_list, &amp;chan-&gt;ld_pending);=
&nbsp; }</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; &#43;/**</div>
<div>&gt; &gt; &gt; &gt; &#43; * fsl_chan_xfer_ld_queue - transfer any pend=
ing transactions</div>
<div>&gt; &gt; &gt; &gt; &#43; * @chan : Freescale DMA channel</div>
<div>&gt; &gt; &gt; &gt; &#43; *</div>
<div>&gt; &gt; &gt; &gt; &#43; * HARDWARE STATE: idle</div>
<div>&gt; &gt; &gt; &gt; &#43; * LOCKING: must hold chan-&gt;desc_lock&nbsp=
; */ static void</div>
<div>&gt; &gt; &gt; &gt; &#43;fsl_chan_xfer_ld_queue(struct fsldma_chan *ch=
an) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct f=
sl_desc_sw *desc;</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
If the list of pending descriptors is empty, then we</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
don't need to do any work at all</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */=
</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (list=
_empty(&amp;chan-&gt;ld_pending)) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan_dbg(chan, &quot;no pending LDs=
\n&quot;);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
The DMA controller is not idle, which means that the</div>
<div>&gt; interrupt</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
handler will start any queued transactions when it runs</div>
<div>&gt; after</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
this transaction finishes</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */=
</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!cha=
n-&gt;idle) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan_dbg(chan, &quot;DMA controller=
 still busy\n&quot;);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
If there are some link descriptors which have not been</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
transferred, we need to start the controller</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */=
</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
Move all elements from the queue of pending transactions</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
onto the list of running transactions</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */=
</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan_dbg=
(chan, &quot;idle, starting controller\n&quot;);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; desc =3D=
 list_first_entry(&amp;chan-&gt;ld_pending, struct fsl_desc_sw,</div>
<div>&gt; &gt; &gt; node);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_spl=
ice_tail_init(&amp;chan-&gt;ld_pending, &amp;chan-&gt;ld_running);</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
The 85xx DMA controller doesn't clear the channel start</div>
<div>&gt; bit</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
automatically at the end of a transfer. Therefore we must</div>
<div>&gt; clear</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
it in software before starting the transfer.</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */=
</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((cha=
n-&gt;feature &amp; FSL_DMA_IP_MASK) =3D=3D FSL_DMA_IP_85XX) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; u32 mode;</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mode =3D DMA_IN(chan, &amp;chan-&gt=
;regs-&gt;mr, 32);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mode &amp;=3D ~FSL_DMA_MR_CS;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DMA_OUT(chan, &amp;chan-&gt;regs-&g=
t;mr, mode, 32);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
Program the descriptor's address into the DMA controller,</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
then start the DMA transaction</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */=
</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; set_cdar=
(chan, desc-&gt;async_tx.phys);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; get_cdar=
(chan);</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_star=
t(chan);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan-&gt=
;idle =3D false;</div>
<div>&gt; &gt; &gt; &gt; &#43;}</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; Please add a note about the locking requirements here, =
and for the</div>
<div>&gt; other</div>
<div>&gt; &gt; &gt; new functions you've added.</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; You call this function from two places:</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; 1) fsldma_cleanup_descriptor() - called with mod-&gt;de=
sc_lock held</div>
<div>&gt; &gt; &gt; 2) fsl_tx_status() - WITHOUT mod-&gt;desc_lock held</di=
v>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; One of them is definitely wrong, and I'd bet that it is=
 #2. You're</div>
<div>&gt; &gt; &gt; modifying ld_completed without a lock.</div>
<div>&gt; &gt; Yes, My bad, I will correct it.</div>
<div>&gt; &gt;</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; &#43;static int</div>
<div>&gt; &gt; &gt; &gt; &#43;fsldma_clean_completed_descriptor(struct fsld=
ma_chan *chan) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct f=
sl_desc_sw *desc, *_desc;</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Run t=
he callback for each descriptor, in order */</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_for=
_each_entry_safe(desc, _desc, &amp;chan-&gt;ld_completed,</div>
<div>&gt; node) {</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (async_tx_test_ack(&amp;desc-&gt=
;async_tx)) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; /* Remove from the list of transactions */</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; list_del(&amp;desc-&gt;node);</div>
<div>&gt; &gt; &gt; &gt; &#43;#ifdef FSL_DMA_LD_DEBUG</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; chan_dbg(chan, &quot;LD %p free\n&quot;, desc); #endif</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; dma_pool_free(chan-&gt;desc_pool, desc,</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; desc-&gt;async_tx.phys);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0=
;</div>
<div>&gt; &gt; &gt; &gt; &#43;}</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;/**</div>
<div>&gt; &gt; &gt; &gt; &#43; * fsldma_run_tx_complete_actions - cleanup a=
nd free a single link</div>
<div>&gt; &gt; &gt; &gt; &#43;descriptor</div>
<div>&gt; &gt; &gt; &gt; &#43; * @chan: Freescale DMA channel</div>
<div>&gt; &gt; &gt; &gt; &#43; * @desc: descriptor to cleanup and free</div=
>
<div>&gt; &gt; &gt; &gt; &#43; * @cookie: Freescale DMA transaction identif=
ier</div>
<div>&gt; &gt; &gt; &gt; &#43; *</div>
<div>&gt; &gt; &gt; &gt; &#43; * This function is used on a descriptor whic=
h has been executed</div>
<div>&gt; by</div>
<div>&gt; &gt; &gt; &gt; &#43;the DMA</div>
<div>&gt; &gt; &gt; &gt; &#43; * controller. It will run any callbacks, sub=
mit any dependencies,</div>
<div>&gt; &gt; &gt; &gt; &#43;and then</div>
<div>&gt; &gt; &gt; &gt; &#43; * free the descriptor.</div>
<div>&gt; &gt; &gt; &gt; &#43; */</div>
<div>&gt; &gt; &gt; &gt; &#43;static dma_cookie_t fsldma_run_tx_complete_ac=
tions(struct</div>
<div>&gt; fsl_desc_sw</div>
<div>&gt; &gt; &gt; *desc,</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct fsldma_chan *chan, dma_cooki=
e_t cookie) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct d=
ma_async_tx_descriptor *txd =3D &amp;desc-&gt;async_tx;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct d=
evice *dev =3D chan-&gt;common.device-&gt;dev;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_addr=
_t src =3D get_desc_src(chan, desc);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_addr=
_t dst =3D get_desc_dst(chan, desc);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; u32 len =
=3D get_desc_cnt(chan, desc);</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; BUG_ON(t=
xd-&gt;cookie &lt; 0);</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (txd-=
&gt;cookie &gt; 0) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cookie =3D txd-&gt;cookie;</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Run the link descriptor callback=
 function */</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (txd-&gt;callback) {</div>
<div>&gt; &gt; &gt; &gt; &#43;#ifdef FSL_DMA_LD_DEBUG</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; chan_dbg(chan, &quot;LD %p callback\n&quot;, desc); #endif</di=
v>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; txd-&gt;callback(txd-&gt;callback_param);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Unmap the dst buffer, if request=
ed */</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!(txd-&gt;flags &amp; DMA_COMPL=
_SKIP_DEST_UNMAP)) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; if (txd-&gt;flags &amp; DMA_COMPL_DEST_UNMAP_SINGLE)</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_unmap_sing=
le(dev, dst, len,</div>
<div>&gt; DMA_FROM_DEVICE);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; else</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_unmap_page=
(dev, dst, len,</div>
<div>&gt; DMA_FROM_DEVICE);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Unmap the src buffer, if request=
ed */</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!(txd-&gt;flags &amp; DMA_COMPL=
_SKIP_SRC_UNMAP)) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; if (txd-&gt;flags &amp; DMA_COMPL_SRC_UNMAP_SINGLE)</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_unmap_sing=
le(dev, src, len,</div>
<div>&gt; DMA_TO_DEVICE);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; else</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_unmap_page=
(dev, src, len,</div>
<div>&gt; DMA_TO_DEVICE);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Run a=
ny dependencies */</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_run_=
dependencies(txd);</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return c=
ookie;</div>
<div>&gt; &gt; &gt; &gt; &#43;}</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;static int</div>
<div>&gt; &gt; &gt; &gt; &#43;fsldma_clean_running_descriptor(struct fsl_de=
sc_sw *desc,</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; struct fsldma_chan *chan)</div>
<div>&gt; &gt; &gt; &gt; &#43;{</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Remov=
e from the list of transactions */</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_del=
(&amp;desc-&gt;node);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* the c=
lient is allowed to attach dependent operations</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
until 'ack' is set</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */=
</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; This comment is does not follow the coding style. It sh=
ould be:</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; /*</div>
<div>&gt; &gt; &gt;&nbsp; * the client is allowed to attech dependent opera=
tions</div>
<div>&gt; &gt; &gt;&nbsp; * until 'ack' is set</div>
<div>&gt; &gt; &gt;&nbsp; */</div>
<div>&gt; &gt; Fine, I will correct it in v4. Include another 2 places rela=
ted to</div>
<div>&gt; coding style.</div>
<div>&gt; &gt; Thanks.</div>
<div>&gt; &gt;</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!asy=
nc_tx_test_ack(&amp;desc-&gt;async_tx)) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* move this slot to the completed =
*/</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; Perhaps a better comment would be:</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; Move this descriptor to the list of descriptors which i=
s complete,</div>
<div>&gt; but</div>
<div>&gt; &gt; &gt; still awaiting the 'ack' bit to be set.</div>
<div>&gt; &gt; Accept.</div>
<div>&gt; &gt;</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_add_tail(&amp;desc-&gt;node, &=
amp;chan-&gt;ld_completed);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_pool=
_free(chan-&gt;desc_pool, desc,</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; desc-&gt;async_tx.phys);</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; This should all be on one line. It is less than 80 char=
acters wide.</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; Accept.</div>
<div>&gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return 0=
;</div>
<div>&gt; &gt; &gt; &gt; &#43;}</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; Locking notes please.</div>
<div>&gt; &gt; I will add it in v4, please check. Thanks.</div>
<div>&gt; &gt;</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; &#43;static void fsldma_cleanup_descriptor(struct =
fsldma_chan *chan) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct f=
sl_desc_sw *desc, *_desc;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_cook=
ie_t cookie =3D 0;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_addr=
_t curr_phys =3D get_cdar(chan);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int idle=
 =3D dma_is_idle(chan);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; int seen=
_current =3D 0;</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fsldma_c=
lean_completed_descriptor(chan);</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Run t=
he callback for each descriptor, in order */</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_for=
_each_entry_safe(desc, _desc, &amp;chan-&gt;ld_running, node)</div>
<div>&gt; {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* do not advance past the current =
descriptor loaded</div>
<div>&gt; into the</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * hardware channel, subsequen=
t descriptors are either</div>
<div>&gt; in</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * process or have not been su=
bmitted</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; Coding style.</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (seen_current)</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; break;</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* stop the search if we reach the =
current descriptor</div>
<div>&gt; and the</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * channel is busy</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; Coding style.</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (desc-&gt;async_tx.phys =3D=3D c=
urr_phys) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; seen_current =3D 1;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; if (!idle)</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; break;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; This trick where you try to look at the hardware state =
to determine</div>
<div>&gt; how</div>
<div>&gt; &gt; &gt; much to clean up has been a source of headaches in the =
past versions</div>
<div>&gt; of</div>
<div>&gt; &gt; &gt; this driver.</div>
<div>&gt; &gt; I know a little about the history of this driver. Could you =
tell me</div>
<div>&gt; what kind</div>
<div>&gt; &gt; headaches in the past versions, I can have a test and fix it=
 in my</div>
<div>&gt; patch. And</div>
<div>&gt; &gt; I also think use current phys addr should be more explicit.<=
/div>
<div>&gt; &gt; Thanks.</div>
<div>&gt; &gt;</div>
<div>&gt; </div>
<div>&gt; It has been a very long time since I last worked on this code, bu=
t I</div>
<div>&gt; will try to remember.</div>
<div>&gt; </div>
<div>&gt; I remember one problem where the currently running descriptor was=
 free'd</div>
<div>&gt; while the hardware was still executing it.</div>
<div>&gt; </div>
<div>&gt; There was another related problem where the DMA hardware would lo=
ck up,</div>
<div>&gt; and it is impossible to recover without a hard reset. The CB (cha=
nnel</div>
<div>&gt; busy) bit gets stuck on, and the running transfer never completes=
. This</div>
<div>&gt; may have been due to a programming issue in a user of the DMAEngi=
ne API,</div>
<div>&gt; and not this driver itself. I don't remember for sure anymore.</d=
iv>
<div>&gt; </div>
<div>&gt; Our current system here at work has 120 boards with this DMA cont=
roller.</div>
<div>&gt; Each one runs 100&#43; DMA operations per second, 24/7/365. They'=
ve been</div>
<div>&gt; online for more than two years. I know for sure that the current =
code</div>
<div>&gt; doesn't lock up the DMA controller. :)</div>
<div>&gt; </div>
<div>&gt; I think your bug is real, and needs to be fixed. I'm just trying =
to make</div>
<div>&gt; sure I understand the change, so it won't break other users. I'm =
only</div>
<div>&gt; trying to help.</div>
<div>Thanks for your information. I will do more explanation of my idea in =
the</div>
<div>following answer.</div>
<div>Could you provide some sample code for reproduce bug, I don't know dma=
test.c</div>
<div>whether is enough. I will add dma self test in fsldma.c.</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>&gt; </div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; It is much easier to reason about the state of the hard=
ware and avoid</div>
<div>&gt; &gt; &gt; race conditions if you complete entire blocks of descri=
ptors after</div>
<div>&gt; the</div>
<div>&gt; &gt; &gt; hardware interrupts you to tell you it is finished.</di=
v>
<div>&gt; &gt; In current driver, it's ok, but there is a potential issue w=
hen enable</div>
<div>&gt; &gt; async_tx api. How can you determine these descriptors in ld_=
running</div>
<div>&gt; whether</div>
<div>&gt; &gt; have been completed in fsl_tx_status()? (I mean in my patch.=
)</div>
<div>&gt; &gt;</div>
<div>&gt; </div>
<div>&gt; I think your idea using an ld_completed list for descriptors whic=
h have</div>
<div>&gt; been run by the hardware, but not yet 'ack'ed by software is fine=
.</div>
<div>&gt; </div>
<div>&gt; Would something similar to the following work?</div>
<div>&gt; </div>
<div>&gt; ld_pending: build a list of descriptors until issue_pending() is =
called.</div>
<div>&gt; This is exactly what it does now, no changes needed.</div>
<div>Yes, no changes.</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>&gt; </div>
<div>&gt; ld_running: this list of descriptors is currently executing. Most=
ly</div>
<div>&gt; unchanged from how it works now.</div>
<div>Yes, no changes.</div>
<div>I will add descriptions about all new interfaces.</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>&gt; </div>
<div>&gt; When you get an interrupt, you know the descriptors in ld_running=
 are</div>
<div>&gt; finished. Update the cookie to the highest number from ld_running=
. Free</div>
<div>&gt; the descriptors which have been 'ack'ed immediately. Move the one=
s which</div>
<div>&gt; are not 'ack'ed onto ld_completed. As part of this process, you s=
hould</div>
<div>&gt; run dma_run_dependencies() and callbacks as needed.</div>
<div>Right, below is new implement of dma_do_tasklet();</div>
<div>First, dma_do_tasklet()</div>
<div><font face=3D"Times New Roman">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; <font face=3D"Consolas">-&gt; </font><font face=3D"Consolas">fsldma_cle=
anup_descriptor</font><font face=3D"Consolas">()</font></font></div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; -&gt; fsldma_clean_completed_descriptor(), free the de=
scriptors which has been ack'ed (I mean in queue ld_completed, not include =
other queues);</div>
<div>Second, transverse the queue ld_running<br>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -&gt; fsldma_run_tx_complete_act=
ions(), find the last descriptor which is completed, update the cookie to t=
he highest number, run callback, unmap dma pages, and run dma_run_dependenc=
ies();</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -&gt; fsldma_clean_running_=
descriptor(), move this descriptor from ld_running to ld_completed.</div>
<div>Last,</div>
<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -&gt; fsl_chan_xfer_ld_queu=
e(), submit much more descriptors from ld_pending to ld_running.</div>
<div>I hope my description is clear enough.</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>&gt; </div>
<div>&gt; I think that this solves the problem you are seeing, which is tha=
t</div>
<div>&gt; descriptors which have not been 'ack'ed are free'd.</div>
<div>&gt; </div>
<div>&gt; If this is unclear, I can write some code to demonstrate. If you =
could</div>
<div>&gt; write a small test driver, similar to drivers/dma/dmatest.c, whic=
h tests</div>
<div>&gt; the async_tx API without any extra hardware needed, I can run it.=
 I have</div>
<div>&gt; never used the async_tx API before.</div>
<div>Your description is clear, I agree with you, I will add fsldma self te=
st in</div>
<div>the file.</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>&gt; </div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; This is the philosophy employed by the driver before yo=
ur</div>
<div>&gt; modifications:</div>
<div>&gt; &gt; &gt; ld_pending: a block of descriptors which is ready to ru=
n as soon as</div>
<div>&gt; the</div>
<div>&gt; &gt; &gt; hardware becomes idle.</div>
<div>&gt; &gt; &gt; ld_running: a block of descriptors which is being execu=
ted by the</div>
<div>&gt; &gt; &gt; hardware.</div>
<div>&gt; &gt; These 2 lists are not enough, async_tx descriptors must be k=
ept order</div>
<div>&gt; as</div>
<div>&gt; &gt; expected of its submitter, we only can process the descripto=
r which has</div>
<div>&gt; been</div>
<div>&gt; &gt; acked by async_tx api, but not free all descriptors in ld_ru=
nning.</div>
<div>&gt; &gt; For example,</div>
<div>&gt; &gt; Step 1, in async_tx memcpy api,</div>
<div>&gt; &gt; tx2 =3D device-&gt;device_prep_dma_memcpy(...),</div>
<div>&gt; &gt; tx2-&gt;depend_tx =3D tx1;</div>
<div>&gt; &gt; step 2, in async_tx submit api,</div>
<div>&gt; &gt; async_tx_submit() will check tx2-&gt;depend_tx whether has b=
een acked,</div>
<div>&gt; &gt; unfortunately, tx2-&gt;depend_tx is freed before step 2 (dma=
 channels is</div>
<div>&gt; flushed</div>
<div>&gt; &gt; by other drivers), the contents of tx2-&gt;depend_tx is set =
to</div>
<div>&gt; POOL_POISON_FREED</div>
<div>&gt; &gt; if DMAPOOL_DEBUG is enabled (illegal pointer will be used if=
 disable</div>
<div>&gt; this config</div>
<div>&gt; &gt; option);</div>
<div>&gt; &gt; step 3, BUG_ON(async_tx_test_ack(depend_tx)) is triggered.</=
div>
<div>&gt; &gt;</div>
<div>&gt; &gt; For resolve this potential risk, first, ack flag must be che=
cked in dma</div>
<div>&gt; driver,</div>
<div>&gt; &gt; second, ld_completed is added to restore all descriptors whi=
ch have</div>
<div>&gt; been acked</div>
<div>&gt; &gt; and completed.</div>
<div>&gt; &gt; In my following answer, most of all are around this idea.</d=
iv>
<div>&gt; &gt;</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cookie =3D fsldma_run_tx_complete_a=
ctions(desc, chan,</div>
<div>&gt; cookie);</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (fsldma_clean_running_descriptor=
(desc, chan))</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp; break;</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
Start any pending transactions automatically</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *<=
/div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
In the ideal case, we keep the DMA controller busy while</div>
<div>&gt; we go</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * =
ahead and free the descriptors below.</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */=
</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fsl_chan=
_xfer_ld_queue(chan);</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (cook=
ie &gt; 0)</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan-&gt;common.completed_cookie =
=3D cookie; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt;&nbsp; static dma_cookie_t fsl_dma_tx_submit(struct=
</div>
<div>&gt; dma_async_tx_descriptor</div>
<div>&gt; &gt; &gt; &gt; *tx)&nbsp; {</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; struct fsldma_chan *chan =3D to_fsl_chan(tx-&gt;chan); @@ -534,8</div>
<div>&gt; &#43;745,10</div>
<div>&gt; &gt; &gt; &gt; @@ static void fsl_dma_free_chan_resources(struct =
dma_chan *dchan)</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; chan_dbg(chan, &quot;free all channel resources\n&quot;);</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; spin_lock_irqsave(&amp;chan-&gt;desc_lock, flags);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fsldma_c=
leanup_descriptor(chan);</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; fsldma_free_desc_list(chan, &amp;chan-&gt;ld_pending);</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; fsldma_free_desc_list(chan, &amp;chan-&gt;ld_running);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fsldma_f=
ree_desc_list(chan, &amp;chan-&gt;ld_completed);</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; spin_unlock_irqrestore(&amp;chan-&gt;desc_lock, flags);</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; dma_pool_destroy(chan-&gt;desc_pool);</div>
<div>&gt; &gt; &gt; &gt; @@ -811,124 &#43;1024,6 @@ static int fsl_dma_devi=
ce_control(struct</div>
<div>&gt; &gt; &gt; &gt; dma_chan *dchan,&nbsp; }</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt;&nbsp; /**</div>
<div>&gt; &gt; &gt; &gt; - * fsldma_cleanup_descriptor - cleanup and free a=
 single link</div>
<div>&gt; &gt; &gt; &gt; descriptor</div>
<div>&gt; &gt; &gt; &gt; - * @chan: Freescale DMA channel</div>
<div>&gt; &gt; &gt; &gt; - * @desc: descriptor to cleanup and free</div>
<div>&gt; &gt; &gt; &gt; - *</div>
<div>&gt; &gt; &gt; &gt; - * This function is used on a descriptor which ha=
s been executed</div>
<div>&gt; by</div>
<div>&gt; &gt; &gt; &gt; the DMA</div>
<div>&gt; &gt; &gt; &gt; - * controller. It will run any callbacks, submit =
any dependencies,</div>
<div>&gt; &gt; &gt; &gt; and then</div>
<div>&gt; &gt; &gt; &gt; - * free the descriptor.</div>
<div>&gt; &gt; &gt; &gt; - */</div>
<div>&gt; &gt; &gt; &gt; -static void fsldma_cleanup_descriptor(struct fsld=
ma_chan *chan,</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; struct fsl_desc_sw *desc)</div>
<div>&gt; &gt; &gt; &gt; -{</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct dma_a=
sync_tx_descriptor *txd =3D &amp;desc-&gt;async_tx;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct devic=
e *dev =3D chan-&gt;common.device-&gt;dev;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_addr_t s=
rc =3D get_desc_src(chan, desc);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_addr_t d=
st =3D get_desc_dst(chan, desc);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; u32 len =3D =
get_desc_cnt(chan, desc);</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Run the l=
ink descriptor callback function */</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (txd-&gt;=
callback) {</div>
<div>&gt; &gt; &gt; &gt; -#ifdef FSL_DMA_LD_DEBUG</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan_dbg(chan, &quot;LD %p callback\n&q=
uot;, desc);</div>
<div>&gt; &gt; &gt; &gt; -#endif</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; txd-&gt;callback(txd-&gt;callback_param=
);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Run any d=
ependencies */</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_run_depe=
ndencies(txd);</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Unmap the=
 dst buffer, if requested */</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!(txd-&g=
t;flags &amp; DMA_COMPL_SKIP_DEST_UNMAP)) {</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (txd-&gt;flags &amp; DMA_COMPL_DEST_=
UNMAP_SINGLE)</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; dma_unmap_single(dev, dst, len, DMA_FROM_DEVICE);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; dma_unmap_page(dev, dst, len, DMA_FROM_DEVICE);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Unmap the=
 src buffer, if requested */</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!(txd-&g=
t;flags &amp; DMA_COMPL_SKIP_SRC_UNMAP)) {</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (txd-&gt;flags &amp; DMA_COMPL_SRC_U=
NMAP_SINGLE)</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; dma_unmap_single(dev, src, len, DMA_TO_DEVICE);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; else</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; dma_unmap_page(dev, src, len, DMA_TO_DEVICE);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -#ifdef FSL_DMA_LD_DEBUG</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan_dbg(cha=
n, &quot;LD %p free\n&quot;, desc);</div>
<div>&gt; &gt; &gt; &gt; -#endif</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_pool_fre=
e(chan-&gt;desc_pool, desc, txd-&gt;phys);</div>
<div>&gt; &gt; &gt; &gt; -}</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -/**</div>
<div>&gt; &gt; &gt; &gt; - * fsl_chan_xfer_ld_queue - transfer any pending =
transactions</div>
<div>&gt; &gt; &gt; &gt; - * @chan : Freescale DMA channel</div>
<div>&gt; &gt; &gt; &gt; - *</div>
<div>&gt; &gt; &gt; &gt; - * HARDWARE STATE: idle</div>
<div>&gt; &gt; &gt; &gt; - * LOCKING: must hold chan-&gt;desc_lock</div>
<div>&gt; &gt; &gt; &gt; - */</div>
<div>&gt; &gt; &gt; &gt; -static void fsl_chan_xfer_ld_queue(struct fsldma_=
chan *chan) -{</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct fsl_d=
esc_sw *desc;</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * If t=
he list of pending descriptors is empty, then we</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * don'=
t need to do any work at all</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</di=
v>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (list_emp=
ty(&amp;chan-&gt;ld_pending)) {</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan_dbg(chan, &quot;no pending LDs\n&q=
uot;);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * The =
DMA controller is not idle, which means that the</div>
<div>&gt; interrupt</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * hand=
ler will start any queued transactions when it runs</div>
<div>&gt; after</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * this=
 transaction finishes</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</di=
v>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!chan-&g=
t;idle) {</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan_dbg(chan, &quot;DMA controller sti=
ll busy\n&quot;);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * If t=
here are some link descriptors which have not been</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * tran=
sferred, we need to start the controller</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</di=
v>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Move=
 all elements from the queue of pending transactions</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * onto=
 the list of running transactions</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</di=
v>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan_dbg(cha=
n, &quot;idle, starting controller\n&quot;);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; desc =3D lis=
t_first_entry(&amp;chan-&gt;ld_pending, struct fsl_desc_sw,</div>
<div>&gt; &gt; &gt; node);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_splice_=
tail_init(&amp;chan-&gt;ld_pending, &amp;chan-&gt;ld_running);</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * The =
85xx DMA controller doesn't clear the channel start</div>
<div>&gt; bit</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * auto=
matically at the end of a transfer. Therefore we must</div>
<div>&gt; clear</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * it i=
n software before starting the transfer.</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</di=
v>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if ((chan-&g=
t;feature &amp; FSL_DMA_IP_MASK) =3D=3D FSL_DMA_IP_85XX) {</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; u32 mode;</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mode =3D DMA_IN(chan, &amp;chan-&gt;reg=
s-&gt;mr, 32);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; mode &amp;=3D ~FSL_DMA_MR_CS;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; DMA_OUT(chan, &amp;chan-&gt;regs-&gt;mr=
, mode, 32);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Prog=
ram the descriptor's address into the DMA controller,</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * then=
 start the DMA transaction</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</di=
v>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; set_cdar(cha=
n, desc-&gt;async_tx.phys);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; get_cdar(cha=
n);</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_start(ch=
an);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan-&gt;idl=
e =3D false;</div>
<div>&gt; &gt; &gt; &gt; -}</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -/**</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp; * fsl_dma_memcpy_issue_pending - Issue=
 the DMA start command</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp; * @chan : Freescale DMA channel</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp; */</div>
<div>&gt; &gt; &gt; &gt; @@ -954,11 &#43;1049,17 @@ static enum dma_status =
fsl_tx_status(struct</div>
<div>&gt; &gt; &gt; dma_chan *dchan,</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; enum dma_status ret;</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; unsigned long flags;</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; spin_lock_ir=
qsave(&amp;chan-&gt;desc_lock, flags);</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; ret =3D dma_cookie_status(dchan, cookie, txstate);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (ret =
=3D=3D DMA_SUCCESS) {</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fsldma_clean_completed_descriptor(c=
han);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ret;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; &#43;</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; spin_loc=
k_irqsave(&amp;chan-&gt;desc_lock, flags);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fsldma_c=
leanup_descriptor(chan);</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; You've made status from a very quick operation (compare=
 two cookies)</div>
<div>&gt; into</div>
<div>&gt; &gt; &gt; a potentially long running operation. It may now run ca=
llbacks, unmap</div>
<div>&gt; &gt; &gt; pages, etc.</div>
<div>&gt; &gt; Yes, that's right, callbacks and unmap pages will be invoked=
 if DMA</div>
<div>&gt; status</div>
<div>&gt; &gt; is not DMA_SUCCESS.</div>
<div>&gt; &gt;</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; I note that Documentation/crypto/async-tx-api.txt secti=
on 3.6</div>
<div>&gt; &gt; &gt; &quot;Constraints&quot; does say that async_*() functio=
ns cannot be called from</div>
<div>&gt; IRQ</div>
<div>&gt; &gt; &gt; context. However, the DMAEngine API itself does not hav=
e anything to</div>
<div>&gt; say</div>
<div>&gt; &gt; &gt; about IRQ context.</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; I expect fsl_tx_status() to be quick, and not potential=
ly call other</div>
<div>&gt; &gt; &gt; arbitrary code.</div>
<div>&gt; &gt; fsl_tx_status() is not in IRQ context. It's reasonable to un=
map pages</div>
<div>&gt; and</div>
<div>&gt; &gt; run dependency of descriptor as fsldma_run_tx_complete_actio=
ns() does.</div>
<div>&gt; &gt;</div>
<div>&gt; </div>
<div>&gt; I looked at several other DMAEngine API drivers. Some of them do =
run</div>
<div>&gt; dependencies and callbacks from tx_status(). You are correct, thi=
s is</div>
<div>&gt; fine.</div>
<div>&gt; </div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; Is it possible to leave this function unchanged?</div>
<div>&gt; &gt; According to my knowledge, it is unlikely to be left unchang=
ed, or it</div>
<div>&gt; will violate</div>
<div>&gt; &gt; the design of this interface. If DMA status is not DMA_SUCCE=
SS, that</div>
<div>&gt; means there</div>
<div>&gt; &gt; are new descriptors completed, we should move them to ld_com=
pleted, and</div>
<div>&gt; do actions</div>
<div>&gt; &gt; to its async_tx descriptors, then dma descriptor will be fre=
ed at</div>
<div>&gt; another time.</div>
<div>&gt; &gt; Most of my idea is from iop-adma.c, the original interface i=
s not align</div>
<div>&gt; with it.</div>
<div>&gt; &gt; Async_tx flags (expecially ack_test) is not considered when =
dma</div>
<div>&gt; descriptor is freed,</div>
<div>&gt; &gt; so some random errors happened, I think you must familiar wi=
th this</div>
<div>&gt; history.</div>
<div>&gt; &gt; As an important &quot;synchronization flag&quot;, async_tx a=
pi must control the</div>
<div>&gt; order of tx</div>
<div>&gt; &gt; descriptor. Dma driver also should make sure keeping order w=
hen free</div>
<div>&gt; the descriptor.</div>
<div>&gt; &gt; That's the reason why I add ld_completed list.</div>
<div>&gt; &gt;</div>
<div>&gt; </div>
<div>&gt; Is it possible to put the descriptors into three different states=
?</div>
<div>&gt; </div>
<div>&gt; 1) ld_pending: ready to run, but not yet executed on the hardware=
</div>
<div>&gt; </div>
<div>&gt; Descriptors move to #2 through either dma_async_issue_pending() o=
r by</div>
<div>&gt; the interrupt which happens when the hardware completes executing=
 a set</div>
<div>&gt; of DMA descriptors.</div>
<div>&gt; </div>
<div>&gt; 2) ld_running: currently executing on the hardware</div>
<div>&gt; </div>
<div>&gt; Descriptors move to #3 through the interrupt which happens when t=
he</div>
<div>&gt; hardware completes executing a set of DMA descriptors.</div>
<div>&gt; </div>
<div>&gt; Dependencies and callbacks are executed as the descriptors are mo=
ved</div>
<div>&gt; onto ld_completed.</div>
<div>&gt; </div>
<div>&gt; 3) ld_completed: finished executing on the hardware, but not yet =
'ack'ed</div>
<div>&gt; </div>
<div>&gt; When they have been 'ack'ed, the descriptors are free'd.</div>
<div>&gt; </div>
<div>&gt; </div>
<div>&gt; As noted above, I think I could code this up fairly quickly if th=
is</div>
<div>&gt; explanation is unclear.</div>
<div>Totally right. I think you understand my idea.</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>&gt; </div>
<div>&gt; Also note that I may not understand your bug completely, and my i=
dea may</div>
<div>&gt; be completely wrong!</div>
<div>I hope you've already understand my issue:)</div>
<div>Thanks.</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div>&gt; </div>
<div>&gt; Ira</div>
<div>&gt; </div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; Also note that if you leave this function unchanged, th=
e locking</div>
<div>&gt; error</div>
<div>&gt; &gt; &gt; pointed out above (fsldma_clean_completed_descriptor() =
is not called</div>
<div>&gt; with</div>
<div>&gt; &gt; &gt; the lock held) goes away.</div>
<div>&gt; &gt; I know. Thanks.</div>
<div>&gt; &gt;</div>
<div>&gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; spin_unlock_irqrestore(&amp;chan-&gt;desc_lock, flags);</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return ret;<=
/div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; return d=
ma_cookie_status(dchan, cookie, txstate);</div>
<div>&gt; &gt; &gt; &gt;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; /*------------------------------------------------=
-----------------</div>
<div>&gt; ---</div>
<div>&gt; &gt; &gt; &gt; --------*/ @@ -1035,53 &#43;1136,21 @@ static irqr=
eturn_t</div>
<div>&gt; &gt; &gt; &gt; fsldma_chan_irq(int irq, void *data)&nbsp; static =
void</div>
<div>&gt; &gt; &gt; &gt; dma_do_tasklet(unsigned long data)&nbsp; {</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; struct fsldma_chan *chan =3D (struct fsldma_chan *)data;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct fsl_d=
esc_sw *desc, *_desc;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; LIST_HEAD(ld=
_cleanup);</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; unsigned long flags;</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; chan_dbg(chan, &quot;tasklet entry\n&quot;);</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; spin_lock_irqsave(&amp;chan-&gt;desc_lock, flags);</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* update th=
e cookie if we have some descriptors to cleanup</div>
<div>&gt; */</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; if (!list_em=
pty(&amp;chan-&gt;ld_running)) {</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_cookie_t cookie;</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; desc =3D to_fsl_desc(chan-&gt;ld_runnin=
g.prev);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; cookie =3D desc-&gt;async_tx.cookie;</d=
iv>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; dma_cookie_complete(&amp;desc-&gt;async=
_tx);</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; chan_dbg(chan, &quot;completed_cookie=
=3D%d\n&quot;, cookie);</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * move=
 the descriptors to a temporary list so we can drop</div>
<div>&gt; the lock</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * duri=
ng the entire cleanup operation</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</di=
v>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_splice_=
tail_init(&amp;chan-&gt;ld_running, &amp;ld_cleanup);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Run a=
ll cleanup for this descriptor */</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fsldma_c=
leanup_descriptor(chan);</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; /* the hardware is now idle and ready for more */</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; chan-&gt;idle =3D true;</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /*</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * Star=
t any pending transactions automatically</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; *</div=
>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * In t=
he ideal case, we keep the DMA controller busy while</div>
<div>&gt; we go</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; * ahea=
d and free the descriptors below.</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; */</di=
v>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; fsl_chan_xfer_ld_queue(chan);</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; spin_unlock_irqrestore(&amp;chan-&gt;desc_lock, flags);</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Run the c=
allback for each descriptor, in order */</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_for_eac=
h_entry_safe(desc, _desc, &amp;ld_cleanup, node) {</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Remove from the list of transactions=
 */</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; list_del(&amp;desc-&gt;node);</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* Run all cleanup for this descriptor =
*/</div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; fsldma_cleanup_descriptor(chan, desc);<=
/div>
<div>&gt; &gt; &gt; &gt; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt; -</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; chan_dbg(chan, &quot;tasklet exit\n&quot;);</div>
<div>&gt; &gt; &gt; &gt;&nbsp; }</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt; @@ -1262,6 &#43;1331,7 @@ static int __devinit</di=
v>
<div>&gt; fsl_dma_chan_probe(struct</div>
<div>&gt; &gt; &gt; fsldma_device *fdev,</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; spin_lock_init(&amp;chan-&gt;desc_lock);</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; INIT_LIST_HEAD(&amp;chan-&gt;ld_pending);</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; INIT_LIST_HEAD(&amp;chan-&gt;ld_running);</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; INIT_LIS=
T_HEAD(&amp;chan-&gt;ld_completed);</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; chan-&gt;idle =3D true;</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; chan-&gt;common.device =3D &amp;fdev-&gt;common; diff --git</div>
<div>&gt; &gt; &gt; &gt; a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h inde=
x</div>
<div>&gt; f5c3879..7ede908</div>
<div>&gt; &gt; &gt; &gt; 100644</div>
<div>&gt; &gt; &gt; &gt; --- a/drivers/dma/fsldma.h</div>
<div>&gt; &gt; &gt; &gt; &#43;&#43;&#43; b/drivers/dma/fsldma.h</div>
<div>&gt; &gt; &gt; &gt; @@ -140,6 &#43;140,7 @@ struct fsldma_chan {</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; spinlock_t desc_lock;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; /* Descriptor operation lock */</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; struct list_head ld_pending;&nbsp;&nbsp;&nbsp; /* Link descriptors queu=
e */</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; struct list_head ld_running;&nbsp;&nbsp;&nbsp; /* Link descriptors queu=
e */</div>
<div>&gt; &gt; &gt; &gt; &#43;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; struct l=
ist_head ld_completed;&nbsp; /* Link descriptors queue</div>
<div>&gt; */</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; struct dma_chan common;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
 /* DMA common channel */</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; struct dma_pool *desc_pool;&nbsp;&nbsp;&nbsp;&nbsp; /* Descriptors pool=
 */</div>
<div>&gt; &gt; &gt; &gt;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; struct device *dev;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp; /* Channel device */</div>
<div>&gt; &gt; &gt; &gt; --</div>
<div>&gt; &gt; &gt; &gt; 1.7.5.1</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt; &gt; &gt;</div>
<div>&gt; &gt;</div>
<div>&gt; &gt;</div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
<div><font face=3D"Times New Roman">&nbsp;</font></div>
</span></font>
</body>
</html>

--_000_BCB48C05FCE8BC4D9E61E841ECBE6DB70C2CF8039SN2MPN1011039d_--

--===============2246862812048194811==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@lists.ozlabs.org
https://lists.ozlabs.org/listinfo/linuxppc-dev
--===============2246862812048194811==--
