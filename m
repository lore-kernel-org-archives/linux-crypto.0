From: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v6 0/4] Broadcom SBA RAID support
Date: Tue, 14 Mar 2017 11:48:06 -0700
Message-ID: <20170314184806.o2oykhztje3obwot@kernel.org>
References: <1488793408-25592-1-git-send-email-anup.patel@broadcom.com>
 <CAPcyv4hGGbhF-g8B__9=rsP+QwR6RBi=WqALLgABNb1M4D3rBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        BCM Kernel Feedback <bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        "dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Device Tree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org"
        <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-raid <lin
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4hGGbhF-g8B__9=rsP+QwR6RBi=WqALLgABNb1M4D3rBw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Mar 14, 2017 at 09:56:35AM -0700, Dan Williams wrote:
> On Mon, Mar 6, 2017 at 1:43 AM, Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
> > The Broadcom SBA RAID is a stream-based device which provides
> > RAID5/6 offload.
> >
> > It requires a SoC specific ring manager (such as Broadcom FlexRM
> > ring manager) to provide ring-based programming interface. Due to
> > this, the Broadcom SBA RAID driver (mailbox client) implements
> > DMA device having one DMA channel using a set of mailbox channels
> > provided by Broadcom SoC specific ring manager driver (mailbox
> > controller).
> >
> > The Broadcom SBA RAID hardware requires PQ disk position instead
> > of PQ disk coefficient. To address this, we have added raid_gflog
> > table which will help driver to convert PQ disk coefficient to PQ
> > disk position.
> >
> > This patchset is based on Linux-4.11-rc1 and depends on patchset
> > "[PATCH v5 0/2] Broadcom FlexRM ring manager support"
> >
> > It is also available at sba-raid-v6 branch of
> > https://github.com/Broadcom/arm64-linux.git
> >
> [..]
> >
> > Anup Patel (4):
> >   lib/raid6: Add log-of-2 table for RAID6 HW requiring disk position
> >   async_tx: Fix DMA_PREP_FENCE usage in do_async_gen_syndrome()
> >   dmaengine: Add Broadcom SBA RAID driver
> >   dt-bindings: Add DT bindings document for Broadcom SBA RAID driver
> 
> For the dmaengine and async_tx changes:
> 
> Acked-by: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> The raid change should get an ack from Shaohua.

For the raid6 part:

Acked-by: Shaohua Li <shli-b10kYP2dOMg@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
