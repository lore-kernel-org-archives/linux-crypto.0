Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.217
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794209774;
	b=I58IiwMqndKfZKSBNi2IqNMNKILQIu0M6KHcKVCSmQ+RkgzJNXtp/+zpsJLuon07ziqc
	 uX+eas15GL4dZhhHaGkhlOkV46awIvybnSBEX08bay3DgURsJu7cfnqC5p9jkZXPhb6RJ
	 UY9zc/cw6pPd48srp6hXczXjyIKGCedWE581HUj/uhmUJvpQ8O3SHT3c4ma1csNjb9+1g
	 Y5O6zZiQy9vnxFEuXsRDA1OYpskxrJBa8x9nQ0EJVq3GWa7RMd8aVti1i/c3rPxNigRWW
	 2hoH4enOQcmD9+JnkJbvW5ZEcX1Q+NZfpuMwVG16CwXCHxG/eRDA37rJkzje3YQFffw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794209774;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=4PSBgBKPMTFaPBbhIHGgOgP5gYmCkxw9n9vkogmf9Ac=;
	b=eIJMtwEIv3FPybAaDT/1sDkBBbVIW1eJ0ryrmVgfggKyr4TNi+8wWXD2N4EZvRs3Sglk
	 M6ftCXp6RWdyTurElZk+zhQKcOrGOE2DEPC81uMHb3IBwGn32COMpWC7zmSOw9Lb1x7dl
	 jfPnvQrVsfjklk6vbaMqxaG36Ddk7DW2CzlNaTdKRQscy3u0uFqgKrqjZVMr81Zz73SM3
	 k/eblY/JQqRkeZNNwVChshf5Nj7bvWlcDIc2xkUSH0zcO5Uzw/kjKrlgSjKvsUj0uSdFT
	 YGNDDr5OWFszS+/na4hamzrAAZjPXnHeTajUbVT7YNCxGc5Br43KGd75hwx1Lk88ZAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=JXYJv7Jl;
	arc=none smtp.remote-ip=113.46.200.217
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22A2606A32A;
	Mon,  9 Nov 2026 07:36:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C22A2606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=JXYJv7Jl
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4PSBgBKPMTFaPBbhIHGgOgP5gYmCkxw9n9vkogmf9Ac=;
	b=JXYJv7JlcNeKagLb7/Y/RdeVGp4+JD8PlQlMUqoowTPP/MGsSHz6WFLxOZXJOmuDCrtIJZnuC
	lc9IBrFhPDbFVkxrU6rEl1E6whqUmR0z8GSIP+pHEITPQ60UaqA2P0BlWaSK/JiQHCLTEVI/VeX
	wre2AqQKpPV0pP0MbtzXKuc=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4jNM5J6q91zcbMY;
	Mon,  9 Nov 2026 15:35:32 +0800 (CST)
Received: from whupemk200001.china.huawei.com (unknown [7.152.184.93])
	by mail.maildlp.com (Postfix) with ESMTPS id BC60340561;
	Mon,  9 Nov 2026 15:36:08 +0800 (CST)
Received: from localhost.localdomain (10.50.163.32) by
 whupemk200001.china.huawei.com (7.152.184.93) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 9 Nov 2026 15:36:07 +0800
From: Chenghai Huang <huangchenghai2@huawei.com>
To: <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <wangzhou1@hisilicon.com>,
	<linwenkai6@hisilicon.com>
Subject: [PATCH 0/4] crypto: engine - add acomp support and adapt Hisilicon HPRE and ZIP drivers
Date: Mon, 9 Nov 2026 15:35:52 +0800
Message-ID: <20261109073556.2517351-1-huangchenghai2@huawei.com>
X-Mailer: git-send-email 2.43.0
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

This series adds asynchronous compression (acomp) support to the crypto
engine framework, then converts the Hisilicon HPRE and ZIP drivers to
use it instead of their hand-rolled backlog / queue-retry mechanisms.

Patch 1 fixes the retry pump loop in the engine core: it skips the
idle check that clears engine->busy and rechecks engine->running, so
after the queue drains a later request can be enqueued without a pump
and stall the engine, and crypto_engine_stop() can spin on the stale
busy flag up to -EBUSY.

Patch 2 adds struct acomp_engine_alg with transfer/finalize helpers and
a register/unregister interface, mirroring the existing akcipher and
kpp support. struct acomp_alg moves to <crypto/acompress.h> so that
engine.h can embed it.

Patch 3 gives each HPRE QP (DH/RSA/ECDH) its own crypto engine.
MAY_BACKLOG requests are routed through the engine, which provides the
backlog queue and retries on -ENOSPC; other requests are sent directly
with bounded retries, and in-flight requests are cleaned up by the
completion callback.

Patch 4 gives ZIP a per-device engine pool, with each QP context
borrowing an engine by its QP id so compression and decompression
queue independently. Requests are sent to the hardware when it has
room; on a full queue they are parked in the engine queue and retried,
with the DMA mappings kept across retries.

Chenghai Huang (3):
  crypto: engine - clear busy and recheck running in the retry pump loop
  crypto: engine - add acomp support
  crypto: hisilicon/zip - adapt to use crypto engine

Weili Qian (1):
  crypto: hisilicon/hpre - use crypto engine framework

 crypto/crypto_engine.c                      |  46 ++-
 drivers/crypto/hisilicon/Kconfig            |   2 +
 drivers/crypto/hisilicon/hpre/hpre.h        |   4 +
 drivers/crypto/hisilicon/hpre/hpre_crypto.c | 414 +++++++++++++++-----
 drivers/crypto/hisilicon/zip/zip.h          |   5 +
 drivers/crypto/hisilicon/zip/zip_crypto.c   | 358 +++++++++++------
 include/crypto/acompress.h                  |  33 ++
 include/crypto/engine.h                     |  13 +
 include/crypto/internal/acompress.h         |  33 --
 9 files changed, 649 insertions(+), 259 deletions(-)

-- 
2.43.0
