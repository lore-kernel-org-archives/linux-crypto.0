From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 5/7] crypto: cryptd: Add support to access underlaying
	shash
Date: Sun, 21 Jun 2009 21:50:15 +0800
Message-ID: <20090621135015.GA3131@gondor.apana.org.au>
References: <1244704234.5320.128.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58742 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753839AbZFUNuN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2009 09:50:13 -0400
Content-Disposition: inline
In-Reply-To: <1244704234.5320.128.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Huang Ying <ying.huang@intel.com> wrote:
> cryptd_alloc_ahash() will allocate a cryptd-ed ahash for specified
> algorithm name. The new allocated one is guaranteed to be cryptd-ed
> ahash, so the shash underlying can be gotten via cryptd_ahash_child().
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

Looks good too.
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
