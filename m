From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - select PCI_IOV when VF are enabled
Date: Sat, 12 Dec 2015 13:44:08 +0800
Message-ID: <20151212054407.GD17504@gondor.apana.org.au>
References: <20151209195947.17596.6859.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fengguang.wu@intel.com, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44804 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbbLLFoK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 12 Dec 2015 00:44:10 -0500
Content-Disposition: inline
In-Reply-To: <20151209195947.17596.6859.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Dec 09, 2015 at 11:59:47AM -0800, Tadeusz Struk wrote:
> Fix i386-randconfig-x004-12092241.
> PCI_IOV needs to be selected when VFs are enabled
> 
> Reported-by: <fengguang.wu@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
