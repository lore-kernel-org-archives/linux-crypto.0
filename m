Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IY98JjAR"
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC1FD5;
	Tue, 12 Dec 2023 23:31:41 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BCJGG1n017143;
	Tue, 12 Dec 2023 23:31:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=EBFXx+IDBFXCxP96kBwUmTIiyFwx3urerGjzAmMEBSE=; b=IY9
	8JjARQynPIgjHNAroRekeNGRete59+7d61AdNbnQ6vjNkCySwT2f96mxMy+yBCMZ
	l58gJeEt+ixKHxxXkk26n7YujzIdlVV7RQWI5zTyZIDAfMtBaBEZ1WWLq1a99n5h
	445QNFKdQqLv6QHBqT18YQvLI+JRHSmClZlHxfKi/xf7TRXarOTjkCWW14FTDCgg
	Z/UsPYp7Ykn4ycCbbGRGD7gUdMWIkB8l82knYvxxBYY/0lAIJ77Bme5U9q4WtfxU
	KNh5uKdotXsD6y+cojx1IAUSy5v0bhGjkeunG2Vd4P2OA4TRKp5sPgF3LsE+hMFO
	sX5frb5c44+I1evJNdA==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3uvrmjvrkq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Tue, 12 Dec 2023 23:31:32 -0800 (PST)
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 12 Dec
 2023 23:31:30 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 12 Dec 2023 23:31:30 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 19DB43F70A1;
	Tue, 12 Dec 2023 23:31:25 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kuba@kernel.org>, <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <corbet@lwn.net>, <kalesh-anakkur.purayil@broadcom.com>,
        <horms@kernel.org>, <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <jerinj@marvell.com>, <ndabilpuram@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v3 6/9] octeontx2-af: update CPT inbound inline IPsec mailbox
Date: Wed, 13 Dec 2023 13:00:52 +0530
Message-ID: <20231213073055.588530-7-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231213073055.588530-1-schalla@marvell.com>
References: <20231213073055.588530-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: U5kogpzqwI6vhlh8Fz-p_WOKbGF7dDyq
X-Proofpoint-ORIG-GUID: U5kogpzqwI6vhlh8Fz-p_WOKbGF7dDyq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

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
index 807db0da52cc..e0c1bbad93cc 100644
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
index e319aa1ff119..5c9484646172 100644
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

