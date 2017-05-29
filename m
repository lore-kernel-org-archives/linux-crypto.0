From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 04/12] staging: ccree: cleanup lli access macro
Date: Mon, 29 May 2017 16:41:14 +0200
Message-ID: <20170529144114.GC12428@kroah.com>
References: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
 <1495982440-10047-5-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
 linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>,
 linux-kernel@vger.kernel.org
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <1495982440-10047-5-git-send-email-gilad@benyossef.com>
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

On Sun, May 28, 2017 at 05:40:29PM +0300, Gilad Ben-Yossef wrote:
> The Linked List Item descriptors were being accessed via
> a baroque set of defines and macro. Re-factor for structs
> and inline function for readability and sanity.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> ---
>  drivers/staging/ccree/cc_lli_defs.h    | 65 +++++++++++++++++++---------------
>  drivers/staging/ccree/ssi_buffer_mgr.c | 45 +++++------------------
>  2 files changed, 44 insertions(+), 66 deletions(-)
> 
> diff --git a/drivers/staging/ccree/cc_lli_defs.h b/drivers/staging/ccree/cc_lli_defs.h
> index 857b94f..c6b2917 100644
> --- a/drivers/staging/ccree/cc_lli_defs.h
> +++ b/drivers/staging/ccree/cc_lli_defs.h
> @@ -28,36 +28,43 @@
>  
>  #define CC_MAX_MLLI_ENTRY_SIZE 0x10000
>  
> -#define LLI_SET_ADDR(__lli_p, __addr) do {				\
> -		u32 *lli_p = (u32 *)__lli_p;				\
> -		typeof(__addr) addr = __addr;				\
> -									\
> -		BITFIELD_SET(lli_p[LLI_WORD0_OFFSET],			\
> -			LLI_LADDR_BIT_OFFSET,				\
> -			LLI_LADDR_BIT_SIZE, (addr & U32_MAX));		\
> -									\
> -		BITFIELD_SET(lli_p[LLI_WORD1_OFFSET],			\
> -			LLI_HADDR_BIT_OFFSET,				\
> -			LLI_HADDR_BIT_SIZE, MSB64(addr));		\
> -	} while (0)
> -
> -#define LLI_SET_SIZE(lli_p, size)					\
> -		BITFIELD_SET(((u32 *)(lli_p))[LLI_WORD1_OFFSET],	\
> -		LLI_SIZE_BIT_OFFSET, LLI_SIZE_BIT_SIZE, size)
> +#define LLI_MAX_NUM_OF_DATA_ENTRIES 128
> +#define LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES 4
> +#define MLLI_TABLE_MIN_ALIGNMENT 4 /* 32 bit alignment */
> +#define MAX_NUM_OF_BUFFERS_IN_MLLI 4
> +#define MAX_NUM_OF_TOTAL_MLLI_ENTRIES (2 * LLI_MAX_NUM_OF_DATA_ENTRIES + \
> +				       LLI_MAX_NUM_OF_ASSOC_DATA_ENTRIES)
> +
> +struct cc_lli_entry {
> +#ifndef __LITTLE_ENDIAN__
> +	u32 addr_lsb;
> +	u16 size;
> +	u16 addr_msb;
> +#else /* __BIG_ENDIAN__ */
> +	u16 addr_msb;
> +	u16 size;
> +	u32 addr_lsb;
> +#endif

How is the bits within the different variables also not affected by the
endian issues?  Just moving them around in the 64bits seems really
strange.

Why not just use the "normal" ways to address data in an endian-neutral
way instead of making your own macros up here?  (i.e. shift and mask.)

thanks,

greg k-h
