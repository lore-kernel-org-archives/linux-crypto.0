From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [revised PATCH] crypto: Correct kzalloc error test
Date: Wed, 30 Apr 2008 00:27:58 +0800
Message-ID: <20080429162758.GA21883@gondor.apana.org.au>
References: <E1JqqUc-0005Rg-00@gondolin.me.apana.org.au> <Pine.LNX.4.58.0804291617210.1185@pc-041.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:33378 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753891AbYD2Q2F (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 29 Apr 2008 12:28:05 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0804291617210.1185@pc-041.diku.dk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 29, 2008 at 04:18:08PM +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Normally, kzalloc returns NULL or a valid pointer value, not a value to be
> tested using IS_ERR.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Patch applied.  Thanks Julia!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
