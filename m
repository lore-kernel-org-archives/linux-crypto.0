Return-Path: <SRS0=z3ky=DB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C41AC4346E
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 05:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9F652311A
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Sep 2020 05:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgIXFDw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Sep 2020 01:03:52 -0400
Received: from mga03.intel.com ([134.134.136.65]:34562 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbgIXFDv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Sep 2020 01:03:51 -0400
IronPort-SDR: 1rzj7wiGIESeyBPUJjyYS4yAvrEz+2h4tamFV7dhDlyfvecNOSsaAucbhtP0avjkKOTI6Wby8W
 3kcKhqhktlzg==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="161161605"
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="161161605"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 22:03:51 -0700
IronPort-SDR: bBOY5IvAKE2dR2qVgHLTeShCzoEoiUVlwhF51qMH4jQUljnyomKZJ6kdMuerYJoXUYQBVUlmYl
 61Xg+3Ko6EOw==
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="486746369"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 22:03:49 -0700
Date:   Thu, 24 Sep 2020 06:03:46 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Qinglang Miao <miaoqinglang@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        qat-linux <qat-linux@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] crypto: qat - remove unnecessary mutex_init()
Message-ID: <20200924050346.GB32206@silpixa00400314>
References: <ee44c6c05720495d8bb72ae9ad7094e8@irsmsx602.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee44c6c05720495d8bb72ae9ad7094e8@irsmsx602.ger.corp.intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 16, 2020 at 07:21:21AM +0100, Qinglang Miao wrote:
> The mutex adf_ctl_lock is initialized statically. It is
> unnecessary to initialize by mutex_init().
> 
> Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>

Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

> ---
>  drivers/crypto/qat/qat_common/adf_ctl_drv.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
> index 71d0c44aa..eb9b3be9d 100644
> --- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
> +++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
> @@ -416,8 +416,6 @@ static long adf_ctl_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
>  
>  static int __init adf_register_ctl_device_driver(void)
>  {
> -	mutex_init(&adf_ctl_lock);
> -
>  	if (adf_chr_drv_create())
>  		goto err_chr_dev;
>  
> -- 
> 2.23.0
> 
