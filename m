Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77F4924BBF0
	for <linux-crypto@vger.kernel.org>; Mon, 13 Jul 2026 03:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783912537; cv=none; b=WrZmHi3FeFWK9afALWSTq0pu24Mv51GTx6xcwUvXS7MdykZtRSwywnYwWnh5CppfyifVriIxO5kfzFeP2RamCVIa5d3wjbY/y8McyPDhZkOuxUpKjoem8o68AGx1L/uj65scGdh2zxb/zR8C+6QMDX0xFJx8ih+XFnalp37vujc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783912537; c=relaxed/simple;
	bh=t8oA++ofkLjSUHQVdPztiR1tlyz354IWY+FPVWWxlwc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FrodPWgE502DzGMQcZ7uE4yygHfB17BvvniGu6e5lpJh/KIPaHFSOESlIqYb4mJOlBvWW5AtHn5EttBr40RivYqfoJzBdqosi4ROx/Y1wVKq3bnexOpLT+P67Kv55ghVdFrw4Fvv8rlOwwliwsj70X2igWKE+y97Fwz5VRyS59k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VF2eS70x; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VF2eS70x"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c85b73ffb52so1308164a12.3
        for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 20:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783912534; x=1784517334; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lGBnUHO0f4jIfHxe2uWJUDkRQrU6rmLu0sMXefsRiuQ=;
        b=VF2eS70xv/0DxZX+d/BqC1aD6jvQ62DSSZQHP8/6DgEO7b5/CByue4+9W9WDt7aPZC
         nhWYywZuU53h6z1rQst0d5m5y4mpR0nFjGOZaD/s3fUueXjo0KD7nNEpXHhqfuOY3X18
         jOuf7IFPk0hhWF3UF4hExqvCULcNcwfCPmWBfsP15XY77O3QspguCz+mr5698VTHc8Ft
         I42uy8bsmjYjelw+nJsaahOBf0sqMSk5i0lTksHKScD6jJMdFKryEuQMAoNTxr5J//9F
         Tv3CCOeL8lX6AqmCFkhqixfTa/QJrLgKiinXXNM1YPuh/6iK1dnO/uQW09LF+em82l4U
         UYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783912534; x=1784517334;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lGBnUHO0f4jIfHxe2uWJUDkRQrU6rmLu0sMXefsRiuQ=;
        b=mEP9DT43dod72Q6x0XPGb7VZMXYo8LHy3tcsQfCCzmBCM8mFyrgdbuDeIGTgHWr0iO
         cjpUMha2ILjyV+RnkcY52ypcLLKoFixVZOW2J6dBe/66sRKBZqG9bnQUuFPBiWWfZ/oA
         n7hQLoa/8Pdh9RQy2EhoLdYc2QcohCnI6fgvca4HKoP+kAtodpR+mAeyYnOkbCZYqibT
         1Q2sY4BbG5BzP613SdoGwuSEoAdVPjTpJH3oHMJcjgwI5XjFLBRe1+peFcHIZ+Hkyn8S
         HjH4qEcrI/RxvAOPzZqHFwIwxVgZEE3Ca+LrSHImuw3jwLYduQBKL+HybYJ+Vdf2mhCB
         TPwg==
X-Gm-Message-State: AOJu0Yyf8yi810gL7NPaD/VtJSmr5fNlehRRZPqE2yiK9fWnzG5Kvmv0
	9qHYtbwwqiHMipH7bTpYpGNgEtCFvYaZa3jrGkjuIfzv2LREdXp74UabXVLW0ec+
X-Gm-Gg: AfdE7clF5rAdwa7uE0pnNLIS0rIXMCW1qwxWK/cNc0CF9vBu78B7HuwONs3raeqPOVF
	qMe5oiTlY1aIE5dpBbZQVbT266I8gCtnWtKzRdfioVbJEXsji/PlJz840mb4KIe7y4edd7RmJF/
	KJnt7JLprJ9rYyiWapWI5DgSCKa4NgPmCQ2LWijVqFzc23Ixy0bi2IYLmSTP2xqFwwsKPCLRMny
	UfF4VpTXTh1tAX4R3RdO/+pG5IuEbey/neVhy8SV2G3nsOJACi+h4XlBC35g6x1/GUa/s/ZwrrD
	2oginx6AN9PtNDAJ4hUfFlxOjKJTCF63cu0HSgVqSCvPqsUdxna4slDiGFZG97PCg5LqX+1QlKj
	SiiMRk5FS4OIBrvfR/RhamLlboVoV8mM2kpubeXvkFJ4RWzH3hhA0B1QUBHw/SI25y5Ie9uuFuL
	iTfwxs0FijHGYPwGwfp4gO013/wvg9BlU7bP2vw5uiVciTCoqf5CHIwfAd6nsagY7lcxELOMCCS
	ZjhCvrMawGX4yIOBlk5C2h+uGDqf4btx0yh15NHc89DkZ0b4Yrhrv/W3k34J+LIk6D8XCsh2vgz
X-Received: by 2002:a05:6a21:468a:b0:3bf:b68f:4682 with SMTP id adf61e73a8af0-3c11062ea08mr7111178637.7.1783912534078;
        Sun, 12 Jul 2026 20:15:34 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:7a86::e35])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5af7d58f3sm7686767a12.1.2026.07.12.20.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 20:15:33 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Boris Brezillon <bbrezillon@kernel.org>,
	Arnaud Ebalard <arno@natisbad.org>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv2] crypto: cesa: switch to non-devm IRQ to free it earlier
Date: Sun, 12 Jul 2026 20:15:32 -0700
Message-ID: <20260713031532.2458000-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Switch the IRQ request from devm_request_threaded_irq() to
request_threaded_irq() so the IRQ is released explicitly, allowing it to
be freed earlier in the cleanup path rather than deferred to device
teardown.

Add the matching free_irq() and irq_set_affinity_hint(NULL) calls in both
the probe error path and the remove function to release the IRQ and clear
the affinity hint set during probe.

Fixes: f63601fd616ab ("crypto: marvell/cesa - add a new driver for Marvell's CESA")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: fixed Fixes tag and reworded commit
 drivers/crypto/marvell/cesa/cesa.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/cesa/cesa.c b/drivers/crypto/marvell/cesa/cesa.c
index 75d8ba23d9a2..57c9295be711 100644
--- a/drivers/crypto/marvell/cesa/cesa.c
+++ b/drivers/crypto/marvell/cesa/cesa.c
@@ -511,7 +511,7 @@ static int mv_cesa_probe(struct platform_device *pdev)
 		writel(engine->sram_dma & CESA_SA_SRAM_MSK,
 		       engine->regs + CESA_SA_DESC_P0);
 
-		ret = devm_request_threaded_irq(dev, irq, NULL, mv_cesa_int,
+		ret = request_threaded_irq(irq, NULL, mv_cesa_int,
 						IRQF_ONESHOT,
 						dev_name(&pdev->dev),
 						engine);
@@ -540,6 +540,10 @@ static int mv_cesa_probe(struct platform_device *pdev)
 	return 0;
 
 err_cleanup:
+	while (i--) {
+		irq_set_affinity_hint(cesa->engines[i].irq, NULL);
+		free_irq(cesa->engines[i].irq, &cesa->engines[i]);
+	}
 	for (i = 0; i < caps->nengines; i++)
 		mv_cesa_put_sram(pdev, i);
 
@@ -553,8 +557,13 @@ static void mv_cesa_remove(struct platform_device *pdev)
 
 	mv_cesa_remove_algs(cesa);
 
-	for (i = 0; i < cesa->caps->nengines; i++)
+	for (i = 0; i < cesa->caps->nengines; i++) {
+		struct mv_cesa_engine *engine = &cesa->engines[i];
+
+		irq_set_affinity_hint(engine->irq, NULL);
+		free_irq(engine->irq, engine);
 		mv_cesa_put_sram(pdev, i);
+	}
 }
 
 static const struct platform_device_id mv_cesa_plat_id_table[] = {
-- 
2.55.0

