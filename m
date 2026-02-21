Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6416FC5
	for <linux-crypto@vger.kernel.org>; Sat, 21 Feb 2026 19:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771700727; cv=none; b=KZlYbxKehVnUKkCceTBX9WhizVuS8kbD1jCTxGu1J/7QleCxwbw2IHw6xRWanq+YWPjrQ0W48nlX/f3lsiF0qHyWai8QUviAjbXdpSUFGwjhWoLMmuyoV7KOExf7uuHKqzemo1EpeEeHJ0UYkLF5ZvTxUXQhS0aTGwZQ4V6qvJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771700727; c=relaxed/simple;
	bh=gKuYwENYrceJVeDntO1G4tFGAIwXGxYQRoFfN+PoFfw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C0gZxj0H4CIrLilwNBRQLIbdvPEZ3rGtqLTjQmqk/yQRfm1yfNhuhNmgKoY5fXJSFNElY7YYe+MPjH5aDCnJ+DzoeQEMvQv88NKg0UoGybrtgbbViFk8v1f9i9Ciy0k6zeRIaCayiLr/SPcBEbFusMTtHE0aek7QjhiAv5mefzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EdeceEfM; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EdeceEfM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771700713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yLDQ4G+6GFW4iU0X3Mnjq0LBajt/MPm52sZH7eipsqY=;
	b=EdeceEfMPT/HNqUYPO72We4yfdggi2cTnMn+D9wm8fmzCRykKB02TV1XcWa1PEM8cZ0qGc
	/dQT1pGeA/XzITZ3FExKB89rkc5WM+q1A9D3ZEtpAi2UhafgqS30Eq2OetAXTFGFZxncvu
	mxyxvvVZ9zb4B4VlTCxK7hF1BaZCI0E=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Lothar Rubusch <l.rubusch@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Linus Walleij <linusw@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: atmel-sha204a - Fix potential UAF and memory leak in remove path
Date: Sat, 21 Feb 2026 20:04:25 +0100
Message-ID: <20260221190424.85984-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Do not return early from atmel_sha204a_remove() when the device is busy.
Instead, flush the I2C workqueue before teardown to prevent a potential
UAF if a queued callback runs while the device is being removed.

Also ensure sysfs entries are removed and ->hwrng.priv is freed, to
prevent a memory leak during removal. Change the log level from emerg
to warn because the system is still usable.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
Compile-tested only.
---
 drivers/crypto/atmel-sha204a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 0fcf4a39de27..3afad915aae3 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -190,10 +190,10 @@ static void atmel_sha204a_remove(struct i2c_client *client)
 {
 	struct atmel_i2c_client_priv *i2c_priv = i2c_get_clientdata(client);
 
-	if (atomic_read(&i2c_priv->tfm_count)) {
-		dev_emerg(&client->dev, "Device is busy, will remove it anyhow\n");
-		return;
-	}
+	if (atomic_read(&i2c_priv->tfm_count))
+		dev_warn(&client->dev, "Device is busy, will remove it anyhow\n");
+
+	atmel_i2c_flush_queue();
 
 	sysfs_remove_group(&client->dev.kobj, &atmel_sha204a_groups);
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

