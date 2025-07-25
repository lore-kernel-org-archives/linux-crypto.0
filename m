Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6D32E3718;
	Fri, 25 Jul 2025 03:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753414353; cv=none; b=KdBfVgyZPLmk65CKQPWq5wjTVZVrCSFgwEUg9/J7W8aaCCKqzYGogjkYfohgVEytNR0s1Npjh5x/cTxPqDNBMdxu59bp3USbGH2mYYCgtEJc2+wwH3jk0Ppwljld1RldnDyvsZX4/pAiLxgs2Up5n0trUTrk0tgGAPs0O4Ij7kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753414353; c=relaxed/simple;
	bh=6GOFpbgMacJO6biPlSBbSrI7lCJ7lnJXaXEhfpcspTU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i1sg0UYz3hcHr9pHBRWUZt2mDK/iafkD8/sCjUytXKCb4OCbmCInx/7clSFw79YkGgqWnHkCyFBdUXHvZxHcbF2KsrkLldZEc8kQZYd/DssKrTEa0Nzg4X3FvxZcz8nEaM26KxqwAR8eWG9vixc1r745gEbqaiaK6PLxkhqVqX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Iu3PKD2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Iu3PKD2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2BFC4CEE7;
	Fri, 25 Jul 2025 03:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753414351;
	bh=6GOFpbgMacJO6biPlSBbSrI7lCJ7lnJXaXEhfpcspTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Iu3PKD2UdPJYK1Qxs4wAwlONI8uCzx8PlXfyOiB+fry2WO5nTTh7vNArnVDikxhjs
	 tsbbMY6MJGHyHTZKCT7oRXG9qnJvOSLrHNxBAhBmuoPWNByr8a14M3ABkK5akJUzLc
	 Lk7BTJiJQmsUt+h7D/xLNHFNslz2LG7tOLjxPv7EfDgAbU+7A3EjhGSn1AstIe1SyV
	 MT5+ZcGXOmVAOlfDNe3tZaA22kfjk4xiQ8nqmC1XvqnxbIHHBFAvrLkG5GwfexIgSD
	 uw/Bj8MGxaXxR9Lkdx6WNcW/Uu5B4DzUezmO7cIoMiFEyzL5F8oORDnv3j4o7hcCNj
	 fRZyrEG6uyTtg==
Message-ID: <7be95f26-3443-4ef1-9761-a9e1551f2ec5@kernel.org>
Date: Thu, 24 Jul 2025 22:32:28 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] crypto: ccp - Add AMD Seamless Firmware Servicing
 (SFS) driver
To: Ashish Kalra <Ashish.Kalra@amd.com>, thomas.lendacky@amd.com,
 john.allen@amd.com, herbert@gondor.apana.org.au, davem@davemloft.net
Cc: seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1753389962.git.ashish.kalra@amd.com>
 <82acbf87e782c482ebd8d80092b5ad47d1f4b854.1753389962.git.ashish.kalra@amd.com>
Content-Language: en-US
From: Mario Limonciello <superm1@kernel.org>
Autocrypt: addr=superm1@gmail.com; keydata=
 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
In-Reply-To: <82acbf87e782c482ebd8d80092b5ad47d1f4b854.1753389962.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/24/25 4:16 PM, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> AMD Seamless Firmware Servicing (SFS) is a secure method to allow
> non-persistent updates to running firmware and settings without
> requiring BIOS reflash and/or system reset.
> 
> SFS does not address anything that runs on the x86 processors and
> it can be used to update ASP firmware, modules, register settings
> and update firmware for other microprocessors like TMPM, etc.
> 
> SFS driver support adds ioctl support to communicate the SFS
> commands to the ASP/PSP by using the TEE mailbox interface.
> 
> The Seamless Firmware Servicing (SFS) driver is added as a
> PSP sub-device.
> 
> For detailed information, please look at the SFS specifications:
> https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/specifications/58604.pdf
> 
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>   drivers/crypto/ccp/Makefile         |   3 +-
>   drivers/crypto/ccp/psp-dev.c        |  20 ++
>   drivers/crypto/ccp/psp-dev.h        |   8 +-
>   drivers/crypto/ccp/sfs.c            | 316 ++++++++++++++++++++++++++++
>   drivers/crypto/ccp/sfs.h            |  53 +++++
>   include/linux/psp-platform-access.h |   2 +
>   include/uapi/linux/psp-sfs.h        |  87 ++++++++
>   7 files changed, 487 insertions(+), 2 deletions(-)
>   create mode 100644 drivers/crypto/ccp/sfs.c
>   create mode 100644 drivers/crypto/ccp/sfs.h
>   create mode 100644 include/uapi/linux/psp-sfs.h
> 
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 394484929dae..9b876bfb1289 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -13,7 +13,8 @@ ccp-$(CONFIG_CRYPTO_DEV_SP_PSP) += psp-dev.o \
>                                      tee-dev.o \
>                                      platform-access.o \
>                                      dbc.o \
> -                                   hsti.o
> +                                   hsti.o \
> +				   sfs.o
>   
>   obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>   ccp-crypto-objs := ccp-crypto-main.o \
> diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
> index 1c5a7189631e..8c4ad225ad67 100644
> --- a/drivers/crypto/ccp/psp-dev.c
> +++ b/drivers/crypto/ccp/psp-dev.c
> @@ -17,6 +17,7 @@
>   #include "psp-dev.h"
>   #include "sev-dev.h"
>   #include "tee-dev.h"
> +#include "sfs.h"
>   #include "platform-access.h"
>   #include "dbc.h"
>   #include "hsti.h"
> @@ -182,6 +183,17 @@ static int psp_check_tee_support(struct psp_device *psp)
>   	return 0;
>   }
>   
> +static int psp_check_sfs_support(struct psp_device *psp)
> +{
> +	/* Check if device supports SFS feature */
> +	if (!psp->capability.sev) {

Should this be psp->capability.sfs?

> +		dev_dbg(psp->dev, "psp does not support SFS\n");
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
>   static int psp_init(struct psp_device *psp)
>   {
>   	int ret;
> @@ -198,6 +210,12 @@ static int psp_init(struct psp_device *psp)
>   			return ret;
>   	}
>   
> +	if (!psp_check_sfs_support(psp)) {
> +		ret = sfs_dev_init(psp);
> +		if (ret)
> +			return ret;
> +	}
> +
>   	if (psp->vdata->platform_access) {
>   		ret = platform_access_dev_init(psp);
>   		if (ret)
> @@ -302,6 +320,8 @@ void psp_dev_destroy(struct sp_device *sp)
>   
>   	tee_dev_destroy(psp);
>   
> +	sfs_dev_destroy(psp);
> +
>   	dbc_dev_destroy(psp);
>   
>   	platform_access_dev_destroy(psp);
> diff --git a/drivers/crypto/ccp/psp-dev.h b/drivers/crypto/ccp/psp-dev.h
> index e43ce87ede76..268c83f298cb 100644
> --- a/drivers/crypto/ccp/psp-dev.h
> +++ b/drivers/crypto/ccp/psp-dev.h
> @@ -32,7 +32,8 @@ union psp_cap_register {
>   		unsigned int sev			:1,
>   			     tee			:1,
>   			     dbc_thru_ext		:1,
> -			     rsvd1			:4,
> +			     sfs			:1,
> +			     rsvd1			:3,
>   			     security_reporting		:1,
>   			     fused_part			:1,
>   			     rsvd2			:1,
> @@ -68,6 +69,7 @@ struct psp_device {
>   	void *tee_data;
>   	void *platform_access_data;
>   	void *dbc_data;
> +	void *sfs_data;
>   
>   	union psp_cap_register capability;
>   };
> @@ -118,12 +120,16 @@ struct psp_ext_request {
>    * @PSP_SUB_CMD_DBC_SET_UID:		Set UID for DBC
>    * @PSP_SUB_CMD_DBC_GET_PARAMETER:	Get parameter from DBC
>    * @PSP_SUB_CMD_DBC_SET_PARAMETER:	Set parameter for DBC
> + * @PSP_SUB_CMD_SFS_GET_FW_VERS:	Get firmware versions for ASP and other MP
> + * @PSP_SUB_CMD_SFS_UPDATE:		Command to load, verify and execute SFS package
>    */
>   enum psp_sub_cmd {
>   	PSP_SUB_CMD_DBC_GET_NONCE	= PSP_DYNAMIC_BOOST_GET_NONCE,
>   	PSP_SUB_CMD_DBC_SET_UID		= PSP_DYNAMIC_BOOST_SET_UID,
>   	PSP_SUB_CMD_DBC_GET_PARAMETER	= PSP_DYNAMIC_BOOST_GET_PARAMETER,
>   	PSP_SUB_CMD_DBC_SET_PARAMETER	= PSP_DYNAMIC_BOOST_SET_PARAMETER,
> +	PSP_SUB_CMD_SFS_GET_FW_VERS	= PSP_SFS_GET_FW_VERSIONS,
> +	PSP_SUB_CMD_SFS_UPDATE		= PSP_SFS_UPDATE,
>   };
>   
>   int psp_extended_mailbox_cmd(struct psp_device *psp, unsigned int timeout_msecs,
> diff --git a/drivers/crypto/ccp/sfs.c b/drivers/crypto/ccp/sfs.c
> new file mode 100644
> index 000000000000..cbca01a884e1
> --- /dev/null
> +++ b/drivers/crypto/ccp/sfs.c
> @@ -0,0 +1,316 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * AMD Secure Processor Seamless Firmware Servicing support.
> + *
> + * Copyright (C) 2023-2025 Advanced Micro Devices, Inc.
> + *
> + * Author: Ashish Kalra <ashish.kalra@amd.com>
> + */
> +
> +#include <linux/firmware.h>
> +
> +#include "sfs.h"
> +#include "sev-dev.h"
> +
> +#define SFS_DEFAULT_TIMEOUT		(10 * MSEC_PER_SEC)
> +#define SFS_MAX_PAYLOAD_SIZE		(2 * 1024 * 1024)
> +#define ORDER_2MB 9
> +
> +/* SFS Status values */
> +#define SFS_SUCCESS			0x00
> +#define SFS_INVALID_TOTAL_SIZE		0x02
> +#define SFS_INVALID_PKG_SIZE		0x04
> +#define SFS_DISABLED			0x05
> +#define SFS_INVALID_CUST_SIGN		0x06
> +#define SFS_INVALID_AMD_SIGN		0x07
> +#define SFS_INTERNAL_ERROR		0x08
> +#define SFS_CUST_SIGN_NOT_ALLOWED	0x09
> +#define SFS_INVALID_BASE_PATCH_LVL	0x0A
> +#define SFS_INVALID_CURR_PATCH_LVL	0x0B
> +#define SFS_INVALID_NEW_PATCH_LVL	0x0C
> +#define SFS_INVALID_SUBCOMMAND		0x0D
> +#define SFS_PROTECTION_FAIL		0x0E
> +#define SFS_BUSY			0x0F
> +#define SFS_FW_VERSION_MISMATCH	0x10
> +#define SFS_SYS_VERSION_MISMATCH	0x11
> +#define SFS_SEV_STILL_INITIALIZED	0x12
> +
> +static bool sfs_initialized;
> +
> +static int send_sfs_cmd(struct psp_sfs_device *sfs_dev, int msg)
> +{
> +	int ret;
> +
> +	*sfs_dev->result = 0;
> +	sfs_dev->command_hdr->ext_req.header.sub_cmd_id = msg;
> +
> +	ret = psp_extended_mailbox_cmd(sfs_dev->psp,
> +					SFS_DEFAULT_TIMEOUT,
> +					(struct psp_ext_request *)sfs_dev->command_hdr);
> +	if (ret == -EIO) {
> +		dev_dbg(sfs_dev->dev,
> +			 "msg 0x%x failed with PSP error: 0x%x\n",
> +			 msg, *sfs_dev->result);
> +		dev_dbg(sfs_dev->dev,
> +			 "msg 0x%x extended status: 0x%x\n",
> +			 msg, *(u32 *)sfs_dev->payload);
> +	}
> +
> +	return ret;
> +}
> +
> +static int send_sfs_get_fw_versions(struct psp_sfs_device *sfs_dev)
> +{
> +	int ret;
> +
> +	sfs_dev->payload_size = &sfs_dev->command_hdr->ext_req.header.payload_size;
> +	sfs_dev->result = &sfs_dev->command_hdr->ext_req.header.status;
> +	sfs_dev->payload = &sfs_dev->command_hdr->ext_req.buf;
> +	sfs_dev->pkg_hdr = (void *)sfs_dev->command_hdr + PAGE_SIZE;
> +	sfs_dev->header_size = sizeof(struct psp_ext_req_buffer_hdr);
> +
> +	/*
> +	 * SFS_GET_FW_VERSIONS command needs the output buffer to be
> +	 * initialized to 0xC7 in every byte.
> +	 */
> +	memset(sfs_dev->pkg_hdr, 0xc7, PAGE_SIZE);
> +	*sfs_dev->payload_size = 2 * PAGE_SIZE;
> +
> +	ret = send_sfs_cmd(sfs_dev, PSP_SFS_GET_FW_VERSIONS);
> +
> +	return ret;
> +}
> +
> +static int send_sfs_update_package(struct psp_sfs_device *sfs_dev, char *payload_name)
> +{
> +	char payload_path[PAYLOAD_NAME_SIZE];
> +	const struct firmware *firmware;
> +	unsigned long package_size;
> +	int ret;
> +
> +	sprintf(payload_path, "amd/%s", payload_name);
> +
> +	ret = firmware_request_nowarn(&firmware, payload_path, sfs_dev->dev);
> +	if (ret < 0) {
> +		dev_warn(sfs_dev->dev, "firmware request fail %d\n", ret);
> +		return -ENOENT;
> +	}
> +
> +	/* SFS Update Package should be 64KB aligned */
> +	package_size = ALIGN(firmware->size + PAGE_SIZE, 0x10000U);
> +
> +	/*
> +	 * SFS command buffer is a pre-allocated 2MB buffer, fail update package
> +	 * if SFS payload is larger than the pre-allocated command buffer.
> +	 */
> +	if (package_size > SFS_MAX_PAYLOAD_SIZE) {
> +		dev_warn(sfs_dev->dev,
> +			 "SFS payload size %ld larger than maximum supported payload size of 2MB\n",
> +			 package_size);
> +		return -ENOMEM;
> +	}
> +
> +	sfs_dev->payload_size = &sfs_dev->command_hdr->ext_req.header.payload_size;
> +	sfs_dev->result = &sfs_dev->command_hdr->ext_req.header.status;
> +	sfs_dev->payload = &sfs_dev->command_hdr->ext_req.buf;
> +	sfs_dev->pkg_hdr = (void *)sfs_dev->command_hdr + PAGE_SIZE;
> +	sfs_dev->header_size = sizeof(struct psp_ext_req_buffer_hdr);
> +
> +	/*
> +	 * Copy firmware data to a kernel allocated contiguous
> +	 * memory region.
> +	 */
> +	memcpy(sfs_dev->pkg_hdr, firmware->data, firmware->size);
> +	*sfs_dev->payload_size = package_size;
> +
> +	ret = send_sfs_cmd(sfs_dev, PSP_SFS_UPDATE);
> +
> +	release_firmware(firmware);
> +	return ret;
> +}
> +
> +static long sfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> +{
> +	struct psp_device *psp_master = psp_get_master_device();
> +	void __user *argp = (void __user *)arg;
> +	char payload_name[PAYLOAD_NAME_SIZE];
> +	struct psp_sfs_device *sfs_dev;
> +	int ret;
> +
> +	if (!psp_master || !psp_master->sfs_data)
> +		return -ENODEV;
> +	sfs_dev = psp_master->sfs_data;
> +
> +	if (!sfs_initialized)
> +		return -EINVAL;
> +
> +	mutex_lock(&sfs_dev->ioctl_mutex);

As it's new code, how about using guard(mutex) instead?  Then you don't 
need to have goto unlock in the failure cases and can just return the 
error directly.

> +
> +	switch (cmd) {
> +	case SFSIOCFWVERS:
> +		dev_dbg(sfs_dev->dev, "in SFSIOCFWVERS\n");
> +
> +		ret = send_sfs_get_fw_versions(sfs_dev);
> +		if (ret && ret != -EIO)
> +			goto unlock;
> +		/*
> +		 * return SFS status and extended status back to userspace
> +		 * if PSP status indicated command error.
> +		 */
> +		if (copy_to_user(argp, sfs_dev->pkg_hdr, PAGE_SIZE))
> +			ret = -EFAULT;
> +		if (copy_to_user(argp + PAGE_SIZE, sfs_dev->result, sizeof(u32)))
> +			ret = -EFAULT;
> +		if (copy_to_user(argp + PAGE_SIZE + sizeof(u32), sfs_dev->payload, sizeof(u32)))
> +			ret = -EFAULT;
> +		break;
> +	case SFSIOCUPDATEPKG:
> +		dev_dbg(sfs_dev->dev, "in SFSIOCUPDATEPKG\n");
> +
> +		if (copy_from_user(payload_name, argp, PAYLOAD_NAME_SIZE)) {
> +			ret = -EFAULT;
> +			goto unlock;
> +		}
> +
> +		ret = send_sfs_update_package(sfs_dev, payload_name);
> +		if (ret && ret != -EIO)
> +			goto unlock;
> +		/*
> +		 * return SFS status and extended status back to userspace
> +		 * if PSP status indicated command error.
> +		 */
> +		if (copy_to_user(argp + PAYLOAD_NAME_SIZE, sfs_dev->result, sizeof(u32)))
> +			ret = -EFAULT;
> +		if (copy_to_user(argp + PAYLOAD_NAME_SIZE + sizeof(u32), sfs_dev->payload,
> +				 sizeof(u32)))
> +			ret = -EFAULT;
> +		break;
> +	default:
> +		ret = -EINVAL;
> +	}
> +
> +unlock:
> +	mutex_unlock(&sfs_dev->ioctl_mutex);
> +
> +	return ret;
> +}
> +
> +static const struct file_operations sfs_fops = {
> +	.owner	= THIS_MODULE,
> +	.unlocked_ioctl = sfs_ioctl,
> +};
> +
> +void sfs_dev_destroy(struct psp_device *psp)
> +{
> +	struct psp_sfs_device *sfs_dev = psp->sfs_data;
> +	int ret;
> +
> +	if (!sfs_dev)
> +		return;
> +
> +	/*
> +	 * TODO: free pre-allocated 2MB command buffer,
> +	 * if SEV-SNP is initialized the command buffer has
> +	 * been marked HV_Fixed and HV_Fixed pages remain
> +	 * in that state till system reset, they cannot be
> +	 * released back to the page allocator.
> +	 *
> +	 */
> +	snp_delete_hypervisor_fixed_pages_list(page_to_pfn(sfs_dev->page) << PAGE_SHIFT);
> +
> +	ret = set_memory_wb((unsigned long)page_address(sfs_dev->page), 512);
> +	if (ret)
> +		dev_dbg(sfs_dev->dev, "set memory wb failed\n");
> +
> +	sfs_initialized = false;
> +	misc_deregister(&sfs_dev->char_dev);
> +	mutex_destroy(&sfs_dev->ioctl_mutex);
> +	psp->sfs_data = NULL;
> +}
> +
> +int sfs_dev_init(struct psp_device *psp)
> +{
> +	struct device *dev = psp->dev;
> +	struct psp_sfs_device *sfs_dev;
> +	struct page *page;
> +	u64 cmd_buf_paddr;
> +	int ret;
> +
> +	/*
> +	 * SFS feature support can be detected on multiple devices but the SFS
> +	 * FW commands must be issued on the master. During probe, we do not
> +	 * know the master hence we create /dev/sfs on the first device probe.
> +	 */
> +	if (sfs_initialized)
> +		return 0;
> +
> +	sfs_dev = devm_kzalloc(dev, sizeof(*sfs_dev), GFP_KERNEL);
> +	if (!sfs_dev)
> +		return -ENOMEM;
> +
> +	BUILD_BUG_ON(sizeof(struct sfs_command) > PAGE_SIZE);
> +
> +	/*
> +	 * Pre-allocate static 2MB command buffer for all SFS commands.
> +	 */
> +	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, ORDER_2MB);
> +	if (!page)
> +		return -ENOMEM;
> +	sfs_dev->page = page;
> +	sfs_dev->command_hdr = page_address(page);
> +	cmd_buf_paddr = page_to_pfn(sfs_dev->page) << PAGE_SHIFT;
> +
> +	/*
> +	 * If SEV-SNP is enabled the SFS command buffer needs to
> +	 * transitioned to HV_Fixed page state.
> +	 */
> +	dev_dbg(sfs_dev->dev, "cmdbuf page pa 0x%llx to be marked as HV_Fixed\n",
> +		cmd_buf_paddr);
> +
> +	ret = snp_insert_hypervisor_fixed_pages_list(cmd_buf_paddr, 512);
> +	if (ret) {
> +		dev_dbg(sfs_dev->dev, "cmdbuf page failed insertion in HV-Fixed page list\n");
> +		goto cleanup_cmd_buf;
> +	}
> +
> +	/*
> +	 * Buffers used for communication with different processors, x86 to ASP
> +	 * in this case must be mapped as non-cacheable.
> +	 */
> +	ret = set_memory_uc((unsigned long)page_address(page), 512);
> +	if (ret) {
> +		dev_dbg(sfs_dev->dev, "set memory uc failed\n");
> +		goto cleanup_cmd_buf_after_hv_fixed;
> +	}
> +
> +	dev_dbg(sfs_dev->dev, "cmdbuf page va 0x%lx marked as UnCacheable\n",
> +		(unsigned long)sfs_dev->command_hdr);
> +
> +	psp->sfs_data = sfs_dev;
> +	sfs_dev->dev = dev;
> +	sfs_dev->psp = psp;
> +
> +	dev_dbg(sfs_dev->dev, "seamless firmware serviving support is available\n");

servicing

> +
> +	sfs_dev->char_dev.minor = MISC_DYNAMIC_MINOR;
> +	sfs_dev->char_dev.name = "sfs";
> +	sfs_dev->char_dev.fops = &sfs_fops;
> +	sfs_dev->char_dev.mode = 0600;
> +	ret = misc_register(&sfs_dev->char_dev);
> +	if (ret)
> +		goto cleanup_cmd_buf_after_hv_fixed;
> +
> +	mutex_init(&sfs_dev->ioctl_mutex);
> +	sfs_initialized = true;
> +
> +	return 0;
> +
> +cleanup_cmd_buf_after_hv_fixed:
> +	snp_delete_hypervisor_fixed_pages_list(cmd_buf_paddr);
> +cleanup_cmd_buf:
> +	__free_pages(page, ORDER_2MB);
> +	psp->sfs_data = NULL;
> +	devm_kfree(dev, sfs_dev);
> +
> +	return ret;
> +}
> diff --git a/drivers/crypto/ccp/sfs.h b/drivers/crypto/ccp/sfs.h
> new file mode 100644
> index 000000000000..89b7792af076
> --- /dev/null
> +++ b/drivers/crypto/ccp/sfs.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * AMD Platform Security Processor (PSP) Seamless Firmware (SFS) Support.
> + *
> + * Copyright (C) 2023-2025 Advanced Micro Devices, Inc.
> + *
> + * Author: Ashish Kalra <ashish.kalra@amd.com>
> + */
> +
> +#ifndef __SFS_H__
> +#define __SFS_H__
> +
> +#include <uapi/linux/psp-sfs.h>
> +
> +#include <linux/device.h>
> +#include <linux/miscdevice.h>
> +#include <linux/psp-sev.h>
> +#include <linux/psp-platform-access.h>
> +#include <linux/set_memory.h>
> +
> +#include <asm/sev.h>
> +
> +#include "psp-dev.h"
> +
> +struct psp_sfs_device {
> +	struct device *dev;
> +	struct psp_device *psp;
> +
> +	struct sfs_command *command_hdr;
> +
> +	struct mutex ioctl_mutex;
> +
> +	struct miscdevice char_dev;
> +
> +	struct page *page;
> +
> +	/* used to abstract communication path */
> +	u32	header_size;
> +	u32	*payload_size;
> +	u32	*result;
> +	void	*payload;
> +	void	*pkg_hdr;
> +};
> +
> +struct sfs_command {
> +	struct psp_ext_request ext_req;
> +};
> +
> +void sfs_dev_destroy(struct psp_device *psp);
> +int sfs_dev_init(struct psp_device *psp);
> +void sfs_pci_init(void);
> +
> +#endif /* __SFS_H__ */
> diff --git a/include/linux/psp-platform-access.h b/include/linux/psp-platform-access.h
> index 1504fb012c05..540abf7de048 100644
> --- a/include/linux/psp-platform-access.h
> +++ b/include/linux/psp-platform-access.h
> @@ -7,6 +7,8 @@
>   
>   enum psp_platform_access_msg {
>   	PSP_CMD_NONE			= 0x0,
> +	PSP_SFS_GET_FW_VERSIONS,
> +	PSP_SFS_UPDATE,
>   	PSP_CMD_HSTI_QUERY		= 0x14,
>   	PSP_I2C_REQ_BUS_CMD		= 0x64,
>   	PSP_DYNAMIC_BOOST_GET_NONCE,
> diff --git a/include/uapi/linux/psp-sfs.h b/include/uapi/linux/psp-sfs.h
> new file mode 100644
> index 000000000000..e752fa041683
> --- /dev/null
> +++ b/include/uapi/linux/psp-sfs.h
> @@ -0,0 +1,87 @@
> +/* SPDX-License-Identifier: GPL-2.0-only WITH Linux-syscall-note */
> +/*
> + * Userspace interface for AMD Seamless Firmware Servicing (SFS)
> + *
> + * Copyright (C) 2023-2025 Advanced Micro Devices, Inc.
> + *
> + * Author: Ashish Kalra <ashish.kalra@amd.com>
> + */
> +
> +#ifndef __PSP_SFS_USER_H__
> +#define __PSP_SFS_USER_H__
> +
> +#include <linux/types.h>
> +
> +/**
> + * SFS: AMD Seamless Firmware Support (SFS) interface
> + */
> +
> +#define PAYLOAD_NAME_SIZE		64
> +#define TEE_EXT_CMD_BUFFER_SIZE	4096
> +
> +/**
> + * struct sfs_user_get_fw_versions - get current level of base firmware (output).
> + * @blob:                  current level of base firmware for ASP and patch levels (input/output).
> + * @sfs_status:            32-bit SFS status value (output).
> + * @sfs_extended_status:   32-bit SFS extended status value (output).
> + */
> +struct sfs_user_get_fw_versions {
> +	__u8	blob[TEE_EXT_CMD_BUFFER_SIZE];
> +	__u32	sfs_status;
> +	__u32	sfs_extended_status;
> +} __packed;
> +
> +/**
> + * struct sfs_user_update_package - update SFS package (input).
> + * @payload_name:          name of SFS package to load, verify and execute (input).
> + * @sfs_status:            32-bit SFS status value (output).
> + * @sfs_extended_status:   32-bit SFS extended status value (output).
> + */
> +struct sfs_user_update_package {
> +	char	payload_name[PAYLOAD_NAME_SIZE];
> +	__u32	sfs_status;
> +	__u32	sfs_extended_status;
> +} __packed;
> +
> +/**
> + * Seamless Firmware Support (SFS) IOC
> + *
> + * possible return codes for all SFS IOCTLs:
> + *  0:          success
> + *  -EINVAL:    invalid input
> + *  -E2BIG:     excess data passed
> + *  -EFAULT:    failed to copy to/from userspace
> + *  -EBUSY:     mailbox in recovery or in use
> + *  -ENODEV:    driver not bound with PSP device
> + *  -EACCES:    request isn't authorized
> + *  -EINVAL:    invalid parameter
> + *  -ETIMEDOUT: request timed out
> + *  -EAGAIN:    invalid request for state machine
> + *  -ENOENT:    not implemented
> + *  -ENFILE:    overflow
> + *  -EPERM:     invalid signature
> + *  -EIO:       unknown error
> + */
> +#define SFS_IOC_TYPE	'S'
> +
> +/**
> + * SFSIOCFWVERS - returns blob containing FW versions
> + *                ASP provides the current level of Base Firmware for the ASP
> + *                and the other microprocessors as well as current patch
> + *                level(s).
> + */
> +#define SFSIOCFWVERS	_IOWR(SFS_IOC_TYPE, 0x1, struct sfs_user_get_fw_versions)
> +
> +/**
> + * SFSIOCUPDATEPKG - updates package/payload
> + *                   ASP loads, verifies and executes the SFS package.
> + *                   By default, the SFS package/payload is loaded from
> + *                   /lib/firmware/amd, but alternative firmware loading
> + *                   path can be specified using kernel parameter
> + *                   firmware_class.path or the firmware loading path
> + *                   can be customized using sysfs file:
> + *                   /sys/module/firmware_class/parameters/path.
> + */
> +#define SFSIOCUPDATEPKG	_IOWR(SFS_IOC_TYPE, 0x2, struct sfs_user_update_package)
> +
> +#endif /* __PSP_SFS_USER_H__ */

