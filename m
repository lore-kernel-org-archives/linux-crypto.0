From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH] crypto: padlock-aes: Use the correct mask when checking
 whether copying is required
Date: Mon, 2 Nov 2009 17:26:50 -0500
Message-ID: <20091102172650.6af2d177@katamari.usersys.redhat.com>
References: <200910272325.n9RNPYfr002918@int-mx08.intmail.prod.int.phx2.redhat.com>
	<20091028072559.GA15131@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277AbZKBW2S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Nov 2009 17:28:18 -0500
In-Reply-To: <20091028072559.GA15131@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

crypto: padlock-aes: Use the correct mask when checking whether copying is required

Masking with PAGE_SIZE is just wrong...

Signed-off-by: Chuck Ebbert <cebbert@redhat.com>

--- vanilla-2.6.31.orig/drivers/crypto/padlock-aes.c
+++ vanilla-2.6.31/drivers/crypto/padlock-aes.c
@@ -236,7 +236,7 @@ static inline void ecb_crypt(const u8 *i
 	/* Padlock in ECB mode fetches at least ecb_fetch_bytes of data.
 	 * We could avoid some copying here but it's probably not worth it.
 	 */
-	if (unlikely(((unsigned long)in & PAGE_SIZE) + ecb_fetch_bytes > PAGE_SIZE)) {
+	if (unlikely(((unsigned long)in & ~PAGE_MASK) + ecb_fetch_bytes > PAGE_SIZE)) {
 		ecb_crypt_copy(in, out, key, cword, count);
 		return;
 	}
@@ -248,7 +248,7 @@ static inline u8 *cbc_crypt(const u8 *in
 			    u8 *iv, struct cword *cword, int count)
 {
 	/* Padlock in CBC mode fetches at least cbc_fetch_bytes of data. */
-	if (unlikely(((unsigned long)in & PAGE_SIZE) + cbc_fetch_bytes > PAGE_SIZE))
+	if (unlikely(((unsigned long)in & ~PAGE_MASK) + cbc_fetch_bytes > PAGE_SIZE))
 		return cbc_crypt_copy(in, out, key, iv, cword, count);
 
 	return rep_xcrypt_cbc(in, out, key, iv, cword, count);
