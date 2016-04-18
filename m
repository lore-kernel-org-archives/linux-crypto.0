From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix section mismatch warning
Date: Mon, 18 Apr 2016 18:53:42 +0800
Message-ID: <20160418105342.GB19448@gondor.apana.org.au>
References: <201604160011.1WGwhONj%fengguang.wu@intel.com>
 <1460742847-10350-1-git-send-email-tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, fengguang.wu@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57260 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852AbcDRKxu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Apr 2016 06:53:50 -0400
Content-Disposition: inline
In-Reply-To: <1460742847-10350-1-git-send-email-tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 15, 2016 at 10:54:07AM -0700, Tadeusz Struk wrote:
> Subject: [PATCH] crypto: qat - fix section mismatch warning
> 
> Fix Section mismatch warinig in adf_exit_vf_wq()
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
