Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0560025333F;
	Fri, 18 Sep 2026 12:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734456; cv=none; b=EUat067O3S8Kp7Nb3mEAAxyuRs4PfgF5ovI5NA/H/n1TH9cV2O5AA+o+7DPH5DfPKtmzdcjR2DAJwBTlBBUK+qSKebCPGIYPopZwguWVvs7xrb1HKG5FfERc3a5pLP1Qee50UqYCd493bXgXvkbxS+0i74e9hCbjgHCv3P7Gfqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734456; c=relaxed/simple;
	bh=S7sjQB6Ut1Cs61lFB+wTgBy6KI8UarLRB4MUdE6TqaA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=eWeHO2mtW+79JLbRvbJaSNe3tgd62ucGQVvROH5XjCVd0tUB22OlaxGjGIq6/jnsZ2luJSW0wM2GKEp3qUMhxLl4cimB7xfeYdpfK2CiRfCyU0LaOI2g58IRBt2/kh7FR6jJ2GYEtD8/26Pg1ORK+wgtjGYBVcQgyly2N7wbHZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=HJc3szw9; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="HJc3szw9"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uVuWH1jFvfxMFOAUKKhr3vY9ZUmO0Pt9iqO8mHjT/k8=;
	b=HJc3szw9bhgbCTU8c50z7QVUo0ILceHkEBka+bp7h6T8//QoYWEQokhh+8nGuGcA8dp4DIPJP
	TP0v1SnUYuJrx2epzlEMpaqoTkIm6jQiIG4UeaYrnQKhD3wbiT28INEDbj+PcmQgJyCqfXjLF3G
	NUoUrw8EnoL3/IFRfHSSxJc=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hmWnN0jZmzKm8V;
	Fri, 18 Sep 2026 20:16:24 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id BE3B140586;
	Fri, 18 Sep 2026 20:27:27 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 18 Sep 2026 20:27:27 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 0/7] crypto: hisilicon/hpre - misc fixes and cleanups
Date: Fri, 18 Sep 2026 20:27:19 +0800
Message-ID: <20260918122726.3014899-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemf200011.china.huawei.com (7.202.181.237)

Patches 1-5 fix bugs (OOB read, dead code, wrong errno, DMA mapping
and GFP flags) in the ECDH/RSA/DH paths; patches 6-7 are cleanups.

Weili Qian (7):
  crypto: hisilicon/hpre - fix pointer dereference before length check
  crypto: hisilicon/hpre - remove dma_free_coherent on NULL req->dst in
    ECDH
  crypto: hisilicon/hpre - return -EOVERFLOW for small ECDH output
    buffer
  crypto: hisilicon/hpre - fix ECDH destination DMA mapping
  crypto: hisilicon/hpre - fix GFP flags for dma_alloc_coherent
  crypto: hisilicon/hpre - extract clusters num into inline function
  crypto: hisilicon/hpre - remove unused macros and struct fields

 drivers/crypto/hisilicon/hpre/hpre.h        |  1 -
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 28 ++++++++---------
 drivers/crypto/hisilicon/hpre/hpre_main.c   | 47 +++++++++--------------------
 3 files changed, 28 insertions(+), 48 deletions(-)

-- 
2.43.0
