From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] async_pq: Remove VLA usage
Date: Thu, 3 May 2018 16:32:55 -0700
Message-ID: <CAGXu5j+AvMCFTuzTQ-qaA14M9ZaNnfwdwYZ37jx+LdAs4pYyPQ@mail.gmail.com>
References: <20180503225716.154235-1-ksspiers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Dan Williams <dan.j.williams@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, vinod.koul@intel.com,
        ray.jui@broadcom.com, anup.patel@broadcom.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Kyle Spiers <ksspiers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180503225716.154235-1-ksspiers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 3, 2018 at 3:57 PM, Kyle Spiers <ksspiers@google.com> wrote:
> In the quest to remove VLAs from the kernel[1], this moves the
> allocation of coefs and blocks from the stack to being kmalloc()ed.
>
> [1] https://lkml.org/lkml/2018/3/7/621
>
> Signed-off-by: Kyle Spiers <ksspiers@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks for working on this one!

-Kees

> ---
>  crypto/async_tx/async_pq.c  | 18 ++++++++++++++----
>  crypto/async_tx/raid6test.c |  8 +++++++-
>  2 files changed, 21 insertions(+), 5 deletions(-)
>
> diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
> index 56bd612927ab..af1912313a23 100644
> --- a/crypto/async_tx/async_pq.c
> +++ b/crypto/async_tx/async_pq.c
> @@ -194,9 +194,9 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
>             (src_cnt <= dma_maxpq(device, 0) ||
>              dma_maxpq(device, DMA_PREP_CONTINUE) > 0) &&
>             is_dma_pq_aligned(device, offset, 0, len)) {
> -               struct dma_async_tx_descriptor *tx;
> +               struct dma_async_tx_descriptor *tx = NULL;
>                 enum dma_ctrl_flags dma_flags = 0;
> -               unsigned char coefs[src_cnt];
> +               unsigned char *coefs;
>                 int i, j;
>
>                 /* run the p+q asynchronously */
> @@ -207,6 +207,9 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
>                  * sources and update the coefficients accordingly
>                  */
>                 unmap->len = len;
> +               coefs = kmalloc_array(src_cnt, sizeof(*coefs), GFP_KERNEL);
> +               if (!coefs)
> +                       goto out;
>                 for (i = 0, j = 0; i < src_cnt; i++) {
>                         if (blocks[i] == NULL)
>                                 continue;
> @@ -240,7 +243,9 @@ async_gen_syndrome(struct page **blocks, unsigned int offset, int disks,
>                 }
>
>                 tx = do_async_gen_syndrome(chan, coefs, j, unmap, dma_flags, submit);
> +out:
>                 dmaengine_unmap_put(unmap);
> +               kfree(coefs);
>                 return tx;
>         }
>
> @@ -298,8 +303,8 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
>  {
>         struct dma_chan *chan = pq_val_chan(submit, blocks, disks, len);
>         struct dma_device *device = chan ? chan->device : NULL;
> -       struct dma_async_tx_descriptor *tx;
> -       unsigned char coefs[disks-2];
> +       struct dma_async_tx_descriptor *tx = NULL;
> +       unsigned char *coefs = NULL;
>         enum dma_ctrl_flags dma_flags = submit->cb_fn ? DMA_PREP_INTERRUPT : 0;
>         struct dmaengine_unmap_data *unmap = NULL;
>
> @@ -318,6 +323,9 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
>                          __func__, disks, len);
>
>                 unmap->len = len;
> +               coefs = kmalloc_array(disks - 2, sizeof(*coefs), GFP_KERNEL);
> +               if (!coefs)
> +                       goto out;
>                 for (i = 0; i < disks-2; i++)
>                         if (likely(blocks[i])) {
>                                 unmap->addr[j] = dma_map_page(dev, blocks[i],
> @@ -423,6 +431,8 @@ async_syndrome_val(struct page **blocks, unsigned int offset, int disks,
>                 async_tx_sync_epilog(submit);
>                 tx = NULL;
>         }
> +out:
> +       kfree(coefs);
>         dmaengine_unmap_put(unmap);
>
>         return tx;
> diff --git a/crypto/async_tx/raid6test.c b/crypto/async_tx/raid6test.c
> index dad95f45b88f..ea036b531ef2 100644
> --- a/crypto/async_tx/raid6test.c
> +++ b/crypto/async_tx/raid6test.c
> @@ -81,11 +81,16 @@ static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, stru
>                         init_async_submit(&submit, 0, NULL, NULL, NULL, addr_conv);
>                         tx = async_gen_syndrome(ptrs, 0, disks, bytes, &submit);
>                 } else {
> -                       struct page *blocks[disks];
> +                       struct page **blocks;
>                         struct page *dest;
>                         int count = 0;
>                         int i;
>
> +                       blocks = kmalloc_array(disks, sizeof(*blocks),
> +                                                       GFP_KERNEL);
> +                       if (!blocks)
> +                               return;
> +
>                         /* data+Q failure.  Reconstruct data from P,
>                          * then rebuild syndrome
>                          */
> @@ -101,6 +106,7 @@ static void raid6_dual_recov(int disks, size_t bytes, int faila, int failb, stru
>
>                         init_async_submit(&submit, 0, tx, NULL, NULL, addr_conv);
>                         tx = async_gen_syndrome(ptrs, 0, disks, bytes, &submit);
> +                       kfree(blocks);
>                 }
>         } else {
>                 if (failb == disks-2) {
> --
> 2.17.0.441.gb46fe60e1d-goog
>



-- 
Kees Cook
Pixel Security
