From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] crypto: x86/sha1 - regression and other fixes
Date: Tue, 25 Mar 2014 20:44:28 +0800
Message-ID: <20140325124428.GA23877@gondor.apana.org.au>
References: <1395677439-7478-1-git-send-email-minipli@googlemail.com>
 <201403242119.44692.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mathias Krause <minipli@googlemail.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:38039 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbaCYMoo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Mar 2014 08:44:44 -0400
Content-Disposition: inline
In-Reply-To: <201403242119.44692.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 24, 2014 at 09:19:44PM +0100, Marek Vasut wrote:
> On Monday, March 24, 2014 at 05:10:36 PM, Mathias Krause wrote:
> > The recent addition of the AVX2 variant of the SHA1 hash function wrongly
> > disabled the AVX variant by introducing a flaw in the feature test. Fixed
> > in patch 1.
> > 
> > The alignment calculations of the AVX2 assembler implementation are
> > questionable, too. Especially the page alignment of the stack pointer is
> > broken in multiple ways. Fixed in patch 2. In patch 3 another issue for
> > code alignment is fixed.
> > 
> > Please apply!
> 
> Nice,
> 
> Reviewed-by: Marek Vasut <marex@denx.de>

All applied.  Thanks Mathias!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
