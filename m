Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D928F25A358;
	Wed, 21 May 2025 10:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747821922; cv=none; b=V73ybik83L6ssVNaCp5RRvDBX57OH4DlE2IJi2eJ/K0TP71Gj4TMYuMPlEvH6R3mZ6oGbGVyo+8EHmQg2SpH5/o0gLsIxnsB0/IgF6fox2Np77xqJ8tefc2tOenFU1PE3zfp6tHuO5OATRiSL3smoYTdkME34ZbVNow9Thoc9fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747821922; c=relaxed/simple;
	bh=McNK5rwRHYHZYFLqUU2KVc+aeV0jdFsf3ryi5vZOOlw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z5TkUJIEzAmt6GyNA1+wITOhyxMdaOq3X1eZmsSNOelSQkc9cG3I0QxwvBrBn7mwRgYjAVSPwPMsGRUaQF+yi/NjQv7uc9dEmjm1xpkBk6SZLinsEzCNwhgmusmLU/R+3LRBtwpFYMjM7H3J+aZnunvR+wuV3obWIU5CFt7ppoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=hvh+LBvI; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hvh+LBvI"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L9qwLF010201;
	Wed, 21 May 2025 03:04:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=J
	efH84uhgqNME6qU13B3lV4H09DDmh0wckuzrahMkBk=; b=hvh+LBvI8a/WmqZuD
	3Jmps2tj5xejFg6Rrh9W+DfjHBtY1vJRSW2ZjV7hJOFkVis0lv128YfUqwFeWJTY
	wskBceJPU0tu7sHyhtunAVSXgMH2d3GAIfAjFksi0Q/FM6SXoVaY4iutPB5KpiwX
	83B5rcEca3kqa3baTzKWzuJTN/PkZyKxFGTlQEZDp6Pr7UY5fpEtHIo6b6/q0+Yx
	33GkZ7GwQHVUYJ08uYZfDCGD2PMNMz7cjqloC8/TyptIwDhVX/zkxhtZTGyQhlH7
	nND8QTFqyM5ns5k3l78GmVxZyBiGkSpLBj5IiGGf4NbhOKIymDUyJn7vBDuqFvdI
	WjZTg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46rwfghpgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 03:04:58 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 21 May 2025 03:04:57 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 21 May 2025 03:04:57 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id EB31D3F70B3;
	Wed, 21 May 2025 03:04:53 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 1/4 v3] crypto: octeontx2: add timeout for load_fvc completion poll
Date: Wed, 21 May 2025 15:34:44 +0530
Message-ID: <20250521100447.94421-2-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250521100447.94421-1-bbhushan2@marvell.com>
References: <20250521100447.94421-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDA5OSBTYWx0ZWRfX7sNeaOAB8OIF kpCiU4jwNXJj3InZUTUYx78kq/nA9SKJEO/nZKY8mPThv8U2w3vrF96lxZJDEZerRhYwU+NxlJa /U5kF4RuXSR1pbY1CFV+LhXDK0IBF3tYgrFIXN+RQs75dDCmaabuUfe01l/1OOuAiUcZqVua/5U
 PQKAqyBBgqC7CXtNSzljLzevXu2cnaoNpUW+b046h5JZlmxkWhNt6GDu56YQMKo8mf9IqUbZHPl FHAotrayhtV2qQvJYCdzeltyaTlyQjZpcST19qusemuMuJ2QUzR+K0dSkMCzlVLe6Dhv31t2Kz/ to/Nz3tGNURV+Bo7nWwZA2xiZM6EBwMNnakdd69718Y506jX14FgiKLr+EmKOF5ZcGrknrj03Fg
 ZWZldVGhIOuvTPl6/H4HVeErNogrZVB1asiy1pK5E2axBzJhbWt4f+a+W5pywwQz4BrgNsPK
X-Proofpoint-GUID: Ikz-tyihjJA9pvvJikOBIuEtjXCttmSC
X-Authority-Analysis: v=2.4 cv=T6OMT+KQ c=1 sm=1 tr=0 ts=682da54a cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=dP9LQboaRqI6G61vZ2MA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: Ikz-tyihjJA9pvvJikOBIuEtjXCttmSC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_03,2025-05-20_03,2025-03-28_01

Adds timeout to exit from possible infinite loop, which polls
on CPT instruction(load_fvc) completion.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
---
 .../crypto/marvell/octeontx2/otx2_cptpf_ucode.c  | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 78367849c3d5..9095dea2748d 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1494,6 +1494,7 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	dma_addr_t rptr_baddr;
 	struct pci_dev *pdev;
 	u32 len, compl_rlen;
+	int timeout = 10000;
 	int ret, etype;
 	void *rptr;
 
@@ -1554,16 +1555,27 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
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

