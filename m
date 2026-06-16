Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840551DE8AE;
	Tue, 16 Jun 2026 00:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781570796; cv=none; b=sipr5bn0P91oLnwEm2FdkU30ufvTTlzn8GLznH4NJbILvH7dhFZClrIL3S3CwT5JCgeE8VgtjZcvOWlOhOYv11q/BXbHaL6KgCg9IiukqWn+ZqRsr5YK/fdht54lypD3+W/x8LUa448ceTn0siGcbQI5vJE0wZJbD7ID3p/K9s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781570796; c=relaxed/simple;
	bh=8unrbgzHg236S1IQf1o9eipiavPG68/9o6yDq4HDiQg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=s/dnSb+1e6wzpRYSez9SbwgVGtbfvyTrYqKZjO2zOqNRDk/gi9yr6XDtJLbxaYidrPIxGtcN6KdWM46hTUnyJoum4YEDDP6OXJiARMeMuH34o+KG7FkSu+VcswExBvn+jveQC99SOYEr9b5A5ilyjYWxZ5vNBpoSaRCOR243VVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-03 (Coremail) with SMTP id rQCowABHZt3lnDBqFXneFA--.7172S2;
	Tue, 16 Jun 2026 08:46:29 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] crypto: sa2ul: stop probe if context pool creation fails
Date: Tue, 16 Jun 2026 08:46:27 +0800
Message-ID: <20260616004627.947-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABHZt3lnDBqFXneFA--.7172S2
X-Coremail-Antispam: 1UD129KBjvJXoWruw4fGFWktryDGw4kAF4ktFb_yoW8JrWrpF
	WkXay2krZ5X3yfG3yxt3W5uFyrGa9agrySg3y7GwnrZwnxGrn5AF1SyFyjva1UJF4UtF17
	XaykKFyUZF43AFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjiID7
	UUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

sa_ul_probe() calls sa_init_mem() to create the DMA pool used for
security context buffers, but ignores its return value. If pool creation
fails, probe still continues with DMA setup, algorithm registration and
child population even though later request setup depends on that pool.

Stop probing when sa_init_mem() fails, and route that failure to the PM
cleanup path without attempting to destroy an uncreated DMA pool.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/crypto/sa2ul.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 965a03d5b27a..d865fd4a098c 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2395,7 +2395,10 @@ static int sa_ul_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	sa_init_mem(dev_data);
+	ret = sa_init_mem(dev_data);
+	if (ret)
+		goto disable_pm;
+
 	ret = sa_dma_init(dev_data);
 	if (ret)
 		goto destroy_dma_pool;
@@ -2430,6 +2433,7 @@ static int sa_ul_probe(struct platform_device *pdev)
 destroy_dma_pool:
 	dma_pool_destroy(dev_data->sc_pool);
 
+disable_pm:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
 
-- 
2.50.1 (Apple Git-155)

