From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 119/123] warning: (CRYPTO_DEV_QAT_DH895xCCVF)
 selects PCI_IOV which has unmet direct dependencies (PCI)
Date: Thu, 13 Aug 2015 15:17:09 +0800
Message-ID: <20150813071709.GB21239@gondor.apana.org.au>
References: <201508110049.yV4f3Yls%fengguang.wu@intel.com>
 <55C8E2E9.8000509@intel.com>
 <20150811135738.GA30846@gondor.apana.org.au>
 <55CA3971.5070008@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45758 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbbHMHRS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Aug 2015 03:17:18 -0400
Content-Disposition: inline
In-Reply-To: <55CA3971.5070008@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 11, 2015 at 11:05:37AM -0700, Tadeusz Struk wrote:
>
> ---8<---
> Fix unmet direct dependencies for QAT_DH895xCCVF
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
