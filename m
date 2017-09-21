From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: talitos - fix sha224
Date: Thu, 21 Sep 2017 16:06:17 +0800
Message-ID: <20170921080617.GC7718@gondor.apana.org.au>
References: <20170913104451.75E8B684D7@po15668-vm-win7.idsi0.si.c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, Stephan Muller <smueller@chronox.de>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:44878 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751693AbdIUIGn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 04:06:43 -0400
Content-Disposition: inline
In-Reply-To: <20170913104451.75E8B684D7@po15668-vm-win7.idsi0.si.c-s.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 13, 2017 at 12:44:51PM +0200, Christophe Leroy wrote:
> Kernel crypto tests report the following error at startup
> 
> [    2.752626] alg: hash: Test 4 failed for sha224-talitos
> [    2.757907] 00000000: 30 e2 86 e2 e7 8a dd 0d d7 eb 9f d5 83 fe f1 b0
> 00000010: 2d 5a 6c a5 f9 55 ea fd 0e 72 05 22
> 
> This patch fixes it
> 
> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
