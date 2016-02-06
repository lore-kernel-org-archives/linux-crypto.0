From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: user - lock crypto_alg_list on alg dump
Date: Sat, 6 Feb 2016 15:45:52 +0800
Message-ID: <20160206074552.GA22220@gondor.apana.org.au>
References: <1454333250-21370-1-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Steffen Klassert <steffen.klassert@secunet.com>,
	PaX Team <pageexec@freemail.hu>
To: Mathias Krause <minipli@googlemail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:43174 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbcBFHqD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Feb 2016 02:46:03 -0500
Content-Disposition: inline
In-Reply-To: <1454333250-21370-1-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Feb 01, 2016 at 02:27:30PM +0100, Mathias Krause wrote:
> We miss to take the crypto_alg_sem semaphore when traversing the
> crypto_alg_list for CRYPTO_MSG_GETALG dumps. This allows a race with
> crypto_unregister_alg() removing algorithms from the list while we're
> still traversing it, thereby leading to a use-after-free as show below:

Applied to crypto.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
