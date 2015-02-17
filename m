From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 2/4] hw_random: bcm63xx-rng: move register definitions
 to driver
Date: Tue, 17 Feb 2015 14:35:20 +0300
Message-ID: <54E32778.3060307@cogentembedded.com>
References: <1424138956-11563-1-git-send-email-f.fainelli@gmail.com> <1424138956-11563-3-git-send-email-f.fainelli@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	mpm@selenic.com, herbert@gondor.apana.org.au, wsa@the-dreams.de,
	cernekee@gmail.com
To: Florian Fainelli <f.fainelli@gmail.com>, linux-mips@linux-mips.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1424138956-11563-3-git-send-email-f.fainelli@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello.

On 2/17/2015 5:09 AM, Florian Fainelli wrote:

> arch/mips/include/asm/mach-bcm63xx/bcm63xx_regs.h contains the register
> definitions for this random number generator block, incorporate these
> register definitions directly into the bcm63xx-rng driver so we do not
> rely on this header to be provided.

> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>   drivers/char/hw_random/bcm63xx-rng.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)

> diff --git a/drivers/char/hw_random/bcm63xx-rng.c b/drivers/char/hw_random/bcm63xx-rng.c
> index ed9b28b35a39..c7f3af852599 100644
> --- a/drivers/char/hw_random/bcm63xx-rng.c
> +++ b/drivers/char/hw_random/bcm63xx-rng.c
> @@ -13,7 +13,15 @@
>   #include <linux/platform_device.h>
>   #include <linux/hw_random.h>
>
> -#include <bcm63xx_regs.h>
> +#define RNG_CTRL			0x00
> +#define RNG_EN				(1 << 0)
> +
> +#define RNG_STAT			0x04
> +#define RNG_AVAIL_MASK			(0xff000000)

    Parens not needed here.

WBR, Sergei
