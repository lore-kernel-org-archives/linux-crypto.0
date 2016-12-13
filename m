From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: [RFC PATCH 1/3] crypto: zip - Add ThunderX ZIP driver core
Date: Tue, 13 Dec 2016 14:39:00 +0100
Message-ID: <20161213133900.GA10647@Red>
References: <20161212150439.18627-1-jglauber@cavium.com>
 <20161212150439.18627-2-jglauber@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Mahipal Challa <Mahipal.Challa@cavium.com>,
        Vishnu Nair <Vishnu.Nair@cavium.com>
To: Jan Glauber <jglauber@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161212150439.18627-2-jglauber@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello

I have some comment below

On Mon, Dec 12, 2016 at 04:04:37PM +0100, Jan Glauber wrote:
> From: Mahipal Challa <Mahipal.Challa@cavium.com>
> 
[...]
> --- a/drivers/crypto/Makefile
> +++ b/drivers/crypto/Makefile
> @@ -27,6 +27,7 @@ obj-$(CONFIG_CRYPTO_DEV_MXC_SCC) += mxc-scc.o
>  obj-$(CONFIG_CRYPTO_DEV_TALITOS) += talitos.o
>  obj-$(CONFIG_CRYPTO_DEV_UX500) += ux500/
>  obj-$(CONFIG_CRYPTO_DEV_QAT) += qat/
> +obj-$(CONFIG_CRYPTO_DEV_CAVIUM_ZIP) += cavium/
>  obj-$(CONFIG_CRYPTO_DEV_QCE) += qce/
>  obj-$(CONFIG_CRYPTO_DEV_VMX) += vmx/
>  obj-$(CONFIG_CRYPTO_DEV_SUN4I_SS) += sunxi-ss/

Try to keep some alphabetical order

[...]
> +/* ZIP invocation result completion status codes */
> +#define ZIP_NOTDONE		0x0
> +
> +/* Successful completion. */
> +#define ZIP_SUCCESS		0x1
> +
> +/* Output truncated */
> +#define ZIP_DTRUNC		0x2
> +
> +/* Dynamic Stop */
> +#define ZIP_DYNAMIC_STOP	0x3
> +
> +/* Uncompress ran out of input data when IWORD0[EF] was set */
> +#define ZIP_ITRUNC		0x4
> +
> +/* Uncompress found the reserved block type 3 */
> +#define ZIP_RBLOCK		0x5
> +
> +/* Uncompress found LEN != ZIP_NLEN in an uncompressed block in the input */
> +#define ZIP_NLEN		0x6
> +
> +/* Uncompress found a bad code in the main Huffman codes. */
> +#define ZIP_BADCODE		0x7
> +
> +/* Uncompress found a bad code in the 19 Huffman codes encoding lengths. */
> +#define ZIP_BADCODE2	        0x8
> +
> +/* Compress found a zero-length input. */
> +#define ZIP_ZERO_LEN	        0x9
> +
> +/* The compress or decompress encountered an internal parity error. */
> +#define ZIP_PARITY		0xA

Perhaps all errors could begin with ZIP_ERR_xxx ?

[...]
> +static inline u64 zip_depth(void)
> +{
> +	struct zip_device *zip_dev = zip_get_device(zip_get_node_id());
> +
> +	if (!zip_dev)
> +		return -ENODEV;
> +
> +	return zip_dev->depth;
> +}

This function is not used.

> +
> +static inline u64 zip_onfsize(void)
> +{
> +	struct zip_device *zip_dev = zip_get_device(zip_get_node_id());
> +
> +	if (!zip_dev)
> +		return -ENODEV;
> +
> +	return zip_dev->onfsize;
> +}

Same for this

> +
> +static inline u64 zip_ctxsize(void)
> +{
> +	struct zip_device *zip_dev = zip_get_device(zip_get_node_id());
> +
> +	if (!zip_dev)
> +		return -ENODEV;
> +
> +	return zip_dev->ctxsize;
> +}

Again

[...]
> +
> +/*
> + * Allocates new ZIP device structure
> + * Returns zip_device pointer or NULL if cannot allocate memory for zip_device
> + */
> +static struct zip_device *zip_alloc_device(struct pci_dev *pdev)

pdev is not used, so you can remove it from arglist.
Or keep it and use devm_kzalloc for allocating zip

> +{
> +	struct zip_device *zip = NULL;
> +	int idx = 0;
> +
> +	for (idx = 0; idx < MAX_ZIP_DEVICES; idx++) {
> +		if (!zip_dev[idx])
> +			break;
> +	}
> +
> +	zip = kzalloc(sizeof(*zip), GFP_KERNEL);
> +
> +	if (!zip)
> +		return NULL;
> +
> +	zip_dev[idx] = zip;
> +	zip->index = idx;
> +	return zip;
> +}

[...]
> +static int zip_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct zip_device *zip = NULL;
> +	int    err;
> +
> +	zip_dbg_enter();
> +
> +	zip = zip_alloc_device(pdev);
> +
> +	if (!zip)
> +		return -ENOMEM;
> +
> +	pr_info("Found ZIP device %d %x:%x on Node %d\n", zip->index,
> +		pdev->vendor, pdev->device, dev_to_node(dev));

You use lots of pr_info, why not using more dev_info/dev_err ?

> +
> +	zip->pdev = pdev;
> +
> +	pci_set_drvdata(pdev, zip);
> +
> +	err = pci_enable_device(pdev);
> +	if (err) {
> +		zip_err("Failed to enable PCI device");
> +		goto err_free_device;
> +	}
> +
> +	err = pci_request_regions(pdev, DRV_NAME);
> +	if (err) {
> +		zip_err("PCI request regions failed 0x%x", err);
> +		goto err_disable_device;
> +	}
> +
> +	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(48));
> +	if (err) {
> +		dev_err(dev, "Unable to get usable DMA configuration\n");
> +		goto err_release_regions;
> +	}
> +
> +	err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(48));
> +	if (err) {
> +		dev_err(dev, "Unable to get 48-bit DMA for allocations\n");
> +		goto err_release_regions;
> +	}
> +
> +	/* MAP configuration registers */
> +	zip->reg_base = pci_ioremap_bar(pdev, PCI_CFG_ZIP_PF_BAR0);
> +	if (!zip->reg_base) {
> +		zip_err("ZIP: Cannot map BAR0 CSR memory space, aborting");
> +		err = -ENOMEM;
> +		goto err_release_regions;
> +	}
> +
> +	/* Initialize ZIP Hardware */
> +	err = zip_init_hw(zip);
> +	if (err)
> +		goto err_release_regions;
> +
> +	return 0;
> +
> +err_release_regions:
> +	if (zip->reg_base)
> +		iounmap(zip->reg_base);
> +	pci_release_regions(pdev);
> +
> +err_disable_device:
> +	pci_disable_device(pdev);
> +
> +err_free_device:
> +	pci_set_drvdata(pdev, NULL);
> +
> +	/* remove zip_dev from zip_device list, free the zip_device memory */
> +	zip_dev[zip->index] = NULL;
> +	kfree(zip);
> +
> +	zip_dbg_exit();
> +	return err;
> +}

[...]
> +static int __init zip_init_module(void)
> +{
> +	int ret;
> +
> +	memset(&zip_dev, 0, sizeof(zip_dev));

A static variable is already zeroed

> +
> +	zip_msg("%s\n", DRV_NAME);
> +
> +	ret = pci_register_driver(&zip_driver);
> +	if (ret < 0) {
> +		zip_err("ZIP: pci_register_driver() returned %d\n", ret);
> +		return ret;
> +	}
> +
> +	/* Register with the Kernel Crypto Interface */
> +	ret = zip_register_compression_device();
> +	if (ret < 0) {
> +		zip_err("ZIP: Kernel Crypto Registration failed\n");
> +		return 1;

1 is not a good error code. And you quit without unregistering.

> +	}
> +
> +	return ret;
> +}
> +
> +static void __exit zip_cleanup_module(void)
> +{
> +	/* Unregister this driver for pci zip devices */
> +	pci_unregister_driver(&zip_driver);
> +
> +	/* Unregister from the kernel crypto interface */
> +	zip_unregister_compression_device();

I think you must do the opposite. (unregister crypto first)

> +
> +	pr_info("ThunderX-ZIP driver is removed successfully\n");
> +}
> +
> +module_init(zip_init_module);
> +module_exit(zip_cleanup_module);

Why not using module_pci_driver ?

[...]
> +/**
> + * enum zip_comp_e - ZIP Completion Enumeration, enumerates the values of
> + * ZIP_ZRES_S[COMPCODE].
> + */
> +enum zip_comp_e {
> +	ZIP_COMP_E_BADCODE = 0x7,
> +	ZIP_COMP_E_BADCODE2 = 0x8,
> +	ZIP_COMP_E_DTRUNC = 0x2,
> +	ZIP_COMP_E_FATAL = 0xb,
> +	ZIP_COMP_E_ITRUNC = 0x4,
> +	ZIP_COMP_E_NLEN = 0x6,
> +	ZIP_COMP_E_NOTDONE = 0x0,
> +	ZIP_COMP_E_PARITY = 0xa,
> +	ZIP_COMP_E_RBLOCK = 0x5,
> +	ZIP_COMP_E_STOP = 0x3,
> +	ZIP_COMP_E_SUCCESS = 0x1,
> +	ZIP_COMP_E_ZERO_LEN = 0x9,
> +	ZIP_COMP_E_ENUM_LAST = 0xc,

Why not using already declared define ? ZIP_COMP_E_BADCODE = ZIP_BADCODE 

Regards
Corentin Labbe
