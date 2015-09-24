From: John Haxby <john.haxby@oracle.com>
Subject: [PATCHv2 0/1] fips-allowed tests fail with non-FIPS ciphers
Date: Thu, 24 Sep 2015 18:24:34 +0100
Message-ID: <1443115475-27398-1-git-send-email-john.haxby@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	John Haxby <john.haxby@oracle.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ukc1-proxy-mwg04-o.oracle.com ([144.24.20.229]:18615 "EHLO
	sheep.uk.oracle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754852AbbIXRZS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Sep 2015 13:25:18 -0400
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

Stepham Mueller pointed out that no authenc() ciphers are FIPS
approved and that ecb(des) also managed to get .fips_approved set.
The following patch removes fips_allowed for all those patches.

Again, Stephan pointed out that ansi_cprng will need to be taken off
the allowed list at the end of the year.  This patch doesn't pre-empt
that.

jch

John Haxby (1):
  Disable fips-allowed for authenc() and des() ciphers

 crypto/testmgr.c | 16 ----------------
 1 file changed, 16 deletions(-)

-- 
2.4.3
