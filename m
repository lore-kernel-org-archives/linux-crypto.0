Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE24A280A57;
	Thu, 15 May 2025 06:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747289637; cv=none; b=eOIr42fCHgfouqdkKSvkt7Qv8OGiNG6AE/Ym3xxEDOforXGkh1AanYzd/I/82ktAYpwBwIQz6BEKSgNPEKI7Cra7Fq9Rb4fhflBwqZjCGKMw9UPgQAmdY9w65SBJsukrl/v/OYTuNhI37an363syaLtNgggZpc7gW2XdD3ym6o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747289637; c=relaxed/simple;
	bh=vtoknimTlct0P2pBjlgVFtfVvUE2Qtioz9EcT/r3oIw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=LRPE67BJ+dfzpmUSM/1f4gJ3tW/qhlx+R4x5g/WYot/nwC/loFDvjWOZH/AC95obv59mI/al7M+NOJf/CDhofAJNgw2ums6xk7gsfWCxUOVTldeH5+KuC5pXH9tVxSAVvmgZ/itzkKwQhB/Z8jy3AV7u8fYhzKUEe8grErWy1rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=LNw4mOFK; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="LNw4mOFK"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54F48PEe026960;
	Wed, 14 May 2025 23:13:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=anHo+MtlLOaSLRQrmIlyGcx
	guu34jS62bNXAmb/2UMY=; b=LNw4mOFKrz30ja9BEm/gV86yZBjycQXhTcPg5rn
	G5zX959Rr9qZcuwqqS8qK10FT/l9ghiBp1spb6cI3HuURFuUixN9xJpOzh6P79td
	fKGs+XKP7U8F3QhTs4IGT6lNyFPlmVOMicBcWNFqZeub2aIsf3PTyGFDxQ4f9bhJ
	H1WbcDqGcR7QL8anz5Ke9vZ6C61EHnrQ3xjU2ge8gdaJ4IXfL5zOvxq2SL1nwZsg
	bgZCb8a1puyCmhP6E7iou7aqtyySJsQ/8AkAxSfjbo8hriznTZeD5dwI+gBnxGdW
	SdOES5PXqEyyW5tJfZpEpA4+VlKeT1l5pQG32qV180E6lGA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46n4vngm63-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 14 May 2025 23:13:42 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 14 May 2025 23:13:41 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 14 May 2025 23:13:41 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id B2EE43F707D;
	Wed, 14 May 2025 23:13:38 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 0/2] crypto: octeontx2: Changes related to LMTST memory
Date: Thu, 15 May 2025 11:43:34 +0530
Message-ID: <20250515061336.3348493-1-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: djwqasaALAIqBFIlDoqzKcpxMVL0ftAh
X-Proofpoint-GUID: djwqasaALAIqBFIlDoqzKcpxMVL0ftAh
X-Authority-Analysis: v=2.4 cv=aIDwqa9m c=1 sm=1 tr=0 ts=68258616 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=5-JLTSaU0EQnWg3z5X0A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDA1OCBTYWx0ZWRfX26n/tu3pqqhL nrN2PLgcmcfkVjXr771VVFIPosuC5yAt7wBld7F9Jec/BkgygSmGIr7MbkkKN+4DCu7N8qhyzgd BTzLr32dDZW3AcmT4EwdomOJlv1Co3rWBEjKkhcdX9gXYYZ568ej9zLMuotBUPWklkWdQxoWW1h
 QtLTkAAJ5A69AhaoR0JXfp2IYjFxu0FhWGpVAA5xi1gvvyH3j0g8F1TB3+Pc9C8lD+ptsvvvgGE R1sw9cg6glOTVxZLmyLQuLI39viGscwlJrxEj31rvJgOC9ASyxmb3Z6cm85LDEgGcDCt1bKyQRY vGqX10Kz075YgoytUsGSmSTxWdsg5Wyuw02VG69pkAcTBb3EMJR3mpAZ8dsNHZhOfqj/IXIE9eK
 i6+87KroP6S9CnC04gzDCKn1EkLGyVhhzP2gzhjTPN2Fvs9hRbNuna8wpLrGYWWYKpfm6HIb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_02,2025-05-14_03,2025-02-21_01

The first patch moves the initialization of cptlfs device info to the early
probe stage, also eliminate redundant initialization.

The second patch updates the driver to use a dynamically allocated
memory region for LMTST instead of the statically allocated memory
from firmware. It also adds myself as a maintainer.

Bharat Bhushan (2):
  crypto: octeontx2: Initialize cptlfs device info once
  crypto: octeontx2: Use dynamic allocated memory region for lmtst

 MAINTAINERS                                   |  1 +
 drivers/crypto/marvell/octeontx2/cn10k_cpt.c  | 89 ++++++++++++++-----
 drivers/crypto/marvell/octeontx2/cn10k_cpt.h  |  1 +
 .../marvell/octeontx2/otx2_cpt_common.h       |  1 +
 .../marvell/octeontx2/otx2_cpt_mbox_common.c  | 25 ++++++
 drivers/crypto/marvell/octeontx2/otx2_cptlf.c |  5 +-
 drivers/crypto/marvell/octeontx2/otx2_cptlf.h | 12 ++-
 .../marvell/octeontx2/otx2_cptpf_main.c       | 18 +++-
 .../marvell/octeontx2/otx2_cptpf_mbox.c       |  6 +-
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  2 -
 .../marvell/octeontx2/otx2_cptvf_main.c       | 19 ++--
 .../marvell/octeontx2/otx2_cptvf_mbox.c       |  1 +
 drivers/pci/controller/pci-host-common.c      |  4 +
 13 files changed, 137 insertions(+), 47 deletions(-)

-- 
2.34.1

