From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/3] crypto: aesni - fix and re-enable "by8" CTR variant
Date: Sun, 28 Sep 2014 22:23:58 +0200
Message-ID: <1411935841-11294-1-git-send-email-minipli@googlemail.com>
Cc: Chandramouli Narayanan <mouli@linux.intel.com>,
	linux-crypto@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:62804 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaI1UYX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 28 Sep 2014 16:24:23 -0400
Received: by mail-we0-f181.google.com with SMTP id u57so427855wes.26
        for <linux-crypto@vger.kernel.org>; Sun, 28 Sep 2014 13:24:22 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This series fixes the counter overflow handling of the "by8" CTR variant
which lead to failing cryptomgr tests and, in turn, disabling this
optimization with commit 7da4b29d496b.

Patch 1 fixes the bug, patch 2 removes some unused defines (left overs
from the unification of the initial source files) and patch 3 re-enables
the code.

The fix was tested by me, doing tcrypt and dm-crypt tests. It was also
tested by Romain who initially reported the issue.

The patches should go on top of crypto-2.6.git.

In case this doesn't get merged for v3.17, patches 1 and 3 may be cc'ed
to stable to propagate the fix.

Please apply!

Thanks,
Mathias


Mathias Krause (3):
  crypto: aesni - fix counter overflow handling in "by8" variant
  crypto: aesni - remove unused defines in "by8" variant
  Revert "crypto: aesni - disable "by8" AVX CTR optimization"

 arch/x86/crypto/aes_ctrby8_avx-x86_64.S |   20 +++++++++++++++-----
 arch/x86/crypto/aesni-intel_glue.c      |    4 ++--
 2 files changed, 17 insertions(+), 7 deletions(-)

-- 
1.7.10.4
