Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843452F7444;
	Mon, 20 Oct 2025 10:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760955105; cv=none; b=MhRSInzmSZHYXtdWxvRhpNlIeagh3tn32MHoLfyEPPN0cxT+GdWsNRLLqxov1lr5KlEb1KVDfHNlVFc7e2fiZMuo5I7rNQdyfaq+HPvkwqFVoOPuO7X/zmuCQ0rB7cg8fSRns+m9LJrT93sRiV5r8eMOyYwuyrYzPrEmFKtk7p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760955105; c=relaxed/simple;
	bh=GTy5Z9KYNiPcjptdrJUxyn4j9Jc8zlzn0Dl9Gd9a+kg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TOqDkVvF9cxDICoJmiwUNZcH+PvZwp1ssrto0HkgPaq0a5Ptkvq1SOkkcm4Bs2ZLUzW7+7P+oeiGETXzuFGEhZyT/yCeUiJEUaa9FiurQHlykB6iPvNT+82gXJ7D4rfknwMZrStOYJk1QroA8NbXpKumvhdswlhOceiQWJQJgak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S (unknown [124.16.141.245])
	by APP-01 (Coremail) with SMTP id qwCowADnPaDLCvZoHdfdEQ--.2307S2;
	Mon, 20 Oct 2025 18:11:23 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: neal_liu@aspeedtech.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: joel@jms.id.au,
	andrew@codeconstruct.com.au,
	linux-aspeed@lists.ozlabs.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] crypto: aspeed - fix double free caused by devm
Date: Mon, 20 Oct 2025 18:11:09 +0800
Message-ID: <20251020101109.1030-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADnPaDLCvZoHdfdEQ--.2307S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Kr18AFWfAr4DKrWUZr48Xrb_yoW8Gry5pa
	yrJ3yFkFW7JF45GFWUJayvqF15J3y5t3yagayxG3W7X3y3JrnYqFZaka1jvFW5AFWkuF1I
	yF4DJr1UuFn8uFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9G14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r106r15McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwVW8twCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQVyDUUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCQ4BA2j12CK++wAAsn

The clock obtained via devm_clk_get_enabled() is automatically managed
by devres and will be disabled and freed on driver detach. Manually
calling clk_disable_unprepare() in error path and remove function
causes double free.

Remove the manual clock cleanup in both aspeed_acry_probe()'s error
path and aspeed_acry_remove().

Fixes: 2f1cf4e50c95 ("crypto: aspeed - Add ACRY RSA driver")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/crypto/aspeed/aspeed-acry.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
index 8d1c79aaca07..5993bcba9716 100644
--- a/drivers/crypto/aspeed/aspeed-acry.c
+++ b/drivers/crypto/aspeed/aspeed-acry.c
@@ -787,7 +787,6 @@ static int aspeed_acry_probe(struct platform_device *pdev)
 err_engine_rsa_start:
 	crypto_engine_exit(acry_dev->crypt_engine_rsa);
 clk_exit:
-	clk_disable_unprepare(acry_dev->clk);
 
 	return rc;
 }
@@ -799,7 +798,6 @@ static void aspeed_acry_remove(struct platform_device *pdev)
 	aspeed_acry_unregister(acry_dev);
 	crypto_engine_exit(acry_dev->crypt_engine_rsa);
 	tasklet_kill(&acry_dev->done_task);
-	clk_disable_unprepare(acry_dev->clk);
 }
 
 MODULE_DEVICE_TABLE(of, aspeed_acry_of_matches);
-- 
2.25.1

