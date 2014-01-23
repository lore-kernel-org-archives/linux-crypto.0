From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Subject: Re: [PATCH 8/8 v4] crypto:s5p-sss: Use clk_prepare/clk_unprepare
Date: Thu, 23 Jan 2014 15:48:24 +0530
Message-ID: <CAHfPSqCHGbVX3iMC-LNnFYkdutRYFuk07RCeYLU4KAaTpgyQ0w@mail.gmail.com>
References: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com> <1389777472-15294-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
	Vladimir Zapolskiy <vzapolskiy@gmail.com>,
	herbert@gondor.apana.org.au, cpgs@samsung.com,
	tomasz.figa@gmail.com
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1389777472-15294-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello All,

On 15 January 2014 14:47, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch set adds use of clk_prepare/clk_unprepare as
> required by generic clock framework.
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
> Changes since v3:
> None
>
>  drivers/crypto/s5p-sss.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index f7c66c7..870e794 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -648,7 +648,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>                 return -ENOENT;
>         }
>
> -       clk_enable(pdata->clk);
> +       clk_prepare_enable(pdata->clk);
>
>         spin_lock_init(&pdata->lock);
>         pdata->ioaddr = devm_ioremap(dev, res->start,
> @@ -711,7 +711,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>         tasklet_kill(&pdata->tasklet);
>
>   err_irq:
> -       clk_disable(pdata->clk);
> +       clk_disable_unprepare(pdata->clk);
>
>         s5p_dev = NULL;
>
> @@ -731,7 +731,7 @@ static int s5p_aes_remove(struct platform_device *pdev)
>
>         tasklet_kill(&pdata->tasklet);
>
> -       clk_disable(pdata->clk);
> +       clk_disable_unprepare(pdata->clk);
>
>         s5p_dev = NULL;
>
> --
> 1.7.9.5
Any update on this patch, Please
>



-- 
Shine bright,
(: Nav :)
