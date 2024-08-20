Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABD61B813;
	Tue, 20 Aug 2024 08:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724142515; cv=none; b=BgOTFjHi0zLXjDsWNUlIx0sQt2ixkI2xhVrAr8hyVvPS6sS3A1NZaWNg5bOX2GeHerR39LasAhN6NJbrcTYYvvrppufBBPdmhQ+y9TbYeo4CsDH1I0GhTd6uWbfNM5jZtWsBYBNlEO20gfwtraDF9rH9o5+bV/EtrwD73QQ1+Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724142515; c=relaxed/simple;
	bh=m9i0a81CyXVEM0PbCQZAofv2G5NcI9KwgCSW8qDh5Kk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Pc1FTfW0mN3jvVBBByELztPNFdX6vSyyyYhlahnP6aLtCZyOQhuxwX/xWXVHZuTQkiZLsShfkBVXR5TY+6pmFO2tJj99BABRoZzs6HQYRhz7zdHAQw1pIEOpNj9oS/xo3sjhw+vO8TO9cH7Rw3I1prrTJvFsRTwbD3VCwZCD8Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Wp2Xw25s8z1S8LR;
	Tue, 20 Aug 2024 16:23:28 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id 3BB901A016C;
	Tue, 20 Aug 2024 16:28:28 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 20 Aug
 2024 16:28:27 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<clabbe@baylibre.com>, <linus.walleij@linaro.org>, <atenart@kernel.org>,
	<arno@natisbad.org>, <bbrezillon@kernel.org>, <thomas.lendacky@amd.com>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-amlogic@lists.infradead.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH -next 0/6] Cleanup unused function declarations
Date: Tue, 20 Aug 2024 16:25:19 +0800
Message-ID: <20240820082525.259337-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Cleanup unused declarations for crypto driver subsystem.

Yue Haibing (6):
  crypto: safexcel - Remove unused declaration
    safexcel_ring_first_rptr()
  crypto: sl3516 - Remove unused declaration sl3516_ce_enqueue()
  crypto: octeontx - Remove unused declaration otx_cpt_callback()
  crypto: ccp - Remove unused declaration sp_get_master()
  crypto: amlogic - Remove unused declaration meson_enqueue()
  crypto: crypto4xx - Remove unused declaration crypto4xx_free_ctx()

 drivers/crypto/amcc/crypto4xx_core.h             | 1 -
 drivers/crypto/amlogic/amlogic-gxl.h             | 2 --
 drivers/crypto/ccp/sp-dev.h                      | 1 -
 drivers/crypto/gemini/sl3516-ce.h                | 2 --
 drivers/crypto/inside-secure/safexcel.h          | 1 -
 drivers/crypto/marvell/octeontx/otx_cptvf_algs.h | 1 -
 6 files changed, 8 deletions(-)

-- 
2.34.1

