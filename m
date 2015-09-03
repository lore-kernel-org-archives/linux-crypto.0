From: Stephan Mueller <smueller@chronox.de>
Subject: testmgr: templates not tested
Date: Thu, 03 Sep 2015 04:20:01 +0200
Message-ID: <2425525.lUG5gvxoc6@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33776 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbbICCUG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Sep 2015 22:20:06 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

while playing with the testmgr in FIPS mode, I see that ciphers with a 
template are not tested even though test vectors exist.

For example, when allocating cbc(aes-generic) I see records of aes-generic 
(aes) being tested, but I do not see a record of cbc(aes).

Is it intended that such combos of a template/cipher are not tested?

-- 
Ciao
Stephan
