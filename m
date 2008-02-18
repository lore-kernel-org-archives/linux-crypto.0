From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [2.6.25 patch] CRYPTO_NULL must select CRYPTO_BLKCIPHER
Date: Mon, 18 Feb 2008 08:53:29 +0800
Message-ID: <20080218005329.GB1753@gondor.apana.org.au>
References: <20080217200945.GG1403@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57301 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755485AbYBRAx5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Feb 2008 19:53:57 -0500
Content-Disposition: inline
In-Reply-To: <20080217200945.GG1403@cs181133002.pp.htv.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Feb 17, 2008 at 10:09:45PM +0200, Adrian Bunk wrote:
> This patch fixes the following build error caused by commit 
> 3631c650c495d61b1dabf32eb26b46873636e918:

Patch applied.  Thanks Adrian!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
