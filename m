From: Stephen Boyd <swboyd@chromium.org>
Subject: Re: [PATCH 1/2] hwrng: msm: add a spinlock and support for blocking
 reads
Date: Thu, 21 Jun 2018 22:36:33 -0700
Message-ID: <152964579304.16708.2651020848216712299@swboyd.mtv.corp.google.com>
References: <1529594276-12210-1-git-send-email-timur@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: timur@codeaurora.org
To: Matt Mackall <mpm@selenic.com>, Timur Tabi <timur@codeaurora.org>,
 linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
 linux-crypto@vger.kernel.org, timur@kernel.org, vinod.koul@linaro.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
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

Quoting Timur Tabi (2018-06-21 08:17:55)
> @@ -96,11 +110,39 @@ static int msm_rng_read(struct hwrng *hwrng, void *data, size_t max, bool wait)
>  
>         /* read random data from hardware */
>         do {
> -               val = readl_relaxed(rng->base + PRNG_STATUS);
> -               if (!(val & PRNG_STATUS_DATA_AVAIL))
> -                       break;
> +               spin_lock(&rng->lock);
> +
> +               /*
> +                * First check the status bit.  If 'wait' is true, then wait
> +                * up to TIMEOUT microseconds for data to be available.
> +                */
> +               if (wait) {
> +                       int ret;

Please don't do local variables like this. Put them at the top of the
function.

> +
> +                       ret = readl_poll_timeout_atomic(rng->base + PRNG_STATUS,
> +                               val, val & PRNG_STATUS_DATA_AVAIL, 0, TIMEOUT);
> +                       if (ret) {
> +                               /* Timed out */
> +                               spin_unlock(&rng->lock);
> +                               break;
> +                       }
> +               } else {
> +                       val = readl_relaxed(rng->base + PRNG_STATUS);
> +                       if (!(val & PRNG_STATUS_DATA_AVAIL)) {
> +                               spin_unlock(&rng->lock);
> +                               break;
> +                       }
> +               }
>  
>                 val = readl_relaxed(rng->base + PRNG_DATA_OUT);
> +               spin_unlock(&rng->lock);

Maybe this should be written as:

		spin_lock()
		if (wait) {
			has_data = readl_poll_timeout_atomic(...) == 0;
		} else {
			val = readl_relaxed(rng->base + PRNG_STATUS);
			has_data = val & PRNG_STATUS_DATA_AVAIL;
		}

		if (has_data)
			val = readl_relaxed(rng->base + PRNG_DATA_OUT);
		spin_unlock();

		if (!has_data)
			break;

> +
> +               /*
> +                * Zero is technically a valid random number, but it's also
> +                * the value returned if the PRNG is not enabled properly.
> +                * To avoid accidentally returning all zeros, treat it as
> +                * invalid and just return what we've already read.
> +                */
>                 if (!val)
>                         break;

Is this a related change? Looks like a nice comment that isn't related
to locking.
