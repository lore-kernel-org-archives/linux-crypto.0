From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Parity Error on keys used for DES crypto test
Date: Wed, 23 Apr 2014 10:20:16 +0200
Message-ID: <535777C0.9090000@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org,
	Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:12215 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbaDWIUS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Apr 2014 04:20:18 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm altering the Freescale Talitos Driver in order to support the SEC1 
security engine, and I have a big issue with the DES test vectors in 
testmgr.h:

The Sec Engine reports key parity error.

Looking at the keys defined in testmgr.h for DES3, it looks like there 
is a real parity issue with the test vectors. A DES key is supposed to 
have all bytes with an odd number of ones. It is not the case in the key 
below. At least the second byte 0xC0 has an even number of ones.

static struct cipher_testvec des3_ede_cbc_enc_tv_template[] = {
     { /* Generated from openssl */
         .key    = "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24"
               "\x44\x4D\x99\x5A\x12\xD6\x40\xC0"
               "\xEA\xC2\x84\xE8\x14\x95\xDB\xE8",

So, how can this test vector work ?

Christophe
