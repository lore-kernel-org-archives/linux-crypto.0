Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7146DC282DA
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 12:35:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 43564218D0
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 12:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfDOMff (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 08:35:35 -0400
Received: from [110.188.70.11] ([110.188.70.11]:52202 "EHLO spam2.hygon.cn"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726094AbfDOMff (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 08:35:35 -0400
X-Greylist: delayed 1573 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Apr 2019 08:35:34 EDT
Received: from spam2.hygon.cn (localhost [127.0.0.2] (may be forged))
        by spam2.hygon.cn with ESMTP id x3FC9LMa059344;
        Mon, 15 Apr 2019 20:09:21 +0800 (GMT-8)
        (envelope-from fenghao@hygon.cn)
Received: from MK-FE.hygon.cn ([172.23.18.61])
        by spam2.hygon.cn with ESMTP id x3FC6sjp059172;
        Mon, 15 Apr 2019 20:06:54 +0800 (GMT-8)
        (envelope-from fenghao@hygon.cn)
Received: from cncheex02.Hygon.cn ([172.23.18.12])
        by MK-FE.hygon.cn with ESMTP id x3FC6Kds022099;
        Mon, 15 Apr 2019 20:06:20 +0800 (GMT-8)
        (envelope-from fenghao@hygon.cn)
Received: from harry-Inspiron-5675.higon.com (172.23.18.44) by
 cncheex02.Hygon.cn (172.23.18.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1466.3; Mon, 15 Apr
 2019 20:06:50 +0800
From:   Hao Feng <fenghao@hygon.cn>
To:     "'Tom Lendacky '" <thomas.lendacky@amd.com>,
        "'Gary Hook '" <gary.hook@amd.com>,
        "'Herbert Xu '" <herbert@gondor.apana.org.au>,
        "' David S. Miller '" <davem@davemloft.net>
CC:     "'Zhaohui Du '" <duzhaohui@hygon.cn>,
        "'Zhiwei Ying '" <yingzhiwei@hygon.cn>,
        "'Wen Pu '" <puwen@hygon.cn>, Hao Feng <fenghao@hygon.cn>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] crypto: ccp: Add Hygon Dhyana support
Date:   Mon, 15 Apr 2019 20:04:23 +0800
Message-ID: <1555329868-17895-2-git-send-email-fenghao@hygon.cn>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
References: <1555329868-17895-1-git-send-email-fenghao@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.23.18.44]
X-ClientProxiedBy: cncheex02.Hygon.cn (172.23.18.12) To cncheex02.Hygon.cn
 (172.23.18.12)
X-MAIL: spam2.hygon.cn x3FC6sjp059172
X-DNSRBL: 
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Hygon Dhyana CPU has 2 CCP devices, the device IDs are 0x1456 and
0x1468, Hygon uses the same device interface as AMD, so enable the CCP
driver to support Hygon CCP devices.

Signed-off-by: Hao Feng <fenghao@hygon.cn>
---
 drivers/crypto/ccp/sp-pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 41bce0a..363ad9f 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -321,6 +321,8 @@ static const struct pci_device_id sp_pci_table[] = {
 	{ PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&dev_vdata[1] },
 	{ PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&dev_vdata[2] },
 	{ PCI_VDEVICE(AMD, 0x1486), (kernel_ulong_t)&dev_vdata[3] },
+	{ PCI_VDEVICE(HYGON, 0x1456), (kernel_ulong_t)&dev_vdata[1] },
+	{ PCI_VDEVICE(HYGON, 0x1468), (kernel_ulong_t)&dev_vdata[2] },
 	/* Last entry must be zero */
 	{ 0, }
 };
-- 
2.7.4

