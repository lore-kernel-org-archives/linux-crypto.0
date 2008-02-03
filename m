From: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: [patch 0/3] Shrink the tcrypt module and fix one XTEA test vector
Date: Sun, 03 Feb 2008 13:55:24 +0100
Message-ID: <20080203125524.339000971@breakoint.cc>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:34766 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763705AbYBCNRa (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Feb 2008 08:17:30 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

I noticed that the tcrypt module got really fat. Don't worry, it is still
less than the nvidia blob :)
Patch
- #1 replaces the memcpy of the struct to something that works with
  pointers. I noticed that some tests failed without doing this.
- #2 is the big diet. A copy of the patch is at [1] in case it does not
  pass the list filters.
- #3 changes one of the XTEA test vectors because the test vector itself
  seems to be wrong (and nobody noticed this before).


[1] http://download.breakpoint.cc/0002-crypto-shrink-the-tcrypt-module.patch 575 KiB

Sebastian
-- 
