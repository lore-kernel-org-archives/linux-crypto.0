Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A04DC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 17:02:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F46E224DE
	for <linux-crypto@archiver.kernel.org>; Mon,  4 Jan 2021 17:02:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727715AbhADRCh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:02:37 -0500
Received: from mga18.intel.com ([134.134.136.126]:41954 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbhADRCh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 4 Jan 2021 12:02:37 -0500
IronPort-SDR: 9WKhop/7fjo4t58EWthzftVOO4NUOa0x94KtFU5nty2JI7/FyyhHx2UH7m5s90a0r/DHjfspiN
 wX/UgStRnDHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9854"; a="164683361"
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="164683361"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 09:01:55 -0800
IronPort-SDR: nDPeWFZWVlVil2UGSgt0KlZMQLNbZaGxW4NLuvGVOaTYlnywG/J5gbQIY4Yq2CcLSGsFi0e7c1
 qk59V4Fn1m2Q==
X-IronPort-AV: E=Sophos;i="5.78,474,1599548400"; 
   d="scan'208";a="462006731"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314) ([10.237.222.51])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2021 09:01:52 -0800
Date:   Mon, 4 Jan 2021 17:01:43 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Marco Chiappero <marco.chiappero@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH] crypto: qat - replace CRYPTO_AES with CRYPTO_LIB_AES in
 Kconfig
Message-ID: <20210104170143.GA6858@silpixa00400314>
References: <20201223205755.GA19858@gondor.apana.org.au>
 <20210104153515.749496-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210104153515.749496-1-marco.chiappero@intel.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 04, 2021 at 03:35:15PM +0000, Marco Chiappero wrote:
> Use CRYPTO_LIB_AES in place of CRYPTO_AES in the dependences for the QAT
> common code.
> 
> Fixes: c0e583ab2016 ("crypto: qat - add CRYPTO_AES to Kconfig dependencies")
> Reported-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>

Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

> ---
>  drivers/crypto/qat/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
> index 846a3d90b41a..77783feb62b2 100644
> --- a/drivers/crypto/qat/Kconfig
> +++ b/drivers/crypto/qat/Kconfig
> @@ -11,7 +11,7 @@ config CRYPTO_DEV_QAT
>  	select CRYPTO_SHA1
>  	select CRYPTO_SHA256
>  	select CRYPTO_SHA512
> -	select CRYPTO_AES
> +	select CRYPTO_LIB_AES
>  	select FW_LOADER
>  
>  config CRYPTO_DEV_QAT_DH895xCC
> -- 
> 2.26.2
> 
