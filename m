From: Vinod <vkoul@kernel.org>
Subject: Re: [PATCH 1/2] hwrng: msm: add a spinlock and support for blocking
 reads
Date: Fri, 22 Jun 2018 09:47:12 +0530
Message-ID: <20180622041712.GE27187@vkoul-mobl>
References: <1529594276-12210-1-git-send-email-timur@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: timur@kernel.org, linux-arm-msm@vger.kernel.org, swboyd@chromium.org,
 linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
 linux-arm-kernel@lists.infradead.org
To: Timur Tabi <timur@codeaurora.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1529594276-12210-1-git-send-email-timur@codeaurora.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 21-06-18, 10:17, Timur Tabi wrote:
> The hwrng.read callback includes a boolean parameter called 'wait'
> which indicates whether the function should block and wait for
> more data.
> 
> When 'wait' is true, the driver spins on the DATA_AVAIL bit or until
> a reasonable timeout.  The timeout can occur if there is a heavy load
> on reading the PRNG.
> 
> The same code also needs a spinlock to protect against race conditions.
> 
> If multiple cores hammer on the PRNG, it's possible for a race
> condition to occur between reading the status register and
> reading the data register.  Add a spinlock to protect against
> that.
> 
> 1. Core 1 reads status register, shows data is available.
> 2. Core 2 also reads status register, same result
> 3. Core 2 reads data register, depleting all entropy
> 4. Core 1 reads data register, which returns 0
> 
> Signed-off-by: Timur Tabi <timur@codeaurora.org>
> ---
>  drivers/char/hw_random/msm-rng.c | 57 +++++++++++++++++++++++++++++++++++-----
>  1 file changed, 50 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/hw_random/msm-rng.c b/drivers/char/hw_random/msm-rng.c
> index 841fee845ec9..44580588b938 100644
> --- a/drivers/char/hw_random/msm-rng.c
> +++ b/drivers/char/hw_random/msm-rng.c
> @@ -15,9 +15,11 @@
>  #include <linux/err.h>
>  #include <linux/hw_random.h>
>  #include <linux/io.h>
> +#include <linux/iopoll.h>
>  #include <linux/module.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> +#include <linux/spinlock.h>
>  
>  /* Device specific register offsets */
>  #define PRNG_DATA_OUT		0x0000
> @@ -35,10 +37,22 @@
>  #define MAX_HW_FIFO_SIZE	(MAX_HW_FIFO_DEPTH * 4)
>  #define WORD_SZ			4
>  
> +/*
> + * Normally, this would be the maximum time it takes to refill the FIFO,
> + * after a read.  Under heavy load, tests show that this delay is either
> + * below 50us or above 2200us.  The higher value is probably what happens
> + * when entropy is completely depleted.
> + *
> + * Since we don't want to wait 2ms in a spinlock, set the timeout to the
> + * lower value.  Under extreme situations, that timeout can extend to 100us.
> + */
> +#define TIMEOUT		50
> +
>  struct msm_rng {
>  	void __iomem *base;
>  	struct clk *clk;
>  	struct hwrng hwrng;
> +	spinlock_t lock;
>  };
>  
>  #define to_msm_rng(p)	container_of(p, struct msm_rng, hwrng)
> @@ -96,11 +110,39 @@ static int msm_rng_read(struct hwrng *hwrng, void *data, size_t max, bool wait)
>  
>  	/* read random data from hardware */
>  	do {
> -		val = readl_relaxed(rng->base + PRNG_STATUS);
> -		if (!(val & PRNG_STATUS_DATA_AVAIL))
> -			break;
> +		spin_lock(&rng->lock);
> +
> +		/*
> +		 * First check the status bit.  If 'wait' is true, then wait
> +		 * up to TIMEOUT microseconds for data to be available.
> +		 */
> +		if (wait) {
> +			int ret;
> +
> +			ret = readl_poll_timeout_atomic(rng->base + PRNG_STATUS,
> +				val, val & PRNG_STATUS_DATA_AVAIL, 0, TIMEOUT);
> +			if (ret) {
> +				/* Timed out */
> +				spin_unlock(&rng->lock);
> +				break;
> +			}
> +		} else {
> +			val = readl_relaxed(rng->base + PRNG_STATUS);
> +			if (!(val & PRNG_STATUS_DATA_AVAIL)) {
> +				spin_unlock(&rng->lock);
> +				break;
> +			}
> +		}
>  
>  		val = readl_relaxed(rng->base + PRNG_DATA_OUT);
> +		spin_unlock(&rng->lock);
> +
> +		/*
> +		 * Zero is technically a valid random number, but it's also
> +		 * the value returned if the PRNG is not enabled properly.
> +		 * To avoid accidentally returning all zeros, treat it as
> +		 * invalid and just return what we've already read.
> +		 */
>  		if (!val)
>  			break;
>  
> @@ -148,10 +190,11 @@ static int msm_rng_probe(struct platform_device *pdev)
>  	if (IS_ERR(rng->clk))
>  		return PTR_ERR(rng->clk);
>  
> -	rng->hwrng.name = KBUILD_MODNAME,
> -	rng->hwrng.init = msm_rng_init,
> -	rng->hwrng.cleanup = msm_rng_cleanup,
> -	rng->hwrng.read = msm_rng_read,
> +	rng->hwrng.name = KBUILD_MODNAME;
> +	rng->hwrng.init = msm_rng_init;
> +	rng->hwrng.cleanup = msm_rng_cleanup;
> +	rng->hwrng.read = msm_rng_read;

this should be a separate patch

-- 
~Vinod
