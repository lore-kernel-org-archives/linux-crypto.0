From: Alexander Gordeev <agordeev@redhat.com>
Subject: Re: [PATCH] crypto: qat - Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Date: Fri, 29 Aug 2014 10:10:55 +0100
Message-ID: <20140829091055.GA1035@agordeev.usersys.redhat.com>
References: <1408433524-11487-1-git-send-email-agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39442 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbaH2JCI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Aug 2014 05:02:08 -0400
Content-Disposition: inline
In-Reply-To: <1408433524-11487-1-git-send-email-agordeev@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 19, 2014 at 09:32:04AM +0200, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

Hello Gentleman,

This trivial patch blocks phasing out of deprecated
pci_enable_msix() function. Could someone review and
accept it, please?

Thanks!

> Cc: Tadeusz Struk <tadeusz.struk@intel.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: qat-linux@intel.com
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-pci@vger.kernel.org
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/crypto/qat/qat_dh895xcc/adf_isr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
> index d4172de..1082e3b 100644
> --- a/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
> +++ b/drivers/crypto/qat/qat_dh895xcc/adf_isr.c
> @@ -70,9 +70,9 @@ static int adf_enable_msix(struct adf_accel_dev *accel_dev)
>  	for (i = 0; i < msix_num_entries; i++)
>  		pci_dev_info->msix_entries.entries[i].entry = i;
>  
> -	if (pci_enable_msix(pci_dev_info->pci_dev,
> -			    pci_dev_info->msix_entries.entries,
> -			    msix_num_entries)) {
> +	if (pci_enable_msix_exact(pci_dev_info->pci_dev,
> +				  pci_dev_info->msix_entries.entries,
> +				  msix_num_entries)) {
>  		pr_err("QAT: Failed to enable MSIX IRQ\n");
>  		return -EFAULT;
>  	}
> -- 
> 1.9.3
> 

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
