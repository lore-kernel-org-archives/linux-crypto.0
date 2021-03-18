Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8FAC433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 15:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09C2C64F2A
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 15:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhCRPxY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 11:53:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:43307 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232080AbhCRPxN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 11:53:13 -0400
IronPort-SDR: nOBe3Y3Xf8lM3IbsuxPsRz6QlOh3jEgo+y+s+taQMa6gTsF0wwGIMb+2OlgpLSw+BkH7KHKBOK
 arTP79aEdfOw==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="189750718"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="189750718"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 08:53:13 -0700
IronPort-SDR: uQ86AuMPb1Evn73ZqS2y10PMl5tuwOGD5Cmv6ypUv/3hQh3ZYoO/1gzFw6dUW9AVvX3tjQLanw
 u2rHoSOmAlKw==
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="439783034"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 08:53:10 -0700
Date:   Thu, 18 Mar 2021 15:53:03 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] crypto: qat - dont release uninitialized resources
Message-ID: <YFN3X6q8dzEaUp27@silpixa00400314>
References: <20210312162203.2416149-1-ztong0001@gmail.com>
 <20210312162203.2416149-2-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312162203.2416149-2-ztong0001@gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 12, 2021 at 11:22:02AM -0500, Tong Zhang wrote:
> adf_vf_isr_resource_alloc() is not unwinding correctly when error
> happens and it trys to release uninitialized resources.
> To fix this, only release initialized resources.
> 
> [    1.792845] Trying to free already-free IRQ 11
> [    1.793091] WARNING: CPU: 0 PID: 182 at kernel/irq/manage.c:1821 free_irq+0x202/0x380
> [    1.801340] Call Trace:
> [    1.801477]  adf_vf_isr_resource_free+0x32/0xb0 [intel_qat]
> [    1.801785]  adf_vf_isr_resource_alloc+0x14d/0x150 [intel_qat]
> [    1.802105]  adf_dev_init+0xba/0x140 [intel_qat]
> 
> Signed-off-by: Tong Zhang <ztong0001@gmail.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
I would add also a Fixes tag:
Fixes: dd0f368398ea ("crypto: qat - Add qat dh895xcc VF driver")

Minor nit, typo in commit message: dont --> don't/do not

Apart from that
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

-- 
Giovanni

> ---
>  drivers/crypto/qat/qat_common/adf_vf_isr.c | 17 +++++++++++++----
>  1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
> index 38d316a42ba6..888388acb6bd 100644
> --- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
> +++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
> @@ -261,17 +261,26 @@ int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
>  		goto err_out;
>  
>  	if (adf_setup_pf2vf_bh(accel_dev))
> -		goto err_out;
> +		goto err_disable_msi;
>  
>  	if (adf_setup_bh(accel_dev))
> -		goto err_out;
> +		goto err_cleanup_pf2vf_bh;
>  
>  	if (adf_request_msi_irq(accel_dev))
> -		goto err_out;
> +		goto err_cleanup_bh;
>  
>  	return 0;
> +
> +err_cleanup_bh:
> +	adf_cleanup_bh(accel_dev);
> +
> +err_cleanup_pf2vf_bh:
> +	adf_cleanup_pf2vf_bh(accel_dev);
> +
> +err_disable_msi:
> +	adf_disable_msi(accel_dev);
> +
>  err_out:
> -	adf_vf_isr_resource_free(accel_dev);
>  	return -EFAULT;
>  }
>  EXPORT_SYMBOL_GPL(adf_vf_isr_resource_alloc);
> -- 
> 2.25.1
> 
