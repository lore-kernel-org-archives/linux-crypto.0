From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC][PATCH 0/8 v4] crypto: Add support for Intel(R) QuickAssist
Date: Sat, 21 Jun 2014 02:42:08 +0800
Message-ID: <20140620184208.GH3169@gondor.apana.org.au>
References: <20140605204133.1400.64237.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, john.griffin@intel.com,
	bruce.w.allan@intel.com, john.ronciak@intel.com,
	karen.xiang@intel.com, pingchaox.yang@intel.com, bo.cui@intel.com,
	qat-linux@intel.com, linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60805 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966270AbaFTSmP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Jun 2014 14:42:15 -0400
Content-Disposition: inline
In-Reply-To: <20140605204133.1400.64237.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 05, 2014 at 01:42:24PM -0700, Tadeusz Struk wrote:
> Hi,
> This patchset adds support for Intel(R) QuickAssist Technology (QAT) and
> DH895xCC hardware accelerator.
> First four patches add a common infractructure that will be used by all QAT
> devices.
> Patch five and six add a firmware loader module that is used to load the
> microcode to the acceleration engines and start them.
> Patch seven adds dh895xcc hardware specific code, which hooks to the common
> infrastructure and provides acceleration for
> the following algorithms:
> authenc(hmac(sha1),cbc(aes)), authenc(hmac(sha256),cbc(aes)),
> authenc(hmac(sha512),cbc(aes))
> Patch eight updates makefiles etc.
> 
> More info on the hardware accelerator and the Quick Assist Technology can
> be found on:
> https://01.org/packet-processing/intel%C2%AE-quickassist-technology-drivers-and-patches
> 
> Acked-by: John Griffin <john.griffin@intel.com>
> Acked-by: Bo Cui <bo.cui@intel.com>
> Reviewed-by: Bruce W. Allan <bruce.w.allan@intel.com>
> Signed-off-by: Karen Xiang <karen.xiang@intel.com>
> Signed-off-by: Pingchaox Yang <pingchaox.yang@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
