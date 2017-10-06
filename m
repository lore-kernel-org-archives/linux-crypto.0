From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH v4] crypto: s5p-sss: Add HASH support for Exynos
Date: Fri, 6 Oct 2017 20:37:27 +0200
Message-ID: <20171006183727.xzjjlw3fypwpk2yt@kozik-lap>
References: <CGME20171004163813eucas1p1c807cbbb50b82f60beaec6ac23bf9f82@eucas1p1.samsung.com>
 <fcabbf6d-b6f2-ba66-bc8d-5f0179effe23@partner.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kamil Konieczny <k.konieczny@partner.samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32864 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdJFShc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 14:37:32 -0400
Content-Disposition: inline
In-Reply-To: <fcabbf6d-b6f2-ba66-bc8d-5f0179effe23@partner.samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 04, 2017 at 06:38:11PM +0200, Kamil Konieczny wrote:
> Add support for MD5, SHA1, SHA256 hash algorithms for Exynos HW.
> It uses the crypto framework asynchronous hash api.
> It is based on omap-sham.c driver.
> S5P has some HW differencies and is not implemented.
> 
> Modifications in s5p-sss:
> 
> - Add hash supporting structures and functions.
> 
> - Modify irq handler to handle both aes and hash signals.
> 
> - Resize resource end in probe if EXYNOS_HASH is enabled in
>   Kconfig.
> 
> - Add new copyright line and new author.
> 
> - Tested on Odroid-U3 with Exynos 4412 CPU, kernel 4.13-rc6
>   with crypto run-time self test testmgr
>   and with tcrypt module with: modprobe tcrypt sec=1 mode=N
>   where N=402, 403, 404 (MD5, SHA1, SHA256).
> 
> Modifications in drivers/crypto/Kconfig:
> 
> - Add new CRYPTO_DEV_EXYNOS_HASH, depend on !EXYNOS_RNG
>   and CRYPTO_DEV_S5P
> 
> - Select sw algorithms MD5, SHA1 and SHA256 in EXYNOS_HASH
>   as they are nedded for fallback.
> 
> Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
> ---
> version 4:
> - fixes suggested by Krzysztof Kozlowski: reformat comments, convert context
>   flag into two bool vars, drop SSS_ALIGNED, change name of SSS_DMA_ALIGN and
>   SSS_DMA_ALIGN_MASK, split assignments into separate lines, use IS_ENABLED in
>   place of ifdef, remove sss_hash_algs_info and simplify register and deregister
>   HASH algs
> 
> version 3:
> - many fixes suggested by Krzysztof Kozlowski: comments, uppercases in const,
>   remove unused defines, remove unused variable bs, constify aes_variant,
>   remove global var use_hash, remove WARN_ON, improve hash_import(),
>   change goto label into 'out' in s5p_hash_handle_queue(), reorder variable
>   declarations, add spinlock to protect clearing HASH_FLAGS_BUSY
> - simplify code: replace one-line functions s5p_hash_update_req(),
>   s5p_hash_final_req() with call to s5p_hash_xmit_dma(), and delete them
> - replace call to s5p_hash_hw_init() into s5p_ahash_dma_init() and delete it
> - fix clearing shash flag CRYPTO_TFM_REQ_MAY_SLEEP
> - fix s5p_hash_set_flow()
> 
> version 2:
> - change patch format so number of lines drops
> - change in Kconfig as suggested by Krzysztof Kozlowski, add
> 	EXYNOS_HASH subsection
> - change #ifndef EXYNOS_RNG into #ifdef CRYPTO_DEV_EXYNOS_HASH
> - remove style fixups in aes, as they should go in separate patch
> - remove FLOW_LOG, FLOW_DUMP macros and its uses
> - remove #if 0 ... endif
> - remove unused function hash_wait and its defines
> - fix compiler warning in dev_dbg
> - remove some comments
> - other minor fixes in comments
> 
>  drivers/crypto/Kconfig   |   14 +
>  drivers/crypto/s5p-sss.c | 1441 +++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 1445 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index fe33c199fc1a..01cf07ce34c5 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -439,6 +439,20 @@ config CRYPTO_DEV_S5P
>  	  Select this to offload Samsung S5PV210 or S5PC110, Exynos from AES
>  	  algorithms execution.
>  
> +config CRYPTO_DEV_EXYNOS_HASH
> +	bool "Support for Samsung Exynos HASH accelerator"
> +	depends on CRYPTO_DEV_S5P
> +	depends on !CRYPTO_DEV_EXYNOS_RNG && CRYPTO_DEV_EXYNOS_RNG!=m
> +	select CRYPTO_SHA1
> +	select CRYPTO_MD5
> +	select CRYPTO_SHA256
> +	help
> +	  Select this to offload Exynos from HASH MD5/SHA1/SHA256.
> +	  This will select software SHA1, MD5 and SHA256 as they are
> +	  needed for small and zero-size messages.
> +	  HASH algorithms will be disabled if EXYNOS_RNG
> +	  is enabled due to hw conflict.
> +
>  config CRYPTO_DEV_NX
>  	bool "Support for IBM PowerPC Nest (NX) cryptographic acceleration"
>  	depends on PPC64
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 7ac657f46d15..2864efeaf8f8 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -1,18 +1,21 @@
>  /*
>   * Cryptographic API.
>   *
> - * Support for Samsung S5PV210 HW acceleration.
> + * Support for Samsung S5PV210 and Exynos HW acceleration.
>   *
>   * Copyright (C) 2011 NetUP Inc. All rights reserved.
> + * Copyright (c) 2017 Samsung Electronics Co., Ltd. All rights reserved.
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as published
>   * by the Free Software Foundation.
>   *
> + * Hash part based on omap-sham.c driver.
>   */
>  
>  #include <linux/clk.h>
>  #include <linux/crypto.h>
> +#include <linux/delay.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/err.h>
>  #include <linux/errno.h>
> @@ -30,28 +33,41 @@
>  #include <crypto/algapi.h>
>  #include <crypto/scatterwalk.h>
>  
> +#include <crypto/hash.h>
> +#include <crypto/md5.h>
> +#include <crypto/sha.h>
> +#include <crypto/internal/hash.h>
> +
>  #define _SBF(s, v)                      ((v) << (s))
>  
>  /* Feed control registers */
>  #define SSS_REG_FCINTSTAT               0x0000
> +#define SSS_FCINTSTAT_HPARTINT		BIT(7)
> +#define SSS_FCINTSTAT_HDONEINT		BIT(5)
>  #define SSS_FCINTSTAT_BRDMAINT          BIT(3)
>  #define SSS_FCINTSTAT_BTDMAINT          BIT(2)
>  #define SSS_FCINTSTAT_HRDMAINT          BIT(1)
>  #define SSS_FCINTSTAT_PKDMAINT          BIT(0)
>  
>  #define SSS_REG_FCINTENSET              0x0004
> +#define SSS_FCINTENSET_HPARTINTENSET	BIT(7)
> +#define SSS_FCINTENSET_HDONEINTENSET	BIT(5)
>  #define SSS_FCINTENSET_BRDMAINTENSET    BIT(3)
>  #define SSS_FCINTENSET_BTDMAINTENSET    BIT(2)
>  #define SSS_FCINTENSET_HRDMAINTENSET    BIT(1)
>  #define SSS_FCINTENSET_PKDMAINTENSET    BIT(0)
>  
>  #define SSS_REG_FCINTENCLR              0x0008
> +#define SSS_FCINTENCLR_HPARTINTENCLR	BIT(7)
> +#define SSS_FCINTENCLR_HDONEINTENCLR	BIT(5)
>  #define SSS_FCINTENCLR_BRDMAINTENCLR    BIT(3)
>  #define SSS_FCINTENCLR_BTDMAINTENCLR    BIT(2)
>  #define SSS_FCINTENCLR_HRDMAINTENCLR    BIT(1)
>  #define SSS_FCINTENCLR_PKDMAINTENCLR    BIT(0)
>  
>  #define SSS_REG_FCINTPEND               0x000C
> +#define SSS_FCINTPEND_HPARTINTP		BIT(7)
> +#define SSS_FCINTPEND_HDONEINTP		BIT(5)
>  #define SSS_FCINTPEND_BRDMAINTP         BIT(3)
>  #define SSS_FCINTPEND_BTDMAINTP         BIT(2)
>  #define SSS_FCINTPEND_HRDMAINTP         BIT(1)
> @@ -72,6 +88,7 @@
>  #define SSS_HASHIN_INDEPENDENT          _SBF(0, 0x00)
>  #define SSS_HASHIN_CIPHER_INPUT         _SBF(0, 0x01)
>  #define SSS_HASHIN_CIPHER_OUTPUT        _SBF(0, 0x02)
> +#define SSS_HASHIN_MASK			_SBF(0, 0x03)
>  
>  #define SSS_REG_FCBRDMAS                0x0020
>  #define SSS_REG_FCBRDMAL                0x0024
> @@ -146,9 +163,84 @@
>  #define AES_KEY_LEN         16
>  #define CRYPTO_QUEUE_LEN    1
>  
> +/* HASH registers */
> +#define SSS_REG_HASH_CTRL		0x00
> +
> +#define SSS_HASH_USER_IV_EN		BIT(5)
> +#define SSS_HASH_INIT_BIT		BIT(4)
> +#define SSS_HASH_ENGINE_SHA1		_SBF(1, 0x00)
> +#define SSS_HASH_ENGINE_MD5		_SBF(1, 0x01)
> +#define SSS_HASH_ENGINE_SHA256		_SBF(1, 0x02)
> +
> +#define SSS_HASH_ENGINE_MASK		_SBF(1, 0x03)
> +
> +#define SSS_REG_HASH_CTRL_PAUSE		0x04
> +
> +#define SSS_HASH_PAUSE			BIT(0)
> +
> +#define SSS_REG_HASH_CTRL_FIFO		0x08
> +
> +#define SSS_HASH_FIFO_MODE_DMA		BIT(0)
> +#define SSS_HASH_FIFO_MODE_CPU          0
> +
> +#define SSS_REG_HASH_CTRL_SWAP		0x0C
> +
> +#define SSS_HASH_BYTESWAP_DI		BIT(3)
> +#define SSS_HASH_BYTESWAP_DO		BIT(2)
> +#define SSS_HASH_BYTESWAP_IV		BIT(1)
> +#define SSS_HASH_BYTESWAP_KEY		BIT(0)
> +
> +#define SSS_REG_HASH_STATUS		0x10
> +
> +#define SSS_HASH_STATUS_MSG_DONE	BIT(6)
> +#define SSS_HASH_STATUS_PARTIAL_DONE	BIT(4)
> +#define SSS_HASH_STATUS_BUFFER_READY	BIT(0)
> +
> +#define SSS_REG_HASH_MSG_SIZE_LOW	0x20
> +#define SSS_REG_HASH_MSG_SIZE_HIGH	0x24
> +
> +#define SSS_REG_HASH_PRE_MSG_SIZE_LOW	0x28
> +#define SSS_REG_HASH_PRE_MSG_SIZE_HIGH	0x2C
> +
> +#define SSS_REG_HASH_IV(s)		(0xB0 + ((s) << 2))
> +#define SSS_REG_HASH_OUT(s)		(0x100 + ((s) << 2))
> +
> +#define HASH_BLOCK_SIZE			64
> +#define HASH_REG_SIZEOF			4
> +#define HASH_MD5_MAX_REG		(MD5_DIGEST_SIZE / HASH_REG_SIZEOF)
> +#define HASH_SHA1_MAX_REG		(SHA1_DIGEST_SIZE / HASH_REG_SIZEOF)
> +#define HASH_SHA256_MAX_REG		(SHA256_DIGEST_SIZE / HASH_REG_SIZEOF)
> +
> +/*
> + * HASH bit numbers, used by device, setting in dev->hash_flags with
> + * functions set_bit(), clear_bit() or tested with test_bit() or BIT(),
> + * to keep HASH state BUSY or FREE, or to signal state from irq_handler
> + * to hash_tasklet. SGS keep track of allocated memory for scatterlist
> + */
> +#define HASH_FLAGS_BUSY		0
> +#define HASH_FLAGS_FINAL	1
> +#define HASH_FLAGS_DMA_ACTIVE	2
> +#define HASH_FLAGS_OUTPUT_READY	3
> +#define HASH_FLAGS_DMA_READY	4
> +#define HASH_FLAGS_SGS_COPIED	5
> +#define HASH_FLAGS_SGS_ALLOCED	6
> +
> +/* HASH op codes */
> +#define HASH_OP_UPDATE		1
> +#define HASH_OP_FINAL		2
> +
> +/* HASH HW constants */
> +#define BUFLEN			HASH_BLOCK_SIZE
> +
> +#define SSS_HASH_DMA_LEN_ALIGN	8
> +#define SSS_HASH_DMA_ALIGN_MASK	(SSS_HASH_DMA_LEN_ALIGN - 1)
> +
> +#define SSS_HASH_QUEUE_LENGTH	10
> +
>  /**
>   * struct samsung_aes_variant - platform specific SSS driver data
>   * @aes_offset: AES register offset from SSS module's base.
> + * @hash_offset: HASH register offset from SSS module's base.
>   *
>   * Specifies platform specific configuration of SSS module.
>   * Note: A structure for driver specific platform data is used for future
> @@ -156,6 +248,7 @@
>   */
>  struct samsung_aes_variant {
>  	unsigned int			aes_offset;
> +	unsigned int			hash_offset;
>  };
>  
>  struct s5p_aes_reqctx {
> @@ -195,6 +288,19 @@ struct s5p_aes_ctx {
>   *		protects against concurrent access to these fields.
>   * @lock:	Lock for protecting both access to device hardware registers
>   *		and fields related to current request (including the busy field).
> + * @res:	Resources for hash.
> + * @io_hash_base: Per-variant offset for HASH block IO memory.
> + * @hash_lock:	Lock for protecting hash_req, hash_queue and hash_flags
> + *		variable.
> + * @hash_tasklet: New HASH request scheduling job.
> + * @xmit_buf:	Buffer for current HASH request transfer into SSS block.
> + * @hash_flags:	Flags for current HASH op.
> + * @hash_queue:	Async hash queue.
> + * @hash_req:	Current request sending to SSS HASH block.
> + * @hash_sg_iter: Scatterlist transferred through DMA into SSS HASH block.
> + * @hash_sg_cnt: Counter for hash_sg_iter.
> + *
> + * @use_hash:	true if HASH algs enabled
>   */
>  struct s5p_aes_dev {
>  	struct device			*dev;
> @@ -215,16 +321,84 @@ struct s5p_aes_dev {
>  	struct crypto_queue		queue;
>  	bool				busy;
>  	spinlock_t			lock;
> +
> +	struct resource			*res;
> +	void __iomem			*io_hash_base;
> +
> +	spinlock_t			hash_lock; /* protect hash_ vars */
> +	unsigned long			hash_flags;
> +	struct crypto_queue		hash_queue;
> +	struct tasklet_struct		hash_tasklet;
> +
> +	u8				xmit_buf[BUFLEN];
> +	struct ahash_request		*hash_req;
> +	struct scatterlist		*hash_sg_iter;
> +	int				hash_sg_cnt;
> +
> +	bool				use_hash;
>  };
>  
> -static struct s5p_aes_dev *s5p_dev;
> +/**
> + * struct s5p_hash_reqctx - HASH request context
> + * @dev:	Associated device
> + * @flags:	Bits for current HASH request
> + * @op:		Current request operation (OP_UPDATE or UP_FINAL)

s/UP_FINAL/OP_FINAL/

> + * @digcnt:	Number of bytes processed by HW (without buffer[] ones)
> + * @digest:	Digest message or IV for partial result
> + * @bufcnt:	Number of bytes holded in buffer[]
> + * @nregs:	Number of HW registers for digest or IV read/write
> + * @engine:	Bits for selecting type of HASH in SSS block
> + * @sg:		sg for DMA transfer
> + * @sg_len:	Length of sg for DMA transfer
> + * @sgl[]:	sg for joining buffer and req->src scatterlist
> + * @skip:	Skip offset in req->src for current op
> + * @total:	Total number of bytes for current request
> + * @finup:	Keep state for finup or final.
> + * @error:	Keep track of error.
> + * @buffer[]:	For byte(s) from end of req->src in UPDATE op
> + */
> +struct s5p_hash_reqctx {
> +	struct s5p_aes_dev	*dd;
> +	int			op;

Thanks for converting it from bit-type. Since it can be only UPDATE or
FINAL then please replace this and #defines with just enum.

Rest looks good for me.

Best regards,
Krzysztof

> +
> +	u64			digcnt;
> +	u8			digest[SHA256_DIGEST_SIZE];
> +	u32			bufcnt;
> +
> +	int			nregs; /* digest_size / sizeof(reg) */
> +	u32			engine;
> +
> +	struct scatterlist	*sg;
> +	int			sg_len;
> +	struct scatterlist	sgl[2];
> +	int			skip;
> +	unsigned int		total;
> +	bool			finup;
> +	bool			error;
> +
> +	u8			buffer[0];
> +};
> +
