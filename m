Return-Path: <SRS0=jmhz=46=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76BDC4CECE
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 11:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C352E20691
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Mar 2020 11:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZnFQvT+R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgCMLsZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Mar 2020 07:48:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46702 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726535AbgCMLsY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Mar 2020 07:48:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DBk5UI020806;
        Fri, 13 Mar 2020 04:48:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=iOhORA4YhJpqIXrjTBlQWhs2Tua0PdDUYKRjZQVXaS4=;
 b=ZnFQvT+RYi+cV5AmRWBa4nDWHMEufQNJXVN+8D94uaW9A4wBAhSH8rPGbi3iX3kmzm72
 5SOqbHvuykoxI0tOV+i3aJ+Dmbu7ygA5DiYcLniw/zqV5tXFV1iyBIV/TthJ9UxGV+QM
 IuIskJwGMbBGuoJOZ4IJ760u0HCMtKnjDN3UzqoVZjXwelqQm7S1NBK7xbzO5b07hhL9
 5TLuxNkUiWc9O1ukBIEpFSx6tu7YER2JB4FrmxlnmXMtCL9DmD+2jJ5tNi90Ic1Piov3
 Rz3dUW5ylcTBz6PTp9VM3AsWMIuE/TV15sK0fjGKyhMY4doJAY4JVOZqB3iE1prHWnlH Gg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yqt7f3n7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Mar 2020 04:48:16 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 13 Mar
 2020 04:48:14 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 13 Mar 2020 04:48:14 -0700
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id B4C293F7044;
        Fri, 13 Mar 2020 04:48:10 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <pathreya@marvell.com>, <schandran@marvell.com>,
        <arno@natisbad.org>, <bbrezillon@kernel.org>,
        SrujanaChalla <schalla@marvell.com>
Subject: [PATCH v2 4/4] crypto: marvell: enable OcteonTX cpt options for build
Date:   Fri, 13 Mar 2020 17:17:08 +0530
Message-ID: <1584100028-21279-5-git-send-email-schalla@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1584100028-21279-1-git-send-email-schalla@marvell.com>
References: <1584100028-21279-1-git-send-email-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_04:2020-03-12,2020-03-13 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: SrujanaChalla <schalla@marvell.com>

Add the OcteonTX cpt options in crypto Kconfig and Makefile

Signed-off-by: SrujanaChalla <schalla@marvell.com>
---
 drivers/crypto/marvell/Kconfig  | 16 ++++++++++++++++
 drivers/crypto/marvell/Makefile |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/crypto/marvell/Kconfig b/drivers/crypto/marvell/Kconfig
index 8262b14..1306338 100644
--- a/drivers/crypto/marvell/Kconfig
+++ b/drivers/crypto/marvell/Kconfig
@@ -19,3 +19,19 @@ config CRYPTO_DEV_MARVELL_CESA
 	  Security Accelerator (CESA) which can be found on MVEBU and ORION
 	  platforms.
 	  This driver supports CPU offload through DMA transfers.
+
+config CRYPTO_DEV_OCTEONTX_CPT
+	tristate "Support for Marvell OcteonTX CPT driver"
+	depends on ARCH_THUNDER || COMPILE_TEST
+	depends on PCI_MSI && 64BIT
+	depends on CRYPTO_LIB_AES
+	select CRYPTO_SKCIPHER
+	select CRYPTO_HASH
+	select CRYPTO_AEAD
+	select CRYPTO_DEV_MARVELL
+	help
+		This driver allows you to utilize the Marvell Cryptographic
+		Accelerator Unit(CPT) found in OcteonTX series of processors.
+
+		To compile this driver as module, choose M here:
+		the modules will be called octeontx-cpt and octeontx-cptvf
diff --git a/drivers/crypto/marvell/Makefile b/drivers/crypto/marvell/Makefile
index 2030b0b..6c6a151 100644
--- a/drivers/crypto/marvell/Makefile
+++ b/drivers/crypto/marvell/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-$(CONFIG_CRYPTO_DEV_MARVELL_CESA) += cesa/
+obj-$(CONFIG_CRYPTO_DEV_OCTEONTX_CPT) += octeontx/
-- 
1.9.1

