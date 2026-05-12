Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17723A7F6D
	for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 22:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778625861; cv=none; b=iVFOLzZhhyPEKxowWewrK104l+aN2laJoiJBMgl1h/c6kyR7JSc65aZTPApRmVWujDJCvt0XkIKnGMIGGhFEGC7IwhAyNAeDs2517TUde2wJy5v2STgQYyMsH44986bZT5siaoTugt9P3EysTiIv6bggL2yIRMHSek7Y56xDJRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778625861; c=relaxed/simple;
	bh=pNjGDy2ibmEHOD1uiiJzIxKcFWHcrE+Moas7jjd56Fg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zn9xalF5564QNroHMlmLGbaicTDJTy4OwKrBwvijdrLc6SuU5/XYhZJwmTlqyxn3TvTclvK6uAFvT577ePXRy30HzEb02eOOkqL6wzYDN3ZapR6WYu7LWjDxRrtel5qeu2lzvwtN/nAZ2qcZuzAV5m2vR4uJ8tT3f6Wli13YN3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XyBwroy1; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XyBwroy1"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d7b879691so438218f8f.1
        for <linux-crypto@vger.kernel.org>; Tue, 12 May 2026 15:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778625858; x=1779230658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oiDLQo6LxMnNaRwvgrfh4SktcEegnVe/AK/y3q5hSoE=;
        b=XyBwroy18RlFO9R1DaVpmWNbxkGVID3TD3d7Aq+qfeq48/5+di28qpO19x/0VtdNmV
         ihy7e8xXDWBjLaOj8i4k+VKR6pIt8LxCngfD4zU7hpHYQnX3zbZRquAhpTquAlUcGqy5
         EhVncpy0Jg8ZcpPiwX0+/LTz5uzVI3QbAW+5wR8EVuasG/B4CrUACI771XJfqIHQLVv0
         oMCFl8UqBaLZbL4MRTuEWwcYD3CPKobbs66QdyDfb08C7+Lfbh0jJtIAYk/CjB9SHbb6
         qCwev6QZQV6m6JUxtXOKrLatABdad7hdyQaz6sSfcyi8pXohd9vzF6zCxZTc+NyaHh7+
         MbIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778625858; x=1779230658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oiDLQo6LxMnNaRwvgrfh4SktcEegnVe/AK/y3q5hSoE=;
        b=DQ1g6T6jjf0J1hDZaO/lEengcstQtLGa1erhICkMFgOtnq8Tmx6dsBgD7whZmIJJH3
         IbyQ87zgKf4gseqiAIjOIeYtDwNc8VU1oIML4nhHDkcVhAXQUdbM2Tnt9yzIWD7Kv9e+
         AJHfh5UGDHxQR+Qs6H2ycqNcEAeEQ2WzA7+1HQYOo4+sjrUidUXJ6fXQuSBftPAfaByy
         Vj+PheVFJrWAFXrL5IxOhlhTgGKa858dp44vCKz7DWm/73SwXDFxPtPs1JDb2U+TJv/C
         sQrJ1O60Wl86Ltla/Z1LQabbqZMLB9pR8iIvMPN0rTJeYrFxA0Mt7wTM5AvssDmR8DD8
         pbew==
X-Gm-Message-State: AOJu0Yz9QayhZpT2CA3nr4GEo3OulX0JE/d14AuPUOa+NPr01Txzq0Jy
	wFwQ9P/HWdbb6LQ3Kl5YNIv3CYPP08sQkManqO15jVzQ/+NC39sy1HmD
X-Gm-Gg: Acq92OFHBgB+FLJQ2wRLs4HbJZKZ+hsGotrWbdBGVq+stHt+y0lpxnsSqV7JI2pywag
	plqDzJ+uD3Yg33IYqIydhrv7z6nJDelr/zGd8tn7+l9lcp9RrUhPrqjkVEF+iMsPGkP/6s2HWPD
	Ie4UMHxYdm93lkQIXFIaAWLw6N9Y95MDjRGHs1sSiG8K1xdsjxGpd+OJz59+6GULkdWiHacadif
	i07BVrS11xs0tIUVE7Qbpd4es43YgxIS0x5u1dVzYYvkAg6ST0tE4BJPpcyF0R89/L11L1ubfJ4
	cLEFW3uRY2p359oPmuHp7X2vy0kh6Rjz9gzl+0AyYuxtOZi+eN6wNUtXkjjXFF561xFViL7G3QL
	wi+E2ihbmo+z3oy6lP32d3vSWdrVC3meiVXeer0675CWb518o051iNLGUH5czrs0k7fao25udOB
	4Lm7d78TzLIoYKyTUX5AlTgPBhKF594iUJF73lxEKHC63oQKOJcP6C8T5ht74Go3g=
X-Received: by 2002:a05:600c:4595:b0:48a:56d4:7274 with SMTP id 5b1f17b1804b1-48fc9a1c617mr4696215e9.3.1778625858129;
        Tue, 12 May 2026 15:44:18 -0700 (PDT)
Received: from menon.v.cablecom.net (84-74-0-139.dclient.hispeed.ch. [84.74.0.139])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fce385ea5sm3194025e9.14.2026.05.12.15.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 15:44:17 -0700 (PDT)
From: Lothar Rubusch <l.rubusch@gmail.com>
To: thorsten.blum@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	nicolas.ferre@microchip.com,
	alexandre.belloni@bootlin.com,
	claudiu.beznea@tuxon.dev
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	l.rubusch@gmail.com
Subject: [PATCH 10/12] crypto: atmel - update workqueue flags and add flush on exit
Date: Tue, 12 May 2026 22:43:47 +0000
Message-Id: <20260512224349.64621-11-l.rubusch@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260512224349.64621-1-l.rubusch@gmail.com>
References: <20260512224349.64621-1-l.rubusch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update workqueue initialization to use WQ_MEM_RECLAIM instead of
WQ_PERCPU. WQ_MEM_RECLAIM already provides per-CPU execution
semantics via a bound workqueue while also ensuring forward progress
via a rescue thread.

Add a flush_workqueue() call during module exit to ensure all queued
work is completed before destroying the workqueue.

Signed-off-by: Lothar Rubusch <l.rubusch@gmail.com>
---
 drivers/crypto/atmel-i2c.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/atmel-i2c.c b/drivers/crypto/atmel-i2c.c
index 50b6bce478d2..0ec2d768a763 100644
--- a/drivers/crypto/atmel-i2c.c
+++ b/drivers/crypto/atmel-i2c.c
@@ -626,12 +626,13 @@ EXPORT_SYMBOL(atmel_i2c_probe);
 
 static int __init atmel_i2c_init(void)
 {
-	atmel_wq = alloc_workqueue("atmel_wq", WQ_PERCPU, 0);
+	atmel_wq = alloc_workqueue("atmel_wq", WQ_MEM_RECLAIM, 0);
 	return atmel_wq ? 0 : -ENOMEM;
 }
 
 static void __exit atmel_i2c_exit(void)
 {
+	flush_workqueue(atmel_wq);
 	destroy_workqueue(atmel_wq);
 }
 
-- 
2.53.0

