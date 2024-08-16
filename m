Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7221726AFC
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 07:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723793231; cv=none; b=o8DuP5+e76/erMdKoE6KZeyYLRhm2nKVoFL84ZOPg/KLcoUuolls3WN5qUtUNegQSDRF7WjqyDv95NYbpkz0D5QxlMyWKSHyfz9Zgsu5Q2jfFuDXDtQ9pCy3hfBmpw1CSX4c3dBObYOY6eGBtOCfGY5UV51Qqe/XTG+1r+o8CVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723793231; c=relaxed/simple;
	bh=ycB76cnwmlz6HwU0ZIJ3jiNrpoFUTcORUl9xOpdgyBY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I0N0MrZyAUUuHgjbsElsVXEULSyqLSE5Qa8edy//HeXSgCbE6GiZlPzjVqBgX8WTtd6Snul6xZZ3ZTM7FxIUusALovPb41twSvBPR0j7bYWjRbOJHDw/vCZT8C584/GPtj0dOU2G7QA2Rgv5r++qXvxr4N5jnjwz6OGo9iy+38g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=YWNvU1PH; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="YWNvU1PH"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-201ed196debso15898935ad.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 00:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1723793229; x=1724398029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4vkBuUCzWA9nwoqD9tlt5sayA4LwP9cf9M8hrIll+Hs=;
        b=YWNvU1PH21Ia+wNyRxaOJ5UPnVviYo3zrzOCt/amtlrQaZVYK7w2ys/niTgPEJc+26
         IlnYiBIH/v3iIqYZty9J4+1Ny8vGsB30dCff4h3c/kVLAGOBdeWoeCL/hIMoEGCBOqJi
         VyV2n1lYnJkcOZnvqnHLyxVQNfJrU+pWTL2yc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723793229; x=1724398029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4vkBuUCzWA9nwoqD9tlt5sayA4LwP9cf9M8hrIll+Hs=;
        b=dCkye/W4GJjBgy1lC2elzPudEXeUGMs0s4JY9oYl+euMEaH7PqS54Bq6zJ3rmeXFzl
         f5R6ZZnW4/Ez6wj8B7WBBqQA2fpyBS1hA47/YzAuj0z8Jnlm7n944b73zZVZL+Famp5u
         911LKv7vuiBx6szxkl/dXFdYHo9MB+DHAhiSQNIQW6e3cIb8rHCmu0eEznSpbe6/akj3
         pvBOD0cXfOQDP0QfzDiES4cfJPLLQgBC38WAlRha9oDanIUCH4wuSpY3R4uF/gYNuSCk
         lzATdMJehaJxld2ZWB9NV4dqomfv9BbxA+pqX1+fh4GWIg3j9fVyXO8yj0BTR4OAMjyI
         GkTw==
X-Forwarded-Encrypted: i=1; AJvYcCUOtzQXv0CJsrEZJifSPg10Tdz1ywMLRskeBodmTBXTTVjY3WEgMHplNR+k41nkidUpSgFabOADEh+4KT96KkGdvwwWffljayvPsPcz
X-Gm-Message-State: AOJu0YwaKsrdqsIDvlMbujX/O77Kj2xtJmiryMNUHGGTT9MibpW4xEoB
	0XPnwrCYrghy3eJ9RIJ52tiiKvz6dYPgtb4BBEL4+SroCSvuemOlYjmdSiFKqI8=
X-Google-Smtp-Source: AGHT+IHhK9Sq7Dle51dpsV+FrGoPOz1JVoL9aMQQ1anIPsgOOTFankBtIcpMxeGmmG6TP6vEpvj3Yw==
X-Received: by 2002:a17:902:f9d0:b0:1fd:510a:3096 with SMTP id d9443c01a7336-2020404a73bmr16608435ad.62.1723793229074;
        Fri, 16 Aug 2024 00:27:09 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f038e1e5sm20128675ad.201.2024.08.16.00.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:27:08 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	dan.carpenter@linaro.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH 1/2] Fix counter width checks
Date: Fri, 16 Aug 2024 12:56:49 +0530
Message-Id: <20240816072650.698340-1-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch fixes counter width checks according to the version extension3
register. The counter widths can be 8, 16, 32 and 64 bits as per the
extension3 register.

Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/dwc-spacc/spacc_skcipher.c | 35 ++++++++++++-----------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/dwc-spacc/spacc_skcipher.c b/drivers/crypto/dwc-spacc/spacc_skcipher.c
index 488c03ff6c36..d55bcfe8c3c5 100644
--- a/drivers/crypto/dwc-spacc/spacc_skcipher.c
+++ b/drivers/crypto/dwc-spacc/spacc_skcipher.c
@@ -406,40 +406,42 @@ static int spacc_cipher_process(struct skcipher_request *req, int enc_dec)
 		for (i = 0; i < 16; i++)
 			ivc1[i] = req->iv[i];
 
-		/* 32-bit counter width */
-		if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3) & (0x2)) {
+		/* 64-bit counter width */
+		if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3) & (0x3)) {
 
-			for (i = 12; i < 16; i++) {
-				num_iv <<= 8;
-				num_iv |= ivc1[i];
+			for (i = 8; i < 16; i++) {
+				num_iv64 <<= 8;
+				num_iv64 |= ivc1[i];
 			}
 
-			diff = SPACC_CTR_IV_MAX32 - num_iv;
+			diff64 = SPACC_CTR_IV_MAX64 - num_iv64;
 
-			if (len > diff) {
+			if (len > diff64) {
 				name = salg->calg->cra_name;
 				ret = spacc_skcipher_fallback(name,
 							      req, enc_dec);
 				return ret;
 			}
+		/* 32-bit counter width */
 		} else if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3)
-			  & (0x3)) { /* 64-bit counter width */
+			& (0x2)) {
 
-			for (i = 8; i < 16; i++) {
-				num_iv64 <<= 8;
-				num_iv64 |= ivc1[i];
+			for (i = 12; i < 16; i++) {
+				num_iv <<= 8;
+				num_iv |= ivc1[i];
 			}
 
-			diff64 = SPACC_CTR_IV_MAX64 - num_iv64;
+			diff = SPACC_CTR_IV_MAX32 - num_iv;
 
-			if (len > diff64) {
+			if (len > diff) {
 				name = salg->calg->cra_name;
 				ret = spacc_skcipher_fallback(name,
 							      req, enc_dec);
 				return ret;
 			}
+		/* 16-bit counter width */
 		} else if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3)
-			   & (0x1)) { /* 16-bit counter width */
+			   & (0x1)) {
 
 			for (i = 14; i < 16; i++) {
 				num_iv <<= 8;
@@ -454,8 +456,9 @@ static int spacc_cipher_process(struct skcipher_request *req, int enc_dec)
 							      req, enc_dec);
 				return ret;
 			}
-		} else if (readl(device_h->regmap + SPACC_REG_VERSION_EXT_3)
-			   & (0x0)) { /* 8-bit counter width */
+		/* 8-bit counter width */
+		} else if ((readl(device_h->regmap + SPACC_REG_VERSION_EXT_3)
+			    & 0x7) == 0) {
 
 			for (i = 15; i < 16; i++) {
 				num_iv <<= 8;

base-commit: 2d6213bd592b4731b53ece3492f9d1d18e97eb5e
-- 
2.25.1

