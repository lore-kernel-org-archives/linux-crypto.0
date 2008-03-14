From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [patch 2/2] zcrypt: add support for large random numbers
Date: Fri, 14 Mar 2008 09:14:02 -0700
Message-ID: <20080314091402.fa409ac7.randy.dunlap@oracle.com>
References: <20080314092523.147382820@de.ibm.com>
	<20080314093046.914555041@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org, Ralph Wuerthner <rwuerthn@de.ibm.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:34079 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbYCNQPw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Mar 2008 12:15:52 -0400
In-Reply-To: <20080314093046.914555041@de.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 14 Mar 2008 10:25:25 +0100 Martin Schwidefsky wrote:

> This patch allows user space applications to access large amounts of 
> truly random data. The random data source is the build-in hardware 
> random number generator on the CEX2C cards.
> ---
> 
>  drivers/crypto/Kconfig              |    1 
>  drivers/s390/crypto/zcrypt_api.c    |  120 +++++++++++++++++++++
>  drivers/s390/crypto/zcrypt_api.h    |    8 +
>  drivers/s390/crypto/zcrypt_pcixcc.c |  199 +++++++++++++++++++++++++++++++++++-
>  4 files changed, 327 insertions(+), 1 deletion(-)
> 
> Index: quilt-2.6/drivers/s390/crypto/zcrypt_api.c
> ===================================================================
> --- quilt-2.6.orig/drivers/s390/crypto/zcrypt_api.c
> +++ quilt-2.6/drivers/s390/crypto/zcrypt_api.c
> @@ -36,6 +36,7 @@
>  #include <linux/compat.h>
>  #include <asm/atomic.h>
>  #include <asm/uaccess.h>
> +#include <linux/hw_random.h>
>  
>  #include "zcrypt_api.h"
>  

> @@ -1041,6 +1094,73 @@ out:
>  	return count;
>  }
>  
> +static int zcrypt_rng_device_count;
> +static u32 *zcrypt_rng_buffer;
> +static int zcrypt_rng_buffer_index;
> +static DEFINE_MUTEX(zcrypt_rng_mutex);
> +
> +static int zcrypt_rng_data_read(struct hwrng *rng, u32 *data)
> +{
> +	int rc;
> +
> +	/**
> +	 * We don't need locking here because the RNG API guarantees serialized
> +	 * read method calls.
> +	 */

Hi,
Linux kernel uses "/**" to indicate the beginning of kernel-doc
notation, so when the comment block is not kernel-doc, please don't
use that /** to begin the comment block.
(multiple occurrences of this)

> +	if (zcrypt_rng_buffer_index == 0) {
> +		rc = zcrypt_rng((char *) zcrypt_rng_buffer);
> +		if (rc < 0)
> +			return -EIO;
> +		zcrypt_rng_buffer_index = rc / sizeof *data;
> +	}
> +	*data = zcrypt_rng_buffer[--zcrypt_rng_buffer_index];
> +	return sizeof *data;
> +}
> +
> +static struct hwrng zcrypt_rng_dev = {
> +	.name		= "zcrypt",
> +	.data_read	= zcrypt_rng_data_read,
> +};
> +
> +static int zcrypt_rng_device_add(void)
> +{
...
> +}


> Index: quilt-2.6/drivers/s390/crypto/zcrypt_pcixcc.c
> ===================================================================
> --- quilt-2.6.orig/drivers/s390/crypto/zcrypt_pcixcc.c
> +++ quilt-2.6/drivers/s390/crypto/zcrypt_pcixcc.c
> @@ -356,6 +356,55 @@ static int XCRB_msg_to_type6CPRB_msgX(st
>  }
>  
>  /**
> + * Prepare a type6 CPRB message for random number generation
> + *
> + * @ap_dev: AP device pointer
> + * @ap_msg: pointer to AP message
> + */

This one is almost kernel-doc.  Just put the function name plus a
hyphen/dash on the first line and remove the almost-blank line:

/**
 * rng_type6CPRB_msgX - Prepare a type6 CPRB message for random number generation
 * @ap_dev: AP device pointer
 * @ap_msg: pointer to AP message
 */


See Documentation/kernel-doc-nano-HOWTO.txt for more info/details,
or ask me/lkml.

> +static void rng_type6CPRB_msgX(struct ap_device *ap_dev,
> +			       struct ap_message *ap_msg,
> +			       unsigned random_number_length)
> +{

...

> +}
> +
> +/**
>   * Copy results from a type 86 ICA reply message back to user space.
>   *
>   * @zdev: crypto device pointer

> @@ -736,6 +830,42 @@ out_free:
>  }
>  
>  /**
> + * The request distributor calls this function if it picked the PCIXCC/CEX2C
> + * device to generate random data.
> + * @zdev: pointer to zcrypt_device structure that identifies the
> + *	  PCIXCC/CEX2C device to the request distributor
> + * @buffer: pointer to a memory page to return random data
> + */
> +
> +static long zcrypt_pcixcc_rng(struct zcrypt_device *zdev,
> +				    char *buffer)
> +{
...
> +}
> +
> +/**
>   * The crypto operations for a PCIXCC/CEX2C card.
>   */
>  static struct zcrypt_ops zcrypt_pcixcc_ops = {
> @@ -859,6 +996,58 @@ out_free:
>  }
>  
>  /**
> + * Large random number detection function. Its sends a message to a pcixcc
> + * card to find out if large random numbers are supported.
> + * @ap_dev: pointer to the AP device.
> + *
> + * Returns 1 if large random numbers are supported, 0 if not and < 0 on error.
> + */
> +static int zcrypt_pcixcc_rng_supported(struct ap_device *ap_dev)
> +{
...
> +}

---
~Randy
