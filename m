From: Sonic Zhang <sonic.adi@gmail.com>
Subject: Re: [PATCH 2/2] crypto: bfin_crc: CRC hardware accelerator driver for
 BF60x family processors.
Date: Tue, 29 May 2012 18:29:10 +0800
Message-ID: <CAJxxZ0M-4G+Lu13VxG9gN56o+m-atYx1Q_FiCZ2BB20Ym3P+gA@mail.gmail.com>
References: <1337939654-12222-1-git-send-email-sonic.adi@gmail.com>
	<1337939654-12222-2-git-send-email-sonic.adi@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	uclinux-dist-devel@blackfin.uclinux.org,
	Sonic Zhang <sonic.zhang@analog.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47740 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2E2K3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 May 2012 06:29:15 -0400
In-Reply-To: <1337939654-12222-2-git-send-email-sonic.adi@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

PING

On Fri, May 25, 2012 at 5:54 PM, Sonic Zhang <sonic.adi@gmail.com> wrot=
e:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> The CRC peripheral is a hardware block used to compute the CRC of the=
 block
> of data. This is based on a CRC32 engine which computes the CRC value=
 of 32b
> data words presented to it. For data words of < 32b in size, this dri=
ver
> pack 0 automatically into 32b data units. This driver implements the =
async
> hash crypto framework API.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> ---
> =A0drivers/crypto/Kconfig =A0 =A0| =A0 =A07 +
> =A0drivers/crypto/Makefile =A0 | =A0 =A03 +-
> =A0drivers/crypto/bfin_crc.c | =A0789 +++++++++++++++++++++++++++++++=
++++++++++++++
> =A03 files changed, 798 insertions(+), 1 deletions(-)
> =A0create mode 100644 drivers/crypto/bfin_crc.c
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 69fdf18..a520b93 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -306,4 +306,11 @@ if CRYPTO_DEV_UX500
> =A0 =A0 =A0 =A0source "drivers/crypto/ux500/Kconfig"
> =A0endif # if CRYPTO_DEV_UX500
>
> +config CRYPTO_DEV_BFIN_CRC
> + =A0 =A0 =A0 tristate "Support for Blackfin CRC hareware accelerator=
"
> + =A0 =A0 =A0 depends on BF60x
> + =A0 =A0 =A0 help
> + =A0 =A0 =A0 =A0 Blackfin processors have CRC hardware accelerator. =
Select this if you
> + =A0 =A0 =A0 =A0 want to use the Blackfin CRC module.
> +
> =A0endif # CRYPTO_HW
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 0139032..d5062bb 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -14,4 +14,5 @@ obj-$(CONFIG_CRYPTO_DEV_OMAP_AES) +=3D omap-aes.o
> =A0obj-$(CONFIG_CRYPTO_DEV_PICOXCELL) +=3D picoxcell_crypto.o
> =A0obj-$(CONFIG_CRYPTO_DEV_S5P) +=3D s5p-sss.o
> =A0obj-$(CONFIG_CRYPTO_DEV_TEGRA_AES) +=3D tegra-aes.o
> -obj-$(CONFIG_CRYPTO_DEV_UX500) +=3D ux500/
> \ No newline at end of file
> +obj-$(CONFIG_CRYPTO_DEV_UX500) +=3D ux500/
> +obj-$(CONFIG_CRYPTO_DEV_BFIN_CRC) +=3D bfin_crc.o
> diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
> new file mode 100644
> index 0000000..477b6a3
> --- /dev/null
> +++ b/drivers/crypto/bfin_crc.c
> @@ -0,0 +1,789 @@
> +/*
> + * Cryptographic API.
> + *
> + * Support Blackfin CRC HW acceleration.
> + *
> + * Copyright 2012 Analog Devices Inc.
> + *
> + * Licensed under the GPL-2.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/errno.h>
> +#include <linux/interrupt.h>
> +#include <linux/kernel.h>
> +#include <linux/irq.h>
> +#include <linux/io.h>
> +#include <linux/platform_device.h>
> +#include <linux/scatterlist.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/delay.h>
> +#include <linux/crypto.h>
> +#include <linux/cryptohash.h>
> +#include <crypto/scatterwalk.h>
> +#include <crypto/algapi.h>
> +#include <crypto/hash.h>
> +#include <crypto/internal/hash.h>
> +
> +#include <asm/blackfin.h>
> +#include <asm/bfin_crc.h>
> +#include <asm/dma.h>
> +#include <asm/portmux.h>
> +
> +#define CRC_CCRYPTO_QUEUE_LENGTH =A0 =A0 =A0 5
> +
> +#define DRIVER_NAME "bfin-hmac-crc"
> +#define CHKSUM_DIGEST_SIZE =A0 =A0 =A04
> +#define CHKSUM_BLOCK_SIZE =A0 =A0 =A0 1
> +
> +#define CRC_MAX_DMA_DESC =A0 =A0 =A0 100
> +
> +#define CRC_CRYPTO_STATE_UPDATE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A01
> +#define CRC_CRYPTO_STATE_FINALUPDATE =A0 2
> +#define CRC_CRYPTO_STATE_FINISH =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A03
> +
> +struct bfin_crypto_crc {
> + =A0 =A0 =A0 struct list_head =A0 =A0 =A0 =A0list;
> + =A0 =A0 =A0 struct device =A0 =A0 =A0 =A0 =A0 *dev;
> + =A0 =A0 =A0 spinlock_t =A0 =A0 =A0 =A0 =A0 =A0 =A0lock;
> +
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 irq;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_ch;
> + =A0 =A0 =A0 u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 poly;
> + =A0 =A0 =A0 volatile struct crc_register *regs;
> +
> + =A0 =A0 =A0 struct ahash_request =A0 =A0*req; /* current request in=
 operation */
> + =A0 =A0 =A0 struct dma_desc_array =A0 *sg_cpu; /* virt addr of sg d=
ma descriptors */
> + =A0 =A0 =A0 dma_addr_t =A0 =A0 =A0 =A0 =A0 =A0 =A0sg_dma; /* phy ad=
dr of sg dma descriptors */
> + =A0 =A0 =A0 u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*sg_mid_b=
uf;
> +
> + =A0 =A0 =A0 struct tasklet_struct =A0 done_task;
> + =A0 =A0 =A0 struct crypto_queue =A0 =A0 queue; /* waiting requests =
*/
> +
> + =A0 =A0 =A0 u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0busy:1; /=
* crc device in operation flag */
> +};
> +
> +struct bfin_crypto_crc_list {
> + =A0 =A0 =A0 struct list_head =A0 =A0 =A0 =A0dev_list;
> + =A0 =A0 =A0 spinlock_t =A0 =A0 =A0 =A0 =A0 =A0 =A0lock;
> +} crc_list;
> +
> +struct bfin_crypto_crc_reqctx {
> + =A0 =A0 =A0 struct bfin_crypto_crc =A0*crc;
> +
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0total; =A0/* total =
request bytes */
> + =A0 =A0 =A0 size_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sg_buflen; /*=
 bytes for this update */
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0sg_nents;
> + =A0 =A0 =A0 struct scatterlist =A0 =A0 =A0*sg; /* sg list head for =
this update*/
> + =A0 =A0 =A0 struct scatterlist =A0 =A0 =A0bufsl[2]; /* chained sg l=
ist */
> +
> + =A0 =A0 =A0 size_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bufnext_len;
> + =A0 =A0 =A0 size_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buflast_len;
> + =A0 =A0 =A0 u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bufnext[C=
HKSUM_DIGEST_SIZE]; /* extra bytes for next udpate */
> + =A0 =A0 =A0 u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0buflast[C=
HKSUM_DIGEST_SIZE]; /* extra bytes from last udpate */
> +
> + =A0 =A0 =A0 u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flag;
> +};
> +
> +struct bfin_crypto_crc_ctx {
> + =A0 =A0 =A0 struct bfin_crypto_crc =A0*crc;
> + =A0 =A0 =A0 u32 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key;
> +};
> +
> +
> +/*
> + * derive number of elements in scatterlist
> + */
> +static int sg_count(struct scatterlist *sg_list)
> +{
> + =A0 =A0 =A0 struct scatterlist *sg =3D sg_list;
> + =A0 =A0 =A0 int sg_nents =3D 1;
> +
> + =A0 =A0 =A0 if (sg_list =3D=3D NULL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 while (!sg_is_last(sg)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg_nents++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg =3D scatterwalk_sg_next(sg);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return sg_nents;
> +}
> +
> +/*
> + * get element in scatter list by given index
> + */
> +static struct scatterlist *sg_get(struct scatterlist *sg_list, unsig=
ned int nents,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigne=
d int index)
> +{
> + =A0 =A0 =A0 struct scatterlist *sg =3D NULL;
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 for_each_sg(sg_list, sg, nents, i)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (i =3D=3D index)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> +
> + =A0 =A0 =A0 return sg;
> +}
> +
> +static int bfin_crypto_crc_init_hw(struct bfin_crypto_crc *crc, u32 =
key)
> +{
> + =A0 =A0 =A0 crc->regs->datacntrld =3D 0;
> + =A0 =A0 =A0 crc->regs->control =3D MODE_CALC_CRC << OPMODE_OFFSET;
> + =A0 =A0 =A0 crc->regs->curresult =3D key;
> +
> + =A0 =A0 =A0 /* setup CRC interrupts */
> + =A0 =A0 =A0 crc->regs->status =3D CMPERRI | DCNTEXPI;
> + =A0 =A0 =A0 crc->regs->intrenset =3D CMPERRI | DCNTEXPI;
> + =A0 =A0 =A0 SSYNC();
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int bfin_crypto_crc_init(struct ahash_request *req)
> +{
> + =A0 =A0 =A0 struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> + =A0 =A0 =A0 struct bfin_crypto_crc_ctx *crc_ctx =3D crypto_ahash_ct=
x(tfm);
> + =A0 =A0 =A0 struct bfin_crypto_crc_reqctx *ctx =3D ahash_request_ct=
x(req);
> + =A0 =A0 =A0 struct bfin_crypto_crc *crc;
> +
> + =A0 =A0 =A0 dev_dbg(crc->dev, "crc_init\n");
> + =A0 =A0 =A0 spin_lock_bh(&crc_list.lock);
> + =A0 =A0 =A0 list_for_each_entry(crc, &crc_list.dev_list, list) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc_ctx->crc =3D crc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock_bh(&crc_list.lock);
> +
> + =A0 =A0 =A0 if (sg_count(req->src) > CRC_MAX_DMA_DESC) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(crc->dev, "init: requested sg l=
ist is too big > %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CRC_MAX_DMA_DESC);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ctx->crc =3D crc;
> + =A0 =A0 =A0 ctx->bufnext_len =3D 0;
> + =A0 =A0 =A0 ctx->buflast_len =3D 0;
> + =A0 =A0 =A0 ctx->sg_buflen =3D 0;
> + =A0 =A0 =A0 ctx->total =3D 0;
> + =A0 =A0 =A0 ctx->flag =3D 0;
> +
> + =A0 =A0 =A0 /* init crc results */
> + =A0 =A0 =A0 *(__le32 *)req->result =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le32p(&crc_ctx->key);
> +
> + =A0 =A0 =A0 dev_dbg(crc->dev, "init: digest size: %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_ahash_digestsize(tfm));
> +
> + =A0 =A0 =A0 return bfin_crypto_crc_init_hw(crc, crc_ctx->key);
> +}
> +
> +static void bfin_crypto_crc_config_dma(struct bfin_crypto_crc *crc)
> +{
> + =A0 =A0 =A0 struct scatterlist *sg;
> + =A0 =A0 =A0 struct bfin_crypto_crc_reqctx *ctx =3D ahash_request_ct=
x(crc->req);
> + =A0 =A0 =A0 int i =3D 0, j =3D 0;
> + =A0 =A0 =A0 unsigned long dma_config;
> + =A0 =A0 =A0 unsigned int dma_count;
> + =A0 =A0 =A0 unsigned int dma_addr;
> + =A0 =A0 =A0 unsigned int mid_dma_count =3D 0;
> + =A0 =A0 =A0 int dma_mod;
> +
> + =A0 =A0 =A0 dma_map_sg(crc->dev, ctx->sg, ctx->sg_nents, DMA_TO_DEV=
ICE);
> +
> + =A0 =A0 =A0 for_each_sg(ctx->sg, sg, ctx->sg_nents, j) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_config =3D DMAFLOW_ARRAY | RESTART =
| NDSIZE_3 | DMAEN | PSIZE_32;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_addr =3D sg_dma_address(sg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* deduce extra bytes in last sg */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sg_is_last(sg))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_count =3D sg_dma_le=
n(sg) - ctx->bufnext_len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_count =3D sg_dma_le=
n(sg);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_dma_count) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Append last middle d=
ma buffer to 4 bytes with first
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes in current=
 sg buffer. Move addr of current
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sg and deduce th=
e length of current sg.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(crc->sg_mid_buf =
+((i-1) << 2) + mid_dma_count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void *=
)dma_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CHKSUM_=
DIGEST_SIZE - mid_dma_count);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_addr +=3D CHKSUM_DI=
GEST_SIZE - mid_dma_count;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_count -=3D CHKSUM_D=
IGEST_SIZE - mid_dma_count;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* chop current sg dma len to multiply =
of 32 bits */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_dma_count =3D dma_count % 4;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_count =3D (dma_count >> 2) << 2;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (dma_addr % 4 =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_config |=3D WDSIZE_=
32;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_count >>=3D 2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_mod =3D 4;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (dma_addr % 2 =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_config |=3D WDSIZE_=
16;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_count >>=3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_mod =3D 2;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_config |=3D WDSIZE_=
8;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_mod =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].start_addr =3D dma_addr;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].cfg =3D dma_config;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].x_count =3D dma_count;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].x_modify =3D dma_mod;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(crc->dev, "%d: crc_dma: start_a=
ddr:0x%lx, "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "cfg:0x%lx, x_count:0x%=
lx, x_modify:0x%lx\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i, crc->sg_cpu[i].start=
_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].cfg, crc=
->sg_cpu[i].x_count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].x_modify=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mid_dma_count) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy extra bytes to =
next middle dma buffer */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_config =3D DMAFLOW_=
ARRAY | RESTART | NDSIZE_3 |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMAEN |=
 PSIZE_32 | WDSIZE_32;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(crc->sg_mid_buf =
+ (i << 2),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void *=
)(dma_addr + (dma_count << 2)),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 mid_dma=
_count);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* setup new dma descri=
ptor for next middle dma */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].start_ad=
dr =3D dma_map_single(crc->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 crc->sg_mid_buf + (i << 2),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 CHKSUM_DIGEST_SIZE, DMA_TO_DEVICE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].cfg =3D =
dma_config;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].x_count =
=3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].x_modify=
 =3D CHKSUM_DIGEST_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(crc->dev, "%d: =
crc_dma: start_addr:0x%lx, "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "cfg:0x=
%lx, x_count:0x%lx, x_modify:0x%lx\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i, crc-=
>sg_cpu[i].start_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg=
_cpu[i].cfg, crc->sg_cpu[i].x_count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg=
_cpu[i].x_modify);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 dma_config =3D DMAFLOW_ARRAY | RESTART | NDSIZE_3 | DMA=
EN | PSIZE_32 | WDSIZE_32;
> + =A0 =A0 =A0 /* For final update req, append the buffer for next upd=
ate as well*/
> + =A0 =A0 =A0 if (ctx->bufnext_len && (ctx->flag =3D=3D CRC_CRYPTO_ST=
ATE_FINALUPDATE ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->flag =3D=3D CRC_CRYPTO_STATE_FINIS=
H)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].start_addr =3D dma_map_s=
ingle(crc->dev, ctx->bufnext,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 CHKSUM_DIGEST_SIZE, DMA_TO_DEVICE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].cfg =3D dma_config;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].x_count =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].x_modify =3D CHKSUM_DIGE=
ST_SIZE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(crc->dev, "%d: crc_dma: start_a=
ddr:0x%lx, "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "cfg:0x%lx, x_count:0x%=
lx, x_modify:0x%lx\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i, crc->sg_cpu[i].start=
_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].cfg, crc=
->sg_cpu[i].x_count,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->sg_cpu[i].x_modify=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 i++;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (i =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ;
> +
> + =A0 =A0 =A0 flush_dcache_range((unsigned int)crc->sg_cpu,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (unsigned int)crc->sg_c=
pu +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 i * sizeof(struct dma_d=
esc_array));
> +
> + =A0 =A0 =A0 /* Set the last descriptor to stop mode */
> + =A0 =A0 =A0 crc->sg_cpu[i - 1].cfg &=3D ~(DMAFLOW | NDSIZE);
> + =A0 =A0 =A0 crc->sg_cpu[i - 1].cfg |=3D DI_EN;
> + =A0 =A0 =A0 set_dma_curr_desc_addr(crc->dma_ch, (unsigned long *)cr=
c->sg_dma);
> + =A0 =A0 =A0 set_dma_x_count(crc->dma_ch, 0);
> + =A0 =A0 =A0 set_dma_x_modify(crc->dma_ch, 0);
> + =A0 =A0 =A0 SSYNC();
> + =A0 =A0 =A0 set_dma_config(crc->dma_ch, dma_config);
> +}
> +
> +#define MIN(x,y) ((x) < (y) ? x : y)
> +
> +static int bfin_crypto_crc_handle_queue(struct bfin_crypto_crc *crc,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 str=
uct ahash_request *req)
> +{
> + =A0 =A0 =A0 struct crypto_async_request *async_req, *backlog;
> + =A0 =A0 =A0 struct bfin_crypto_crc_reqctx *ctx;
> + =A0 =A0 =A0 struct scatterlist *sg;
> + =A0 =A0 =A0 int ret =3D 0;
> + =A0 =A0 =A0 int nsg, i, j, nextlen;
> + =A0 =A0 =A0 unsigned long flags;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(&crc->lock, flags);
> + =A0 =A0 =A0 if (req)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D ahash_enqueue_request(&crc->que=
ue, req);
> + =A0 =A0 =A0 if (crc->busy) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&crc->lock, flag=
s);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 backlog =3D crypto_get_backlog(&crc->queue);
> + =A0 =A0 =A0 async_req =3D crypto_dequeue_request(&crc->queue);
> + =A0 =A0 =A0 if (async_req)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->busy =3D 1;
> + =A0 =A0 =A0 spin_unlock_irqrestore(&crc->lock, flags);
> +
> + =A0 =A0 =A0 if (!async_req)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> +
> + =A0 =A0 =A0 if (backlog)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 backlog->complete(backlog, -EINPROGRESS=
);
> +
> + =A0 =A0 =A0 req =3D ahash_request_cast(async_req);
> + =A0 =A0 =A0 crc->req =3D req;
> + =A0 =A0 =A0 ctx =3D ahash_request_ctx(req);
> + =A0 =A0 =A0 ctx->sg =3D NULL;
> + =A0 =A0 =A0 ctx->sg_buflen =3D 0;
> + =A0 =A0 =A0 ctx->sg_nents =3D 0;
> +
> + =A0 =A0 =A0 dev_dbg(crc->dev, "handling new req, flag=3D%u, nbytes:=
 %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 ctx->flag, req->nbytes);
> +
> + =A0 =A0 =A0 if (ctx->flag =3D=3D CRC_CRYPTO_STATE_FINISH) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctx->bufnext_len =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->busy =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Pack last crc update buffer to 32bit=
 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(ctx->bufnext + ctx->bufnext_len,=
 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CHKSUM_=
DIGEST_SIZE - ctx->bufnext_len);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Pack small data which is less than 3=
2bit to buffer for next update.*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctx->bufnext_len + req->nbytes < CH=
KSUM_DIGEST_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ctx->bufnext + c=
tx->bufnext_len,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg_virt=
(req->src), req->nbytes);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->bufnext_len +=3D r=
eq->nbytes;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctx->flag =3D=3D CR=
C_CRYPTO_STATE_FINALUPDATE &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->bu=
fnext_len) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto fi=
nish_update;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->bu=
sy =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctx->bufnext_len) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Chain in extra bytes=
 of last update */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->buflast_len =3D ct=
x->bufnext_len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ctx->buflast, ct=
x->bufnext, ctx->buflast_len);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nsg =3D ctx->sg_buflen =
? 2 : 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg_init_table(ctx->bufs=
l, nsg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg_set_buf(ctx->bufsl, =
ctx->buflast, ctx->buflast_len);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nsg > 1)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 scatter=
walk_sg_chain(ctx->bufsl, nsg,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 req->src);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->sg =3D ctx->bufsl;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->sg =3D req->src;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* punch crc buffer size to multiply of=
 32 bit */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 nsg =3D ctx->sg_nents =3D sg_count(ctx-=
>sg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->sg_buflen =3D ctx->buflast_len + r=
eq->nbytes;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->bufnext_len =3D ctx->sg_buflen % 4=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->sg_buflen =3D (ctx->sg_buflen >> 2=
) << 2;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctx->bufnext_len) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy extra bytes to =
buffer for next update */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(ctx->bufnext, 0,=
 CHKSUM_DIGEST_SIZE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nextlen =3D ctx->bufnex=
t_len;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D nsg - 1; i >=
=3D 0; i--) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg =3D =
sg_get(ctx->sg, nsg, i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 j =3D M=
IN(nextlen, sg_dma_len(sg));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(=
ctx->bufnext + nextlen - j,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sg_virt(sg) + sg_dma_len(sg) - j, j);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (j =3D=
=3D sg_dma_len(sg))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 ctx->sg_nents--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nextlen=
 -=3D j;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (nex=
tlen =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> +finish_update:
> + =A0 =A0 =A0 if (ctx->bufnext_len && (ctx->flag =3D=3D CRC_CRYPTO_ST=
ATE_FINALUPDATE ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->flag =3D=3D CRC_CRYPTO_STATE_FINIS=
H))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ctx->sg_buflen +=3D CHKSUM_DIGEST_SIZE;
> +
> + =A0 =A0 =A0 /* set CRC data count before start DMA */
> + =A0 =A0 =A0 crc->regs->datacnt =3D ctx->sg_buflen >> 2;
> +
> + =A0 =A0 =A0 /* setup and enable CRC DMA */
> + =A0 =A0 =A0 bfin_crypto_crc_config_dma(crc);
> +
> + =A0 =A0 =A0 /* finally kick off CRC operation */
> + =A0 =A0 =A0 crc->regs->control |=3D BLKEN;
> + =A0 =A0 =A0 SSYNC();
> +
> + =A0 =A0 =A0 return -EINPROGRESS;
> +}
> +
> +static int bfin_crypto_crc_update(struct ahash_request *req)
> +{
> + =A0 =A0 =A0 struct bfin_crypto_crc_reqctx *ctx =3D ahash_request_ct=
x(req);
> +
> + =A0 =A0 =A0 if (!req->nbytes)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> +
> + =A0 =A0 =A0 dev_dbg(ctx->crc->dev, "crc_update\n");
> + =A0 =A0 =A0 ctx->total +=3D req->nbytes;
> + =A0 =A0 =A0 ctx->flag =3D CRC_CRYPTO_STATE_UPDATE;
> +
> + =A0 =A0 =A0 return bfin_crypto_crc_handle_queue(ctx->crc, req);
> +}
> +
> +static int bfin_crypto_crc_final(struct ahash_request *req)
> +{
> + =A0 =A0 =A0 struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> + =A0 =A0 =A0 struct bfin_crypto_crc_ctx *crc_ctx =3D crypto_ahash_ct=
x(tfm);
> + =A0 =A0 =A0 struct bfin_crypto_crc_reqctx *ctx =3D ahash_request_ct=
x(req);
> +
> + =A0 =A0 =A0 dev_dbg(ctx->crc->dev, "crc_final\n");
> + =A0 =A0 =A0 ctx->flag =3D CRC_CRYPTO_STATE_FINISH;
> + =A0 =A0 =A0 crc_ctx->key =3D 0;
> +
> + =A0 =A0 =A0 return bfin_crypto_crc_handle_queue(ctx->crc, req);
> +}
> +
> +static int bfin_crypto_crc_finup(struct ahash_request *req)
> +{
> + =A0 =A0 =A0 struct crypto_ahash *tfm =3D crypto_ahash_reqtfm(req);
> + =A0 =A0 =A0 struct bfin_crypto_crc_ctx *crc_ctx =3D crypto_ahash_ct=
x(tfm);
> + =A0 =A0 =A0 struct bfin_crypto_crc_reqctx *ctx =3D ahash_request_ct=
x(req);
> +
> + =A0 =A0 =A0 dev_dbg(ctx->crc->dev, "crc_finishupdate\n");
> + =A0 =A0 =A0 ctx->total +=3D req->nbytes;
> + =A0 =A0 =A0 ctx->flag =3D CRC_CRYPTO_STATE_FINALUPDATE;
> + =A0 =A0 =A0 crc_ctx->key =3D 0;
> +
> + =A0 =A0 =A0 return bfin_crypto_crc_handle_queue(ctx->crc, req);
> +}
> +
> +static int bfin_crypto_crc_digest(struct ahash_request *req)
> +{
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 ret =3D bfin_crypto_crc_init(req);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> +
> + =A0 =A0 =A0 return bfin_crypto_crc_finup(req);
> +}
> +
> +static int bfin_crypto_crc_setkey(struct crypto_ahash *tfm, const u8=
 *key,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int keylen)
> +{
> + =A0 =A0 =A0 struct bfin_crypto_crc_ctx *crc_ctx =3D crypto_ahash_ct=
x(tfm);
> +
> + =A0 =A0 =A0 dev_dbg(crc_ctx->crc->dev, "crc_setkey\n");
> + =A0 =A0 =A0 =A0if (keylen !=3D CHKSUM_DIGEST_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0crypto_ahash_set_flags(tfm, CRYPTO_T=
=46M_RES_BAD_KEY_LEN);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -EINVAL;
> + =A0 =A0 =A0 =A0}
> +
> + =A0 =A0 =A0 crc_ctx->key =3D le32_to_cpu(*(__le32 *)key);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int bfin_crypto_crc_cra_init(struct crypto_tfm *tfm)
> +{
> + =A0 =A0 =A0 struct bfin_crypto_crc_ctx *crc_ctx =3D crypto_tfm_ctx(=
tfm);
> +
> + =A0 =A0 =A0 crc_ctx->key =3D 0;
> + =A0 =A0 =A0 crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0size=
of(struct bfin_crypto_crc_reqctx));
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static void bfin_crypto_crc_cra_exit(struct crypto_tfm *tfm)
> +{
> +}
> +
> +static struct ahash_alg algs =3D {
> + =A0 =A0 =A0 .init =A0 =A0 =A0 =A0 =A0 =3D bfin_crypto_crc_init,
> + =A0 =A0 =A0 .update =A0 =A0 =A0 =A0 =3D bfin_crypto_crc_update,
> + =A0 =A0 =A0 .final =A0 =A0 =A0 =A0 =A0=3D bfin_crypto_crc_final,
> + =A0 =A0 =A0 .finup =A0 =A0 =A0 =A0 =A0=3D bfin_crypto_crc_finup,
> + =A0 =A0 =A0 .digest =A0 =A0 =A0 =A0 =3D bfin_crypto_crc_digest,
> + =A0 =A0 =A0 .setkey =A0 =A0 =A0 =A0 =3D bfin_crypto_crc_setkey,
> + =A0 =A0 =A0 .halg.digestsize =A0 =A0 =A0 =A0=3D CHKSUM_DIGEST_SIZE,
> + =A0 =A0 =A0 .halg.base =A0 =A0 =A0=3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=
 "hmac(crc32)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_driver_name =A0 =A0 =A0 =A0=3D DRI=
VER_NAME,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_priority =A0 =A0 =A0 =A0 =A0 =3D 1=
00,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_flags =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 CRYPTO_ALG_TYPE_AHASH |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 CRYPTO_ALG_ASYNC,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_blocksize =A0 =A0 =A0 =A0 =A0=3D C=
HKSUM_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_ctxsize =A0 =A0 =A0 =A0 =A0 =A0=3D=
 sizeof(struct bfin_crypto_crc_ctx),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_alignmask =A0 =A0 =A0 =A0 =A0=3D 3=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_module =A0 =A0 =A0 =A0 =A0 =A0 =3D=
 THIS_MODULE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_init =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=
 bfin_crypto_crc_cra_init,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_exit =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=
 bfin_crypto_crc_cra_exit,
> + =A0 =A0 =A0 }
> +};
> +
> +static void bfin_crypto_crc_done_task(unsigned long data)
> +{
> + =A0 =A0 =A0 struct bfin_crypto_crc *crc =3D (struct bfin_crypto_crc=
 *)data;
> +
> + =A0 =A0 =A0 bfin_crypto_crc_handle_queue(crc, NULL);
> +}
> +
> +static irqreturn_t bfin_crypto_crc_handler(int irq, void *dev_id)
> +{
> + =A0 =A0 =A0 struct bfin_crypto_crc *crc =3D dev_id;
> +
> + =A0 =A0 =A0 if (crc->regs->status & DCNTEXP) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->regs->status =3D DCNTEXP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 SSYNC();
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* prepare results */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *(__le32 *)crc->req->result =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le32p((u32 *)&cr=
c->regs->result);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->regs->control &=3D ~BLKEN;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->busy =3D 0;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (crc->req->base.complete)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->req->base.complete=
(&crc->req->base, 0);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tasklet_schedule(&crc->done_task);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return IRQ_HANDLED;
> + =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return IRQ_NONE;
> +}
> +
> +#ifdef CONFIG_PM
> +/**
> + * =A0 =A0 bfin_crypto_crc_suspend - suspend crc device
> + * =A0 =A0 @pdev: device being suspended
> + * =A0 =A0 @state: requested suspend state
> + */
> +static int bfin_crypto_crc_suspend(struct platform_device *pdev, pm_=
message_t state)
> +{
> + =A0 =A0 =A0 struct bfin_crypto_crc *crc =3D platform_get_drvdata(pd=
ev);
> + =A0 =A0 =A0 int i =3D 100000;
> +
> + =A0 =A0 =A0 while ((crc->regs->control & BLKEN) && --i)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_relax();
> +
> + =A0 =A0 =A0 if (i =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crc->regs->control &=3D ~BLKEN;
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * =A0 =A0 bfin_crypto_crc_resume - resume crc device
> + * =A0 =A0 @pdev: device being resumed
> + */
> +static int bfin_crypto_crc_resume(struct platform_device *pdev)
> +{
> + =A0 =A0 =A0 return 0;
> +}
> +#else
> +# define bfin_crypto_crc_suspend NULL
> +# define bfin_crypto_crc_resume NULL
> +#endif
> +
> +/**
> + * =A0 =A0 bfin_crypto_crc_probe - Initialize module
> + *
> + */
> +static int __devinit bfin_crypto_crc_probe(struct platform_device *p=
dev)
> +{
> + =A0 =A0 =A0 struct device *dev =3D &pdev->dev;
> + =A0 =A0 =A0 struct resource *res;
> + =A0 =A0 =A0 struct bfin_crypto_crc *crc =3D NULL;
> + =A0 =A0 =A0 unsigned int timeout =3D 100000;
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 crc =3D kzalloc(sizeof(*crc), GFP_KERNEL);
> + =A0 =A0 =A0 if (!crc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "fail to malloc bfi=
n_crypto_crc\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 crc->dev =3D dev;
> +
> + =A0 =A0 =A0 INIT_LIST_HEAD(&crc->list);
> + =A0 =A0 =A0 spin_lock_init(&crc->lock);
> + =A0 =A0 =A0 tasklet_init(&crc->done_task, bfin_crypto_crc_done_task=
, (unsigned long)crc);
> + =A0 =A0 =A0 crypto_init_queue(&crc->queue, CRC_CCRYPTO_QUEUE_LENGTH=
);
> +
> + =A0 =A0 =A0 res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> + =A0 =A0 =A0 if (res =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "Cannot get IORESOU=
RCE_MEM\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOENT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_error_free_mem;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 crc->regs =3D ioremap(res->start, resource_size(res));
> + =A0 =A0 =A0 if (!crc->regs) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "Cannot map CRC IO\=
n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENXIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_error_free_mem;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 crc->irq =3D platform_get_irq(pdev, 0);
> + =A0 =A0 =A0 if (crc->irq < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "No CRC DCNTEXP IRQ=
 specified\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOENT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_error_unmap;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ret =3D request_irq(crc->irq, bfin_crypto_crc_handler, =
IRQF_SHARED, DRIVER_NAME, crc);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "Unable to request =
blackfin crc irq\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_error_unmap;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 res =3D platform_get_resource(pdev, IORESOURCE_DMA, 0);
> + =A0 =A0 =A0 if (res =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "No CRC DMA channel=
 specified\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOENT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_error_irq;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 crc->dma_ch =3D res->start;
> +
> + =A0 =A0 =A0 ret =3D request_dma(crc->dma_ch, DRIVER_NAME);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "Unable to attach B=
lackfin CRC DMA channel\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_error_irq;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 crc->sg_cpu =3D dma_alloc_coherent(&pdev->dev, PAGE_SIZ=
E, &crc->sg_dma, GFP_KERNEL);
> + =A0 =A0 =A0 if (crc->sg_cpu =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_error_dma;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 /* need at most CRC_MAX_DMA_DESC sg + CRC_MAX_DMA_DESC =
middle =A0+
> + =A0 =A0 =A0 =A0 =A01 last + 1 next dma descriptors
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 crc->sg_mid_buf =3D (u8 *)(crc->sg_cpu + ((CRC_MAX_DMA_=
DESC + 1) << 1));
> +
> + =A0 =A0 =A0 crc->regs->control =3D 0;
> + =A0 =A0 =A0 SSYNC();
> + =A0 =A0 =A0 crc->regs->poly =3D crc->poly =3D (u32)pdev->dev.platfo=
rm_data;
> + =A0 =A0 =A0 SSYNC();
> +
> + =A0 =A0 =A0 while (!(crc->regs->status & LUTDONE) && (--timeout) > =
0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_relax();
> +
> + =A0 =A0 =A0 if (timeout =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_info(&pdev->dev, "init crc poly tim=
eout\n");
> +
> + =A0 =A0 =A0 spin_lock(&crc_list.lock);
> + =A0 =A0 =A0 list_add(&crc->list, &crc_list.dev_list);
> + =A0 =A0 =A0 spin_unlock(&crc_list.lock);
> +
> + =A0 =A0 =A0 platform_set_drvdata(pdev, crc);
> +
> + =A0 =A0 =A0 ret =3D crypto_register_ahash(&algs);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&crc_list.lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_del(&crc->list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&crc_list.lock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "Cann't register cr=
ypto ahash device\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_error_dma;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 dev_info(&pdev->dev, "initialized\n");
> +
> + =A0 =A0 =A0 return 0;
> +
> +out_error_dma:
> + =A0 =A0 =A0 if (crc->sg_cpu)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_free_coherent(&pdev->dev, PAGE_SIZE=
, crc->sg_cpu, crc->sg_dma);
> + =A0 =A0 =A0 free_dma(crc->dma_ch);
> +out_error_irq:
> + =A0 =A0 =A0 free_irq(crc->irq, crc->dev);
> +out_error_unmap:
> + =A0 =A0 =A0 iounmap((void *)crc->regs);
> +out_error_free_mem:
> + =A0 =A0 =A0 kfree(crc);
> +
> + =A0 =A0 =A0 return ret;
> +}
> +
> +/**
> + * =A0 =A0 bfin_crypto_crc_remove - Initialize module
> + *
> + */
> +static int __devexit bfin_crypto_crc_remove(struct platform_device *=
pdev)
> +{
> + =A0 =A0 =A0 struct bfin_crypto_crc *crc =3D platform_get_drvdata(pd=
ev);
> +
> + =A0 =A0 =A0 if (!crc)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENODEV;
> +
> + =A0 =A0 =A0 spin_lock(&crc_list.lock);
> + =A0 =A0 =A0 list_del(&crc->list);
> + =A0 =A0 =A0 spin_unlock(&crc_list.lock);
> +
> + =A0 =A0 =A0 crypto_unregister_ahash(&algs);
> + =A0 =A0 =A0 tasklet_kill(&crc->done_task);
> + =A0 =A0 =A0 iounmap((void *)crc->regs);
> + =A0 =A0 =A0 free_dma(crc->dma_ch);
> + =A0 =A0 =A0 if (crc->irq > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 free_irq(crc->irq, crc->dev);
> + =A0 =A0 =A0 kfree(crc);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static struct platform_driver bfin_crypto_crc_driver =3D {
> + =A0 =A0 =A0 .probe =A0 =A0 =3D bfin_crypto_crc_probe,
> + =A0 =A0 =A0 .remove =A0 =A0=3D __devexit_p(bfin_crypto_crc_remove),
> + =A0 =A0 =A0 .suspend =A0 =3D bfin_crypto_crc_suspend,
> + =A0 =A0 =A0 .resume =A0 =A0=3D bfin_crypto_crc_resume,
> + =A0 =A0 =A0 .driver =A0 =A0=3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .name =A0=3D DRIVER_NAME,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .owner =3D THIS_MODULE,
> + =A0 =A0 =A0 },
> +};
> +
> +/**
> + * =A0 =A0 bfin_crypto_crc_mod_init - Initialize module
> + *
> + * =A0 =A0 Checks the module params and registers the platform drive=
r.
> + * =A0 =A0 Real work is in the platform probe function.
> + */
> +static int __init bfin_crypto_crc_mod_init(void)
> +{
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 pr_info("Blackfin hardware CRC crypto driver\n");
> +
> + =A0 =A0 =A0 INIT_LIST_HEAD(&crc_list.dev_list);
> + =A0 =A0 =A0 spin_lock_init(&crc_list.lock);
> +
> + =A0 =A0 =A0 ret =3D platform_driver_register(&bfin_crypto_crc_drive=
r);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 pr_info(KERN_ERR "unable to register dr=
iver\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * =A0 =A0 bfin_crypto_crc_mod_exit - Deinitialize module
> + */
> +static void __exit bfin_crypto_crc_mod_exit(void)
> +{
> + =A0 =A0 =A0 platform_driver_unregister(&bfin_crypto_crc_driver);
> +}
> +
> +module_init(bfin_crypto_crc_mod_init);
> +module_exit(bfin_crypto_crc_mod_exit);
> +
> +MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
> +MODULE_DESCRIPTION("Blackfin CRC hardware crypto driver");
> +MODULE_LICENSE("GPL");
> --
> 1.7.0.4
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at =A0http://www.tux.org/lkml/
