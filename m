Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D071C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 17:19:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB44A64E37
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 17:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhCRRSf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 13:18:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:58225 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229810AbhCRRSS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 13:18:18 -0400
IronPort-SDR: UvTxcHt4Vsdk1hdjXa0diSh3nWG3qT/3dOutm04MFqKI4YLcBPCeEv+PR7iE6j8lsjf2gpsUcp
 p0V1Law5DbRg==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="177324702"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="177324702"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 10:18:17 -0700
IronPort-SDR: Y5pBJNPKrRhFMTmbtbvLo2dX46i+dZJzhWk3kQVXCWiRbCGhDqhOUaMGIozoh3xj03y4V7uGax
 pcaEfzf5hmNw==
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="389323632"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 10:17:57 -0700
Date:   Thu, 18 Mar 2021 17:17:50 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Fiona Trahe <fiona.trahe@intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH v4 2/2] crypto: qat: ADF_STATUS_PF_RUNNING should be set
 after adf_dev_init
Message-ID: <YFOLPn31KF7bW6T/@silpixa00400314>
References: <YFN6hlz/L7erLO0H@silpixa00400314>
 <20210318162105.378239-3-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210318162105.378239-3-ztong0001@gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Just a minor comment on the commit message:
crypto: qat: ADF_STATUS_PF_RUNNING ...
           ^
Patches to the qat driver have the following headline:
        crypto: qat -
not
        crypto: qat :

Regards,

-- 
Giovanni

On Thu, Mar 18, 2021 at 12:21:05PM -0400, Tong Zhang wrote:
> ADF_STATUS_PF_RUNNING is (only) used and checked by adf_vf2pf_shutdown()
> before calling adf_iov_putmsg()->mutex_lock(vf2pf_lock), however the
> vf2pf_lock is initialized in adf_dev_init(), which can fail and when it
> fail, the vf2pf_lock is either not initialized or destroyed, a subsequent
> use of vf2pf_lock will cause issue.
> To fix this issue, only set this flag if adf_dev_init() returns 0.
> 
> [    7.178404] BUG: KASAN: user-memory-access in __mutex_lock.isra.0+0x1ac/0x7c0
> [    7.180345] Call Trace:
> [    7.182576]  mutex_lock+0xc9/0xd0
> [    7.183257]  adf_iov_putmsg+0x118/0x1a0 [intel_qat]
> [    7.183541]  adf_vf2pf_shutdown+0x4d/0x7b [intel_qat]
> [    7.183834]  adf_dev_shutdown+0x172/0x2b0 [intel_qat]
> [    7.184127]  adf_probe+0x5e9/0x600 [qat_dh895xccvf]
> 
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Fixes: 25c6ffb249f6 ("crypto: qat - check if PF is running")
> Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> ---
>  drivers/crypto/qat/qat_c3xxxvf/adf_drv.c    | 4 ++--
>  drivers/crypto/qat/qat_c62xvf/adf_drv.c     | 4 ++--
>  drivers/crypto/qat/qat_dh895xccvf/adf_drv.c | 4 ++--
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
> index 1d1532e8fb6d..067ca5e17d38 100644
> --- a/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
> +++ b/drivers/crypto/qat/qat_c3xxxvf/adf_drv.c
> @@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (ret)
>  		goto out_err_free_reg;
>  
> -	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> -
>  	ret = adf_dev_init(accel_dev);
>  	if (ret)
>  		goto out_err_dev_shutdown;
>  
> +	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> +
>  	ret = adf_dev_start(accel_dev);
>  	if (ret)
>  		goto out_err_dev_stop;
> diff --git a/drivers/crypto/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
> index 04742a6d91ca..51ea88c0b17d 100644
> --- a/drivers/crypto/qat/qat_c62xvf/adf_drv.c
> +++ b/drivers/crypto/qat/qat_c62xvf/adf_drv.c
> @@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (ret)
>  		goto out_err_free_reg;
>  
> -	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> -
>  	ret = adf_dev_init(accel_dev);
>  	if (ret)
>  		goto out_err_dev_shutdown;
>  
> +	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> +
>  	ret = adf_dev_start(accel_dev);
>  	if (ret)
>  		goto out_err_dev_stop;
> diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
> index c972554a755e..29999da716cc 100644
> --- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
> +++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.c
> @@ -184,12 +184,12 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (ret)
>  		goto out_err_free_reg;
>  
> -	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> -
>  	ret = adf_dev_init(accel_dev);
>  	if (ret)
>  		goto out_err_dev_shutdown;
>  
> +	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
> +
>  	ret = adf_dev_start(accel_dev);
>  	if (ret)
>  		goto out_err_dev_stop;
> -- 
> 2.25.1
> 
