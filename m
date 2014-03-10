From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 1/3] crypto: remove direct blkcipher_walk dependency
 on transform
Date: Mon, 10 Mar 2014 20:22:54 +0800
Message-ID: <20140310122254.GI10556@gondor.apana.org.au>
References: <1393910920-5796-1-git-send-email-ard.biesheuvel@linaro.org>
 <1393910920-5796-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:43188 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbaCJMW4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Mar 2014 08:22:56 -0400
Content-Disposition: inline
In-Reply-To: <1393910920-5796-2-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 04, 2014 at 01:28:38PM +0800, Ard Biesheuvel wrote:
> In order to allow other uses of the blkcipher walk API than the blkcipher
> algos themselves, this patch copies some of the transform data members to the
> walk struct so the transform is only accessed at walk init time.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Applied patches 1 & 2.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
