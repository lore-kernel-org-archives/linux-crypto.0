Return-Path: <SRS0=HcFc=OV=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:42962 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbeLLHwK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Dec 2018 02:52:10 -0500
Received: by mail-io1-f67.google.com with SMTP id x6so14052704ioa.9
        for <linux-crypto@vger.kernel.org>; Tue, 11 Dec 2018 23:52:09 -0800 (PST)
MIME-Version: 1.0
References: <1544595853-18492-1-git-send-email-amhetre@nvidia.com>
In-Reply-To: <1544595853-18492-1-git-send-email-amhetre@nvidia.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 12 Dec 2018 08:51:57 +0100
Message-ID: <CAKv+Gu9pMz2TdbY6B1eErxzGvcduuYqeQ=+oKUV6Z-7bC311Tw@mail.gmail.com>
Subject: Re: [PATCH] scatterlist: Update size type to support greater then 4GB size.
To: amhetre@nvidia.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, linux-nvme@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        vdumpa@nvidia.com, mmaddireddy@nvidia.com, Snikam@nvidia.com,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 12 Dec 2018 at 07:25, Ashish Mhetre <amhetre@nvidia.com> wrote:
>
> From: Krishna Reddy <vdumpa@nvidia.com>
>
> In the cases where greater than 4GB allocations are required, current
> definition of scatterlist doesn't support it. For example, Tegra devices
> have more than 4GB of system memory available. So they are expected to
> support larger allocation requests.
> This patch updates the type of scatterlist members to support creating
> scatterlist for allocations of size greater than 4GB size.

Can you explain what the use case is? We have had systems with more
than 4 GB for a while now, so where does this new requirement come
from?

Also, you are changing 'length' to size_t and 'offset' to unsigned
long. What is the rationale behind that? Did you consider 32-bit
architectures with PAE at all?


> Updated the files that are necessary to fix compilation issues with updated
> type of variables.
>
> With definition of scatterlist changed in this patch, size of sg has
> increased from 28 bytes to 40 bytes because of which allocations in nvme
> driver are crossing order-0( as sizeof(struct scatterlist) is used in nvme
> driver allocations ) i.e. they are not able to fit into single page.
>
> Recently a patch to limit the nvme allocations to order-0 is mergerd.
> 'commit 943e942e6266f22babee5efeb00f8f672fbff5bd ("nvme-pci: limit
> max IO size and segments to avoid high order allocations")'
> Because of that patch, WARN log is getting printed in our case as
> definition of scatterlist has changed. Alloc size of nvme is calculated as
> NVME_MAX_SEGS * sizeof(struct scatterlist). As sizeof(struct scatterlist)
> has changed from 28 bytes to 40 bytes, so updating NVME_MAX_SEGS from 127
> to 88 to correspond to original nvme alloc size value.
>
> Signed-off-by: Krishna Reddy <vdumpa@nvidia.com>
> Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
> ---
>  crypto/shash.c                |  2 +-
>  drivers/ata/libata-sff.c      |  2 +-
>  drivers/mmc/host/sdhci.c      |  2 +-
>  drivers/mmc/host/toshsd.c     |  2 +-
>  drivers/mmc/host/usdhi6rol0.c | 14 +++++++-------
>  drivers/nvme/host/pci.c       |  8 ++++----
>  include/linux/nvme.h          |  2 +-
>  include/linux/scatterlist.h   |  8 ++++----
>  8 files changed, 20 insertions(+), 20 deletions(-)
>
> diff --git a/crypto/shash.c b/crypto/shash.c
> index d21f04d..434970e 100644
> --- a/crypto/shash.c
> +++ b/crypto/shash.c
> @@ -298,7 +298,7 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
>
>         if (nbytes &&
>             (sg = req->src, offset = sg->offset,
> -            nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
> +            nbytes < min(sg->length, ((size_t)(PAGE_SIZE)) - offset))) {
>                 void *data;
>
>                 data = kmap_atomic(sg_page(sg));
> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index c5ea0fc..675def6 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -810,7 +810,7 @@ static int __atapi_pio_bytes(struct ata_queued_cmd *qc, unsigned int bytes)
>         offset %= PAGE_SIZE;
>
>         /* don't overrun current sg */
> -       count = min(sg->length - qc->cursg_ofs, bytes);
> +       count = min(sg->length - qc->cursg_ofs, (size_t)bytes);
>
>         /* don't cross page boundaries */
>         count = min(count, (unsigned int)PAGE_SIZE - offset);
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index 99bdae5..bd84c0c 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -1025,7 +1025,7 @@ static void sdhci_prepare_data(struct sdhci_host *host, struct mmc_command *cmd)
>                 if (unlikely(length_mask | offset_mask)) {
>                         for_each_sg(data->sg, sg, data->sg_len, i) {
>                                 if (sg->length & length_mask) {
> -                                       DBG("Reverting to PIO because of transfer size (%d)\n",
> +                                       DBG("Reverting to PIO because of transfer size (%zd)\n",
>                                             sg->length);
>                                         host->flags &= ~SDHCI_REQ_USE_DMA;
>                                         break;
> diff --git a/drivers/mmc/host/toshsd.c b/drivers/mmc/host/toshsd.c
> index dd961c5..af00936 100644
> --- a/drivers/mmc/host/toshsd.c
> +++ b/drivers/mmc/host/toshsd.c
> @@ -479,7 +479,7 @@ static void toshsd_start_data(struct toshsd_host *host, struct mmc_data *data)
>  {
>         unsigned int flags = SG_MITER_ATOMIC;
>
> -       dev_dbg(&host->pdev->dev, "setup data transfer: blocksize %08x  nr_blocks %d, offset: %08x\n",
> +       dev_dbg(&host->pdev->dev, "setup data transfer: blocksize %08x  nr_blocks %d, offset: %08lx\n",
>                 data->blksz, data->blocks, data->sg->offset);
>
>         host->data = data;
> diff --git a/drivers/mmc/host/usdhi6rol0.c b/drivers/mmc/host/usdhi6rol0.c
> index cd8b1b9..5fce5ff 100644
> --- a/drivers/mmc/host/usdhi6rol0.c
> +++ b/drivers/mmc/host/usdhi6rol0.c
> @@ -316,7 +316,7 @@ static void usdhi6_blk_bounce(struct usdhi6_host *host,
>         struct mmc_data *data = host->mrq->data;
>         size_t blk_head = host->head_len;
>
> -       dev_dbg(mmc_dev(host->mmc), "%s(): CMD%u of %u SG: %ux%u @ 0x%x\n",
> +       dev_dbg(mmc_dev(host->mmc), "%s(): CMD%u of %u SG: %ux%u @ 0x%lx\n",
>                 __func__, host->mrq->cmd->opcode, data->sg_len,
>                 data->blksz, data->blocks, sg->offset);
>
> @@ -360,7 +360,7 @@ static void *usdhi6_sg_map(struct usdhi6_host *host)
>
>         WARN(host->pg.page, "%p not properly unmapped!\n", host->pg.page);
>         if (WARN(sg_dma_len(sg) % data->blksz,
> -                "SG size %u isn't a multiple of block size %u\n",
> +                "SG size %zu isn't a multiple of block size %u\n",
>                  sg_dma_len(sg), data->blksz))
>                 return NULL;
>
> @@ -383,7 +383,7 @@ static void *usdhi6_sg_map(struct usdhi6_host *host)
>         else
>                 host->blk_page = host->pg.mapped;
>
> -       dev_dbg(mmc_dev(host->mmc), "Mapped %p (%lx) at %p + %u for CMD%u @ 0x%p\n",
> +       dev_dbg(mmc_dev(host->mmc), "Mapped %p (%lx) at %p + %lu for CMD%u @ 0x%p\n",
>                 host->pg.page, page_to_pfn(host->pg.page), host->pg.mapped,
>                 sg->offset, host->mrq->cmd->opcode, host->mrq);
>
> @@ -492,7 +492,7 @@ static void usdhi6_sg_advance(struct usdhi6_host *host)
>                 host->sg = next;
>
>                 if (WARN(next && sg_dma_len(next) % data->blksz,
> -                        "SG size %u isn't a multiple of block size %u\n",
> +                        "SG size %zu isn't a multiple of block size %u\n",
>                          sg_dma_len(next), data->blksz))
>                         data->error = -EINVAL;
>
> @@ -1044,7 +1044,7 @@ static int usdhi6_rq_start(struct usdhi6_host *host)
>                     (data->blksz % 4 ||
>                      data->sg->offset % 4))
>                         dev_dbg(mmc_dev(host->mmc),
> -                               "Bad SG of %u: %ux%u @ %u\n", data->sg_len,
> +                               "Bad SG of %u: %ux%u @ %lu\n", data->sg_len,
>                                 data->blksz, data->blocks, data->sg->offset);
>
>                 /* Enable DMA for USDHI6_MIN_DMA bytes or more */
> @@ -1056,7 +1056,7 @@ static int usdhi6_rq_start(struct usdhi6_host *host)
>                         usdhi6_write(host, USDHI6_CC_EXT_MODE, USDHI6_CC_EXT_MODE_SDRW);
>
>                 dev_dbg(mmc_dev(host->mmc),
> -                       "%s(): request opcode %u, %u blocks of %u bytes in %u segments, %s %s @+0x%x%s\n",
> +                       "%s(): request opcode %u, %u blocks of %u bytes in %u segments, %s %s @+0x%lx%s\n",
>                         __func__, cmd->opcode, data->blocks, data->blksz,
>                         data->sg_len, use_dma ? "DMA" : "PIO",
>                         data->flags & MMC_DATA_READ ? "read" : "write",
> @@ -1704,7 +1704,7 @@ static void usdhi6_timeout_work(struct work_struct *work)
>         case USDHI6_WAIT_FOR_WRITE:
>                 sg = host->sg ?: data->sg;
>                 dev_dbg(mmc_dev(host->mmc),
> -                       "%c: page #%u @ +0x%zx %ux%u in SG%u. Current SG %u bytes @ %u\n",
> +                       "%c: page #%u @ +0x%zx %ux%u in SG%u. Current SG %zu bytes @ %lu\n",
>                         data->flags & MMC_DATA_READ ? 'R' : 'W', host->page_idx,
>                         host->offset, data->blocks, data->blksz, data->sg_len,
>                         sg_dma_len(sg), sg->offset);
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index d668682..57ef89d 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -43,7 +43,7 @@
>   * require an sg allocation that needs more than a page of data.
>   */
>  #define NVME_MAX_KB_SZ 4096
> -#define NVME_MAX_SEGS  127
> +#define NVME_MAX_SEGS  88
>
>  static int use_threaded_interrupts;
>  module_param(use_threaded_interrupts, int, 0);
> @@ -552,8 +552,8 @@ static void nvme_print_sgl(struct scatterlist *sgl, int nents)
>
>         for_each_sg(sgl, sg, nents, i) {
>                 dma_addr_t phys = sg_phys(sg);
> -               pr_warn("sg[%d] phys_addr:%pad offset:%d length:%d "
> -                       "dma_address:%pad dma_length:%d\n",
> +               pr_warn("sg[%d] phys_addr:%pad offset:%lu length:%zu "
> +                       "dma_address:%pad dma_length:%zu\n",
>                         i, &phys, sg->offset, sg->length, &sg_dma_address(sg),
>                         sg_dma_len(sg));
>         }
> @@ -566,7 +566,7 @@ static blk_status_t nvme_pci_setup_prps(struct nvme_dev *dev,
>         struct dma_pool *pool;
>         int length = blk_rq_payload_bytes(req);
>         struct scatterlist *sg = iod->sg;
> -       int dma_len = sg_dma_len(sg);
> +       u64 dma_len = sg_dma_len(sg);
>         u64 dma_addr = sg_dma_address(sg);
>         u32 page_size = dev->ctrl.page_size;
>         int offset = dma_addr & (page_size - 1);
> diff --git a/include/linux/nvme.h b/include/linux/nvme.h
> index 68e91ef..0a07a29 100644
> --- a/include/linux/nvme.h
> +++ b/include/linux/nvme.h
> @@ -587,7 +587,7 @@ enum {
>
>  struct nvme_sgl_desc {
>         __le64  addr;
> -       __le32  length;
> +       __le64  length;
>         __u8    rsvd[3];
>         __u8    type;
>  };
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 093aa57..f6d3482 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -10,11 +10,11 @@
>
>  struct scatterlist {
>         unsigned long   page_link;
> -       unsigned int    offset;
> -       unsigned int    length;
> +       unsigned long   offset;
> +       size_t          length;
>         dma_addr_t      dma_address;
>  #ifdef CONFIG_NEED_SG_DMA_LENGTH
> -       unsigned int    dma_length;
> +       size_t          dma_length;
>  #endif
>  };
>
> @@ -114,7 +114,7 @@ static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
>   *
>   **/
>  static inline void sg_set_page(struct scatterlist *sg, struct page *page,
> -                              unsigned int len, unsigned int offset)
> +                              size_t len, unsigned long offset)
>  {
>         sg_assign_page(sg, page);
>         sg->offset = offset;
> --
> 2.7.4
>
