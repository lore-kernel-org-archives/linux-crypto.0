From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: api - Clear CRYPTO_ALG_DEAD bit before
 registering an alg
Date: Mon, 23 Jan 2017 22:57:35 +0800
Message-ID: <20170123145735.GA20806@gondor.apana.org.au>
References: <1484308448-3225-1-git-send-email-salvatore.benedetto@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:59131 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750784AbdAWO5v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Jan 2017 09:57:51 -0500
Content-Disposition: inline
In-Reply-To: <1484308448-3225-1-git-send-email-salvatore.benedetto@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 11:54:08AM +0000, Salvatore Benedetto wrote:
> Make sure CRYPTO_ALG_DEAD bit is cleared before proceeding with
> the algorithm registration. This fixes qat-dh registration when
> driver is restarted
> 
> Signed-off-by: Salvatore Benedetto <salvatore.benedetto@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
