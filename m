Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3856A6FBE;
	Sat,  1 Jun 2024 02:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717209625; cv=none; b=OlxVgv5RdqIGhMBNWGQ/OFbgOB2HwBfhmd8RPKbrPPDIRSqdhL4ah1RqzLTaFVVc5QZaVFwUZgRoUL/Nzg/0rLd+Drk0HvMMOGsbEaZDVmMxu4CNZ6Ko9FAXfQJ0NGMTsf/5QXSu0oVXTy94OK5HAiDkPpbFFGynGio3YAhZUmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717209625; c=relaxed/simple;
	bh=Qfgl0Biv0aP0AfSr2hL0ISOr/2WJn7Y3CpP9bolN+HY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mntRDfLuK5N1FkWN/BnZqfPFd0jBZ9ltejP+bX6/9pzYwSPlL/6yGC9b99Kn7cpC/eYJVhNtwJHKHY56dq5h9SW1G6Fl1zUGM8//PeUupm7iKtzA3PLi8rV+amaSH44E0gijgm7uxjk966xxFJBieqiBJInaGOk1acNloPNll4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4VrkfC4YcjzPpHP;
	Sat,  1 Jun 2024 10:37:07 +0800 (CST)
Received: from kwepemi500025.china.huawei.com (unknown [7.221.188.170])
	by mail.maildlp.com (Postfix) with ESMTPS id 49FDD18006C;
	Sat,  1 Jun 2024 10:40:20 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemi500025.china.huawei.com (7.221.188.170) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 1 Jun 2024 10:40:19 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<shenyang39@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>
Subject: [PATCH V2 0/2] crypto: hisilicon - adjust vf configuration sequence and optimize zip reg offset
Date: Sat, 1 Jun 2024 10:40:14 +0800
Message-ID: <20240601024016.1598391-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20240601024016.1598391-1-huangchenghai2@huawei.com>
References: <20240601024016.1598391-1-huangchenghai2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500025.china.huawei.com (7.221.188.170)

The VF enabling and disabling issues are fixed, and the ZIP address
offset calculation is optimized.

Chenghai Huang (2):
  crypto: hisilicon/qm - adjust the internal processing sequence of the
    vf enable and disable
  crypto: hisilicon/zip - optimize the address offset of the reg query
    function

 drivers/crypto/hisilicon/qm.c           | 11 ++----
 drivers/crypto/hisilicon/zip/zip_main.c | 48 +++++++++++--------------
 2 files changed, 23 insertions(+), 36 deletions(-)

-- 
2.33.0

