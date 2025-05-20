Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B75C22D9E2;
	Tue, 20 May 2025 13:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747746485; cv=none; b=XVrY1je1dDkJMVQEwGGpUpOEh5YGtf0ZH0j3W6kO7oOpuYK+QG3yC/sfCEuz6qCUSzu3/TnRXBLY2QnOMoOFfM17qv1Rgotgnj5p7x9LjH5be3IH6TXgxHnI9m/mKsrcT5lXXF/6+bmZdg1EL8IN3iKTuHHNSofTQ4SwmDH3vls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747746485; c=relaxed/simple;
	bh=V4dsV4FSoNuk8JOuAPHbPGEZhyf8ojWlXmG5n50k25s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rm9Maj8vXjEcloSwaEpY70i7NUbZGwiusNgt0XSMBbre4Dm3XGcM1I7+Yg+2xA9PSeEHtPwuo1pBLiJdU7cy94AbuBlnn2LTc4Yld68ZieO8r73oCDx1umGsjqUZbvNbpAWcx8n5KYMty3xcL8Y+R79n3L/u2uR5JVcrPEH7ylE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=PQe9z9wp; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="PQe9z9wp"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JNTwn9012017;
	Tue, 20 May 2025 06:07:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=y
	tR0d8fLxbm5jO2+WA/zdwQJACfVHKbdfeZvHmBsT2c=; b=PQe9z9wpJP0LbKC8K
	4NjCzcXC321FD8U2M5ywxn728hNIT/D3j71Ew4k20ZZC7pB0B1DbeduDAVfl9lW4
	JQ1cUYEgAezzA4+wjL1nmnY9BWm3lt221KbnahJDpkp7oXRNmdIPqBwnIoXyGWIm
	wHLb6nk8c5LcM1+8qS/nhwZVLkW/IA3No8t0VdRb3/FgaXhLgwPWl/U5zEtwIVNf
	KKdWXltUQedVuY1AqEAj7Zt75Ok0Cy34CLEPSURwzgWKHzV2pCLQVPXt/i+gupjR
	TA0HJCuyONAbAVoU+4EjKW7wFSHHnWNE73V3NJQQICXnqt4ZfRWt+CFz/B0+Eeoz
	UuhBQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46rebt18jv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 06:07:49 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 20 May 2025 06:07:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 20 May 2025 06:07:47 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 1F95D3F7061;
	Tue, 20 May 2025 06:07:43 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH 1/4 v2] crypto: octeontx2: add timeout for load_fvc completion poll
Date: Tue, 20 May 2025 18:37:34 +0530
Message-ID: <20250520130737.4181994-2-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250520130737.4181994-1-bbhushan2@marvell.com>
References: <20250520130737.4181994-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDEwNSBTYWx0ZWRfX7WNo3O7QzqXi fmx7NW0n8TJwzZZwy+NNweC7oyTSPFIriHviAu2Xcs17vn+n3ED/YmnhacmFilSEoPRkzGb5Qx0 aVHWV2iwhnx5Q1e91e/MsFNXP1nJMZtx07rqHatLGA9zVGayirt7Fzg1FPBVeVz/sLc5db1OvYb
 x8lhcaY9jROFd2vou5PY4+Q88oFvYyhWayGJZN7IIhQEa4tw2Fw+W76cAfoBxVA327TafGKP8R+ mm+LZJnZar8PqrLF5YI45rj8v5mIxq0bSx70VWUHBe8eA8HkKiWk0cEJeBa+a3xsst8rWkyZduB OP1Huoz21wjzEpkch+6i7Kk7BDlogthK9wyhnO7hdi7BU8SEfWzL3qho6fzzBy7BklIbM0ya8u4
 uJmD920o4dCGS8KbDrE72aFXeSSyi6vUBpHSyfJe8EBPwovHMFZlMHEY1Ttf6+2ZP2xW2nCf
X-Proofpoint-ORIG-GUID: KGc0KakT1Kx4ITyKx8BNaovJEtDRJ1t2
X-Authority-Analysis: v=2.4 cv=BqCdwZX5 c=1 sm=1 tr=0 ts=682c7ea5 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=dP9LQboaRqI6G61vZ2MA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: KGc0KakT1Kx4ITyKx8BNaovJEtDRJ1t2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_05,2025-05-16_03,2025-03-28_01

Adds timeout to exit from possible infinite loop, which polls
on CPT instruction(load_fvc) completion.

Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
Cc: <stable@vger.kernel.org> #v6.5+
---
v1->v2:
 - No Change

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

