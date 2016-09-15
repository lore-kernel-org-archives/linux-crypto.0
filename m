From: Stephan Mueller <stephan.mueller@atsec.com>
Subject: [RFC] revamp fips_allowed flag
Date: Thu, 15 Sep 2016 07:35:43 +0200
Message-ID: <1818375.56xtGUSNII@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.atsec.com ([138.201.47.226]:8757 "EHLO mail1.atsec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755693AbcIOFpw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 01:45:52 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

The fips_allowed flag in testmgr.c shall prevent the use of "non-approved" 
ciphers in FIPS mode.

With the current code, the fips_allowed flag is bound to a name a specific 
cipher is referenced with. With the advent of more complex cipher string names 
that can be used (for example, consider names like 
"seqiv(rfc4106(gcm_base(ctr-aes-s390,ghash-generic)))", the authenc ciphers 
with the two components or even the recently added pkcspad1 algorithm), it 
seems that the approach in testmgr.c reached its limits. Lately more and more 
entries in the alg_test_descs array were added purely to have the fips_allowed 
flag set.

Wouldn't it be more prudent to move that flag into the crypto_alg and 
crypto_template data structures so that the flag is checked during the 
crypto_register_* functions? I.e. if the flag is not set and the FIPS mode is 
enabled, the cipher is simply not registered?

With that, suggestion, the fips_allowed flag is now decoupled from the cipher 
name. Complex cipher strings would now not be falsely treated as non-approved 
ciphers any more.

Ciao
Stephan
-- 
atsec information security GmbH, Steinstraße 70, 81667 München, Germany
P: +49 89 442 49 830 - F: +49 89 442 49 831
M: +49 172 216 55 78 - HRB: 129439 (Amtsgericht München)
US: +1 949 545 4096
GF: Salvatore la Pietra, Staffan Persson
atsec it security news blog - atsec-information-security.blogspot.com
