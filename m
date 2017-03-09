From: Fabien Dessenne <fabien.dessenne@st.com>
Subject: [PATCH] crypto: doc - fix typo (struct sdesc)
Date: Thu, 9 Mar 2017 10:40:05 +0100
Message-ID: <1489052405-405-1-git-send-email-fabien.dessenne@st.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:52251 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1753635AbdCIJkf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 04:40:35 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id v299Qgpp015135
        for <linux-crypto@vger.kernel.org>; Thu, 9 Mar 2017 10:40:11 +0100
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-.pphosted.com with ESMTP id 28yu0h4d81-1
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Thu, 09 Mar 2017 10:40:11 +0100
Received: from zeta.dmz-eu.st.com (zeta.dmz-eu.st.com [164.129.230.9])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 2DC9634
        for <linux-crypto@vger.kernel.org>; Thu,  9 Mar 2017 09:40:10 +0000 (GMT)
Received: from Webmail-eu.st.com (Safex1hubcas23.st.com [10.75.90.46])
        by zeta.dmz-eu.st.com (STMicroelectronics) with ESMTP id E2B562670
        for <linux-crypto@vger.kernel.org>; Thu,  9 Mar 2017 09:40:10 +0000 (GMT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add missing " " in api-samples.rst

Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
---
 Documentation/crypto/api-samples.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/crypto/api-samples.rst b/Documentation/crypto/api-samples.rst
index 0a10819..d021fd9 100644
--- a/Documentation/crypto/api-samples.rst
+++ b/Documentation/crypto/api-samples.rst
@@ -155,9 +155,9 @@ Code Example For Use of Operational State Memory With SHASH
         char ctx[];
     };
 
-    static struct sdescinit_sdesc(struct crypto_shash *alg)
+    static struct sdesc init_sdesc(struct crypto_shash *alg)
     {
-        struct sdescsdesc;
+        struct sdesc sdesc;
         int size;
 
         size = sizeof(struct shash_desc) + crypto_shash_descsize(alg);
@@ -172,7 +172,7 @@ Code Example For Use of Operational State Memory With SHASH
     static int calc_hash(struct crypto_shashalg,
                  const unsigned chardata, unsigned int datalen,
                  unsigned chardigest) {
-        struct sdescsdesc;
+        struct sdesc sdesc;
         int ret;
 
         sdesc = init_sdesc(alg);
-- 
2.7.4
