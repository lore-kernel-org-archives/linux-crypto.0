Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D979E23BE;
	Wed, 14 May 2025 05:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747198849; cv=none; b=BbY6vzWH5cFbO7i3Pl3ZeXsyJn4zejskcufMSKMplvJ2j7+VHY6TGZWV5aGcn6LrFCog5ALGrUBTjO9f5zt9nR2DYUpseHEpOt1/VNwUIf4tYLxN8QcYLaxHEUJh95kbhqU5L9OH1SgayAhD9t3Jq5+fA8QT/F1GviWJo9KvBQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747198849; c=relaxed/simple;
	bh=DOk6w4KAtF/2yyHIl4W/3BA+O6PvltzofmtBqfLTc9U=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=dGoIcjPJjiMU57CeKc08GYZKwwj+xLb3AJ993Wh12vaOvJZ19VDx2yf/0T7OUhxVsIipszfqH0qZVxiQAnajngvBoNQwJNHak2iZ9erlh5dBGAM1hXB3C0pnSQA1YNf6P83z/7XbpnPvDyQvyLBjNz/mfRo1wwKbZfQTSIFZopE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=CaacCWlt; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="CaacCWlt"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54DNTYdF018270;
	Tue, 13 May 2025 22:00:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=HBkYcfhQW5E/EeMsTr5py5E
	JzuJHUSEjDNHl11vsfGA=; b=CaacCWltuy4+KMa1snPs/XZPstLVo0djtfUP3Aq
	yz8LcUNwmaLHOZZr4JUHMhAvcdWFelsaY328gcgLyF/k9g9K+WUjTnpg3oN1rvd+
	yN0gEefTnycKM3KPWF6mVQOEIIedh67/rbK/gBPL/L89L4xBKU4XskMV1IEQwNr6
	qL8Hyd6JXtm7JLfMckB5ppbWNxIc73wFnUuF3S4m73QDPEylSsgvpAtVChrTP34a
	ecMJozPbFV57F2LL6BaGoMZEMx+aN8u93YA/x6GN0e0oFOMO07rGdCZkFTIHS6wj
	LGJiiddr4J0ajPTHeKjNujou+7U1jxU30zmYBjk+h00Bbkw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 46mft50gau-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 13 May 2025 22:00:29 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 13 May 2025 22:00:27 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 13 May 2025 22:00:27 -0700
Received: from bharat-OptiPlex-Tower-Plus-7020.. (unknown [10.28.34.254])
	by maili.marvell.com (Postfix) with ESMTP id 558A05B6934;
	Tue, 13 May 2025 22:00:23 -0700 (PDT)
From: Bharat Bhushan <bbhushan2@marvell.com>
To: <bbrezillon@kernel.org>, <arno@natisbad.org>, <schalla@marvell.com>,
        <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <iovanni.cabiddu@intel.com>, <linux@treblig.org>,
        <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
CC: Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH 0/4] crypto: octeontx2: Fix hang and address alignment issues
Date: Wed, 14 May 2025 10:30:16 +0530
Message-ID: <20250514050020.3165262-1-bbhushan2@marvell.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: qkcIw26bq72R2i3kmLdCmCtNvveJ-hlW
X-Authority-Analysis: v=2.4 cv=VITdn8PX c=1 sm=1 tr=0 ts=6824236d cx=c_pps a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17 a=dt9VzEwgFbYA:10 a=voKHntS-kiqXh1f54uIA:9
X-Proofpoint-GUID: qkcIw26bq72R2i3kmLdCmCtNvveJ-hlW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE0MDA0MiBTYWx0ZWRfXxDw5Z3eBNQKk I3WE8c0Was7xS7YBbFMqHLOuP1/x00aUdhW7Lf/f7z2tBU22a9JeOz2/qtjkURbDjTfjkYNdl7L yrvZxuuNnGBAlIQkBv/JVRdYGoV38HVr+p/zpn8QewUaEokoJEohVe91sg0xCovbqU5b6xh3rpm
 qwm5rYoMD7t7LkGE79VFVwNyQcHk06N+y1wZ3CVgOrqCr+jtDoKbusSgTpriAzv1uJeDldnwV4L yG+5WGEzSkxmG+P8yPrzjLPGy8rxD6icOXYwrZ0oLsTBVJj/sq3DeWeEM50pkwT0ZKAR0zCzv95 djcR+CoOZv4RoWMt490l7jxiKGK0pfBygLzrlCNGAXc7aG9ZJV9k7Br5uRb7NxGBcNj5ssqw11p
 KMk8rYEj2tLSC4itClEKnhsCDvTLfhdMDqPXmqxzGPVar8gkuWL9fv4CaJfCoD0B653U83eF
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

