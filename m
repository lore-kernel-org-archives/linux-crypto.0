From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC 2/7] crypto: Use GHASH digest algorithm in GCM
Date: Sun, 21 Jun 2009 21:46:35 +0800
Message-ID: <20090621134635.GA2980@gondor.apana.org.au>
References: <1244704228.5320.125.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:41723 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751259AbZFUNqh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 21 Jun 2009 09:46:37 -0400
Content-Disposition: inline
In-Reply-To: <1244704228.5320.125.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Huang Ying <ying.huang@intel.com> wrote:
>
> +       ghash = crypto_alloc_ahash("ghash", 0, 0);
> +       if (IS_ERR(ghash))
> +               return PTR_ERR(ghash);

We should add this as an extra parameter to gcm_base.  This is
so that the user can select an alternative ghash implementation.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
