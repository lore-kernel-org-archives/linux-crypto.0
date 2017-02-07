From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH v2 2/5] async_tx: Handle DMA devices having support for
 fewer PQ coefficients
Date: Tue, 7 Feb 2017 22:12:08 +0530
Message-ID: <20170207164207.GI19244@localhost>
References: <1486455406-11202-1-git-send-email-anup.patel@broadcom.com>
 <1486455406-11202-3-git-send-email-anup.patel@broadcom.com>
 <CAPcyv4gbV1yf52JrejW+Dn3wOPn7Er+8HWdu2qsW0+Qm+cRr9g@mail.gmail.com>
 <CAALAos_yhXufdt79KWY0eugjF5oyJ8+NcPh2E-dEXnSQu2WhhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Williams <dan.j.williams@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Device Tree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>
To: Anup Patel <anup.patel@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAALAos_yhXufdt79KWY0eugjF5oyJ8+NcPh2E-dEXnSQu2WhhA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Feb 07, 2017 at 02:32:15PM +0530, Anup Patel wrote:
> On Tue, Feb 7, 2017 at 1:57 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Tue, Feb 7, 2017 at 12:16 AM, Anup Patel <anup.patel@broadcom.com> wrote:
> >> The DMAENGINE framework assumes that if PQ offload is supported by a
> >> DMA device then all 256 PQ coefficients are supported. This assumption
> >> does not hold anymore because we now have BCM-SBA-RAID offload engine
> >> which supports PQ offload with limited number of PQ coefficients.
> >>
> >> This patch extends async_tx APIs to handle DMA devices with support
> >> for fewer PQ coefficients.
> >>
> >> Signed-off-by: Anup Patel <anup.patel@broadcom.com>
> >> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> >
> > I don't like this approach. Define an interface for md to query the
> > offload engine once at the beginning of time. We should not be adding
> > any new extensions to async_tx.
> 
> Even if we do capability checks in Linux MD, we still need a way
> for DMAENGINE drivers to advertise number of PQ coefficients
> handled by the HW.

If the question is only for advertising caps, then why not do as done
for dma_get_slave_caps(). you can add dma_get_pq_caps() so that clients (md)
in this case would know the HW capability.

> I agree capability checks should be done once in Linux MD but I don't
> see why this has to be part of BCM-SBA-RAID driver patches. We need
> separate patchsets to address limitations of async_tx framework.
> 
> Regards,
> Anup

-- 
~Vinod
