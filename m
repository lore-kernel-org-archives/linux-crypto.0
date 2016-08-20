From: Corentin LABBE <clabbe.montjoie@gmail.com>
Subject: Re: [PATCH 2/2] hwrng: thunderx: Add Cavium HWRNG driver for ThunderX
 SoC.
Date: Sat, 20 Aug 2016 07:41:31 +0200
Message-ID: <5650aa14-e163-13d8-2704-5f949c67cb26@gmail.com>
References: <1471645933-3643-1-git-send-email-okhaliq@caviumnetworks.com>
 <1471645933-3643-3-git-send-email-okhaliq@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Omer Khaliq <okhaliq@caviumnetworks.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@vger.kernel.org,
        bhelgaas@google.com, mpm@selenic.com, herbert@gondor.apana.org.au,
        Ananth.Jasty@cavium.com, david.daney@cavium.com
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <1471645933-3643-3-git-send-email-okhaliq@caviumnetworks.com>
Sender: linux-pci-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello

I have some minor comments below

On 20/08/2016 00:32, Omer Khaliq wrote:
> The Cavium ThunderX SoC has a hardware random number generator.
> This driver provides support using the HWRNG framework.
> 
> Signed-off-by: Omer Khaliq <okhaliq@caviumnetworks.com>
> Signed-off-by: Ananth Jasty <Ananth.Jasty@cavium.com>
> Acked-by: David Daney <david.daney@cavium.com>
> ---
>  drivers/char/hw_random/Kconfig         |  13 +++++
>  drivers/char/hw_random/Makefile        |   1 +
>  drivers/char/hw_random/cavium-rng-vf.c | 102 ++++++++++++++++++++++++++++++++
>  drivers/char/hw_random/cavium-rng.c    | 103 +++++++++++++++++++++++++++++++++
>  4 files changed, 219 insertions(+)
>  create mode 100644 drivers/char/hw_random/cavium-rng-vf.c
>  create mode 100644 drivers/char/hw_random/cavium-rng.c
> 
> diff --git a/drivers/char/hw_random/Kconfig b/drivers/char/hw_random/Kconfig
> index 56ad5a5..fb9c7ad 100644
> --- a/drivers/char/hw_random/Kconfig
> +++ b/drivers/char/hw_random/Kconfig
> @@ -410,6 +410,19 @@ config HW_RANDOM_MESON
>  
>  	  If unsure, say Y.
>  
> +config HW_RANDOM_CAVIUM
> +       tristate "Cavium ThunderX Random Number Generator support"
> +       depends on HW_RANDOM && PCI && (ARM64 || (COMPILE_TEST && 64BIT))
> +       default HW_RANDOM
> +       ---help---
> +         This driver provides kernel-side support for the Random Number
> +         Generator hardware found on Cavium SoCs.
> +
> +         To compile this driver as a module, choose M here: the
> +         module will be called cavium_rng.
> +
> +         If unsure, say Y.
> +
>  endif # HW_RANDOM
>  
>  config UML_RANDOM
> diff --git a/drivers/char/hw_random/Makefile b/drivers/char/hw_random/Makefile
> index 04bb0b0..5f52b1e 100644
> --- a/drivers/char/hw_random/Makefile
> +++ b/drivers/char/hw_random/Makefile
> @@ -35,3 +35,4 @@ obj-$(CONFIG_HW_RANDOM_XGENE) += xgene-rng.o
>  obj-$(CONFIG_HW_RANDOM_STM32) += stm32-rng.o
>  obj-$(CONFIG_HW_RANDOM_PIC32) += pic32-rng.o
>  obj-$(CONFIG_HW_RANDOM_MESON) += meson-rng.o
> +obj-$(CONFIG_HW_RANDOM_CAVIUM) += cavium-rng.o cavium-rng-vf.o
> diff --git a/drivers/char/hw_random/cavium-rng-vf.c b/drivers/char/hw_random/cavium-rng-vf.c
> new file mode 100644
> index 0000000..8e80bce
> --- /dev/null
> +++ b/drivers/char/hw_random/cavium-rng-vf.c
> @@ -0,0 +1,102 @@
> +/*
> + * Hardware Random Number Generator support for Cavium, Inc.
> + * Thunder processor family.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Copyright (C) 2016 Cavium, Inc.
> + */
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/device.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +#include <linux/pci_ids.h>
> +#include <linux/gfp.h>
> +#include <linux/pci.h>
> +#include <linux/init.h>

Please alphabetize headers, and check if there are necessary, clearly platform_device.h is unnecessary.

> +
> +struct cavium_rng {
> +	struct hwrng ops;
> +	void __iomem *result;
> +};
> +
> +/* Read data from the RNG unit */
> +static int cavium_rng_read(struct hwrng *rng, void *dat, size_t max, bool wait)
> +{
> +	struct cavium_rng *p = container_of(rng, struct cavium_rng, ops);
> +	unsigned int size = max;
> +
> +	while (size >= 8) {
> +		*((u64 *)dat) = readq(p->result);
> +		size -= 8;
> +		dat += 8;
> +	}
> +	while (size > 0) {
> +		*((u8 *)dat) = readb(p->result);
> +		size--;
> +		dat++;
> +	}
> +	return max;
> +}
> +
> +/* Map Cavium RNG to an HWRNG object */
> +static int cavium_rng_probe_vf(struct	pci_dev		*pdev,
> +			 const struct	pci_device_id	*id)
> +{
> +	struct	cavium_rng *rng;
> +	int	ret;
> +
> +	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
> +	if (!rng)
> +		return -ENOMEM;
> +
> +	/* Map the RNG result */
> +	rng->result = pcim_iomap(pdev, 0, 0);
> +	if (!rng->result) {
> +		dev_err(&pdev->dev, "Error iomap failed retrieving result.\n");
> +		return -ENOMEM;
> +	}
> +
> +	rng->ops.name    = "cavium rng";
> +	rng->ops.read    = cavium_rng_read;
> +	rng->ops.quality = 1000;
> +
> +	pci_set_drvdata(pdev, rng);
> +
> +	ret = hwrng_register(&rng->ops);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Error registering device as HWRNG.\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Remove the VF */
> +void  cavium_rng_remove_vf(struct pci_dev *pdev)
> +{
> +	struct cavium_rng *rng;
> +
> +	rng = pci_get_drvdata(pdev);
> +	hwrng_unregister(&rng->ops);
> +}
> +
> +static const struct pci_device_id cavium_rng_vf_id_table[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, 0xa033), 0, 0, 0},
> +	{0,},
> +};
> +MODULE_DEVICE_TABLE(pci, cavium_rng_vf_id_table);
> +
> +static struct pci_driver cavium_rng_vf_driver = {
> +	.name		= "cavium_rng_vf",
> +	.id_table	= cavium_rng_vf_id_table,
> +	.probe		= cavium_rng_probe_vf,
> +	.remove		= cavium_rng_remove_vf,
> +};
> +module_pci_driver(cavium_rng_vf_driver);
> +
> +MODULE_AUTHOR("Omer Khaliq");

You could add your email address.

> +MODULE_LICENSE("GPL");
> diff --git a/drivers/char/hw_random/cavium-rng.c b/drivers/char/hw_random/cavium-rng.c
> new file mode 100644
> index 0000000..7f09ee4
> --- /dev/null
> +++ b/drivers/char/hw_random/cavium-rng.c
> @@ -0,0 +1,103 @@
> +/*
> + * Hardware Random Number Generator support for Cavium Inc.
> + * Thunder processor family.
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + *
> + * Copyright (C) 2016 Cavium, Inc.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/device.h>
> +#include <linux/hw_random.h>
> +#include <linux/io.h>
> +#include <linux/pci_ids.h>
> +#include <linux/gfp.h>
> +#include <linux/pci.h>
> +#include <linux/init.h>
> +#include <linux/pci-ats.h>

Same comment for headers

> +
> +#define THUNDERX_RNM_ENT_EN     0x1
> +#define THUNDERX_RNM_RNG_EN     0x2
> +
> +struct cavium_rng_pf {
> +	void __iomem *control_status;
> +};
> +
> +

Do you have run checkpatch.pl ?
No more than one blank line.

> +/* Enable the RNG hardware and activate the VF */
> +static int cavium_rng_probe(struct pci_dev *pdev,
> +				 const struct pci_device_id *id)
> +{
> +	struct	cavium_rng_pf *rng;
> +	int	iov_err;
> +
> +

Same problem

> +	rng = devm_kzalloc(&pdev->dev, sizeof(*rng), GFP_KERNEL);
> +	if (!rng)
> +		return -ENOMEM;
> +
> +	/*Map the RNG control */
> +	rng->control_status = pcim_iomap(pdev, 0, 0);
> +	if (!rng->control_status) {
> +		dev_err(&pdev->dev,
> +			"Error iomap failed retrieving control_status.\n");
> +		return -ENOMEM;
> +	}
> +
> +	/* Enable the RNG hardware and entropy source */
> +	writeq(THUNDERX_RNM_RNG_EN | THUNDERX_RNM_ENT_EN,
> +		rng->control_status);
> +
> +	pci_set_drvdata(pdev, rng);
> +
> +	/* Fix for improper link id reported for cn88XX */
> +	if (pdev->subsystem_device == 0xa118)
> +		pci_sriov_fdl_override(pdev, pdev->devfn);
> +
> +	/* Enable the Cavium RNG as a VF */
> +	iov_err = pci_enable_sriov(pdev, 1);
> +	if (iov_err != 0) {
> +		dev_err(&pdev->dev,
> +			"Error initializing RNG virtual function,(%i).\n",
> +			iov_err);
> +		return iov_err;

You return without disabling the RNG

> +	}
> +
> +	return 0;
> +}
> +
> +/* Disable VF and RNG Hardware */
> +void  cavium_rng_remove(struct pci_dev *pdev)
> +{
> +	struct cavium_rng_pf *rng;
> +
> +	rng = pci_get_drvdata(pdev);
> +
> +	/* Remove the VF */
> +	pci_disable_sriov(pdev);
> +
> +	/* Disable the RNG hardware and entropy source */
> +	writeq(0, rng->control_status);
> +}
> +
> +static const struct pci_device_id cavium_rng_pf_id_table[] = {
> +	{ PCI_DEVICE(PCI_VENDOR_ID_CAVIUM, 0xa018), 0, 0, 0}, /* Thunder RNM */
> +	{0,},
> +};
> +
> +MODULE_DEVICE_TABLE(pci, cavium_rng_pf_id_table);
> +
> +static struct pci_driver cavium_rng_pf_driver = {
> +	.name		= "cavium_rng_pf",
> +	.id_table	= cavium_rng_pf_id_table,
> +	.probe		= cavium_rng_probe,
> +	.remove		= cavium_rng_remove,
> +};
> +
> +module_pci_driver(cavium_rng_pf_driver);
> +MODULE_AUTHOR("Omer Khaliq");
> +MODULE_LICENSE("GPL");
> 

Regards
