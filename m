From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: replace kmalloc and then memcpy with kmemdup
Date: Thu, 21 Mar 2013 17:54:16 +0800
Message-ID: <20130321095415.GB26931@gondor.apana.org.au>
References: <1362998890-7532-1-git-send-email-mihneadb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	linus.walleij@linaro.org, andreas.westin@stericsson.com,
	arnd@arndb.de, rubini@unipv.it, linux-kernel@vger.kernel.org
To: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:46168 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757856Ab3CUJyf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 Mar 2013 05:54:35 -0400
Content-Disposition: inline
In-Reply-To: <1362998890-7532-1-git-send-email-mihneadb@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 11, 2013 at 12:48:10PM +0200, Mihnea Dobrescu-Balaur wrote:
> Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
