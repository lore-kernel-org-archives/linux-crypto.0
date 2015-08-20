From: Rameshwar Sahu <rsahu@apm.com>
Subject: Re: [PATCH v1 2/4] dmaengine: xgene-dma: Add support for CRC32C
 calculation via DMA engine
Date: Thu, 20 Aug 2015 12:23:50 +0530
Message-ID: <CAFd313y3vTCzaGKY7ZVyFGDiSx+KuxQHyBwqKyB+xWfR5dtVSA@mail.gmail.com>
References: <1438258268-3099-1-git-send-email-rsahu@apm.com>
	<1438258268-3099-3-git-send-email-rsahu@apm.com>
	<20150820054034.GX13546@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dan.j.williams@intel.com, Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	dmaengine@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, jcm@redhat.com,
	patches@apm.com
To: Vinod Koul <vinod.koul@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150820054034.GX13546@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Vinod,

On Thu, Aug 20, 2015 at 11:10 AM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Thu, Jul 30, 2015 at 05:41:06PM +0530, Rameshwar Prasad Sahu wrote:
>> +     /* Invalidate unused source address field */
>> +     for (; i < 4; i++)
>> +             xgene_dma_invalidate_buffer(xgene_dma_lookup_ext8(desc2, i));
>> +
>> +     /* Check whether requested buffer processed */
>> +     if (nbytes) {
>> +             chan_err(chan, "Src count crossed maximum limit\n");
>> +             return -EINVAL;
> no cleanup ?
Here not required, cleanup I am doing in parent function from where
this function is getting called in case of failure.
>
>> +struct dma_async_tx_descriptor *xgene_dma_prep_flyby(
>> +     struct xgene_dma_chan *chan, struct scatterlist *src_sg,
>> +     size_t len, u32 seed, u8 *result, unsigned long flags, u8 opcode)
> please fix style here

Could you explain me What kind of coding style you would like here ??
>
>> +struct dma_async_tx_descriptor *xgene_dma_prep_crc32c(
>> +     struct dma_chan *dchan, struct scatterlist *src_sg,
>> +     size_t len, u32 seed, u8 *result, unsigned long flags)
> here too
>
>> @@ -1309,8 +1512,13 @@ static void xgene_dma_setup_ring(struct xgene_dma_ring *ring)
>>                 ring->pdma->csr_ring + XGENE_DMA_RING_ID);
>>
>>       /* Set DMA ring buffer */
>> -     iowrite32(XGENE_DMA_RING_ID_BUF_SETUP(ring->num),
>> -               ring->pdma->csr_ring + XGENE_DMA_RING_ID_BUF);
>> +     ring_id_buf = XGENE_DMA_RING_ID_BUF_SETUP(ring->num);
>> +
>> +     if (ring->is_bufpool)
>> +             ring_id_buf |= XGENE_DMA_RING_IS_BUFPOOL;
>> +
>> +     iowrite32(ring_id_buf, ring->pdma->csr_ring +
>> +               XGENE_DMA_RING_ID_BUF);
> pls fix style here
I didn't see any alignment issue here, just follow checkpatch that
argument should start just after "function(" in next line also.
>
> --
> ~Vinod
