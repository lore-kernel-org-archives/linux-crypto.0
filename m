Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB952202637
	for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 16:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729268670; cv=none; b=IRN/zalyyBUO0yw/DcbH8x3+sI0iBHUUTFveD0ajgHslnbpnHIS4yHzovn8lE0h/W9wN8+uWFBWIgDv3045qTyUihPR4hApmgfDu6BEAK1UNmgeje7G88cXL/KV4orC949XBEak9nUuwcH6u4ati1J+84wGpMOBIE9OBFqrEnN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729268670; c=relaxed/simple;
	bh=01OmuGFUNQmRAxj7LtspDTDEt788Pg4nhvfFhahXLso=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qv4IlbZ14ZGQIAfEjzSgWVnJrYGz/L4E/mQ1tFRQRvHXHxY4mF1zJFhyCMhpQk/KreHOTAWImIwxNBR9+hsDiI6o6N1AAStKgECIUdr7oZym2hoi8XbexYqYayoGS6EbYb/9ot3eGa8c5ZH036GnrfQugYrAgXtKnRbdJAx8fpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=everestkc.com.np; spf=pass smtp.mailfrom=everestkc.com.np; dkim=pass (2048-bit key) header.d=everestkc-com-np.20230601.gappssmtp.com header.i=@everestkc-com-np.20230601.gappssmtp.com header.b=gSNcxDbK; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=everestkc.com.np
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=everestkc.com.np
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=everestkc-com-np.20230601.gappssmtp.com header.i=@everestkc-com-np.20230601.gappssmtp.com header.b="gSNcxDbK"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-430ee5c9570so29695885e9.3
        for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2024 09:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=everestkc-com-np.20230601.gappssmtp.com; s=20230601; t=1729268665; x=1729873465; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=l04dyyVzM4ASaoUOb4EeBqz615dHFIixDrN8t8rAv3s=;
        b=gSNcxDbKwJOItjXw8KSFGWMcW5o6FPTWaa176lqFAtfHnfbCqqSoLWOCLIopXlfBpL
         MqtIYAcVKFnqv46ZewjKaQGSP3N4odSVkTWf0XqwQFsFxDplFy2TW0Usmxuu0CHYSmHf
         CnxjEMUuUdMY/j7INOLZVuIoor2aXY0X1/TTSuBeZOqysr5yn2+5BUVR25Yme2Sper7s
         quEBQZ2USCuONwvXTcTJvI2FoeBBd1xh9BrwYQbDL0YfccYDNlUNUD+B1woI5oNTHsFC
         2lL2J72TvuuBsMNItk3LHPhnQVR7pSt7j60Elsmg7MPobHtWyhBPyNJlD/Qdt309Rg2W
         +PwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729268665; x=1729873465;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l04dyyVzM4ASaoUOb4EeBqz615dHFIixDrN8t8rAv3s=;
        b=hnuV/83ctDxLgSq9b4b2RMbQxq0AYh3yt1hmFZqgrbyDbnAXnvFA8l7uJ17oIhzRdC
         vk/y2+XqJ2kbhCMNSD1vzYzR/RWlCR3WVLbpmBSRH0buecje+y3eRIlymd98ljaHQM3g
         dkfFUAfeQ/xzKaNW11JgtcdFwLaNR685PJWZyQgxLsOrUgOb/ah7c3P4GYrIB8vbl410
         SUQWnNvI3sYBxyVLPoYjzexH5p10dSJPCIHkuVs/IkWKRO+UfElgTDrKSbtRx8h8vZVV
         KHmZMfdGp3Wxgi2xHpcD41R5P0TdgK/GgrnxDefsm/al9XEakxxI8XGZzPhtP+//+Cnb
         77FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjxZswjlcqwBfU68eCq7B5Zimzo/cfzMuZUoo3tQ7S+rYP3EaYNj6UBZh3FZ1YBGffz6LzPKnXYjaF14g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUNoDKCCZIqvjxDh7ZveiQGZbv5AH9XZhYPq1htL8V4y1H3CoI
	uiNaygCn/XVXvXqGPLd9uxbvuDF5bXzP+8jVLgcakktXkPe6H9HIBYIUazhn3mQ=
X-Google-Smtp-Source: AGHT+IGhdQwCy7dGozKjCuyT8kKsDdG3f8/KAU4iCzV3UU05p9ozWe5ZuVHalGWiqzrKF3YocjdHLw==
X-Received: by 2002:a05:600c:4e12:b0:431:4a5a:f08f with SMTP id 5b1f17b1804b1-4316161ee27mr24720365e9.4.1729268664785;
        Fri, 18 Oct 2024 09:24:24 -0700 (PDT)
Received: from localhost.localdomain ([195.88.86.203])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-431606c649csm31401105e9.33.2024.10.18.09.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2024 09:24:24 -0700 (PDT)
From: "Everest K.C." <everestkc@everestkc.com.np>
To: gcherian@marvell.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net
Cc: "Everest K.C." <everestkc@everestkc.com.np>,
	skhan@linuxfoundation.org,
	linux-crypto@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: cavium - Fix the if condition to exit loop after timeout
Date: Fri, 18 Oct 2024 10:23:10 -0600
Message-ID: <20241018162311.4770-1-everestkc@everestkc.com.np>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The while loop breaks in the first run because of incorrect
if condition. It also causes the statements after the if to
appear dead.
Fix this by changing the condition from if(timeout--) to
if(!timeout--).

This bug was reported by Coverity Scan.
Report:
CID 1600859: (#1 of 1): Logically dead code (DEADCODE)
dead_error_line: Execution cannot reach this statement: udelay(30UL);

Fixes: 9e2c7d99941d ("crypto: cavium - Add Support for Octeon-tx CPT Engine")
Signed-off-by: Everest K.C. <everestkc@everestkc.com.np>
---
 drivers/crypto/cavium/cpt/cptpf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptpf_main.c b/drivers/crypto/cavium/cpt/cptpf_main.c
index 6872ac344001..ec17beee24c0 100644
--- a/drivers/crypto/cavium/cpt/cptpf_main.c
+++ b/drivers/crypto/cavium/cpt/cptpf_main.c
@@ -44,7 +44,7 @@ static void cpt_disable_cores(struct cpt_device *cpt, u64 coremask,
 		dev_err(dev, "Cores still busy %llx", coremask);
 		grp = cpt_read_csr64(cpt->reg_base,
 				     CPTX_PF_EXEC_BUSY(0));
-		if (timeout--)
+		if (!timeout--)
 			break;
 
 		udelay(CSR_DELAY);
@@ -394,7 +394,7 @@ static void cpt_disable_all_cores(struct cpt_device *cpt)
 		dev_err(dev, "Cores still busy");
 		grp = cpt_read_csr64(cpt->reg_base,
 				     CPTX_PF_EXEC_BUSY(0));
-		if (timeout--)
+		if (!timeout--)
 			break;
 
 		udelay(CSR_DELAY);
-- 
2.43.0

