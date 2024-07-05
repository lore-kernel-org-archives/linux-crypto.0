Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D5716B3BA
	for <linux-crypto@vger.kernel.org>; Fri,  5 Jul 2024 17:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720199625; cv=none; b=ZyKIWE0OjxbXJCFBQZ+sZzhwJ6VSPEoIM3/nKR/NMimynapHWxcprXNwp3sAS2EQyv0YgXvyP2xSIiTqNpBU5qOB2xZbydDsD18OqR/xBsujGHukw8Pfu6Whhp8OpLAUfSJmgVe075xdMBFzS8Bwc+jnNhXIKVbXOobP6MCP+uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720199625; c=relaxed/simple;
	bh=03Or/FiYd0/nl0Pewsikw0aSkjgcfqdZV+GhUY8nJPg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IMHNTIRpKNmOb1hs4fF1LK3cb+cvryvCkvw4aTJea9oINvePpLV5oy8WXJ0+w6OYU3p/Mwsd1gJ90ZkMp24YTeNoj6lk0t9dfsd1RPPRzhviMVmtjrvq/1EkOFHPm+VAdaKTIOYW5OorAD9zUmMVOKNWxeDdsptO8Z/Dz+XbCfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=jYpdQqaj; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="jYpdQqaj"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-70b0e7f6f8bso770719b3a.3
        for <linux-crypto@vger.kernel.org>; Fri, 05 Jul 2024 10:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1720199624; x=1720804424; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z6rOVwxl67M1ho00LCXthXQkqBxCB3HpfniWe3LKqEs=;
        b=jYpdQqajz9dBmvL5WCfN163CRvI4k+GAaMQm/hFnS+6IJZOxTL6/5nTxeMEgG+ee7Q
         tvG9DkSd98PkCPogUcGiEtrfT7NFM0eNskFMwUf7lwnTsKEXXy+qm1za70rB19ol8bKV
         3KJMjFsExPyPsJnEeu/Vx1R7prbqYjdJCB7Lc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720199624; x=1720804424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z6rOVwxl67M1ho00LCXthXQkqBxCB3HpfniWe3LKqEs=;
        b=DGzzD6TapW04htScQH2jpUuyNPQpJ72AgCT3uaDjnXlqZbFNSjAmGzX6NmKJcgZSo1
         XqaWTVzeu7r1zPN0EW0awGdHMX4F4B2fM5nkuCAKxPCa8XAVui61lHQ5bXRiePQPWI4Z
         HvmfvO5Qea/YTbgtuz90LEqW4Kp5CaigmnOYJHANnyIMrE4iVqPGnmAPdNLBwR8b4mJQ
         /8UcVHTNvDHcPBTiHt2hz2gOiVoIDOMJGseH9Ycis34MC7IP2+p32hUMJJSQDIqdHE29
         XZ332X4HD3kbGxnLnDrmQefs7IRSlngeQw5m19yk2+Vi9YNPX8Nhag8kvxuQ4Chn8ds6
         p49w==
X-Forwarded-Encrypted: i=1; AJvYcCUJg6jfvlAW+mQ00z0/oq9yVPRYmoV/zBjl4nNF4W6a5016+0D9DOIjdkLJKhS/YdQzHWbc/O6K324Tc32T/iVYM67IWIEl5jFcKKjQ
X-Gm-Message-State: AOJu0Yw7zxMq+NkNBAADUyYCGAS4YpjZnewx/P/OwmKF39hz62f0IkFu
	XoCyRmxcE/tBIqNRZKJ6WJCEUjvkHKTUnWCdCdEH2mR0H1he5xrK5ctDQv+VxM1C0yk9pOS3we5
	x
X-Google-Smtp-Source: AGHT+IEUS7I7XnRuEVSesDJkp24nCNiGRTsi2v2Jr6YFAwxKRZapys19FGO7cv3uDTkPpA6dnb4WFw==
X-Received: by 2002:a05:6a00:2997:b0:706:74be:686e with SMTP id d2e1a72fcca58-70b00ab6c42mr5152618b3a.26.1720199623713;
        Fri, 05 Jul 2024 10:13:43 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b030d5d0bsm3174889b3a.14.2024.07.05.10.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jul 2024 10:13:43 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v6 6/6] Enable Driver compilation in crypto Kconfig and Makefile
Date: Fri,  5 Jul 2024 22:42:55 +0530
Message-Id: <20240705171255.2618994-7-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240705171255.2618994-1-pavitrakumarm@vayavyalabs.com>
References: <20240705171255.2618994-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/Kconfig  | 1 +
 drivers/crypto/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 94f23c6fc93b..009cbd0e1993 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -696,6 +696,7 @@ config CRYPTO_DEV_BCM_SPU
 	  ahash, and aead algorithms with the kernel cryptographic API.
 
 source "drivers/crypto/stm32/Kconfig"
+source "drivers/crypto/dwc-spacc/Kconfig"
 
 config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index ad4ccef67d12..a937e8f5849b 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_CRYPTO_DEV_BCM_SPU) += bcm/
 obj-$(CONFIG_CRYPTO_DEV_SAFEXCEL) += inside-secure/
 obj-$(CONFIG_CRYPTO_DEV_ARTPEC6) += axis/
 obj-y += xilinx/
+obj-y += dwc-spacc/
 obj-y += hisilicon/
 obj-$(CONFIG_CRYPTO_DEV_AMLOGIC_GXL) += amlogic/
 obj-y += intel/
-- 
2.25.1

