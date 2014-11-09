From: Stephan Mueller <smueller@chronox.de>
Subject: crypto: zeroization of sensitive data in af_alg
Date: Sun, 09 Nov 2014 23:33:52 +0100
Message-ID: <1979092.odOtqL46qU@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54310 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbaKJHxO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Nov 2014 02:53:14 -0500
Received: from tachyon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S609B> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 10 Nov 2014 08:53:12 +0100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

while working on the AF_ALG interface, I saw no active zeroizations of memory 
that may hold sensitive data that is maintained outside the kernel crypto API 
cipher handles. I think the following memory segments fall under that 
category:

	* message digest

	* IV

	* plaintext / ciphertext handed in by consumer

	* ciphertext / plaintext that is send back to the consumer

May I ask whether such zeroizations are present? At least I did not find it. 
If we conclude that there is a need for adding such zeroizations, I checked 
the code for the appropriate locations:

I think I found the location for the first one: hash_sock_destruct that should 
be enhanced with a memset(0) of ctx->result. I have a patch ready which is 
tested and works.

For the IV, I think I found the spot as well: skcipher_sock_destruct. This 
function should be enhanced with a memset(0) of ctx->iv. Again, I have a patch 
ready which is tested and works.

However, I am failing to find the right spot to add a zeroization for the 
latter one, i.e. the code that handles the pages send in by the user or the 
pages that are returned by the crypto API. Initially I thought 
skcipher_pull_sgl is a good spot for the symmetric ciphers as it evicts the 
used pages out of the scope of the kernel crypto API. I added a 
clear_page(sg_page(sg+1)) as well as memset(sg_page(sg+1), 0, plen) right 
before the put_page call. All that I got in return was a BUG() from the memory 
management layer.

Then I tried the same in af_alg_free_sg() as this function is used by 
algif_hash.c -- with the same result.

That makes me wonder: where should such a zeroization call be added?

Thanks

-- 
Ciao
Stephan
