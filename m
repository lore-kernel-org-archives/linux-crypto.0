From: Vinod Koul <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 5/6] dmaengine: Add Broadcom SBA RAID driver
Date: Sun, 5 Feb 2017 11:36:57 +0530
Message-ID: <20170205060657.GV19244@localhost>
References: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com>
 <1486010836-25228-6-git-send-email-anup.patel@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
        Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
        Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
        Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
        Ray Jui <rjui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Scott Branden <sbranden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Jon Mason <jonmason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        Rob Rice <rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, dmaengine-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
        linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Anup Patel <anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1486010836-25228-6-git-send-email-anup.patel-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 02, 2017 at 10:17:15AM +0530, Anup Patel wrote:
> +config BCM_SBA_RAID
> +        tristate "Broadcom SBA RAID engine support"
> +        depends on (ARM64 && MAILBOX && RAID6_PQ) || COMPILE_TEST
> +        select DMA_ENGINE
> +        select DMA_ENGINE_RAID
> +	select ASYNC_TX_ENABLE_CHANNEL_SWITCH
> +	default ARCH_BCM_IPROC

whats with the funny alignement?

> +/* SBA command related defines */
> +#define SBA_TYPE_SHIFT					48
> +#define SBA_TYPE_MASK					0x3
> +#define SBA_TYPE_A					0x0
> +#define SBA_TYPE_B					0x2
> +#define SBA_TYPE_C					0x3
> +#define SBA_USER_DEF_SHIFT				32
> +#define SBA_USER_DEF_MASK				0xffff
> +#define SBA_R_MDATA_SHIFT				24
> +#define SBA_R_MDATA_MASK				0xff
> +#define SBA_C_MDATA_MS_SHIFT				18
> +#define SBA_C_MDATA_MS_MASK				0x3
> +#define SBA_INT_SHIFT					17
> +#define SBA_INT_MASK					0x1
> +#define SBA_RESP_SHIFT					16
> +#define SBA_RESP_MASK					0x1
> +#define SBA_C_MDATA_SHIFT				8
> +#define SBA_C_MDATA_MASK				0xff
> +#define SBA_CMD_SHIFT					0
> +#define SBA_CMD_MASK					0xf
> +#define SBA_CMD_ZERO_ALL_BUFFERS			0x8
> +#define SBA_CMD_LOAD_BUFFER				0x9
> +#define SBA_CMD_XOR					0xa
> +#define SBA_CMD_GALOIS_XOR				0xb
> +#define SBA_CMD_ZERO_BUFFER				0x4
> +#define SBA_CMD_WRITE_BUFFER				0xc

Try using BIT and GENMAST for hardware descriptions

> +
> +/* SBA C_MDATA helper macros */
> +#define SBA_C_MDATA_LOAD_VAL(__bnum0)		((__bnum0) & 0x3)
> +#define SBA_C_MDATA_WRITE_VAL(__bnum0)		((__bnum0) & 0x3)
> +#define SBA_C_MDATA_XOR_VAL(__bnum1, __bnum0)			\
> +			({	u32 __v = ((__bnum0) & 0x3);	\
> +				__v |= ((__bnum1) & 0x3) << 2;	\
> +				__v;				\
> +			})
> +#define SBA_C_MDATA_PQ_VAL(__dnum, __bnum1, __bnum0)		\
> +			({	u32 __v = ((__bnum0) & 0x3);	\
> +				__v |= ((__bnum1) & 0x3) << 2;	\
> +				__v |= ((__dnum) & 0x1f) << 5;	\
> +				__v;				\
> +			})

ah why are we usig complex macros, why can't these be simple functions..

> +#define SBA_C_MDATA_LS(__c_mdata_val)	((__c_mdata_val) & 0xff)
> +#define SBA_C_MDATA_MS(__c_mdata_val)	(((__c_mdata_val) >> 8) & 0x3)
> +
> +/* Driver helper macros */
> +#define to_sba_request(tx)		\
> +	container_of(tx, struct sba_request, tx)
> +#define to_sba_device(dchan)		\
> +	container_of(dchan, struct sba_device, dma_chan)
> +
> +enum sba_request_state {
> +	SBA_REQUEST_STATE_FREE = 1,
> +	SBA_REQUEST_STATE_ALLOCED = 2,
> +	SBA_REQUEST_STATE_PENDING = 3,
> +	SBA_REQUEST_STATE_ACTIVE = 4,
> +	SBA_REQUEST_STATE_COMPLETED = 5,
> +	SBA_REQUEST_STATE_ABORTED = 6,

whats up with a very funny indentation setting, we use 8 chars.

Please re-read the Documentation/process/coding-style.rst

> +static int sba_alloc_chan_resources(struct dma_chan *dchan)
> +{
> +	/*
> +	 * We only have one channel so we have pre-alloced
> +	 * channel resources. Over here we just return number
> +	 * of free request.
> +	 */
> +	return sba_free_request_count(to_sba_device(dchan));
> +}

essentially you are not doing much, so you can skip it. Its an optional
call.

> +static void sba_free_chan_resources(struct dma_chan *dchan)
> +{
> +	/*
> +	 * Channel resources are pre-alloced so we just free-up
> +	 * whatever we can so that we can re-use pre-alloced
> +	 * channel resources next time.
> +	 */
> +	sba_cleanup_inflight_requests(to_sba_device(dchan));

well this one checks for pending requests as well, which shouldn't be there
when freeing a channel, something seems not quite right here..

> +static int sba_send_mbox_request(struct sba_device *sba,
> +				 struct sba_request *req)
> +{
> +	int mchans_idx, ret = 0;
> +
> +	/* Select mailbox channel in round-robin fashion */
> +	mchans_idx = atomic_inc_return(&sba->mchans_current);
> +	mchans_idx = mchans_idx % sba->mchans_count;
> +
> +	/* Send batch message for the request */
> +	req->bmsg.batch.msgs_queued = 0;
> +	ret = mbox_send_message(sba->mchans[mchans_idx], &req->bmsg);
> +	if (ret < 0) {
> +		dev_info(sba->dev, "channel %d message %d (total %d)",
> +			 mchans_idx, req->bmsg.batch.msgs_queued,
> +			 req->bmsg.batch.msgs_count);

dev_err?

> +		dev_err(sba->dev, "send message failed with error %d", ret);
> +		return ret;
> +	}
> +	ret = req->bmsg.error;
> +	if (ret < 0) {
> +		dev_info(sba->dev,
> +			 "mbox channel %d message %d (total %d)",
> +			 mchans_idx, req->bmsg.batch.msgs_queued,
> +			 req->bmsg.batch.msgs_count);

same here

> +static dma_cookie_t sba_tx_submit(struct dma_async_tx_descriptor *tx)
> +{
> +	unsigned long flags;
> +	dma_cookie_t cookie;
> +	struct sba_request *req;
> +	struct sba_device *sba;
> +
> +	if (unlikely(!tx))
> +		return -EINVAL;
> +
> +	sba = to_sba_device(tx->chan);
> +	req = to_sba_request(tx);
> +
> +	/* Assign cookie and mark request pending */
> +	spin_lock_irqsave(&sba->reqs_lock, flags);
> +	cookie = dma_cookie_assign(tx);
> +	_sba_pending_request(sba, req);
> +	spin_unlock_irqrestore(&sba->reqs_lock, flags);
> +
> +	/* Try to submit pending request */
> +	sba_issue_pending(&sba->dma_chan);

Nope, thats wrong, caller needs to call .issue_pending for that

> +static enum dma_status sba_tx_status(struct dma_chan *dchan,
> +				     dma_cookie_t cookie,
> +				     struct dma_tx_state *txstate)
> +{
> +	int mchan_idx;
> +	enum dma_status ret;
> +	struct sba_device *sba = to_sba_device(dchan);
> +
> +	ret = dma_cookie_status(dchan, cookie, txstate);
> +	if (ret == DMA_COMPLETE)
> +		return ret;
> +
> +	for (mchan_idx = 0; mchan_idx < sba->mchans_count; mchan_idx++)
> +		mbox_client_peek_data(sba->mchans[mchan_idx]);

what is this achieving?

> +static struct dma_async_tx_descriptor *
> +sba_prep_dma_memcpy(struct dma_chan *dchan, dma_addr_t dst, dma_addr_t src,
> +		    size_t len, unsigned long flags)
> +{
> +	size_t msg_len;
> +	dma_addr_t msg_offset = 0;
> +	unsigned int msgs_count = 0, cmds_count, cmds_idx = 0;
> +	struct sba_device *sba = to_sba_device(dchan);
> +	struct sba_request *req = NULL;
> +
> +	/* Sanity checks */
> +	if (unlikely(len > sba->req_size))
> +		return NULL;

why is that an error, you can create multiple txn of max length

> +static int sba_async_register(struct sba_device *sba)
> +{
> +	int ret;
> +	struct dma_device *dma_dev = &sba->dma_dev;
> +
> +	/* Initialize DMA channel cookie */
> +	sba->dma_chan.device = dma_dev;
> +	dma_cookie_init(&sba->dma_chan);
> +
> +	/* Initialize DMA device capability mask */
> +	dma_cap_zero(dma_dev->cap_mask);
> +	dma_cap_set(DMA_MEMCPY, dma_dev->cap_mask);
> +	dma_cap_set(DMA_XOR, dma_dev->cap_mask);
> +	dma_cap_set(DMA_PQ, dma_dev->cap_mask);
> +
> +	/*
> +	 * Set mailbox channel device as the base device of
> +	 * our dma_device because the actual memory accesses
> +	 * will be done by mailbox controller
> +	 */
> +	dma_dev->dev = sba->mbox_dev;
> +
> +	/* Set base prep routines */
> +	dma_dev->device_alloc_chan_resources = sba_alloc_chan_resources;
> +	dma_dev->device_free_chan_resources = sba_free_chan_resources;
> +	dma_dev->device_issue_pending = sba_issue_pending;
> +	dma_dev->device_tx_status = sba_tx_status;

Please add terminate callback support, also add the capabilities, we need to
advertise that and use in clients

Also you can simplify bunch of code by using virt-chan support for managing
channels and descriptors

-- 
~Vinod
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
