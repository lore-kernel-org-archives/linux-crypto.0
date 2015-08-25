From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aead - fix for multiple operations on AF_ALG
 sockets
Date: Tue, 25 Aug 2015 21:16:22 +0800
Message-ID: <20150825131622.GA13824@gondor.apana.org.au>
References: <1440496755-15105-1-git-send-email-larper@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Lars Persson <larper@axis.com>
To: Lars Persson <lars.persson@axis.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36416 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbbHYNQ3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 25 Aug 2015 09:16:29 -0400
Content-Disposition: inline
In-Reply-To: <1440496755-15105-1-git-send-email-larper@axis.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 25, 2015 at 11:59:15AM +0200, Lars Persson wrote:
> The tsgl scatterlist must be re-initialized after each
> operation. Otherwise the sticky bits in the page_link will corrupt the
> list with pre-mature termination or false chaining.
> 
> Signed-off-by: Lars Persson <larper@axis.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
