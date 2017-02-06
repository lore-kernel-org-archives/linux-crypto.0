From: Vinod Koul <vinod.koul@intel.com>
Subject: Re: [PATCH 5/6] dmaengine: Add Broadcom SBA RAID driver
Date: Mon, 6 Feb 2017 22:24:00 +0530
Message-ID: <20170206165400.GD19244@localhost>
References: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com>
 <1486010836-25228-6-git-send-email-anup.patel@broadcom.com>
 <20170205060657.GV19244@localhost>
 <CAALAos9FxwKuF+qtqViybZ8APZNYt-PWLnTfJs64xtoyYB5NZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jassi Brar <jassisinghbrar@gmail.com>,
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
To: Anup Patel <anup.patel@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAALAos9FxwKuF+qtqViybZ8APZNYt-PWLnTfJs64xtoyYB5NZQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 06, 2017 at 05:31:15PM +0530, Anup Patel wrote:

> >> +
> >> +/* SBA C_MDATA helper macros */
> >> +#define SBA_C_MDATA_LOAD_VAL(__bnum0)                ((__bnum0) & 0x3)
> >> +#define SBA_C_MDATA_WRITE_VAL(__bnum0)               ((__bnum0) & 0x3)
> >> +#define SBA_C_MDATA_XOR_VAL(__bnum1, __bnum0)                        \
> >> +                     ({      u32 __v = ((__bnum0) & 0x3);    \
> >> +                             __v |= ((__bnum1) & 0x3) << 2;  \
> >> +                             __v;                            \
> >> +                     })
> >> +#define SBA_C_MDATA_PQ_VAL(__dnum, __bnum1, __bnum0)         \
> >> +                     ({      u32 __v = ((__bnum0) & 0x3);    \
> >> +                             __v |= ((__bnum1) & 0x3) << 2;  \
> >> +                             __v |= ((__dnum) & 0x1f) << 5;  \
> >> +                             __v;                            \
> >> +                     })
> >
> > ah why are we usig complex macros, why can't these be simple functions..
> 
> "static inline functions" seemed too complicated here because most of
> these macros are two lines of c-code.

and thats where I have an issue with this. Macros for simple things is fine
but not for couple of line of logic!

> 
> Do you still insist on using "static inline functions"?

Yes

> 
> >
> >> +#define SBA_C_MDATA_LS(__c_mdata_val)        ((__c_mdata_val) & 0xff)
> >> +#define SBA_C_MDATA_MS(__c_mdata_val)        (((__c_mdata_val) >> 8) & 0x3)
> >> +
> >> +/* Driver helper macros */
> >> +#define to_sba_request(tx)           \
> >> +     container_of(tx, struct sba_request, tx)
> >> +#define to_sba_device(dchan)         \
> >> +     container_of(dchan, struct sba_device, dma_chan)
> >> +
> >> +enum sba_request_state {
> >> +     SBA_REQUEST_STATE_FREE = 1,
> >> +     SBA_REQUEST_STATE_ALLOCED = 2,
> >> +     SBA_REQUEST_STATE_PENDING = 3,
> >> +     SBA_REQUEST_STATE_ACTIVE = 4,
> >> +     SBA_REQUEST_STATE_COMPLETED = 5,
> >> +     SBA_REQUEST_STATE_ABORTED = 6,
> >
> > whats up with a very funny indentation setting, we use 8 chars.
> >
> > Please re-read the Documentation/process/coding-style.rst
> 
> I have double checked this enum. The indentation is fine
> and as-per coding style. Am I missing anything else?

Somehow the initial indent doesnt seem to be 8 chars to me.

> >> +static enum dma_status sba_tx_status(struct dma_chan *dchan,
> >> +                                  dma_cookie_t cookie,
> >> +                                  struct dma_tx_state *txstate)
> >> +{
> >> +     int mchan_idx;
> >> +     enum dma_status ret;
> >> +     struct sba_device *sba = to_sba_device(dchan);
> >> +
> >> +     ret = dma_cookie_status(dchan, cookie, txstate);
> >> +     if (ret == DMA_COMPLETE)
> >> +             return ret;
> >> +
> >> +     for (mchan_idx = 0; mchan_idx < sba->mchans_count; mchan_idx++)
> >> +             mbox_client_peek_data(sba->mchans[mchan_idx]);
> >
> > what is this achieving?
> 
> The mbox_client_peek_data() is a hint to mailbox controller driver
> to check for available messages.
> 
> This gives good performance improvement when some DMA client
> code is polling using tx_status() callback.

Then why do it before and then check status.

-- 
~Vinod
