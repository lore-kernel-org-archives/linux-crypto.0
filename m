Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="OEaLzTnZ"
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF0E193;
	Fri, 24 Nov 2023 04:51:17 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AO5Og0A017566;
	Fri, 24 Nov 2023 04:51:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=xuWr1SM7havjsQf44sHDaRSwoxLOEKZkmvHTR+fxuI4=;
 b=OEaLzTnZvD0UWMnpzD4c9nr1rTdE23Enh9rm2Br+bdjoSP3CeZuofAKmYnhrR4cuSJMS
 nNLt/C2ih/BDAR0scx5YCk6Gph7LSlsNUrlUMsXZotDO1Wxe1T1Anq14tlg4ccx94QsV
 Bqh5qVIj8cZf9B0JNeMiSYfYgallM4s4b0QHBhmFbVO0ixfovbuZxUgtI0HZQk+8f9SH
 nqi8KWHFXnkRbexZCb/2JXycN2TJJS4G0q9EOoc/JqF7Yg5ShVEwU9ch+B+2r0RhEn9p
 5osDyHkfgifUHuOCfpnTKIqgfTHEsFUh7Gry2jS643m6ztA92pakF8gh748DavBFIehJ WQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3uj7yku06t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Fri, 24 Nov 2023 04:51:00 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 24 Nov
 2023 04:50:58 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Fri, 24 Nov 2023 04:50:59 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id E25143F7074;
	Fri, 24 Nov 2023 04:50:53 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <ndabilpuram@marvell.com>, <sgoutham@marvell.com>,
        <jerinj@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next 01/10] crypto: octeontx2: remove CPT block reset
Date: Fri, 24 Nov 2023 18:20:38 +0530
Message-ID: <20231124125047.2329693-2-schalla@marvell.com>
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
X-Proofpoint-GUID: 66L1xYJKldjH2aNAiIdCCi3bCzET-_Uk
X-Proofpoint-ORIG-GUID: 66L1xYJKldjH2aNAiIdCCi3bCzET-_Uk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-23_15,2023-11-22_01,2023-05-22_02

CPT block reset in CPT PF erase all the CPT configuration which is
done in AF driver init. So, remove CPT block reset from CPT PF as
it is also being done in AF init and not required in CPT PF.

Signed-off-by: Srujana Challa <schalla@marvell.com>
---
 .../marvell/octeontx2/otx2_cptpf_main.c       | 43 -------------------
 1 file changed, 43 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
index e34223daa327..5436b0d3685c 100644
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

