From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] staging: ccree: Fix format/argument mismatches
Date: Mon, 31 Jul 2017 09:39:45 +0300
Message-ID: <CAOtvUMfru3VJiBoVrCcLYzuuJAhUOyNknH=Udjj8pAHTtCk4mQ@mail.gmail.com>
References: <ad38ad75c09fb836cc89127e5049c7619325927d.1501433084.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Joe Perches <joe@perches.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f68.google.com ([209.85.214.68]:33365 "EHLO
        mail-it0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbdGaGjq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Jul 2017 02:39:46 -0400
Received: by mail-it0-f68.google.com with SMTP id t6so19047659itb.0
        for <linux-crypto@vger.kernel.org>; Sun, 30 Jul 2017 23:39:46 -0700 (PDT)
In-Reply-To: <ad38ad75c09fb836cc89127e5049c7619325927d.1501433084.git.joe@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jul 30, 2017 at 7:45 PM, Joe Perches <joe@perches.com> wrote:
> By default, debug logging is disabled by CC_DEBUG not being defined.
>
> Convert SSI_LOG_DEBUG to use no_printk instead of an empty define
> to validate formats and arguments.
>
> Fix fallout.
>
> Miscellanea:
>
> o One of the conversions now uses %pR instead of multiple uses of %pad

This looks great (I didn't know about no_printk) but does not seem to
apply on top of
staging-next.


Thanks,
Gilad

>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/ccree/ssi_aead.c        |  8 ++++----
>  drivers/staging/ccree/ssi_buffer_mgr.c  | 29 +++++++++++++----------------
>  drivers/staging/ccree/ssi_cipher.c      | 10 +++++-----
>  drivers/staging/ccree/ssi_driver.c      |  5 ++---
>  drivers/staging/ccree/ssi_driver.h      |  2 +-
>  drivers/staging/ccree/ssi_hash.c        | 32 ++++++++++++++++----------------
>  drivers/staging/ccree/ssi_request_mgr.c |  6 +++---
>  7 files changed, 44 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
> index ea29b8a1a71d..9376bf8b8c61 100644
> --- a/drivers/staging/ccree/ssi_aead.c
> +++ b/drivers/staging/ccree/ssi_aead.c
> @@ -103,7 +103,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
>         if (ctx->enckey) {
>                 dma_free_coherent(dev, AES_MAX_KEY_SIZE, ctx->enckey, ctx->enckey_dma_addr);
>                 SSI_LOG_DEBUG("Freed enckey DMA buffer enckey_dma_addr=%pad\n",
> -                             ctx->enckey_dma_addr);
> +                             &ctx->enckey_dma_addr);
>                 ctx->enckey_dma_addr = 0;
>                 ctx->enckey = NULL;
>         }
> @@ -117,7 +117,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
>                                           xcbc->xcbc_keys_dma_addr);
>                 }
>                 SSI_LOG_DEBUG("Freed xcbc_keys DMA buffer xcbc_keys_dma_addr=%pad\n",
> -                             xcbc->xcbc_keys_dma_addr);
> +                             &xcbc->xcbc_keys_dma_addr);
>                 xcbc->xcbc_keys_dma_addr = 0;
>                 xcbc->xcbc_keys = NULL;
>         } else if (ctx->auth_mode != DRV_HASH_NULL) { /* HMAC auth. */
> @@ -128,7 +128,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
>                                           hmac->ipad_opad,
>                                           hmac->ipad_opad_dma_addr);
>                         SSI_LOG_DEBUG("Freed ipad_opad DMA buffer ipad_opad_dma_addr=%pad\n",
> -                                     hmac->ipad_opad_dma_addr);
> +                                     &hmac->ipad_opad_dma_addr);
>                         hmac->ipad_opad_dma_addr = 0;
>                         hmac->ipad_opad = NULL;
>                 }
> @@ -137,7 +137,7 @@ static void ssi_aead_exit(struct crypto_aead *tfm)
>                                           hmac->padded_authkey,
>                                           hmac->padded_authkey_dma_addr);
>                         SSI_LOG_DEBUG("Freed padded_authkey DMA buffer padded_authkey_dma_addr=%pad\n",
> -                                     hmac->padded_authkey_dma_addr);
> +                                     &hmac->padded_authkey_dma_addr);
>                         hmac->padded_authkey_dma_addr = 0;
>                         hmac->padded_authkey = NULL;
>                 }
> diff --git a/drivers/staging/ccree/ssi_buffer_mgr.c b/drivers/staging/ccree/ssi_buffer_mgr.c
> index 6579a54f9dc4..e13184d1d165 100644
> --- a/drivers/staging/ccree/ssi_buffer_mgr.c
> +++ b/drivers/staging/ccree/ssi_buffer_mgr.c
> @@ -14,6 +14,7 @@
>   * along with this program; if not, see <http://www.gnu.org/licenses/>.
>   */
>
> +#include <linux/kernel.h>
>  #include <linux/crypto.h>
>  #include <linux/version.h>
>  #include <crypto/algapi.h>
> @@ -33,14 +34,10 @@
>  #include "ssi_hash.h"
>  #include "ssi_aead.h"
>
> -#ifdef CC_DEBUG
>  #define GET_DMA_BUFFER_TYPE(buff_type) ( \
>         ((buff_type) == SSI_DMA_BUF_NULL) ? "BUF_NULL" : \
>         ((buff_type) == SSI_DMA_BUF_DLLI) ? "BUF_DLLI" : \
>         ((buff_type) == SSI_DMA_BUF_MLLI) ? "BUF_MLLI" : "BUF_INVALID")
> -#else
> -#define GET_DMA_BUFFER_TYPE(buff_type)
> -#endif
>
>  enum dma_buffer_type {
>         DMA_NULL_TYPE = -1,
> @@ -262,7 +259,7 @@ static int ssi_buffer_mgr_generate_mlli(
>         SSI_LOG_DEBUG("MLLI params: "
>                      "virt_addr=%pK dma_addr=%pad mlli_len=0x%X\n",
>                    mlli_params->mlli_virt_addr,
> -                  mlli_params->mlli_dma_addr,
> +                  &mlli_params->mlli_dma_addr,
>                    mlli_params->mlli_len);
>
>  build_mlli_exit:
> @@ -278,7 +275,7 @@ static inline void ssi_buffer_mgr_add_buffer_entry(
>
>         SSI_LOG_DEBUG("index=%u single_buff=%pad "
>                      "buffer_len=0x%08X is_last=%d\n",
> -                    index, buffer_dma, buffer_len, is_last_entry);
> +                    index, &buffer_dma, buffer_len, is_last_entry);
>         sgl_data->nents[index] = 1;
>         sgl_data->entry[index].buffer_dma = buffer_dma;
>         sgl_data->offset[index] = 0;
> @@ -362,7 +359,7 @@ static int ssi_buffer_mgr_map_scatterlist(
>                 SSI_LOG_DEBUG("Mapped sg: dma_address=%pad "
>                              "page=%p addr=%pK offset=%u "
>                              "length=%u\n",
> -                            sg_dma_address(sg),
> +                            &sg_dma_address(sg),
>                              sg_page(sg),
>                              sg_virt(sg),
>                              sg->offset, sg->length);
> @@ -426,7 +423,7 @@ ssi_aead_handle_config_buf(struct device *dev,
>         SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad "
>                      "page=%p addr=%pK "
>                      "offset=%u length=%u\n",
> -                    sg_dma_address(&areq_ctx->ccm_adata_sg),
> +                    &sg_dma_address(&areq_ctx->ccm_adata_sg),
>                      sg_page(&areq_ctx->ccm_adata_sg),
>                      sg_virt(&areq_ctx->ccm_adata_sg),
>                      areq_ctx->ccm_adata_sg.offset,
> @@ -459,7 +456,7 @@ static inline int ssi_ahash_handle_curr_buf(struct device *dev,
>         SSI_LOG_DEBUG("Mapped curr_buff: dma_address=%pad "
>                      "page=%p addr=%pK "
>                      "offset=%u length=%u\n",
> -                    sg_dma_address(areq_ctx->buff_sg),
> +                    &sg_dma_address(areq_ctx->buff_sg),
>                      sg_page(areq_ctx->buff_sg),
>                      sg_virt(areq_ctx->buff_sg),
>                      areq_ctx->buff_sg->offset,
> @@ -484,7 +481,7 @@ void ssi_buffer_mgr_unmap_blkcipher_request(
>
>         if (likely(req_ctx->gen_ctx.iv_dma_addr != 0)) {
>                 SSI_LOG_DEBUG("Unmapped iv: iv_dma_addr=%pad iv_size=%u\n",
> -                             req_ctx->gen_ctx.iv_dma_addr,
> +                             &req_ctx->gen_ctx.iv_dma_addr,
>                               ivsize);
>                 dma_unmap_single(dev, req_ctx->gen_ctx.iv_dma_addr,
>                                  ivsize,
> @@ -545,7 +542,7 @@ int ssi_buffer_mgr_map_blkcipher_request(
>                 }
>                 SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=%pad\n",
>                               ivsize, info,
> -                             req_ctx->gen_ctx.iv_dma_addr);
> +                             &req_ctx->gen_ctx.iv_dma_addr);
>         } else {
>                 req_ctx->gen_ctx.iv_dma_addr = 0;
>         }
> @@ -675,7 +672,7 @@ void ssi_buffer_mgr_unmap_aead_request(
>          */
>         if (areq_ctx->mlli_params.curr_pool) {
>                 SSI_LOG_DEBUG("free MLLI buffer: dma=%pad virt=%pK\n",
> -                             areq_ctx->mlli_params.mlli_dma_addr,
> +                             &areq_ctx->mlli_params.mlli_dma_addr,
>                               areq_ctx->mlli_params.mlli_virt_addr);
>                 dma_pool_free(areq_ctx->mlli_params.curr_pool,
>                               areq_ctx->mlli_params.mlli_virt_addr,
> @@ -794,7 +791,7 @@ static inline int ssi_buffer_mgr_aead_chain_iv(
>
>         SSI_LOG_DEBUG("Mapped iv %u B at va=%pK to dma=%pad\n",
>                       hw_iv_size, req->iv,
> -                     areq_ctx->gen_ctx.iv_dma_addr);
> +                     &areq_ctx->gen_ctx.iv_dma_addr);
>         if (do_chain && areq_ctx->plaintext_authenticate_only) {  // TODO: what about CTR?? ask Ron
>                 struct crypto_aead *tfm = crypto_aead_reqtfm(req);
>                 unsigned int iv_size_to_authenc = crypto_aead_ivsize(tfm);
> @@ -1718,7 +1715,7 @@ void ssi_buffer_mgr_unmap_hash_request(
>          */
>         if (areq_ctx->mlli_params.curr_pool) {
>                 SSI_LOG_DEBUG("free MLLI buffer: dma=%pad virt=%pK\n",
> -                             areq_ctx->mlli_params.mlli_dma_addr,
> +                             &areq_ctx->mlli_params.mlli_dma_addr,
>                               areq_ctx->mlli_params.mlli_virt_addr);
>                 dma_pool_free(areq_ctx->mlli_params.curr_pool,
>                               areq_ctx->mlli_params.mlli_virt_addr,
> @@ -1728,7 +1725,7 @@ void ssi_buffer_mgr_unmap_hash_request(
>         if ((src) && likely(areq_ctx->in_nents != 0)) {
>                 SSI_LOG_DEBUG("Unmapped sg src: virt=%pK dma=%pad len=0x%X\n",
>                               sg_virt(src),
> -                             sg_dma_address(src),
> +                             &sg_dma_address(src),
>                               sg_dma_len(src));
>                 dma_unmap_sg(dev, src,
>                              areq_ctx->in_nents, DMA_TO_DEVICE);
> @@ -1738,7 +1735,7 @@ void ssi_buffer_mgr_unmap_hash_request(
>                 SSI_LOG_DEBUG("Unmapped buffer: areq_ctx->buff_sg=%pK"
>                              " dma=%pad len 0x%X\n",
>                                 sg_virt(areq_ctx->buff_sg),
> -                               sg_dma_address(areq_ctx->buff_sg),
> +                               &sg_dma_address(areq_ctx->buff_sg),
>                                 sg_dma_len(areq_ctx->buff_sg));
>                 dma_unmap_sg(dev, areq_ctx->buff_sg, 1, DMA_TO_DEVICE);
>                 if (!do_revert) {
> diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
> index bfe9b1ccbf37..90a960c73e81 100644
> --- a/drivers/staging/ccree/ssi_cipher.c
> +++ b/drivers/staging/ccree/ssi_cipher.c
> @@ -211,7 +211,7 @@ static int ssi_blkcipher_init(struct crypto_tfm *tfm)
>         }
>         SSI_LOG_DEBUG("Mapped key %u B at va=%pK to dma=%pad\n",
>                       max_key_buf_size, ctx_p->user.key,
> -                     ctx_p->user.key_dma_addr);
> +                     &ctx_p->user.key_dma_addr);
>
>         if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
>                 /* Alloc hash tfm for essiv */
> @@ -244,7 +244,7 @@ static void ssi_blkcipher_exit(struct crypto_tfm *tfm)
>         dma_unmap_single(dev, ctx_p->user.key_dma_addr, max_key_buf_size,
>                          DMA_TO_DEVICE);
>         SSI_LOG_DEBUG("Unmapped key buffer key_dma_addr=%pad\n",
> -                     ctx_p->user.key_dma_addr);
> +                     &ctx_p->user.key_dma_addr);
>
>         /* Free key buffer in context */
>         kfree(ctx_p->user.key);
> @@ -620,9 +620,9 @@ ssi_blkcipher_create_data_desc(
>         /* Process */
>         if (likely(req_ctx->dma_buf_type == SSI_DMA_BUF_DLLI)) {
>                 SSI_LOG_DEBUG(" data params addr %pad length 0x%X\n",
> -                             sg_dma_address(src), nbytes);
> +                             &sg_dma_address(src), nbytes);
>                 SSI_LOG_DEBUG(" data params addr %pad length 0x%X\n",
> -                             sg_dma_address(dst), nbytes);
> +                             &sg_dma_address(dst), nbytes);
>                 hw_desc_init(&desc[*seq_size]);
>                 set_din_type(&desc[*seq_size], DMA_DLLI, sg_dma_address(src),
>                              nbytes, NS_BIT);
> @@ -637,7 +637,7 @@ ssi_blkcipher_create_data_desc(
>                 /* bypass */
>                 SSI_LOG_DEBUG(" bypass params addr %pad "
>                              "length 0x%X addr 0x%08X\n",
> -                       req_ctx->mlli_params.mlli_dma_addr,
> +                       &req_ctx->mlli_params.mlli_dma_addr,
>                         req_ctx->mlli_params.mlli_len,
>                         (unsigned int)ctx_p->drvdata->mlli_sram_addr);
>                 hw_desc_init(&desc[*seq_size]);
> diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
> index e0faca0a30a6..6d9bacf5aae6 100644
> --- a/drivers/staging/ccree/ssi_driver.c
> +++ b/drivers/staging/ccree/ssi_driver.c
> @@ -250,10 +250,9 @@ static int init_cc_resources(struct platform_device *plat_dev)
>                 rc = -ENODEV;
>                 goto init_cc_res_err;
>         }
> -       SSI_LOG_DEBUG("Got MEM resource (%s): start=%pad end=%pad\n",
> +       SSI_LOG_DEBUG("Got MEM resource (%s): %pR\n",
>                       new_drvdata->res_mem->name,
> -                     new_drvdata->res_mem->start,
> -                     new_drvdata->res_mem->end);
> +                     new_drvdata->res_mem);
>         /* Map registers space */
>         req_mem_cc_regs = request_mem_region(new_drvdata->res_mem->start, resource_size(new_drvdata->res_mem), "arm_cc7x_regs");
>         if (unlikely(!req_mem_cc_regs)) {
> diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
> index b6ad89ae9bee..69a523321306 100644
> --- a/drivers/staging/ccree/ssi_driver.h
> +++ b/drivers/staging/ccree/ssi_driver.h
> @@ -100,7 +100,7 @@
>  #ifdef CC_DEBUG
>  #define SSI_LOG_DEBUG(format, ...) SSI_LOG(KERN_DEBUG, format, ##__VA_ARGS__)
>  #else /* Debug log messages are removed at compile time for non-DEBUG config. */
> -#define SSI_LOG_DEBUG(format, ...) do {} while (0)
> +#define SSI_LOG_DEBUG(format, ...) no_printk(format, ##__VA_ARGS__)
>  #endif
>
>  #define MIN(a, b) (((a) < (b)) ? (a) : (b))
> diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
> index fba0643e78fa..bb2e56b693f5 100644
> --- a/drivers/staging/ccree/ssi_hash.c
> +++ b/drivers/staging/ccree/ssi_hash.c
> @@ -141,7 +141,7 @@ static int ssi_hash_map_result(struct device *dev,
>         SSI_LOG_DEBUG("Mapped digest result buffer %u B "
>                      "at va=%pK to dma=%pad\n",
>                 digestsize, state->digest_result_buff,
> -               state->digest_result_dma_addr);
> +               &state->digest_result_dma_addr);
>
>         return 0;
>  }
> @@ -205,7 +205,7 @@ static int ssi_hash_map_request(struct device *dev,
>         }
>         SSI_LOG_DEBUG("Mapped digest %d B at va=%pK to dma=%pad\n",
>                 ctx->inter_digestsize, state->digest_buff,
> -               state->digest_buff_dma_addr);
> +               &state->digest_buff_dma_addr);
>
>         if (is_hmac) {
>                 dma_sync_single_for_cpu(dev, ctx->digest_buff_dma_addr, ctx->inter_digestsize, DMA_BIDIRECTIONAL);
> @@ -254,7 +254,7 @@ static int ssi_hash_map_request(struct device *dev,
>                 }
>                 SSI_LOG_DEBUG("Mapped digest len %u B at va=%pK to dma=%pad\n",
>                         HASH_LEN_SIZE, state->digest_bytes_len,
> -                       state->digest_bytes_len_dma_addr);
> +                       &state->digest_bytes_len_dma_addr);
>         } else {
>                 state->digest_bytes_len_dma_addr = 0;
>         }
> @@ -268,7 +268,7 @@ static int ssi_hash_map_request(struct device *dev,
>                 }
>                 SSI_LOG_DEBUG("Mapped opad digest %d B at va=%pK to dma=%pad\n",
>                         ctx->inter_digestsize, state->opad_digest_buff,
> -                       state->opad_digest_dma_addr);
> +                       &state->opad_digest_dma_addr);
>         } else {
>                 state->opad_digest_dma_addr = 0;
>         }
> @@ -322,21 +322,21 @@ static void ssi_hash_unmap_request(struct device *dev,
>                 dma_unmap_single(dev, state->digest_buff_dma_addr,
>                                  ctx->inter_digestsize, DMA_BIDIRECTIONAL);
>                 SSI_LOG_DEBUG("Unmapped digest-buffer: digest_buff_dma_addr=%pad\n",
> -                             state->digest_buff_dma_addr);
> +                             &state->digest_buff_dma_addr);
>                 state->digest_buff_dma_addr = 0;
>         }
>         if (state->digest_bytes_len_dma_addr != 0) {
>                 dma_unmap_single(dev, state->digest_bytes_len_dma_addr,
>                                  HASH_LEN_SIZE, DMA_BIDIRECTIONAL);
>                 SSI_LOG_DEBUG("Unmapped digest-bytes-len buffer: digest_bytes_len_dma_addr=%pad\n",
> -                             state->digest_bytes_len_dma_addr);
> +                             &state->digest_bytes_len_dma_addr);
>                 state->digest_bytes_len_dma_addr = 0;
>         }
>         if (state->opad_digest_dma_addr != 0) {
>                 dma_unmap_single(dev, state->opad_digest_dma_addr,
>                                  ctx->inter_digestsize, DMA_BIDIRECTIONAL);
>                 SSI_LOG_DEBUG("Unmapped opad-digest: opad_digest_dma_addr=%pad\n",
> -                             state->opad_digest_dma_addr);
> +                             &state->opad_digest_dma_addr);
>                 state->opad_digest_dma_addr = 0;
>         }
>
> @@ -360,7 +360,7 @@ static void ssi_hash_unmap_result(struct device *dev,
>                 SSI_LOG_DEBUG("unmpa digest result buffer "
>                              "va (%pK) pa (%pad) len %u\n",
>                              state->digest_result_buff,
> -                            state->digest_result_dma_addr,
> +                            &state->digest_result_dma_addr,
>                              digestsize);
>                 memcpy(result,
>                        state->digest_result_buff,
> @@ -1004,7 +1004,7 @@ static int ssi_hash_setkey(void *hash,
>                         return -ENOMEM;
>                 }
>                 SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad "
> -                            "keylen=%u\n", ctx->key_params.key_dma_addr,
> +                            "keylen=%u\n", &ctx->key_params.key_dma_addr,
>                              ctx->key_params.keylen);
>
>                 if (keylen > blocksize) {
> @@ -1148,7 +1148,7 @@ static int ssi_hash_setkey(void *hash,
>                                 ctx->key_params.key_dma_addr,
>                                 ctx->key_params.keylen, DMA_TO_DEVICE);
>                 SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
> -                               ctx->key_params.key_dma_addr,
> +                               &ctx->key_params.key_dma_addr,
>                                 ctx->key_params.keylen);
>         }
>         return rc;
> @@ -1187,7 +1187,7 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
>         }
>         SSI_LOG_DEBUG("mapping key-buffer: key_dma_addr=%pad "
>                      "keylen=%u\n",
> -                    ctx->key_params.key_dma_addr,
> +                    &ctx->key_params.key_dma_addr,
>                      ctx->key_params.keylen);
>
>         ctx->is_hmac = true;
> @@ -1235,7 +1235,7 @@ static int ssi_xcbc_setkey(struct crypto_ahash *ahash,
>                         ctx->key_params.key_dma_addr,
>                         ctx->key_params.keylen, DMA_TO_DEVICE);
>         SSI_LOG_DEBUG("Unmapped key-buffer: key_dma_addr=%pad keylen=%u\n",
> -                       ctx->key_params.key_dma_addr,
> +                       &ctx->key_params.key_dma_addr,
>                         ctx->key_params.keylen);
>
>         return rc;
> @@ -1291,7 +1291,7 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
>                                  sizeof(ctx->digest_buff), DMA_BIDIRECTIONAL);
>                 SSI_LOG_DEBUG("Unmapped digest-buffer: "
>                              "digest_buff_dma_addr=%pad\n",
> -                             ctx->digest_buff_dma_addr);
> +                             &ctx->digest_buff_dma_addr);
>                 ctx->digest_buff_dma_addr = 0;
>         }
>         if (ctx->opad_tmp_keys_dma_addr != 0) {
> @@ -1300,7 +1300,7 @@ static void ssi_hash_free_ctx(struct ssi_hash_ctx *ctx)
>                                  DMA_BIDIRECTIONAL);
>                 SSI_LOG_DEBUG("Unmapped opad-digest: "
>                              "opad_tmp_keys_dma_addr=%pad\n",
> -                             ctx->opad_tmp_keys_dma_addr);
> +                             &ctx->opad_tmp_keys_dma_addr);
>                 ctx->opad_tmp_keys_dma_addr = 0;
>         }
>
> @@ -1321,7 +1321,7 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
>         }
>         SSI_LOG_DEBUG("Mapped digest %zu B at va=%pK to dma=%pad\n",
>                 sizeof(ctx->digest_buff), ctx->digest_buff,
> -                     ctx->digest_buff_dma_addr);
> +                     &ctx->digest_buff_dma_addr);
>
>         ctx->opad_tmp_keys_dma_addr = dma_map_single(dev, (void *)ctx->opad_tmp_keys_buff, sizeof(ctx->opad_tmp_keys_buff), DMA_BIDIRECTIONAL);
>         if (dma_mapping_error(dev, ctx->opad_tmp_keys_dma_addr)) {
> @@ -1332,7 +1332,7 @@ static int ssi_hash_alloc_ctx(struct ssi_hash_ctx *ctx)
>         }
>         SSI_LOG_DEBUG("Mapped opad_tmp_keys %zu B at va=%pK to dma=%pad\n",
>                 sizeof(ctx->opad_tmp_keys_buff), ctx->opad_tmp_keys_buff,
> -                     ctx->opad_tmp_keys_dma_addr);
> +                     &ctx->opad_tmp_keys_dma_addr);
>
>         ctx->is_hmac = false;
>         return 0;
> diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
> index 3f39150cda4f..5ee1c07f69de 100644
> --- a/drivers/staging/ccree/ssi_request_mgr.c
> +++ b/drivers/staging/ccree/ssi_request_mgr.c
> @@ -324,9 +324,9 @@ int send_request(
>         if (ssi_req->ivgen_dma_addr_len > 0) {
>                 SSI_LOG_DEBUG("Acquire IV from pool into %d DMA addresses %pad, %pad, %pad, IV-size=%u\n",
>                               ssi_req->ivgen_dma_addr_len,
> -                             ssi_req->ivgen_dma_addr[0],
> -                             ssi_req->ivgen_dma_addr[1],
> -                             ssi_req->ivgen_dma_addr[2],
> +                             &ssi_req->ivgen_dma_addr[0],
> +                             &ssi_req->ivgen_dma_addr[1],
> +                             &ssi_req->ivgen_dma_addr[2],
>                               ssi_req->ivgen_size);
>
>                 /* Acquire IV from pool */
> --
> 2.10.0.rc2.1.g053435c
>



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
