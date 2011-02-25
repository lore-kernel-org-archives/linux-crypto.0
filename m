From: Atul Sowani <sowani@gmail.com>
Subject: [PATCH 2.6.37.2 1/1] crypto: Uninitialized variable fix.
Date: Fri, 25 Feb 2011 23:28:28 +0530
Message-ID: <4D67EDC4.3020103@gmail.com>
Reply-To: sowani@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, gregkh@suse.de
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:34245 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab1BYSA7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Feb 2011 13:00:59 -0500
Received: by pxi15 with SMTP id 15so291472pxi.19
        for <linux-crypto@vger.kernel.org>; Fri, 25 Feb 2011 10:00:59 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Array inter[4] was uninitialized in anubis_crypt() and was causing
compiler warning. Added the array initialization.

Signed-off-by: Atul Sowani <sowani@gmail.com>
---

diff a/crypto/anubis.c b/crypto/anubis.c
--- a/crypto/anubis.c   2011-02-25 04:39:00.000000000 +0530
+++ b/crypto/anubis.c   2011-02-25 23:07:12.000000000 +0530
@@ -578,7 +578,7 @@ static void anubis_crypt(u32 roundKey[AN
         __be32 *dst = (__be32 *)ciphertext;
         int i, r;
         u32 state[4];
-       u32 inter[4];
+       u32 inter[4] = { 0, 0, 0, 0 };

         /*
          * map plaintext block to cipher state (mu)
