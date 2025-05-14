Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA2519E975;
	Wed, 14 May 2025 05:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747199492; cv=none; b=pHumWwhQvphjfd5WGZqZUWDQzzYR9guipLYHJKKq3KjlDrvcAYg8SD+jZ07avIzyNeWv2OmOu6/34dqtDmT6NaCTRM00dZkr5perQHQOORjPnz5AfGvmgxba0K1e2tlRTz7nd/jL2nzSBmonDMOdvO+j6rGDuuIaAIK41ExoigY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747199492; c=relaxed/simple;
	bh=DOk6w4KAtF/2yyHIl4W/3BA+O6PvltzofmtBqfLTc9U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qFPHGnrub8taBHJi9/Vzs/zksJSc5sUl/IY2llGgSPREhZairSN8ZiaxPGqNdA7DmXx5ZKxmS8vcJ5284Z7Mg4faDzZmYrZy3ZZ8iVtVDp/nhAJpetdy74sDEuYUo5CFcsCUI5XL5LDbCOwk3PML+WJdA/G05pWMw7EgQjI5SS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=kwdEWofw; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kwdEWofw"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DNU10p018657;
	Tue, 13 May 2025 22:11:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=HBkYcfhQW5E/EeMsTr5py5E
	JzuJHUSEjDNHl11vsfGA=; b=kwdEWofwDwz6h//gWXs8U1nWdgmModTvW8GQ+ml
	4Vlal5wo+Y4G9cOgce3sxmnlywbrGVpqHRFdWIM3hR/GHUPf7jlVvQJTpDAdXHtN
	E9hiiVG7tTVMIN4ZkZK8dPX1d3Yp5UQn4wLo3twyvYAXC0OojRrgRGZJtks0S5Mr
	urom44oZvTrS7MqIzpTxOopCIPffO1h6BfOooZuJpbyGP+U4HQrdRpzrNa0wmtKf
	tVPEjNb5+KLcb0J6ScwV5LE38k4pqi9aHsDmEvFriPfKKPA1J+rvhRYcr6mzDonp
	Tt7E3jwuEfB33itoQzhMkaAcB6C4MPgpNoOGbMcRIWpg2vA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46mft50gvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 May 2025 22:11:13 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 13 May 2025 22:11:12 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 13 May 2025 22:11:12 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id B400C5B693B;
	Tue, 13 May 2025 22:11:07 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <arno@natisbad.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <giovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <bharatb.linux@gmail.com>
CC: <stable@vger.kernel.org>, Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 0/4 RESEND] crypto: octeontx2: Fix hang and address alignment issues
Date: Wed, 14 May 2025 10:40:39 +0530
Message-ID: <20250514051043.3178659-1-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 0tcbA8q4hieW-hLdFQ9LezAcuoxpiC7g
X-Authority-Analysis: v=2.4 cv=VITdn8PX c=1 sm=1 tr=0 ts=682425f1 cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=voKHntS-kiqXh1f54uIA:9
X-Proofpoint-GUID: 0tcbA8q4hieW-hLdFQ9LezAcuoxpiC7g
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA0MyBTYWx0ZWRfX0Yo8hlyuRNMB 0xgH5mAbD23FoN7bBR94N1HAiwFtD9nMW5bI2Y505TEm8EA5RA5tpVYGef1KHwVVi94V5me7Mdw WYOnZyElewxeZI/hMotipK8dhblcxvb0Dh9uMotxlBwslNV7673e9o6xJtlVA19L7rC96ZYbnjB
 MHE+62eiN1wh2TCBua+La5uijnnWbyYYsnqyFcvk/McohoI+L8nc/h6wG7fJYb2xYWZzzkq1bj5 klx+vmNoYMUfLuYIDPpv9BtQRdOUPg5vYyIFm/Ihj5Fn3gJaM3p1v/Le6qiU37kOuCbMM9BUiiI axY6Ovkn6FUAYs6UAXaPFYraiSsDASqX/I33+ysK8c0BoEjhsx+XlQ8qphrkkOvANcfz8fblsMf
 SunRKA0Yb9jp887ZXNlfeTWa/hQfuUWy8Git6JzUH6jNo0zU1G3oGWyzXVL4EJ2vpIlkorX5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-14_01,2025-05-09_01,2025-02-21_01

First patch of the series fixes possible infinite loop.

Remaining three patches fixes address alignment issue observed
after "9382bc44b5f5 arm64: allow kmalloc() caches aligned to the
       smaller cache_line_size()"

Patch-2 and patch-3 applies to stable version 6.6 onwards.
Patch-4 applies to stable version 6.12 onwards

Bharat Bhushan (4):
  crypto: octeontx2: add timeout for load_fvc completion poll
  crypto: octeontx2: Fix address alignment issue on ucode loading
  crypto: octeontx2: Fix address alignment on CN10K A0/A1 and OcteonTX2
  crypto: octeontx2: Fix address alignment on CN10KB and CN10KA-B0

 .../marvell/octeontx2/otx2_cpt_reqmgr.h       | 119 +++++++++++++-----
 .../marvell/octeontx2/otx2_cptpf_ucode.c      |  46 ++++---
 2 files changed, 121 insertions(+), 44 deletions(-)

-- 
2.34.1

