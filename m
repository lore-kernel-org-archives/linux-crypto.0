Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE795156C62
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723809828; cv=none; b=ACd+yditGpPV2IqoYgvwiLUr7Bv1TZU0Ws8qsEuU+mcx8GZZW8rqn2zZz7KlhZfIY6p0S2bzmmUUg5r069TWtmgstyqKiMByGDrFG1vEsWfeSy/sHVe3mpcKJ96+ytX2ndUBSOTm1hKcjo32JFbPjuGurYXpN+0b6XxJ9lwqkqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723809828; c=relaxed/simple;
	bh=ycB76cnwmlz6HwU0ZIJ3jiNrpoFUTcORUl9xOpdgyBY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ag+K810dRiOp6deW99g8bCT2S6J+wm92jERJGX5+YqfwxBctr3k+H62+cb05DXF1UCfP+bBR/SCs2AxKcgaPBuLtAYlJsH0gn1G0Rfw8Vzqx2q0epSBu0HZlMjiyQ41rhZILt3tWGqCd1SAB74Rt7tCV09eoF8w7lwFM5Wq5XNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=nmqjqlJA; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="nmqjqlJA"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fec34f94abso18906215ad.2
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 05:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1723809826; x=1724414626; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4vkBuUCzWA9nwoqD9tlt5sayA4LwP9cf9M8hrIll+Hs=;
        b=nmqjqlJAxS0XtvSNxLARH8FvdqQLGULXjAW07IfjMB5wcXxtz4lg2XDRIWqixl1eTJ
         +zpDvwIx+V6q8cQrh03jwIlkXKZMS9nLIBlPP14NhOqVtOmebqOmu9S9WCosZiTucfAu
         ktvGL6Gsv486Ysf7H5TIlnpEO5e7RTLWz+svI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723809826; x=1724414626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4vkBuUCzWA9nwoqD9tlt5sayA4LwP9cf9M8hrIll+Hs=;
        b=wxVQHb255kiaCWmukqwvECsn+x+FDBDs/m5fZ2a4W3RFA2G2PfNaNe8T1lEUBI1vI6
         KmnlaTILudRiWLHJQvTeqnHndXBk81/vMjTL4gVOW0MWrPavfXvbG7RVld+Jv7I1J+r0
         NlRZBaL6/+H7cjSDy1HPlcjENDnyizEcOtzEwskf1TDF2K8pJ6kt7LlNvIL5gTcLaj6y
         n56BGJCipCExl8UmZ7u4YwkedgJFEtEi6l9Hc1bOPn9eaLZ9/mzZnnPc/8D26/wb3+vH
         5hAXJ7OeQ7pyeR6p7bXoq4xy72HxVf+BpNUSEg3uCJv2g+pT5Fi3groiVJCkrpAAZZE9
         d4Aw==
X-Forwarded-Encrypted: i=1; AJvYcCW3hkE+OohvkwRGnirv44x8OY0Fe8FI8ebacFVhOg1hjsVVH/3oFb9ZrrAT7fdvMxpBuhlgL//QujtVxBrvUl+dbmvMrBdhMVGkvwez
X-Gm-Message-State: AOJu0YwJ5VHjhELAHFxGHGxqNCLG9BhLq6jZuIF4USig/O7rB8aEiJrF
	al1J/q4lAUxMNLF6Kz9ghtk15t/pS4w92/vLmbf0/vnp71GEABlOsemG7Dpwypg=
X-Google-Smtp-Source: AGHT+IHSNuZySpx7CyX9PkLvUvjA/kgkripE7kLD3AlpRKMeZlZratQEghax2E7KfuFFXSAY2gJ2Jw==
X-Received: by 2002:a17:902:d2c1:b0:202:ac8:991f with SMTP id d9443c01a7336-2020ac89cecmr13873805ad.26.1723809825973;
        Fri, 16 Aug 2024 05:03:45 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03751f6sm24401725ad.169.2024.08.16.05.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 05:03:45 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	dan.carpenter@linaro.org,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v1 1/2] Fix counter width checks
Date: Fri, 16 Aug 2024 17:33:32 +0530
Message-Id: <20240816120333.791577-1-pavitrakumarm@vayavyalabs.com>
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

