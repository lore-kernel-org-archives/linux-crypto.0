Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B5C4322FA;
	Thu, 24 Sep 2026 11:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790249901; cv=none; b=R8TIulJhaRb5q0W7wcUQo5yREssFJAzYuvfJYDJJMiBNiQ5KiQj+U+ayNVe3LH4HqwiLfpHuxi9MBgKXwsSzeaYMZs6HMc96KZAOjSLdE24Hkd5vfTyDuFCfZf401QYBV9TGhjbv86WGkbf9XfpOnYmT5rh+o4m3iffVWXSqfUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790249901; c=relaxed/simple;
	bh=Orb1+MG9GCZoRR6gKZh3dJBS2D6Y0j7z/SARREZnjmo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fnWSdGJ34S5F3WNT/NFgDVRdn9mJEWsT1uXIoJ1obO8AKDkALdDr8wtezWgh+ixYBorzckJgR4D25scm6lAjTa49A+psFMFy1utXeSDK2XJANuSAstWgkn9DmqUc9t9vSRPrDPhG5jhf76Ie301k0pFAeA/qz29racstLwEAK0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=FO+BAvrL; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="FO+BAvrL"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2grtqkvMKrl7Od30noBKUeUHkqLVD2bKDhtgRv70tGA=;
	b=FO+BAvrLil+Kpzc8VPFBze61iy3ceEvYacJEf1AleyAoabOdKkrsX5yZnG4zyo4Gf6BFhkjmG
	MWc8ULSwrqhpzRz+3klOpfJzA24UGxLM23FVFyXSMrdm5A3JPhEb7sko9OUPZdVeGIA/0EuMVc2
	KSHQGAkLc8c+FDS8FAQZwWs=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hrBPp4s8xz1cyPY;
	Thu, 24 Sep 2026 19:27:10 +0800 (CST)
Received: from kwepemf200011.china.huawei.com (unknown [7.202.181.237])
	by mail.maildlp.com (Postfix) with ESMTPS id AFCE740572;
	Thu, 24 Sep 2026 19:38:13 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 kwepemf200011.china.huawei.com (7.202.181.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 19:38:13 +0800
From: Weili Qian <qianweili@huawei.com>
To: <herbert@gondor.apana.org.au>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH 0/4] crypto: hisilicon/qm - fix bugs and harden against abnormal hardware
Date: Thu, 24 Sep 2026 19:38:08 +0800
Message-ID: <20260924113812.1110302-1-qianweili@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf200011.china.huawei.com (7.202.181.237)

This series fixes bugs in the hisilicon/qm driver and adds
checks for abnormal hardware.

Weili Qian (4):
  crypto: hisilicon/qm - clear runtime PM flag for non-power-manageable
    device
  crypto: hisilicon/qm - return error for abnormal device capability
    version
  crypto: hisilicon/qm - check queue depth read from hardware
  crypto: hisilicon/qm - fix uacce leak when SVA is not supported

 drivers/crypto/hisilicon/qm.c | 64 +++++++++++++++++++++++++++++------
 1 file changed, 53 insertions(+), 11 deletions(-)

-- 
2.43.0

