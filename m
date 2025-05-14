Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9CE101EE;
	Wed, 14 May 2025 05:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747199492; cv=none; b=HUtSaN1+b4/RL71iRmWY3CPHLbmbmFibMxnxfXj7SQdhbYQq59Yp3LopYJ1Qb7LuBYW0UM5OdeJN/BzjzrhrHpYHoyhbbN+qlmMTYgCGtCW2nSI59Huu33ZjLSpr9rLNUZbfpDVkrJUIZsB3LaI6iGSz+OuWSNCcn9R2T4QAGIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747199492; c=relaxed/simple;
	bh=czjazmFYUiok/yL9SSrhyqGeSrUqieqiCLgQIhFaOuk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HOuG9j23R5w3uAf53jDvRiVDROd+CtvI73prbUCF3g9yZA4azQzxmmc5SIFYTNkIM7hq03G/Bh4KLGa+zN/tLG/tHYxb6H1SLiJQIdsFR88jGOtyETzvlZEHKHxHK0xwwcJkSmFVeE2FsD3nhKrCt/YBDEoHCPnJQEDQYAqN0bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jAg2cprF; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jAg2cprF"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DNU2fn018705;
	Tue, 13 May 2025 22:11:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=1
	iRQpEgL7o9TFw08szdan6sVYDSiqeDOutFpf9FuMdU=; b=jAg2cprFSnMS+Xbvn
	fuFsIUdcB5/Cg6ecDRs9wGKI6NWEYqEF9do1PY8/3DQ58oR4WDywkBt4wXIfDag6
	1fGb6B2xfNuEV5j8zcXHH07hYhc7WGaA9ExXJ06rkxbzh4G8CahB9gaZXwJ4Szcm
	EZEFVehaNtdx/VMppwYs90qJ+FPLOE0TgFnaOUcwchIPgjBJCzDo+VsYcMS/0uqh
	cdqFqecFYNQZdDQJHz1VYQpsDHocgUM9G9jrwZ5J041hzzv0+0e3FWqKYMFUsCgq
	j6fmpL3/+Zvnx0JPYOTrzMd3VTckIO+q/GGJyOmG585rjg8Skh2f4GkzVKmUxcXh
	wP8vg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46mft50gw1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 May 2025 22:11:17 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 13 May 2025 22:11:16 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 13 May 2025 22:11:16 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id BD1105C68E3;
	Tue, 13 May 2025 22:11:12 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <arno@natisbad.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bharatb.linux@gmail.com>
CC: <stable@vger.kernel.org>, Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 1/4 RESEND] crypto: octeontx2: add timeout for load_fvc completion poll
Date: Wed, 14 May 2025 10:40:40 +0530
Message-ID: <20250514051043.3178659-2-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514051043.3178659-1-bbhushan2@marvell.com>
References: <20250514051043.3178659-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: iKrlbvHaAo-xKbh8FPnpSBx4Ge7Vcu5k
X-Authority-Analysis: v=2.4 cv=VITdn8PX c=1 sm=1 tr=0 ts=682425f5 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=dP9LQboaRqI6G61vZ2MA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: iKrlbvHaAo-xKbh8FPnpSBx4Ge7Vcu5k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA0MyBTYWx0ZWRfX+eRNgYH8MIwt qJlO9mDYNc/SOuSGFY5t4aTTNBXERCZKGMGfOb+ecjVeHp+GKImniH+WQsA8DsHJUR/QuHi5S7D KK/XDbjXOqJqetO7P4AWy1o9QAkEeCwrLY41VWnHeGK17CfEhJAexORP3PiYYwXSGq1u6P4wJa/
 mw8dE7BWCVKUna3+NqXmla1JhqH+jEYg957cF13fEEWV2H3aWRBvJI+7KGnBuyM8yBdrnTufF31 8FwcRNHdO/E05YvS0oU4e2LMdP8RcUDqGv8Svq3G6ExRcLxUI9nzg5OvG357HmU4B3wtMA9y0KR 03OAj9RHGdtLcqxXrgivSo7yjc0ECcRlz3N5Yptk6FKeden1ub9lfuZiDEknecp0uUqZJyREzyS
 LJHIvDVuRDGKWYQhtsTIa/oJQv+ByUsux3ruZqNfYkj/2PWu8bEfA2zDtBN1LEHtSBfe3Ggc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_01,2025-05-09_01,2025-02-21_01

Adds timeout to exit from possible infinite loop, which polls
on CPT instruction(load_fvc) completion.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
---
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c  | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 42c5484ce66a..3a818ac89295 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1494,6 +1494,7 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	dma_addr_t rptr_baddr;
 	struct pci_dev *pdev;
 	u32 len, compl_rlen;
+	int timeout = 10000;
 	int ret, etype;
 	void *rptr;
 
@@ -1556,16 +1557,27 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 							 etype);
 		otx2_cpt_fill_inst(&inst, &iq_cmd, rptr_baddr);
 		lfs->ops->send_cmd(&inst, 1, &cptpf->lfs.lf[0]);
+		timeout = 10000;
 
 		while (lfs->ops->cpt_get_compcode(result) ==
-						OTX2_CPT_COMPLETION_CODE_INIT)
+						OTX2_CPT_COMPLETION_CODE_INIT) {
 			cpu_relax();
+			udelay(1);
+			timeout--;
+			if (!timeout) {
+				ret = -ENODEV;
+				cptpf->is_eng_caps_discovered = false;
+				dev_warn(&pdev->dev, "Timeout on CPT load_fvc completion poll\n");
+				goto error_no_response;
+			}
+		}
 
 		cptpf->eng_caps[etype].u = be64_to_cpup(rptr);
 	}
-	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
 	cptpf->is_eng_caps_discovered = true;
 
+error_no_response:
+	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
 free_result:
 	kfree(result);
 lf_cleanup:
-- 
2.34.1

