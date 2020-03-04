Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A02D8C3F2D1
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 12:26:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73F5E2146E
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 12:26:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Tpm6kyZE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbgCDM0B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 07:26:01 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:18250 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729256AbgCDM0A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 07:26:00 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 024CAkG1014133;
        Wed, 4 Mar 2020 04:25:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=KdGZHKL53hAmdh213CBwe/4O3H7TKpykrhR4SbwdT5k=;
 b=Tpm6kyZEUive1uMHPrm6EwQEc9RW8P1ThDKrHDQBc9Vb8J2a+s3By6x/WTNdSuX7C6gx
 R7MSR8xdkTwVrYXyXiVvFe616OHYq7Phdv0BXNH8Wj96Y7jM45WLKVKdncl7wPL/w1HA
 MDzRgSAdBoKRhb05/6NWwRw1zRmkOblybrpKrTMt2wG8ihCuiMkPoEx5o3/rPT52PQu+
 aIvXIZDC1QjkCLccXn6gZulHV9+KIoI7AdO3Klwcio4yMiRHeck+w8DaoE+klwh6dac7
 Z6yXvyZ6qOr0Ef/5AXa91JmPUN/I3Uggj0Spz0yJKsdX3ZM7FjJrGBgR9oiEdJHyYoG/ vw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2yhxw4c3vg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 04 Mar 2020 04:25:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Mar
 2020 04:25:44 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 4 Mar
 2020 04:25:44 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 4 Mar 2020 04:25:43 -0800
Received: from hyd1schalla-dt.marvell.com (hyd1schalla-dt.marvell.com [10.29.8.39])
        by maili.marvell.com (Postfix) with ESMTP id 2528E3F703F;
        Wed,  4 Mar 2020 04:25:41 -0800 (PST)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>
CC:     <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <pathreya@marvell.com>, SrujanaChalla <schalla@marvell.com>
Subject: [PATCH 4/4] crypto: marvell: enable OcteonTX cpt options for build
Date:   Wed, 4 Mar 2020 17:55:16 +0530
Message-ID: <1583324716-23633-5-git-send-email-schalla@marvell.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1583324716-23633-1-git-send-email-schalla@marvell.com>
References: <1583324716-23633-1-git-send-email-schalla@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_03:2020-03-04,2020-03-04 signatures=0
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
index 9f09845..4930f1a 100644
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
+	select CRYPTO_BLKCIPHER
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

