From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 3/11] [CRYPTO] blkcipher: Merge ablkcipher and blkcipher into one option/module
Date: Thu, 22 Nov 2007 14:18:07 +0300
Message-ID: <20071122111807.GD2444@2ka.mipt.ru>
References: <20071122084758.GA7536@gondor.apana.org.au> <E1Iv7jl-00020C-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:45454 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbXKVLSS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 06:18:18 -0500
Content-Disposition: inline
In-Reply-To: <E1Iv7jl-00020C-00@gondolin.me.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Herbert.

On Thu, Nov 22, 2007 at 04:48:41PM +0800, Herbert Xu (herbert@gondor.apana.org.au) wrote:
> [CRYPTO] blkcipher: Merge ablkcipher and blkcipher into one option/module
> 
> Now that we have the givcipher type, both blkcipher and ablkcipher algorithms
> will use it to create givcipher objects.  As such it no longer makes sense
> to split the system between ablkcipher and blkcipher.  In particular, both
> ablkcipher.c and blkcipher.c would need to use the givcipher type which has
> to reside in ablkcipher.c since it shares much code with it.
> 
> This patch merges the two Kconfig options as well as the modules into one.

This breaks cryptodev tree, since some devices other than cryptd selects
CRYPTO_ABLKCIPHER.

-- 
	Evgeniy Polyakov
