From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH v2] tpm: Move Linux RNG connection to hwrng
Date: Sun, 5 Nov 2017 13:05:06 +0200
Message-ID: <20171105110506.usxmuzrvcjvxahr6@linux.intel.com>
References: <20171031200503.GC18578@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        linux-integrity@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:INTEGRITY MEASUREMENT ARCHITECTURE (IMA)"
        <linux-security-module@vger.kernel.org>,
        "open list:KEYS-TRUSTED" <keyrings@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        Matt Mackall <mpm@selenic.com>,
        David Safford <safford@us.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Serge E. Hallyn" <serge@hall
To: Jason Gunthorpe <jgg@ziepe.ca>
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171031200503.GC18578@ziepe.ca>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 31, 2017 at 02:05:03PM -0600, Jason Gunthorpe wrote:
> The tpm-rng.c approach is completely inconsistent with how the kernel
> handles hotplug. Instead manage a hwrng device for each TPM. This will
> cause the kernel to read entropy from the TPM when it is plugged in,
> and allow access to the TPM rng via /dev/hwrng.
> 
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/char/hw_random/Kconfig   | 13 -----------
>  drivers/char/hw_random/Makefile  |  1 -
>  drivers/char/hw_random/tpm-rng.c | 50 ----------------------------------------
>  drivers/char/tpm/Kconfig         | 11 +++++++++
>  drivers/char/tpm/tpm-chip.c      | 41 ++++++++++++++++++++++++++++----
>  drivers/char/tpm/tpm.h           |  4 ++++
>  6 files changed, 52 insertions(+), 68 deletions(-)
>  delete mode 100644 drivers/char/hw_random/tpm-rng.c
> 
> v2 applies against Jarkko's patch
> "tpm: use struct tpm_chip for tpm_chip_find_get()"
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 95a031e9eced07..a20fed182cbcce 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -306,19 +306,6 @@ config HW_RANDOM_POWERNV
>  
>  	  If unsure, say Y.
>  
> -config HW_RANDOM_TPM
> -	tristate "TPM HW Random Number Generator support"
> -	depends on TCG_TPM
> -	default HW_RANDOM
> -	---help---
> -	  This driver provides kernel-side support for the Random Number
> -	  Generator in the Trusted Platform Module
> -
> -	  To compile this driver as a module, choose M here: the
> -	  module will be called tpm-rng.
> -
> -	  If unsure, say Y.
> -
>  config HW_RANDOM_HISI
>  	tristate "Hisilicon Random Number Generator support"
>  	depends on HW_RANDOM && ARCH_HISI
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index 39a67defac67cb..91cb8e8213e7c1 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -26,7 +26,6 @@ obj-$(CONFIG_HW_RANDOM_NOMADIK) += nomadik-rng.o
>  obj-$(CONFIG_HW_RANDOM_PSERIES) += pseries-rng.o
>  obj-$(CONFIG_HW_RANDOM_POWERNV) += powernv-rng.o
>  obj-$(CONFIG_HW_RANDOM_HISI)	+= hisi-rng.o
> -obj-$(CONFIG_HW_RANDOM_TPM) += tpm-rng.o
>  obj-$(CONFIG_HW_RANDOM_BCM2835) += bcm2835-rng.o
>  obj-$(CONFIG_HW_RANDOM_IPROC_RNG200) += iproc-rng200.o
>  obj-$(CONFIG_HW_RANDOM_MSM) += msm-rng.o
> diff --git a/drivers/char/hw_random/tpm-rng.c b/drivers/char/hw_random/tpm-rng.c
> deleted file mode 100644
> index c5e363825af008..00000000000000
> --- a/drivers/char/hw_random/tpm-rng.c
> +++ /dev/null
> @@ -1,50 +0,0 @@
> -/*
> - * Copyright (C) 2012 Kent Yoder IBM Corporation
> - *
> - * HWRNG interfaces to pull RNG data from a TPM
> - *
> - * This program is free software; you can redistribute it and/or modify
> - * it under the terms of the GNU General Public License version 2 as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it will be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
> - */
> -
> -#include <linux/module.h>
> -#include <linux/hw_random.h>
> -#include <linux/tpm.h>
> -
> -#define MODULE_NAME "tpm-rng"
> -
> -static int tpm_rng_read(struct hwrng *rng, void *data, size_t max, bool wait)
> -{
> -	return tpm_get_random(NULL, data, max);
> -}
> -
> -static struct hwrng tpm_rng = {
> -	.name = MODULE_NAME,
> -	.read = tpm_rng_read,
> -};
> -
> -static int __init rng_init(void)
> -{
> -	return hwrng_register(&tpm_rng);
> -}
> -module_init(rng_init);
> -
> -static void __exit rng_exit(void)
> -{
> -	hwrng_unregister(&tpm_rng);
> -}
> -module_exit(rng_exit);
> -
> -MODULE_LICENSE("GPL v2");
> -MODULE_AUTHOR("Kent Yoder <key@linux.vnet.ibm.com>");
> -MODULE_DESCRIPTION("RNG driver for TPM devices");
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index a30352202f1fdc..18c81cbe4704ca 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -26,6 +26,17 @@ menuconfig TCG_TPM
>  
>  if TCG_TPM
>  
> +config HW_RANDOM_TPM
> +	bool "TPM HW Random Number Generator support"
> +	depends on TCG_TPM && HW_RANDOM && !(TCG_TPM=y && HW_RANDOM=m)
> +	default y
> +	---help---
> +	  This setting exposes the TPM's Random Number Generator as a hwrng
> +	  device. This allows the kernel to collect randomness from the TPM at
> +	  boot, and provides the TPM randomines in /dev/hwrng.
> +
> +	  If unsure, say Y.
> +
>  config TCG_TIS_CORE
>  	tristate
>  	---help---
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 6faf4c3fa6dbbd..797ab962291333 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -26,6 +26,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/freezer.h>
>  #include <linux/major.h>
> +#include <linux/hw_random.h>
>  #include "tpm.h"
>  #include "tpm_eventlog.h"
>  
> @@ -391,6 +392,26 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
>  
>  	return 0;
>  }
> +
> +static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
> +{
> +	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
> +
> +	return tpm_get_random(chip, data, max);
> +}
> +
> +static int tpm_add_hwrng(struct tpm_chip *chip)
> +{
> +	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM))
> +		return 0;
> +
> +	snprintf(chip->hwrng_name, sizeof(chip->hwrng_name),
> +		 "tpm-rng-%d", chip->dev_num);
> +	chip->hwrng.name = chip->hwrng_name;
> +	chip->hwrng.read = tpm_hwrng_read;
> +	return hwrng_register(&chip->hwrng);
> +}
> +
>  /*
>   * tpm_chip_register() - create a character device for the TPM chip
>   * @chip: TPM chip to use.
> @@ -423,11 +444,13 @@ int tpm_chip_register(struct tpm_chip *chip)
>  
>  	tpm_add_ppi(chip);
>  
> +	rc = tpm_add_hwrng(chip);
> +	if (rc)
> +		goto out_ppi;
> +
>  	rc = tpm_add_char_device(chip);
> -	if (rc) {
> -		tpm_bios_log_teardown(chip);
> -		return rc;
> -	}
> +	if (rc)
> +		goto out_hwrng;
>  
>  	rc = tpm_add_legacy_sysfs(chip);
>  	if (rc) {
> @@ -436,6 +459,14 @@ int tpm_chip_register(struct tpm_chip *chip)
>  	}
>  
>  	return 0;
> +
> +out_hwrng:
> +	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM))
> +		hwrng_unregister(&chip->hwrng);
> +out_ppi:
> +	tpm_bios_log_teardown(chip);
> +
> +	return rc;
>  }
>  EXPORT_SYMBOL_GPL(tpm_chip_register);
>  
> @@ -455,6 +486,8 @@ EXPORT_SYMBOL_GPL(tpm_chip_register);
>  void tpm_chip_unregister(struct tpm_chip *chip)
>  {
>  	tpm_del_legacy_sysfs(chip);
> +	if (IS_ENABLED(CONFIG_HW_RANDOM_TPM))
> +		hwrng_unregister(&chip->hwrng);
>  	tpm_bios_log_teardown(chip);
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>  		cdev_device_del(&chip->cdevs, &chip->devs);
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 7424511241031a..efe8ad0d137f74 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -26,6 +26,7 @@
>  #include <linux/module.h>
>  #include <linux/delay.h>
>  #include <linux/fs.h>
> +#include <linux/hw_random.h>
>  #include <linux/mutex.h>
>  #include <linux/sched.h>
>  #include <linux/platform_device.h>
> @@ -210,6 +211,9 @@ struct tpm_chip {
>  	int dev_num;		/* /dev/tpm# */
>  	unsigned long is_open;	/* only one allowed */
>  
> +	char hwrng_name[64];
> +	struct hwrng hwrng;
> +
>  	struct mutex tpm_mutex;	/* tpm is processing */
>  
>  	unsigned long timeout_a; /* jiffies */
> -- 
> 2.7.4
> 

I asked to create a series for a reason. Now this doesn't apply because I
don't have an ancestor in my git history.

Please resend as series together with my patch. I can apply neither yet
because they have zero tested-by's.

/Jarkko
