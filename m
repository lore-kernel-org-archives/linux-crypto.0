From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH -v2 1/5] crypto: Add GHASH digest algorithm for GCM
Date: Thu, 6 Aug 2009 15:33:19 +1000
Message-ID: <20090806053319.GA23557@gondor.apana.org.au>
References: <1249285531-22422-1-git-send-email-ying.huang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59378 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753326AbZHFFdW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2009 01:33:22 -0400
Content-Disposition: inline
In-Reply-To: <1249285531-22422-1-git-send-email-ying.huang@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 03, 2009 at 03:45:27PM +0800, Huang Ying wrote:
> GHASH is implemented as a shash algorithm. The actual implementation
> is copied from gcm.c. This makes it possible to add
> architecture/hardware accelerated GHASH implementation.
> 
> v2:
>  - Fix a bug in Makefile (Thanks Sebastian)
>  - Some other minor fixes
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Patch applied.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
