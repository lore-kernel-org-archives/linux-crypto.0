From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: ccp - Remove "select OF" from Kconfig
Date: Thu, 24 Jul 2014 16:53:54 +0800
Message-ID: <20140724085354.GA7530@gondor.apana.org.au>
References: <20140723144519.19404.46876.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Tom Lendacky <thomas.lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:43715 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaGXIyA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Jul 2014 04:54:00 -0400
Content-Disposition: inline
In-Reply-To: <20140723144519.19404.46876.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 23, 2014 at 09:45:19AM -0500, Tom Lendacky wrote:
> The addition of the "select OF if ARM64" has led to a Kconfig
> recursive dependency error when "make ARCH=sh rsk7269_defconfig"
> was run.  Since OF is selected by ARM64 and the of_property_read_bool
> is defined no matter what, delete the Kconfig line that selects OF.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>

Patch applied.  Thanks Tom.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
