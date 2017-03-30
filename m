From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v6 0/4] Broadcom SBA RAID support
Date: Thu, 30 Mar 2017 10:19:40 +0530
Message-ID: <20170330044940.GU9308@localhost>
References: <1488793408-25592-1-git-send-email-anup.patel@broadcom.com>
 <20170321083052.GY2843@localhost>
 <CAALAos-k_DBYAz49278wBr_GoceOKYVH_UuzTLn1h7QCiUd8pg@mail.gmail.com>
 <20170321091829.GZ2843@localhost>
 <CAALAos-P6CDdWTJxg8YQfT1V+iCxUcbYHiQ35EdZzz9PnN3cuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anup Patel <anup.patel@broadcom.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        dmaengine@vger.kernel.org,
        Device Tree <devicetree@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAALAos-P6CDdWTJxg8YQfT1V+iCxUcbYHiQ35EdZzz9PnN3cuA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 29, 2017 at 11:35:43AM +0530, Anup Patel wrote:
> On Tue, Mar 21, 2017 at 2:48 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> > On Tue, Mar 21, 2017 at 02:17:21PM +0530, Anup Patel wrote:
> >> On Tue, Mar 21, 2017 at 2:00 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> >> > On Mon, Mar 06, 2017 at 03:13:24PM +0530, Anup Patel wrote:
> >> >> The Broadcom SBA RAID is a stream-based device which provides
> >> >> RAID5/6 offload.
> >> >>
> >> >> It requires a SoC specific ring manager (such as Broadcom FlexRM
> >> >> ring manager) to provide ring-based programming interface. Due to
> >> >> this, the Broadcom SBA RAID driver (mailbox client) implements
> >> >> DMA device having one DMA channel using a set of mailbox channels
> >> >> provided by Broadcom SoC specific ring manager driver (mailbox
> >> >> controller).
> >> >>
> >> >> The Broadcom SBA RAID hardware requires PQ disk position instead
> >> >> of PQ disk coefficient. To address this, we have added raid_gflog
> >> >> table which will help driver to convert PQ disk coefficient to PQ
> >> >> disk position.
> >> >>
> >> >> This patchset is based on Linux-4.11-rc1 and depends on patchset
> >> >> "[PATCH v5 0/2] Broadcom FlexRM ring manager support"
> >> >
> >> > Okay I applied and was about to push when I noticed this :(
> >> >
> >> > So what is the status of this..?
> >>
> >> PATCH2 is Acked but PATCH1 is under-review. Currently, its
> >> v6 of that patchset.
> >>
> >> The only dependency on that patchset is the changes in
> >> brcm-message.h which are required by this BCM-SBA-RAID
> >> driver.
> >>
> >> @Jassi,
> >> Can you please have a look at PATCH v6?
> >
> > And I would need an immutable branch/tag once merged. I am going to keep
> > this series pending till then.
> 
> The Broadcom FlexRM patchset is pickedup by Jassi and
> can be found in mailbox-for-next branch of
> git://git.linaro.org/landing-teams/working/fujitsu/integration
> 
> Both patchset (Broadcom FlexRM patchset and this one) are
> also available in sba-raid-v7 branch of
> https://github.com/Broadcom/arm64-linux.git

Jassi,

Can you provide an immutable branch/tag please for this, latter is
preferred.

Btw didn't find your tree in MAINTAINERS..

> 
> Regards,
> Anup

-- 
~Vinod
