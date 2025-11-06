Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA6A314B9A
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 11:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762428882; cv=none; b=UQByZ40HyQUPhwEmO970DjpycxKFYAFT8DQtC0bMub1hGi8/Ic+PBTCIE4QfDQLUxHNGMZJutpEFzRDk8/RjyZXQNu+zwXbGrl+B1F8EPxv8GcJqXAC30SkM2+w18Ocec92hos/mqtb758EUbtTaOvwTemCNFhPBOzt3ZglJ2SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762428882; c=relaxed/simple;
	bh=HmUXLW2y1rVjaif1QbzcfjuElUDdKXykWdLm9c4LpXI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=RHYY10CnlGle2YKoGjKkDcggJHB+rbP7SbPJ8AKEKoVKCTe9J2kebXJnxiMQMX09mYHXCzKoGprbkmEuEP5lWpr3AinGuE+AS9IN7hAXRqCk6wpsSFjUNz3QVt/JUANAe1H14wgLj595NxJNtDBlQ4Z1OF3ItD727O2c4rk6O+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=VHcONQdh; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="VHcONQdh"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4775ae77516so9905965e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 03:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1762428878; x=1763033678; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t7aHWUrzlgxNBbKWCNeGhQi8iWZi43My+Fzs3phWPnY=;
        b=VHcONQdhjwWlt7k4S0daRAlmy3l2i8S88cmTgbJbowhe3knjB2JAE2sVULWNh78ecO
         hn2M+xbyph+FJiyO9jq4GOWBkLYN7xRDmYRJsCP3AzxnMF0WQL3Oqt5mQVTeoPi/ocg+
         VSW9Rcke1uVSR2dHoLdYvuotAEzE29AA+tLMeElp/Tf8lDXahjUCmKAD0k51riARVOBq
         4jDEhZZ/ysGLA1UEh/MzenzZLvJoQO9aSlO2QBtRksWidF+gCllO29pN9vS6Sa1zgChX
         p0jWoEX2iJQdFWwZPSaaH6BN9wS2mFv0bdhHhK3UVKHFivpUrmXBbzBoAVRUXzI/s0gb
         Tz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762428878; x=1763033678;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t7aHWUrzlgxNBbKWCNeGhQi8iWZi43My+Fzs3phWPnY=;
        b=b1Uxw/Bg+TNeuY8gPX9SEIPSwUb8wrcO3NeoneztZ6y4uuh3a+xP/zBia7uPeWBXPi
         P2/NuSuyfyCsqST+0ITQP5PbVdNI4Nb0ss5vkYhpWXeN/nwk9tCeoJLpgfg5xqwBYN45
         hXUlW8CU/7xQx1FauvCZuQsSdv9bPjguEOwUBp4CHAdA1OYjFRKZBz9yi+73Ws1LW9RU
         DqESbzMT5T1XbBIn2g+x88Yrked4vlV6FfpFHGQR9cjH5XhIT651yNd6JcPjaVrAnIgk
         2TQzwWLBMydbCh3hI1NhqgM1PGuoYzo0inRqKadbRymfBgHIkggfZ9IADUjOFVJ/MqBF
         LTdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWD2LtmlubJWwNBlrhClXdrUIy98JiojUKpFQxh7UMHuJf6qS3Wy+ZSPVDBsMQrpMv6Bgz1+0kRtNasoUw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvT9U0Vt5816eE2SNsvRwkpI0wwTEptTI3n40gQf16dZBBEy+B
	b45jTnG3fawlsksfHVO7vQk1qkZ/pAnQyZadt8QRywJBz0Wtx+4AS/xowlAIbWRNrLQ=
X-Gm-Gg: ASbGncs1dK7No8IW0NUk4e9jkWufZe5j8gAwwRTR7b/W6TJAcf2dCss6r8LzmphEe+x
	wBFXYQmjmwYw0YtWaHugRA04w2TPB42nQrzmGAKW1i1mnBn1VcJFQ8AwwRfNyTKejVtjTQH1gz3
	jSEw58IzLerPOiVLpWOk9k5OtOQmo0vPv9WHvm/lg+SE0V8+f9xBiibrN8asiIMuc4Hm1EHllGF
	KRFAaZn6vXvTqR+pEBA8AOe4MOWiVPg9xVgE51e+czxzKT9NvyCW2jT8Xc4YsZ05J6AJM1rRrSd
	tbmWVfbDloVuHx71XjOXD7HTE4nHykyjh5tDAruv6AOdmzDQPIpOzvoDrJxCH1IORB8ZGkVSFDB
	uOAVr5ocuV92BFIqUTKm9FHe0prRnBIuXtcdE8qt8DwkvzU/QEPj3B8nJYqBKcga6x8oR
X-Google-Smtp-Source: AGHT+IHoK1O/+JDQW0JFse0/zrHgzULYmUJO8yjsG0GrRdQ5S3RvCjLR1rPwRSyZQozg3pEN49UEFQ==
X-Received: by 2002:a05:6000:2585:b0:429:cacf:1075 with SMTP id ffacd0b85a97d-429e32e4649mr6174613f8f.17.1762428878188;
        Thu, 06 Nov 2025 03:34:38 -0800 (PST)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:d9de:4038:a78:acab])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb40379esm4389459f8f.9.2025.11.06.03.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 03:34:37 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 06 Nov 2025 12:34:04 +0100
Subject: [PATCH v8 08/11] crypto: qce - Map crypto memory for DMA
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251106-qcom-qce-cmd-descr-v8-8-ecddca23ca26@linaro.org>
References: <20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org>
In-Reply-To: <20251106-qcom-qce-cmd-descr-v8-0-ecddca23ca26@linaro.org>
To: Vinod Koul <vkoul@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 Udit Tiwari <quic_utiwari@quicinc.com>, 
 Daniel Perez-Zoghbi <dperezzo@quicinc.com>, 
 Md Sadre Alam <mdalam@qti.qualcomm.com>
Cc: dmaengine@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, 
 Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3084;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=YrlK+FCBMpnN0mtgQnv4x5y020oK7SmjbrJXDNXzn5g=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBpDIe9PAKKUyb4afZt0r5bIvZ+oWZJdtCAEcub9
 pOHJZBRI7qJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaQyHvQAKCRARpy6gFHHX
 chpXD/9NByZYb24rxG/Ghz2t9YYbHOU4a7LXMIg07ieVmtBqJwlhLP7h0sKuRaxHxREFUKO2Cac
 XvK0LjqloxZ6+ORHjrLB9zCDOAYud6CAbxZASMdM7nlv4LdWV8xPTxtHpM5KkGRPDSOkSW5WCch
 eBBrjBHTUQSdNUi+Z3/KrrBzuIIlk+LQzgQ4wPLqDf9mJ0YMemD2clgtLdILmqyYzWX8Wzt5iBp
 Clru+Ab+RQ8AD4rZP8+UMMUcQ1QMCZZ8C54WNeJPUgDsRlGJ/oGhZBiMuFOZrFIHB3UqdrrnRR5
 e8Zl4xh90DX51C9Ga5vCx6lgB37BT+dMpUTzW4vI6MnO6VRDLHRN2oudv2jv0MI/5HtC3rzFdMD
 sSR4wRIz+hVgpOj3t1jjdn2l5wmf7Ri/UzhbnfZKIY+PVFqBlcV4HnNG1eHKo+2x4imE5UGYd/J
 FWP/rUBnoI7G9ld+50zwCE2kNXsFcRB0ug5fDM0VCvja8L4UxhvbYY0MqL40j3BiwdKJapuRBY2
 iYbjGh9rI6R5NFLgeCEeYKNk2jrCi8sRZTlzpXP0rERk2yPNHSbaBi1T+52NzxOry3uZ6BGN/Yg
 hEpEM2VJXEIiH/UBD+o1L3l0Cln4piKV9RagSk83wK3BgvIfskBCmMikKWvtFqJqU2oFMeGd2yw
 WsgEqAgozobeU4A==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

As the first step in converting the driver to using DMA for register
I/O, let's map the crypto memory range.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/crypto/qce/core.c | 25 +++++++++++++++++++++++--
 drivers/crypto/qce/core.h |  6 ++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index aac65041f585221b800f4d7756e4bf9d9f21d0a0..e486d366c0d63aa0e1f545da9265e8ce689b50e0 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -186,10 +186,19 @@ static int qce_check_version(struct qce_device *qce)
 	return 0;
 }
 
+static void qce_crypto_unmap_dma(void *data)
+{
+	struct qce_device *qce = data;
+
+	dma_unmap_resource(qce->dev, qce->base_dma, qce->dma_size,
+			   DMA_BIDIRECTIONAL, 0);
+}
+
 static int qce_crypto_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct qce_device *qce;
+	struct resource *res;
 	int ret;
 
 	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
@@ -199,7 +208,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->dev = dev;
 	platform_set_drvdata(pdev, qce);
 
-	qce->base = devm_platform_ioremap_resource(pdev, 0);
+	qce->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(qce->base))
 		return PTR_ERR(qce->base);
 
@@ -245,7 +254,19 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->async_req_enqueue = qce_async_request_enqueue;
 	qce->async_req_done = qce_async_request_done;
 
-	return devm_qce_register_algs(qce);
+	ret = devm_qce_register_algs(qce);
+	if (ret)
+		return ret;
+
+	qce->dma_size = resource_size(res);
+	qce->base_dma = dma_map_resource(dev, res->start, qce->dma_size,
+					 DMA_BIDIRECTIONAL, 0);
+	qce->base_phys = res->start;
+	ret = dma_mapping_error(dev, qce->base_dma);
+	if (ret)
+		return ret;
+
+	return devm_add_action_or_reset(qce->dev, qce_crypto_unmap_dma, qce);
 }
 
 static const struct of_device_id qce_crypto_of_match[] = {
diff --git a/drivers/crypto/qce/core.h b/drivers/crypto/qce/core.h
index f092ce2d3b04a936a37805c20ac5ba78d8fdd2df..a80e12eac6c87e5321cce16c56a4bf5003474ef0 100644
--- a/drivers/crypto/qce/core.h
+++ b/drivers/crypto/qce/core.h
@@ -27,6 +27,9 @@
  * @dma: pointer to dma data
  * @burst_size: the crypto burst size
  * @pipe_pair_id: which pipe pair id the device using
+ * @base_dma: base DMA address
+ * @base_phys: base physical address
+ * @dma_size: size of memory mapped for DMA
  * @async_req_enqueue: invoked by every algorithm to enqueue a request
  * @async_req_done: invoked by every algorithm to finish its request
  */
@@ -43,6 +46,9 @@ struct qce_device {
 	struct qce_dma_data dma;
 	int burst_size;
 	unsigned int pipe_pair_id;
+	dma_addr_t base_dma;
+	phys_addr_t base_phys;
+	size_t dma_size;
 	int (*async_req_enqueue)(struct qce_device *qce,
 				 struct crypto_async_request *req);
 	void (*async_req_done)(struct qce_device *qce, int ret);

-- 
2.51.0

