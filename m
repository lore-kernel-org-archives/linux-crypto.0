Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4587BC433DB
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 10:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D533C64E6F
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Feb 2021 10:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhBIK1Q (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Feb 2021 05:27:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:54255 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231652AbhBIKZG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Feb 2021 05:25:06 -0500
IronPort-SDR: dL+kAUVaNLouhNwDBdzpfcdx6aML9AZmKxD3wJ+tTQDM5YZb3COhPu3GghzBialZhNLYs1RpWn
 yZhdRL3f8FjA==
X-IronPort-AV: E=McAfee;i="6000,8403,9889"; a="168982958"
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="168982958"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 02:24:19 -0800
IronPort-SDR: q0iJNI4F2v7k55D7v7qCdAqR/Yz9ki46zGqg6+rHYvuKqNoQa2tkq3ppka9XWDIWs9oyfCUD6S
 V3zovXye5sWQ==
X-IronPort-AV: E=Sophos;i="5.81,164,1610438400"; 
   d="scan'208";a="396061551"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2021 02:24:18 -0800
Date:   Tue, 9 Feb 2021 10:24:15 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] drivers: crypto: qat: qat_common: Two different lines
 fix the same spelling in the file adf_vf2pf_msg.c
Message-ID: <20210209102415.GB118045@silpixa00400314>
References: <20210203150148.25671-1-unixbhaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203150148.25671-1-unixbhaskar@gmail.com>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Will be consolidated with the other patch that fixes the same spelling
mistake.

Regards,

-- 
Giovanni

On Wed, Feb 03, 2021 at 08:31:48PM +0530, Bhaskar Chowdhury wrote:
> 
> s/messge/message/  ..two different lines
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/crypto/qat/qat_common/adf_vf2pf_msg.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
> index 2c98fb63f7b7..e85bd62d134a 100644
> --- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
> +++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
> @@ -8,7 +8,7 @@
>   * adf_vf2pf_init() - send init msg to PF
>   * @accel_dev:  Pointer to acceleration VF device.
>   *
> - * Function sends an init messge from the VF to a PF
> + * Function sends an init message from the VF to a PF
>   *
>   * Return: 0 on success, error code otherwise.
>   */
> @@ -31,7 +31,7 @@ EXPORT_SYMBOL_GPL(adf_vf2pf_init);
>   * adf_vf2pf_shutdown() - send shutdown msg to PF
>   * @accel_dev:  Pointer to acceleration VF device.
>   *
> - * Function sends a shutdown messge from the VF to a PF
> + * Function sends a shutdown message from the VF to a PF
>   *
>   * Return: void
>   */
> --
> 2.26.2
> 
