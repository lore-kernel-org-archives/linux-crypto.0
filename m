Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097F12FDC38
	for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 21:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777238998; cv=none; b=s6AbUCwLOTR6YVs7ghRGU+YHsfcliIGLWZzTZaFSvHDmfjmRCmHTZJMq7BKz0inW5rgWDUpAb7x7EuzgQJ7T63c6eenfD+w66tsrQAu95zvhcHeDTAbyraBfSW4o8VG5mvdHV+zHs/T0aVSGUH4zQ8gGRVc7I9UaM4mbNIL2B8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777238998; c=relaxed/simple;
	bh=4kDmO+Sn24u2AqLLrq+64jAFcR1LrxQW8BDS8JdjPGA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FQa7oRdF2hs3+d9YvQfB3xRjQ8FPeqUfGJ2lXlSaBwA5qZXUBsEZkzME6y1Fk8bMrPmyHbVXSHBIJQW7x25fMKXA3FvC0Hf1ofEZJI9xL6CVc9mX/3pryzQ4LyCuvzzsq8kM2YdS+FfyOGEACT7w+57m7joNRDhvLeESgIie0pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M33xGM0F; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M33xGM0F"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4891c569cb1so11389705e9.2
        for <linux-crypto@vger.kernel.org>; Sun, 26 Apr 2026 14:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777238995; x=1777843795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sqonbb4yOoprB7ZvKc0Cn/U848NJVsSj7hGA97TbfZ0=;
        b=M33xGM0FqmPrXCDCeOUnEPAktif6s/NL/RChdVH9vRswOsLfO1kCJVA39DOcGJFQnW
         cU6WvywBUImB8+6iyamMUSGOvmzPTDY8kbrUjjC+Nd3Sfo6rZSLrto+/2lCxSbLgoPLj
         Ddo0KKPgU3dWnKXu95GSqXFZF94tfrtnf4ZBEEowZmP/DWRm956pVf3mGqPdt7mUVGDX
         2R49oAMMO2sEWAzoHH2jqMR5auPXTS0RmVFWBA/CWz0+znm+9TnuvC21obpiJOTty72o
         aYr0bf7evWBU9FbBjWhPM8+TsnU9SmnfRiFYFswbauBVDNvdkxJ1DMe4d1SB4akKX1t2
         4vEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777238995; x=1777843795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sqonbb4yOoprB7ZvKc0Cn/U848NJVsSj7hGA97TbfZ0=;
        b=YkzroYCn0nX2l2oENCeL8Mfr9BDje34GdM3gAqXuRpyb/ZN4YES0BuOhi9BBfGUode
         i5gqSTXI6lmmXYYembjiAncG5UEVyAfwjsi1P4Dn+j+IhyTcHMvA/VlApYfto2hf9dRV
         Au8xQRn69RCzDxiiPFvRsEVi1vtlG7OMMzGlgc63LW9jPjztO88peyNpRbtwBP6WdhKH
         lBMOcrwfk1G0g5DDPMYeFEiXcbeUe+3ZbBsA/TtGUHdG7Z7+lib8S4JlNKmGhS07uiV3
         DTUNLl48AzlgTBgQKXfScgnjjMtwC5i0v3e4hh/gyiQ9rKYuAUv96qT8A+Cqth6KJVc8
         tKCw==
X-Gm-Message-State: AOJu0Yz5T4GW1Mdzx97wQgzXkL8FZF7zN86GNQcCKVZtJmUK94ewyF6D
	WQQqbwOZtVHK2nNEIgCJy7/iZKL7a/UxUx8n5wc9DRKEEce8uoGx3mHa
X-Gm-Gg: AeBDietGLJYUgl4+qP6v05P7QAwbsl5Nh3z7mmnaY1PgkaPUoZ3FPW5i7kY/x/q/Ze2
	D7SlvQ+O0n4ZKkoURqXfV8LaQ9eHMemDhqdxPouEq8ShaXuKSjr/2QtiPEIiZrnnKZhjsIXTxX+
	5895T3LXQyrEhwT0sdLqyE+6YeUbbi8Ga3Nd4C4VUNOz5LuYmQe1QBOLg/fvm2u07Qf8lZV/kai
	gmc2KjVceOYEWTbkCSpiM+go7KBAVlCftCIiJe5cqP1GiV1nhXoZgFrVh6RgkXek/enxvlNhIrp
	cfrbZV/Hqj0gtjG9RsxwcRnyqnJeHAN15HO7kSqF0hdMbuWxK9db2ZHvPyIfoT0AYc9F3x21eOJ
	BAUxnJz2pK+iEu49JHfNSRRH0lBpnsC+aFAyr8yYymlkkNYIG0Oh4NyXu+85Tn2mqTR7kA5y1me
	HY26vAF+wzIIlo6O3uYC2scSoyzQmwV7HY20XGYZqy8X3LrUDZL5ZbqfFsuC1DVDXJAXqHz4zL6
	g==
X-Received: by 2002:a05:600c:154e:b0:487:17d:d0bf with SMTP id 5b1f17b1804b1-488fb769fb4mr257421595e9.6.1777238995346;
        Sun, 26 Apr 2026 14:29:55 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a79esm79047320f8f.17.2026.04.26.14.29.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 14:29:55 -0700 (PDT)
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
Subject: [PATCH v5 1/1] crypto: atmel-sha204a - fix blocking and non-blocking rng logic
Date: Sun, 26 Apr 2026 21:29:47 +0000
Message-Id: <20260426212947.24757-2-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260426212947.24757-1-l.rubusch@gmail.com>
References: <20260426212947.24757-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The blocking and non-blocking paths were failing to provide valid entropy
due to improper buffer management. Reading the buffer starting from byte 1,
only fetch the 32 bytes of random data from the return message.

Tested on an Atmel SHA204A device.

Before (here for blocking), tests showed repeatedly reading reduced bytes.
$ head -c 32 /dev/hwrng | hexdump -C
00000000  02 28 85 b3 47 40 f2 ee  00 00 00 00 00 00 00 00  |.(..G@..........|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000020

After, the result will be similar to the following:
$ head -c 32 /dev/hwrng | hexdump -C
00000000  5a fc 3f 13 14 68 fe 06  68 0a bd 04 83 6e 09 69  |Z.?..h..h....n.i|
00000010  75 ff cf 87 10 84 3b c9  c1 df ae eb 45 53 4c c3  |u.....;.....ESL.|
00000020

Fixes: da001fb651b0 ("crypto: atmel-i2c - add support for SHA204A random number generator")
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-sha204a.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index dbb39ed0cea1..5699bb532325 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -48,8 +48,8 @@ static int atmel_sha204a_rng_read_nonblocking(struct hwrng *rng, void *data,
 
 	if (rng->priv) {
 		work_data = (struct atmel_i2c_work_data *)rng->priv;
-		max = min(sizeof(work_data->cmd.data), max);
-		memcpy(data, &work_data->cmd.data, max);
+		max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+		memcpy(data, &work_data->cmd.data[RSP_DATA_IDX], max);
 		rng->priv = 0;
 	} else {
 		work_data = kmalloc_obj(*work_data, GFP_ATOMIC);
@@ -87,8 +87,8 @@ static int atmel_sha204a_rng_read(struct hwrng *rng, void *data, size_t max,
 	if (ret)
 		return ret;
 
-	max = min(sizeof(cmd.data), max);
-	memcpy(data, cmd.data, max);
+	max = min(RANDOM_RSP_SIZE - CMD_OVERHEAD_SIZE, max);
+	memcpy(data, &cmd.data[RSP_DATA_IDX], max);
 
 	return max;
 }
-- 
2.53.0

