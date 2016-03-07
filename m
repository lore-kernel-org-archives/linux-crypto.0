From: Vladimir Zapolskiy <vz@mleia.com>
Subject: Re: [PATCH 1/2] crypto: s5p-sss - Minor coding cleanups
Date: Mon, 7 Mar 2016 03:01:53 +0200
Message-ID: <56DCD301.4030401@mleia.com>
References: <1457259436-32560-1-git-send-email-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Krzysztof Kozlowski <krzk@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-samsung-soc@vger.kernel.org
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1457259436-32560-1-git-send-email-krzk@kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Krzysztof,

On 06.03.2016 12:17, Krzysztof Kozlowski wrote:
> Remove unneeded inclusion of delay.h and get rid of indentation from
> labels.

just in case are you aware of this discussion regarding goto labels
http://lkml.iu.edu/hypermail/linux/kernel/0706.0/0809.html ?

Practically there is no big need (neither it is a clean-up IMHO)
to change column 1 indentation of goto labels, however I do agree that
^[a-z0-9_]\+:$ style of goto labels is 10 times more commonly used,
and that means it's a good time to update my ~/.emacs config.

Someone may want to fix the style of another 5000+ goto labels one day,
though it is better to have an officially agreed policy beforehand.

Anyway I do not strictly object against the change, see one my comment
below and feel free to add my

Acked-by: Vladimir Zapolskiy <vz@mleia.com>

> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  drivers/crypto/s5p-sss.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 5f161a9777e3..60f835455a41 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -11,7 +11,6 @@
>   *
>   */
>  
> -#include <linux/delay.h>
>  #include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/init.h>

Since you are here, can you sort headers out, please?

And I'm pretty sure some more inclusions can be safely removed
from the list.

> @@ -284,7 +283,7 @@ static int s5p_set_outdata(struct s5p_aes_dev *dev, struct scatterlist *sg)
>  	dev->sg_dst = sg;
>  	err = 0;
>  
> - exit:
> +exit:
>  	return err;
>  }
>  
> @@ -310,7 +309,7 @@ static int s5p_set_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
>  	dev->sg_src = sg;
>  	err = 0;
>  
> - exit:
> +exit:
>  	return err;
>  }
>  
> @@ -452,10 +451,10 @@ static void s5p_aes_crypt_start(struct s5p_aes_dev *dev, unsigned long mode)
>  
>  	return;
>  
> - outdata_error:
> +outdata_error:
>  	s5p_unset_indata(dev);
>  
> - indata_error:
> +indata_error:
>  	s5p_aes_complete(dev, err);
>  	spin_unlock_irqrestore(&dev->lock, flags);
>  }
> @@ -506,7 +505,7 @@ static int s5p_aes_handle_req(struct s5p_aes_dev *dev,
>  
>  	tasklet_schedule(&dev->tasklet);
>  
> - exit:
> +exit:
>  	return err;
>  }
>  
> @@ -705,7 +704,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  
>  	return 0;
>  
> - err_algs:
> +err_algs:
>  	dev_err(dev, "can't register '%s': %d\n", algs[i].cra_name, err);
>  
>  	for (j = 0; j < i; j++)
> @@ -713,7 +712,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>  
>  	tasklet_kill(&pdata->tasklet);
>  
> - err_irq:
> +err_irq:
>  	clk_disable_unprepare(pdata->clk);
>  
>  	s5p_dev = NULL;
> 

--
With best wishes,
Vladimir
