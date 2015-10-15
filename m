From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: testmgr: test IV value after a cipher
 operation
Date: Thu, 15 Oct 2015 21:18:35 +0800
Message-ID: <20151015131835.GA3981@gondor.apana.org.au>
References: <1434448007-9537-1-git-send-email-boris.brezillon@free-electrons.com>
 <1434448007-9537-2-git-send-email-boris.brezillon@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40388 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbbJONSn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 15 Oct 2015 09:18:43 -0400
Content-Disposition: inline
In-Reply-To: <1434448007-9537-2-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 16, 2015 at 11:46:46AM +0200, Boris Brezillon wrote:
> The crypto drivers are supposed to update the IV passed to the crypto
> request before calling the completion callback.
> Test for the IV value before considering the test as successful.
> 
> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Patch applied with s/ablkcipher/skcipher/ as pointed out by Stephan.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
