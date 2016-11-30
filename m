From: Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH 4/4] MAINTAINERS: add crypto headers to crypto entry
Date: Wed, 30 Nov 2016 15:16:11 +0200
Message-ID: <367c581cc2b60e684e08ff0660f14795ed72e939.1480511771.git.baruch@tkos.co.il>
References: <900b42a57c35095988dcad0c1eb366da0fa71c05.1480511771.git.baruch@tkos.co.il>
Cc: linux-crypto@vger.kernel.org, Baruch Siach <baruch@tkos.co.il>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from guitar.tcltek.co.il ([192.115.133.116]:54102 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753688AbcK3NQY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Nov 2016 08:16:24 -0500
In-Reply-To: <900b42a57c35095988dcad0c1eb366da0fa71c05.1480511771.git.baruch@tkos.co.il>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 8d4148406923..dba40107aca4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3425,6 +3425,7 @@ F:	arch/*/crypto/
 F:	crypto/
 F:	drivers/crypto/
 F:	include/crypto/
+F:	include/linux/crypto*
 
 CRYPTOGRAPHIC RANDOM NUMBER GENERATOR
 M:	Neil Horman <nhorman@tuxdriver.com>
-- 
2.10.2
