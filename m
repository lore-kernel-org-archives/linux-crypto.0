Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74C522E00E;
	Fri, 16 May 2025 08:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747385104; cv=none; b=SNeFOiYCEes8fL/TbY4hzBUuYpZ0ewqOiQlXaQlgfkZduEBE5OIc+D66vxzhNyAwafTlT8paBrsmkf9HCZLJxZKj1cMJo/GqONGllb64/DPdSVWOwUNQjCnVKMdkww3KyIM5aWhVBtVKhg6dAyR6d4fx0pm2tmd0nAur3dmtlj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747385104; c=relaxed/simple;
	bh=MCPD5vLVfDPlZDQL7eGOOEzDsmZvrf8VWIwwoE0whJs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gBMpm7/+Gygf6DhgAGB6pETnxeRrfDjC8g88jk/nV5L1gQ7ahCG1/0C9hC81Hd+2mDG/lZTeTH+TRMy8EX3UNu5pLmjxJ7ePMimvB99fwOu7QUUGuQr0A+/SAzf99kFxAKkZmHoErpCQC3ENbvzG6G6szQXx8PniWv1FZhMZDl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=dzxxhTxZ; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="dzxxhTxZ"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54G7up4N008332;
	Fri, 16 May 2025 01:44:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=F4WHEyC2UcuKVIqP0y7lKr7
	SaYwxU8ryoBlI5c6cbcE=; b=dzxxhTxZoD8b1tRhcIWGPUQUj99o8ak3sUTbln4
	VmBLfm53d4kinsQnVvB+vtHj1W16U2HyfKfcST024xRCY6hxqgLKEdlhMp2iRVS0
	+a7rS5rbPI6AUX3ecQocL3AxpTo2rlOhpSwyjPfrVTN2zQpxZAUAnpTxjvl3g/h9
	yUfL8ZEbyfKhnyzDZIamxV8sousX+N9LjBqEMA8+gorpVQ91Cr89xoAD0wpwk7yd
	FCRDdJT92/En4UkCPPK3dGZ5hoW1H7qi5xWlkzBQYOtFjJ4JcSLmIzWzD3N164BM
	0NEhCryyWMWlyRt3cc+4jim9xPj/F7bMDF2erXJiZb3wqCg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 46p1du02nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 16 May 2025 01:44:49 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 16 May 2025 01:44:48 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Fri, 16 May 2025 01:44:48 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 5A7BC3F707C;
	Fri, 16 May 2025 01:44:44 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>, Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH v2 0/2] crypto: octeontx2: Changes related to LMTST memory
Date: Fri, 16 May 2025 14:14:39 +0530
Message-ID: <20250516084441.3721548-1-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: IH5gXWqIRfCMVLpD6jzdiNjAD9fNKKO-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDA4MiBTYWx0ZWRfX75uIOdWJ4a0P BfG7woKXlp1uAud1rDPL8h3zCZoypX8jv4yDMAE88z/PoRTMbj1+CpE9IU/J/+eaLMaJi3iWQTA bDkVTpvzBSzlwQDFJozXzlzVkh3YkVrYd/vBHjYt4QDVtQKjpLAnHocj3nEhl+MaWxZKbDjLGh6
 EKWU5oRo9LW/6KuP0JYb4NtqwkCxQ2mQtW48AWDIq30eyIrpPX2NkRgLxVt/AE33m3+K5sPC0YF a38DJzCH52/d8EHvhUFkKInwjs6rFTCgxh3DuDoka6toxLnfXxXbBQ9hUqzwq2p+5P7Iv7ae2Fq pKRjJ4nxzBNwyVQq/CNcwAmVsEvtzX7wWyuMoGVJXgyy/+kH1ZSrBhyTM0G+ST6Ix4KIPMrko8r
 dsOwZelu0+2/PnKCbl7lvdxbroSXnVYxWru0ga3beSOdRFvXMVCl/iXYTJyrf2+uS4kGkXqE
X-Proofpoint-GUID: IH5gXWqIRfCMVLpD6jzdiNjAD9fNKKO-
X-Authority-Analysis: v=2.4 cv=fvPcZE4f c=1 sm=1 tr=0 ts=6826fb01 cx=c_pps a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17 a=dt9VzEwgFbYA:10 a=5-JLTSaU0EQnWg3z5X0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_03,2025-05-15_01,2025-03-28_01

v1->v2:
 -  Removed changes in pci-host-common.c, those were comitted
    by mistake.

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
 12 files changed, 133 insertions(+), 47 deletions(-)

-- 
2.34.1

