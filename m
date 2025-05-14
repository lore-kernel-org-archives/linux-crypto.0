Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DA71F5430;
	Wed, 14 May 2025 05:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747198853; cv=none; b=TOkKai1Fo34AaTjIJG4gTE/qIOIKTSe506FVgf4WFPfpWYZOdfeNVvIWCPMwD/bSxUk0hK0H+8QI0HlIMrvAMuRjHn00CnXbYF2rVKyvCGRuu62u51MX7Krt54ErnkQeb/ENwWkzbu4MtPpM1GcKMhBt7k1N0PYkO8Yo87KYycg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747198853; c=relaxed/simple;
	bh=nftJTquf7IRaq8HHdnbjeXO05NPydCSiIigaPKYx7mU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZkGzcg2X/hT3sCkIkkC8pWMzadb3SN3CE3dihCH1HlhMLDXjL9vkKPHnDPYESn7vggJzfvIt1Z8/9Vc0k/Xku00TrGgzoEMh1BKaGwcJ/9mQFEaOp6jGvA9es1Nv87T+Bft7Mn8rDUXQEt8DWDyDM+cXhodVzu1N+d1OKEJbIRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=KI6TLQyO; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KI6TLQyO"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DNSt36028349;
	Tue, 13 May 2025 22:00:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=u
	Walq60J9nmTGN587g4K2toCWBPNF4Fg/bQygVQX8eM=; b=KI6TLQyO4b+ibOAXX
	oLpeMORD5f8p8C/nlIBevZo9g/Mt21dNn5dYwxPP3EAxJzq032JsLg8j6h/WRAmt
	hRY8P0ZCLsqE7liFkuR9kRGuv/X6f1u6mK62MSh7/JUg7+m45FLZP5g+G4TrcFvg
	grF2vZ18W6dXEaZsqPPaAKEbufOIv24N6bisfCWZfrcvGG5a1mbf9ubypB0cTN9C
	14L5vr4bTB/Yhzdc1j/rer9wC5XW72IqjthDEKSE+AMFuCCOfcl5DzoLzZp3LcH6
	1P+1XA7gkW7qCwrL4voYAYhZvImf2MWUDSZy+dSH7tlvazo/YWRWwvFoHiVEewXa
	4K6HQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46mfssrg5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 May 2025 22:00:36 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 13 May 2025 22:00:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 13 May 2025 22:00:35 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id DC8905B693E;
	Tue, 13 May 2025 22:00:31 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <arno@natisbad.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <iovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 2/4] crypto: octeontx2: Fix address alignment issue on ucode loading
Date: Wed, 14 May 2025 10:30:18 +0530
Message-ID: <20250514050020.3165262-3-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514050020.3165262-1-bbhushan2@marvell.com>
References: <20250514050020.3165262-1-bbhushan2@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=OvpPyz/t c=1 sm=1 tr=0 ts=68242374 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=M5GUcnROAAAA:8 a=ub5NSpVJfYrinLkKqRIA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: sKZu00-gmkJoiBol6v4nutWc372NI5kP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA0MiBTYWx0ZWRfXzbx+AHp73A31 XoVgaCxsfGijkHPM/8drf4Lyiz4q0bMxSe8gsaOPYQaGWKNToZgAlKD32xwA9FWuBLq/eV+4U9T 9hPEGcXPaLr+qAm9R0lYUx+ZGZQKMg6jSTfbWIxmOyHfDFFdwNxgW09/o5/ZuasiumG9WQh6C3r
 2miyGFKwlkKdl2/clM2hlIzyWf7i+qVtvI8rx/x6KNenzMdUZ1NL2IyZqlFW1OiEKi9utdLPR/I qXhMybub+9cyufDVK2vzPC9+i7yPnrYkGQ1YaUFAiq8msyjQ4AKmyQcLz67sHY3Nm7BBvJzx8MB UG5n01v681vZCd5naQsKyISmjeP12J8EhV4L7M1XWKPRfDKGQ3sR+pYOxDABJqYwv72Qp5IFs9E
 sutQma9ascMA8bJU0+qCfoiur22GOjH5uPzerpXIOBfm+pRtbkOQRCpqcUTRzzenUYvswkU4
X-Proofpoint-GUID: sKZu00-gmkJoiBol6v4nutWc372NI5kP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_01,2025-05-09_01,2025-02-21_01

octeontx2 crypto driver allocates memory using kmalloc/kzalloc,
and uses this memory for dma (does dma_map_single()). It assumes
that kmalloc/kzalloc will return 128-byte aligned address. But
kmalloc/kzalloc returns 8-byte aligned address after below changes:
  "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
   smaller cache_line_size()"

Completion address should be 32-Byte alignment when loading
microcode.

Signed-off-by: Bharat Bhushan <bbhushan2@marvell.com>
---
 .../marvell/octeontx2/otx2_cptpf_ucode.c      | 30 +++++++++++--------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
index 3a818ac89295..1c2aa9626088 100644
--- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
+++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_ucode.c
@@ -1491,12 +1491,13 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	union otx2_cpt_opcode opcode;
 	union otx2_cpt_res_s *result;
 	union otx2_cpt_inst_s inst;
+	dma_addr_t result_baddr;
 	dma_addr_t rptr_baddr;
 	struct pci_dev *pdev;
-	u32 len, compl_rlen;
 	int timeout = 10000;
 	int ret, etype;
 	void *rptr;
+	u32 len;
 
 	/*
 	 * We don't get capabilities if it was already done
@@ -1521,22 +1522,27 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	if (ret)
 		goto delete_grps;
 
-	compl_rlen = ALIGN(sizeof(union otx2_cpt_res_s), OTX2_CPT_DMA_MINALIGN);
-	len = compl_rlen + LOADFVC_RLEN;
+	len = LOADFVC_RLEN + sizeof(union otx2_cpt_res_s) +
+	       OTX2_CPT_RES_ADDR_ALIGN;
 
-	result = kzalloc(len, GFP_KERNEL);
-	if (!result) {
+	rptr = kzalloc(len, GFP_KERNEL);
+	if (!rptr) {
 		ret = -ENOMEM;
 		goto lf_cleanup;
 	}
-	rptr_baddr = dma_map_single(&pdev->dev, (void *)result, len,
+
+	rptr_baddr = dma_map_single(&pdev->dev, rptr, len,
 				    DMA_BIDIRECTIONAL);
 	if (dma_mapping_error(&pdev->dev, rptr_baddr)) {
 		dev_err(&pdev->dev, "DMA mapping failed\n");
 		ret = -EFAULT;
-		goto free_result;
+		goto free_rptr;
 	}
-	rptr = (u8 *)result + compl_rlen;
+
+	result = (union otx2_cpt_res_s *)PTR_ALIGN(rptr + LOADFVC_RLEN,
+						   OTX2_CPT_RES_ADDR_ALIGN);
+	result_baddr = ALIGN(rptr_baddr + LOADFVC_RLEN,
+			     OTX2_CPT_RES_ADDR_ALIGN);
 
 	/* Fill in the command */
 	opcode.s.major = LOADFVC_MAJOR_OP;
@@ -1548,14 +1554,14 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 	/* 64-bit swap for microcode data reads, not needed for addresses */
 	cpu_to_be64s(&iq_cmd.cmd.u);
 	iq_cmd.dptr = 0;
-	iq_cmd.rptr = rptr_baddr + compl_rlen;
+	iq_cmd.rptr = rptr_baddr;
 	iq_cmd.cptr.u = 0;
 
 	for (etype = 1; etype < OTX2_CPT_MAX_ENG_TYPES; etype++) {
 		result->s.compcode = OTX2_CPT_COMPLETION_CODE_INIT;
 		iq_cmd.cptr.s.grp = otx2_cpt_get_eng_grp(&cptpf->eng_grps,
 							 etype);
-		otx2_cpt_fill_inst(&inst, &iq_cmd, rptr_baddr);
+		otx2_cpt_fill_inst(&inst, &iq_cmd, result_baddr);
 		lfs->ops->send_cmd(&inst, 1, &cptpf->lfs.lf[0]);
 		timeout = 10000;
 
@@ -1578,8 +1584,8 @@ int otx2_cpt_discover_eng_capabilities(struct otx2_cptpf_dev *cptpf)
 
 error_no_response:
 	dma_unmap_single(&pdev->dev, rptr_baddr, len, DMA_BIDIRECTIONAL);
-free_result:
-	kfree(result);
+free_rptr:
+	kfree(rptr);
 lf_cleanup:
 	otx2_cptlf_shutdown(lfs);
 delete_grps:
-- 
2.34.1

