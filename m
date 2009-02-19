From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -v2 1/3] crypto: Use dedicated workqueue for crypto
	subsystem
Date: Thu, 19 Feb 2009 14:44:31 +0800
Message-ID: <20090219064431.GA2011@gondor.apana.org.au>
References: <1234246430.20270.73.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:46439 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752660AbZBSGoi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Feb 2009 01:44:38 -0500
Content-Disposition: inline
In-Reply-To: <1234246430.20270.73.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 10, 2009 at 02:13:50PM +0800, Huang Ying wrote:
> Use dedicated workqueue for crypto subsystem
> 
> A dedicated workqueue named kcrypto_wq is created to be used by crypto
> subsystem. The system shared keventd_wq is not suitable for
> encryption/decryption, because of potential starvation problem.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

All applied.  Thanks a lot for doing this!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
