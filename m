Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jrqVggVM"
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D0B5CE;
	Mon, 11 Dec 2023 21:18:18 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BBK7Q4i009898;
	Mon, 11 Dec 2023 21:18:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=yiHOE6AG6cXnK0ODKTTevs5ZzYarbHn5mJbO+051JSY=; b=jrq
	VggVMZpD2OBHvJBtzlKS4RWgePL1Paggf5Eh+G5wLV3xy/A/INkkTynZa3yM8dgu
	YI7ocqcbbvS68YbV+AkW3Rjlfl+bSYE2LkfJ+0sJwASg+xXWyBprIXCwSG2mUN2H
	jkIL5bW/JlhUrunkr1Q8dj95rNjarRMn9JD3nOXFc5vXpz428KBOKGXDglYHpf6b
	8yMoQAYPybuOM3+XuLlpQ877YABWLYpKaY5vjjl1R8IS7friZK2lRSSCgdcMg/+0
	/AnfYZTgOEEWJK3LW46Swp7f4cNwxbjvXhL3b5KbNFUzct+LgP3narzQtj7m0nOr
	qVOpScUwHEjfikkcXag==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3uwyp4kp70-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Mon, 11 Dec 2023 21:18:09 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 11 Dec
 2023 21:18:08 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 11 Dec 2023 21:18:07 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 73E593F70A2;
	Mon, 11 Dec 2023 21:18:02 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <corbet@lwn.net>, <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <jerinj@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <ndabilpuram@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next v2 05/10] crypto: octeontx2: remove errata workaround for CN10KB or CN10KA B0 chip.
Date: Tue, 12 Dec 2023 10:47:25 +0530
Message-ID: <20231212051730.386088-6-schalla@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231212051730.386088-1-schalla@marvell.com>
References: <20231212051730.386088-1-schalla@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: lWh1mlaDlhhSFYseZp56lFLLYmXt3i2x
X-Proofpoint-GUID: lWh1mlaDlhhSFYseZp56lFLLYmXt3i2x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

Adds code to not execute CPT errata "when CPT_AF_DIAG[FLT_DIS] = 0 and a
CPT engine access to LLC/DRAM encounters  a fault/poison, a rare case
may result in unpredictable data being delivered to a CPT engine"
workaround on CN10KA B0/CN10KB HW as it is fixed on these chips.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h  |  8 ++++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 10 ++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index df7321193f19..f932a3bf3e3b 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -186,6 +186,14 @@ static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
 	}
 }
 
+static inline bool cpt_is_errata_38550_exists(struct pci_dev *pdev)
+{
+	if (is_dev_otx2(pdev) || is_dev_cn10ka_ax(pdev))
+		return true;
+
+	return false;
+}
+
 static inline bool cpt_feature_rxc_icb_cnt(struct pci_dev *pdev)
 {
 	if (!is_dev_otx2(pdev) && !is_dev_cn10ka_ax(pdev))
diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 7fccc348f66e..e319aa1ff119 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1254,10 +1254,12 @@ int otx2_cpt_create_eng_grps(struct otx2_cptpf_dev *cptpf,
 	 * encounters a fault/poison, a rare case may result in
 	 * unpredictable data being delivered to a CPT engine.
 	 */
-	otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_DIAG, &reg_val,
-			     BLKADDR_CPT0);
-	otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_DIAG,
-			      reg_val | BIT_ULL(24), BLKADDR_CPT0);
+	if (cpt_is_errata_38550_exists(pdev)) {
+		otx2_cpt_read_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_DIAG,
+				     &reg_val, BLKADDR_CPT0);
+		otx2_cpt_write_af_reg(&cptpf->afpf_mbox, pdev, CPT_AF_DIAG,
+				      reg_val | BIT_ULL(24), BLKADDR_CPT0);
+	}
 
 	mutex_unlock(&eng_grps->lock);
 	return 0;
-- 
2.25.1

