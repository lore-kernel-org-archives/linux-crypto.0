Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900F9311941
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 11:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764330267; cv=none; b=V1RIe0pG3ExU/oCRSajlOKcOX/ZQ4i4eGDgN2+1K+jCsEPaFkmiNkduyL1GQ61hf8F/CPVIMXh++8vJKSVADkR7w53RA4qULvD5T6xUCyANvahuFbEtVbb6ajpbIMAgCLs/+F19uviMDYAXwp9nwTrd4n8am/J8WgDNhUUvDEG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764330267; c=relaxed/simple;
	bh=jjPbOJFfXgc2j2M1nzFoNpgu00yiy6mM2ewael8rYJs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Yh8gSSXWIq3aX9CX6lP230w9njzVImCNzbWGngIej6ZDSkzrKoPoc4HG9BoD/L3dB/C71S2kyWiZADlXjWs9d89Ov3WzYSo8Afli9GxHAeMPsBV4WbESQIjdgsOFrCdj61ylIbyRnQB0K5hBhb/CJH6tmQy8E3r8Kyk6zkj3sAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=l9semmwd; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="l9semmwd"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4777771ed1aso10389595e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 03:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1764330261; x=1764935061; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2CZU5ZuvBdXmOknsghzwIXQPJm9VKwYk4mzQdsJqW84=;
        b=l9semmwdPbTpHmUqboWGFt9O+8mUTTMYTUNra1301ReM1EZVHAfpmZogyozTpyrLoU
         0xfu8KrxoINeD+pMfoa3YYJ9Vl58EYNOTvel02uEt6dgTTbvWhwfrnaiJoW9W+vChK0x
         OzG9V9gwk4Oonjx5ZFPurWnVQDYnWgWkNwNFNxuMJJH6yW4Ux41nTEaSXbYcCgFupq+X
         ASqgatsWPsLXHWsxCAVOh5RU6UxG2reJo8N0fHuLzmztVHv/9sN6v9OXfmgrdDHOKagm
         Gz1mhZxaqI2WYeE5Nfo5W56kNCWamLbzd03ODSZzg8PB7C1Il6og9lszCeIGfU8FmIkd
         s0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764330261; x=1764935061;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2CZU5ZuvBdXmOknsghzwIXQPJm9VKwYk4mzQdsJqW84=;
        b=OBlHEtl9xmrGqHn1oup4LNOoBfsouQfHvYlSazLrp4alNksy4gCR7ZM9840ytLMNJl
         /7UkNZLb6qVQYTxTgS+kJH4ASGPPiqemze7epn0FG9k6ivSY4NkZRTJDu8fnxZLCMOrC
         iEL2NKd0DOQ8oj55+YsvLS4e9ZEwyuNbFOgXmZBo01ibeQyfrZ1oN29ZylvdMikxcJHC
         0hMak4mQ0mkABwf/i5zyrDX3CXm3DS184o+z80f8IOKe/XQnDQ4j6pFGp58rN0BkhKMC
         VXc8SBkHG5YYvyT0ACCaeHX1hnFDjPAoysLPQvWeEO2IG5GYH+azmZhV+Kx/XWJ/CzXe
         lfyA==
X-Forwarded-Encrypted: i=1; AJvYcCW9bT7ThwImX0Qj3OboOrqOZIzCVSiREw3H5UflBY1BCQ3v/Ya1GUk0XzVN4tMIRamNW7Q3kRE5+wfch4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzajUE+j5rJ/tw31fiJGfLB7PGb9V0wNVapaUXcx70ZVvVdBvSE
	rJuq1Mh0LVxyahgUx9pWcolVeh1TskZoSW3wUQIZmw7OANtJevmVopQw97+MwljIGDZxpkVWMO0
	3xIJ0
X-Gm-Gg: ASbGnctbzcPsrBzsLWkLBZ14qqK6PdWCm07SzV21c1FwrDiNsb9q11tzSfeI3yB/XH/
	xxgK3g0gBkF9yNNG3ctH68ICLj9F/VgOVqGeBzwlnjLqMIGX+eA+9c1JpA7MUdSPmnvtx/M/OX2
	Y38/zaovWQi9ZqEYD2RbMsiFtZzj9uDFl/PpZzifpF3qGooIXnDlv4jpR//8hte5XnBxMWrWrPK
	jJDh3lggcDgD5M44AvVpMhnJZdZQ1gREr0TcoPn6zBF9Dgn2Mrbc90gEObMQL2n9+OR1qvBT4zx
	CJhbXEMJpA6sLiE1Xk5CLKBJiDEr0p0CXuKy67uJCkimGib1KZkiU7S2RtvV4Ti0Wor89YYk3pT
	Ycx6T10qSYLG1fHhuxCWl5xT9DF7LTew9dy8RuNsMO5PWnaNfbbmCbMT6a0Dk9FSSPHUmFsk1Eu
	+9CK+YCg==
X-Google-Smtp-Source: AGHT+IHFIgYlBpxn3c9paAciRv5NbWK6ivHWHM+DP/aH9NlaBNBySq4rTqL0gyyvo3eu5I/G3vNnEQ==
X-Received: by 2002:a05:600c:4ed2:b0:477:55ce:f3c3 with SMTP id 5b1f17b1804b1-477c0162dd6mr259757175e9.5.1764330261434;
        Fri, 28 Nov 2025 03:44:21 -0800 (PST)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f3c6:aa54:79d2:8979])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47906cb1f60sm89888445e9.1.2025.11.28.03.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 03:44:20 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 28 Nov 2025 12:44:04 +0100
Subject: [PATCH v9 06/11] crypto: qce - Simplify arguments of
 devm_qce_dma_request()
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251128-qcom-qce-cmd-descr-v9-6-9a5f72b89722@linaro.org>
References: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
In-Reply-To: <20251128-qcom-qce-cmd-descr-v9-0-9a5f72b89722@linaro.org>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Udit Tiwari <quic_utiwari@quicinc.com>, 
 Daniel Perez-Zoghbi <dperezzo@quicinc.com>, 
 Md Sadre Alam <mdalam@qti.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2545;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=Tu/2fgD2kuZ/5Q8ol0x7uSkKfyxWvVnr1Z7r0zJGsbc=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpKYsITfzj2E3jRweFoyHTvntofAw93VWl3pQYv
 s9g8B6Y92qJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaSmLCAAKCRAFnS7L/zaE
 w+RlEACdr0H3twl7t3Ov1BXP/Wk4UR3tn9025w6Q7VABm8js7X99DLz1p2Mm5o8+KER/O3mrpNW
 41hAeQKVYETzW643dzTK+DyzCSkuuDe+bMfnzBtHNphSwm56ke7t0yoEvnu65v4ydVytj2M/hx9
 csSi6NoP/KEeZe7ohcLwpvin8bUQhcffH7HoPERF3ev0Ei9DFHXnVyCMUx/GsUcYRcpOuM+ZLod
 Xcwc2bldC/5hv4XiR/zsupnbY4p2/rwP3PkSC+ILTzxNTtepYXNGcFmDRPa0kiFAfoDwyL2fzpt
 z2f/Y+9c2voEoFttvaZRNoNOX9THGQO8CIR3YPiSaEw6pMlsDwIUEa7Qzvorcw8LdVCXQpDQT8V
 yw3+MHGZB3w43fMKy1Zai64xa27Sgb+u60twXM6GLtjgxRGFaHZNtyzvtijpO91Ol+CdWIJd/6d
 UK8fkB1Qe9JGDZqUTDH/7x/oWMWp/QMsbOyU03n2so6mbaniXsVvQA8UXfEzRG49nQzLocJ9CYY
 nzAQjNc0DWWlyiOjMP3wiAWZE27qD/e04/nNDLSm7wwREyHpTvEK8xs8OzkRav7Te1yStyyb6lb
 TZ7wrGj8z1Cua67BTQJUOIk5nGUVrc+w0v4zqLVZMJ2vKNOe0T28QoVWKPLMC00xmZzL/e6EvJq
 hZ9TET8WgkIWKKA==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

This function can extract all the information it needs from struct
qce_device alone so simplify its arguments. This is done in preparation
for adding support for register I/O over DMA which will require
accessing even more fields from struct qce_device.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/crypto/qce/core.c | 2 +-
 drivers/crypto/qce/dma.c  | 5 ++++-
 drivers/crypto/qce/dma.h  | 4 +++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 65205100c3df961ffaa4b7bc9e217e8d3e08ed57..8b7bcd0c420c45caf8b29e5455e0f384fd5c5616 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -226,7 +226,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = devm_qce_dma_request(qce->dev, &qce->dma);
+	ret = devm_qce_dma_request(qce);
 	if (ret)
 		return ret;
 
diff --git a/drivers/crypto/qce/dma.c b/drivers/crypto/qce/dma.c
index 08bf3e8ec12433c1a8ee17003f3487e41b7329e4..c29b0abe9445381a019e0447d30acfd7319d5c1f 100644
--- a/drivers/crypto/qce/dma.c
+++ b/drivers/crypto/qce/dma.c
@@ -7,6 +7,7 @@
 #include <linux/dmaengine.h>
 #include <crypto/scatterwalk.h>
 
+#include "core.h"
 #include "dma.h"
 
 #define QCE_IGNORE_BUF_SZ		(2 * QCE_BAM_BURST_SIZE)
@@ -20,8 +21,10 @@ static void qce_dma_release(void *data)
 	kfree(dma->result_buf);
 }
 
-int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma)
+int devm_qce_dma_request(struct qce_device *qce)
 {
+	struct qce_dma_data *dma = &qce->dma;
+	struct device *dev = qce->dev;
 	int ret;
 
 	dma->txchan = dma_request_chan(dev, "tx");
diff --git a/drivers/crypto/qce/dma.h b/drivers/crypto/qce/dma.h
index fc337c435cd14917bdfb99febcf9119275afdeba..483789d9fa98e79d1283de8297bf2fc2a773f3a7 100644
--- a/drivers/crypto/qce/dma.h
+++ b/drivers/crypto/qce/dma.h
@@ -8,6 +8,8 @@
 
 #include <linux/dmaengine.h>
 
+struct qce_device;
+
 /* maximum data transfer block size between BAM and CE */
 #define QCE_BAM_BURST_SIZE		64
 
@@ -32,7 +34,7 @@ struct qce_dma_data {
 	struct qce_result_dump *result_buf;
 };
 
-int devm_qce_dma_request(struct device *dev, struct qce_dma_data *dma);
+int devm_qce_dma_request(struct qce_device *qce);
 int qce_dma_prep_sgs(struct qce_dma_data *dma, struct scatterlist *sg_in,
 		     int in_ents, struct scatterlist *sg_out, int out_ents,
 		     dma_async_tx_callback cb, void *cb_param);

-- 
2.51.0

