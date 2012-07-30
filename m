From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/14] crypto: cleanup - alg and shash init/exit
 cleanups and remove unneeded cra_list initializations
Date: Mon, 30 Jul 2012 15:52:29 +0800
Message-ID: <20120730075229.GB5515@gondor.apana.org.au>
References: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:38404 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752249Ab2G3Hwc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 30 Jul 2012 03:52:32 -0400
Content-Disposition: inline
In-Reply-To: <20120711111949.6875.60269.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 11, 2012 at 02:19:50PM +0300, Jussi Kivilinna wrote:
> Patches 1-5 change various cipher modules to use new crypto_register_algs and
> crypto_unregister_algs.
> 
> Patch 6 adds new crypto_register_shashes and crypto_unregister_shashes
> functions for registering multiple shash algorithms at same time.
> 
> Patches 7-10 change various shash modules to use new crypto_register_shashes
> and crypto_unregister_shashes.
> 
> Patches 11-14 remove unneeded .cra_list initializations.

All applied.  Thanks Jussi!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
