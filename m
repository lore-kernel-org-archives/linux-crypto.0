From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - add a chunking test for cbc(aes)
Date: Tue, 7 Jul 2015 22:00:41 +0800
Message-ID: <20150707140041.GA3302@gondor.apana.org.au>
References: <1436182653-32683-1-git-send-email-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: LABBE Corentin <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:56853 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297AbbGGOAp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jul 2015 10:00:45 -0400
Content-Disposition: inline
In-Reply-To: <1436182653-32683-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 06, 2015 at 01:37:33PM +0200, LABBE Corentin wrote:
> All tests for cbc(aes) use only blocks of data with a multiple of 4.
> This test adds a test with some odd SG size.
> 
> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
