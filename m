Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B083D904C
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 08:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774945281; cv=none; b=OjNyI/4ORIAmXEI7SykC9KT8/pw6QvIl9+wxdvjmX4/wp0ovlr/TNhfdZp3mz42V+mMMFkRZnQ/fycIKelkecM2VA/sx9ls31Gp1pc/ZpmYbLUXCU6pZkUBSk+wE2/gBGdhqSZzOHDYeUI828wk4O2bHFJEiwM+t4D0I0dMqktE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774945281; c=relaxed/simple;
	bh=X8pf/RdhoihV+vUE+GHa2UaVGVZmQs8OtVynhGYcOlk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mIHHn8rtSnj/K4omAPdEwzAcVkv4ueJTCu5h76npHTvH66XWs7QdBDZzJy48hG26td+fZFYSVEaYLnq3NNsI9JG1ku185xDGezGuwcQRfTk7yT9AZau99wFCP3l42sn1s0sHOVmIkXk+3gQ2olvEMxPK4gwq3qr01YeXbh4aFbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QcF001pf; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QcF001pf"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4853a5ffc05so11516725e9.0
        for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 01:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774945279; x=1775550079; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2GwQ4+C9ATAPLFcmqTbKzY7v6j7eVjPD9TBcAmNWpQc=;
        b=QcF001pfW4yu/KPbpiqGMsS0cDwkTJFIy1IyPKGeqYgPW3ryXGClY66FJlp2B2Tf0C
         IV3iHkQvh0bz0gaCM8CcVl/PhWk48RTcWhXN7k7Z9HBHBdO3okE8Bm64J0wO+nyEuHNR
         oUZZjHHiJ6nkZyp2Mq99aZLcJRRWQs171yxQ9FowbfbbdBGp2HyR4Qzoytm7jXFo+bhb
         P/n7oRisG8+tAgyEcwsZzHrWXT7kTPWrKdKkj52GV2fC3gHihjdnDcVGd/E5zitTnLfO
         zIZfF2ASn1gVNIVKbm1gOr5KGm5YBMye09/rQBBcRV56W5iRVVx4hQmM7KthOpoxMFqP
         /Wgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774945279; x=1775550079;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2GwQ4+C9ATAPLFcmqTbKzY7v6j7eVjPD9TBcAmNWpQc=;
        b=GSpD968VTPKF5c8QgtNlxN1emPrQpCNo0kOOQvSUHQ53FyheDFVAd1N7j8SX7uCnvd
         ygQFiAdpLA8EPtxk5t8W+WIqYCLsoz4mTAkqs5mfXIZ9J+q81xUW3FSjxcLa3zyf1UKd
         nMtF4cwcVvQh8uubHnFPOW3NAsNQvNgMcnabPK3oz6u6jXT7NK6b5we0zibhq30i/Rlt
         DynPymmLnN/QrOKCYiY2nZDlknAn4pkYECshnK18tE4Pw5kF9HpZ36yDrCB2opYJTL7+
         SFecjf/do1U1Ldpyur+Kx+W5Ikf/pvzcjpyAdCqF40J558bc0p1vMls/MO7hf18rNhv4
         S2zg==
X-Gm-Message-State: AOJu0YzV0veS8Fxp79I6vPZV2m/uL6eavCS0KeOdRafF7gCRwJYY1VPI
	P0AOH812ePiYfRftc8HLtxXEo+0d7BQniuIR3yaozy3gKW5OjnkxkHLH
X-Gm-Gg: ATEYQzzB8UkGXchbNWy6nvyYop0niYB2PhSfNnFU+xiNokjTnaxkhxV3PUDUb3VwiMk
	q1fPGVEjyAgPh4xGlHtQdRMDh3nfgpRbVXRp5lkphTdXc3iZmaP++Ht5znGEUZtXfFdgV8IuUJC
	aY8MsySm5n2lochIX0qRd7FPzQ98y0eDU3WTURUxInHfkubWkcg+oXkNemDLoNxYom79A5aBWW0
	7GqjLo0Lgixzbh1+N+QfNsj2n8k9hmvX/pr8/1blxFZjA7XSOO9P/ArKMamYoefG72f8V1R89ak
	bomA3zwAVRlG3IXJ1TrTesU6VvPgpDo+7b/EGGDN01VaJFtbef+GQ+fBOhwwQ2SF30nEF+AagrI
	s3CI5p9bJ7Tdq6pO0qs/3ch+3vYfDm6r4qRbaRriPEZxz2YjGnQVMu6VJgF6CvqpfDKtb9ED8NL
	NlBgP7Q6dotyTBmiLtLrTOSSzo/pJvMidjM+6+fFzuQEexBsKwsorOJo6eryy0sJY=
X-Received: by 2002:a05:600c:4f09:b0:477:9c9e:ec7e with SMTP id 5b1f17b1804b1-48727ef6489mr109750975e9.6.1774945278456;
        Tue, 31 Mar 2026 01:21:18 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887ad8d28bsm14542485e9.10.2026.03.31.01.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 01:21:18 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev,
	ardb@kernel.org,
	linusw@kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH v2 2/3] crypto: atmel-sha204a - fix truncated 32-byte blocking read
Date: Tue, 31 Mar 2026 08:21:04 +0000
Message-Id: <20260331082105.697468-3-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260331082105.697468-1-l.rubusch@gmail.com>
References: <20260331082105.697468-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ATSHA204A returns a 35-byte packet consisting of a 1-byte count,
32 bytes of entropy, and a 2-byte CRC. The current blocking read
implementation was incorrectly copying data starting from the
count byte, leading to offset data and truncated entropy.

Additionally, the chip requires significant execution time to
generate random numbers, going by the datasheet. Reading the I2C bus
too early results in the chip NACK-ing or returning a partial buffer
followed by zeros.

Verification:
Tests before showed repeadetly reading only 8 bytes of entropy:
$ head -c 32 /dev/hwrng | hexdump -C
00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@..........|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020

After this patch applied, the result will be as follows:
$ head -c 32 /dev/hwrng | hexdump -C
00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h....n.i|
00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;.....ESL.|
00000020

Fix these issues by:
Increase cmd.msecs to 30ms to provide sufficient execution time. Then
set cmd.rxsize to RANDOM_RSP_SIZE (35 bytes) to capture the entire
hardware response. Eventually, correct the memcpy() offset to index 1 of
the data buffer to skip the count byte and retrieve exactly 32 bytes of
entropy.

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 1baf4750d311..350ba8618c69 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -18,6 +18,9 @@
 #include <linux/workqueue.h>
 #include "atmel-i2c.h"
 
+#define ATMEL_RNG_BLOCK_SIZE 32
+#define ATMEL_RNG_EXEC_TIME 30
+
 static void atmel_sha204a_rng_done(struct atmel_i2c_work_data *work_data,
 				   void *areq, int status)
 {
@@ -91,13 +94,15 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
 	i2c_priv = container_of(rng, struct atmel_i2c_client_priv, hwrng);
 
 	atmel_i2c_init_random_cmd(&cmd);
+	cmd.msecs = ATMEL_RNG_EXEC_TIME;
+	cmd.rxsize = RANDOM_RSP_SIZE;
 
 	ret = atmel_i2c_send_receive(i2c_priv->client, &cmd);
 	if (ret)
 		return ret;
 
-	max = min(sizeof(cmd.data), max);
-	memcpy(data, cmd.data, max);
+	max = min_t(size_t, ATMEL_RNG_BLOCK_SIZE, max);
+	memcpy(data, &cmd.data[1], max);
 
 	return max;
 }
-- 
2.39.5

