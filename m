From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] crypto: qat - fix some timeout tests
Date: Wed, 16 Dec 2015 02:50:31 +0300
Message-ID: <20151215235031.GK5177@mwanda>
References: <20151215100515.GB20848@mwanda>
 <567077AB.8040602@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Pingchao Yang <pingchao.yang@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46318 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbbLOXus (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 15 Dec 2015 18:50:48 -0500
Content-Disposition: inline
In-Reply-To: <567077AB.8040602@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 15, 2015 at 12:27:23PM -0800, Tadeusz Struk wrote:
> Since the times var is an signed int I think we should rather change the condition:

I don't see what signed int has to do with anything.

> 
> diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
> index 45c1739..864a5ea 100644
> --- a/drivers/crypto/qat/qat_common/qat_hal.c
> +++ b/drivers/crypto/qat/qat_common/qat_hal.c
> @@ -186,7 +186,7 @@ static int qat_hal_wait_cycles(struct icp_qat_fw_loader_handle *handle,
>  		if (elapsed_cycles >= 8 && !(csr & (1 << ACS_ABO_BITPOS)))
>  			return 0;
>  	}
> -	if (!times) {
> +	if (!(0 < times)) {

Oh, wow that's nasty!  Why would you write it in such an obfuscated way?
Plus it's buggy and wrong...  What on earth.

regards,
dan carpenter
