From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [patch 0/2] merge AES setkey function for i586
Date: Sat, 03 Nov 2007 11:05:03 +0100
Message-ID: <20071102180503.712394234@ml.breakpoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52524 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756185AbXKCKFR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 3 Nov 2007 06:05:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Herbert,

this patch series unifies the AES setkey function for the i586 asm code. 
Now the glue code is equal for aes_{32|64} and can be shared as well.

Sebastian
-- 
