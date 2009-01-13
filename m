From: Dean Jenkins <djenkins@mvista.com>
Subject: Re: kernel BUG at crypto/scatterwalk.c:37! when using modified
	tcrypt for HMAC testing
Date: Tue, 13 Jan 2009 14:46:14 +0000
Message-ID: <1231857974.7937.74.camel@libdev3.mvista.co.uk>
References: <20090113003704.GA13775@gondor.apana.org.au>
Reply-To: djenkins@mvista.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-bwoIYtGCYT0N0FosFfyL"
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [63.81.120.158] ([63.81.120.158]:29520 "EHLO
	gateway-1237.mvista.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756371AbZAMOqM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2009 09:46:12 -0500
In-Reply-To: <20090113003704.GA13775@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--=-bwoIYtGCYT0N0FosFfyL
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Herbert,

Many thanks that fixed it.

Regards,

Dean Jenkins
MontaVista Software

--=-bwoIYtGCYT0N0FosFfyL
Content-Disposition: inline
Content-Description: Forwarded message - Re: kernel BUG at
	crypto/scatterwalk.c:37! when using modified tcrypt for HMAC testing
Content-Type: message/rfc822

Return-Path: <herbert@gondor.apana.org.au>
Received: from hermes.mvista.com ([unix socket]) by hermes.mvista.com
	(Cyrus v2.2.3-Invoca-RPM-2.2.3-4) with LMTP; Mon, 12 Jan 2009 16:37:40 -0800
X-Sieve: CMU Sieve 2.2
Received: from dune.mvista.com (unknown [10.20.1.91]) by hermes.mvista.com
	(Postfix) with ESMTP id 342E818A4B for <djenkins@mvista.com>; Mon, 12 Jan
	2009 16:37:39 -0800 (PST)
Received: (qmail 26310 invoked from network); 13 Jan 2009 00:37:38 -0000
X-Spam-Checker-Version: SpamAssassin 3.1.7 (2006-10-05) on thoth.mvista.com
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=5.0 tests=AWL,BAYES_00,
	USER_IN_WHITELIST_TO autolearn=ham version=3.1.7
Received: from unknown (HELO arnor.apana.org.au) (64.62.148.172) by
	dune.mvista.com with DES-CBC3-SHA encrypted SMTP; 13 Jan 2009 00:37:09 -0000
Received: from gondolin.me.apana.org.au ([192.168.0.6]) by
	arnor.apana.org.au with esmtp (Exim 4.63 #1 (Debian)) id 1LMXHG-0008T1-S4;
	Tue, 13 Jan 2009 11:37:07 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 4.69)
	(envelope-from <herbert@gondor.apana.org.au>) id 1LMXHF-0003aP-CH; Tue, 13
	Jan 2009 11:37:05 +1100
Date: Tue, 13 Jan 2009 11:37:04 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: djenkins@mvista.com
Cc: linux-crypto@vger.kernel.org
Subject: Re: kernel BUG at crypto/scatterwalk.c:37! when using modified
	tcrypt for HMAC testing
Message-ID: <20090113003704.GA13775@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Content-Transfer-Encoding: 7bit

Dean Jenkins <djenkins@mvista.com> wrote:
>
> I'm using a 2.6.27.4 kernel on an armv5te platform.
> 
> I hit a BUG() at crypto/scatterwalk.c:37 that indicates that the scatterlist 
> length is zero.
> 
> I've traced this back to crypto/authenc.c function crypto_authenc_genicv()...

Does this patch fix it?

commit 700aa8bfa071875cda833f44491d3548ad79951e
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Tue Jan 13 11:26:18 2009 +1100

    crypto: authenc - Fix zero-length IV crash
    
    As it is if an algorithm with a zero-length IV is used (e.g.,
    NULL encryption) with authenc, authenc may generate an SG entry
    of length zero, which will trigger a BUG check in the hash layer.
    
    This patch fixes it by skipping the IV SG generation if the IV
    size is zero.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 40b6e9e..5793b64 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -158,16 +158,19 @@ static int crypto_authenc_genicv(struct aead_request *req, u8 *iv,
 	dstp = sg_page(dst);
 	vdst = PageHighMem(dstp) ? NULL : page_address(dstp) + dst->offset;
 
-	sg_init_table(cipher, 2);
-	sg_set_buf(cipher, iv, ivsize);
-	authenc_chain(cipher, dst, vdst == iv + ivsize);
+	if (ivsize) {
+		sg_init_table(cipher, 2);
+		sg_set_buf(cipher, iv, ivsize);
+		authenc_chain(cipher, dst, vdst == iv + ivsize);
+		dst = cipher;
+	}
 
 	cryptlen = req->cryptlen + ivsize;
-	hash = crypto_authenc_hash(req, flags, cipher, cryptlen);
+	hash = crypto_authenc_hash(req, flags, dst, cryptlen);
 	if (IS_ERR(hash))
 		return PTR_ERR(hash);
 
-	scatterwalk_map_and_copy(hash, cipher, cryptlen,
+	scatterwalk_map_and_copy(hash, dst, cryptlen,
 				 crypto_aead_authsize(authenc), 1);
 	return 0;
 }
@@ -285,11 +288,14 @@ static int crypto_authenc_iverify(struct aead_request *req, u8 *iv,
 	srcp = sg_page(src);
 	vsrc = PageHighMem(srcp) ? NULL : page_address(srcp) + src->offset;
 
-	sg_init_table(cipher, 2);
-	sg_set_buf(cipher, iv, ivsize);
-	authenc_chain(cipher, src, vsrc == iv + ivsize);
+	if (ivsize) {
+		sg_init_table(cipher, 2);
+		sg_set_buf(cipher, iv, ivsize);
+		authenc_chain(cipher, src, vsrc == iv + ivsize);
+		src = cipher;
+	}
 
-	return crypto_authenc_verify(req, cipher, cryptlen + ivsize);
+	return crypto_authenc_verify(req, src, cryptlen + ivsize);
 }
 
 static int crypto_authenc_decrypt(struct aead_request *req)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--=-bwoIYtGCYT0N0FosFfyL--

