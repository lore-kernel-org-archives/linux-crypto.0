From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 2/3] ARM: at91/dt/trivial: before sama5d3, Atmel MPU were
 using at91 prefix
Date: Mon, 14 Oct 2013 19:09:51 +0200
Message-ID: <20131014170951.GJ11420@ns203013.ovh.net>
References: <ba9872c3bb29c9a06f06caa8e0b4528329f07675.1381769174.git.nicolas.ferre@atmel.com>
 <a7f43a96aaf83c3348dc631c71c54729f9d0e9e0.1381769174.git.nicolas.ferre@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 ebenard@eukrea.com, linux-arm-kernel@lists.infradead.org,
 herbert@gondor.apana.org.au
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <a7f43a96aaf83c3348dc631c71c54729f9d0e9e0.1381769174.git.nicolas.ferre@atmel.com>
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

On 18:46 Mon 14 Oct     , Nicolas Ferre wrote:
> Change the sha/aes/tdes compatibility string to match common
> case for the at91sam9g45 family which is to keep the at91 prefix.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  arch/arm/boot/dts/sama5d3.dtsi | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
> index b2aabff..99bd4a6 100644
> --- a/arch/arm/boot/dts/sama5d3.dtsi
> +++ b/arch/arm/boot/dts/sama5d3.dtsi
> @@ -342,19 +342,19 @@
>  			};
>  
>  			sha@f8034000 {
> -				compatible = "atmel,sam9g46-sha";
> +				compatible = "atmel,at91sam9g46-sha";
>  				reg = <0xf8034000 0x100>;
>  				interrupts = <42 IRQ_TYPE_LEVEL_HIGH 0>;
>  			};
>  
>  			aes@f8038000 {
> -				compatible = "atmel,sam9g46-aes";
> +				compatible = "atmel,at91sam9g46-aes";
>  				reg = <0xf8038000 0x100>;
>  				interrupts = <43 IRQ_TYPE_LEVEL_HIGH 0>;
>  			};
>  
>  			tdes@f803c000 {
> -				compatible = "atmel,sam9g46-tdes";
> +				compatible = "atmel,at91sam9g46-tdes";
>  				reg = <0xf803c000 0x100>;
>  				interrupts = <44 IRQ_TYPE_LEVEL_HIGH 0>;
you keep the previous compatible in the driver too for backword compatiblity

Best Regards,
J.
>  			};
> -- 
> 1.8.2.2
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
