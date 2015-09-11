From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: qat - don't check for iommu
Date: Fri, 11 Sep 2015 12:26:00 -0700
Message-ID: <55F32AC8.1090502@intel.com>
References: <20150910183657.26171.65960.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, john.griffin@intel.com,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:25012 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbbIKT1p (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Sep 2015 15:27:45 -0400
In-Reply-To: <20150910183657.26171.65960.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/10/2015 11:36 AM, Tadeusz Struk wrote:
> From: John Griffin <john.griffin@intel.com>
> 
> In some cases we don't want iommu to be enabled but still we want enable VFs.
> 
> Signed-off-by: John Griffin <john.griffin@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  drivers/crypto/qat/qat_common/adf_sriov.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
> index 2f77a4a..fb5a53d 100644
> --- a/drivers/crypto/qat/qat_common/adf_sriov.c
> +++ b/drivers/crypto/qat/qat_common/adf_sriov.c
> @@ -245,9 +245,8 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
>  	}
>  
>  	if (!iommu_present(&pci_bus_type)) {
> -		dev_err(&pdev->dev,
> -			"IOMMU must be enabled for SR-IOV to work\n");
> -		return -EINVAL;
> +		dev_warn(&pdev->dev,
> +			"IOMMU should be enabled for SR-IOV to work correctly\n");
>  	}
>  
>  	if (accel_dev->pf.vf_info) {
> 
Again after checkpatch fixes.

---8<---
From: John Griffin <john.griffin@intel.com>

In some cases we don't want iommu to be enabled but still we want to enable VFs.

Signed-off-by: John Griffin <john.griffin@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 2f77a4a..1117a8b 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -244,11 +244,8 @@ int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 		return -EFAULT;
 	}
 
-	if (!iommu_present(&pci_bus_type)) {
-		dev_err(&pdev->dev,
-			"IOMMU must be enabled for SR-IOV to work\n");
-		return -EINVAL;
-	}
+	if (!iommu_present(&pci_bus_type))
+		dev_warn(&pdev->dev, "IOMMU should be enabled for SR-IOV to work correctly\n");
 
 	if (accel_dev->pf.vf_info) {
 		dev_info(&pdev->dev, "Already enabled for this device\n");
