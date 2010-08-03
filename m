From: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [RFC 9/9] crypto: Add Samsung crypto engine driver
Date: Tue, 3 Aug 2010 13:44:35 +0900
Message-ID: <AANLkTi=FKAdC9AwPR41MUBUjBZ2Zf1qv1DSQ+EnMHu7d@mail.gmail.com>
References: <cover.1276284559.git.mcuelenaere@gmail.com>
	<4C129341.2060407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net
To: Maurus Cuelenaere <mcuelenaere@gmail.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <4C129341.2060407@gmail.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Any update on this?

Thank you,
Kyungmin Park

On Sat, Jun 12, 2010 at 4:49 AM, Maurus Cuelenaere
<mcuelenaere@gmail.com> wrote:
> This patch adds support for the Samsung crypto engine driver availabl=
e in the
> S3C64XX and S5PC100 SoCs. Currently this supports AES and (T)DES with=
 ECB and
> CBC block ciphers (also CTR for AES). Support for (HMAC)-SHA1 acceler=
ation is
> also available in this engine, but isn't used in the driver yet.
>
> Support for DMA has been added in the code but is currently disabled =
due to
> issues with data transfers.
>
> Signed-off-by: Maurus Cuelenaere <mcuelenaere@gmail.com>
> ---
> =A0drivers/crypto/Kconfig =A0 | =A0 11 +
> =A0drivers/crypto/Makefile =A0| =A0 =A01 +
> =A0drivers/crypto/s3c-sss.c | 1320 ++++++++++++++++++++++++++++++++++=
++++++++++++
> =A03 files changed, 1332 insertions(+), 0 deletions(-)
> =A0create mode 100644 drivers/crypto/s3c-sss.c
>
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index b08403d..597a151 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -222,4 +222,15 @@ config CRYPTO_DEV_PPC4XX
> =A0 =A0 =A0 =A0help
> =A0 =A0 =A0 =A0 =A0This option allows you to have support for AMCC cr=
ypto acceleration.
>
> +config CRYPTO_DEV_SSS
> + =A0 =A0 =A0 tristate "Samsung Security Sub-Systems"
> + =A0 =A0 =A0 depends on SAMSUNG_DEV_SSS
> + =A0 =A0 =A0 select CRYPTO_ALGAPI
> + =A0 =A0 =A0 select CRYPTO_BLKCIPHER
> + =A0 =A0 =A0 select CRYPTO_DES
> + =A0 =A0 =A0 select CRYPTO_HASH
> + =A0 =A0 =A0 help
> + =A0 =A0 =A0 =A0 =A0 This driver utilizes the cryptographic engine i=
n Samsung S3C64XX
> + =A0 =A0 =A0 =A0 =A0 and S5PC100 SoCs.
> +
> =A0endif # CRYPTO_HW
> diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
> index 6ffcb3f..ef14b4d 100644
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_CRYPTO_DEV_MV_CESA) +=3D mv_cesa.o
> =A0obj-$(CONFIG_CRYPTO_DEV_TALITOS) +=3D talitos.o
> =A0obj-$(CONFIG_CRYPTO_DEV_IXP4XX) +=3D ixp4xx_crypto.o
> =A0obj-$(CONFIG_CRYPTO_DEV_PPC4XX) +=3D amcc/
> +obj-$(CONFIG_CRYPTO_DEV_SSS) +=3D s3c-sss.o
> diff --git a/drivers/crypto/s3c-sss.c b/drivers/crypto/s3c-sss.c
> new file mode 100644
> index 0000000..9fd5288
> --- /dev/null
> +++ b/drivers/crypto/s3c-sss.c
> @@ -0,0 +1,1320 @@
> +/*
> + * linux/drivers/crypto/s3c-sss.c
> + *
> + * Copyright (C) 2010 Maurus Cuelenaere
> + *
> + * Support for S3C64XX Security Sub-Systems
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +/*#define DEBUG*/
> +
> +#include <linux/clk.h>
> +#include <linux/crypto.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +#include <linux/timer.h>
> +
> +#include <crypto/internal/hash.h>
> +#include <crypto/algapi.h>
> +#include <crypto/aes.h>
> +#include <crypto/ctr.h>
> +#include <crypto/des.h>
> +#include <crypto/sha.h>
> +#include <crypto/scatterwalk.h>
> +
> +#include <mach/dma.h>
> +
> +#include <plat/regs-sss.h>
> +
> +#define SSS_CRA_PRIORITY =A0 =A0 =A0 300
> +#define SSS_MAX_KEY_SIZE =A0 =A0 =A0 AES_MAX_KEY_SIZE
> +#define SSS_FIFO_SIZE =A0 =A0 =A0 =A0 =A00x40U
> +#define SSS_TIMEOUT =A0 =A0 =A0 =A0 =A0 =A0(3*HZ)
> +
> +/**
> + * struct s3c_sss - driver state.
> + * @dev: pointer to the device struct
> + * @clock: clock associated with peripheral
> + * @irq: irq associated with peripheral
> + * @regs: pointer to mapped registers
> + * @regs_phys: pointer to physical address of registers
> + * @regs_res: pointer to struct resource representing registers
> + * @cur_req: pointer to pending request (NULL indicates no current r=
equest)
> + * @dma_client: struct used for passing to DMA core
> + * @lock: lock used for synchronizing queue accesses
> + * @tasklet: tasklet doing the main work
> + * @timer: timer used for timing out faulty requests
> + * @queue: queue containing requests
> + */
> +struct s3c_sss {
> + =A0 =A0 =A0 struct device =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *dev;
> +
> + =A0 =A0 =A0 struct clk =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*=
clock;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 irq;
> + =A0 =A0 =A0 void __iomem =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*re=
gs;
> + =A0 =A0 =A0 void __iomem =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*re=
gs_phys;
> + =A0 =A0 =A0 struct resource =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *regs_r=
es;
> +
> + =A0 =A0 =A0 struct ablkcipher_request =A0 =A0 =A0 *cur_req;
> + =A0 =A0 =A0 struct s3c2410_dma_client =A0 =A0 =A0 dma_client;
> + =A0 =A0 =A0 spinlock_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0l=
ock;
> + =A0 =A0 =A0 struct tasklet_struct =A0 =A0 =A0 =A0 =A0 tasklet;
> + =A0 =A0 =A0 struct timer_list =A0 =A0 =A0 =A0 =A0 =A0 =A0 timer;
> + =A0 =A0 =A0 struct crypto_queue =A0 =A0 =A0 =A0 =A0 =A0 queue;
> +};
> +
> +/**
> + * struct sss_context - cipher/hash key state
> + * @key: storage for the key
> + * @key_len: length of the key
> + * @dev: pointer to struct containing the driver state
> + */
> +struct sss_context {
> + =A0 =A0 =A0 u8 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0key[SSS_MAX_KEY_SIZE];
> + =A0 =A0 =A0 unsigned int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0key=
_len;
> +
> + =A0 =A0 =A0 struct s3c_sss =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*dev;
> +};
> +
> +/**
> + * struct sss_fifo_channel - FIFO handling state
> + *
> + * @cur_sg: scatterlist used in current transfer
> + * @offset: offset within current scatterlist
> + * @dir: FIFO direction
> + * @sg: pointer to scatter-gather lists
> + * @sg_count: amount of scatter-gather lists
> + * @req_size: size of current request
> + * @bytes_done: amount of data transferred
> + * @dev: pointer to struct containing the driver state
> + */
> +struct sss_fifo_channel {
> + =A0 =A0 =A0 /* DMA */
> + =A0 =A0 =A0 struct scatterlist =A0 =A0 =A0 =A0 =A0 =A0 =A0*cur_sg;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 offset;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sg_count;
> +
> + =A0 =A0 =A0 /* generic */
> + =A0 =A0 =A0 enum {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 FIFO_RX,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 FIFO_TX
> + =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 dir;
> + =A0 =A0 =A0 struct scatterlist =A0 =A0 =A0 =A0 =A0 =A0 =A0*sg;
> + =A0 =A0 =A0 size_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0req_size;
> + =A0 =A0 =A0 size_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0bytes_done;
> + =A0 =A0 =A0 struct s3c_sss =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*dev;
> +};
> +
> +/**
> + * struct sss_req_context - driver-specific data associated with a r=
equest
> + * @algorithm: algorithm used in request
> + * @blk_cipher: block cipher used in request
> + * @direction: whether to encrypt or decrypt
> + * @rx: RX FIFO channel, see struct sss_fifo_channel
> + * @tx: TX FIFO channel, see struct sss_fifo_channel
> + * @setup_done: whether hardware has been set up
> + * @err: indicates any occured error during request
> + */
> +struct sss_req_context {
> + =A0 =A0 =A0 enum sss_algorithm {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ALGO_AES,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ALGO_DES,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ALGO_TDES,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ALGO_SHA1,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ALGO_HMAC_SHA1,
> + =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 algorithm;
> + =A0 =A0 =A0 enum sss_block_cipher {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIPH_ECB,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIPH_CBC,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIPH_CTR,
> + =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 blk_cipher;
> + =A0 =A0 =A0 enum sss_direction {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ENCRYPT,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 DECRYPT,
> + =A0 =A0 =A0 } =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 direction;
> +
> + =A0 =A0 =A0 struct sss_fifo_channel =A0 =A0 =A0 =A0 rx;
> + =A0 =A0 =A0 struct sss_fifo_channel =A0 =A0 =A0 =A0 tx;
> + =A0 =A0 =A0 bool =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0setup_done;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 err;
> +};
> +
> +/**
> + * struct sss_crypto_wrapper - simple wrapper for easy access to the=
 driver data
> + * @alg: wrapped crypto algorithm
> + * @dev: pointer to the driver state
> + */
> +struct sss_crypto_wrapper {
> + =A0 =A0 =A0 struct crypto_alg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0alg;
> + =A0 =A0 =A0 struct s3c_sss =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*dev;
> +};
> +
> +/*** Helper functions ***/
> +
> +#define fifo_to_req_ctx(fifo, dir) container_of((fifo), \
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 struct sss_req_context, dir)
> +
> +static inline struct sss_req_context *sss_to_req_ctx(struct s3c_sss =
*sss)
> +{
> + =A0 =A0 =A0 struct ablkcipher_request *req =3D sss->cur_req;
> + =A0 =A0 =A0 return req ? ablkcipher_request_ctx(req) : NULL;
> +}
> +
> +static inline unsigned int fifo_to_dma_channel(struct sss_fifo_chann=
el *chan)
> +{
> + =A0 =A0 =A0 return chan->dir =3D=3D FIFO_TX ? DMACH_SECURITY_TX : D=
MACH_SECURITY_RX;
> +}
> +
> +static inline bool sss_dma_enabled(void)
> +{
> + =A0 =A0 =A0 /* DMA is disabled till someone figures out why it's no=
t transmitting
> + =A0 =A0 =A0 =A0 =A0all data to the crypto engine. */
> + =A0 =A0 =A0 return false;
> +}
> +
> +static int count_sgs(struct scatterlist *sg)
> +{
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 for (i =3D 0; sg; i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg =3D sg_next(sg);
> +
> + =A0 =A0 =A0 return i;
> +}
> +
> +static inline void orrl(u32 val, void __iomem *reg)
> +{
> + =A0 =A0 =A0 writel(readl(reg) | val, reg);
> +}
> +
> +#ifdef DEBUG
> +static void sss_dump_regs(struct s3c_sss *sss)
> +{
> + =A0 =A0 =A0 dev_dbg(sss->dev, "DnI_CFG: %x\n", readl(sss->regs + Dn=
I_CFG));
> +
> + =A0 =A0 =A0 dev_dbg(sss->dev, "FRx_Ctrl: %x\n", readl(sss->regs + F=
Rx_Ctrl));
> + =A0 =A0 =A0 dev_dbg(sss->dev, "FRx_MLen: %x\n", readl(sss->regs + F=
Rx_MLen));
> + =A0 =A0 =A0 dev_dbg(sss->dev, "FRx_BlkSz: %x\n", readl(sss->regs + =
=46Rx_BlkSz));
> + =A0 =A0 =A0 dev_dbg(sss->dev, "FRx_Addr: %x\n", readl(sss->regs + F=
Rx_Addr));
> + =A0 =A0 =A0 dev_dbg(sss->dev, "FRx_MLenCnt: %x\n", readl(sss->regs =
+ FRx_MLenCnt));
> +
> + =A0 =A0 =A0 dev_dbg(sss->dev, "FTx_Ctrl: %x\n", readl(sss->regs + F=
Tx_Ctrl));
> + =A0 =A0 =A0 dev_dbg(sss->dev, "FTx_MLen: %x\n", readl(sss->regs + F=
Tx_MLen));
> + =A0 =A0 =A0 dev_dbg(sss->dev, "FTx_BlkSz: %x\n", readl(sss->regs + =
=46Tx_BlkSz));
> + =A0 =A0 =A0 dev_dbg(sss->dev, "FTx_Addr: %x\n", readl(sss->regs + F=
Tx_Addr));
> + =A0 =A0 =A0 dev_dbg(sss->dev, "FTx_MLenCnt: %x\n", readl(sss->regs =
+ FTx_MLenCnt));
> +
> + =A0 =A0 =A0 dev_dbg(sss->dev, "AES_CTRL: %x\n", readl(sss->regs + A=
ES_CTRL));
> + =A0 =A0 =A0 dev_dbg(sss->dev, "TDES_CTRL: %x\n", readl(sss->regs + =
TDES_CTRL));
> + =A0 =A0 =A0 dev_dbg(sss->dev, "HASH_CTRL: %x\n", readl(sss->regs + =
HASH_CTRL));
> + =A0 =A0 =A0 dev_dbg(sss->dev, "HASH_STATUS: %x\n", readl(sss->regs =
+ HASH_STATUS));
> +}
> +#else
> +#define sss_dump_regs(...)
> +#endif
> +
> +#ifdef DEBUG
> +static void sss_dump_channel(struct sss_fifo_channel *chan)
> +{
> + =A0 =A0 =A0 struct s3c_sss *sss =3D chan->dev;
> + =A0 =A0 =A0 bool tx =3D (chan->dir =3D=3D FIFO_TX);
> + =A0 =A0 =A0 u32 val;
> +
> + =A0 =A0 =A0 val =3D readl(sss->regs + (tx ? FTx_Ctrl : FRx_Ctrl));
> +
> + =A0 =A0 =A0 dev_dbg(sss->dev, "FIFO_%cX: %c%c%c%c%c\n", tx ? 'T' : =
'R',
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val & FXx_Ctrl_Full ? 'F' : ' ',
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val & FXx_Ctrl_Empty ? 'E' : ' ',
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val & FXx_Ctrl_Done ? 'D' : ' ',
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val & FXx_Ctrl_Running ? 'R' : ' ',
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val & FXx_Ctrl_Start ? 'S' : ' ');
> +
> + =A0 =A0 =A0 if (sss_dma_enabled()) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(sss->dev, " =A0 =A0 =A0cur_sg: =
%p\n", chan->cur_sg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(sss->dev, " =A0 =A0 =A0offset: =
%d\n", chan->offset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(sss->dev, " =A0 =A0sg_count: %d=
\n", chan->sg_count);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 dev_dbg(sss->dev, " =A0 =A0req_size: %d\n", chan->req_s=
ize);
> + =A0 =A0 =A0 dev_dbg(sss->dev, " =A0bytes_done: %d\n", chan->bytes_d=
one);
> + =A0 =A0 =A0 dev_dbg(sss->dev, " =A0 =A0 mlencnt: %d\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 readl(sss->regs + (tx ? FTx_MLenCnt : F=
Rx_MLenCnt)) * 4);
> + =A0 =A0 =A0 dev_dbg(sss->dev, " =A0 =A0wd2write: %d\n", (val >> tx =
? 8 : 16) & 0xFF);
> + =A0 =A0 =A0 dev_dbg(sss->dev, " =A0 =A0 wd2read: %d\n", (val >> tx =
? 16 : 8) & 0xFF);
> +}
> +#else
> +#define sss_dump_channel(...)
> +#endif
> +
> +static void sss_reset_fifo(struct s3c_sss *sss, int reg)
> +{
> + =A0 =A0 =A0 int timeout =3D 1000;
> + =A0 =A0 =A0 u32 val;
> +
> + =A0 =A0 =A0 writel(FXx_Ctrl_Reset, sss->regs + reg);
> +
> + =A0 =A0 =A0 while (timeout-- > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val =3D readl(sss->regs + reg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!(val & FXx_Ctrl_Reset))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (timeout <=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(sss->dev, "Failed to reset FIF=
O_%cX!\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0reg =3D=3D FRx_Ctrl =
? 'R' : 'T');
> +}
> +
> +static void sss_reset_hw(struct s3c_sss *sss)
> +{
> + =A0 =A0 =A0 u32 val =3D 0;
> +
> + =A0 =A0 =A0 if (sss_dma_enabled())
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val |=3D (DnI_CFG_RxDmaEnb | DnI_CFG_Tx=
DmaEnb |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DnI_CFG_RxTrgLevel(16) =
| DnI_CFG_TxTrgLevel(16));
> +
> + =A0 =A0 =A0 writel(val, sss->regs + DnI_CFG);
> +
> + =A0 =A0 =A0 /* Reset FIFOs */
> + =A0 =A0 =A0 sss_reset_fifo(sss, FRx_Ctrl);
> + =A0 =A0 =A0 sss_reset_fifo(sss, FTx_Ctrl);
> +
> + =A0 =A0 =A0 /* Ensure all subsystems are disabled */
> + =A0 =A0 =A0 writel(0, sss->regs + AES_CTRL);
> + =A0 =A0 =A0 writel(0, sss->regs + TDES_CTRL);
> + =A0 =A0 =A0 writel(0, sss->regs + HASH_CTRL);
> +}
> +
> +#ifdef DEBUG
> +static void check_priv_mismatch(struct s3c_sss *sss, const char* nam=
e, int reg)
> +{
> + =A0 =A0 =A0 u32 val =3D readl(sss->regs + reg);
> +
> + =A0 =A0 =A0 if (val & RdPrivMismatch)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(sss->dev, "%s read privilege m=
ismatch! (0x%x)\n", name,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0val);
> +
> + =A0 =A0 =A0 if (val & WrPrivMismatch)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(sss->dev, "%s write privilege =
mismatch! (0x%x)\n",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0name, val);
> +}
> +#else
> +#define check_priv_mismatch(...)
> +#endif
> +
> +static irqreturn_t sss_irq(int irq, void *priv)
> +{
> + =A0 =A0 =A0 struct s3c_sss *sss =3D priv;
> + =A0 =A0 =A0 u32 cfg =3D readl(sss->regs + DnI_CFG);
> +
> + =A0 =A0 =A0 check_priv_mismatch(sss, "CONFIG", DnI_CFG);
> +
> + =A0 =A0 =A0 if (cfg & DnI_CFG_FRx_Intr_Status) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(sss->dev, "%s: FIFO_RX IRQ\n", =
__func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 check_priv_mismatch(sss, "FIFO RX", FRx=
_Ctrl);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sss->cur_req && !sss_dma_enabled())=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct sss_fifo_channel=
 *ch =3D &sss_to_req_ctx(sss)->rx;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ch->req_size) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg=
(sss->dev, "Increasing consumption with "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "%d bytes\n", ch->req_size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ch->byt=
es_done +=3D ch->req_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ch->req=
_size =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tasklet=
_schedule(&sss->tasklet);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (cfg & DnI_CFG_FTx_Intr_Status) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(sss->dev, "%s: FIFO_TX IRQ\n", =
__func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 check_priv_mismatch(sss, "FIFO TX", FTx=
_Ctrl);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sss->cur_req && !sss_dma_enabled())
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 tasklet_schedule(&sss->=
tasklet);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (cfg & DnI_CFG_SHA_Intr_Status)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(sss->dev, "%s: HASH IRQ\n", __f=
unc__);
> +
> + =A0 =A0 =A0 if (cfg & DnI_CFG_DES_Intr_Status) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(sss->dev, "%s: TDES IRQ\n", __f=
unc__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 check_priv_mismatch(sss, "TDES", TDES_C=
TRL);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (cfg & DnI_CFG_AES_Intr_Status) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_dbg(sss->dev, "%s: AES IRQ\n", __fu=
nc__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 check_priv_mismatch(sss, "AES", AES_CTR=
L);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return IRQ_HANDLED;
> +}
> +
> +static void sss_dma_cb(struct s3c2410_dma_chan *chan, void *pw, int =
size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0enum s3c2410_dma_buffres=
ult res)
> +{
> + =A0 =A0 =A0 struct sss_fifo_channel *fifo_chan =3D pw;
> + =A0 =A0 =A0 struct s3c_sss *sss =3D fifo_chan->dev;
> + =A0 =A0 =A0 struct sss_req_context *req_ctx;
> +
> + =A0 =A0 =A0 dev_dbg(sss->dev, "%s: FIFO_%cX\n", __func__,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo_chan->dir =3D=3D FIFO_RX ? 'R' : '=
T');
> +
> + =A0 =A0 =A0 if (fifo_chan->dir =3D=3D FIFO_RX)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 req_ctx =3D fifo_to_req_ctx(fifo_chan, =
rx);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 req_ctx =3D fifo_to_req_ctx(fifo_chan, =
tx);
> +
> + =A0 =A0 =A0 switch (res) {
> + =A0 =A0 =A0 case S3C2410_RES_OK:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo_chan->bytes_done +=3D fifo_chan->r=
eq_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo_chan->offset +=3D fifo_chan->req_s=
ize;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo_chan->req_size =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case S3C2410_RES_ERR:
> + =A0 =A0 =A0 case S3C2410_RES_ABORT:
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(sss->dev, "Error occured during=
 DMA transfer!\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!req_ctx->err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 req_ctx->err =3D -EIO;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 tasklet_schedule(&sss->tasklet);
> +}
> +
> +static int sss_setup_dma(struct s3c_sss *sss, unsigned int channel)
> +{
> + =A0 =A0 =A0 enum s3c2410_dmasrc source;
> + =A0 =A0 =A0 unsigned long reg;
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 ret =3D s3c2410_dma_request(channel, &sss->dma_client, =
sss);
> + =A0 =A0 =A0 if (ret < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> +
> + =A0 =A0 =A0 if (channel =3D=3D DMACH_SECURITY_RX) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 reg =3D (unsigned long)(sss->regs_phys =
+ SDMA_FRx_Buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 source =3D S3C2410_DMASRC_MEM;
> + =A0 =A0 =A0 } else { /* DMACH_SECURITY_TX */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 reg =3D (unsigned long)(sss->regs_phys =
+ SDMA_FTx_Buf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 source =3D S3C2410_DMASRC_HW;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 s3c2410_dma_config(channel, 4);
> + =A0 =A0 =A0 s3c2410_dma_devconfig(channel, source, reg);
> + =A0 =A0 =A0 s3c2410_dma_set_buffdone_fn(channel, sss_dma_cb);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static void sss_setup_hw(struct s3c_sss *sss)
> +{
> + =A0 =A0 =A0 struct ablkcipher_request *req =3D sss->cur_req;
> + =A0 =A0 =A0 struct sss_context *ctx =3D crypto_tfm_ctx(req->base.tf=
m);
> + =A0 =A0 =A0 struct sss_req_context *req_ctx =3D ablkcipher_request_=
ctx(req);
> + =A0 =A0 =A0 u32 val, cfg, fifo_rx, fifo_tx;
> +
> + =A0 =A0 =A0 dev_dbg(sss->dev, "%s: setting up hw\n", __func__);
> +
> + =A0 =A0 =A0 sss_reset_hw(sss);
> +
> + =A0 =A0 =A0 cfg =3D readl(sss->regs + DnI_CFG);
> + =A0 =A0 =A0 cfg |=3D (DnI_CFG_FTx_Intr_En | DnI_CFG_FRx_Intr_En);
> +
> + =A0 =A0 =A0 fifo_rx =3D (FXx_Ctrl_Host_Rd_En | FXx_Ctrl_Host_Wr_En =
|
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FRx_Ctrl_Sync_Tx);
> + =A0 =A0 =A0 fifo_tx =3D (FXx_Ctrl_Host_Rd_En | FXx_Ctrl_Host_Wr_En)=
;
> +
> + =A0 =A0 =A0 switch (req_ctx->algorithm) {
> + =A0 =A0 =A0 case ALGO_AES:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cfg |=3D DnI_CFG_AES_Intr_En;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo_rx |=3D FXx_Ctrl_Module_AES;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo_tx |=3D FXx_Ctrl_Module_AES;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (req_ctx->blk_cipher) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case CIPH_ECB:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val =3D AES_CTRL_OpMode=
_ECB;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case CIPH_CBC:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val =3D AES_CTRL_OpMode=
_CBC;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(sss->regs + AES_=
IV, req->info, 16);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case CIPH_CTR:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val =3D AES_CTRL_OpMode=
_CTR;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(sss->regs + AES_=
CTR, req->info, 16); /* ??? */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (req_ctx->direction =3D=3D DECRYPT &=
&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 req_ctx->blk_cipher !=3D CIPH_C=
TR)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val |=3D AES_CTRL_OpDir=
ection_Dec;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (ctx->key_len) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case AES_KEYSIZE_128:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val |=3D AES_CTRL_KeyMo=
de_128bits;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case AES_KEYSIZE_192:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val |=3D AES_CTRL_KeyMo=
de_192bits;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case AES_KEYSIZE_256:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val |=3D AES_CTRL_KeyMo=
de_256bits;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(sss->regs + AES_KEY, ctx->key, c=
tx->key_len);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(val, sss->regs + AES_CTRL);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(AES_BLOCK_SIZE / 4, sss->regs + =
=46Rx_BlkSz);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(AES_BLOCK_SIZE / 4, sss->regs + =
=46Tx_BlkSz);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(sss->regs_phys + AES_DIN, sss->r=
egs + FRx_Addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(sss->regs_phys + AES_DOUT, sss->=
regs + FTx_Addr);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case ALGO_DES:
> + =A0 =A0 =A0 case ALGO_TDES:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cfg |=3D DnI_CFG_DES_Intr_En;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo_rx |=3D FXx_Ctrl_Module_DES;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo_tx |=3D FXx_Ctrl_Module_DES;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 switch (req_ctx->blk_cipher) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case CIPH_ECB:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val =3D TDES_CTRL_Mode_=
ECB;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case CIPH_CBC:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val =3D TDES_CTRL_Mode_=
CBC;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(sss->regs + TDES=
_IV, req->info, 16);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case CIPH_CTR:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* NOP */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (req_ctx->direction =3D=3D DECRYPT)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val |=3D TDES_CTRL_OpDi=
rection_Dec;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (req_ctx->algorithm =3D=3D ALGO_TDES=
)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 val |=3D TDES_CTRL_Mode=
_Tdes;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 val |=3D TDES_CTRL_IntMode;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(sss->regs + TDES_KEY, ctx->key, =
ctx->key_len);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(val, sss->regs + TDES_CTRL);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(DES_BLOCK_SIZE / 4, sss->regs + =
=46Rx_BlkSz);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(DES_BLOCK_SIZE / 4, sss->regs + =
=46Tx_BlkSz);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(sss->regs_phys + TDES_INPUT, sss=
->regs + FRx_Addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(sss->regs_phys + TDES_OUTPUT, ss=
s->regs + FTx_Addr);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case ALGO_SHA1:
> + =A0 =A0 =A0 case ALGO_HMAC_SHA1:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cfg |=3D DnI_CFG_SHA_Intr_En;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo_rx |=3D FXx_Ctrl_Module_SHA;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo_tx |=3D FXx_Ctrl_Module_SHA;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*TODO*/
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 writel(cfg, sss->regs + DnI_CFG);
> + =A0 =A0 =A0 writel(fifo_rx, sss->regs + FRx_Ctrl);
> + =A0 =A0 =A0 writel(fifo_tx, sss->regs + FTx_Ctrl);
> +}
> +
> +static void sss_setup_hw_mlen(struct sss_fifo_channel *chan, size_t =
len)
> +{
> + =A0 =A0 =A0 struct s3c_sss *sss =3D chan->dev;
> +
> + =A0 =A0 =A0 if (chan->dir =3D=3D FIFO_RX) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(len / 4, sss->regs + FRx_MLen);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 orrl(FXx_Ctrl_Start, sss->regs + FRx_Ct=
rl);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(len / 4, sss->regs + FTx_MLen);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 orrl(FXx_Ctrl_Start, sss->regs + FTx_Ct=
rl);
> + =A0 =A0 =A0 }
> +}
> +
> +static int sss_setup_dma_channel(struct sss_fifo_channel *chan)
> +{
> + =A0 =A0 =A0 struct s3c_sss *sss =3D chan->dev;
> + =A0 =A0 =A0 unsigned int channel =3D fifo_to_dma_channel(chan);
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 if (chan->offset >=3D sg_dma_len(chan->cur_sg)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 chan->cur_sg =3D sg_next(chan->cur_sg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 chan->offset =3D 0;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 chan->req_size =3D min(sg_dma_len(chan->cur_sg) - chan-=
>offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SSS_FIFO_SIZ=
E);
> +
> + =A0 =A0 =A0 sss_setup_hw_mlen(chan, chan->req_size);
> +
> + =A0 =A0 =A0 dev_dbg(sss->dev, "Enqueue'ing for FIFO_%cX: %x (%d)\n"=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 channel =3D=3D DMACH_SECURITY_TX ? 'T' =
: 'R',
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg_dma_address(chan->cur_sg) + chan->of=
fset, chan->req_size);
> +
> + =A0 =A0 =A0 ret =3D s3c2410_dma_enqueue(channel, chan,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg_=
dma_address(chan->cur_sg) + chan->offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cha=
n->req_size);
> + =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
> +
> + =A0 =A0 =A0 return s3c2410_dma_ctrl(fifo_to_dma_channel(chan), S3C2=
410_DMAOP_START);
> +}
> +
> +static void sss_setup_fifo(struct sss_fifo_channel *chan)
> +{
> + =A0 =A0 =A0 struct s3c_sss *sss =3D chan->dev;
> + =A0 =A0 =A0 struct ablkcipher_request *req =3D sss->cur_req;
> + =A0 =A0 =A0 enum dma_data_direction dir;
> + =A0 =A0 =A0 unsigned int sg_flags;
> +
> + =A0 =A0 =A0 if (chan->dir =3D=3D FIFO_RX) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg_flags =3D SG_MITER_FROM_SG;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 chan->sg =3D req->src;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dir =3D DMA_TO_DEVICE;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sg_flags =3D SG_MITER_TO_SG;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 chan->sg =3D req->dst;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dir =3D DMA_FROM_DEVICE;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (sss_dma_enabled()) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int sg_count =3D count_sgs(chan->sg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 chan->sg_count =3D dma_map_sg(sss->dev,=
 chan->sg, sg_count, dir);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 chan->cur_sg =3D chan->sg;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 s3c2410_dma_ctrl(fifo_to_dma_channel(ch=
an),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0S3C2=
410_DMAOP_FLUSH);
> + =A0 =A0 =A0 }
> +}
> +
> +static int sss_handle_fifo(struct sss_fifo_channel *chan)
> +{
> + =A0 =A0 =A0 struct s3c_sss *sss =3D chan->dev;
> + =A0 =A0 =A0 struct ablkcipher_request *req =3D sss->cur_req;
> + =A0 =A0 =A0 void __iomem *fifo;
> +
> + =A0 =A0 =A0 if (chan->req_size)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* FIFO is still transferring data */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINPROGRESS;
> +
> + =A0 =A0 =A0 if (sss_dma_enabled())
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return sss_setup_dma_channel(chan);
> +
> + =A0 =A0 =A0 /* PIO */
> + =A0 =A0 =A0 if (chan->dir =3D=3D FIFO_RX)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo =3D sss->regs + FRx_Buf;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fifo =3D sss->regs + FTx_Buf;
> +
> + =A0 =A0 =A0 chan->req_size =3D min(req->nbytes - chan->bytes_done, =
SSS_FIFO_SIZE);
> +
> + =A0 =A0 =A0 sss_setup_hw_mlen(chan, chan->req_size);
> +
> + =A0 =A0 =A0 dev_dbg(sss->dev, "Transferring %d bytes to FIFO_%s\n",=
 chan->req_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 chan->dir =3D=3D FIFO_TX ? "TX" : "RX")=
;
> +
> + =A0 =A0 =A0 scatterwalk_map_and_copy(fifo, chan->sg, chan->bytes_do=
ne,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0chan=
->req_size, (chan->dir =3D=3D FIFO_TX));
> +
> + =A0 =A0 =A0 if (chan->dir =3D=3D FIFO_TX) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 chan->bytes_done +=3D chan->req_size;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 chan->req_size =3D 0;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static void sss_cleanup_fifo(struct sss_fifo_channel *chan)
> +{
> + =A0 =A0 =A0 struct s3c_sss *sss =3D chan->dev;
> + =A0 =A0 =A0 enum dma_data_direction dir;
> +
> + =A0 =A0 =A0 if (sss_dma_enabled()) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (chan->dir =3D=3D FIFO_RX)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dir =3D DMA_TO_DEVICE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dir =3D DMA_FROM_DEVICE=
;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_unmap_sg(sss->dev, chan->sg, chan->=
sg_count, dir);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 s3c2410_dma_ctrl(fifo_to_dma_channel(ch=
an), S3C2410_DMAOP_STOP);
> + =A0 =A0 =A0 }
> +}
> +
> +static void sss_timer_callback(unsigned long priv)
> +{
> + =A0 =A0 =A0 struct s3c_sss *sss =3D (struct s3c_sss *)priv;
> + =A0 =A0 =A0 struct sss_req_context *req_ctx =3D sss_to_req_ctx(sss)=
;
> +
> + =A0 =A0 =A0 dev_err(sss->dev, "Request timed out!\n");
> + =A0 =A0 =A0 req_ctx->err =3D -ETIMEDOUT;
> +
> + =A0 =A0 =A0 tasklet_schedule(&sss->tasklet);
> +}
> +
> +static void sss_tasklet_callback(unsigned long priv)
> +{
> + =A0 =A0 =A0 struct s3c_sss *sss =3D (struct s3c_sss *)priv;
> + =A0 =A0 =A0 struct sss_req_context *req_ctx;
> + =A0 =A0 =A0 struct ablkcipher_request *req;
> + =A0 =A0 =A0 unsigned long flags;
> +
> + =A0 =A0 =A0 if (!sss->cur_req) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock_irqsave(&sss->lock, flags);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sss->cur_req =3D ablkcipher_dequeue_req=
uest(&sss->queue);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock_irqrestore(&sss->lock, flag=
s);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!sss->cur_req) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_warn(sss->dev, "Tas=
klet was called without any "
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0"pending request!\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /*TODO: backlog*/
> +
> + =A0 =A0 =A0 req =3D sss->cur_req;
> + =A0 =A0 =A0 req_ctx =3D ablkcipher_request_ctx(req);
> +
> + =A0 =A0 =A0 dev_dbg(sss->dev, "Current request: %p (%d)\n", req, re=
q->nbytes);
> +
> + =A0 =A0 =A0 if (!req_ctx->setup_done) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 clk_enable(sss->clock);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sss_setup_hw(sss);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sss_setup_fifo(&req_ctx->rx);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sss_setup_fifo(&req_ctx->tx);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 req_ctx->setup_done =3D true;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Ensure timeout handler is killed */
> + =A0 =A0 =A0 if (timer_pending(&sss->timer))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 del_timer(&sss->timer);
> +
> + =A0 =A0 =A0 if (!req_ctx->err && (req_ctx->rx.bytes_done < req->nby=
tes ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 req_ctx->tx=
=2Ebytes_done < req->nbytes)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (req_ctx->tx.bytes_done < req_ctx->r=
x.bytes_done)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Keep TX in sync with=
 RX */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sss_handle_fifo=
(&req_ctx->tx);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Transmit some more d=
ata to RX */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sss_handle_fifo=
(&req_ctx->rx);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sss_dump_channel(&req_ctx->tx);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sss_dump_channel(&req_ctx->rx);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret && ret !=3D -EINPROGRESS) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 req_ctx->err =3D ret;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto cleanup;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mod_timer(&sss->timer, jiffies + SSS_TI=
MEOUT);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +
> +cleanup:
> + =A0 =A0 =A0 sss_cleanup_fifo(&req_ctx->rx);
> + =A0 =A0 =A0 sss_cleanup_fifo(&req_ctx->tx);
> +
> + =A0 =A0 =A0 clk_disable(sss->clock);
> +
> + =A0 =A0 =A0 /* Inform client of completion */
> + =A0 =A0 =A0 req->base.complete(&req->base, req_ctx->err);
> +
> + =A0 =A0 =A0 spin_lock_irqsave(&sss->lock, flags);
> + =A0 =A0 =A0 sss->cur_req =3D NULL;
> + =A0 =A0 =A0 /* Check whether there's still work to do */
> + =A0 =A0 =A0 if (sss->queue.qlen || crypto_get_backlog(&sss->queue))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tasklet_schedule(&sss->tasklet);
> + =A0 =A0 =A0 spin_unlock_irqrestore(&sss->lock, flags);
> +}
> +
> +/*** SW handling ***/
> +
> +static int sss_crypto_generic(struct ablkcipher_request *req,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum sss_al=
gorithm alg,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum sss_bl=
ock_cipher blk_ciph,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 enum sss_di=
rection dir)
> +{
> + =A0 =A0 =A0 struct sss_context *ctx =3D crypto_tfm_ctx(req->base.tf=
m);
> + =A0 =A0 =A0 struct sss_req_context *req_ctx =3D ablkcipher_request_=
ctx(req);
> + =A0 =A0 =A0 struct s3c_sss *sss =3D ctx->dev;
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 /* Fill the request */
> + =A0 =A0 =A0 *req_ctx =3D (struct sss_req_context){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .algorithm =A0 =A0 =A0=3D alg,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_cipher =A0 =A0 =3D blk_ciph,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .direction =A0 =A0 =A0=3D dir,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .rx =A0 =A0 =A0 =A0 =A0 =A0 =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .dev =3D=
 sss,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .dir =3D=
 FIFO_RX,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 },
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .tx =A0 =A0 =A0 =A0 =A0 =A0 =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .dev =3D=
 sss,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .dir =3D=
 FIFO_TX,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 },
> + =A0 =A0 =A0 };
> +
> + =A0 =A0 =A0 /* Enqueue the request */
> + =A0 =A0 =A0 spin_lock_irqsave(&sss->lock, flags);
> + =A0 =A0 =A0 ret =3D ablkcipher_enqueue_request(&sss->queue, req);
> + =A0 =A0 =A0 if (ret =3D=3D -EINPROGRESS && !sss->cur_req)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tasklet_schedule(&sss->tasklet);
> + =A0 =A0 =A0 spin_unlock_irqrestore(&sss->lock, flags);
> +
> + =A0 =A0 =A0 if (ret !=3D -EINPROGRESS)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(sss->dev, "Couldn't enqueue req=
uest!\n");
> +
> + =A0 =A0 =A0 return ret;
> +}
> +
> +static int sss_aes_setkey(struct crypto_ablkcipher *cipher, const u8=
 *key,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int len)
> +{
> + =A0 =A0 =A0 struct crypto_tfm *tfm =A0=3D crypto_ablkcipher_tfm(cip=
her);
> + =A0 =A0 =A0 struct sss_context *ctx =3D crypto_tfm_ctx(tfm);
> +
> + =A0 =A0 =A0 switch (len) {
> + =A0 =A0 =A0 case AES_KEYSIZE_128:
> + =A0 =A0 =A0 case AES_KEYSIZE_192:
> + =A0 =A0 =A0 case AES_KEYSIZE_256:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_ablkcipher_set_flags(cipher, CRY=
PTO_TFM_RES_BAD_KEY_LEN);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 memcpy(ctx->key, key, len);
> + =A0 =A0 =A0 ctx->key_len =3D len;
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int sss_des_setkey(struct crypto_ablkcipher *cipher, const u8=
 *key,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int len)
> +{
> + =A0 =A0 =A0 struct crypto_tfm *tfm =A0=3D crypto_ablkcipher_tfm(cip=
her);
> + =A0 =A0 =A0 struct sss_context *ctx =3D crypto_tfm_ctx(tfm);
> +
> + =A0 =A0 =A0 if (len > SSS_MAX_KEY_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_ablkcipher_set_flags(cipher, CRY=
PTO_TFM_RES_BAD_KEY_LEN);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* RFC2451: weak key checks SHOULD be performed */
> + =A0 =A0 =A0 if (len =3D=3D DES_KEY_SIZE) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 u32 tmp[DES_EXPKEY_WORDS];
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 int ret =3D des_ekey(tmp, key);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (unlikely(ret =3D=3D 0) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (crypto_tfm_get_flags(tfm) & CR=
YPTO_TFM_REQ_WEAK_KEY)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_tfm_set_flags(tf=
m, CRYPTO_TFM_RES_WEAK_KEY);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 memcpy(ctx->key, key, len);
> + =A0 =A0 =A0 ctx->key_len =3D len;
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int sss_cra_init(struct crypto_tfm *tfm)
> +{
> + =A0 =A0 =A0 struct sss_crypto_wrapper *wrapper =3D container_of(tfm=
->__crt_alg,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 struct sss_crypto_wrapper, alg);
> + =A0 =A0 =A0 struct s3c_sss *sss =3D wrapper->dev;
> + =A0 =A0 =A0 struct sss_context *ctx =3D crypto_tfm_ctx(tfm);
> +
> + =A0 =A0 =A0 ctx->dev =3D sss;
> + =A0 =A0 =A0 tfm->crt_ablkcipher.reqsize =3D sizeof(struct sss_req_c=
ontext);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static int sss_aes_cbc_encrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_AES, CIPH_CBC, ENCR=
YPT);
> +}
> +
> +static int sss_aes_cbc_decrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_AES, CIPH_CBC, DECR=
YPT);
> +}
> +
> +static int sss_aes_ecb_encrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_AES, CIPH_ECB, ENCR=
YPT);
> +}
> +
> +static int sss_aes_ecb_decrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_AES, CIPH_ECB, DECR=
YPT);
> +}
> +
> +static int sss_aes_ctr_encrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_AES, CIPH_CTR, ENCR=
YPT);
> +}
> +
> +static int sss_aes_ctr_decrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_AES, CIPH_CTR, DECR=
YPT);
> +}
> +
> +static int sss_des_ecb_encrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_DES, CIPH_ECB, ENCR=
YPT);
> +}
> +
> +static int sss_des_ecb_decrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_DES, CIPH_ECB, DECR=
YPT);
> +}
> +
> +static int sss_des_cbc_encrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_DES, CIPH_CBC, ENCR=
YPT);
> +}
> +
> +static int sss_des_cbc_decrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_DES, CIPH_CBC, DECR=
YPT);
> +}
> +
> +static int sss_tdes_ecb_encrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_TDES, CIPH_ECB, ENC=
RYPT);
> +}
> +
> +static int sss_tdes_ecb_decrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_TDES, CIPH_ECB, DEC=
RYPT);
> +}
> +
> +static int sss_tdes_cbc_encrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_TDES, CIPH_CBC, ENC=
RYPT);
> +}
> +
> +static int sss_tdes_cbc_decrypt(struct ablkcipher_request *req)
> +{
> + =A0 =A0 =A0 return sss_crypto_generic(req, ALGO_TDES, CIPH_CBC, DEC=
RYPT);
> +}
> +
> +static struct sss_algo_template {
> + =A0 =A0 =A0 char =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0*alg_name;
> + =A0 =A0 =A0 char =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0*blk_ciph_name;
> + =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0blk_size;
> + =A0 =A0 =A0 struct ablkcipher_alg =A0 =A0 =A0 =A0 =A0 =A0ablkcipher=
;
> +
> + =A0 =A0 =A0 struct sss_crypto_wrapper =A0 =A0 =A0 *alg;
> +} sss_crypto_algos[] =3D {
> + =A0 =A0 =A0 /* AES ECB/CBC/CTR */
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .alg_name =3D "aes",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_ciph_name =3D "ecb",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_size =3D AES_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ablkcipher =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .min_keysize =A0 =A0=3D=
 =A0 =A0 =A0 AES_MIN_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .max_keysize =A0 =A0=3D=
 =A0 =A0 =A0 AES_MAX_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .setkey =A0 =A0 =A0 =A0=
 =3D =A0 =A0 =A0 sss_aes_setkey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .encrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_aes_ecb_encrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .decrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_aes_ecb_decrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 },
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .alg_name =3D "aes",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_ciph_name =3D "cbc",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_size =3D AES_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ablkcipher =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ivsize =A0 =A0 =A0 =A0=
 =3D =A0 =A0 =A0 AES_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .min_keysize =A0 =A0=3D=
 =A0 =A0 =A0 AES_MIN_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .max_keysize =A0 =A0=3D=
 =A0 =A0 =A0 AES_MAX_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .setkey =A0 =A0 =A0 =A0=
 =3D =A0 =A0 =A0 sss_aes_setkey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .encrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_aes_cbc_encrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .decrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_aes_cbc_decrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 },
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .alg_name =3D "aes",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_ciph_name =3D "ctr",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_size =3D AES_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ablkcipher =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ivsize =A0 =A0 =A0 =A0=
 =3D =A0 =A0 =A0 CTR_RFC3686_IV_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .min_keysize =A0 =A0=3D=
 =A0 =A0 =A0 AES_MIN_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .max_keysize =A0 =A0=3D=
 =A0 =A0 =A0 AES_MAX_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .setkey =A0 =A0 =A0 =A0=
 =3D =A0 =A0 =A0 sss_aes_setkey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .encrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_aes_ctr_encrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .decrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_aes_ctr_decrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 },
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 /* DES CBC/ECB */
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .alg_name =3D "des",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_ciph_name =3D "cbc",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_size =3D DES_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ablkcipher =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ivsize =A0 =A0 =A0 =A0=
 =3D =A0 =A0 =A0 DES_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .min_keysize =A0 =A0=3D=
 =A0 =A0 =A0 DES_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .max_keysize =A0 =A0=3D=
 =A0 =A0 =A0 DES_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .setkey =A0 =A0 =A0 =A0=
 =3D =A0 =A0 =A0 sss_des_setkey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .encrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_des_cbc_encrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .decrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_des_cbc_decrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 },
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .alg_name =3D "des",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_ciph_name =3D "ecb",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_size =3D DES_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ablkcipher =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .min_keysize =A0 =A0=3D=
 =A0 =A0 =A0 DES_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .max_keysize =A0 =A0=3D=
 =A0 =A0 =A0 DES_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .setkey =A0 =A0 =A0 =A0=
 =3D =A0 =A0 =A0 sss_des_setkey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .encrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_des_ecb_encrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .decrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_des_ecb_decrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 },
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 /* TDES CBC/ECB */
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .alg_name =3D "des3_ede",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_ciph_name =3D "cbc",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_size =3D DES3_EDE_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ablkcipher =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ivsize =A0 =A0 =A0 =A0=
 =3D =A0 =A0 =A0 DES3_EDE_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .min_keysize =A0 =A0=3D=
 =A0 =A0 =A0 DES3_EDE_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .max_keysize =A0 =A0=3D=
 =A0 =A0 =A0 DES3_EDE_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .setkey =A0 =A0 =A0 =A0=
 =3D =A0 =A0 =A0 sss_des_setkey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .encrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_tdes_cbc_encrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .decrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_tdes_cbc_decrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 },
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .alg_name =3D "des3_ede",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_ciph_name =3D "ecb",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .blk_size =3D DES3_EDE_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .ablkcipher =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .min_keysize =A0 =A0=3D=
 =A0 =A0 =A0 DES3_EDE_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .max_keysize =A0 =A0=3D=
 =A0 =A0 =A0 DES3_EDE_KEY_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .setkey =A0 =A0 =A0 =A0=
 =3D =A0 =A0 =A0 sss_des_setkey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .encrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_tdes_ecb_encrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .decrypt =A0 =A0 =A0 =A0=
=3D =A0 =A0 =A0 sss_tdes_ecb_decrypt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 },
> + =A0 =A0 =A0 },
> +};
> +
> +static int sss_init_template(struct platform_device *pdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct sss_a=
lgo_template *templ)
> +{
> + =A0 =A0 =A0 struct s3c_sss *sss =3D platform_get_drvdata(pdev);
> + =A0 =A0 =A0 struct sss_crypto_wrapper *alg;
> +
> + =A0 =A0 =A0 alg =3D kzalloc(sizeof(struct sss_crypto_wrapper), GFP_=
KERNEL);
> + =A0 =A0 =A0 if (!alg)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 alg->dev =3D sss;
> + =A0 =A0 =A0 alg->alg =3D (struct crypto_alg){
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_ablkcipher =3D tem=
pl->ablkcipher,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_blocksize =A0=3D t=
empl->blk_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_ctxsize =A0 =A0=3D=
 sizeof(struct sss_context),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_flags =A0 =A0 =A0=3D=
 CRYPTO_ALG_TYPE_ABLKCIPHER |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 CRYPTO_ALG_ASYNC,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_init =A0 =A0 =A0 =3D=
 sss_cra_init,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_module =A0 =A0 =3D=
 THIS_MODULE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_priority =A0 =3D S=
SS_CRA_PRIORITY,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_type =A0 =A0 =A0 =3D=
 &crypto_ablkcipher_type,
> + =A0 =A0 =A0 };
> +
> + =A0 =A0 =A0 snprintf(alg->alg.cra_name, CRYPTO_MAX_ALG_NAME, "%s(%s=
)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0templ->blk_ciph_name, templ->alg_nam=
e);
> + =A0 =A0 =A0 snprintf(alg->alg.cra_driver_name, CRYPTO_MAX_ALG_NAME,=
 "%s-%s-%s",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdev->name, templ->alg_name, templ->=
blk_ciph_name);
> +
> + =A0 =A0 =A0 /* Save pointer for removal */
> + =A0 =A0 =A0 templ->alg =3D alg;
> +
> + =A0 =A0 =A0 dev_info(sss->dev, "crypto acceleration for %s", alg->a=
lg.cra_name);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static struct ahash_alg sss_hash_algos[] =3D {
> +#if 0
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .init =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0=
 sss_sha_init,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .update =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0=
 sss_sha_update,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .final =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0=
 sss_sha1_final,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .digest =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0=
 sss_sha1_digest,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .halg =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .digestsize =A0 =A0 =A0=
 =A0 =A0 =A0 =3D =A0 =A0 =A0 SHA1_DIGEST_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .statesize =A0 =A0 =A0 =
=A0 =A0 =A0 =A0=3D =A0 =A0 =A0 sizeof(struct sha1_state),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .base =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_na=
me =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 "sha1",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_dr=
iver_name =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 "s3c-sss-sha1",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_pr=
iority =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 SSS_CRA_PRIORITY,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_fl=
ags =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 CRYPTO_ALG_TYPE_AHASH |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CRYPTO_ALG_ASY=
NC,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_bl=
ocksize =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 SHA1_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_ct=
xsize =A0 =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 sizeof(struct sss_context)=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_ty=
pe =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 &crypto_ahash_type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_mo=
dule =A0 =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 THIS_MODULE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_in=
it =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 sss_cra_init,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 },
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .init =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0=
 sss_sha_init,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .update =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0=
 sss_sha_update,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .final =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0=
 sss_sha1_final,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .digest =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0=
 sss_sha1_digest,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .setkey =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0=
 sss_sha1_setkey,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .halg =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0=
 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .digestsize =A0 =A0 =A0=
 =A0 =A0 =A0 =3D =A0 =A0 =A0 SHA1_DIGEST_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .statesize =A0 =A0 =A0 =
=A0 =A0 =A0 =A0=3D =A0 =A0 =A0 sizeof(struct sha1_state),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .base =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_na=
me =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 "hmac(sha1)",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_dr=
iver_name =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 "s3c-sss-hmac-sha1",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_pr=
iority =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 SSS_CRA_PRIORITY,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_fl=
ags =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 CRYPTO_ALG_TYPE_AHASH |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CRYPTO_ALG_ASY=
NC,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_bl=
ocksize =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 SHA1_BLOCK_SIZE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_ct=
xsize =A0 =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 sizeof(struct sss_context)=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_ty=
pe =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 &crypto_ahash_type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_mo=
dule =A0 =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 THIS_MODULE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 .cra_in=
it =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 sss_cra_init,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 },
> + =A0 =A0 =A0 },
> +#endif
> +};
> +
> +static void sss_unregister_algos(void)
> +{
> + =A0 =A0 =A0 struct sss_crypto_wrapper *alg;
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(sss_crypto_algos); i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 alg =3D sss_crypto_algos[i].alg;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (alg) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_unregister_alg(&=
alg->alg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(alg);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sss_crypto_algos[i].alg=
 =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Unregistering algorithms that weren't registered in =
the first place
> + =A0 =A0 =A0 =A0 =A0doesn't do any harm, so just do it for all. */
> + =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(sss_hash_algos); i++)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 crypto_unregister_ahash(&sss_hash_algos=
[i]);
> +}
> +
> +static int sss_register_algos(struct platform_device *pdev)
> +{
> + =A0 =A0 =A0 int i, ret;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(sss_crypto_algos); i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sss_init_template(pdev, &sss_cr=
ypto_algos[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D crypto_register_alg(&sss_crypto=
_algos[i].alg->alg);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 for (i =3D 0; i < ARRAY_SIZE(sss_hash_algos); i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D crypto_register_ahash(&sss_hash=
_algos[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +
> +exit:
> + =A0 =A0 =A0 sss_unregister_algos();
> + =A0 =A0 =A0 return ret;
> +}
> +
> +static int __devinit sss_probe(struct platform_device *pdev)
> +{
> + =A0 =A0 =A0 struct device *dev =3D &pdev->dev;
> + =A0 =A0 =A0 struct resource *res;
> + =A0 =A0 =A0 struct s3c_sss *sss;
> + =A0 =A0 =A0 int ret;
> +
> + =A0 =A0 =A0 sss =3D kzalloc(sizeof(struct s3c_sss), GFP_KERNEL);
> + =A0 =A0 =A0 if (!sss) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev, "cannot allocate memory\n"=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 spin_lock_init(&sss->lock);
> + =A0 =A0 =A0 crypto_init_queue(&sss->queue, 50);
> + =A0 =A0 =A0 tasklet_init(&sss->tasklet, sss_tasklet_callback, (unsi=
gned long) sss);
> + =A0 =A0 =A0 setup_timer(&sss->timer, sss_timer_callback, (unsigned =
long) sss);
> +
> + =A0 =A0 =A0 sss->dev =3D dev;
> + =A0 =A0 =A0 sss->dma_client.name =3D (char *) pdev->name;
> + =A0 =A0 =A0 platform_set_drvdata(pdev, sss);
> +
> + =A0 =A0 =A0 res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> + =A0 =A0 =A0 if (!res) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev, "cannot find register reso=
urce\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_dev;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 sss->regs_res =3D request_mem_region(res->start, resour=
ce_size(res),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0dev_name(dev));
> + =A0 =A0 =A0 if (!sss->regs_res) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev, "cannot request register r=
esource\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENOENT;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_dev;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 sss->regs_phys =3D (void __iomem *) res->start;
> +
> + =A0 =A0 =A0 sss->regs =3D ioremap(res->start, resource_size(res));
> + =A0 =A0 =A0 if (!sss->regs) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev, "cannot map registers\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENXIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_resource;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ret =3D platform_get_irq(pdev, 0);
> + =A0 =A0 =A0 if (ret < 0 || ret =3D=3D NO_IRQ) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev, "cannot find IRQ\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_regs_remap;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 sss->irq =3D ret;
> +
> + =A0 =A0 =A0 ret =3D request_irq(sss->irq, sss_irq, 0, dev_name(dev)=
, sss);
> + =A0 =A0 =A0 if (ret < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev, "cannot claim IRQ\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_regs_remap;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 sss->clock =3D clk_get(dev, "secur");
> + =A0 =A0 =A0 if (!sss->clock) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev, "cannot find clock\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D -ENXIO;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_irq;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 WARN_ON(clk_set_rate(sss->clock, 66*1000000)); /*REMOVE=
ME*/
> +
> + =A0 =A0 =A0 if (sss_dma_enabled()) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sss_setup_dma(sss, DMACH_SECURI=
TY_RX);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev, "cannot se=
tup SECURITY_RX DMA channel\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_clock;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D sss_setup_dma(sss, DMACH_SECURI=
TY_TX);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ret < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev, "cannot se=
tup SECURITY_TX DMA channel\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_dma_rx;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 ret =3D sss_register_algos(pdev);
> + =A0 =A0 =A0 if (ret) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(dev, "cannot register algos\n")=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto exit_dma_tx;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +
> +exit_dma_tx:
> + =A0 =A0 =A0 if (sss_dma_enabled())
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 s3c2410_dma_free(DMACH_SECURITY_TX, &ss=
s->dma_client);
> +exit_dma_rx:
> + =A0 =A0 =A0 if (sss_dma_enabled())
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 s3c2410_dma_free(DMACH_SECURITY_RX, &ss=
s->dma_client);
> +exit_clock:
> + =A0 =A0 =A0 clk_put(sss->clock);
> +exit_irq:
> + =A0 =A0 =A0 free_irq(sss->irq, sss);
> +exit_regs_remap:
> + =A0 =A0 =A0 iounmap(sss->regs);
> +exit_resource:
> + =A0 =A0 =A0 release_resource(sss->regs_res);
> + =A0 =A0 =A0 kfree(sss->regs_res);
> +exit_dev:
> + =A0 =A0 =A0 tasklet_kill(&sss->tasklet);
> + =A0 =A0 =A0 kfree(sss);
> +
> + =A0 =A0 =A0 return ret;
> +}
> +
> +static int __devexit sss_remove(struct platform_device *pdev)
> +{
> + =A0 =A0 =A0 struct s3c_sss *sss =3D platform_get_drvdata(pdev);
> +
> + =A0 =A0 =A0 if (timer_pending(&sss->timer))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 del_timer(&sss->timer);
> +
> + =A0 =A0 =A0 if (sss_dma_enabled()) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 s3c2410_dma_free(DMACH_SECURITY_TX, &ss=
s->dma_client);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 s3c2410_dma_free(DMACH_SECURITY_RX, &ss=
s->dma_client);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 sss_unregister_algos();
> + =A0 =A0 =A0 clk_put(sss->clock);
> + =A0 =A0 =A0 free_irq(sss->irq, sss);
> + =A0 =A0 =A0 iounmap(sss->regs);
> + =A0 =A0 =A0 release_resource(sss->regs_res);
> + =A0 =A0 =A0 kfree(sss->regs_res);
> + =A0 =A0 =A0 tasklet_kill(&sss->tasklet);
> + =A0 =A0 =A0 kfree(sss);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +static struct platform_driver sss_crypto =3D {
> + =A0 =A0 =A0 .driver =A0 =A0 =A0 =A0 =3D {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .name =A0 =3D "s3c-sss",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 .owner =A0=3D THIS_MODULE,
> + =A0 =A0 =A0 },
> + =A0 =A0 =A0 .probe =A0 =A0 =A0 =A0 =A0=3D sss_probe,
> + =A0 =A0 =A0 .remove =A0 =A0 =A0 =A0 =3D __devexit_p(sss_remove),
> +};
> +
> +static int __init sss_crypto_init(void)
> +{
> + =A0 =A0 =A0 return platform_driver_register(&sss_crypto);
> +}
> +module_init(sss_crypto_init);
> +
> +static void __exit sss_crypto_exit(void)
> +{
> + =A0 =A0 =A0 platform_driver_unregister(&sss_crypto);
> +}
> +module_exit(sss_crypto_exit);
> +
> +MODULE_AUTHOR("Maurus Cuelenaere <mcuelenaere@gmail.com>");
> +MODULE_DESCRIPTION("Support for Samsung's Security Sub-Systems");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:sss_crypto");
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsu=
ng-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
