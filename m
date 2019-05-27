Return-Path: <SRS0=ER81=T3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7C8C07542
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 08:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 505092173B
	for <linux-crypto@archiver.kernel.org>; Mon, 27 May 2019 08:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfE0Ij3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 May 2019 04:39:29 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:33853 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726282AbfE0Ij2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 May 2019 04:39:28 -0400
X-UUID: bf1d95354e3543b588a19fde8c97c38b-20190527
X-UUID: bf1d95354e3543b588a19fde8c97c38b-20190527
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <neal.liu@mediatek.com>)
        (mhqrelay.mediatek.com ESMTP with TLS)
        with ESMTP id 1882384691; Mon, 27 May 2019 16:39:09 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs01n1.mediatek.inc (172.21.101.68) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 27 May 2019 16:39:08 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 27 May 2019 16:39:08 +0800
From:   Neal Liu <neal.liu@mediatek.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@kernel.org>
CC:     Neal Liu <neal.liu@mediatek.com>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, <wsd_upstream@mediatek.com>,
        Crystal Guo <Crystal.Guo@mediatek.com>
Subject: [PATCH v2 1/3] soc: mediatek: add SMC fid table for SIP interface
Date:   Mon, 27 May 2019 16:38:44 +0800
Message-ID: <1558946326-13630-2-git-send-email-neal.liu@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1558946326-13630-1-git-send-email-neal.liu@mediatek.com>
References: <1558946326-13630-1-git-send-email-neal.liu@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

1. Add a header file to provide SIP interface to ARM Trusted
Firmware(ATF)
2. Add hwrng SMC fid

Signed-off-by: Neal Liu <neal.liu@mediatek.com>
---
 include/linux/soc/mediatek/mtk_sip_svc.h |   51 ++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 include/linux/soc/mediatek/mtk_sip_svc.h

diff --git a/include/linux/soc/mediatek/mtk_sip_svc.h b/include/linux/soc/mediatek/mtk_sip_svc.h
new file mode 100644
index 0000000..f65d403
--- /dev/null
+++ b/include/linux/soc/mediatek/mtk_sip_svc.h
@@ -0,0 +1,51 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2019 MediaTek Inc.
+ */
+
+#ifndef _MTK_SECURE_API_H_
+#define _MTK_SECURE_API_H_
+
+#include <linux/kernel.h>
+
+/* Error Code */
+#define SIP_SVC_E_SUCCESS			0
+#define SIP_SVC_E_NOT_SUPPORTED			-1
+#define SIP_SVC_E_INVALID_PARAMS		-2
+#define SIP_SVC_E_INVALID_RANGE			-3
+#define SIP_SVC_E_PERMISSION_DENY		-4
+
+#ifdef CONFIG_ARM64
+#define MTK_SIP_SMC_AARCH_BIT			0x40000000
+#else
+#define MTK_SIP_SMC_AARCH_BIT			0x00000000
+#endif
+
+/*******************************************************************************
+ * Defines for Mediatek runtime services func ids
+ ******************************************************************************/
+
+/* Debug feature and ATF related SMC call */
+
+/* CPU operations related SMC call */
+
+/* SPM related SMC call */
+
+/* Low power related SMC call */
+
+/* AMMS related SMC call */
+
+/* Security related SMC call */
+/* HWRNG */
+#define MTK_SIP_KERNEL_GET_RND \
+	(0x82000206 | MTK_SIP_SMC_AARCH_BIT)
+
+/* Storage Encryption related SMC call */
+
+/* Platform related SMC call */
+
+/* Pheripheral related SMC call */
+
+/* MM related SMC call */
+
+#endif /* _MTK_SECURE_API_H_ */
-- 
1.7.9.5

