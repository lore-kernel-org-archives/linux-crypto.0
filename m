From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: Re: [PATCH 2/5] ARM: AT91SAM9G45: same platform data structure for
 all crypto peripherals
Date: Wed, 7 Nov 2012 16:26:15 +0100
Message-ID: <20121107152615.GD4576@game.jcrosoft.org>
References: <1352219544-30416-1-git-send-email-nicolas@eukrea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: herbert@gondor.apana.org.au, nicolas.ferre@atmel.com,
 linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, eric@eukrea.com,
 davem@davemloft.net, linux-arm-kernel@lists.infradead.org
To: Nicolas Royer <nicolas@eukrea.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1352219544-30416-1-git-send-email-nicolas@eukrea.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: linux-arm-kernel-bounces@lists.infradead.org
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On 17:32 Tue 06 Nov     , Nicolas Royer wrote:
> Only AES use DMA in AT91SAM9G45 (TDES and SHA use PDC).
> =

> However latest Atmel TDES and SHA IP releases use DMA instead of PDC.
>   --> Atmel TDES and SHA drivers need DMA platform data for those IP rele=
ases.
> =

> Goal of this patch is to use the same platform data structure for all Atm=
el
> crypto peripherals. This structure contains information about DMA interfa=
ce.
> =

> Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Acked-by: Eric B=E9nard <eric@eukrea.com>
> Tested-by: Eric B=E9nard <eric@eukrea.com>
> ---
>  arch/arm/mach-at91/at91sam9g45_devices.c   |    8 ++++----
>  include/linux/platform_data/atmel-aes.h    |   22 ----------------------
>  include/linux/platform_data/crypto-atmel.h |   22 ++++++++++++++++++++++
>  3 files changed, 26 insertions(+), 26 deletions(-)
>  delete mode 100644 include/linux/platform_data/atmel-aes.h
>  create mode 100644 include/linux/platform_data/crypto-atmel.h
> =

> diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at9=
1/at91sam9g45_devices.c
> index fcd233c..a48dcb4 100644
> --- a/arch/arm/mach-at91/at91sam9g45_devices.c
> +++ b/arch/arm/mach-at91/at91sam9g45_devices.c
> @@ -18,7 +18,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/i2c-gpio.h>
>  #include <linux/atmel-mci.h>
> -#include <linux/platform_data/atmel-aes.h>
> +#include <linux/platform_data/crypto-atmel.h>
>  =

>  #include <linux/platform_data/at91_adc.h>
>  =

> @@ -1900,7 +1900,7 @@ static void __init at91_add_device_tdes(void) {}
>   * -------------------------------------------------------------------- =
*/
>  =

>  #if defined(CONFIG_CRYPTO_DEV_ATMEL_AES) || defined(CONFIG_CRYPTO_DEV_AT=
MEL_AES_MODULE)
> -static struct aes_platform_data aes_data;
> +static struct crypto_platform_data aes_data;
>  static u64 aes_dmamask =3D DMA_BIT_MASK(32);
>  =

>  static struct resource aes_resources[] =3D {
> @@ -1931,9 +1931,9 @@ static struct platform_device at91sam9g45_aes_devic=
e =3D {
>  static void __init at91_add_device_aes(void)
>  {
>  	struct at_dma_slave	*atslave;
> -	struct aes_dma_data	*alt_atslave;
> +	struct crypto_dma_data	*alt_atslave;
>  =

> -	alt_atslave =3D kzalloc(sizeof(struct aes_dma_data), GFP_KERNEL);
> +	alt_atslave =3D kzalloc(sizeof(struct crypto_dma_data), GFP_KERNEL);
we do not check the result of kzalloc ouch

and why we allocate it?

Best Regards,
J.
J.
