From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 119/123] warning: (CRYPTO_DEV_QAT_DH895xCCVF)
 selects PCI_IOV which has unmet direct dependencies (PCI)
Date: Tue, 11 Aug 2015 21:57:38 +0800
Message-ID: <20150811135738.GA30846@gondor.apana.org.au>
References: <201508110049.yV4f3Yls%fengguang.wu@intel.com>
 <55C8E2E9.8000509@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42589 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964936AbbHKN5r (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Aug 2015 09:57:47 -0400
Content-Disposition: inline
In-Reply-To: <55C8E2E9.8000509@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 10, 2015 at 10:44:09AM -0700, Tadeusz Struk wrote:
>
>  config CRYPTO_DEV_QAT_DH895xCCVF
>  	tristate "Support for Intel(R) DH895xCC Virtual Function"
> +	select PCI
>  	select PCI_IOV

Wouldn't a dependency on PCI make more sense? Or does this not
work?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
