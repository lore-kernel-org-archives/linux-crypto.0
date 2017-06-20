From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] rsa-pkcs1pad: use constant time memory comparison for
 MACs
Date: Tue, 20 Jun 2017 11:38:09 +0800
Message-ID: <20170620033809.GC17764@gondor.apana.org.au>
References: <20170610025912.6499-1-Jason@zx2c4.com>
 <20170611212023.31101-1-Jason@zx2c4.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:60860 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbdFTDie (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 23:38:34 -0400
Content-Disposition: inline
In-Reply-To: <20170611212023.31101-1-Jason@zx2c4.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jun 11, 2017 at 11:20:23PM +0200, Jason A. Donenfeld wrote:
> Otherwise, we enable all sorts of forgeries via timing attack.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Suggested-by: Stephan Müller <smueller@chronox.de>
> Cc: stable@vger.kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
