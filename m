From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH 0/6] crypto: talitos - various fixes
Date: Thu, 21 Sep 2017 09:19:45 +0200 (CEST)
Message-ID: <cover.1575825623.git.christophe.leroy@c-s.fr>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:24820 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751484AbdIUHTr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2017 03:19:47 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 3xySfY2nHdz9ttBX
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:33 +0200 (CEST)
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id PdIuVnLgq-mK for <linux-crypto@vger.kernel.org>;
        Thu, 21 Sep 2017 09:19:33 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 3xySfY1LJGz9ttBK
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2017 09:19:33 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This serie provide various fixes on the talitos driver.

Christophe Leroy (6):
  crypto: talitos - Don't provide setkey for non hmac hashing algs.
  crypto: talitos - fix hashing
  crypto: talitos - fix sha224
  crypto: talitos - fix AEAD test failures
  crypto: talitos - use kzalloc instead of kmalloc
  crypto: talitos - fix memory corruption on SEC2

 drivers/crypto/talitos.c | 81 +++++++++++++++++++++---------------------------
 drivers/crypto/talitos.h |  2 --
 2 files changed, 36 insertions(+), 47 deletions(-)

-- 
2.13.3
