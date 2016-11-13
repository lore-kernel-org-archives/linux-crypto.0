From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 0/16] crypto: skcipher - skcipher algorithm conversion
 part 3
Date: Sun, 13 Nov 2016 19:43:54 +0800
Message-ID: <20161113114354.GA8169@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47697 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932371AbcKMLoB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Nov 2016 06:44:01 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi:

v2 fixes a number of bugs in the skcipher walk code.

This patch series is the third instalment of the skcipher conversion.

It introduces the skcipher walk interface, and converts a number of
core algorithms such as CBC and LRW/XTS, as well as the aesni on x86
and various ARM aes implementations.

It also adds an skcipher version of cryptd, as well as making
testmgr skip all internal algorithms when testing.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
