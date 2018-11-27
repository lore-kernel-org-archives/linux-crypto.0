Return-Path: <SRS0=NopL=OG=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36886 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731508AbeK1E1y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Nov 2018 23:27:54 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wARHTArE065457
        for <linux-crypto@vger.kernel.org>; Tue, 27 Nov 2018 12:29:17 -0500
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2p172v9uyj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-crypto@vger.kernel.org>; Tue, 27 Nov 2018 12:29:17 -0500
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-crypto@vger.kernel.org> from <pfsmorigo@linux.vnet.ibm.com>;
        Tue, 27 Nov 2018 17:29:16 -0000
From: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Breno Leitao <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] MAINTAINERS: change NX/VMX maintainers
Date: Tue, 27 Nov 2018 15:27:21 -0200
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Message-Id: <20181127172739.24621-1-pfsmorigo@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add Breno and Nayna as NX/VMX crypto driver maintainers. Also change my
email address to my personal account and remove Leonidas since he's not
working with the driver anymore.

Signed-off-by: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
---
 MAINTAINERS | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 380e43f585d3..b7a4da8f2e33 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7017,8 +7017,9 @@ F:	crypto/842.c
 F:	lib/842/
 
 IBM Power in-Nest Crypto Acceleration
-M:	Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
-M:	Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
+M:	Breno Leitão <leitao@debian.org>
+M:	Nayna Jain <nayna@linux.ibm.com>
+M:	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	drivers/crypto/nx/Makefile
@@ -7084,8 +7085,9 @@ S:	Supported
 F:	drivers/scsi/ibmvscsi_tgt/
 
 IBM Power VMX Cryptographic instructions
-M:	Leonidas S. Barbosa <leosilva@linux.vnet.ibm.com>
-M:	Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
+M:	Breno Leitão <leitao@debian.org>
+M:	Nayna Jain <nayna@linux.ibm.com>
+M:	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
 L:	linux-crypto@vger.kernel.org
 S:	Supported
 F:	drivers/crypto/vmx/Makefile
-- 
2.14.4
