Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A54A289E2E;
	Wed, 28 May 2025 15:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748444467; cv=none; b=DPFnsO7V1Kqww8UHcim7fXuuSjzdki3QwBTFqmnUeDWs2wKZU00XXN7A/nXTq4lWgi1xT8gzZinkaUMl3NCLY0AOBB+dTCLSH9lL1fye2W+h4+Wcv9JCZO2ZoQCSU4iroZ5iCWYhyGOKktQa6/j73EzmnOLHAUThB/lNgP/QDVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748444467; c=relaxed/simple;
	bh=2uJ+tGZqyrBrCh0Qw9nMaeH5x+2ObMmNmZLu+fhKw7g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=odAF05gWmTE4bpTZlaEfJt6NbLsh0WZVlAvlwsimw0hYmU61pdtOD0FwFIwoq7hptMK9kYDfu9epqmlwxisLeVOsqHV654+xp/KhcZDXHEGje9szp67LPEdf/V+3Yikgv09p0Owy4hqfd4TK8FC23b5GxNFFB2SV/VzppnjSeiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=F7O/Losn; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="F7O/Losn"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54SDqasc021258;
	Wed, 28 May 2025 07:59:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=mMHJ+m5f3/50TEokEsHWSSl
	ZWDK+XJmegSFBuiUr1e4=; b=F7O/LosninwyHKOF7YEfNYRemNmqK0ZrHbAnQAW
	lCJHBy+PEm7FeiuiuIdpOOBvalzidoe7xAMUviH/b//hHcvYvV41XO7r+Cjy5Zki
	hoa5sPlw6Ul7i7QnaKGxLA1KfTAeTlwt9iSM7c/bh0Fcs5Fht+/9IomzIjhiMRmI
	hbi0FXV0boSioirCDyy9bg+g5aEqkIeGmISEzojlcZmbnidSQ2/pD6v05pFBvB09
	/K+eD1xzLC2qMuKWkglw9IJ/aAVsB36B/3gXlP2a76vxPtlqeYeS2HQd+WfGOst2
	XRRzlLxTVr4n/cj7pXK+AtDozWP0zCEwvKgz0GBKzcj2w5A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46wu5ah1rc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 07:59:52 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 28 May 2025 07:59:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 28 May 2025 07:59:52 -0700
Received: from localhost.localdomain (unknown [10.28.36.167])
	by maili.marvell.com (Postfix) with ESMTP id B389E3F704F;
	Wed, 28 May 2025 07:59:47 -0700 (PDT)
From: Amit Singh Tomar <amitsinght@marvell.com>
To: Srujana Challa <schalla@marvell.com>,
        Bharat Bhushan
	<bbhushan2@marvell.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S.
 Miller" <davem@davemloft.net>,
        Amit Singh Tomar <amitsinght@marvell.com>,
        Kuan-Wei Chiu <visitorckw@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Philipp Stanner <pstanner@redhat.com>,
        Shashank Gupta <shashankg@marvell.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Tanmay Jagdale <tanmay@marvell.com>
Subject: [PATCH 0/2] extend engine group handling for Additional types
Date: Wed, 28 May 2025 20:29:39 +0530
Message-ID: <20250528145941.2659706-1-amitsinght@marvell.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDEzMCBTYWx0ZWRfXxGqDrFNrVK63 qbPMlMk2BT/0K330mYfu8mnnp8hAyk9f5MTHwQBNDdhXzkhuwQW+QmkugUlKpAgZcLf9nckacbM xkSdIQnyUZf8kltTkYVJULskkWWFK/5Rg5Wi9uXkCkuXD4tuLtCme8DLayYMmcSKD0ZS7/JQyNJ
 1IKBwNLFuvWehIaOWlFz3XRM4xD3hg84Hpd2U0f0ylIrrtIv4paiIRHTRCJb6kBiQIGNFdCw03E kWZNddKiTHNitCm8b2did79EF7m01Yff8D5Unbghn97h5SKDMhsfCFm6/NOCv6smbn2PIQMoI56 N0olU8+Fd53pXhdOdTBbnCJz34ZQRSPDl0GdLObKMlfviwGjssPeMuwFFRxRbKl64oKVqd50yiI
 +Zh0QZ5JcIQ7lXQt0JlwI5BD3MshVZ65uBb1hCJS8eANeyNOQaJqTeA8juunT3zHmYtMe1Ap
X-Proofpoint-GUID: eM80qeMSim00De_t1G_1G2PE3sTkOUDS
X-Proofpoint-ORIG-GUID: eM80qeMSim00De_t1G_1G2PE3sTkOUDS
X-Authority-Analysis: v=2.4 cv=UahRSLSN c=1 sm=1 tr=0 ts=683724e8 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=CBuo3nfPA_17JlLSTRIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_07,2025-05-27_01,2025-03-28_01

The Cryptographic Accelerator Unit (CPT) on MARVELL platform supports
different engine groups to execute both symmetric and asymmetric
algorithms. This small patch set introduces minor enhancements to the
engine group handling logic to ensure the correct group numbers are
obtained for AE and SE.

patch(1/1) 
	* extend the otx2_cpt_get_kcrypto_eng_grp_num() API to support
	  retrieving engine group numbers for additional engine types.

patch(2/2)
	* Add support for retrieving the engine group number for the asymmetric
	  engine type.

Amit Singh Tomar (2):
  crypto: octeontx2: Rework how engine group number is obtained
  crypto: octeontx2: get engine group number for asymmetric engine

 .../marvell/octeontx2/otx2_cpt_reqmgr.h       |  3 ++-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h |  3 ++-
 .../marvell/octeontx2/otx2_cptvf_algs.c       |  6 +++--
 .../marvell/octeontx2/otx2_cptvf_main.c       | 26 +++++++++++++++----
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  7 ++++-
 .../marvell/octeontx2/otx2_cptvf_reqmgr.c     | 14 ++++++++--
 6 files changed, 47 insertions(+), 12 deletions(-)

-- 
2.48.1

