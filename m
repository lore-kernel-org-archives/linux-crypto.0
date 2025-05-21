Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92F225B1D7;
	Wed, 21 May 2025 10:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747821922; cv=none; b=q8CY6tquh8iDXPX9OtWJVmwl0GAAac2cxUedzXFXR7Mx7vi1UTsJSVpbTEK6yOF+8WXyTgCfzkNEztDsQOPQ3c/y0pLH8P2G0/zaC+CJh1EgbbbwRWNIOCqAf2j9Jy96EdFBHekKRyomqXsW/fNY2Jf2BOmjllnEzRVgU05ZSKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747821922; c=relaxed/simple;
	bh=QBcXV2Go+RTJKZL8GPyRsRvcvbYEH2UET43WgqAY/IA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=csk8JRvA5fpXGZyMoK+DQnipiaw7iPU9Luz0GCif3raeQeaqSx/SFfb90Dp+Kn5/nHDLSn0mZwHV/Y6Dzsr4UPWYJBqFCNEgkfEgAUuBsK4GAqRLO9qwzVyIwsBKtlDqEnYGfIhMYKKnmSfw3PAnEfy8Ckcq5FnfJs4KSehGBmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=G1xohiG3; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="G1xohiG3"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L9qwbi010202;
	Wed, 21 May 2025 03:04:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=ESmwcFjV+fTv0t4n/zIs3wo
	g9UJs7PIJJd1mf0W/d/Q=; b=G1xohiG3D1hYjxp1LyDzMT5H4HxCidwddc9hG28
	YUrHgjUcsMw0K85DIiIuGYYBXTqKrpKHxmfA7Knui6U8LGqSTTyLhQlo5HZ+B9CI
	oT78RxggDwFAW2XBNlPVs8AmJwzyvkyDfUmzEFjuxc145vgROXwDZefa3IKuGVoj
	DTZiqkq85Chgw6TWcVPTnLIEReN6LeIW5JIhngpfC60aBjHHpix9yLU1PSrFxleK
	c0x4Oec1Pgo5/d4ANY73exz7JPKNJSmGvg+AHfCBvPn2Y0UFXSn29zsC8wryQ+xO
	L9/EtXPTg3dtzdFjz3o2EjPl3iCJcDv90Hp0CchndG0ieqA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46rwfghpgd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 May 2025 03:04:56 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 21 May 2025 03:04:53 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 21 May 2025 03:04:53 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 242DC3F70B3;
	Wed, 21 May 2025 03:04:49 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 0/4 v3] crypto: octeontx2: Fix hang and address alignment issues
Date: Wed, 21 May 2025 15:34:43 +0530
Message-ID: <20250521100447.94421-1-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDA5OSBTYWx0ZWRfXxbVLDjiVJxOR glwwXGWgvHUeGlCBjnnNmMXV3NiDkeY3OzRH3AcqKrRxULB8xBq3jKBn2nXsQ9XhI2W5jP8DKXT KAlFFdYM3PnS4dbhlXZRHoWMghWNW/qLalo2ERpZIsVYbH9yI9LiYYX3IfTptz9LqANN0mPsBIf
 8g9vz1WvkpSjXnE1Gvfc0CrAnOjkWaq3knFTuINS4rDmcJ6WePElLMy1nNnMsR2HYD0YsbdOkdX ifznzLtkjbAIY7zrhhEHOcD46roVdJRdDAfWReV71GuJv2UwyV5Ma1Qx0TsKXE/YIuENsvo+7l5 sKRcQtlJqkkcpDindy/u1/+I4GDWg7ojFT90f7o357BTEamB9+Au3R827WVH3a1h6VwTKaXX/6C
 ZcoFwszUVVfLioolKN8Z8Gmei3vScKWLwIhx9oXBbQgPwfz/cbgsxxkUqwP5vYnEKLadMEx3
X-Proofpoint-GUID: MTMVrTTh5psOTIC3JOHOGxcFzvm_rh-C
X-Authority-Analysis: v=2.4 cv=T6OMT+KQ c=1 sm=1 tr=0 ts=682da548 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=voKHntS-kiqXh1f54uIA:9
X-Proofpoint-ORIG-GUID: MTMVrTTh5psOTIC3JOHOGxcFzvm_rh-C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_03,2025-05-20_03,2025-03-28_01

First patch of the series fixes possible infinite loop.

Remaining three patches fixes address alignment issue observed
after "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
       smaller cache_line_size()"
  
First 3 patches applies to Linux version 6.5 onwards.
Patch-4 applies to Linux version 6.8 onwards

v2->v3:
 - Align DMA memory to ARCH_DMA_MINALIGN as that is mapped as
   bidirectional
 
v1->v2:
 - Fixed memory padding size calculation as per review comment

Bharat Bhushan (4):
  crypto: octeontx2: add timeout for load_fvc completion poll
  crypto: octeontx2: Fix address alignment issue on ucode loading
  crypto: octeontx2: Fix address alignment on CN10K A0/A1 and OcteonTX2
  crypto: octeontx2: Fix address alignment on CN10KB and CN10KA-B0

 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 121 +++++++++++++-----
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  51 +++++---
 2 files changed, 126 insertions(+), 46 deletions(-)

-- 
2.34.1

