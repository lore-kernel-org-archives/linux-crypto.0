From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [CRYPTO] api: Flush the current page right than the next
Date: Sat, 31 Mar 2007 12:59:32 +1000
Message-ID: <20070331025932.GA552@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4193 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933509AbXCaC7e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 30 Mar 2007 22:59:34 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1HXToT-0001ER-5C
	for <linux-crypto@vger.kernel.org>; Sat, 31 Mar 2007 12:59:33 +1000
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1HXToS-000095-00
	for <linux-crypto@vger.kernel.org>; Sat, 31 Mar 2007 12:59:32 +1000
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi:

While looking at the scatterlist_copychunks bug I noticed that we're
flushing the wrong page.

[CRYPTO] api: Flush the current page right than the next

On platforms where flush_dcache_page is needed we're currently flushing
the next page right than the one we've just processed.  This patch fixes
the off-by-one error.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 0f76175..81afd17 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -59,8 +59,12 @@ EXPORT_SYMBOL_GPL(scatterwalk_map);
 static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 				 unsigned int more)
 {
-	if (out)
-		flush_dcache_page(scatterwalk_page(walk));
+	if (out) {
+		struct page *page;
+
+		page = walk->sg->page + ((walk->offset - 1) >> PAGE_SHIFT);
+		flush_dcache_page(page);
+	}
 
 	if (more) {
 		walk->offset += PAGE_SIZE - 1;
