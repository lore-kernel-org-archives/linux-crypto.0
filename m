From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/8] crypto/md4.c: use ARRAY_SIZE
Date: Thu, 13 Nov 2008 21:19:18 +0800
Message-ID: <20081113131918.GB31608@gondor.apana.org.au>
References: <Pine.LNX.4.64.0811091753500.32509@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35789 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751658AbYKMNTZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Nov 2008 08:19:25 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811091753500.32509@ask.diku.dk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 09, 2008 at 05:54:15PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> ARRAY_SIZE is more concise to use when the size of an array is divided by
> the size of its type or the size of its first element.

Applied to cryptodev.  Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
