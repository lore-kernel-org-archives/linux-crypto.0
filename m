From: Kevin Mulvey <kevin@kevinmulvey.net>
Subject: [PATCH] Documentation: "kerneli" typo in description for "Serpent cipher algorithm" Bug #60848
Date: Wed,  2 Oct 2013 12:10:37 -0400
Message-ID: <1380730237-42543-1-git-send-email-kevin@kevinmulvey.net>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Kevin Mulvey <kevin@kevinmulvey.net>
To: rob@landley.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qe0-f41.google.com ([209.85.128.41]:38928 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab3JBQKn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Oct 2013 12:10:43 -0400
Received: by mail-qe0-f41.google.com with SMTP id 1so728628qee.0
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2013 09:10:43 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

change kerneli to kernel as well as kerneli.org to kernel.org

Signed-off-by: Kevin Mulvey <kevin@kevinmulvey.net>
---
 Documentation/crypto/api-intro.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/crypto/api-intro.txt b/Documentation/crypto/api-intro.txt
index 8b49302..94c2e8c 100644
--- a/Documentation/crypto/api-intro.txt
+++ b/Documentation/crypto/api-intro.txt
@@ -155,7 +155,7 @@ of the API:
 
 Portions of this API were derived from the following projects:
   
-  Kerneli Cryptoapi (http://www.kerneli.org/)
+  Kernel Cryptoapi (http://www.kernel.org/)
     Alexander Kjeldaas
     Herbert Valerio Riedel
     Kyle McMartin
-- 
1.8.1.4
