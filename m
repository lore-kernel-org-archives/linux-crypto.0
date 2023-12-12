Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ag8rDo2A"
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD3ECE;
	Mon, 11 Dec 2023 21:18:01 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 3BBJYZt3009928;
	Mon, 11 Dec 2023 21:17:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=UReJLMLrvpJIa4FY1T75cC81B7xyCL36z25xAsooeqc=; b=ag8
	rDo2A5uGWCscJBJhKmV+wcMBKFiJHwe5iDo+GmZm30otga2F30o4BqUJx4mOBGCr
	+KydNzID7MLZhDqMQ43v6/72q+fxQHIvOyVS4yNWkcZ0fSvRTiK7kE5ABumn2w8x
	VTPAOF7fqPrN2gjzA6hPFrhBpR9fQDCDDV5nkMuvhdkUti28J4vbpbVwU/UUeyU1
	v9HGtHKq2W0u6U5HDW+IaMXVyOwam348IWUxDsYr0YhxvNFIUUyIn9IRo3nq4RbD
	1Jepm113ttI/+RNOFE+aQF7R/3JN6YKO7CuIHCWvigcAFDEf82sdG2NWlacAydji
	iwsUXHQrA42ZZmWRUOg==
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3uwyp4kp55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Mon, 11 Dec 2023 21:17:45 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Mon, 11 Dec
 2023 21:17:43 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Mon, 11 Dec 2023 21:17:43 -0800
Received: from localhost.localdomain (unknown [10.28.36.175])
	by maili.marvell.com (Postfix) with ESMTP id 112DD3F709C;
	Mon, 11 Dec 2023 21:17:37 -0800 (PST)
From: Srujana Challa <schalla@marvell.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>, <kuba@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <bbrezillon@kernel.org>,
        <arno@natisbad.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <corbet@lwn.net>, <sgoutham@marvell.com>, <bbhushan2@marvell.com>,
        <jerinj@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <ndabilpuram@marvell.com>, <schalla@marvell.com>
Subject: [PATCH net-next v2 01/10] crypto: octeontx2: remove CPT block reset
Date: Tue, 12 Dec 2023 10:47:21 +0530
Message-ID: <20231212051730.386088-2-schalla@marvell.com>
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
X-Proofpoint-ORIG-GUID: JeAuDA8sHd_jwR-dQfJHAnQbF9A_h7ab
X-Proofpoint-GUID: JeAuDA8sHd_jwR-dQfJHAnQbF9A_h7ab
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

