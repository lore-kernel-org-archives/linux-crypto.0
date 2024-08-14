Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2611C8229
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 21:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723669921; cv=none; b=l0W+dHc9Qk9yksRk/eGFQauc6Gi7UR6CG+s7XBlrHKNk0hIV1oM0nCVlnaFnUNA7Ebw2cOCfB9W8IQXEY1NKJy12HLrM2yAAUOgiBAKA22QONycHAOUmVkmV3IvjENOOyW6yK6hUfe5/N0N1epEhjeRZrl3P7iW2Eud5/V+Aj8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723669921; c=relaxed/simple;
	bh=ycPuvrttB1C6BQ1ELjYP6wzk3vRUYi3s707GVRhkX0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=XBsc1v5R5CAWLVk4aKbqXEw+VvbWM7JvxQJH3ComkVjNJKEPcDrVZNzAOSq2P3l1JPihIy8z7i/1ZhxePOI1sZiNF8VpwnQ/OXZctFinbMOqraiTKdpyUAvhSVqSiM2LidTlfwdUCV70O409HYTkN/GU0XE0EIhMiqiJqqg7Yzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pm5s9w31; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pm5s9w31"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3686b285969so168125f8f.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 14:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723669915; x=1724274715; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=evmJCbr5KXjWqF9JXMvY5BqY0grGgRkrA3c6RXKRpdo=;
        b=pm5s9w31eZTMn7HDH2FCDvbYfN+6rH3zUEaEORXFXHT6uPqRTGJ+5JVWLnhS6M9YFc
         ENr4WdBtEcdCJym8erCbzCG28NrSXPBcuaK6A1CkO1VzgZw0GLopiiMe356K8NxjsfTX
         QHphOKLDyZgaKE9RTdnbw2ZDnlx03Oguj3Ug569iWYAAtQsD4HA7VL7by4sBjs+Uxwek
         4NZGMYddnBwDa6gr32hOgXuHTfaeibRALgHP2elJRgp4Thk2gC3244bxpHx4nHbKpc3B
         JWc9OKlEro9P3WCzNjRwzr/84SZFlBO4xAzZKE6QsuHT9g4KECSBLNYMR/zmmLGDdXbh
         HKwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723669915; x=1724274715;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=evmJCbr5KXjWqF9JXMvY5BqY0grGgRkrA3c6RXKRpdo=;
        b=c1vXxdE5YW2Ecq0MCJbBJM/p+u1CJLY7lx0YWbltJN/uz4ZJkOblnq6EKJJ/Fsq3OB
         f4XRL6JhKrlmlT/RhLeXQuVjWph6lfc8HR7MW7tDF9y4f5vt0BqTxGrvKpcuveFjQ87P
         ACYjcpC6SeFn9alzjsngnIH18ICtV8uuVK6Gvzd6oLWR//OspOv6dJ+ER5O4YjJtVzEq
         OjgWiseA/ky1eZde5LIjzMc+BkGiyaasROMFFS5YhfPEe7yA4IW0Um7TM2a26xxwJ+L0
         Piwecr4EY86iG8HKWa4ChaVFA3qUGnF2cCk+LQaX/9fZU4/g0C93mGNaFDGBqZGU/YQw
         7Bkw==
X-Forwarded-Encrypted: i=1; AJvYcCUhTr0QGwFcHILFgQGSB2rK3RLS8gezel7ujrCDlPEacb48k3gQGd7MoTqHscQw+9OI4QNLH+HmDU+bEPEUZl7lNTIYOINuJLFejwsf
X-Gm-Message-State: AOJu0YyAp9JzbRk8wq1fZhT+jLmZCOj1/7NzPMvjie4w93sQSxzgpUt0
	XGat721opmlTsu2Gi68kArx8krtNlHwEy3v6PvUH9lRxy/Ga7Bn6hkqxEw/Hne6jgyxqccVjzrb
	c
X-Google-Smtp-Source: AGHT+IG4xQA7voZvyBkrr8JmB0I9Eo6GKpbi6HEwCJE+aA7CNONDvi13+K+VQ4L/iKeF3xsGk5ywoA==
X-Received: by 2002:adf:ebd1:0:b0:367:9881:7d66 with SMTP id ffacd0b85a97d-371777fe292mr2891842f8f.41.1723669915521;
        Wed, 14 Aug 2024 14:11:55 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-371898ac2d1sm30494f8f.109.2024.08.14.14.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:11:55 -0700 (PDT)
Date: Thu, 15 Aug 2024 00:11:51 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Bhoomika K <bhoomikak@vayavyalabs.com>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] crypto: spacc - Fix bounds checking on spacc->job[]
Message-ID: <3bab6e88-739e-43ca-894c-82c17e0177bc@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c12622ca-923e-4aa5-993b-36cee7442ed2@stanley.mountain>

This bounds checking is off by one.  The > should be >=.  The
spacc->job[] array is allocated in spacc_init() and it has
SPACC_MAX_JOBS elements.

Fixes: 8ebb14deef0f ("crypto: spacc - Enable SPAcc AUTODETECT")
Fixes: c8981d9230d8 ("crypto: spacc - Add SPAcc Skcipher support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/crypto/dwc-spacc/spacc_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-spacc/spacc_core.c
index 9bc49de06bb2..e3380528e82b 100644
--- a/drivers/crypto/dwc-spacc/spacc_core.c
+++ b/drivers/crypto/dwc-spacc/spacc_core.c
@@ -1024,7 +1024,7 @@ int spacc_set_operation(struct spacc_device *spacc, int handle, int op,
 	int ret = CRYPTO_OK;
 	struct spacc_job *job = NULL;
 
-	if (handle < 0 || handle > SPACC_MAX_JOBS)
+	if (handle < 0 || handle >= SPACC_MAX_JOBS)
 		return -ENXIO;
 
 	job = &spacc->job[handle];
@@ -1105,7 +1105,7 @@ int spacc_packet_enqueue_ddt_ex(struct spacc_device *spacc, int use_jb,
 	struct spacc_job *job;
 	int ret = CRYPTO_OK, proc_len;
 
-	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS)
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS)
 		return -ENXIO;
 
 	switch (prio)  {
@@ -1331,7 +1331,7 @@ static int spacc_set_auxinfo(struct spacc_device *spacc, int jobid,
 	int ret = CRYPTO_OK;
 	struct spacc_job *job;
 
-	if (jobid < 0 || jobid > SPACC_MAX_JOBS)
+	if (jobid < 0 || jobid >= SPACC_MAX_JOBS)
 		return -ENXIO;
 
 	job = &spacc->job[jobid];
@@ -2364,7 +2364,7 @@ int spacc_set_key_exp(struct spacc_device *spacc, int job_idx)
 	struct spacc_ctx *ctx = NULL;
 	struct spacc_job *job = NULL;
 
-	if (job_idx < 0 || job_idx > SPACC_MAX_JOBS) {
+	if (job_idx < 0 || job_idx >= SPACC_MAX_JOBS) {
 		pr_debug("ERR: Invalid Job id specified (out of range)\n");
 		return -ENXIO;
 	}
-- 
2.43.0

