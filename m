From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [PATCH 0/2] fix authenc() kernel crash
Date: Sun, 24 Sep 2017 08:22:54 +0200
Message-ID: <3874163.dZU00zCVt8@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34932 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751149AbdIXGZt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Sep 2017 02:25:49 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

The two patches together fix a kernel crash that can be triggered via
AF_ALG when using authenc() with zero plaintext.

The changes are also tested to verify that the hashing on null data
is still supported.

I suspect that the vulnerability fixed with patch 1 is present in
abklcipher that was used before the switch to skcipher. Thus, I would
suspect in older kernels that this vulnerability is still present.
Could you please provide guidance on how to address that issue in such
older kernels?

Stephan Mueller (2):
  crypto: skcipher - noop for enc/dec with NULL data
  crypto: shash - no kmap of zero SG

 crypto/shash.c            | 4 +++-
 include/crypto/skcipher.h | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

-- 
2.13.5
