From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni_intel - fix Kconfig problem with
 CRYPTO_GLUE_HELPER_X86
Date: Thu, 25 Apr 2013 21:06:28 +0800
Message-ID: <20130425130628.GA29329@gondor.apana.org.au>
References: <51652688.vLFH53k1uKh/xP2W%fengguang.wu@intel.com>
 <20130410153920.15657.98615.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, kbuild-all@01.org,
	kbuild test robot <fengguang.wu@intel.com>,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:50342 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756935Ab3DYNGc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Apr 2013 09:06:32 -0400
Content-Disposition: inline
In-Reply-To: <20130410153920.15657.98615.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 10, 2013 at 06:39:20PM +0300, Jussi Kivilinna wrote:
> The Kconfig setting for glue helper module is CRYPTO_GLUE_HELPER_X86, but
> recent change for aesni_intel used CRYPTO_GLUE_HELPER instead. Patch corrects
> this issue.
> 
> Cc: kbuild-all@01.org
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
