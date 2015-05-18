From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: remove 842-nx null checks
Date: Mon, 18 May 2015 12:25:39 +0800
Message-ID: <20150518042539.GA13238@gondor.apana.org.au>
References: <20150515070424.GA17008@gondor.apana.org.au>
 <1431702453-12118-1-git-send-email-ddstreet@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35883 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbbEREZp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2015 00:25:45 -0400
Content-Disposition: inline
In-Reply-To: <1431702453-12118-1-git-send-email-ddstreet@ieee.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 15, 2015 at 11:07:33AM -0400, Dan Streetman wrote:
> Remove the null checks for tfm, src, slen, dst, dlen; tfm will never
> be null and the other fields are always expected to be set correctly.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
