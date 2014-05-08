From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: user - Allow CRYPTO_MSG_GETALG without
 CAP_NET_ADMIN
Date: Thu, 8 May 2014 22:01:19 +0800
Message-ID: <20140508140119.GB13769@gondor.apana.org.au>
References: <534016A0.6020702@mirix.org>
 <5359955A.4070903@mirix.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Matthias-Christian Ott <ott@mirix.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:52264 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128AbaEHOBW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 May 2014 10:01:22 -0400
Content-Disposition: inline
In-Reply-To: <5359955A.4070903@mirix.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 24, 2014 at 10:51:06PM +0000, Matthias-Christian Ott wrote:
> 
> CRYPTO_USER requires CAP_NET_ADMIN for all operations. Most information
> provided by CRYPTO_MSG_GETALG is also accessible through /proc/modules
> and AF_ALG. CRYPTO_MSG_GETALG should not require CAP_NET_ADMIN so that
> processes without CAP_NET_ADMIN can use CRYPTO_MSG_GETALG to get cipher
> details, such as cipher priorities, for AF_ALG.
> 
> Signed-off-by: Matthias-Christian Ott <ott@mirix.org>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
