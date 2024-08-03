Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9ECF23CB
	for <linux-crypto@vger.kernel.org>; Sat,  3 Aug 2024 06:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722667776; cv=none; b=c1BxvQivrQWWjV3KI1ofd8qO5un903YmhtHqb4JCQ1ZdWcYmgpyXLB20ojSdo9ydRK6CqhmlGuYLjcwxlzPpfwoIKRzciTkmPk3aUngFjOCm4dyLKzU1lTaFacK4o/C5OKbAeqw5jmBWLQhjwo//thv4Dg/GlrC6kmcsnGAWeFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722667776; c=relaxed/simple;
	bh=yg2UdZr0d/Hd7X1vQ9T5Qt6LK+Ok4Gb9x2zNUHQRhXo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tHBK62lCVDKxqt5bWyHoLXRycztK2EBWtw/p1TZdCe2I7MO5KjA+V0pseFnYEOEsD414s/v7PieGBSg7DEA8WOZxUoNnxYj6cz+97J6qFM2o/8x1tDpRDcLR98HvZSQlzbinMT7ZOYutq/e/pjj4z43wO6NqdTrLjzutm/bc9d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4WbYFy2hD6z1L9dZ;
	Sat,  3 Aug 2024 14:49:10 +0800 (CST)
Received: from kwepemd200011.china.huawei.com (unknown [7.221.188.251])
	by mail.maildlp.com (Postfix) with ESMTPS id 651521400D1;
	Sat,  3 Aug 2024 14:49:25 +0800 (CST)
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
Subject: [PATCH -next 1/2] hwrng: bcm2835 - Add missing clk_disable_unprepare in bcm2835_rng_init
Date: Sat, 3 Aug 2024 14:49:22 +0800
Message-ID: <20240803064923.337696-2-cuigaosheng1@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240803064923.337696-1-cuigaosheng1@huawei.com>
References: <20240803064923.337696-1-cuigaosheng1@huawei.com>
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

Add the missing clk_disable_unprepare() before return in
bcm2835_rng_init().

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index b03e80300627..aa2b135e3ee2 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -94,8 +94,10 @@ static int bcm2835_rng_init(struct hwrng *rng)
 		return ret;
 
 	ret = reset_control_reset(priv->reset);
-	if (ret)
+	if (ret) {
+		clk_disable_unprepare(priv->clk);
 		return ret;
+	}
 
 	if (priv->mask_interrupts) {
 		/* mask the interrupt */
-- 
2.25.1

