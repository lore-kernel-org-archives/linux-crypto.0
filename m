Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0401B156C62
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 12:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723809832; cv=none; b=WOnR8aQu8p4yN+wWhR22pV582TAVaUhPsslhXGRRgAVm81Trsm1iWgzNtD3aUIWpVsRY+Yc3xfGRgvFarsJ8GWpcpXBqBOnXRMg1sVwkpednMkKgVtxfeWryXse78HLMcDgN+257zpMOkUEJSt94WTz1IH5CBfm067EPLG9iFwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723809832; c=relaxed/simple;
	bh=QsDoUS1ElqARPVJGKlEqs4yyR/pFU/tg9T7gF0bk0Fo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=njc5BmQvjjGQ30Xm/kuE0pjINu/6QKqenWWc26LWzm+0BWrlvzHQ/rPyag9n1R9gAf7IqBUgaDzijrJOCBj7BvAbEL0+DHBbctquYiYerT7IS4zX+2SgLurVCzWBte2yYiBm2szkAiQ5r2uDmypNWaHwh2n+wsJsa1Q1crsEEdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=eE23AeR+; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="eE23AeR+"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-201e64607a5so14022165ad.2
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 05:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1723809830; x=1724414630; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mRVQpU/KkLLWE9g7x2RE2OoWH8BnNFuTM4i4IOyBB0s=;
        b=eE23AeR+Gb/qYZ6r4aOMNwwy8WTQXAFxctlXauRxRIJ5/YlV+v8xACR4qjIZcXX5LP
         FBCbDC42j/0aJuaLs1fN1mb34Coen6Nh89zgWfZVRs7ci/ffec0Ip7+RfkijW6gxkh/3
         CdwwuH2D0iTf1piudjsyHKs19Fw04l1HzWWgY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723809830; x=1724414630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mRVQpU/KkLLWE9g7x2RE2OoWH8BnNFuTM4i4IOyBB0s=;
        b=QRZJUCoJcB6UdMYjoy+UMWrIHBGdw1UeO7IU4oKIrzRA+APqbA1QTXiZvXKIfsChxZ
         4fvfB6rdcNMNhBTU3pL2bIhQ1n+5p0Kw8U21u98wlkUZstkESIH9qctjAlDaEa1/EH/U
         GYYJ9GXuIN1QlJAI14QhTRAa89XVrU9FEPkcqkD/f5FAFl7BKVwi4U4sZm1Kir+5LiPZ
         17PnfBccW2oAwejD94F0tfezWpp0tJOL+n5vDypngpvooJ+kI7maQhv60RDMoSPKjbAI
         +pDHZPECNS0Nr576QRDQj+K4jAh328+F6tYPTcDTwBGzx9eOfa0tTMga6p24fOFQ4+uG
         U02w==
X-Forwarded-Encrypted: i=1; AJvYcCWyRjSIN+kIZI8aITiSehz51gaiV7woSVl3ZL+aApaw84+mxBIpWdSuhRriSga+1A2DE/xWglcUqi1Xid9400TtcW50TMxTYJOyq5BR
X-Gm-Message-State: AOJu0YzxsOIQx55oDlJozNck6P3WB1TStEmTNpvzyfDdkEJKWJVQMl+6
	9LPCmhP/+D3aWjDotOrb+2lcpacvrt/cEVWzQhpC5KIii/vL0EzHO5cq80tEmpE=
X-Google-Smtp-Source: AGHT+IGmWu4PUsovmi2jSo6X9vXs+aWE4ndVf2RWGO1RGubzji0oY61Ll8ny+Ioiyo5tMB4q7ZHUyw==
X-Received: by 2002:a17:902:f60f:b0:201:daee:6fae with SMTP id d9443c01a7336-20203f2c389mr35086095ad.48.1723809830285;
        Fri, 16 Aug 2024 05:03:50 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f03751f6sm24401725ad.169.2024.08.16.05.03.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 05:03:50 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	dan.carpenter@linaro.org,
	linux-crypto@vger.kernel.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH v1 2/2] Fixed return to CRYPTO_OK
Date: Fri, 16 Aug 2024 17:33:33 +0530
Message-Id: <20240816120333.791577-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240816120333.791577-1-pavitrakumarm@vayavyalabs.com>
References: <20240816120333.791577-1-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Removed CRYPTO_USED_JB and returning CRYPTO_OK instead.

Signed-off-by: Bhoomika K <bhoomikak@vayavyalabs.com>
Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
---
 drivers/crypto/dwc-spacc/spacc_core.c | 6 +++---
 drivers/crypto/dwc-spacc/spacc_core.h | 2 --
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-spacc/spacc_core.c
index 9bc49de06bb2..03495b4ae553 100644
--- a/drivers/crypto/dwc-spacc/spacc_core.c
+++ b/drivers/crypto/dwc-spacc/spacc_core.c
@@ -1103,7 +1103,7 @@ int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb,
 {
 	int i;
 	struct spacc_job *job;
-	int ret = CRYPTO_OK, proc_len;
+	int proc_len;
 
 	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS)
 		return -ENXIO;
@@ -1222,7 +1222,7 @@ int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb,
 		job->ctrl &= ~SPACC_CTRL_MASK(SPACC_CTRL_KEY_EXP);
 	}
 
-	return ret;
+	return CRYPTO_OK;
 
 fifo_full:
 	/* try to add a job to the job buffers*/
@@ -1248,7 +1248,7 @@ int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb,
 
 	spacc->jb_head = i;
 
-	return CRYPTO_USED_JB;
+	return CRYPTO_OK;
 }
 
 int spacc_packet_enqueue_ddt(struct spacc_device *spacc, int job_idx,
diff --git a/drivers/crypto/dwc-spacc/spacc_core.h b/drivers/crypto/dwc-spacc/spacc_core.h
index 399b7c976151..297a08eea0d2 100644
--- a/drivers/crypto/dwc-spacc/spacc_core.h
+++ b/drivers/crypto/dwc-spacc/spacc_core.h
@@ -333,8 +333,6 @@ enum {
 #define SPACC_MAX_JOB_BUFFERS	192
 #endif
 
-#define CRYPTO_USED_JB	256
-
 /* max DDT particle size */
 #ifndef SPACC_MAX_PARTICLE_SIZE
 #define SPACC_MAX_PARTICLE_SIZE	4096
-- 
2.25.1

