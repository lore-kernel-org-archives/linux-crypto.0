Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DB0136E3F;
	Fri, 30 Aug 2024 10:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725013044; cv=none; b=omv1isnfWNfR/rFlEkPRbHay+0kQCSm35E0WFwAlwIEi3lSIw3hVHY41QtbJAmDTDKP44c3ekutKz449i/j74MIPKF8623+lnXONxIGBuWO4zpgAvIorqySVPyt+UudykhAa5qp/75a71Q7GVTYAyyE3Zck5GwTLCkRpB8dnFwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725013044; c=relaxed/simple;
	bh=1lSIaIE0EU6GGaY7bQnD3AjI5OiT26rCfEFmYdyZOVA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kYBPPgMdUiia/pfDCan97UFTMxGQlpe7pc/8KpTN2fWDEVqeLQ3y/XDwT10PHqQJWilFqoi0j0pt6YDWa6RZ9xw2+Kk7fLiFbSTr1bI5bhuL/UQSOmMuo546yNCmLE8EXir19yXVhp+h+FBD4QWKPheG/Aeq9O0+PdIcls/bCMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WwDbQ3dZRz1j7j1;
	Fri, 30 Aug 2024 18:17:06 +0800 (CST)
Received: from kwepemd200024.china.huawei.com (unknown [7.221.188.85])
	by mail.maildlp.com (Postfix) with ESMTPS id 317171A0188;
	Fri, 30 Aug 2024 18:17:20 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemd200024.china.huawei.com (7.221.188.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 30 Aug 2024 18:17:19 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <shenyang39@huawei.com>,
	<songzhiqi1@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<taoqi10@huawei.com>, <wangzhou1@hisilicon.com>, <huangchenghai2@huawei.com>
Subject: [PATCH 0/3] crypto: hisilicon - fix resource contention and abnormal branch processing issues
Date: Fri, 30 Aug 2024 18:17:15 +0800
Message-ID: <20240830101718.3193159-1-huangchenghai2@huawei.com>
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
 kwepemd200024.china.huawei.com (7.221.188.85)

1. Fix the queue resource competition issue in hpre and zip.
2. Fix the abnormal branch processing problem in sgl.
3. Adjust the header file and printing format problems in trng.

Chenghai Huang (2):
  crypto: hisilicon - add a lock for the qp send operation
  crypto: hisilicon/trng - modifying the order of header files

Yang Shen (1):
  crypto: hisilicon - fix missed error branch

 drivers/crypto/hisilicon/hpre/hpre_crypto.c |  2 ++
 drivers/crypto/hisilicon/sgl.c              | 14 ++++++++++----
 drivers/crypto/hisilicon/trng/trng.c        |  4 ++--
 drivers/crypto/hisilicon/zip/zip_crypto.c   |  3 +++
 4 files changed, 17 insertions(+), 6 deletions(-)

-- 
2.33.0

