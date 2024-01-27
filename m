Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018BF25603;
	Sat, 27 Jan 2024 13:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706361378; cv=none; b=bTzEvK2/EAayWvsp+Mpjwnu0AANO+vJGXLSJud5MCqTHpCSmyghh/3akyLUytk+YcjsogI18ryIU4L+iMFlUYVocK3v4OrSawVizMfhmjppWh2CUE51QnPY3uYH9w679brD9CNgIHs9GdNg7/S2wLJoBi5hAFeBznqFxvmjATu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706361378; c=relaxed/simple;
	bh=A83iSRlSoaDN53FDesl5lhj/DqkiysP0gEydd/giHWY=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pG4L1aDjGNvs9gt8BMY2glbr/8QGQU/gSxOmHmtEKBdD3ipkkKHpZnxTLtkLePTz9qg1RVH/CQH41volTvseBKipkYY71KIIUNmXcwjeNVh8U9fGeNcL0uEmJ4RWHIrOyxzrcihkwSFaLWmONZunKMn6HCV5bFhGNHGaLtIpS8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4TMZmH4bJkzXgft;
	Sat, 27 Jan 2024 21:14:55 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 9548218001C;
	Sat, 27 Jan 2024 21:16:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Sat, 27 Jan 2024 21:16:12 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 0/3] crypto: hisilicon/qm - add stop function and obtain queue status 
Date: Sat, 27 Jan 2024 21:15:27 +0800
Message-ID: <20240127131530.64617-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)

Patch #1 supports stopping function by sending mailbox to device,
device directly flush out function data.
Patch #2 supports users to obtain the queue stopping result by
querying the debug file.
Patch #3 changes function type.

Weili Qian (3):
  crypto: hisilicon/qm - add stop function by hardware
  crypto: hisilicon/qm - obtain stop queue status
  crypto: hisilicon/qm - change function type to void

 Documentation/ABI/testing/debugfs-hisi-hpre |  15 ++
 Documentation/ABI/testing/debugfs-hisi-sec  |  15 ++
 Documentation/ABI/testing/debugfs-hisi-zip  |  15 ++
 drivers/crypto/hisilicon/debugfs.c          |   5 +
 drivers/crypto/hisilicon/qm.c               | 171 +++++++++++++-------
 include/linux/hisi_acc_qm.h                 |  18 ++-
 6 files changed, 179 insertions(+), 60 deletions(-)

-- 
2.33.0

