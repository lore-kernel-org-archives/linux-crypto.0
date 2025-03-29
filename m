Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7254073477;
	Sat, 29 Mar 2025 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743271323; cv=none; b=CKQGNkunYx2GpIVv8xY5qa8a2BRvmYo8wcb64tVDL4ScIxiy1C+PQI/PMfvHuB73qIExpHtZ8qa0FEXK1yGlaoFYqSUlVuZmqXDZ+YT66pVgzMTajwqhBdnSbSP5wzyF4ElLlSH/soEjv2y2ULD1AlLsIFgLijDbp2Ijvc15QBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743271323; c=relaxed/simple;
	bh=f1Wm717vdHLW7sXfY/IqnfflabVOZp5cdMkquU4WcMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GoJrMgzLUeZDlSf+qVZQEYBeQRUB38Gi9vVZQD5EIF4qvCen+Nmf+Hm/b2juf3peZ7IEdie6hy0V8urs6EvjQQViSB1HEyq742P9Laix1Y28RI+SY8HEyJzV4HTWrdD89o69/0D1tsqAs7URt+j2WqnpikAQcsZXHhBeAnk6Wac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JSRhx6Me; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JSRhx6Me"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43cfb6e9031so29575555e9.0;
        Sat, 29 Mar 2025 11:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743271320; x=1743876120; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+c6l8/en3e1iOe3sQU56Phlf9Czvj3y3xt6gawWr3wA=;
        b=JSRhx6MedsqPI3Gxi1ip7myTNRK8Ii5LhhraJ7Rkvz+CyVCumk6ruNkbuk8VtTH3Cd
         IFRYh6RXkHl0DkkCsJ8FLAn8WPo/OLLDbjVbsqNom22GUungIPAFf/Vvw4hbYppL4WQN
         wZvaGeliMBILAZMfJ8+n3bp8d1y6R8nMz/+inkNiG7FL1y1e69tVwxT8gVdFZL0TkqYN
         2jLNYD7WTyEVhyzHCPBmyIrMaUEmiAaxb/lG1Walob1JXQPl2sLZgtLm4KkHkDCAG56t
         Y33yuKuxYMWi0RzrcEgzhGNxqACbgn0KKQJoPEmdEfbqrCOeW5mYkl6of3AstIQb341g
         lCog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743271320; x=1743876120;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+c6l8/en3e1iOe3sQU56Phlf9Czvj3y3xt6gawWr3wA=;
        b=kCIJMIL5nUmMRXwJC7MmouKR+U8zlTpUU6GIrTE0Q7vSWkaidpGZkG9lHwfgEem+q1
         TgTUWfDdIIB/0tsZxGEtThGDoNRbT9qTC8u+RZhSm11L1PPmIG+vFOc/7UAZ4zeS25Dl
         cMCTBoMmkmC+Llbmr1N0nzTzGqwI5RHNJRToIDmfqTnSBnrTt6Tl1Kw4pinUYc/W0dQa
         8RCUxCM1MqGswKZxH92uVLfcx8ohy6E1TJpeRXifja4eWTP9qLY/GxGe+gT+1b0Su5oa
         CHagSNMVWcv7nkjJ1EMMyxCP5sMWQVK5vUfqHS1ke2y07qRq+8WhLZusPlTRZvNK4y2x
         ggLg==
X-Gm-Message-State: AOJu0Yw4io/lTis777hJPfTw4kHqTqUv7yPF6mV/wRLU1zJvCShPQ0/A
	EPH1+p5Pb4hXoQLQRmvWJfXAejCXlkfqsLezYnDp+hPeSk2YWz8X5kAswg==
X-Gm-Gg: ASbGncsn8r3sMIDoEmYRSaj4/NZPg1Hkt5CV40zwsKhBy+C8E+SBjoezYoH7nY5eHyv
	eizKroMc4rYFX9xeA49t3GVWbe0m/93NdzaUccQaNgz6Z06xzcGhUCBt15XrW1ergw0Myf2wp89
	ie/z6IYXXAXLYpi+V++ZY75ePm4av/pvfU8G0/SGjv8tLFC9W9C6dAwZTyn0SwCFInle0ek6jx4
	sKgMJzh414EWPDGM/GpGao1bjYjph705cFn1DXu+cws1vyhT+cy7YzvbXGxo/ewMQlQB2u29ewx
	oy26bMI6A14d159l5lLnFKRstJJKsiI15ukmavxL8Ckm3RIRKfEd2WnC5vkuH1PuVpsq9Yah
X-Google-Smtp-Source: AGHT+IHFhzxqMYT2rcFVec7BdBAxrFYql/4UfC6v8E1BPxuxzFfvi+igj6nfOntdF+6oFd76u9pv4g==
X-Received: by 2002:a05:600c:16c4:b0:43d:300f:fa4a with SMTP id 5b1f17b1804b1-43ddccbfe45mr24227055e9.12.1743271319347;
        Sat, 29 Mar 2025 11:01:59 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d8ff02f84sm67703535e9.25.2025.03.29.11.01.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Mar 2025 11:01:59 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 2/2] crypto: omap-sham - use dev_groups to register attribute groups
Date: Sat, 29 Mar 2025 20:01:22 +0200
Message-ID: <20250329180122.3668989-2-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250329180122.3668989-1-ovidiu.panait.oss@gmail.com>
References: <20250329180122.3668989-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of manually adding attribute groups, set dev_groups pointer to
have the driver core do it.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 drivers/crypto/omap-sham.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 7021481bf027..56f192cb976d 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2039,10 +2039,7 @@ static struct attribute *omap_sham_attrs[] = {
 	&dev_attr_fallback.attr,
 	NULL,
 };
-
-static const struct attribute_group omap_sham_attr_group = {
-	.attrs = omap_sham_attrs,
-};
+ATTRIBUTE_GROUPS(omap_sham);
 
 static int omap_sham_probe(struct platform_device *pdev)
 {
@@ -2158,12 +2155,6 @@ static int omap_sham_probe(struct platform_device *pdev)
 		}
 	}
 
-	err = sysfs_create_group(&dev->kobj, &omap_sham_attr_group);
-	if (err) {
-		dev_err(dev, "could not create sysfs device attrs\n");
-		goto err_algs;
-	}
-
 	return 0;
 
 err_algs:
@@ -2210,8 +2201,6 @@ static void omap_sham_remove(struct platform_device *pdev)
 
 	if (!dd->polling_mode)
 		dma_release_channel(dd->dma_lch);
-
-	sysfs_remove_group(&dd->dev->kobj, &omap_sham_attr_group);
 }
 
 static struct platform_driver omap_sham_driver = {
@@ -2220,6 +2209,7 @@ static struct platform_driver omap_sham_driver = {
 	.driver	= {
 		.name	= "omap-sham",
 		.of_match_table	= omap_sham_of_match,
+		.dev_groups = omap_sham_groups,
 	},
 };
 
-- 
2.48.1

