From: Haren Myneni <haren@linux.vnet.ibm.com>
Subject: [PATCH] crypto/nx: Update MAINTAINERS entry for 842 compression
Date: Sat, 01 Apr 2017 10:25:40 -0700
Message-ID: <1491067540.29552.39.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, ddstreet@ieee.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53785 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751888AbdDARZr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 1 Apr 2017 13:25:47 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v31HOEg6045321
        for <linux-crypto@vger.kernel.org>; Sat, 1 Apr 2017 13:25:47 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29j8v48bt2-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Sat, 01 Apr 2017 13:25:47 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <haren@linux.vnet.ibm.com>;
        Sat, 1 Apr 2017 11:25:46 -0600
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[PATCH] crypto/nx: Update MAINTAINERS entry for 842 compression

Signed-off-by: Haren Myneni <haren@us.ibm.com>

---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c265a5f..4cfd225 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6211,7 +6211,7 @@ F:	drivers/crypto/nx/nx_csbcpb.h
 F:	drivers/crypto/nx/nx_debugfs.h
 
 IBM Power 842 compression accelerator
-M:	Dan Streetman <ddstreet@ieee.org>
+M:	Haren Myneni <haren@us.ibm.com>
 S:	Supported
 F:	drivers/crypto/nx/Makefile
 F:	drivers/crypto/nx/Kconfig
-- 
1.8.3.1
