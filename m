From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [CRYPTO] xcbc: Fix algorithm leak when block size check fails
Date: Tue, 1 Jan 2008 16:00:20 +1100
Message-ID: <20080101050020.GA31107@gondor.apana.org.au>
References: <20080101044607.GA27124@gondor.apana.org.au> <20080101045004.GA27410@gondor.apana.org.au> <20080101045821.GA30853@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3145 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750722AbYAAFAW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Jan 2008 00:00:22 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J9ZEi-0005Sx-GV
	for <linux-crypto@vger.kernel.org>; Tue, 01 Jan 2008 16:00:20 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1J9ZEi-00086c-00
	for <linux-crypto@vger.kernel.org>; Tue, 01 Jan 2008 16:00:20 +1100
Content-Disposition: inline
In-Reply-To: <20080101045821.GA30853@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 01, 2008 at 03:58:21PM +1100, Herbert Xu wrote:
> 
> In order to see if it still works:
> 
> [CRYPTO] tcrypt: Make xcbc available as a standalone test

It helps to have a break:

[CRYPTO] tcrypt: Make xcbc available as a standalone test

Currently the gcm(aes) tests have to be taken together with all other
algorithms.  This patch makes it available by itself at number 106.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 72073ef..1ab8c01 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -1608,11 +1608,17 @@ static void do_test(void)
 		test_hash("hmac(sha512)", hmac_sha512_tv_template,
 			  HMAC_SHA512_TEST_VECTORS);
 		break;
+
 	case 105:
 		test_hash("hmac(sha224)", hmac_sha224_tv_template,
 			  HMAC_SHA224_TEST_VECTORS);
 		break;
 
+	case 106:
+		test_hash("xcbc(aes)", aes_xcbc128_tv_template,
+			  XCBC_AES_TEST_VECTORS);
+		break;
+
 	case 200:
 		test_cipher_speed("ecb(aes)", ENCRYPT, sec, NULL, 0,
 				  aes_speed_template);

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
