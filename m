From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: rsa - Do not gratuitously drop leading zeroes
Date: Fri, 24 Jun 2016 17:30:17 +0800
Message-ID: <20160624093017.GB18935@gondor.apana.org.au>
References: <20160622101432.GA30454@gondor.apana.org.au>
 <733379976.TmXhNiYQ9x@positron.chronox.de>
 <20160624084147.GB18603@gondor.apana.org.au>
 <1513733.zSFupaElV5@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51542 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbcFXJa1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 05:30:27 -0400
Content-Disposition: inline
In-Reply-To: <1513733.zSFupaElV5@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 24, 2016 at 11:23:06AM +0200, Stephan Mueller wrote:
> 
> Patch 2 introduces the bug.
> 
> Note, with patch 2, there is also a compile warning with crypto/dh.c.

Oh I see.  It's a conflict with the kpp stuff that didn't exist
when I wrote this.

Let me respin the patches on top of kpp.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
