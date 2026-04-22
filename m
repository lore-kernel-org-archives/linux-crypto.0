Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B07D3624C3
	for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 21:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776892196; cv=none; b=na54NC7qxVJovQi4wpc3DgpHF+Oi5DeTwBPYeUA6O1ziEkOoJoFCxKJKwUU2K/bcJN4Vsd+sTzNcUoAaMkFJ7UtejQl71yMBFHklWZxT0lcX73v6Eeas2VyfmvG1tyUFTterOLOG+OdfIgbsyxi6F7t4m+pypJ4yRcPtruHY8i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776892196; c=relaxed/simple;
	bh=ZMoydrc7o7FmKlzETkRm5Lk1yNUKiQmCgwkgRQfgdqM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mvwYuZy4fJW4wY8RuLiXIsFcAPgmQ3eIsofUAX2FRBZdA5JEmXXOUGpcYUBW4xbs57Dyfw3QYi3c5Nah2yG5x4BgjjPI+vbkWyFe8/MNYsqFFWPGuvmYGwVgdy/dmghjK4T8tb9z2D4ADiHKtSgtdsPKbqQvnFQr6IQNE2w0o+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qU7afEuA; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qU7afEuA"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48910865133so4236235e9.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Apr 2026 14:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776892190; x=1777496990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oFbIAxTdzhK2l/tqKW0C6io62S5s+Mdv160kLRimrJs=;
        b=qU7afEuAXwkANkmwYluTJGrMIGGjUlyJZh1b6L4a/jg1QBl26MPAa95/zWLqVvYe9k
         ZtzSkkH/G/EJ0xMjIJyret08HmG1HB5fvUlSydYFl3keGXVcxl8vaZwAsMvos8DkijmI
         B9vy+9yPFi4nr2pmlT/hRuCiviw8rX/QZ751odpLlMuiQ/jKSDtJIzfXZIbIrewpDrmk
         GyUn9DoQDTzHeUdG3SmrmOZnj0NP/4uOhWvly7PEZA5bw7v/FFVWu8mEp6xGRLsNtou0
         hYjaxFFVdi7tDMd4hCFcJ9LNBWTCK0a2R7ROe4B/sYKzthhd6LoEareDa2nM95Lyfczl
         DcSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776892190; x=1777496990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oFbIAxTdzhK2l/tqKW0C6io62S5s+Mdv160kLRimrJs=;
        b=cxaP5ykgLz5JmrDNhf/iz6OPp+4zrUbC/oC2TY+KzY3nclaLuitz+n5mNBii/yjRef
         a+WuXgYi0h0rqZfRrdAvEef4hxtvNnzDsVlkKJxkwVN8QWp3f1ob/PLYquFsZCtzsZ3e
         u25yP+D9GLRyWMQdgGPVsBoU4XGzJB2nEWzGEH0+dgfbMqP94KT9S5wE/ONlpamycaRd
         276RSvmtaVrn1QGvCDDs5V1fNsv3cQ65KTvSdy+Nx3g9/ELRyJrirjcZXr93tVHvlqtU
         jz6lEHUw/fZX3ULLXmnRisdR3vDlOsjsYbU/bBmSGxIhbNs2uiTJwGB40E3J9CoYtZCx
         1AsA==
X-Gm-Message-State: AOJu0YxKETKesnBZWh0UzGoE2I+hhZ7ec5J2I7jnmlYy5YNRuJCQP8aA
	AtzKEr0YDvvg+SvPSsI0NKTHXZJLle40put5ia7RbRT/1AY5iUTgGEgr
X-Gm-Gg: AeBDiessUhSTWicS3xUpF5kkINQ75TtQ3q7ZOCNdHh43rNF5M1uEL1RVkFbhnwgypv5
	7QJOda0RWttD9fStaMyUBj+CB7QlYwt8KOvNK/Ww27nqj2JU/G5zyBArg354GaAsv2u2SMKT6RM
	M8YCxOZor+wF+PvedO4rTNZhLzNLZKZDmp5Zy5UXMKTlI9nVuTu9EZC0LOF3DYIjrJEiLIv8N4g
	KEtZjcAIMYW/Z7iHbRhhhECIdzTTSNNAVwAdlNFE5xl6giL6wVGFrWjx1fmaXB1BmMhnTVZ5v55
	ha0tOf6j3jJcqEayQwImOfdETrTvwtjRm31FEcl+OJo8CWYFHQX41Nf5wBfJT8mAUIrh+dmrJNe
	8ETD+IMvYaUUgs6XQKzBTCkH1R7z2bwBH35joDKMxS9H96vLUPukScy16RPqQfxiVE/01LME9Gc
	wzTSFc01wr9V/xN2UBb0lv+d/Ju7WZWmAsKqVxOQyG4+dKbhCrcK6aCVjehkqZ68cLyVVItuOWG
	VZGAoJc1TAf
X-Received: by 2002:a05:600c:314c:b0:48a:5664:f44a with SMTP id 5b1f17b1804b1-48a56650076mr69908225e9.2.1776892190398;
        Wed, 22 Apr 2026 14:09:50 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a4b329542sm352469085e9.3.2026.04.22.14.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2026 14:09:49 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: herbert@gondor.apana.org.au,
	thorsten.blum@linux.dev,
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
Subject: [PATCH v3 2/3] crypto: atmel-sha204a - fix truncated 32-byte blocking read
Date: Wed, 22 Apr 2026 21:09:35 +0000
Message-Id: <20260422210936.20095-3-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260422210936.20095-1-l.rubusch@gmail.com>
References: <20260422210936.20095-1-l.rubusch@gmail.com>
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
index 19720bdd446d..f7dc00d0f4cd 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -19,6 +19,9 @@
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

