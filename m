Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="bQKaLUfO"
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E7A4D71;
	Fri, 24 Nov 2023 04:51:45 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AO7PpH5004885;
	Fri, 24 Nov 2023 04:51:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=43CBmmmd3XYLFFV5yxD/fnJwLJxBv4USfvbOfdDqyL8=;
 b=bQKaLUfOiK9LKCeoDdHqHJPaQ65r4znRFwNSLSu8OpF0Mfg00YtkanVbkhyzHhinL+j9
 yE/Ks1XIpHgNjmftb0Jbn7oImhjZ8Xr222utydJ9V40/f+8AWNfNqy1xF7zEjOhLIxxR
 Dcskwfbo0nIg/CRgc9qZ5ciAnrcxSL5LlQiSi31Ki7jVcWPjFCoLLHECoImKFmMjnoSk
 u4P/QZvH8U+0DNaEC8H4hL9yEF7pllqkb36FAY6LR6y+Mbja8PkY63vS8q9HtiadDaph
 r438ZKFHKuo1hrysnzuE84CroEvkJ6dvDnOcrGj6LcFYlB+zmtvIVyR/Q1ugfsujkpfB xw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3uhpxn69c0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Fri, 24 Nov 2023 04:51:34 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 24 Nov
 2023 04:51:32 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 24 Nov 2023 04:51:32 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 6F98E3F707B;
	Fri, 24 Nov 2023 04:51:27 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <ndabilpuram@marvell.com>, <sgoutham@marvell.com>,
        <jerinj@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next 07/10] octeontx2-af: update CPT inbound inline IPsec mailbox
Date: Fri, 24 Nov 2023 18:20:44 +0530
Message-ID: <20231124125047.2329693-8-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231124125047.2329693-1-schalla@marvell.com>
References: <20231124125047.2329693-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 1Zs3H4_NjwDvGSax5FIUqtqwUXyRXJyS
X-Proofpoint-GUID: 1Zs3H4_NjwDvGSax5FIUqtqwUXyRXJyS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-23_15,2023-11-22_01,2023-05-22_02

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

