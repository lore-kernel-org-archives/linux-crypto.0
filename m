From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: dont return PTR_ERR() of wrong pointer
Date: Tue, 4 Jan 2011 15:37:28 +1100
Message-ID: <20110104043728.GB27632@gondor.apana.org.au>
References: <4D1DF505.3040005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
To: roel kluin <roel.kluin@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:38259 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1ADEhg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Jan 2011 23:37:36 -0500
Content-Disposition: inline
In-Reply-To: <4D1DF505.3040005@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 31, 2010 at 04:21:41PM +0100, roel kluin wrote:
> Fix a PTR_ERR() return of the wrong pointer
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
