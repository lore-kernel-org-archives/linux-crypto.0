From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: sha512_generic - set cra_driver_name
Date: Tue, 28 May 2013 17:52:24 +0800
Message-ID: <20130528095224.GF24414@gondor.apana.org.au>
References: <20130521141010.16154.53640.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:58342 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932290Ab3E1Jw1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 28 May 2013 05:52:27 -0400
Content-Disposition: inline
In-Reply-To: <20130521141010.16154.53640.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 21, 2013 at 05:10:10PM +0300, Jussi Kivilinna wrote:
> 'sha512_generic' should set driver name now that there is alternative sha512
> provider (sha512_ssse3).
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
