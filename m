Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78994C4332F
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Nov 2023 05:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbjKCFd6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Nov 2023 01:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjKCFd5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2023 01:33:57 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E301B3;
        Thu,  2 Nov 2023 22:33:50 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A2LsB8q012913;
        Thu, 2 Nov 2023 22:33:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=43CBmmmd3XYLFFV5yxD/fnJwLJxBv4USfvbOfdDqyL8=;
 b=Dfo0T+HmTw7FxSCEHJEw+2iiF4WM8cJ75mlisyS25IF6VYJTBls8AKu4LRN6DqLcq6a6
 uKheLIaPqiagRbriZDIGVKD7yyzmcFyuRscDBfgUcO091D4CuQhQYvOG1/LwE+0SloIo
 0BJ3NPEVvGiQ49tQQ0Hu2wbXJo1v1s/xJr0GU9tK+1i/0crcmLe2wf+x9O3QIfgI2Vkq
 cQuyrTMcAsZPhZ32bmcQiI+MDoVleZjgY6zjFdb0FpbhUJH/O1BktIA1d9SNqRQjIxQ1
 +v32dA/1sP7jD/Xx53rgnGP3blv7IMl8UAOjZkoelCdD7bMEt64Etj9xbatFIDkCTPMk 9w== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3u4m34982w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Nov 2023 22:33:39 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 2 Nov
 2023 22:33:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 2 Nov 2023 22:33:37 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 331323F7057;
        Thu,  2 Nov 2023 22:33:33 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <kuba@kernel.org>, <ndabilpuram@marvell.com>,
        <sgoutham@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v1 07/10] octeontx2-af: update CPT inbound inline IPsec mailbox
Date:   Fri, 3 Nov 2023 11:03:03 +0530
Message-ID: <20231103053306.2259753-8-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231103053306.2259753-1-schalla@marvell.com>
References: <20231103053306.2259753-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: EOrTTfAcDCul9PHlE1_bTkXn8UOVgQdq
X-Proofpoint-GUID: EOrTTfAcDCul9PHlE1_bTkXn8UOVgQdq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_05,2023-11-02_03,2023-05-22_02
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Updates CPT inbound inline IPsec configure mailbox to take
CPT credit threshold and bpid, which are introduced
in CN10KB.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h  | 2 ++
 drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c  | 2 ++
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 6 +++++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 79805e476853..3caa5245df1d 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -56,6 +56,8 @@ struct otx2_cpt_rx_inline_lf_cfg {
 	u16 param2;
 	u16 opcode;
 	u32 credit;
+	u32 credit_th;
+	u16 bpid;
 	u32 reserved;
 };
 
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
index a6f16438bd4a..bbabb57b4665 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_mbox.c
@@ -171,6 +171,8 @@ static int rx_inline_ipsec_lf_cfg(struct otx2_cptpf_dev *cptpf, u8 egrp,
 	nix_req->hdr.id = MBOX_MSG_NIX_INLINE_IPSEC_CFG;
 	nix_req->hdr.sig = OTX2_MBOX_REQ_SIG;
 	nix_req->enable = 1;
+	nix_req->credit_th = req->credit_th;
+	nix_req->bpid = req->bpid;
 	if (!req->credit || req->credit > OTX2_CPT_INST_QLEN_MSGS)
 		nix_req->cpt_credit = OTX2_CPT_INST_QLEN_MSGS - 1;
 	else
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 7178fa81f00f..9b66d220be43 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -16,7 +16,11 @@
 #define LOADFVC_MAJOR_OP 0x01
 #define LOADFVC_MINOR_OP 0x08
 
-#define CTX_FLUSH_TIMER_CNT 0xFFFFFF
+/*
+ * Interval to flush dirty data for next CTX entry. The interval is measured
+ * in increments of 10ns(interval time = CTX_FLUSH_TIMER_COUNT * 10ns).
+ */
+#define CTX_FLUSH_TIMER_CNT 0x2FAF0
 
 struct fw_info_t {
 	struct list_head ucodes;
-- 
2.25.1

