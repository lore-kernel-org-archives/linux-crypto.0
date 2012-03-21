From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/3] crypto: ux500: Add driver for HASH hardware
Date: Tue, 20 Mar 2012 19:35:14 -0500
Message-ID: <20120320193514.5654abff6d656e79f1035717@freescale.com>
References: <1331714748-25136-1-git-send-email-andreas.westin@stericsson.com>
	<1331714748-25136-3-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	<linux-crypto@vger.kernel.org>
To: Andreas Westin <andreas.westin@stericsson.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:7290
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755227Ab2CUAgv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Mar 2012 20:36:51 -0400
In-Reply-To: <1331714748-25136-3-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 14 Mar 2012 09:45:47 +0100
Andreas Westin <andreas.westin@stericsson.com> wrote:

> diff --git a/drivers/crypto/ux500/hash/hash_alg_p.h b/drivers/crypto/ux500/hash/hash_alg_p.h
> new file mode 100644
> index 0000000..a44047a
> --- /dev/null
> +++ b/drivers/crypto/ux500/hash/hash_alg_p.h
> @@ -0,0 +1,20 @@
> +/*
> + * Copyright (C) ST-Ericsson SA 2010
> + * Author :  Robert Marklund <robert.marklund@stericsson.com>
> + * License terms: GNU General Public License (GPL) version 2
> +*/
> +
> +#ifndef _HASH_P_H_
> +#define _HASH_P_H_
> +
> +/*--------------------------------------------------------------------------*
> + * Includes                                                                 *
> + *--------------------------------------------------------------------------*/
> +#include "hash_alg.h"
> +
> +/*--------------------------------------------------------------------------*
> + * Defines                                                                  *
> + *--------------------------------------------------------------------------*/
> +
> +#endif /* End _HASH_P_H_ */
> +

this header file doesn't look very useful just including another
header.

> +static int hash_mode;
> +module_param(hash_mode, int, 0);
> +MODULE_PARM_DESC(hash_mode, "CPU or DMA mode. CPU = 0 (default), DMA = 1");



> +/**
> + * Pre-calculated empty message digests.
> + */
> +static u8 zero_message_hash_sha1[SHA1_DIGEST_SIZE] = {
> +	0xda, 0x39, 0xa3, 0xee, 0x5e, 0x6b, 0x4b, 0x0d,
> +	0x32, 0x55, 0xbf, 0xef, 0x95, 0x60, 0x18, 0x90,
> +	0xaf, 0xd8, 0x07, 0x09
> +};

Please explain why these are not equal to SHA1_H0 values, etc.

> +static void hash_hw_write_key(struct hash_device_data *device_data,
> +		const u8 *key, unsigned int keylen)
> +{
> +	u32 word = 0;
> +	int nwords = 1;
> +
> +	HASH_CLEAR_BITS(&device_data->base->str, HASH_STR_NBLW_MASK);
> +
> +	while (keylen >= 4) {
> +		word = ((u32) (key[3] & 0xff) << 24) |
> +			((u32) (key[2] & 0xff) << 16) |
> +			((u32) (key[1] & 0xff) << 8) |
> +			((u32) (key[0] & 0xff));

assuming this isn't a cpu--h/w endian conversion, there's something
in include/linux/swab.h that's reusable here.

> +/**
> + * hash_save_state - Function that saves the state of hardware.
> + * @device_data:	Pointer to the device structure.
> + * @device_state:	The strucure where the hardware state should be saved.
> + *
> + * Reentrancy: Non Re-entrant

I can't tell - is the driver taking care of the locking, or does
this mean the driver does not work with e.g., PREEMPT on?

> + */
> +int hash_save_state(struct hash_device_data *device_data,
> +		struct hash_state *device_state)
> +{
> +	u32 temp_cr;
> +	u32 count;
> +	int hash_mode = HASH_OPER_MODE_HASH;
> +
> +	if (NULL == device_state) {
> +		dev_err(device_data->dev, "[%s] HASH_INVALID_PARAMETER!",
> +				__func__);
> +		return -EPERM;

-ENOTSUPP, no?

> +/**
> + * hash_check_hw - This routine checks for peripheral Ids and PCell Ids.
> + * @device_data:
> + *
> + */
> +int hash_check_hw(struct hash_device_data *device_data)
> +{
> +	int ret = 0;
> +
> +	if (NULL == device_data) {

when would this be called with NULL?

> +		ret = -EPERM;
> +		pr_err(DEV_DBG_NAME " [%s] HASH_INVALID_PARAMETER!",
> +			__func__);
> +		goto out;
> +	}
> +
> +	/* Checking Peripheral Ids  */
> +	if ((HASH_P_ID0 == readl_relaxed(&device_data->base->periphid0))
> +		&& (HASH_P_ID1 == readl_relaxed(&device_data->base->periphid1))
> +		&& (HASH_P_ID2 == readl_relaxed(&device_data->base->periphid2))
> +		&& (HASH_P_ID3 == readl_relaxed(&device_data->base->periphid3))
> +		&& (HASH_CELL_ID0 == readl_relaxed(&device_data->base->cellid0))
> +		&& (HASH_CELL_ID1 == readl_relaxed(&device_data->base->cellid1))
> +		&& (HASH_CELL_ID2 == readl_relaxed(&device_data->base->cellid2))
> +		&& (HASH_CELL_ID3 == readl_relaxed(&device_data->base->cellid3))
> +	   ) {

unnecessary inner parens

> +		ret = 0;
> +		goto out;

just return 0

> +	} else {
> +		ret = -EPERM;
> +		dev_err(device_data->dev, "[%s] HASH_UNSUPPORTED_HW!",
> +				__func__);
> +		goto out;
> +	}
> +out:
> +	return ret;
> +}

drop the else keyword, then just dev_err and return -ENOTSUPP.

> +/**
> + * hash_algs_register_all -
> + */
> +static int ahash_algs_register_all(struct hash_device_data *device_data)

see my comment on alg. registration to patch 1/3.

Kim
