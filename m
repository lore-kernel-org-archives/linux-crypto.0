From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 02/12] staging: ccree: move to kernel bitfields/bitops
Date: Mon, 29 May 2017 16:38:44 +0200
Message-ID: <20170529143844.GB12428@kroah.com>
References: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
 <1495982440-10047-3-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
 linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1495982440-10047-3-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

On Sun, May 28, 2017 at 05:40:27PM +0300, Gilad Ben-Yossef wrote:
> ccree had a lot of boilerplate code for dealing with bitops
> and bitfield register access. Move it over to the generic kernel
> infrastructure used for doing the same.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/staging/ccree/cc_bitops.h        |  11 +-
>  drivers/staging/ccree/cc_hw_queue_defs.h | 679 ++++++++++++-----------
>  drivers/staging/ccree/ssi_aead.c         | 901 +++++++++++++++----------------
>  drivers/staging/ccree/ssi_cipher.c       | 224 ++++----
>  drivers/staging/ccree/ssi_driver.h       |   4 +-
>  drivers/staging/ccree/ssi_fips_ll.c      | 704 ++++++++++++------------
>  drivers/staging/ccree/ssi_hash.c         | 832 ++++++++++++++--------------
>  drivers/staging/ccree/ssi_ivgen.c        |  77 ++-
>  drivers/staging/ccree/ssi_request_mgr.c  |  25 +-
>  drivers/staging/ccree/ssi_sram_mgr.c     |   8 +-
>  10 files changed, 1765 insertions(+), 1700 deletions(-)
> 
> diff --git a/drivers/staging/ccree/cc_bitops.h b/drivers/staging/ccree/cc_bitops.h
> index ee5238a..a12a65c 100644
> --- a/drivers/staging/ccree/cc_bitops.h
> +++ b/drivers/staging/ccree/cc_bitops.h
> @@ -21,9 +21,14 @@
>  #ifndef _CC_BITOPS_H_
>  #define _CC_BITOPS_H_
>  
> -#define BITMASK(mask_size) (((mask_size) < 32) ?	\
> -	((1UL << (mask_size)) - 1) : 0xFFFFFFFFUL)
> -#define BITMASK_AT(mask_size, mask_offset) (BITMASK(mask_size) << (mask_offset))
> +#include <linux/bitops.h>
> +#include <linux/bitfield.h>
> +
> +#define BITMASK(mask_size) (((mask_size) < 32) ? \
> +		((1UL << (mask_size)) - 1) : 0xFFFFFFFFUL)
> +
> +#define BITMASK_AT(mask_size, mask_offset) \
> +	(BITMASK(mask_size) << (mask_offset))

Why do you still needed these macros with this change?

>  
>  #define BITFIELD_GET(word, bit_offset, bit_size) \
>  	(((word) >> (bit_offset)) & BITMASK(bit_size))
> diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
> index 7138176..af10850 100644
> --- a/drivers/staging/ccree/cc_hw_queue_defs.h
> +++ b/drivers/staging/ccree/cc_hw_queue_defs.h
> @@ -22,25 +22,69 @@
>  #include "cc_regs.h"
>  #include "dx_crys_kernel.h"
>  
> -/******************************************************************************
> -*				DEFINITIONS
> -******************************************************************************/
> -
> -/* Dma AXI Secure bit */
> -#define	AXI_SECURE	0
> -#define AXI_NOT_SECURE	1
> +/*****************************************************************************
> + *				DEFINITIONS
> + *****************************************************************************/

That has nothing to do with changing bitops :(

>  
>  #define HW_DESC_SIZE_WORDS		6
> -#define HW_QUEUE_SLOTS_MAX              15 /* Max. available slots in HW queue */
> +#define HW_QUEUE_SLOTS_MAX              15 /* Max. available HW queue slots */

Neither does this :(

I'm stopping reviewing this here, please be more careful...

greg k-h
