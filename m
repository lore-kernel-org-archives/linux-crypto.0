Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4232B101F2;
	Tue, 20 May 2025 13:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747746477; cv=none; b=aJ0s/LUemN8OvNw+20RluJjlY8eihTaOb8jKDq28Q4E2t1Gz2i73m2BIbbMy4+4C7xLOYycvMh7YZ1XDiLh6leM11JZMlU40Y3JsGdfLN3APqBPTYQToOnIKDFT/mZqo3LZRGVhZewHvoJ3sDsqFUtSKowTiOhWFyhNkBmvtCpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747746477; c=relaxed/simple;
	bh=YVFgeWiJ2UMkrAkbzkvFnN2kCUO3lFkNmGfrgH+DacQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lH6Dg5k8OhyvTakVKCpNR8Hj0IwD8zQQoLBVkRiaPtOEHUn3YXTBhl31t27XepV+pbbEaevKE8RzwrZbWS95v3UaOK1ML6kAIU5GXkyy70qALhjztP79nxcrZdDDNu8ifZRT0q058YvciovQ9L6iUjjN7PhYZauUpvSaMG1cVDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=cU5HceWf; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="cU5HceWf"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JHr0Dm001883;
	Tue, 20 May 2025 06:07:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=gNUEfOuRGNKUAiL7nngBHra
	pDxkhCe31fRPUmYEGbsA=; b=cU5HceWfQTbOS3LLZT9mnq0yQeGI2RvbXLPgTq6
	tzla8fkCS72vmWhRmXGNLl2a029l3qF7D+lICOu50AfOfZvipAGLx/IA984E5r0u
	E+3q1s4N+fBzj3/U4+U3LXw8rjQ9P2c495QlWeav0ni47w9XK0edWEoMPFvVxeKN
	8ig9Cu0O+3Kxw3Mf5sRYLhxL03dA//Ng4nrnD4vBfVpzhrc4tGm2IzEtZJERZ6/o
	52twql0xIBx/fxcfBXjfRYEOXiaeAiBYUzntQnYZ/ZYyVdLN4fgQV4PjfOgrsma7
	FqUSNuHgD24fiMHxcieP6nMMU5FF+ddL5ycq16WD+nJGsMw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46q46fcvce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 06:07:44 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 20 May 2025 06:07:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 20 May 2025 06:07:43 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 35AAF3F7061;
	Tue, 20 May 2025 06:07:39 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <bharatb.linux@gmail.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 0/4 v2]crypto: octeontx2: Fix hang and address alignment issues
Date: Tue, 20 May 2025 18:37:33 +0530
Message-ID: <20250520130737.4181994-1-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=b8uy4sGx c=1 sm=1 tr=0 ts=682c7ea0 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=4t-wQQLICdffoIUl0A0A:9
X-Proofpoint-GUID: dnoH5JX8a8OhNSQylY87QFENWGfUJ5hF
X-Proofpoint-ORIG-GUID: dnoH5JX8a8OhNSQylY87QFENWGfUJ5hF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDEwNSBTYWx0ZWRfX5kwduRqQKpao hOr9nPYVlZqS83J/dRobAyaO949Cm7JC0354wpWrZIvk9GasP3xMzPlwm029g+/fVb/78Fmqihk bcbKhhw9kL+IClbtY2AgU6fWrAxsGyZtcLi8xQcVplcaijFMNky1iCNSn/xQ5vWBQkj2ky/9BTH
 CI/dqZHgXEn3ZqeSlFy02iysqV3e/jrB638BOXeqe1I3bc2Zzs/k8TOxdRrTS8ROnaVWTR6Hn6L PUqv6C8cuLwi/ZfZmaQU9GdAxVoBluncEC7zVS8SFeAroqvguJzSziqjkbEVU4JnYylFnx4IJAQ N1GJB9n0nARgvjCqYKpQwKuxbkPjHmoOX7VfM0hMytLgQsVKCPmUiTk0goDJuwqkRYhEfznZAtW
 ILkUDBOOXg7iHoNSAz0KXTOEfADLcAmHtqa/uBF+p9kAH8RHsHsyxKasrsfAamt6Y4saNW0o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_05,2025-05-16_03,2025-03-28_01

First patch of the series fixes possible infinite loop.

Remaining three patches fixes address alignment issue observed
after "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
       smaller cache_line_size()"

First 3 patches applies to Linux version 6.5 onwards.
Patch-4 applies to Linux version 6.8 onwards

v1->v2:
 - Fixed memory padding size calculation as per review comment 

Bharat Bhushan (4):
  crypto: octeontx2: add timeout for load_fvc completion poll
  crypto: octeontx2: Fix address alignment issue on ucode loading
  crypto: octeontx2: Fix address alignment on CN10K A0/A1 and OcteonTX2
  crypto: octeontx2: Fix address alignment on CN10KB and CN10KA-B0

 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 123 +++++++++++++-----
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  46 +++++--
 2 files changed, 125 insertions(+), 44 deletions(-)

-- 
2.34.1

