From: Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH v2] hwrng: meson: Fix module autoload for OF registration
Date: Wed, 19 Oct 2016 11:19:39 +0200
Message-ID: <e8df64b3-79c3-2d69-97b6-ee99d052d22b@baylibre.com>
References: <1476733877-20275-1-git-send-email-javier@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Kevin Hilman <khilman@baylibre.com>, Matt Mackall <mpm@selenic.com>,
 Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
 linux-crypto@vger.kernel.org,
 PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
 Carlo Caione <carlo@caione.org>, linux-amlogic@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org
To: Javier Martinez Canillas <javier@osg.samsung.com>,
 linux-kernel@vger.kernel.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1476733877-20275-1-git-send-email-javier@osg.samsung.com>
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

On 10/17/2016 09:51 PM, Javier Martinez Canillas wrote:
> If the driver is built as a module, autoload won't work because the module
> alias information is not filled. So user-space can't match the registered
> device with the corresponding module.
> 
> Export the module alias information using the MODULE_DEVICE_TABLE() macro.
> 
> Before this patch:
> 
> $ modinfo drivers/char/hw_random/meson-rng.ko | grep alias
> alias:          platform:meson-rng
> 
> After this patch:
> 
> $ modinfo drivers/char/hw_random/meson-rng.ko | grep alias
> alias:          platform:meson-rng
> alias:          of:N*T*Camlogic,meson-rngC*
> alias:          of:N*T*Camlogic,meson-rng
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
> Changes in v2:
> - Remove unrelated changes added by mistake. Suggested by Jason Gunthorpe.
> 
>  drivers/char/hw_random/meson-rng.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/char/hw_random/meson-rng.c b/drivers/char/hw_random/meson-rng.c
> index 58bef39f7286..51864a509be7 100644
> --- a/drivers/char/hw_random/meson-rng.c
> +++ b/drivers/char/hw_random/meson-rng.c
> @@ -110,6 +110,7 @@ static const struct of_device_id meson_rng_of_match[] = {
>  	{ .compatible = "amlogic,meson-rng", },
>  	{},
>  };
> +MODULE_DEVICE_TABLE(of, meson_rng_of_match);
>  
>  static struct platform_driver meson_rng_driver = {
>  	.probe	= meson_rng_probe,
> 

Acked-by: Neil Armstrong <narmstrong@baylibre.com>
