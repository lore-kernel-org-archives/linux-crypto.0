Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43CA7CDB482
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Oct 2023 06:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjJPGuP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Oct 2023 02:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231796AbjJPGuM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Oct 2023 02:50:12 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708C8E3
        for <linux-crypto@vger.kernel.org>; Sun, 15 Oct 2023 23:50:09 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39FMqvdr002312;
        Sun, 15 Oct 2023 23:50:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=T9q4JzD4kNcGvh74HXP4FwWn2fv2CHvz0DEhbwe4GtY=;
 b=U+jRdbn5be6AVxstlosZyj2bCJug38EVsDf2/BWKUxizlEBzllqqQYR3CT4ohaKdk+77
 BkUjPiv8GOWqGbr4A12V7sp7UFXll94nlAPyEa/URN3HQYbrJbYCrP0bl8DWefklOEHz
 MBD9XoLqvEfiCRPfoaOaumPxs9gceGihgIxZ0b64uLyTKTGnVACXY6HHwPNNs//hXaig
 /X7uvF9ZA4gc8tjxzYSeHSDJGWVorFxa4YZ2HF1367N3O5j7YLfQ7034Abeu3GF1kali
 T/kgV+mOxuRhRBsRl1XY8qWERELk1edG2weU8CFsYNHwkZBJdc5j913E4QNecfmEE7UO uA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3tqtgkm936-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 15 Oct 2023 23:50:02 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Sun, 15 Oct
 2023 23:50:00 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Sun, 15 Oct 2023 23:49:59 -0700
Received: from localhost.localdomain (unknown [10.28.36.175])
        by maili.marvell.com (Postfix) with ESMTP id 69D093F705C;
        Sun, 15 Oct 2023 23:49:57 -0700 (PDT)
From:   Srujana Challa <schalla@marvell.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC:     <linux-crypto@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <kuba@kernel.org>, <ndabilpuram@marvell.com>,
        <schalla@marvell.com>
Subject: [PATCH 07/10] octeontx2-af: update CPT inbound inline IPsec mailbox
Date:   Mon, 16 Oct 2023 12:19:31 +0530
Message-ID: <20231016064934.1913964-8-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016064934.1913964-1-schalla@marvell.com>
References: <20231016064934.1913964-1-schalla@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Fe618QBVNmh2h3D3aO1kaaVPzB1vJJpe
X-Proofpoint-ORIG-GUID: Fe618QBVNmh2h3D3aO1kaaVPzB1vJJpe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-15_09,2023-10-12_01,2023-05-22_02
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
index 04150931422e..6b8110208e27 100644
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

