From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/2] crypto: aead - Fix aead_instance memory overrun
Date: Thu, 18 Jun 2015 13:59:59 +0800
Message-ID: <20150618055959.GA28242@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47242 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbbFRGAC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Jun 2015 02:00:02 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

I just noticed that the code for struct aead_instance allocation
is wrong.  The problem is that struct aead_instance doesn't contain
the full amount of space required.  For ahash/shash this is dealt
with by calculating the size by adding head space to the size of
struct crypto_instance.  Unfortunately we didn't do that for AEAD.

These two patches fix this in a slightly different way.  We will
enlarge struct aead_instance so that it contains the actual amount
of space required.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
