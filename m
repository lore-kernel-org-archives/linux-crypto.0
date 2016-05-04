From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: algif_skcipher: replace sg++ with sg_next()
Date: Wed, 4 May 2016 12:09:44 +0800
Message-ID: <20160504040944.GA25781@gondor.apana.org.au>
References: <1462301939-23578-1-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Muhammad Falak R Wani <falakreyaz@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53910 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbcEDEJr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 00:09:47 -0400
Content-Disposition: inline
In-Reply-To: <1462301939-23578-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Muhammad Falak R Wani <falakreyaz@gmail.com> wrote:
> Never use sg++, always use sg = sg_next(sg). Scatterlist entries can
> be combined if the memory is contiguous but sg++ won't know about
> that. It sure would run on the slower side.
> But regardless, sg++ should never be used, only sg_next is safe.
> 
> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>

No please the only difference between sg_next and sg++ is chaining,
which is irrelevant here.

Patch rejected.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
