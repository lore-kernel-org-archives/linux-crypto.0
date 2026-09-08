Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0E2355F22
	for <linux-crypto@vger.kernel.org>; Tue,  8 Sep 2026 16:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788883301; cv=none; b=jszLekUHBS5MQqOIt+fMb/kY5a7knlLU13SKxsMQV7iVOnmF82J+Ha7oGBuv/9slIUTeLlqgZhnE2817TCuQV9kyKzXYMGoFwx7eR7F2C4v2WK1JHvf5GmHwIOfbg1dhdaxXUZbifGQ9nmY7wBkoiZc1YVYnotYAuWKBtw8HZxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788883301; c=relaxed/simple;
	bh=fSnUC/Uevm5Vbrih7n+FM4vcyD9bqX8J6oiWP1kp/DY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MQmYkT+arp/1J3V00qpEOBOGLNLumFmk9zo8jyhm7SQg8MP7nisq5299rP8qgxWGWsvm/jQI2yKH76Exb57g2B4QirykdZapbTHRSuISdeHdrI9O33950TDQT3kOZM9PwFa41W9z9ltbuoIfz80YyqK8w6hUOwu8qRys8m/Lznc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eNV+3LFb; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eNV+3LFb"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-4a451915d8aso4411784b6e.2
        for <linux-crypto@vger.kernel.org>; Tue, 08 Sep 2026 09:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788883298; x=1789488098; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1HavqBuvOK9+7hkcuCpVB9Cv/dvjoerCr3RPaWhvFOI=;
        b=eNV+3LFb0X8EySGhpt/G4eUKLZBtSxeBr0h2RzFyu8qL1fHSnhBwr6u/Gdrky1Ed15
         OCrGbQ8L37t4w4Qs5LoAEJyB3Gcti0jnLzTxxIHWzyFBwVQ8Eea/mLEpKgCeCAORuB1s
         8ytcmAp0iXmH2Q7HjJ7wnMlWplnKWslbMGq4Xhqu3Qy96TNEYiAXThejrhsZrTRBzYSp
         5N4dSm7ORo3AGLkh2lmem5UF3m3fMCQ+EPaIHKxb3XfVcuK3fAgPiFQDh47YxYpJzmNm
         YdmUYZl/6Cu9+SngJizmQTXBT/1UlCsBU6qBSn4wfLRxeH/aaim72RIEI9Pd/bI0agAG
         rnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883298; x=1789488098;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1HavqBuvOK9+7hkcuCpVB9Cv/dvjoerCr3RPaWhvFOI=;
        b=GGrqnuB3B8mu8oLr1rY8WsAT4S8dEvetkui5dKI/Xn7gPBDtghPG2NFbV/dsbCvGy2
         ebMmI2GqvKg8y5li4WBv/ejOdvjpq/wQ3FPouU6vONyVY6J5VRKPhi8lqR5Y+ddslvvt
         tQdIm+t1pr/bdf9IatxWs8GgYMcoOV6m71O+QlDgs12LFf8IXGyIotmgV8IedOMOZx3F
         TcJP7wcYpZwYY/U3BRlIbZCUZltoyUwvHEQIMWH8dXwj6K0Yn39Lc51msbJpRvp4Zz4z
         PFoSO3IQpVURbQz4EQtYzFyJmTwxdYNhD1ojiBugePKDxKSe4uvFRjvGlOQFEiQBU9ki
         gT6A==
X-Forwarded-Encrypted: i=1; AKwUvByEHr2B0DOJ4nivR6+CUQCPns5UV+K/BtQVofaTgWnHpyomDamqIcookIs94Iv8oujWRjRww30Rqr3uCQk=@vger.kernel.org
X-Gm-Message-State: AFuF++nHD1Ts8XlW5GsoNnUcr04i+mdQhlLmySGlIX4sxL2jOGkxEXtT
	eawukF9D7PGP+9bNnv6oCE0zJdA5Nh4T3E0rV7RKXGvI/wkxxUnb7tk4kPX/z2W4
X-Gm-Gg: AYBFou37uMWnwMhLm3si0wUY5ZN6G6VWGY6nV9lCv4ERXHtIlL9ttgDwaSYCaFCX+B5
	CQAmLQcbjwYkeX6yejIglQNW2+3QzwepUxX0JY1BR/1+a+Plp/yG+U1BAXtliaumAl+JWBtzVFb
	9MVyCa5Q19LEsLbGGqqvMYRul6rzyVmItejEfzWC5xWrnQvovSfPt9frKxzdQJOZy4UH2tZnfoG
	ZJVPIU2IKsII8T7VERy4meHnLNgy7FheEdFYfOrI0MpYNGoIZH4nCC2WgX1afKSuMFj8VixqDZJ
	e2NC+Ts1lVlnoBWX1S8wqxlEUuAsvwlmt43ZFsGzl8Gp0sgZrc5WPwBVSN9P8ewGV2YiYspQOno
	0UbPCXCnEvYIirqPZST8lSOHSqlIvZ9aZteS2Bxr6NzIYMKHfBVKKCVOpJFg+WIJWGi803NCpyG
	EtES6o/tw50INM4Yh/Z0dH6Z5cI+AtR9o8PEezjNLCdkT2B1CNFPHNKHkRukRYQhfPdRgys+FeX
	fBD41cT
X-Received: by 2002:a05:6820:6ac3:b0:6b0:4170:59ad with SMTP id 006d021491bc7-6b6fc7d1f64mr19096852eaf.24.1788883295449;
        Tue, 08 Sep 2026 09:01:35 -0700 (PDT)
Received: from kernel ([45.251.35.112])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339a534df1sm43084171eec.7.2026.09.08.09.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 09:01:34 -0700 (PDT)
From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
To: herbert@gondor.apana.org.au,
	clabbe@baylibre.com,
	davem@davemloft.net
Cc: skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	jkoolstra@xs4all.nl,
	linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: amlogic: Fix IRQ handler return value and fallthrough logic
Date: Tue,  8 Sep 2026 21:31:20 +0530
Message-ID: <20260908160120.4805-1-raizudeen.kerneldev@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In irqreturn_t_meson_irq_handler(), when an interrupt matches a flow
but the status register is empty, the driver prints an error but
doesn't return. It falls through the loop and incorrectly prints an
`unknown irq` message.

Fix this by returning IRQ_HANDLED immediately after the error print.

Additionally, the handler returns IRQ_HANDLED for genuinely unknown
interrupts. This masks false interrupts and prevents the kernel from
detecting interrupts. Return IRQ_NONE instead for unhandled
interrupts.

Cc: stable@vger.kernel.org
Fixes: 48fe583fe5417 ("crypto: amlogic - Add crypto accelerator for amlogic GXL")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
---
 drivers/crypto/amlogic/amlogic-gxl-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-core.c b/drivers/crypto/amlogic/amlogic-gxl-core.c
index 6cb33949915f..302b398405e2 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-core.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-core.c
@@ -38,11 +38,12 @@ static irqreturn_t meson_irq_handler(int irq, void *data)
 				return IRQ_HANDLED;
 			}
 			dev_err(mc->dev, "%s %d Got irq for flow %d but ctrl is empty\n", __func__, irq, flow);
+			return IRQ_HANDLED; 
 		}
 	}
 
 	dev_err(mc->dev, "%s %d from unknown irq\n", __func__, irq);
-	return IRQ_HANDLED;
+	return IRQ_NONE;
 }
 
 static struct meson_alg_template mc_algs[] = {
-- 
2.53.0

