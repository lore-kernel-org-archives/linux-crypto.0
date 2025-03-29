Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AF11BF58;
	Sat, 29 Mar 2025 18:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743271322; cv=none; b=SQXFUZZ4hqqtAB5PIIP+x6kbNNfjAnOJeAdznSqG797jOCLeTQLZo4pTW5Ic/fXmUTC3mx6l71htccoC0AVUfIBnW7KWsr2jGEtfO32qAHmRfNoxbd58X+thYHSLKgFZ2uj4+r7b5GLm1pCQ2oLUl5J/48q78GGa4mE2SP24UJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743271322; c=relaxed/simple;
	bh=3G68McS59Jm0PsvqVooccHj7w7LmHxfWFaHneBdvv8c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PM1RgY6AaWFRpAFkpPVgMFn7CNHNRnf/je0DIoIs0ku4IDuf7zprFQaUcI+28lRg+BeXyHx4/TMONX6RvXE+0P415mumUttHe0cRNnIzBR1ERSbHVWnbQD0OzgwW8dWAsE7xE6qgrc4NvvDSz6mq5OmxcsCTuOL3rVS1LiJY+qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q5l3+Dpr; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q5l3+Dpr"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cf0d787eeso30031015e9.3;
        Sat, 29 Mar 2025 11:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743271319; x=1743876119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1bdkWJBlp465zoP0rSSd01uwRG5DkrMz/7pJl4WgitE=;
        b=Q5l3+DprK/WNI1pbk5BC0ksNoMqqi+XWdG2N392JasTM2sBU4jkXRMeJ4gyh99do8A
         rm9WU+x12NfRaTv9Wxomh34hQ/goKwRKo0BGdQicaOXyEl19kbUUpADsHl7ibJBogVJs
         QDlkJULpfBsu4QI1DBVRNwYuH5dr2b9uGNECs15lVg7J00m3mCKE6cKxwbaSpoXZJkhr
         4BBEFxqgs77F1yP5R0p94GtoP9TCFzSW5lQlXPkXVZaabnyaKjz2Vuz37miatHytj+cT
         FVOHz9pxt5XqRbvPos6msDN1j8T5R+355xuHOVGSJFSP2/Jl6RBXtRmAJdHkRd30JuyZ
         AMHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743271319; x=1743876119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1bdkWJBlp465zoP0rSSd01uwRG5DkrMz/7pJl4WgitE=;
        b=Dq1CflthXiPwbcFYy9tmXovYyZvUJhQAAW84qjDythzyEgYIhI1pdUV6ISH3dw+j0e
         eowFVGrVihBUuTh9c47NA7rs0r4rrb0HLHT8mtGdNdr6pBu0zFvOvMwrccivzR1PnNqL
         o0anLvQBYzrY9hPy7P4uqEIyXEzQGUvVLFN+oxNId05ZkuNzn9yetz8D+dc/JPlkIKD+
         XwvfREzvdkwh/T9DpFrJ/VeCbp4PDgaxvmb/zi/9VYVAeO/6A4vwUClFABCUFDxMvd29
         3mVTETtjsoFkTU0DM5zdr+GEdvgvu9NpcUDn4A20IvO9w8ZD7mxWP5Rv/cn8l+aOvRT+
         pgfg==
X-Gm-Message-State: AOJu0YxOrXVMYpKdU6nG0vqzMrbSoQwIL0I1Ym8S3wVZZQVAfILyxkOc
	o7J9A2JCZbcIYBkDZr162G5VvbTjHLmPo0bWN52F+doMWFbGbE++vvltLQ==
X-Gm-Gg: ASbGncv8uvg0MyUe84Wuuyvgcu7T3Lct58EMi2/EK0yAXg1Lx2aLceb5tTQyEqj5+at
	rAneg8T4/ga9vvUCFVNbA85q7OmFPzvFfnGNrvZAPUQ5Btvu6tU9S+9/blBjieh5tWW93Tjhf1e
	HVCKPOD8xb3RRK8g9jfbdk+6Mly9+uNIj/7ftoMB7wAar4PxtD9mzwkiK2zgivI9IZsdt2pvZN0
	4qvy3b0RNoPT+NIPqdLPOEj9QPEBgjoRj2X4l0LQNPMy0rsU60WTwanXCoonaiEpFVOF6r84R7E
	3ms+LWTvSPq1WasY/xcTpYivvkBmvaFY2B9dra8Gxhr8Pet1MeDkT0Ky6fh3DwxENtccTt2e
X-Google-Smtp-Source: AGHT+IFEXxTAW8ZpL/txA5T30KwwRt8KbiQuZrfEOpgxJQJUBBcTl2zUNYEar3sLZP3VqaI2LGfjmw==
X-Received: by 2002:a05:600c:4fd1:b0:43c:f6b0:e807 with SMTP id 5b1f17b1804b1-43db8527142mr32549135e9.31.1743271318483;
        Sat, 29 Mar 2025 11:01:58 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d8ff02f84sm67703535e9.25.2025.03.29.11.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Mar 2025 11:01:58 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 1/2] crypto: omap-aes - use dev_groups to register attribute groups
Date: Sat, 29 Mar 2025 20:01:21 +0200
Message-ID: <20250329180122.3668989-1-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
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
 drivers/crypto/omap-aes.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 551dd32a8db0..1ecf5f6ac04e 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -1086,10 +1086,7 @@ static struct attribute *omap_aes_attrs[] = {
 	&dev_attr_fallback.attr,
 	NULL,
 };
-
-static const struct attribute_group omap_aes_attr_group = {
-	.attrs = omap_aes_attrs,
-};
+ATTRIBUTE_GROUPS(omap_aes);
 
 static int omap_aes_probe(struct platform_device *pdev)
 {
@@ -1215,12 +1212,6 @@ static int omap_aes_probe(struct platform_device *pdev)
 		}
 	}
 
-	err = sysfs_create_group(&dev->kobj, &omap_aes_attr_group);
-	if (err) {
-		dev_err(dev, "could not create sysfs device attrs\n");
-		goto err_aead_algs;
-	}
-
 	return 0;
 err_aead_algs:
 	for (i = dd->pdata->aead_algs_info->registered - 1; i >= 0; i--) {
@@ -1277,8 +1268,6 @@ static void omap_aes_remove(struct platform_device *pdev)
 	tasklet_kill(&dd->done_task);
 	omap_aes_dma_cleanup(dd);
 	pm_runtime_disable(dd->dev);
-
-	sysfs_remove_group(&dd->dev->kobj, &omap_aes_attr_group);
 }
 
 #ifdef CONFIG_PM_SLEEP
@@ -1304,6 +1293,7 @@ static struct platform_driver omap_aes_driver = {
 		.name	= "omap-aes",
 		.pm	= &omap_aes_pm_ops,
 		.of_match_table	= omap_aes_of_match,
+		.dev_groups = omap_aes_groups,
 	},
 };
 
-- 
2.48.1

