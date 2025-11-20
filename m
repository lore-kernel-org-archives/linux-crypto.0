Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C12346773;
	Thu, 20 Nov 2025 13:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763647113; cv=none; b=NGDf//g88yv9j3mqAlQn3/HzSasTG8M9HbPsu3zVecxysdHfvjj8cE+rIqvS9jhro805TzcOT97CusPwIcMF3GaI9prg060A1S64YkmbN7ghsuISJU0kZXXYe1Hk+jG15H4SO76vay+jDNdlpe7pZ5CgWzMZkPaaNPki8Of31HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763647113; c=relaxed/simple;
	bh=G2sYMyoH7MH6fh7vAHzTPFiRHhF/6/TTE2OOQlnnR6I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Jd34mAIrI9Q0dQ5/Xku+ZpFJKnRKjvNJpuvxaiPEPS/cqNUOezGm75CepP+8NgPtcZhBO1ZMJOb25uGUa6xm7Ku/NqlW5C8yRNnrC/3B2CU4R0XAZL31Nd1fCkK3WnyPEqxf1Y9nFC2G7SkfKcADXOAJ47PiXoAkmwaza0UvDA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=G+z25qGn; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="G+z25qGn"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5fyq1VcJkx8jmFTls+rTlptt/utnaN8kv5dibxJWAVw=;
	b=G+z25qGnVUb83Jd2wrg6JyF9PX4BTlLdqz36nYT7ELOSmnv+IbTdqx2vNneoAA+nicdp8FSnq
	8S56tPsaqUG2kSROW3haIMZfBoSKKjuv9yW7vM8Q0yXD3vSZ8QSj0Wdfd0XVxUqItRyfH0y5xta
	Hq2tk+pjPj7BDeb4Zx8B3Q4=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dC0JP4NkTz1prnm;
	Thu, 20 Nov 2025 21:56:37 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id E1B6B180BD3;
	Thu, 20 Nov 2025 21:58:22 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Nov 2025 21:58:13 +0800
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Nov 2025 21:58:13 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<fanghao11@huawei.com>, <liulongfang@huawei.com>, <qianweili@huawei.com>,
	<linwenkai6@hisilicon.com>, <wangzhou1@hisilicon.com>
Subject: [PATCH 0/2] crypto: hisilicon/trng - support multiple tfms sharing the device
Date: Thu, 20 Nov 2025 21:58:10 +0800
Message-ID: <20251120135812.1814923-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200001.china.huawei.com (7.202.195.16)

Patch 1: Uses DEFINE_MUTEX() and LIST_HEAD() to automatically
initialize locks and list heads instead of runtime initialization.
Patch 2: Supports multiple tfms sharing the device to avoid
tfm creation failure.

Weili Qian (2):
  crypto: hisilicon/trng - use DEFINE_MUTEX() and LIST_HEAD()
  crypto: hisilicon/trng - support tfms sharing the device

 drivers/crypto/hisilicon/trng/trng.c | 200 ++++++++++++++++-----------
 1 file changed, 116 insertions(+), 84 deletions(-)

-- 
2.33.0

