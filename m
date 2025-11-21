Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2D31D90DF;
	Fri, 21 Nov 2025 02:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763693159; cv=none; b=SuF84VvFkZWSXCthBqH+zxZtZjB7ALr+ek5Rqx9OynkKpFy9N7TzaL5UttXzMf9R4Fk7PFlJdGsfE3IbQORBplLe00b6SDHDYhUEggNrIeUPm3e1apGnQa+6dNTvLPtGX+8ENS6m4Ef7YLglLaG6oamy71RSGd6OraXztnQ+9Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763693159; c=relaxed/simple;
	bh=BaW5FsM9bIPc7TWwW2Mlw22TDdrUl4axe65nRTXqUdo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=U0pgU77nvNKoV+B31O2TbsJcQBeUrz9/DsJi7L3Ac4m6YQnjcD3et2br7jvjjzibm3SmUmmeddkL5Mei5fgfqw6yGOg0Cj1XxhT/pQljCHzmjdBWSJgBoCJZHXifKLf+QO/x5e0kBv9eSGwKwNRchzZIPHrSvFFzRXk7ruteFpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dQ1o6j9Y; arc=none smtp.client-ip=220.197.31.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dQ1o6j9Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=Ip
	cxXhs+hOjQkRjFUScuKAu+nntmFOjdDcE4Z7tDCdw=; b=dQ1o6j9Y8SztDaodYZ
	YuqSsj6rREW2erWTHKK0Iz8U4HE44zR2o8CLLPXYUGcFvqTv8sx4ZV1jP4TaZQbt
	Q+fHANtz/h+fGh27jhKZuFibrcmp8xpwmwf6DwMO96voe8IceFgaf9gDG7u7QxnK
	1xjKrfw4yhdNSOjVoOPzbAWlI=
Received: from localhost.localdomain (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PygvCgD338cq0h9pGDSBEg--.10441S2;
	Fri, 21 Nov 2025 10:45:00 +0800 (CST)
From: Gongwei Li <13875017792@163.com>
To: horia.geanta@nxp.com,
	pankaj.gupta@nxp.com,
	gaurav.jain@nxp.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Gongwei Li <ligongwei@kylinos.cn>
Subject: [PATCH 1/1] crypto: caam - use kmalloc_array() instead of kmalloc()
Date: Fri, 21 Nov 2025 10:44:56 +0800
Message-Id: <20251121024456.47381-1-13875017792@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PygvCgD338cq0h9pGDSBEg--.10441S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr48ZF13tw4fArW8Gw43GFg_yoWkXrgE93
	yUWr1xuryjy3Z5ZFnru3yDXrySva1kWF4kW3Zaga43Aa4UJrWfXFyxZF1Dur9xZrZ7ursI
	van7tF1xtF12kjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUn-dbUUUUUU==
X-CM-SenderInfo: rprtmlyvqrllizs6il2tof0z/1tbiXA0NumkfyffYFgAAsg

From: Gongwei Li <ligongwei@kylinos.cn>

Replace kmalloc() with kmalloc_array() to prevent potential
overflow, as recommended in Documentation/process/deprecated.rst.

Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>
---
 drivers/crypto/caam/ctrl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 320be5d77737..81583251b1f6 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -208,7 +208,7 @@ static int deinstantiate_rng(struct device *ctrldev, int state_handle_mask)
 	u32 *desc, status;
 	int sh_idx, ret = 0;
 
-	desc = kmalloc(CAAM_CMD_SZ * 3, GFP_KERNEL);
+	desc = kmalloc_array(3, CAAM_CMD_SZ, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
 
@@ -285,7 +285,7 @@ static int instantiate_rng(struct device *ctrldev, int state_handle_mask,
 	int ret = 0, sh_idx;
 
 	ctrl = (struct caam_ctrl __iomem *)ctrlpriv->ctrl;
-	desc = kmalloc(CAAM_CMD_SZ * 7, GFP_KERNEL);
+	desc = kmalloc_array(7, CAAM_CMD_SZ, GFP_KERNEL);
 	if (!desc)
 		return -ENOMEM;
 
-- 
2.25.1

