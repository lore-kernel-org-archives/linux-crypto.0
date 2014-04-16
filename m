From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add test cases for SHA-1, SHA-224, SHA-256 and
 AES-CCM
Date: Wed, 16 Apr 2014 21:49:48 +0800
Message-ID: <20140416134948.GF4684@gondor.apana.org.au>
References: <1397150203-12654-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:59998 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbaDPNtu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Apr 2014 09:49:50 -0400
Content-Disposition: inline
In-Reply-To: <1397150203-12654-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Apr 10, 2014 at 07:16:43PM +0200, Ard Biesheuvel wrote:
> This adds test cases for SHA-1, SHA-224, SHA-256 and AES-CCM with an input size
> that is an exact multiple of the block size. The reason is that some
> implementations use a different code path for these cases.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
