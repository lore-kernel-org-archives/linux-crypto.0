Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794209775;
	b=Bl6otZQzm7/WKDXXQ3dH/0sPSddNTv2MEsgs9u5jkCbW0N/4uZIGbCGw4GaxbfE27ppo
	 qgDCixoLH1nOm1WjVYMzrh2x101SZPKgzh+Zv8Z8AZ/xWOwLwXJJ98i/o6npNFh6Xa6p3
	 g1oacJ9+Z32FlHIa0/fhAfKaN/hRgtXkqyqlGizzUskQpD+t6Mb3TtDe5yXkORJ7B8KHl
	 60Le/ghpGgdu397672/d0SbaTe8TATL/zo8Gwny1eNXWHTDU4+MmdSS9dAKaBRgz8JRSG
	 SOgmKzdye7MVMBzyzOBffoGRQHL6uWnNZjXs5VgY2/UZ7gZWWuh/3ZH8gxZtJzE0xgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794209775;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=yF9JVkGVR2aGG3aF6jXJ0BO0tZQAnzVsEur9IWCcqTA=;
	b=h0+CQ5MRmnWqQH/BPDJEJblcJUeaJkIJlTAyMoHNRIA01HAycdLlQfiLFmPhXzxQxTk5
	 VwWK7xpj99CyDL1CkU64oVFy+ppMkSMvZ6rJoFhxkFFT+Qa/6EWazW/O2Q419T34jRccP
	 14mfVNPKDeafwJVhIlWC1IalGCHmTp+drGkeFspG4ijpSGWNmAW7QRksgJE56jPjy1Qhr
	 IXd6igcvMnN3dKZnn8t0spSIXlp3CWVBqnY9t9GD1BuCjfCV0khOLfpTvY0+Xwt91uOcw
	 XQat1Tf/AahPRiqhKwc7RfgtpWG407SzjwgD18oMqzJEIovl/N5Bbt8SF3+yyWDpPSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=h9p58XMX;
	arc=none smtp.remote-ip=113.46.200.219
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF49606A31C;
	Mon,  9 Nov 2026 07:36:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DF49606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=h9p58XMX
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=yF9JVkGVR2aGG3aF6jXJ0BO0tZQAnzVsEur9IWCcqTA=;
	b=h9p58XMX6OH6j6VoyN6nQd/OlAy+/gxcTNa+btddTXDsIcEIK49m4ciFn7EQKa0Jxduziofxr
	Td3sRr8a6DaGwSUsecW3L4yBxVD8yD8p3tvDWELzS7g03/K4L2KbSnLYpvpcVpcUo5eFUOIGeJu
	i/b0ENl1ooZVjSg/vxQrK0I=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4jNM5t0KVgz1prmH;
	Mon,  9 Nov 2026 15:36:02 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id 8EC584056E;
	Mon,  9 Nov 2026 15:36:09 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 15:36:08 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH 1/4] crypto: engine - clear busy and recheck running in the retry pump loop
Date: Mon, 9 Nov 2026 15:35:53 +0800
Message-ID: <20261109073556.2517351-2-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261109073556.2517351-1-huangchenghai2@huawei.com>
References: <20261109073556.2517351-1-huangchenghai2@huawei.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemk200001.china.huawei.com (7.152.184.93)

The retry pump loop jumps back to the dequeue path directly, skipping
the idle check that clears engine->busy and rechecks engine->running.

When the loop drains the queue it exits with busy still set, and
crypto_transfer_request() queues a pump only when the engine is not
busy: if the loop ends with the inline error completion in req_err_1,
which queues no pump, the next request is enqueued with nothing to run
it and the engine queue stalls. crypto_engine_stop() also spins
waiting for the stale busy flag, up to failing with -EBUSY, and the
loop keeps submitting to hardware after stop was requested because it
never rechecks running.

Jump to the idle check instead: the loop now clears busy and exits
when the queue is empty, and stops submitting once the engine is no
longer running. Engines without retry support are unaffected.

Fixes: 6a89f492f8e5 ("crypto: engine - support for parallel requests based on retry mechanism")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
---
 crypto/crypto_engine.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 3d07dd5de4fa..5b669038acb4 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -82,6 +82,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	if (!engine->retry_support && engine->cur_req)
 		goto out;
 
+check_idle:
 	/* Check if the engine queue is idle */
 	if (!crypto_queue_len(&engine->queue) || !engine->running) {
 		if (!engine->busy)
@@ -98,7 +99,6 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 		goto out;
 	}
 
-start_request:
 	/* Get the fist request from the engine queue to handle */
 	backlog = crypto_get_backlog(&engine->queue);
 	async_req = crypto_dequeue_request(&engine->queue);
@@ -161,7 +161,7 @@ static void crypto_pump_requests(struct crypto_engine *engine,
 	/* If retry mechanism is supported, send new requests to engine */
 	if (engine->retry_support) {
 		spin_lock_irqsave(&engine->queue_lock, flags);
-		goto start_request;
+		goto check_idle;
 	}
 	return;
 
-- 
2.43.0

