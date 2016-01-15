From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: crypto: qat - remove to call get_sram_bar_id for qat_c3xxx
Date: Fri, 15 Jan 2016 10:28:51 -0800
Message-ID: <56993A63.5060304@intel.com>
References: <1452074194-115019-1-git-send-email-pingchao.yang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pingchao Yang <pingchao.yang@intel.com>,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:23997 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbcAOSch (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jan 2016 13:32:37 -0500
In-Reply-To: <1452074194-115019-1-git-send-email-pingchao.yang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/06/2016 01:56 AM, Pingchao Yang wrote:
> From: Pingchao Yang <pingchao.yang@intel.com>
> 
> Reported-by : Struk, Tadeusz <tadeusz.struk@intel.com>
> Signed-off-by: Yang Pingchao <pingchao.yang@intel.com>
> 
> ---
> drivers/crypto/qat/qat_common/qat_hal.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
> index 0d0b5ed..bcb39b0 100644
> --- a/drivers/crypto/qat/qat_common/qat_hal.c
> +++ b/drivers/crypto/qat/qat_common/qat_hal.c
> @@ -693,14 +693,12 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
>  	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
>  	struct adf_bar *misc_bar =
>  			&pci_info->pci_bars[hw_data->get_misc_bar_id(hw_data)];
> -	struct adf_bar *sram_bar =
> -			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
> +	struct adf_bar *sram_bar;
>  
>  	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
>  	if (!handle)
>  		return -ENOMEM;
>  
> -	handle->hal_sram_addr_v = sram_bar->virt_addr;
>  	handle->hal_cap_g_ctl_csr_addr_v =
>  		(void __iomem *)((uintptr_t)misc_bar->virt_addr +
>  				 ICP_QAT_CAP_OFFSET);
> @@ -714,6 +712,11 @@ int qat_hal_init(struct adf_accel_dev *accel_dev)
>  		(void __iomem *)((uintptr_t)handle->hal_cap_ae_xfer_csr_addr_v +
>  				 LOCAL_TO_XFER_REG_OFFSET);
>  	handle->pci_dev = pci_info->pci_dev;
> +	if (handle->pci_dev->device != ADF_C3XXX_PCI_DEVICE_ID) {
> +		sram_bar =
> +			&pci_info->pci_bars[hw_data->get_sram_bar_id(hw_data)];
> +		handle->hal_sram_addr_v = sram_bar->virt_addr;
> +	}
>  	handle->fw_auth = (handle->pci_dev->device ==
>  			   ADF_DH895XCC_PCI_DEVICE_ID) ? false : true;
>  	handle->hal_handle = kzalloc(sizeof(*handle->hal_handle), GFP_KERNEL);
> 
Herbert,
This fixes issue related to invalid BAR mapping on C3XXX device,
which leads to memory corruption and kernel oops.
Please include this fix into 4.5.
Thanks,

-- 
TS
