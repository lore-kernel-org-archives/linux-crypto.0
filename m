From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/9] crypto: Add ChaCha20-Poly1305 AEAD support for IPsec
Date: Wed, 3 Jun 2015 10:44:25 +0800
Message-ID: <20150603024425.GA2553@gondor.apana.org.au>
References: <1433159044-30753-1-git-send-email-martin@strongswan.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	linux-crypto@vger.kernel.org
To: Martin Willi <martin@strongswan.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53477 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752986AbbFCCof (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2015 22:44:35 -0400
Content-Disposition: inline
In-Reply-To: <1433159044-30753-1-git-send-email-martin@strongswan.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 01, 2015 at 01:43:55PM +0200, Martin Willi wrote:
> This is a first version of a patch series implementing the ChaCha20-Poly1305
> AEAD construction defined in RFC7539. It is based on the current cryptodev tree.

The patches look fine to me.  Steffen, what do you think?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
