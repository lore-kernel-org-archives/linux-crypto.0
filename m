From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: img-hash: Fix Kconfig selections
Date: Mon, 23 Mar 2015 22:08:53 +1100
Message-ID: <20150323110852.GA13736@gondor.apana.org.au>
References: <CAD3Xx4Kz0qT+=FKEy8N-rkubSrPAEhmXkTXk1H+-MGJ7BNiGqA@mail.gmail.com>
 <1426783584-11167-1-git-send-email-james.hartley@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
	abrestic@chromium.org, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Paul Bolle <pebolle@tiscali.nl>,
	Andreas Ruprecht <rupran@einserver.de>,
	hengelein Stefan <stefan.hengelein@fau.de>
To: James Hartley <james.hartley@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:38901 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbbCWLJR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Mar 2015 07:09:17 -0400
Content-Disposition: inline
In-Reply-To: <1426783584-11167-1-git-send-email-james.hartley@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 19, 2015 at 04:46:24PM +0000, James Hartley wrote:
> The Kconfig entry for CRYPTO_DEV_IMGTEC_HASH incorrectly selects
> CRYPTO_SHA224, which does not exist (and is covered by CRYPTO_SHA256
> which covers both 224 and 256). Remove it.
> 
> Also correct typo CRYPTO_ALG_API to be CRYPTO_ALGPI.
> 
> Reported-by: Valentin Rothberg <valentinrothberg@gmail.com>
> Signed-off-by: James Hartley <james.hartley@imgtec.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
