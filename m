Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795148364;
	b=5Q6rlvNqidmdsVkPPgoSarGOrecIsSASyvrQJu61Fza7H0T3SnxGqiP0dgL11ojbx9Vd
	 2I4HsVIMlKiuGRJEObQFVWhvxMjE6dBCO1yXd7Uk5hK2SwLW2GYVr/VLxgGaokymcY7zF
	 0Cd/wEFXRwG4OrswZlQaNkkWDn3c+RAgYrNqNS/GyVuSBd+cY6AzQ2IfvpKkRO/R/NJPd
	 7pjhl2Kuh5IprVMAugU1Bl9wbw/KpRPWshI9dFoORituUhtDoY21VJAuu6isktVn/7pDU
	 VS1pxmlilvWyuefNb/SyyUvcggGxejYlmlOZGUTgthomddpBzZZC14LizDSNfr02zug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795148364;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
	b=UgFL9HZo03KZwozSmZ0f6/07pQgeNKeQu9llwbvIXsLAQGu+ZPErsB9rhNrn8XVm0MLf
	 K98qLtS4fTuLMPON5iHMmu9cuhFrJAJMB9XKO7monDZf8Lff/1TjT6t/3MGkH8F4jsQlW
	 CkqGYsDf8i0aFnoVG21V6DAm7eheF/e+XMV7KhfcX6pzpEIYnhyk97vsfkrbfUEjxth5F
	 YNw/BsBpgHECxkX10wS2rHdPWrZQD3VeimrMIjOLwfAxEPRVTsDZaz0wg0FQW7OU+wWeb
	 W5lU9GbgCvA2IzSyhBze5rZhOMVR8krcyC5qECqhFGH5GRrEgElB7/1WZLuBmdVxexg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j4lWuamG;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD79D60A263D
	for <linux-crypto@vger.kernel.org>; Fri, 20 Nov 2026 04:19:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD79D60A263D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j4lWuamG
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1a8cc11ac42so677017c88.0
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2026 20:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795148363; x=1795753163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
        b=j4lWuamGqrp+0FhEODMdJBWWdsX6PMg1oouTQ3/954T41wnfXZFMj8i8/+vMchGMZj
         LC10Lmyy8DRFpHCxbHBKJoh6Tz/kTowRjskS9V7gSh0RUBa9Z6EsNdbsRVMpPsUmpfmb
         1vzghRzlxZgYvSYFqHQoC8gVDiMJ09sdNgLs5l2zl41cKqUSgiK0jJVhn6AEwI/bVgSm
         C2sIZasWoWIzrJJv4/052BkqzZxs3KU5izVuxLXNDke46pFtHS13cFhiCgIjt9eHwaOx
         WjVK7cbO7n6+7QCAC7ErR4wab/cUymy9hYrqh4iZRU/Nxuf4FgaYjJ6yOIhRDKcmDNxz
         jRXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795148363; x=1795753163;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hnkDMtwt0yq1d4PAeYVaT2YC+Oe3WZGJ26Fjv0oSbVo=;
        b=gsYFS15zdRovy4lh4utPULWv1t5oNN2FjT/n+Ln3UcccMvRi3skPITOuVi1PpAnWhb
         NMBwaQZnMYKMm17DsS3NP51YeUXWRPOhustwj75uqMKbL2bYAfOTmY1W8tYgxSqMwxkr
         BGkXBGCc4MLBk5Mx7L/yDvrF9QiZ3bAdx9o3IT8HPBHq9E4jKMmntxsDW2RcWBpIiyl6
         DthPA5TIX2wtx5yebGkF0mR5aWmcE5jBxbSyQGMgH7RicfCs+9eiufdDN9UXzjCDF8QG
         KCQBSxSpUi1CkXkI2RSMQV3skzJ9WVf0eoNhkAcQz1rJIb1GOuHwqAgTyjz/yO3Ma9RL
         PPIA==
X-Forwarded-Encrypted: i=1; AL+hErEs3MIGTE7Hsn3ytFLETgThrBa4UpkJkfXtSk25jmFXnrjPY9DMz4kDy/QAIFZHaOzNTVwU3AJ0zMPp31k=@vger.kernel.org
X-Gm-Message-State: APuU4Z/OdsM8rZCV0M95t2xcMp4Ab0IpNqJa7WWmFPA+Qs7DBufqEwTd
	gv9drjSkAsiXB0TCuAMjfik0S/q45hWWk0Fa24AVn2/QKnG01dIW0cPH
X-Gm-Gg: AYBFou1NYnvBJktL6+1dLSiJLz3EWa/0VGVQHTFRiSH3MrrXCQ4tOGWpmLBs2aeT2q7
	qN5rDzra6pfKsEM79iKWQWBaCN30VZRhcIxMuUD4TTPIAbarFlTwAIovSI2sXPzL9Wgcslfl2Ct
	mJHjXumty/LIKRDdYbjKBDYYkFS0L+gM23EgSxhHNFPTXBxI0GgSTAOKGcwJ95dL5Yi37ugj0O3
	EM+vJxBHVQzOzwxNXqZOEvkDeBfeG9dbNwTM/1Ixtaj4DcyYEZQGBIKotdm72XZTDG5H5YHj7Pb
	32qZKBdNEhRPg3JqpZHxcBwV8Qn7S95prILjSzTw//brcLxs+dLTeC/JCQ1c35InAWPmyexypNk
	GcV8nCG68g2rF1YAdv0XP8ydJFfQVFMxe0IztdqXfMLGBS00gGbiFJrRJ/lgic1SKrj3yHZTvpe
	3bxzrauo51IyxS0PbLOIb3NnaAckPQ9e3ow2C7JGL/0cytlvLbZhmIgMA7EZk/qd3mkr0uUOhyh
	TQ9IJ0VviEaIVXBRxt5VyCFuA/eSzLu9srSrJreSwulL2CrSt2hfNq2Poo0n1c2cg+iJeT07qPN
	hKIjZnUwDpB77XRUPtXfbheIqW8l/caJlI7qHH1wlA==
X-Received: by 2002:a05:701a:cccd:20b0:1b5:3819:f8f with SMTP id a92af1059eb24-1b55692aa4emr1650809c88.36.1795148362798;
        Thu, 19 Nov 2026 20:19:22 -0800 (PST)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ffa8csm3124341c88.7.2026.11.19.20.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 20:19:22 -0800 (PST)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v4 4/8] crypto: acomp - Add API to get a compression algorithm's batch-size.
Date: Thu, 19 Nov 2026 20:19:02 -0800
Message-Id: <20261120041906.5785-5-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit adds a @batch_size data member to struct acomp_alg.

An acomp_alg compression algorithm that supports batching of
compressions and decompressions must provide a @batch_size greater
than 1, representing the maximum batch-size that the compressor
supports, so that kernel users of crypto_acomp, such as zswap, can
allocate resources for submitting multiple compress/decompress jobs that
can be batched, and invoke batching of [de]compressions.

The new crypto_acomp_batch_size() API queries the crypto_acomp's
acomp_alg for the batch-size. If the acomp_alg has registered a
@batch_size greater than 1, this is returned. If not, a default of "1"
is returned.

zswap can invoke crypto_acomp_batch_size() to query the maximum number
of requests that can be batch [de]compressed. Based on this, zswap
can use the minimum of any zswap-specific upper limits for batch-size
and the compressor's max @batch_size, to allocate batching resources.

This enables zswap to compress/decompress multiple pages as a batch
to improve swapout/swapin performance and memory savings.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 crypto/acompress.c                  | 14 ++++++++++++++
 include/crypto/acompress.h          | 12 ++++++++++++
 include/crypto/internal/acompress.h |  3 +++
 3 files changed, 29 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index ac4dc52668b8..df9e42f519c3 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -327,6 +327,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
 
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
+{
+	if (acomp_is_async(tfm) &&
+	    (crypto_comp_alg_common(tfm)->base.cra_type == &crypto_acomp_type)) {
+		struct acomp_alg *alg = crypto_acomp_alg(tfm);
+
+		if (alg && alg->batch_size > 1)
+			return alg->batch_size;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);
+
 void comp_prepare_alg(struct comp_alg_common *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 93fa02ce818b..3ce4704dc879 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -593,6 +593,18 @@ int crypto_acomp_compress(struct acomp_req *req);
  */
 int crypto_acomp_decompress(struct acomp_req *req);
 
+/**
+ * crypto_acomp_batch_size() -- Get the algorithm's batch size
+ *
+ * Function returns the algorithm's batch size for batching operations
+ *
+ * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ *
+ * Return:	@tfm's acomp_alg's @batch_size, if it has defined a
+ *		@batch_size greater than 1; else return 1.
+ */
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm);
+
 static inline struct acomp_req *acomp_request_on_stack_init(
 	char *buf, struct crypto_acomp *tfm)
 {
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 0c0d3fc8a9fc..2d4d302d1b3f 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -28,6 +28,8 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @batch_size:	Maximum batch-size for batching compress/decompress
+ *		operations.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -47,6 +49,7 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int batch_size;
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.39.5

