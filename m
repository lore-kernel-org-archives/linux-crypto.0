Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F214E8E14
	for <linux-crypto@vger.kernel.org>; Thu,  3 Sep 2026 15:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788450160; cv=none; b=ux/4XiDEYRAkyBvmT7Iq+oLo6uxmJablHEeqdAvQwVpxfUKmBUyQXrumLkOzuKILmN6vgCaIcvnSqEROZErPQWI2izHnP8bfLdWwMtQ8eS/1S5qlIAaLnltbar/xpQNlMnk1z5n+ck0Qu+bzXJ9aLmsCvcbtG+b8hr1rbq2Irv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788450160; c=relaxed/simple;
	bh=Krkxe12J+zKExjm+ys4pq56wu8sANIl9Xl6198K8bxs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PF0CtOm47kytTxmUnSFurf+RMzGWu3saK4wMebMrL3zT0Ido/hYIKFIYeVDfBl9LZcSbTFPOcVGyIPuop+Suh+71aVVoP5rhw/Az0EhGBPWKIFnzPzTDrAMiN04bgNtEseoih1mgfIzsIIls1iNpsMLcYW3jEv3PRdQdOBFYoCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk; spf=pass smtp.mailfrom=thegoodpenguin.co.uk; dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b=wyQ6JHWa; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=thegoodpenguin.co.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=thegoodpenguin-co-uk.20251104.gappssmtp.com header.i=@thegoodpenguin-co-uk.20251104.gappssmtp.com header.b="wyQ6JHWa"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-39647aa9d52so1426186a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 03 Sep 2026 08:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=thegoodpenguin-co-uk.20251104.gappssmtp.com; s=20251104; t=1788450157; x=1789054957; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vrQF0RfWVSyrposIdYBuKXDlowmFEDCZ8WICH5uaiDM=;
        b=wyQ6JHWahQCr/IsIoFLyhycDxqzhtZVJL6sddGKAPpsVMcngER55T9sjuS41gxvlUe
         9vJp/21lgttDY/+j7Jxez2+v9zn2lmpzFZp8DBaJktKE/5PkmFRg7EIlzkuLMThgZpHH
         O8FECGN/BU7g5MouQRWM+5dS0irlqgQDtEgIJN7CKpr++NsP0P31eLAbIg2FS/4Ow5sz
         YkPjgZhx5ODBbMFvpoOSs020w6npNPQ55mq66buPZ7OpEdlCmx7ncRg4lTu4thIA/P+j
         mDjqQQyAE93RMPAnpKLWClob3mnRQaBKXyzgFrRqReYY1yuE/xgFOvLCnQ+vAaG2RhMj
         ll8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788450157; x=1789054957;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vrQF0RfWVSyrposIdYBuKXDlowmFEDCZ8WICH5uaiDM=;
        b=dxYAuTNCTJB79O+CjPLlr9/sVCRcG3906qAUW1NT9cs2Lk513LoDjwP99dfgyxA2x3
         k6+T5RON4gj3n18GpMawNSDIdZWlow0tVyHOUNsufHONlv51tOQZj0sCxl41P2WCuK8Y
         3W6RuCkliF5b4SH/+DTHDCwNcz/JHdAS4QP5tuWxT5+xOcjoSnSUQ9lPhM/D8IZbcNxF
         ytyzBboMRN22tWNBCxenlFWtmtmHUjvLORUZxBtg1X4O/GFd8l0h3P8svnbaRmaVeL3Z
         y4Zc/2UUo7ZDT1uGZV0GiznH66d8nABUWuygsDuLK6SFT/eUgb8pl3Xz+tX3z2J/aLs7
         +tRA==
X-Gm-Message-State: AFuF++lRE0VlPzkb1DdFic+Y9bKqyFomleCzNuwhO151XjweyKvv14/t
	8U6fHRY2HSq1Irl2QUlUl+Oz//Ie1+ysvonYQIuNzjFvHtdui2wvPnFCHvNhCxR/GnYs7ic5+QB
	IOJQ94Xs=
X-Gm-Gg: AYBFou16qJNNMFYIfg7Je0tfNE2wPxX/FS04d+xuMCdz50btm+oBkuo53h57/htC5LK
	niYHDX3EwExLVRrhhlkQ2EiO7OJWjw/fgklvSiBkGw+BX94gmtGlxo0KZ/e6laKRN6oLtN7bL8r
	bD/FPG0D8gg/WtQbK0yxKHK82cl1VamryTCv3UdvwgjHG8hk4Jk8ZNWMqBtp0f2lv/NZXK0VkCX
	rWZqwpgZQq+fVYGGLD/3otMGcIePfI0/KatpcZzMJ7HCwCBfKm1LO86Q+YzkuNo6l26Q/upzwFB
	zKzMTiMIoIPtO6zlse9wfxMcol3O232rp5S6jub9Dg6uRxEvwHiAGgbHcRgEN22WDiEZ9BqU1js
	9vfQL23WqepzI13figA69yuodHPWAIEvK7LAj8228ftv/7DcF0biF41rL+2IFk+IqaQgzV3C/1M
	/A7HmlUOrUhYo1TdxaMohP0CoOX6ErYU281K5nUq6kLwjDq9FhnxmPl4aUzy7yrJeIyYK9MFeD+
	6L5H/4xXE8d+F9m
X-Received: by 2002:a17:90b:518c:b0:38f:cfe2:fd3a with SMTP id 98e67ed59e1d1-39b0865357bmr7566591a91.15.1788450156766;
        Thu, 03 Sep 2026 08:42:36 -0700 (PDT)
Received: from [10.42.0.1] ([2a00:23c7:1d1a:9c01:521a:d95c:2f1e:64be])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14324356931sm522926c88.4.2026.09.03.08.42.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 08:42:36 -0700 (PDT)
From: "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
Date: Thu, 03 Sep 2026 16:42:17 +0100
Subject: [PATCH 2/2] crypto: hisilicon/sec: use named initializers for
 acpi_device_id
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-acpi-crypto-v1-2-253cc6fd9836@thegoodpenguin.co.uk>
References: <20260903-acpi-crypto-v1-0-253cc6fd9836@thegoodpenguin.co.uk>
In-Reply-To: <20260903-acpi-crypto-v1-0-253cc6fd9836@thegoodpenguin.co.uk>
To: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Pawel Zalewski (The Capable Hub)" <pzalewski@thegoodpenguin.co.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788450148; l=979;
 i=pzalewski@thegoodpenguin.co.uk; s=20260430; h=from:subject:message-id;
 bh=Krkxe12J+zKExjm+ys4pq56wu8sANIl9Xl6198K8bxs=;
 b=LMdxkZ9u2EsjjrwjJsmPaw1+YmF8oPJQ+Rs1S9Yq0E9Z+NHj/qHAxOcg1F42wFjFniWD3INu5
 tySBfldbaTBDSEASyy7uVONgqNAmblw47lNyLqTnfHY1ZSfld37CvYA
X-Developer-Key: i=pzalewski@thegoodpenguin.co.uk; a=ed25519;
 pk=vHq4n9IonORH2GTzLv8r6CWAFHzgfBuNkQPXA8NSly0=

Use a designated initializer for the acpi_device_id fields
which makes the code more readable and consistent with how
lists are initialized in the rest of the kernel code base.
Also drop explicitly setting fields to 0 where it is redundant.

Signed-off-by: Pawel Zalewski (The Capable Hub) <pzalewski@thegoodpenguin.co.uk>
---
 drivers/crypto/hisilicon/sec/sec_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_drv.c b/drivers/crypto/hisilicon/sec/sec_drv.c
index 2514a5e1f9b4..7d3fb8d67203 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.c
+++ b/drivers/crypto/hisilicon/sec/sec_drv.c
@@ -1285,7 +1285,7 @@ static const __maybe_unused struct of_device_id sec_match[] = {
 MODULE_DEVICE_TABLE(of, sec_match);
 
 static const __maybe_unused struct acpi_device_id sec_acpi_match[] = {
-	{ "HISI02C1", 0 },
+	{ .id = "HISI02C1" },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, sec_acpi_match);

-- 
2.43.0

