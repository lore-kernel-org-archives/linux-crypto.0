Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136FF37F8CB
	for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 21:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774301292; cv=none; b=StqcOSKVcP5WBNwe6AAFuMmrtHpGsQTd/+NtFhJOZVfPmNibpRNfzOUXlyzFM7CYR4xf5K1AcqmgaJjijTzZFTsXWR2flf/oxUicu+DIzdSmXiXBxyXujn1Jx7g7YIV8r+3gAyCwXA3AA1vDwhbQzVwHWrvbHJftvd5H/1S7TeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774301292; c=relaxed/simple;
	bh=FgIOcFM8s9R6nuzyMTBBlQ7LGLqjwuZuy4bomRP/2e0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kr0FhfRbo28ZH0VZJ7iQyfCJ1QWFgFJF9YViXzi61gumwyKwZHbjNQOaewf3b81IblGij3WUtdnMz8N9e1QN2aCgTQJ7j5S7+kJTl4CtOR+XlEIdlXU+IRjM1MalJ1NVdrfWpDZsK38z0EWPeYURVko2J4iLjPwTPMlQo45SlyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SRU5or4+; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SRU5or4+"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-486fc49c5c0so5631765e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 23 Mar 2026 14:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774301289; x=1774906089; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=csOGr/K8Tf7uItgGXZwcjonMRapeP/TA0fdd2GZkXSo=;
        b=SRU5or4+Ebg14RA/5Ua71Ie3UmFmXlyTaKhK5trmUjqJx4NWyQFX+/2HNmBTk+cLtv
         YTJmGajFBSH14H/C39B7YOo6Dv6o57yLsGKT0+LtAn1Bc4/TDdoVmm+RmpW2WXvX8xEA
         8g6ybcvWPYRJUAJ7PjRvsxSMMCRB30ZyJCeo8mWBplp0uiR+QWZUv+cXP/uw/DcVUT2P
         LWfvNHsFCyxURLXGSXLEz8PLINfqf0ieBum4Hvd2vjCpRKPLYy6NkpsJR4NEAgDx8ylU
         ZuYbziqvq0//c0kW1wRyikoLkh4NHmGSYNLoYhVDBXMlQWPk/+UpEeMOX2F7OUwN1H/H
         l/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774301289; x=1774906089;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=csOGr/K8Tf7uItgGXZwcjonMRapeP/TA0fdd2GZkXSo=;
        b=Qo3vJOud5CG1Ggnkk/ydkOJU0GdUryS1IqIvS+WLObZEF6McR+0ANz4ZpFYDXGIv6t
         df1DhhzKndWsy5ftS8C7Vk3hpzLPKMcnVaqx5Z+UDsG4pKAU2GKYT99i2NW48umhol5w
         okx41vnw6afmpJ+xNmZCBoc/Q/W/9G4bEbxteVWwgJHtziTlTpPmGe6m9WIGjQQxAPBD
         PZbUsZouuTf7MEaEFRRta+OvSCKy217mnWHm9V02txI3yp93d9OLoEO6kc/j/CXFAYM2
         sRsJ/eEOZFPhAgGG6ArciSVqwY+htXxJXrXHVb9soO+EheJ8rFVSFQTeKq7hDJ/lWbGe
         B7wQ==
X-Gm-Message-State: AOJu0YyjGXAOwtb0/2xhAnrVwsQKQhEfkK1ZEBOv1vj4Q3FcXvWn7Ojl
	QYgbcAwl96DMJv3iGDiROfDmAawaGS7fOW0xAyMViswQzely/qThJlcg
X-Gm-Gg: ATEYQzyjHfk4Ayk98xyink9hjtpUs59qEYhBeWHqaZVnF8/Gb+fsmYsLCe4CrbJgoPg
	dEeM0mYto9eHL7I/euCCfteVtIF2BNRsfVBL1KLtgRKu+pMSmBtfra+AJpfO1uqCgNAyFfKS4pv
	Kg3ESrLuYgIxLj2VSdkNlJhhWhDiwxNJZLgih69C0lyKn1SKB889EEXja16UTb6xgOptP5rmMFR
	nBXsAJLip15Cj8qIuG0G/dJrO610sshw1UQUrcVkm/Bq4honmoJr7IXsipbGWoq26REPtuuWdiW
	dEPUQeMgyqafoPmvgFsJSxPvCPxIJ0vyigU3+tj0FTxHsZPfnRCNmMPsZ7ARHpNoHhQfNDKCIKr
	sLtaT5lowt25my7ZmFbgiLTrsOIfzWap+Rl+t/KzcXRbdzVl4hML6LvlxfyAL0HWrvqIPfXwUDz
	wEazQHk5PkvQLBm3gNNMt4CcTC/36yLP+yUh3XfUEubmaUbyllDmwBnUb1oiYKKuM=
X-Received: by 2002:a05:600c:3b07:b0:485:9a50:338b with SMTP id 5b1f17b1804b1-486febb8560mr105205725e9.2.1774301289309;
        Mon, 23 Mar 2026 14:28:09 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6470393fsm33386975f8f.17.2026.03.23.14.28.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2026 14:28:08 -0700 (PDT)
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
Subject: [PATCH 2/3] crypto: atmel-sha204a - fix truncated 32-byte blocking read
Date: Mon, 23 Mar 2026 21:27:54 +0000
Message-Id: <20260323212755.687342-3-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260323212755.687342-1-l.rubusch@gmail.com>
References: <20260323212755.687342-1-l.rubusch@gmail.com>
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
2.53.0

