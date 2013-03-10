From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: user - constify netlink dispatch table
Date: Sun, 10 Mar 2013 18:14:59 +0800
Message-ID: <20130310101459.GC10910@gondor.apana.org.au>
References: <1361711352-7795-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:58497 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752829Ab3CJKPE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Mar 2013 06:15:04 -0400
Content-Disposition: inline
In-Reply-To: <1361711352-7795-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 24, 2013 at 02:09:12PM +0100, Mathias Krause wrote:
> There is no need to modify the netlink dispatch table at runtime and
> making it const even makes the resulting object file slightly smaller.
> 
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Patch applied.  Thanks Mathias!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
