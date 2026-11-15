Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754290;
	b=OmNdJmviB1itO201MlChM/PFrlw7I140Y5lk2QnD0p4CYfdV1WXVto69M9lr6w7/Q4n3
	 GxhvLbNFXn4C7CxRanuGQMpgYZyZCH5ud/jUaa26/tx3T8z7vvjr+HbBxrPwMBjmTNeb+
	 Ec3DSTrmusK5MaY1qNGriTI/jOBufpWux8lCNZaDOqYAZBZLOMYakbb+ITeuTGVIKofKs
	 AJTuSKV3uYgWDffst+8d0Bi82LVptkj72GaO1G9/pJWChS8XddUMfgwSZE7r/Z5vQnKTB
	 FHvOVfAllsDj96APQmynbpqb43Zb4eW1NMt4Ie3OxDgz0cLo3iYeK826COetTETl82Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754290;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=1ZfYp2fVOAsovMDBuZ6IFcNyy3aPY7Zpal+R9H3Fzo8=;
	b=tGaVSDRYOtXpx6SVFTEQHuLahSV8SZD/9RJ3ZoHjguPml3zbGMapWemrvnvDg+3jwt65
	 WsONjAgtEqWn5w7dgT1VFT/nl99eFkwvEFRVq8G1MoE69iPkV9Yn9JJk+0+IPPbos7mH9
	 nEDccUVVqNM0JuSNA6CsTn4FF+ItDqt/nB9eGOFoZeTTU1Iyol7/pahS4CM+0CCD5gR35
	 LAsWd1igk1ERhAXhBwSVhag5CpZz6BpnjPL3avxZT/CtDxDnKbOCFR1xqd93TlCb1XcbM
	 Ss6u4BUYa2/fXNjs07MsNTMJ66mfj36FElq3eu+eGil/SJTLsunoO126meBy/WJF9+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a9SIedi3;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D88606A323
	for <linux-crypto@vger.kernel.org>; Sun, 15 Nov 2026 14:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75D88606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a9SIedi3
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cddee4abc57so129938a12.0
        for <linux-crypto@vger.kernel.org>; Sun, 15 Nov 2026 06:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794754290; x=1795359090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1ZfYp2fVOAsovMDBuZ6IFcNyy3aPY7Zpal+R9H3Fzo8=;
        b=a9SIedi3C6EHJCF1iS7LlJ9JTawYnDP3geGbLahyMmZbYrRcciEIC5LWSZov4Y4nrU
         EnIp44EKasSUXQILotvPIDflq2Mq2xRA7WmbmxFmA2JccePPAdK1VCbsUeZYE2Ew2LB+
         TB6XSaDhRBVzJ9gGln7vw7Nv8zzVIFRPyiz4CHMSgbpxeq9LTLNDlxY6OCky8pyOcmUW
         xLyt6jqpxoY1DIWqkhsd5j+KsbLfr/7gv/PgfMqSQUxI7V0OTMnpyGgpcf3oT1Ib3E8Y
         zLw18kCeVI9c6ee8KcvdYtGF5d9j+gpTf3L4i9gMPKLqUppZGKUxN/hUmP1e/MRDhLM+
         FZZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794754290; x=1795359090;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1ZfYp2fVOAsovMDBuZ6IFcNyy3aPY7Zpal+R9H3Fzo8=;
        b=pUbXt4sznYK/DxMU7wjYq1ynbsGAuBQhtWrp+tluUjrWkde5Ya8mh/NNT//d4CjX+J
         GTOb8beYeJoDbeevsorMHNVa6LFzgOXANJ6RFk+MuftulNRXe8H4gDwQ6SUdQGLbH/s0
         /37Tb7sb3BE8GAMdSlgoL1HjN2OAvvuo6rem7fUummW/q69K1K3ObT8n0FQeLiJvdrTz
         BtUUqQNYVJTiA1HsGN/2uCJRu2vrdSFtlFojRjClUfx2xFWO7VpqR16AZFfl/mnJ3c3A
         bGVEmlrsn4QxXHMgK3KvlUp1KEAfX9Hg65Sk3FDih6O7ls64UoBkAWQxHcgndjvCV9q3
         JeWw==
X-Gm-Message-State: APuU4Z+LESJYrGO1J4vyWSmdtVm+9ROUK2JTd484l8mqz4Uu5Dg93uuE
	gSPKdGkLrGIQkZl1r6fZHVqWVHIVjqmDN2O8GqfG9guk9FT7Na+rwx7O
X-Gm-Gg: AYBFou2hmkXnvq2DB1z3QPCQJpt4I3/2KpSYIYTBfSjAmIcicdjeJ3BdM6x3OpDz2FR
	aMs5NT5slMmXXFLf6sVfSbmTl5rigLA0bGcwmFaeWnoOlmOGZpUTa1ukhZ2u9TdZT/Z30lowW4I
	0WmNMLvlCPz7ks6/ZHuowipT13k+KJ5qXEDncCx2q7jinDcNtMPNcXDPbE3LN8SuOZxNoxJ25IT
	trh3wAVIQEcxPmPx6p//2moWaRHvhB0xMknPMqyqKCFW+29Z8CdhrkHuDOI++0VETdqYGjcK8jk
	aSjttRgbWn5ACdVYi2Tt0jDXuJhb0cAqlF5BXqFUkYtBEKvPtHslEe/RizddVcFZWZ6qxqHSa4A
	9EZdH8ffsNzdFciHGJIfkv4gi9QaxuwD/0jlWiXSTCRiD7gVbFnp0t8YzWIWsbycGMcHtp8Jq95
	UvKPYvdGR8R9NVNAnkJ9LZEFa1h26popcTgs6RH5q299pLmCLHdpQcnd2YoVrdAv/N4aNHeUyPg
	FPjfskAdCCmYdKlR7YxazMqSSL8RCtUccTFtttVLHFgwdSm5BNa0V8zbR6sLZvIRbjePECuC4OP
	/+H2GoCAGqc6zA1B4Fbokp3MjOSPA3rx+E/gkSpIkN79dZgL
X-Received: by 2002:a17:90b:1650:b0:3b1:8396:ebf8 with SMTP id 98e67ed59e1d1-3b1b0a4fe2emr7626437a91.36.1794754289600;
        Sun, 15 Nov 2026 06:51:29 -0800 (PST)
Received: from localhost.localdomain ([115.76.89.253])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d32ea0sm17353559a91.15.2026.11.15.06.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2026 06:51:29 -0800 (PST)
From: Nhat Tran <nhat.tranminhk2@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Olivia Mackall <olivia@selenic.com>,
	Deepak Saxena <dsaxena@plexity.net>
Cc: linux-crypto@vger.kernel.org,
	linux-omap@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nhat Tran <nhat.tranminhk2@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] hwrng: omap - Unregister hwrng before disabling the device on remove
Date: Sun, 15 Nov 2026 21:50:50 +0700
Message-Id: <20261115145050.88427-1-nhat.tranminhk2@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Commit 3e75241be808 ("hwrng: drivers - Use device-managed registration
API") switched omap-rng to devm_hwrng_register() and dropped the
hwrng_unregister() call from the start of omap_rng_remove(). Since then
the hwrng is unregistered by devres only after omap_rng_remove() has
returned, i.e. after the device has been runtime suspended and its
runtime PM disabled.

When the omap-rng is the current hwrng, hwrng_unregister() drops the
last reference and schedules cleanup_rng_work(), which calls
omap_rng_cleanup() and in turn omap4_rng_cleanup(). That reads and
writes RNG_CONTROL_REG while the module clock is gated. On a
BeagleBone Black (AM335x) unbinding the driver triggers:

  # echo 48310000.rng > /sys/bus/platform/drivers/omap_rng/unbind
  Unhandled fault: external abort on non-linefetch (0x1028) at 0xfa310014
  Internal error: : 1028 [#1] SMP ARM
  Workqueue: events cleanup_rng_work
  PC is at omap4_rng_cleanup+0x14/0x24
  LR is at cleanup_rng_work+0x30/0x48
  Call trace:
   omap4_rng_cleanup from cleanup_rng_work+0x30/0x48
   cleanup_rng_work from process_scheduled_works+0xf0/0x518
   process_scheduled_works from worker_thread+0x140/0x2f0
   worker_thread from kthread+0xfc/0x134
   kthread from ret_from_fork+0x14/0x28

The worker dies before it completes rng->cleanup_done, so the unbind
also never returns because hwrng_unregister() waits for that
completion. The same window lets the hwrng fill thread call
omap_rng_do_read() on the suspended device.

Restore the original teardown order: register with hwrng_register()
and call hwrng_unregister() first in omap_rng_remove(), while the
device is still powered.

Fixes: 3e75241be808 ("hwrng: drivers - Use device-managed registration API")
Cc: stable@vger.kernel.org
Signed-off-by: Nhat Tran <nhat.tranminhk2@gmail.com>
---
 drivers/char/hw_random/omap-rng.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 49d7f021fd31..e5b14ab1b7e4 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -493,7 +493,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_register;
 
-	ret = devm_hwrng_register(&pdev->dev, &priv->rng);
+	ret = hwrng_register(&priv->rng);
 	if (ret)
 		goto err_register;
 
@@ -520,6 +520,7 @@ static void omap_rng_remove(struct platform_device *pdev)
 {
 	struct omap_rng_dev *priv = platform_get_drvdata(pdev);
 
+	hwrng_unregister(&priv->rng);
 
 	priv->pdata->cleanup(priv);
 
-- 
2.25.1

