From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [PATCH 1/2] hwrng: msm: add a spinlock and support for blocking
 reads
Date: Fri, 22 Jun 2018 18:38:35 +0300
Message-ID: <acc7e9d3-8a81-ff15-27c7-78ec7c17f6cc@linaro.org>
References: <1529594276-12210-1-git-send-email-timur@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Timur Tabi <timur@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
 linux-crypto@vger.kernel.org, vinod.koul@linaro.org,
 Matt Mackall <mpm@selenic.com>, swboyd@chromium.org,
 linux-arm-msm@vger.kernel.org, timur@kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1529594276-12210-1-git-send-email-timur@codeaurora.org>
Content-Language: en-US
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

Hi,

On 06/21/2018 06:17 PM, Timur Tabi wrote:
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

Before entering into the read function we already hold a mutex which
serializes data reading so I cannot imagine how below sequence could
happen. Can you explain how to reproduce this race?

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

-- 
regards,
Stan
