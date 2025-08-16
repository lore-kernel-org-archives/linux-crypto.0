Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F0313C8E8;
	Sat, 16 Aug 2025 14:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755354679; cv=none; b=evLZUvsPC02uCHDdM9oJI7S6CwPzOhjz5K1RFFlIc6iWsliESXcray7kvo2zQE3sMVU+qntlaFyu8noAQ1L/Bl7jjh95XoT+gFrOLzU57mQ4D4tX/yOJ5Oiy0KZEayqmdhcDGTpjju+KOQLdpNuKnrhMVv2wFWeaklZzM0yyQFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755354679; c=relaxed/simple;
	bh=HhguPHUJKvVYAfS+9cBX+7KbT3KNe62nChxhs2XLHqo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=WAR9pSqeFe8VLjTF8EqmvzT2E837JyKVRQWmUYlCWiNwq2ac/vADyev7xgoPCFYm8GUU2FrKm/JK5sitYj4CMX6WB24/XSAGj61B3vYxGAATHha/FfATW11GAzdW2pCiiLKh2NCo1x9P7E1yyWVuXarJ/8VK+v0FQjfJv8ZOXXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kzalloc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3234f8df749so27040a91.1;
        Sat, 16 Aug 2025 07:31:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755354677; x=1755959477;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fbXVKmwTmBle6WieiA86XD5ok5iCzQaoBjx5FPM18ck=;
        b=oDPTPKORPkhEUXRihvam7fNywuZVcfVDrHxW7Pmoinc9euFgm1c49bk9muZyxfX0MT
         qRO42AJ81rT59qOQFdyKqszCpbNKU7gXM8hSDwFA4qu/6Q2b+Iij/oKbw4g9S0J9a/8X
         2sebwI44Q3DN4owcepicq/RX/bslMNmk1/sVJ0MMJwriViJuKvnropIXZSfoXVagSA77
         hssOqhRPydHO+lsDCZ5fIQWXW5+C4EbvHrRKk2ulKBVtTQNZP/ob4s8PrNxcubhLiuUr
         e3RQDQcYKcw374+QopnthK2TFlDPwsoSgrNWGhIQNm11gLSdGiDUh4Aivo7Ln5wB1UiM
         1nKg==
X-Forwarded-Encrypted: i=1; AJvYcCUgB/NoyYfAkeUInS2mfJJkG4wFMUc3ajkz1aL/fMWeGYUjVruSRCX/7Upe8FnpRBzWKO0m1GaYaF9GLYs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNJ4tEhPPdM0EQZ8rb7xcKDzmDnk+s147OUceOcBO6eZFFs9bM
	yxJ3/dgaKiS3sU8sQpff4uahrYx7nL/kw++oaOUAmi/3AqkQv8G/rNzi
X-Gm-Gg: ASbGncunX3ZhA99xpc4XBCJRPsErpazPeEjr/r4dGq3+amchceqbYQirjoT1S4mkoro
	pzpxOh7jkDmWiwGcJL0mEFo86gihT8tJpDYdKxmAPMzvGhtQMCZZssXTGMrH1Yz+JL4iP2SlnV/
	3GrFiomFR3sYFf0g6NmVwf7SYFgTU3gGMWfhFysGWE6kaLeuRJLXzPFVRA+njwyxmnpkNEKhjD2
	kRG6Dh9vDLQawUZMZBD4I2hrbbDGox9euSZQMm7YyNQ5v3eXL3eXhdAVTrPMmgLzVjtohMhDiPj
	lfOIudejw8hZiSRSlKAzasQkXvbwW+Ei3nD57Dc/PnGNofsc6o38Np9RkE7azZFr9IOmIQPkuQd
	oZlxGZ3Y5sUX3
X-Google-Smtp-Source: AGHT+IG45Q4pGe721l1Jsgta++LAwyguEs1Lmoh/PbZ/rv/gnomUeuiTX6XE1tVsV8m9R25Ztin6jA==
X-Received: by 2002:a17:90b:4c42:b0:31f:28ae:870f with SMTP id 98e67ed59e1d1-32342107d32mr3875895a91.8.1755354676809;
        Sat, 16 Aug 2025 07:31:16 -0700 (PDT)
Received: from localhost ([218.152.98.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32331124b2fsm6597977a91.16.2025.08.16.07.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Aug 2025 07:31:16 -0700 (PDT)
From: Yunseong Kim <ysk@kzalloc.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yunseong Kim <ysk@kzalloc.com>
Subject: [PATCH] crypto: ccp: Fix typo in psp_populate_hsti function name
Date: Sat, 16 Aug 2025 14:30:29 +0000
Message-ID: <20250816143028.1111603-2-ysk@kzalloc.com>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function "psp_poulate_hsti" was misspelled. This patch corrects
the typo to "psp_populate_hsti" in both the function definition and
its call site within psp_init_hsti().

Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
---
 drivers/crypto/ccp/hsti.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/hsti.c b/drivers/crypto/ccp/hsti.c
index 1b39a4fb55c0..2e23ff7f3b18 100644
--- a/drivers/crypto/ccp/hsti.c
+++ b/drivers/crypto/ccp/hsti.c
@@ -74,7 +74,7 @@ struct attribute_group psp_security_attr_group = {
 	.is_visible = psp_security_is_visible,
 };
 
-static int psp_poulate_hsti(struct psp_device *psp)
+static int psp_populate_hsti(struct psp_device *psp)
 {
 	struct hsti_request *req;
 	int ret;
@@ -114,7 +114,7 @@ int psp_init_hsti(struct psp_device *psp)
 	int ret;
 
 	if (PSP_FEATURE(psp, HSTI)) {
-		ret = psp_poulate_hsti(psp);
+		ret = psp_populate_hsti(psp);
 		if (ret)
 			return ret;
 	}
-- 
2.50.0

