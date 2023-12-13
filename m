Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="RJ/Nuxse"
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFF2AD;
	Tue, 12 Dec 2023 23:31:22 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BD3XOEt012156;
	Tue, 12 Dec 2023 23:31:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=1Ax72ax+JA+8w6P4mRHd+BZK2Yvt2lTlpLwsNh/4LhE=; b=RJ/
	Nuxsek5aeGFkwq09avDrMXgnID0JAr2L1ytQ5h3zoSxYGGCrhRJe1w8Pa4Ls34rM
	GR3ray5R908n5wujGdLeaE+NivyLXsO+wLIXYWBDcw1hjMmiKsFoFbnPpovm3UXW
	EYAme/gW4NuOyIMXhNxW1tdwQS8VXuchkGnvZzWpEBYJ8BHUw+w8iV05HcS6KhZF
	tOmUxxxdymAtLBR2gEAsyrtk1KQUQarDil2xYE82bVlGLlpry985kke9zPqVqmwM
	3zwQC2DlBySdMMyHvJGt4ij2vcoTaafdUWI+Qyir4yDEoqCeHpKPRsJ4bcYYatrk
	saOP4AWX3CJjCjahb7Q==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3uy4tggqxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Tue, 12 Dec 2023 23:31:07 -0800 (PST)
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Tue, 12 Dec
 2023 23:31:06 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Tue, 12 Dec 2023 23:31:06 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id ED0AB3F70AD;
	Tue, 12 Dec 2023 23:31:01 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <kuba@kernel.org>, <bbrezillon@kernel.org>, <arno@natisbad.org>,
        <corbet@lwn.net>, <kalesh-anakkur.purayil@broadcom.com>,
        <horms@kernel.org>, <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <jerinj@marvell.com>, <ndabilpuram@marvell.com>, <schalla@marvell.com>
Subject: [PATCH v3 1/9] crypto: octeontx2: remove CPT block reset
Date: Wed, 13 Dec 2023 13:00:47 +0530
Message-ID: <20231213073055.588530-2-schalla@marvell.com>
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
X-Proofpoint-ORIG-GUID: JdhkM10kp775DDmHEUI4JdigzTqsfes1
X-Proofpoint-GUID: JdhkM10kp775DDmHEUI4JdigzTqsfes1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-09_02,2023-12-07_01,2023-05-22_02

CPT block reset in CPT PF erase all the CPT configuration which is
done in AF driver init. So, remove CPT block reset from CPT PF as
it is also being done in AF init and not required in PF.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../marvell/octeontx2/otx2_cptpf_main.c       | 43 -------------------
 1 file changed, 43 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index b13df6a49644..a9d372d88a35 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
@@ -587,45 +587,6 @@ static int cpt_is_pf_usable(struct otx2_cptpf_dev *cptpf)
 	return 0;
 }
 
-static int cptx_device_reset(struct otx2_cptpf_dev *cptpf, int blkaddr)
-{
-	int timeout = 10, ret;
-	u64 reg = 0;
-
-	ret = otx2_cpt_write_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
-				    CPT_AF_BLK_RST, 0x1, blkaddr);
-	if (ret)
-		return ret;
-
-	do {
-		ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
-					   CPT_AF_BLK_RST, &reg, blkaddr);
-		if (ret)
-			return ret;
-
-		if (!((reg >> 63) & 0x1))
-			break;
-
-		usleep_range(10000, 20000);
-		if (timeout-- < 0)
-			return -EBUSY;
-	} while (1);
-
-	return ret;
-}
-
-static int cptpf_device_reset(struct otx2_cptpf_dev *cptpf)
-{
-	int ret = 0;
-
-	if (cptpf->has_cpt1) {
-		ret = cptx_device_reset(cptpf, BLKADDR_CPT1);
-		if (ret)
-			return ret;
-	}
-	return cptx_device_reset(cptpf, BLKADDR_CPT0);
-}
-
 static void cptpf_check_block_implemented(struct otx2_cptpf_dev *cptpf)
 {
 	u64 cfg;
@@ -643,10 +604,6 @@ static int cptpf_device_init(struct otx2_cptpf_dev *cptpf)
 
 	/* check if 'implemented' bit is set for block BLKADDR_CPT1 */
 	cptpf_check_block_implemented(cptpf);
-	/* Reset the CPT PF device */
-	ret = cptpf_device_reset(cptpf);
-	if (ret)
-		return ret;
 
 	/* Get number of SE, IE and AE engines */
 	ret = otx2_cpt_read_af_reg(&cptpf->afpf_mbox, cptpf->pdev,
-- 
2.25.1

