From: Benjamin Peterson <bp@benjamin.pe>
Subject: [PATCH] crypto: fix typo in docs
Date: Sun, 18 Jun 2017 23:53:41 -0700
Message-ID: <20170619065341.14100-1-bp@benjamin.pe>
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37519 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751013AbdFSHAx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 03:00:53 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Benjamin Peterson <bp@benjamin.pe>
---
 Documentation/crypto/userspace-if.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index de5a72e32bc9..ff86befa61e0 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -327,7 +327,7 @@ boundary. Non-aligned data can be used as well, but may require more
 operations of the kernel which would defeat the speed gains obtained
 from the zero-copy interface.
 
-The system-interent limit for the size of one zero-copy operation is 16
+The system-inherent limit for the size of one zero-copy operation is 16
 pages. If more data is to be sent to AF_ALG, user space must slice the
 input into segments with a maximum size of 16 pages.
 
-- 
2.11.0
