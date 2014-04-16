From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypt: bfin_crc: access crc registers by readl and
 writel functions
Date: Wed, 16 Apr 2014 21:48:54 +0800
Message-ID: <20140416134854.GD4684@gondor.apana.org.au>
References: <1397111456-17371-1-git-send-email-sonic.adi@gmail.com>
 <201404101001.34907.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sonic Zhang <sonic.adi@gmail.com>, linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:50558 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161071AbaDPNs7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Apr 2014 09:48:59 -0400
Content-Disposition: inline
In-Reply-To: <201404101001.34907.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 10, 2014 at 10:01:34AM +0200, Marek Vasut wrote:
> On Thursday, April 10, 2014 at 08:30:56 AM, Sonic Zhang wrote:
> > From: Sonic Zhang <sonic.zhang@analog.com>
> > 
> > Move architecture independant crc header file out of the blackfin folder.
> > 
> > 
> > Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> > ---
> > v2-changes:
> > - avoid combine the IO accessors into each other
> > - use readl/writel other than ioread32/iowrite32
> 
> Reviewed-by: Marek Vasut <marex@denx.de>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
