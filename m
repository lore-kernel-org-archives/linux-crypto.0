From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] crypto: [sha] x86 SHA extension optimization of SHA1
 and SHA256
Date: Fri, 18 Sep 2015 22:03:22 +0800
Message-ID: <20150918140322.GD9249@gondor.apana.org.au>
References: <1441924012.4322.0.camel@schen9-desk2.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	"David S.Miller" <davem@davemloft.net>,
	Sean Gulley <sean.m.gulley@intel.com>,
	Chandramouli Narayanan <mouli_7982@yahoo.com>,
	Vinodh Gopal <vinodh.gopal@intel.com>,
	James Guilford <james.guilford@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tim Chen <tim.c.chen@linux.intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42777 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbbIRODz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Sep 2015 10:03:55 -0400
Content-Disposition: inline
In-Reply-To: <1441924012.4322.0.camel@schen9-desk2.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 10, 2015 at 03:26:52PM -0700, Tim Chen wrote:
> 
> The new x86 SHA extensions provide new hardware accelerated instructions
> for computing SHA1 and SHA256 hashes. This patch series provide the
> assembly routines for SHA1 and SHA256 computation using these new
> instructions to the kernel crypto library.  For 4K data blocks, we've
> seen up to 3.6x speedup over existing SSSE3 enhanced routines in the
> kernel crypto library on Broxton platform.

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
