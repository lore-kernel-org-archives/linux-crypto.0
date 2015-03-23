From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH v3] omap-rng: Change RNG_CONFIG_REG to RNG_CONTROL_REG
 when, checking and disabling TRNG
Date: Mon, 23 Mar 2015 10:42:52 +0530
Message-ID: <550FA0D4.4070905@ti.com>
References: <54E6BA01.7090904@analog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>
To: Andre Wolokita <andre.wolokita@analog.com>, <dsaxena@plexity.net>
Return-path: <linux-omap-owner@vger.kernel.org>
In-Reply-To: <54E6BA01.7090904@analog.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Andre,
On Friday 20 February 2015 10:07 AM, Andre Wolokita wrote:
> In omap4_rng_init(), a check of bit 10 of the RNG_CONFIG_REG is done to determine
> whether the RNG is running. This is suspicious firstly due to the use of
> RNG_CONTROL_ENABLE_TRNG_MASK and secondly because the same mask is written to
> RNG_CONTROL_REG after configuration of the FROs. Similar suspicious logic is
> repeated in omap4_rng_cleanup() when RNG_CONTROL_REG masked with
> RNG_CONTROL_ENABLE_TRNG_MASK is read, the same mask bit is cleared, and then
> written to RNG_CONFIG_REG. Unless the TRNG is enabled with one bit in RNG_CONTROL
> and disabled with another in RNG_CONFIG and these bits are mirrored in some way,
> I believe that the TRNG is not really shutting off, leaving the FROs running
> indefinitely which, in an extreme case, could lead to degredation of the
> hardware and potentially reduce the level of entropy generated.
Yes you are correct. Patch looks good to me.
It should be RNG_CONTROL_REG

Acked-by: Lokesh Vutla <lokeshvutla@ti.com>

Thanks and regards,
Lokesh

> 
> Apart from the strange logic, I have reason to suspect that the OMAP4 related
> code in this driver is driving an Inside Secure IP hardware RNG and strongly
> suspect that bit 10 of RNG_CONFIG_REG is one of the bits configuring the
> sampling rate of the FROs. This option is by default set to 0 and is not being
> set anywhere in omap-rng.c. Reading this bit during omap4_rng_init() will
> always return 0. It will remain 0 because ~(value of TRNG_MASK in control) will
> always be 0, because the TRNG is never shut off. This is of course presuming
> that the OMAP4 features the Inside Secure IP, which I strongly suspect.
> 
> I'm interested in knowing what the guys at TI think about this, as only they
> can confirm or deny the detailed structure of these registers.
> 
> Signed-off-by: Andre Wolokita <Andre.Wolokita@analog.com>
> ---
>  drivers/char/hw_random/omap-rng.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
> index d14dcf7..67151cb 100644
> --- a/drivers/char/hw_random/omap-rng.c
> +++ b/drivers/char/hw_random/omap-rng.c
> @@ -236,7 +236,7 @@ static int omap4_rng_init(struct omap_rng_dev *priv)
>         u32 val;
> 
>         /* Return if RNG is already running. */
> -       if (omap_rng_read(priv, RNG_CONFIG_REG) & RNG_CONTROL_ENABLE_TRNG_MASK)
> +       if (omap_rng_read(priv, RNG_CONTROL_REG) & RNG_CONTROL_ENABLE_TRNG_MASK)
>                 return 0;
> 
>         val = RNG_CONFIG_MIN_REFIL_CYCLES << RNG_CONFIG_MIN_REFIL_CYCLES_SHIFT;
> @@ -262,7 +262,7 @@ static void omap4_rng_cleanup(struct omap_rng_dev *priv)
> 
>         val = omap_rng_read(priv, RNG_CONTROL_REG);
>         val &= ~RNG_CONTROL_ENABLE_TRNG_MASK;
> -       omap_rng_write(priv, RNG_CONFIG_REG, val);
> +       omap_rng_write(priv, RNG_CONTROL_REG, val);
>  }
> 
>  static irqreturn_t omap4_rng_irq(int irq, void *dev_id)
> 

