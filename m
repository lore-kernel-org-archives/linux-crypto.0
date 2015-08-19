From: Stephan Mueller <smueller@chronox.de>
Subject: Recent AEAD change: testmgr.c change needed?
Date: Wed, 19 Aug 2015 11:48:05 +0200
Message-ID: <1732898.70JpgbIL8N@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48133 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbbHSJsJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2015 05:48:09 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

The recent AEAD change seems to trigger a need to change something in 
testmgr.c. I ran my test tool trying to invoke all possible permutations of 
cra_name and cra_driver_name ciphers and got the following:

[11152.816179] alg: No test for gcm_base(ctr(aes-asm),ghash-generic) 
(gcm_base(ctr(aes-asm),ghash-generic))
[11154.278466] alg: No test for ccm_base(ctr(aes-asm),aes-asm) 
(ccm_base(ctr(aes-asm),aes-asm))
[11174.819535] alg: No test for gcm(aes-asm) (gcm_base(ctr(aes-asm),ghash-
clmulni))
[11174.819610] alg: No test for rfc4106(gcm(aes-asm)) 
(rfc4106(gcm_base(ctr(aes-asm),ghash-clmulni)))
[11174.819654] alg: No test for seqiv(rfc4106(gcm(aes-asm))) 
(seqiv(rfc4106(gcm_base(ctr(aes-asm),ghash-clmulni))))
[11192.292759] alg: No test for gcm_base(ctr-aes-aesni,ghash-clmulni) 
(gcm_base(ctr-aes-aesni,ghash-clmulni))
[11193.775049] alg: No test for ccm_base(ctr-aes-aesni,aes-aesni) 
(ccm_base(ctr-aes-aesni,aes-aesni))
[11213.936196] alg: No test for gcm(aes-aesni) (gcm_base(ctr(aes-aesni),ghash-
clmulni))
[11213.936308] alg: No test for rfc4106(gcm(aes-aesni)) 
(rfc4106(gcm_base(ctr(aes-aesni),ghash-clmulni)))
[11213.936418] alg: No test for seqiv(rfc4106(gcm(aes-aesni))) 
(seqiv(rfc4106(gcm_base(ctr(aes-aesni),ghash-clmulni))))
[11252.498078] alg: No test for seqiv(rfc4106(gcm(aes))) (seqiv(rfc4106-gcm-
aesni))
[11270.222200] alg: No test for gcm_base(ctr(aes-generic),ghash-generic) 
(gcm_base(ctr(aes-generic),ghash-generic))
[11271.602667] alg: No test for ccm_base(ctr(aes-generic),aes-generic) 
(ccm_base(ctr(aes-generic),aes-generic))


Albeit this listing is a nuisance in normal operation, it becomes fatal in 
fips=1 mode.

I guess we have to add all the listed ciphers into the big array in testmgr.c. 
If you concur, I could prepare a patch.

-- 
Ciao
Stephan
