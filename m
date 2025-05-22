Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25F7286D7B;
	Thu, 22 May 2025 10:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747908407; cv=none; b=PaRq893wY5wWGKcwyoppHkYQTHKfXSyXnpO9ln9qtD7xBFWS/E5OVeHfn6XbVYMsgiQSRa6DG6SWWcNyNAb8o3tXFWqgJwnbTLFPcZYX2q4GO5cHK99HPjn1TaExOti8h6vVz9RT3UpIvJXcXW3WChrVpfyC9vZrnz4ZsuH3I2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747908407; c=relaxed/simple;
	bh=czjazmFYUiok/yL9SSrhyqGeSrUqieqiCLgQIhFaOuk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c7s7GBSBnyLPU4s020LL0VmKah/iA5SPG2RdRwAdTFeORbUDI68zAoyBYHtcxdKzi9nBWoTRZpC0fp+tat2MQPx26YREkiBfSS5SuZEe2bApf9M+Q8eIgObf8KMi0fC0UZB8Sug10pKHuuE4NGM0+uB3wnFBHynFl55B2Qdy7l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=IulkCPl9; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IulkCPl9"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LM5fHW008871;
	Thu, 22 May 2025 03:06:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=1
	iRQpEgL7o9TFw08szdan6sVYDSiqeDOutFpf9FuMdU=; b=IulkCPl96Sxa/BE+d
	tIz9+cwap0AhJXuTPGaoiIGPoGBv1PemjtiBIbHT/H7oR5iRl9VhhwjEoEwh6Lzh
	Oy0AzBmGXHCUFe6TfBbgyVBNusnLKJh+BL+RlEU0vS1exVJtUDWqxygd++PlGlmR
	pSmzgkZ/tsrCMq3uSzK4AALvHGNBRf7HKIxXqBE2PEgRKZZd66NTF5+lahUhev/p
	xIk4rj8KTfnCcMrDRe60NVqJhWQAwgFF255IOImoVhAR2jmG19ijqDtVcFnQnQvy
	nmPKMiP2+hDqQvQjHT4bw5URdWr4WKGhV9bxuCG452VMpLJPtETBwPwvxJMnY8j2
	NHP3A==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46sqap95m9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 03:06:37 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 22 May 2025 03:06:37 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 22 May 2025 03:06:37 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id C32F23F704D;
	Thu, 22 May 2025 03:06:33 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 1/4 v4] crypto: octeontx2: add timeout for load_fvc completion poll
Date: Thu, 22 May 2025 15:36:24 +0530
Message-ID: <20250522100627.175210-2-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250522100627.175210-1-bbhushan2@marvell.com>
References: <20250522100627.175210-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: WPRcD1qQenSbEK8WwlHzTZuYqVouYnpA
X-Authority-Analysis: v=2.4 cv=HfgUTjE8 c=1 sm=1 tr=0 ts=682ef72d cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=dP9LQboaRqI6G61vZ2MA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: WPRcD1qQenSbEK8WwlHzTZuYqVouYnpA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwMSBTYWx0ZWRfX2DghlUyE8BTy Nac/WmWvvpsFo6KRa+rf9gBiV/8kGkbhvZ+CJHXSuwFxcttV6GOwYATnkgCKP1JFECbylwcHraz g/f6ihCXsS2LQRFXkVhHpjGrpXzRs5EzB7j6KDKpKeRXjYBJ2+BaklHBRs2wHpVaJjZELWYRVF4
 jHrLDcL/brcmYcFml9umEsAVokNxmXbJJ4M18AHYP+H7Xdy4qpc7At6BW13daMEmHFGir/olvAe whq+FK9VOsECDzSsDZdu94WLQdEek1SL0GGNHE5aoqiC7ZFsNSNFaV5q8hTL7JV+YITWxr/Jg1F tWb8OTVhn6K5V1AfytAxGyPqLN0LmBh4Dw6HqoMl6GOK4IZgWF0Qs/sv7vyJGmXYqg5GLH0ltmr
 CmhyX+rBPJZnyl0eKzslcPtW86NRy/QU6ajcqJOnwacpyVro4C2zq6wP3Qv7yGDiiyJmqOL1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01

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

