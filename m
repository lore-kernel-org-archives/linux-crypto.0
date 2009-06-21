From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 4/7] crypto: use crypto_shash instead of crypto_hash in
	cryptd hash
Date: Sun, 21 Jun 2009 21:49:50 +0800
Message-ID: <20090621134950.GA3092@gondor.apana.org.au>
References: <1244704232.5320.127.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58738 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbZFUNtt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2009 09:49:49 -0400
Content-Disposition: inline
In-Reply-To: <1244704232.5320.127.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Huang Ying <ying.huang@intel.com> wrote:
> crypto_hash interface has some issue and will be replaced by
> crypto_shash. This patch replace crypto_hash in cryptd hash with
> crypto_shash.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>

This patch and 3/7 looks good to me.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
