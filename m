From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v2] crypto: Add VMAC(AES) to Linux for intel_txt
	support
Date: Sat, 29 Aug 2009 17:34:51 +1000
Message-ID: <20090829073451.GA12104@gondor.apana.org.au>
References: <4A5F41C4.3050808@intel.com> <4A5F431B.6060307@intel.com> <4A805375.4030902@intel.com> <20090814032201.GA2544@gondor.apana.org.au> <4A85955F.3040807@intel.com> <20090820100949.GA31928@gondor.apana.org.au> <4A8FEC65.1080806@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Cihula, Joseph" <joseph.cihula@intel.com>
To: Shane Wang <shane.wang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36764 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751843AbZH2Hew (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 29 Aug 2009 03:34:52 -0400
Content-Disposition: inline
In-Reply-To: <4A8FEC65.1080806@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Aug 22, 2009 at 09:02:29PM +0800, Shane Wang wrote:
>
> Resend:
> This patch adds VMAC (a fast MAC) support into crypto framework.

I was going to apply this but it doesn't apply:

$ git apply ~/p
error: patch failed: crypto/Kconfig:267
error: crypto/Kconfig: patch does not apply
error: patch failed: crypto/Makefile:32
error: crypto/Makefile: patch does not apply
error: patch failed: crypto/testmgr.h:1652
error: crypto/testmgr.h: patch does not apply
$ 

Please rebase your patch against the current cryptodev tree.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
