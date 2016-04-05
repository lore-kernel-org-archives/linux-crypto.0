From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch] crypto: marvell/cesa - remove unneeded condition
Date: Tue, 5 Apr 2016 20:46:36 +0800
Message-ID: <20160405124636.GG13048@gondor.apana.org.au>
References: <20160321090342.GB31670@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38512 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412AbcDEMqr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 08:46:47 -0400
Content-Disposition: inline
In-Reply-To: <20160321090342.GB31670@mwanda>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 21, 2016 at 12:03:43PM +0300, Dan Carpenter wrote:
> creq->cache[] is an array inside the struct, it's not a pointer and it
> can't be NULL.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
