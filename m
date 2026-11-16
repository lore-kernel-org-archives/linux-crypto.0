Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794838658;
	b=ho7+MaVuJ7IIZhTtLFQt3t/SidTxJL+g8bZqW6dzBAzxLRGBk8UHLO86nO11p1jD5ttc
	 YwteqvN/02dfr7m3SNkfnqt+xkHFf8APFPMFg31VX8TnmVFO7D0ssq0EPxQhEOZ3h9t6B
	 no+sg6X8vwylErmpz/ykPBTuxmuJnvR3DUpxnKUEVxAXZNI4Rx+eGYpUSVQSsTQZWONEp
	 yuFLJg+rAVXjGbFjBA4PeQVu6EejNtXZz27ugGwKX6N9V36F0lAv41bkRlujVinftN17n
	 ZTAw1QGsRtbxGupZqi6p5jLToYLDyNTif6XJX/87BPehT9wrRx1cNwiX5dyNkddZ7uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794838658;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=giP4zr7/1xQzxpkVfS9aMV/TzjoOGGnqbTKIKs5sHlM=;
	b=AVYUsC3F0c5CLuYCK95CMaZZ6Hg4MNYWp95uSoUoRmj6jknpGWoxgTqD3wS9nH86W3+3
	 GJX3idib03nAFp+8xgjuzDu7q+m5qTZBv7EkSYLFCFAE0D0mo1xMo/kcFbLHFCkvzuqz2
	 zIR7MY5CQGWt7etinQofXhFlchhMP7l2iQH1RpjUU8vBIj7L/c8PugRZEYhhMTX4eYhni
	 VX7s8RTs1/fg7QPnbak6vUlLwjBQMtCTFCIMsBZM3Ulp+m0xYpWmBQkR92XpSMqUGn398
	 Q6gVMw5DoA+55avojnyr+uxvzNWsxMeei/5o39H9FnlV/+hDLS3WUFZoe/3PZFoZubQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=OBwxn7iR;
	arc=none smtp.remote-ip=101.71.155.101
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6872606A330;
	Mon, 16 Nov 2026 14:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A6872606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=OBwxn7iR
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 54db4478d;
	Mon, 16 Nov 2026 22:17:33 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: Ayush Sawal <ayush.sawal@chelsio.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: chelsio - Fix potential NULL dereference after detach
Date: Mon, 16 Nov 2026 22:17:32 +0800
Message-ID: <20261116-c29ba55625-crypto-chelsio@mail.sdu.edu.cn>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1e4b8683b03a1kunm146edbbb10e019
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSktPVhoZTkpIH05ITxgeSlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=OBwxn7iRsVM0rKlObWAEhsqiKps4J0yoH7uqWh6qxF2PBC46P29g9Y2ItJgF2ZaYIsUZDWluLC7YRaZHKEDRt4bDUT+6dxDyAc/+7s0ifCOvU6otCUaijxKJj1KOw+0qLGER6q+m7UkUBNH/Dbxvd448E80VufdmkPQCqBqlNe4=; c=relaxed/relaxed; s=default; d=mail.sdu.edu.cn; v=1;
	bh=giP4zr7/1xQzxpkVfS9aMV/TzjoOGGnqbTKIKs5sHlM=;
	h=date:mime-version:subject:message-id:from;

Detached contexts remain on the inactive list until module exit, but
their PCI driver data has already been cleared. Looking up the adapter
to reset its counters then dereferences NULL.

Skip the adapter lookup for detached contexts and free the contexts
without accessing the removed adapter.

This issue was found by our static analysis tool under development.

Fixes: c0271a053612 ("crypto: chelsio - Resetting crypto counters during the driver unregister")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
 drivers/crypto/chelsio/chcr_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/chelsio/chcr_core.c b/drivers/crypto/chelsio/chcr_core.c
index 2609a8c3c18b..96ac6ea482b2 100644
--- a/drivers/crypto/chelsio/chcr_core.c
+++ b/drivers/crypto/chelsio/chcr_core.c
@@ -295,8 +295,10 @@ static void __exit chcr_crypto_exit(void)
 		kfree(u_ctx);
 	}
 	list_for_each_entry_safe(u_ctx, tmp, &drv_data.inact_dev, entry) {
-		adap = padap(&u_ctx->dev);
-		memset(&adap->chcr_stats, 0, sizeof(adap->chcr_stats));
+		if (u_ctx->dev.state != CHCR_DETACH) {
+			adap = padap(&u_ctx->dev);
+			memset(&adap->chcr_stats, 0, sizeof(adap->chcr_stats));
+		}
 		list_del(&u_ctx->entry);
 		kfree(u_ctx);
 	}

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0

