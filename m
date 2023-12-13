Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="X2dsQ1sT"
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD90D3;
	Tue, 12 Dec 2023 23:31:28 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BD3Y1Y8012763;
	Tue, 12 Dec 2023 23:31:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=P220VcY/Z0DwWKOXoVx7Fl785OVCqyfVCh0hgEzJwg0=; b=X2d
	sQ1sTLAKSsZ67AEDWT5fRGufGM732dNXsej86ZJYnynRnURod6UARTcO1EO72dLP
	ggBqy7yz7SgrJiazQ2wSPUM4dyxV8ZcSNLa9MB2iLJBKBYxB8IF5zc7kSZdr5hui
	2gSbKvADOJBg8Ge9z/BsEzYMHR2u4S7VQ4HDdMFCmyBMmysd95nlfRNwH1RAyg1K
	Q1nozO5susqRQngzcenJsERtj2nnz2QPEuFlLUhYt4ajwFqniXDuGr2vzsS0k12F
	+5JW37El2odJ0PceXf6GqKJeks3olH0pBY3IYOsuIqAbH3Q2uzAhTQ+5dHdlpN+h
	5nt2ipLyI68DB9YAnNA==
Received: from dc5-exch02.marvell.com ([199.233.59.182])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3uy4tggqyq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Tue, 12 Dec 2023 23:31:22 -0800 (PST)
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 12 Dec
 2023 23:31:20 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 12 Dec 2023 23:31:20 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 712843F70A1;
	Tue, 12 Dec 2023 23:31:16 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kuba@kernel.org>, <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <corbet@lwn.net>, <kalesh-anakkur.purayil@broadcom.com>,
        <horms@kernel.org>, <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <jerinj@marvell.com>, <ndabilpuram@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v3 4/9] crypto: octeontx2: remove errata workaround for CN10KB or CN10KA B0 chip.
Date: Wed, 13 Dec 2023 13:00:50 +0530
Message-ID: <20231213073055.588530-5-schalla@marvell.com>
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
X-Proofpoint-ORIG-GUID: -AJkwnewLwAfU-G1cL08c1jWqh15qk6W
X-Proofpoint-GUID: -AJkwnewLwAfU-G1cL08c1jWqh15qk6W
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

Adds code to not execute CPT errata "when CPT_AF_DIAG[FLT_DIS] = 0 and a
CPT engine access to LLC/DRAM encounters  a fault/poison, a rare case
may result in unpredictable data being delivered to a CPT engine"
workaround on CN10KA B0/CN10KB HW as it is fixed on these chips.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 drivers/crypto/marvell/octeontx2/otx2_cpt_common.h  |  7 +++++++
 drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c | 10 ++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
index 746b049c6c44..ba1682a213e3 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
+++ b/drivers/crypto/marvell/octeontx2/otx2_cpt_common.h
@@ -186,6 +186,13 @@ static inline void otx2_cpt_set_hw_caps(struct pci_dev *pdev,
 	}
 }
 
+static inline bool cpt_is_errata_38550_exists(struct pci_dev *pdev)
+{
+	if (is_dev_otx2(pdev) || is_dev_cn10ka_ax(pdev))
+		return true;
+
+	return false;
+}
 
 static inline bool cpt_feature_sgv2(struct pci_dev *pdev)
 {
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

