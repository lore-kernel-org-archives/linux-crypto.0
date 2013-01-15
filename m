From: "Mark A. Greer" <mgreer@animalcreek.com>
Subject: Re: [PATCH] crypto: omap-sham - Fix compile errors when CONFIG_OF
 not defined
Date: Tue, 15 Jan 2013 16:36:35 -0700
Message-ID: <20130115233635.GB527@animalcreek.com>
References: <1358283182-29392-1-git-send-email-mgreer@animalcreek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: herbert@gondor.apana.org.au
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1358283182-29392-1-git-send-email-mgreer@animalcreek.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jan 15, 2013 at 01:53:02PM -0700, Mark A. Greer wrote:
> From: "Mark A. Greer" <mgreer@animalcreek.com>
> 
> Fix the compile errors created by commit 2545e8d
> (crypto: omap-sham - Add Device Tree Support)
> when CONFIG_OF is not defined.  This includes
> changing omap_sham_get_res_dev() to omap_sham_get_res_of()
> and creating an empty version of omap_sham_of_match[].
> 
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
>  drivers/crypto/omap-sham.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index edff981..dc2d354 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -1607,7 +1607,11 @@ err:
>  	return err;
>  }
>  #else
> -static int omap_sham_get_res_dev(struct omap_sham_dev *dd,
> +static const struct of_device_id omap_sham_of_match[] = {
> +	{},
> +};
> +
> +static int omap_sham_get_res_of(struct omap_sham_dev *dd,
>  		struct device *dev, struct resource *res)
>  {
>  	return -EINVAL;
> -- 
> 1.7.12

I meant to add that this applies to the current cryptodev/master repo/branch.

Mark
--
