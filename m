From: John Haxby <john.haxby@oracle.com>
Subject: [PATCH 0/1] fips-allowed tests fail with non-FIPS ciphers
Date: Thu, 24 Sep 2015 17:02:02 +0100
Message-ID: <1443110523-23473-1-git-send-email-john.haxby@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	John Haxby <john.haxby@oracle.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ukc1-proxy-mwg04-o.oracle.com ([144.24.20.229]:44520 "EHLO
	sheep.uk.oracle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757189AbbIXQT3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Sep 2015 12:19:29 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello All,

"Make fips=1 work on 4.1", they said, wittily, "it'll be easy."

I suppose it wasn't that complicated, although I seem to be unearthing
other problems as I go along.  The first problem was dracut (and I owe
an upstream patch for that) and the second problem was tcrypt.

The tcrypt module was failing on authenc ciphers that wrap non-FIPS
ciphers and hashes.  These ones in fact:

    authenc(hmac(md5),ecb(cipher_null))
    authenc(hmac(sha1),cbc(des))
    authenc(hmac(sha1),ecb(cipher_null))
    authenc(hmac(sha224),cbc(des))
    authenc(hmac(sha256),cbc(des))
    authenc(hmac(sha384),cbc(des))
    authenc(hmac(sha512),cbc(des))

I'm fairly sure that wrapping des, cipher_null and md5 in authenc
shouldn't make them fips-allowed so the following patch simply removes
that.

Interestingly, some of these just failed outright and others just sat
there chewing CPU time.  I think that's just a curiousity though,
rather than a problem.

jch

John Haxby (1):
  Disable fips-allowed for non-FIPS authenc ciphers

 crypto/testmgr.c | 7 -------
 1 file changed, 7 deletions(-)

-- 
2.4.3
