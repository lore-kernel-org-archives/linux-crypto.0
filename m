From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/4] crypto: talitos - avoid memleak in
 talitos_alg_alloc()
Date: Wed, 13 May 2015 11:20:09 +0800
Message-ID: <20150513032009.GC24980@gondor.apana.org.au>
References: <1431363804-2331-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Horia Geanta <horia.geanta@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38172 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933994AbbEMDUM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 May 2015 23:20:12 -0400
Content-Disposition: inline
In-Reply-To: <1431363804-2331-1-git-send-email-horia.geanta@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 11, 2015 at 08:03:24PM +0300, Horia Geanta wrote:
> Cc: <stable@vger.kernel.org> # 3.2+
> Fixes: 1d11911a8c57 ("crypto: talitos - fix warning: 'alg' may be used uninitialized in this function")
> Signed-off-by: Horia Geanta <horia.geanta@freescale.com>

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
