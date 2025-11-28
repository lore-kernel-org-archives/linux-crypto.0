Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FD230F7EF
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 11:44:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764330270; cv=none; b=OJbv5IvL2bGgLJ1rb4H9vZS32rytapytEWDtpg1gL/Y/Oz/FuX2+k57xm27YK2JLBHjB8SqXjMA6eGPHYvFqFMchJ/r8prjTxxnNcZ/dErCH4mGTcYHYBFukGRLouU9kY3dHkDdAfeD7v+Z4DtoRU9NRlWDz3oGXVaGAiDvvl8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764330270; c=relaxed/simple;
	bh=ZKzs687dLj16A7Kf7yoCj+ePQd4RDiiBWDaWylkwc6g=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Lnz2sj8axTN3yXGffnd/9fl/eE/UCMyf46LLK9I/+gDxRjAw0R+TfA743m+ayzOEqOLNQUodTg9Gb8B7x8CBUo6DG+SJSAx+EVwN7KRZtrWdEXHdztpHqiKKSHZ3+NfCi8WdiImhyasmAz/ws8ElLM/9S5llhX1Nsoju8S7m6U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=I1EeC1tI; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="I1EeC1tI"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4777771ed1aso10389895e9.2
        for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 03:44:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1764330265; x=1764935065; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uh7uPTnxM0ybqUV5+6YbE7YAw5NDuzVDUVQeWVG00yU=;
        b=I1EeC1tIzDfrua0VKrIK/pbZwseAfaVIe6najJFTy6/krbiRhHPjYlWwe6yhxhDZ4I
         SKvwPf33IWIN+TD+1EN8fbp5pQ51B1zarjI3kXKswm9nidNvOQaAoYvzK4LmzIkcSb1k
         Gv/u6y9iH07V8d1ibmvPMQ+ktfcXAP/cI4ezLgiRAIbO016yFn2RQX5rRGeof2sQMhrS
         BayeY/gq3+9jlby9DhlHo5NnwpG30uNODXKHvLow2NYwM0ihmGxKFssQ0EulThWO9WXo
         x3sOzHOusNPN7zH6Z1Su8JxTp8xhTNuu6KMtG8vAC/uqZM7aI6cAnJptaJdnuFgSFCbl
         ZmPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764330265; x=1764935065;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uh7uPTnxM0ybqUV5+6YbE7YAw5NDuzVDUVQeWVG00yU=;
        b=U4fxtCWjczJeWg0JaBfmlmmYxQN36tehN+hGzpqRHsL3V/pwFKGM5tNWhL2/caKWFA
         z68h+bnhn0o3Dh+ugRX4Qv+kH7H0hWYwKN2TsESoiZL1fSFCPjy+4OscU2DRGtLfuxs1
         NwXJF7fWGIfkHv1D2cMnj90LhLHFOF44G1zsQaS/DmkhgsD3GjhWAo3hO8CCa7U7Wmpu
         WdPRXIQV4kivkqRf3fwyFm18OaCpddNzdCnqaIrwCGsmMYayGi0eYL5fUARQn+OMvPq7
         EPz66CrHEB55qoPe9D5bpTO/GzvTvWha8jDuDi9xpqplHhB5SSFWzGfW2Ds2buDW81tR
         QkKw==
X-Forwarded-Encrypted: i=1; AJvYcCXBxRSx19UWgvd01/VRkWyzLXlh586n9fDxXuzaDbLtjkxKoygu+e2jwHhPpQqWe84ASV5rsJN15VdTDao=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9srXpn6j5SRh7zwM+C2SP9QSVQ1i5s9IHHBR2w3KwDD8Pin1a
	iqcF5fi+wV+gNOKAWlHAydOXHkw5Vk5REN/dY5YoXBt+KwdpdSVugCUqMEFBn5FJhB0=
X-Gm-Gg: ASbGncsucQhp7zI+/+Bv5wkk0d+5Z9nYQIH+OU5S7wRf+UE44VFm8fNlhfO6VG7I97y
	f7yhgeoeOilMqLTzny5eoK2ZZo9MXQERRnIMBfDAD++kq8uLTLDIG3x+YyKNQgONOYOjcDjvguv
	FeH8nSBn30gS2eJsIQZSUdm3sB9pIar/GhsWXWF0fX0BOmb5o4meEf1vo9+vGHArexoVVd+kBLf
	myrNzXR+C1ZBU+8P7LObA4QFcbgOjxLD5Hv7yTEXomkBsn63x8r345xxN0h5ELs+vB9jsD0St5Z
	PmqZXhqp1aVhf1GK6n7iNXWmBdbfgPgRlzx7hPxr059P6sXB9TUEz9aagZBlkfO3skNs0plDKlJ
	mWmVMnuNXceFxWTWMgsaugazWzcZRutKkk7kanL5JmHc38VZ6esrIAAwrYnv2vIYBlceaabUfeb
	JKsk3F/4Zom1Dyd+qV
X-Google-Smtp-Source: AGHT+IFGETmBAn2a7+y85c+vAvK8Uw2E/Z+IXGCCYI+StYUHb18thUJIZL9h+pQs700HfcB2Zj7Geg==
X-Received: by 2002:a05:600c:4684:b0:477:9c73:2680 with SMTP id 5b1f17b1804b1-477c01bf658mr268758615e9.23.1764330264639;
        Fri, 28 Nov 2025 03:44:24 -0800 (PST)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f3c6:aa54:79d2:8979])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47906cb1f60sm89888445e9.1.2025.11.28.03.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 03:44:23 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 28 Nov 2025 12:44:06 +0100
Subject: [PATCH v9 08/11] crypto: qce - Map crypto memory for DMA
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251128-qcom-qce-cmd-descr-v9-8-9a5f72b89722@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3084;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=Y7Zq3m7ZDk1j81mFJRjZnJPSUKI9CxqNE4sy8coRQ28=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpKYsJ9Hr9P0P/w6D7i6D7Q5ICQn3DGaJjvkNV5
 Jlv6XQErV2JAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaSmLCQAKCRAFnS7L/zaE
 w+wYD/98jkhzq4pvermrohP+/8Osr2vJf2aNYrttJVI6X5gKtxQB8Qp0iS9e3HRGKBNUx7j4EdM
 9gmBANZFdZ1tV4t/gN/gWV5jwLsbwiEz/oEs4bLNawlPZoHLk6CKcEa6jXxfOQd4wrc8dIkTf6e
 xu9xRozw1A3za4JaO771zSuZx6se/RMmMkqnTj0NmhFRbOOFahxD9dQLPNb8g55A/tnIaOLBs3W
 trGwgIbZdyV7C6nIh1hc2WM9unq0dnGKhkWSH9Hv9gGx5zkfRsxVVq7rysCDyNJZtOyNG3hYH1g
 GYfi0Tucn2n30UMk8fjdx8RFXylsB4FnT9b7+JadJlgEgxe5uHbERZ68n1Bz1UW0LrpGovDUTeZ
 eJ1ekLpG+JdKkcqrya4c93/7w5vL2yeuNeN94RYXLaZ+rTWEayc0rIifDWQe4JwwMJ/Yv1tHUSl
 x2Qbg2m009Xw++F6DcNn4fVj1k1C08c5QsSPn7cAV+41qusFfLF0FEe07ifqiQpnIao12C1sFT3
 RsfXuT5GVCt7T65xutcQakbHaFwXFQDm3ChGe5NKnaAW7ca2Dr9eusA9WHDyPbIx+uG6aGZtUqY
 tg8RZrpPlczJLrD9cdkF4/Md4X55/0YRffmZlvmm2yYlB6DaSVAH6p1wNo3bkeG4bV/p8aMsssJ
 FGGzypi5XRKumfw==
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
index 8b7bcd0c420c45caf8b29e5455e0f384fd5c5616..2667fcd67fee826a44080da8f88a3e2abbb9b2cf 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -185,10 +185,19 @@ static int qce_check_version(struct qce_device *qce)
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
@@ -198,7 +207,7 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	qce->dev = dev;
 	platform_set_drvdata(pdev, qce);
 
-	qce->base = devm_platform_ioremap_resource(pdev, 0);
+	qce->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(qce->base))
 		return PTR_ERR(qce->base);
 
@@ -244,7 +253,19 @@ static int qce_crypto_probe(struct platform_device *pdev)
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

