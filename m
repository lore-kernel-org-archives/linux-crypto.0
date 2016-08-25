From: LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH] hwrng: pasemi_rng.c: Migrate to managed API
Date: Thu, 25 Aug 2016 14:15:46 +0200
Message-ID: <20160825121546.GA25650@Red>
References: <1472124856-12767-1-git-send-email-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, mpm@selenic.com, olof@lixom.net,
 linuxppc-dev@lists.ozlabs.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Disposition: inline
In-Reply-To: <1472124856-12767-1-git-send-email-prasannatsmkumar@gmail.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 25, 2016 at 05:04:16PM +0530, PrasannaKumar Muralidharan wrote:
> Use devm_ioremap and devm_hwrng_register instead of ioremap and
> hwrng_register. This removes unregistering and error handling code.
> 
> This patch is not tested with hardware as I don't have access to it.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> ---
>  drivers/char/hw_random/pasemi-rng.c | 26 +++-----------------------
>  1 file changed, 3 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
> index 699b725..0f03397 100644
> --- a/drivers/char/hw_random/pasemi-rng.c
> +++ b/drivers/char/hw_random/pasemi-rng.c
> @@ -100,37 +100,18 @@ static int rng_probe(struct platform_device *ofdev)
>  	void __iomem *rng_regs;
>  	struct device_node *rng_np = ofdev->dev.of_node;
>  	struct resource res;
> -	int err = 0;
>  
> -	err = of_address_to_resource(rng_np, 0, &res);
> -	if (err)
> +	if (of_address_to_resource(rng_np, 0, &res))
>  		return -ENODEV;
>  
> -	rng_regs = ioremap(res.start, 0x100);
> -
> +	rng_regs = devm_ioremap(&ofdev->dev, res.start, 0x100);
>  	if (!rng_regs)
>  		return -ENOMEM;
>  

I will propose to use devm_ioremap_resource() instead for removing this hardcoded 0x100, but i cannot find any user of this driver in any dts. (And so cannot check that this 0x100 is given in any DT resource node)

Is this normal ?

Regard
