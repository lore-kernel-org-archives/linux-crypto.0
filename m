Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7088BE5B
	for <linux-crypto@vger.kernel.org>; Tue, 14 Nov 2023 05:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="hHtN6zOr"
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E776319B
	for <linux-crypto@vger.kernel.org>; Mon, 13 Nov 2023 21:05:54 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1cc3c51f830so39313745ad.1
        for <linux-crypto@vger.kernel.org>; Mon, 13 Nov 2023 21:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1699938354; x=1700543154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C3JBb67mZe+968l11OU2Z5ouKRxnvoS9bSl4IHKshAQ=;
        b=hHtN6zOrKdBEM8ibiSXNYahtM3/Dd5KAtd4nfhFojmLD8Pj3p9WQvkIbhbYRYT4HCG
         zsoYHCDyDWI60tPDYv1O+y9G7dn29Jq9UrZE+Cz0leLIlwVmyzkFLnuyV/v1kBKVifJc
         aqzTRYg63meSeFK1jYVHVC4gxZdjkaYVFuTP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699938354; x=1700543154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C3JBb67mZe+968l11OU2Z5ouKRxnvoS9bSl4IHKshAQ=;
        b=wktyLvSC4Gy9pQ+6V6veDPzc0Puz8ZOTUecxUm20AZLDzvODUfopNuivrm6fIxbriU
         dtC5sIHl9FmGWEMftWXKCj8vIGDVX1CnmtGbLL0eaqKox/es5ZK/tcw4paLHgYYD+pb1
         A9U8SP9k9EoHw3HAmGNEg+GcOXfwEJ6HXcmbgpyBvviQG68xEqLV7X2Sr0Owv6tza291
         miBa8IuSwHi22Y5uxZw4OZXa5f2L1lUS42ASYjSMrrXYalWUpg0wm+mxlZApMvEpgQrd
         g4yytEO0WaiyD79USf154BYBCw5hnUL7utmYjrMq+QEd8jBwY/p88sPxJEr/m9It9vnc
         Unkg==
X-Gm-Message-State: AOJu0Yw24zMsnMZ/sBumaALK0e0+bLpsYd7QRWj83m/hwB2nq+rO/S1F
	stCph2xTLKfRcfV12mFb5t7oFw==
X-Google-Smtp-Source: AGHT+IEIwEKVHxxFKtL+8M6IBRaLvmHzaJXipIuEz0CWKBBiOsyhYfqG5DnjVQq50ZYojpEM8UyzSA==
X-Received: by 2002:a17:903:1251:b0:1cc:50f6:7fca with SMTP id u17-20020a170903125100b001cc50f67fcamr1518573plh.24.1699938354374;
        Mon, 13 Nov 2023 21:05:54 -0800 (PST)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id a20-20020a170902ee9400b001b896686c78sm4910131pld.66.2023.11.13.21.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 21:05:54 -0800 (PST)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: manjunath.hadli@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	shwetar <shwetar@vayavyalabs.com>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>
Subject: [PATCH 4/4] Enable Driver compilation in crypto Kconfig and Makefile file
Date: Tue, 14 Nov 2023 10:35:25 +0530
Message-Id: <20231114050525.471854-5-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231114050525.471854-1-pavitrakumarm@vayavyalabs.com>
References: <20231114050525.471854-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: shwetar <shwetar@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/Kconfig  | 1 +
 drivers/crypto/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 79c3bb9c99c3..c80b63438b55 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -703,6 +703,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.
 
 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index d859d6a5f3a4..25558a26c4e3 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
+obj-y += dwc-spacc/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
-- 
2.25.1

