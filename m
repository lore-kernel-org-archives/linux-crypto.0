Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA9BD26AFC
	for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 07:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723793235; cv=none; b=YevLQKXJ/AEcAhHrmG+wtIEaHL6lVewI1LnZTYoNRUciJAN4t2KPoPB61FlDAFHweR7a5sYJX1wkpLJ1QqBamVOH+X/4CchJs5vo5AHrzCr5AIrzejmcWRcLwXERURTY8Q5dPzATYvouAmdtZLYYJlrCewmYVfumsWNGsrmWcyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723793235; c=relaxed/simple;
	bh=gPpJNAzWX30OZJy4ytFkveWfr5PRe4Yd+74kxdtyU6Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dLIm0QnbgcSdWWJ6qU9yeyRmYt6U2CgG9+dhIfjPczbMNO6KQnlxL5mmS69hNb00PWvxkHM0N6pdaRbJbeQMYH7ICsiRclbVUlfIqDzVYj7SQEsX8eYKQxF6YiZoOB2KTjGwmAiRyN+phaX9oOYiDXh5LjwsjPHNj6EqF4aQxd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=lyojbi60; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="lyojbi60"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-76cb5b6b3e4so1341268a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 16 Aug 2024 00:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1723793233; x=1724398033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YI9HWNqX/Dg7eBiYJ1S9znzpuS6y/ifhooF8yaG1zYk=;
        b=lyojbi604hdzqJn/UQCiiQhx7WKMyg1yjr8yPkuSNC3zKZAKNIyvg+imP+UMIGCemO
         FcE3exliRamfGONtmdy2O97lXbv3XWFIT78a4a5LmFxKQDsqBfJbjLoHJeYmrxBz9KJ/
         KzQRlRtOFP8EjrrMO5+rTTBsHcs71iJsHOFXU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723793233; x=1724398033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YI9HWNqX/Dg7eBiYJ1S9znzpuS6y/ifhooF8yaG1zYk=;
        b=KAZIWB4gPSVbppw4owT854HIAfyS9+SYLeAIpxp8iYY9JRcDqeuwuNnT3tRcBxQ/Jp
         n9TMTWbi9yuF0by4Dixtn+St6zgE1u0pKAp/MBrsMWXCkobK/CCF/XzbWElo38uojpER
         HAUk/kvdBZ+1Kz53iDloGPvTZ8la7Yfzw9dCy9lbxHQHI6cpXWQLDtEeaEPQDFjrSNyq
         Ouu31iD3i7xl5FxpqedpJcIUEr+UFnd6PdV1KhgHaoMVSxFlVArgp9Vo3pi2mgWCY3hr
         8OGt4u5AONuWz3sX5KSo8sZ0Xvf2UZkL91vKYHhnvK+fhmgxCywwnaE31Q/4v9spMYAQ
         Ubhw==
X-Forwarded-Encrypted: i=1; AJvYcCUOHrB7/Ofv7Hb+WKRrxejP+7Y+s+bIOeyGNcywFf3anGdN+YiFsKt7EqGiLSBw9z5S1n/AeKCv6RjjnYfbYxqj9GC4tAWAhhf66TZ9
X-Gm-Message-State: AOJu0YwUOZyHlfRY7u8d7h3cJMwvfuF/hgfWQc9aDJzr51wJzqsSGw73
	tI/iwvSBjMo5/6UnZ0XW7A60Y9N7n59WGC+Mwb1Kz5VcAtVbUzsez8a1DLWgmwY=
X-Google-Smtp-Source: AGHT+IGaBSIF+fFSJFySGoLwcyPCz5Ha2a86Z2xMF3HsmL9AZnk+4HoHcAW6LH6kQZdVt8dAOmIgKA==
X-Received: by 2002:a05:6a21:2d84:b0:1c4:a162:502b with SMTP id adf61e73a8af0-1c904f9110dmr2500126637.20.1723793233117;
        Fri, 16 Aug 2024 00:27:13 -0700 (PDT)
Received: from localhost.localdomain ([103.108.57.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f038e1e5sm20128675ad.201.2024.08.16.00.27.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 00:27:12 -0700 (PDT)
From: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
To: herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org,
	dan.carpenter@linaro.org
Cc: Ruud.Derwig@synopsys.com,
	manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Subject: [PATCH 2/2] Fixed return to CRYPTO_OK
Date: Fri, 16 Aug 2024 12:56:50 +0530
Message-Id: <20240816072650.698340-2-pavitrakumarm@vayavyalabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240816072650.698340-1-pavitrakumarm@vayavyalabs.com>
References: <20240816072650.698340-1-pavitrakumarm@vayavyalabs.com>
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
 1 file changed, 3 insertions(+), 3 deletions(-)

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
-- 
2.25.1

