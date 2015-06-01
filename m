From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: scatterwalk - Hide PageSlab call to optimise away
 flush_dcache_page
Date: Mon, 1 Jun 2015 16:22:03 +0800
Message-ID: <20150601082203.GA11946@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: "David S. Miller" <davem@davemloft.net>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39136 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbbFAIWK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 04:22:10 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On architectures where flush_dcache_page is not needed, we will
end up generating all the code up to the PageSlab call.  This is
because PageSlab operates on a volatile pointer and thus cannot
be optimised away.
    
This patch works around this by checking whether flush_dcache_page
is needed before we call PageSlab which then allows PageSlab to be
compiled awy.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 2ef9cbb..ea5815c 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -54,7 +54,11 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 		struct page *page;
 
 		page = sg_page(walk->sg) + ((walk->offset - 1) >> PAGE_SHIFT);
-		if (!PageSlab(page))
+		/* Test ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE first as
+		 * PageSlab cannot be optimised away per se due to
+		 * use of volatile pointer.
+		 */
+		if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE && !PageSlab(page))
 			flush_dcache_page(page);
 	}
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
