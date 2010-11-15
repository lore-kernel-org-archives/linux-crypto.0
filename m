From: Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH 4/4] crypto: algif_skcipher - User-space interface for
 skcipher operations
Date: Mon, 15 Nov 2010 15:55:49 +0100
Message-ID: <1289832949.1979.71.camel@martin>
References: <20101115115120.GA3797@gondor.apana.org.au>
	 <E1PHxca-00011N-As@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sitav-80024.hsr.ch ([152.96.80.24]:40661 "EHLO strongswan.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754435Ab0KOOz4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Nov 2010 09:55:56 -0500
In-Reply-To: <E1PHxca-00011N-As@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> This patch adds the af_alg plugin for symmetric key ciphers,
> corresponding to the ablkcipher kernel operation type.

I can confirm that the newest patch fixes the page leak.

Tested-by: Martin Willi <martin@strongswan.org>
