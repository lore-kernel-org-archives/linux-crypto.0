Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FD42AEEA
	for <linux-crypto@vger.kernel.org>; Sat,  3 Aug 2024 06:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722667769; cv=none; b=WLMZWdwOK5Xy2riue1elmF1bt4aK2mEQ4nrkpVFmvWZCAu/GGC3dqeRHfZ5Kt8CDwqpDErP3+S87DdvZGl/rwQ9ZvNOO+BChGFv7fpRcs9550/zb6LAUMISfX2g/04KihupIY3E4I1crgnP6BWsk3dvkX8DDFlZqRYnnixRGlwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722667769; c=relaxed/simple;
	bh=BMD1pZTIyr7VWgKf9KkB8BNt/ZVXQ7HXuKiqvLQghaE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=GLAk+rrsMSB4GS3Bx52aDziKGxBiCsYER2h43bz6+YcKwg+hEFXK91prhoTiV9q57tkKRVeJq0ctTV/H/39oqkv1yTv/srPFcmTQcwZiwlLwfghagrcZFL2J2OgDMm/kVWuYDu1YP8QnjTOe0w8fkxw3gu6bPBSLW4pBpSjkiA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WbYGB1YlVzcd3p;
	Sat,  3 Aug 2024 14:49:22 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id D70EA1800A4;
	Sat,  3 Aug 2024 14:49:24 +0800 (CST)
Received: from cgs.huawei.com (10.244.148.83) by
 kwepemd200011.china.huawei.com (7.221.188.251) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 3 Aug 2024 14:49:24 +0800
From: Gaosheng Cui <cuigaosheng1@huawei.com>
To: <olivia@selenic.com>, <herbert@gondor.apana.org.au>,
	<florian.fainelli@broadcom.com>, <bcm-kernel-feedback-list@broadcom.com>,
	<rjui@broadcom.com>, <sbranden@broadcom.com>, <hadar.gat@arm.com>,
	<cuigaosheng1@huawei.com>, <alex@shruggie.ro>, <aboutphysycs@gmail.com>,
	<wahrenst@gmx.net>, <robh@kernel.org>
CC: <linux-crypto@vger.kernel.org>, <linux-rpi-kernel@lists.infradead.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -next 0/2] Add missing clk_disable_unprepare
Date: Sat, 3 Aug 2024 14:49:21 +0800
Message-ID: <20240803064923.337696-1-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemd200011.china.huawei.com (7.221.188.251)

Add missing clk_disable_unprepare, thanks!

Gaosheng Cui (2):
  hwrng: bcm2835 - Add missing clk_disable_unprepare in bcm2835_rng_init
  hwrng: cctrng - Add missing clk_disable_unprepare in cctrng_resume

 drivers/char/hw_random/bcm2835-rng.c | 4 +++-
 drivers/char/hw_random/cctrng.c      | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

-- 
2.25.1

