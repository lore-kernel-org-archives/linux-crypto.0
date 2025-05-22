Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73329286D72;
	Thu, 22 May 2025 10:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747908406; cv=none; b=SYEx4DhbOCw/PdBn6dQ8uhQJPKDk2C/UW+lIJkY+9vDdumZ/D9NyW816GAHFWMdewpydbHlI1depNMfTDJ/ZnsRhuWegIYb3bM6/PbL53s61RNAFVy8TP5kpS1MrknPwqONhGqDDFLVr8itim2d1Iv21MK73MO2MyA4YniJXxQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747908406; c=relaxed/simple;
	bh=V+HOpa4ZLt1QROCir0lhwmjopu2L6RTP7KP9xQg1uIk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kSi2sSd+wPrzOsolpMVmkI+ujNiID5DGruwom7u9Ng07jQCYXNgXr8O3jlsunHe3Op61RvVzyQIE0j1BBfpTYkZ5WpibziP/Rahe8CTdWZCaV4onUckRvM+CoTTWEyCTlypiXimyOX0vWtklQK6bGl53LZvSB79U9BZ7r6/bGKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=LyG5lhXZ; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="LyG5lhXZ"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LM5XFp008367;
	Thu, 22 May 2025 03:06:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=1oY3A2J8MYXiGNyA+QlmBsr
	Ldc2IdL7dWZwQfg2v234=; b=LyG5lhXZPgjAcftpgyGPXVFgEFWsDyUMUHV8nBa
	3xdpqCh5PQKShi0PggKbjvH7nHJx/IMQmze0nJ0FjEEwdaLoNiktmGLNpzucoiOS
	mSc+MifdE8I4BpesE7G9dkMaYRu6HpNHUmf1ArJgl65WX6aqYsEMlEk3P8j3DV+q
	rOJZFAD5bJ7ICldHlu1S3LaObgVJaj7H5Vg5E6XmEGIZ4Atmq4W+Ls0jTgTJ7ZCx
	HwfK0bVcMX83C+1FWrUlrgnBIep6thIdbsFurc0zUxixRbQ/uwU4O/Yk5VXBMfAt
	Qm6+0YD7ogLRE/+DjVoLrCUISCAjqfgAcXMOyEp4NEV0hHg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46sqap95m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 03:06:34 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Thu, 22 May 2025 03:06:33 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Thu, 22 May 2025 03:06:33 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id E134D3F7083;
	Thu, 22 May 2025 03:06:29 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 0/4 v4] crypto: octeontx2: Fix hang and address alignment issues
Date: Thu, 22 May 2025 15:36:23 +0530
Message-ID: <20250522100627.175210-1-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 56QjARDuFOCbNE-2Yc3azTlz43rYs7bE
X-Authority-Analysis: v=2.4 cv=HfgUTjE8 c=1 sm=1 tr=0 ts=682ef72a cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=31lhjb_RWtGG_5pqcG4A:9
X-Proofpoint-ORIG-GUID: 56QjARDuFOCbNE-2Yc3azTlz43rYs7bE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDEwMSBTYWx0ZWRfX+ls7ufzMKr3z f8pIslddte1K4vKA+ZcwoXWVvtIc1N88M0/2kFKwEfXVh1xDcH0G/VfFYMGobYKF7RTtZEq3zG7 PUUx8DtQ3YNuJRjWW/gbChmSlTD2qqdf9MVhXmBFKV0UIerybHnxX09UG3ykvrvnOyPdJa1bBUm
 TrorIxqkpVOK6+m3b0QeSOE5q3CTHehFz1aONtMH1jAyCH1roonsFUC5JiyB5RrEDMkKanxu1iV DaU1aDMyAaDgsRLaGzMRErVMwU0jmOFwUjZIULXe20GRuuMdYpkpuR9AH1JZxCSyn0opsDQZS66 xr8XWbrfpTCCglMgKRb9pbiTPv+PUe+kNTZvplmZwvteAPRmN5V+Ya8lgStibHM96SgoeMo6Ztf
 +rgNp6EdigY0pD9BWcSecH/6Xd72v9w/S/3CnrEHQG9BFiwi+JUH/p9SPjUJgGZH6LWcNLJd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_05,2025-05-22_01,2025-03-28_01

First patch of the series fixes possible infinite loop.

Remaining three patches fixes address alignment issue observed
after "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
       smaller cache_line_size()"

First 3 patches applies to Linux version 6.5 onwards.
Patch-4 applies to Linux version 6.8 onwards

v3->v4:
 - Again fixed memory size calculation as per review comment

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

 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 125 +++++++++++++-----
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  51 ++++---
 2 files changed, 130 insertions(+), 46 deletions(-)

-- 
2.34.1

