From: George Cherian <gcherian@caviumnetworks.com>
Subject: Re: [PATCH v3 1/3] drivers: crypto: Add Support for Octeon-tx CPT
 Engine
Date: Fri, 6 Jan 2017 11:49:39 +0530
Message-ID: <586F36FB.8020108@caviumnetworks.com>
References: <1482321373-407-1-git-send-email-george.cherian@cavium.com>
 <1482321373-407-2-git-send-email-george.cherian@cavium.com>
 <20161221132347.GA21051@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        <david.daney@cavium.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>,
        <george.cherian@cavium.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0078.outbound.protection.outlook.com ([104.47.37.78]:18337
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751622AbdAFGT5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Jan 2017 01:19:57 -0500
In-Reply-To: <20161221132347.GA21051@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Corentin,

Thank you very much for the review.
I was on vacation and now am back, I will fix your comments and send a 
new version.


On 12/21/2016 06:53 PM, Corentin Labbe wrote:
> Hello
>
> I have some comment inline
>
> On Wed, Dec 21, 2016 at 11:56:11AM +0000, george.cherian@cavium.com wrote:
>> From: George Cherian <george.cherian@cavium.com>
>>
>> Enable the Physical Function diver for the Cavium Crypto Engine (CPT)
>
> typo driver
okay
>
>> found in Octeon-tx series of SoC's. CPT is the Cryptographic Acceleration
>> Unit. CPT includes microcoded GigaCypher symmetric engines (SEs) and
>> asymmetric engines (AEs).
>>
>> Signed-off-by: George Cherian <george.cherian@cavium.com>
>> Reviewed-by: David Daney <david.daney@cavium.com>
>> ---
>>   drivers/crypto/cavium/cpt/Kconfig        |  16 +
>>   drivers/crypto/cavium/cpt/Makefile       |   2 +
>>   drivers/crypto/cavium/cpt/cpt_common.h   | 158 +++++++
>>   drivers/crypto/cavium/cpt/cpt_hw_types.h | 658 +++++++++++++++++++++++++++++
>>   drivers/crypto/cavium/cpt/cptpf.h        |  69 +++
>>   drivers/crypto/cavium/cpt/cptpf_main.c   | 703 +++++++++++++++++++++++++++++++
>>   drivers/crypto/cavium/cpt/cptpf_mbox.c   | 163 +++++++
>>   7 files changed, 1769 insertions(+)
>>   create mode 100644 drivers/crypto/cavium/cpt/Kconfig
>>   create mode 100644 drivers/crypto/cavium/cpt/Makefile
>>   create mode 100644 drivers/crypto/cavium/cpt/cpt_common.h
>>   create mode 100644 drivers/crypto/cavium/cpt/cpt_hw_types.h
>>   create mode 100644 drivers/crypto/cavium/cpt/cptpf.h
>>   create mode 100644 drivers/crypto/cavium/cpt/cptpf_main.c
>>   create mode 100644 drivers/crypto/cavium/cpt/cptpf_mbox.c
>>
>> diff --git a/drivers/crypto/cavium/cpt/Kconfig b/drivers/crypto/cavium/cpt/Kconfig
>> new file mode 100644
>> index 0000000..247f1cb
>> --- /dev/null
>> +++ b/drivers/crypto/cavium/cpt/Kconfig
>> @@ -0,0 +1,16 @@
>> +#
>> +# Cavium crypto device configuration
>> +#
>> +
>> +config CRYPTO_DEV_CPT
>> +	tristate
>> +
>> +config CAVIUM_CPT
>> +	tristate "Cavium Cryptographic Accelerator driver"
>> +	depends on ARCH_THUNDER
>> +	select CRYPTO_DEV_CPT
>
> Could you add some COMPILE_TEST ?

You meant depends on ARCH_THUNDER || COMPILE_TEST?
>
> [...]
>> +struct microcode {
>> +	u8 is_mc_valid;
>> +	u8 is_ae;
>> +	u8 group;
>> +	u8 num_cores;
>> +	u32 code_size;
>> +	u64 core_mask;
>> +	u8 version[32];
>
> I see this "32" in some other place, perhaps you could use a define
okay
>
> [...]
>> +#include <linux/version.h>
>> +#include <linux/module.h>
>> +#include <linux/moduleparam.h>
>> +#include <linux/printk.h>
>> +#include <linux/device.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/firmware.h>
>> +#include <linux/pci.h>
>
> Header need to be sorted
will do
>
> [...]
>> +static void cpt_disable_cores(struct cpt_device *cpt, u64 coremask,
>> +			      u8 type, u8 grp)
>> +{
>> +	u64 pf_exe_ctl;
>> +	u32 timeout = 0xFFFFFFFF;
>> +	u64 grpmask = 0;
>> +	struct device *dev = &cpt->pdev->dev;
>> +
>> +	if (type == AE_TYPES)
>> +		coremask = (coremask << cpt->max_se_cores);
>> +
>> +	/* Disengage the cores from groups */
>> +	grpmask = cpt_read_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp));
>> +	cpt_write_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp),
>> +			(grpmask & ~coremask));
>> +	udelay(CSR_DELAY);
>> +	grp = cpt_read_csr64(cpt->reg_base, CPTX_PF_EXEC_BUSY(0));
>> +	while (grp & coremask) {
>> +		dev_err(dev, "Cores still busy %llx", coremask);
>> +		grp = cpt_read_csr64(cpt->reg_base,
>> +				     CPTX_PF_EXEC_BUSY(0));
>> +		if (timeout--)
>> +			break;
>
> The timeout seems enormous and you will flooding syslog with dev_err()
will reduce.
>
>> +	}
>> +
>> +	/* Disable the cores */
>> +	pf_exe_ctl = cpt_read_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0));
>> +	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0),
>> +			(pf_exe_ctl & ~coremask));
>> +	udelay(CSR_DELAY);
>> +}
>> +
>> +/*
>> + * Enable cores specified by coremask
>> + */
>> +static void cpt_enable_cores(struct cpt_device *cpt, u64 coremask,
>> +			     u8 type)
>> +{
>> +	u64 pf_exe_ctl;
>> +
>> +	if (type == AE_TYPES)
>> +		coremask = (coremask << cpt->max_se_cores);
>> +
>> +	pf_exe_ctl = cpt_read_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0));
>> +	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0),
>> +			(pf_exe_ctl | coremask));
>> +	udelay(CSR_DELAY);
>> +}
>> +
>> +static void cpt_configure_group(struct cpt_device *cpt, u8 grp,
>> +				u64 coremask, u8 type)
>> +{
>> +	u64 pf_gx_en = 0;
>> +
>> +	if (type == AE_TYPES)
>> +		coremask = (coremask << cpt->max_se_cores);
>> +
>> +	pf_gx_en = cpt_read_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp));
>> +	cpt_write_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp),
>> +			(pf_gx_en | coremask));
>> +	udelay(CSR_DELAY);
>> +}
>> +
>> +static void cpt_disable_mbox_interrupts(struct cpt_device *cpt)
>> +{
>> +	/* Clear mbox(0) interupts for all vfs */
>> +	cpt_write_csr64(cpt->reg_base, CPTX_PF_MBOX_ENA_W1CX(0, 0), ~0ull);
>> +}
>> +
>> +static void cpt_disable_ecc_interrupts(struct cpt_device *cpt)
>> +{
>> +	/* Clear ecc(0) interupts for all vfs */
>> +	cpt_write_csr64(cpt->reg_base, CPTX_PF_ECC0_ENA_W1C(0), ~0ull);
>> +}
>> +
>> +static void cpt_disable_exec_interrupts(struct cpt_device *cpt)
>> +{
>> +	/* Clear exec interupts for all vfs */
>> +	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXEC_ENA_W1C(0), ~0ull);
>> +}
>> +
>> +static void cpt_disable_all_interrupts(struct cpt_device *cpt)
>> +{
>> +	cpt_disable_mbox_interrupts(cpt);
>> +	cpt_disable_ecc_interrupts(cpt);
>> +	cpt_disable_exec_interrupts(cpt);
>> +}
>> +
>> +static void cpt_enable_mbox_interrupts(struct cpt_device *cpt)
>> +{
>> +	/* Set mbox(0) interupts for all vfs */
>> +	cpt_write_csr64(cpt->reg_base, CPTX_PF_MBOX_ENA_W1SX(0, 0), ~0ull);
>> +}
>> +
>> +static int cpt_load_microcode(struct cpt_device *cpt, struct microcode *mcode)
>> +{
>> +	int ret = 0, core = 0, shift = 0;
>> +	u32 total_cores = 0;
>> +	struct device *dev = &cpt->pdev->dev;
>> +
>> +	if (!mcode || !mcode->code) {
>> +		dev_err(dev, "Either the mcode is null or data is NULL\n");
>> +		return 1;
>
> This is not a standard error code
>
Yes will return standard error codes.
>> +	}
>> +
>> +	if (mcode->code_size == 0) {
>> +		dev_err(dev, "microcode size is 0\n");
>> +		return 1;
>
> the same
>
>> +	}
>> +
>> +	/* Assumes 0-9 are SE cores for UCODE_BASE registers and
>> +	 * AE core bases follow
>> +	 */
>> +	if (mcode->is_ae) {
>> +		core = CPT_MAX_SE_CORES; /* start couting from 10 */
>> +		total_cores = CPT_MAX_TOTAL_CORES; /* upto 15 */
>> +	} else {
>> +		core = 0; /* start couting from 0 */
>> +		total_cores = CPT_MAX_SE_CORES; /* upto 9 */
>> +	}
>> +
>> +	/* Point to microcode for each core of the group */
>> +	for (; core < total_cores ; core++, shift++) {
>> +		if (mcode->core_mask & (1 << shift)) {
>> +			cpt_write_csr64(cpt->reg_base,
>> +					CPTX_PF_ENGX_UCODE_BASE(0, core),
>> +					(u64)mcode->phys_base);
>> +		}
>> +	}
>> +	return ret;
>> +}
>> +
>> +static int do_cpt_init(struct cpt_device *cpt, struct microcode *mcode)
>> +{
>> +	int ret = 0;
>> +	struct device *dev = &cpt->pdev->dev;
>> +
>> +	/* Make device not ready */
>> +	cpt->flags &= ~CPT_FLAG_DEVICE_READY;
>> +	/* Disable All PF interrupts */
>> +	cpt_disable_all_interrupts(cpt);
>> +	/* Calculate mcode group and coremasks */
>> +	if (mcode->is_ae) {
>> +		if (mcode->num_cores > cpt->max_ae_cores) {
>> +			dev_err(dev, "Requested for more cores than available AE cores\n");
>> +			ret = -1;
>
> This is not a standard error code
>
>> +			goto cpt_init_fail;
>> +		}
>> +
>> +		if (cpt->next_group >= CPT_MAX_CORE_GROUPS) {
>> +			dev_err(dev, "Can't load, all eight microcode groups in use");
>> +			return -ENFILE;
>> +		}
>> +
>> +		mcode->group = cpt->next_group;
>> +		/* Convert requested cores to mask */
>> +		mcode->core_mask = GENMASK(mcode->num_cores, 0);
>> +		cpt_disable_cores(cpt, mcode->core_mask, AE_TYPES,
>> +				  mcode->group);
>> +		/* Load microcode for AE engines */
>> +		if (cpt_load_microcode(cpt, mcode)) {
>> +			dev_err(dev, "Microcode load Failed for %s\n",
>> +				mcode->version);
>> +			ret = -1;
>
> again and you loose the error code given by cpt_load_microcode
okay
>
>> +			goto cpt_init_fail;
>> +		}
>> +		cpt->next_group++;
>> +		/* Configure group mask for the mcode */
>> +		cpt_configure_group(cpt, mcode->group, mcode->core_mask,
>> +				    AE_TYPES);
>> +		/* Enable AE cores for the group mask */
>> +		cpt_enable_cores(cpt, mcode->core_mask, AE_TYPES);
>> +	} else {
>> +		if (mcode->num_cores > cpt->max_se_cores) {
>> +			dev_err(dev, "Requested for more cores than available SE cores\n");
>> +			ret = -1;
>
> Again
>
>> +			goto cpt_init_fail;
>> +		}
>> +		if (cpt->next_group >= CPT_MAX_CORE_GROUPS) {
>> +			dev_err(dev, "Can't load, all eight microcode groups in use");
>> +			return -ENFILE;
>> +		}
>> +
>> +		mcode->group = cpt->next_group;
>> +		/* Covert requested cores to mask */
>> +		mcode->core_mask = GENMASK(mcode->num_cores, 0);
>> +		cpt_disable_cores(cpt, mcode->core_mask, SE_TYPES,
>> +				  mcode->group);
>> +		/* Load microcode for SE engines */
>> +		if (cpt_load_microcode(cpt, mcode)) {
>> +			dev_err(dev, "Microcode load Failed for %s\n",
>> +				mcode->version);
>> +			ret = -1;
>
> Again
>
>> +			goto cpt_init_fail;
>> +		}
>> +		cpt->next_group++;
>> +		/* Configure group mask for the mcode */
>> +		cpt_configure_group(cpt, mcode->group, mcode->core_mask,
>> +				    SE_TYPES);
>> +		/* Enable SE cores for the group mask */
>> +		cpt_enable_cores(cpt, mcode->core_mask, SE_TYPES);
>> +	}
>> +
>> +	/* Enabled PF mailbox interrupts */
>> +	cpt_enable_mbox_interrupts(cpt);
>> +	cpt->flags |= CPT_FLAG_DEVICE_READY;
>> +
>> +	return ret;
>> +
>> +cpt_init_fail:
>> +	/* Enabled PF mailbox interrupts */
>> +	cpt_enable_mbox_interrupts(cpt);
>> +
>> +	return ret;
>> +}
>> +
>> +struct ucode_header {
>> +	u8 version[32];
>> +	u32 code_length;
>> +	u32 data_length;
>> +	u64 sram_address;
>> +};
>> +
>> +static int cpt_ucode_load_fw(struct cpt_device *cpt, const u8 *fw, bool is_ae)
>> +{
>> +	const struct firmware *fw_entry;
>> +	struct device *dev = &cpt->pdev->dev;
>> +	struct ucode_header *ucode;
>> +	struct microcode *mcode;
>> +	int j, ret = 0;
>> +
>> +	ret = request_firmware(&fw_entry, fw, dev);
>> +	if (ret)
>> +		return ret;
>
> I think you could also check for a minimal firmware size

Yes will add the check.
>
> [...]
>> +static void cpt_disable_all_cores(struct cpt_device *cpt)
>> +{
>> +	u32 grp, timeout = 0xFFFFFFFF;
>> +	struct device *dev = &cpt->pdev->dev;
>> +
>> +	/* Disengage the cores from groups */
>> +	for (grp = 0; grp < CPT_MAX_CORE_GROUPS; grp++) {
>> +		cpt_write_csr64(cpt->reg_base, CPTX_PF_GX_EN(0, grp), 0);
>> +		udelay(CSR_DELAY);
>> +	}
>> +
>> +	grp = cpt_read_csr64(cpt->reg_base, CPTX_PF_EXEC_BUSY(0));
>> +	while (grp) {
>> +		dev_err(dev, "Cores still busy");
>> +		grp = cpt_read_csr64(cpt->reg_base,
>> +				     CPTX_PF_EXEC_BUSY(0));
>> +		if (timeout--)
>> +			break;
>> +	}
>
> Same problem than cpt_disable_cores
Will adjust the timeout.
>
>> +	/* Disable the cores */
>> +	cpt_write_csr64(cpt->reg_base, CPTX_PF_EXE_CTL(0), 0);
>> +}
>> +
>> +/**
>> + * Ensure all cores are disenganed from all groups by
>
> typo engaged
>
>> + * calling cpt_disable_all_cores() before calling this
>> + * function.
>> + */
>> +static void cpt_unload_microcode(struct cpt_device *cpt)
>> +{
>> +	u32 grp = 0, core;
>> +
>> +	/* Free microcode bases and reset group masks */
>> +	for (grp = 0; grp < CPT_MAX_CORE_GROUPS; grp++) {
>> +		struct microcode *mcode = &cpt->mcode[grp];
>> +
>> +		if (cpt->mcode[grp].code)
>> +			dma_free_coherent(&cpt->pdev->dev, mcode->code_size,
>> +					  mcode->code, mcode->phys_base);
>> +		mcode->code = NULL;
>> +		//mcode->base = NULL;
>
> This is not a standard comment
Will get this removed.
>
>> +	}
>> +	/* Clear UCODE_BASE registers for all engines */
>> +	for (core = 0; core < CPT_MAX_TOTAL_CORES; core++)
>> +		cpt_write_csr64(cpt->reg_base,
>> +				CPTX_PF_ENGX_UCODE_BASE(0, core), 0ull);
>> +}
>> +
>> +static int cpt_device_init(struct cpt_device *cpt)
>> +{
>> +	u64 bist;
>> +	struct device *dev = &cpt->pdev->dev;
>> +
>> +	/* Reset the PF when probed first */
>> +	cpt_reset(cpt);
>> +	mdelay((100));
>
> double parenthesis
okay
>
>> +
>> +	/*Check BIST status*/
>> +	bist = (u64)cpt_check_bist_status(cpt);
>> +	if (bist) {
>> +		dev_err(dev, "RAM BIST failed with code 0x%llx", bist);
>> +		return -ENODEV;
>> +	}
>> +
>> +	bist = cpt_check_exe_bist_status(cpt);
>> +	if (bist) {
>> +		dev_err(dev, "Engine BIST failed with code 0x%llx", bist);
>> +		return -ENODEV;
>> +	}
>> +
>> +	/*Get CLK frequency*/
>> +	/*Get max enabled cores */
>> +	cpt_find_max_enabled_cores(cpt);
>> +	/*Disable all cores*/
>> +	cpt_disable_all_cores(cpt);
>> +	/*Reset device parameters*/
>> +	cpt->next_mc_idx   = 0;
>> +	cpt->next_group = 0;
>> +	/* PF is ready */
>> +	cpt->flags |= CPT_FLAG_DEVICE_READY;
>> +
>> +	return 0;
>> +}
>> +
>> +static int cpt_register_interrupts(struct cpt_device *cpt)
>> +{
>> +	int ret;
>> +	struct device *dev = &cpt->pdev->dev;
>> +
>> +	/* Enable MSI-X */
>> +	ret = cpt_enable_msix(cpt);
>> +	if (ret)
>> +		return ret;
>> +
>> +	/* Register mailbox interrupt handlers */
>> +	ret = request_irq(cpt->msix_entries[CPT_PF_INT_VEC_E_MBOXX(0)].vector,
>> +			  cpt_mbx0_intr_handler, 0, "CPT Mbox0", cpt);
>> +	if (ret)
>> +		goto fail;
>> +
>> +	cpt->irq_allocated[CPT_PF_INT_VEC_E_MBOXX(0)] = true;
>> +
>> +	/* Enable mailbox interrupt */
>> +	cpt_enable_mbox_interrupts(cpt);
>> +	return 0;
>> +
>> +fail:
>> +	dev_err(dev, "Request irq failed\n");
>> +	cpt_free_all_interrupts(cpt);
>> +	return ret;
>> +}
>> +
>> +static void cpt_unregister_interrupts(struct cpt_device *cpt)
>> +{
>> +	cpt_free_all_interrupts(cpt);
>> +	cpt_disable_msix(cpt);
>> +}
>> +
>> +static int cpt_sriov_init(struct cpt_device *cpt, int num_vfs)
>> +{
>> +	int pos = 0;
>> +	int err;
>> +	u16 total_vf_cnt;
>> +	struct pci_dev *pdev = cpt->pdev;
>> +
>> +	pos = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_SRIOV);
>> +	if (!pos) {
>> +		dev_err(&pdev->dev, "SRIOV capability is not found in PCIe config space\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	cpt->num_vf_en = num_vfs; /* User requested VFs */
>> +	pci_read_config_word(pdev, (pos + PCI_SRIOV_TOTAL_VF), &total_vf_cnt);
>> +	if (total_vf_cnt < cpt->num_vf_en)
>> +		cpt->num_vf_en = total_vf_cnt;
>> +
>> +	if (!total_vf_cnt)
>> +		return 0;
>> +
>> +	/*Enabled the available VFs */
>> +	err = pci_enable_sriov(pdev, cpt->num_vf_en);
>> +	if (err) {
>> +		dev_err(&pdev->dev, "SRIOV enable failed, num VF is %d\n",
>> +			cpt->num_vf_en);
>> +		cpt->num_vf_en = 0;
>> +		return err;
>> +	}
>> +
>> +	/* TODO: Optionally enable static VQ priorities feature */
>> +
>> +	dev_info(&pdev->dev, "SRIOV enabled, number of VF available %d\n",
>> +		 cpt->num_vf_en);
>> +
>> +	cpt->flags |= CPT_FLAG_SRIOV_ENABLED;
>> +
>> +	return 0;
>> +}
>> +
>> +static int cpt_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	struct cpt_device *cpt;
>> +	int err;
>> +
>> +	if (num_vfs > 16) {
>> +		pr_warn("Invalid vf count %d, Resetting it to 4(default)\n",
>> +			num_vfs);
>
> Why not using dev_warn ?
>
>> +		num_vfs = 4;
>> +	}
>> +
>> +	cpt = devm_kzalloc(dev, sizeof(struct cpt_device), GFP_KERNEL);
>
> Use sizeof(*cpt) like checkpatch will said.
>
> [...]
>> +static void cpt_shutdown(struct pci_dev *pdev)
>> +{
>> +	struct cpt_device *cpt = pci_get_drvdata(pdev);
>> +
>> +	if (!cpt)
>> +		return;
>> +
>> +	dev_info(&pdev->dev, "Shutdown device %x:%x.\n",
>> +		 (u32)pdev->vendor, (u32)pdev->device);
>> +
>> +	cpt_unregister_interrupts(cpt);
>> +	pci_release_regions(pdev);
>> +	pci_disable_device(pdev);
>> +	pci_set_drvdata(pdev, NULL);
>> +	kzfree(cpt);
>
> since cpt is allocated with devm_, this kzfree is unnecessary
Noted!!
>
> Thanks
> Regards
> Corentin Labbe
>
