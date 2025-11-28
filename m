Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC8930F819
	for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 11:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764330259; cv=none; b=lqYunOaf++soQSshrOqLFdZVKNeXxMsDkkJPjfZ/TsD0SBMi+79IBnsjBN9EBVPfIeU117a0o8caOO3Hkp5028Hud36wZ1FxTABgoV5qemqKs9hIUwbTGK1rlAKFm3Va9Tm+lyiwceRi/xEnDOovMCjSCf/x5l4IXmWN+6tjOjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764330259; c=relaxed/simple;
	bh=0cf2sYKS2TgBzFYc/lqN/kXN1VBlxGschLMTqCaHz40=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZyrwhjdUGT2na61e6ePTGn++2tW+tVe0O4KaS5wYXWyJ5WJdfZzWKC0qiSncPizNxh7XhACE9sasqRv0dsvPB82uwP7/vt5cWRzoHRRaw1Z6Tj/bNpWgpu2hTjBiR5xMerE7Us3kLNmFWoTKF/9A1UbPof3Abw+aarGNtWyq2JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=zK2vRFbF; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="zK2vRFbF"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477b91680f8so14337055e9.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Nov 2025 03:44:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1764330255; x=1764935055; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VMOh3EBYtYfHeuhJAyRcwyFC4rtu5MrYV13Tg8Gi6xw=;
        b=zK2vRFbFL9InZcNsrqUNABaSrNTv3aeUTCdq+okGh8Ta5RJ/s+GJMsFXH0xA2WQuz4
         4lTineQ7RipTPuyUPYZbh6JE6N33i8e05GsWvzgO+RrEhLz/QbJik87443R0cl4Rub7L
         QfKI26vsewF8o5wzQVhXf3gYJKxsx0dYNS2f/+h9IU3scoNZe1JY7VU2LHv6xC7w8lwV
         fJSTkxKsw+Djn3Wan8pf77GhPzBuQR0XeanryKa4fraBhgjE1jd+n5Ly2u4HFpKpowjc
         hNmd+uub6PGWDDNf/bZaUzAxl2kuiN+6j01Oxcjp6gkidi2+trFG89l1FnAF0wfhrUNp
         fShA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764330255; x=1764935055;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VMOh3EBYtYfHeuhJAyRcwyFC4rtu5MrYV13Tg8Gi6xw=;
        b=heRNI+pvEz74cGoVdZpPNSX9FIHbo27ya82je3ZNlvVOXhHPfzCXghEPMZk4KKnEES
         RGB2sa50HBeTUXNiJhTDwykSrN1HsARmrS2iZUGMEONGMrbsx6jwj/tec8+yfO1jQKo2
         IA45kDRCljY/NQmsl/N+p10mtExwEFFjPP7/yPAp/q2YHa132rhDhkgRwvIFJp8J93E2
         A8KtinxKOT/9PAhPVYR4RywXJoomWFt6R2N+W8jluTdbhlfZwpTtr0puNyLNexRYgt46
         CAot+SiU7qb0cvHA9YDO009SIHiB+/jL36xVz252dG7q3J2CQjhfhjsVbOOeUF5T6Ku7
         rK6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXZ+1GIXAFKb5IyI6+z3zz2cM03DtJpQQ1T5qQlQRHJ949cNWu9P1aKqqheLsudf3ejJGr/x49XQO/23uY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1kMLf7GTWKjRtpp0waY0dkEuuzwhEeDCofRC7DM6+tRKAHFiM
	6R1CmxB9sMlzfJ4OoVhnHvdsaoYvqmR4KqVq8wd0iXN2HWzwWtMY8FVvClsq4CZsqdY=
X-Gm-Gg: ASbGncvkOHFyzXg1TkVPf2KcB3xRCDVvsbLWvXN4EA/D2WmkPvr8p+5NOsq6C6zb4OH
	rUxNughEp38gsZe8X8Kq2p4LB6RN2cVkM+RuURrpHY4wFhWbMcFr4ae1qsmj+OA+Uu1kUOcos+p
	wtkoL7+HFIrQxThOx9zjsR7hrCPXjmDTj6ubi0xdKjvaUxDwNn2g5TVYRAKqfCjZhyRisPhts63
	vWMlPBI4P+LShDEtYJEwJpOxkxk+4oqTLcEbTrF7F2Iwd8sh/B8D8p9IhyX9lMdgQu4gkU4DtCh
	tM720qD5sJWNMr4oVBe3ulhSpjU8cQRWtjAcNTK+SbyLMK0M88nwjDqSMLtsVS4VQZDWGWu9vJb
	q8v6slypRuVzYW2tHJ9T6QbQ/WgYsjlsN+OutmduLKevOjT7ks6GDAAVdJFgxSkosobh9heZv5T
	kJI3f9Dg==
X-Google-Smtp-Source: AGHT+IHYDT8265UCPLrcHldT6Cbr99LyQV0pdk7UJQ9F9zFrQVOxHXVebZp3Vbnh7paEy79wIqESwQ==
X-Received: by 2002:a05:600c:524c:b0:477:9976:9e1a with SMTP id 5b1f17b1804b1-477c10c887bmr261551685e9.6.1764330255054;
        Fri, 28 Nov 2025 03:44:15 -0800 (PST)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:f3c6:aa54:79d2:8979])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47906cb1f60sm89888445e9.1.2025.11.28.03.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 03:44:13 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Fri, 28 Nov 2025 12:44:00 +0100
Subject: [PATCH v9 02/11] dmaengine: qcom: bam_dma: Add bam_pipe_lock flag
 support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251128-qcom-qce-cmd-descr-v9-2-9a5f72b89722@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1527;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=p9Va/58wF8Fjgoq2zpqVnJ+LhDyGow0rENCMKQ+9sJY=;
 b=owEBbQKS/ZANAwAKAQWdLsv/NoTDAcsmYgBpKYsHwzwo4ZQ+YyP3lY0RkcVBWJl0Pu9UcNY7U
 D4Ni3P7XVuJAjMEAAEKAB0WIQSR5RMt5bVGHXuiZfwFnS7L/zaEwwUCaSmLBwAKCRAFnS7L/zaE
 wzazEACKqiqPyDSxCpX3RMA/OGSXlWSSDpAOHqGTID043zIFmbd8VLAcA1JGAHy39KfY3g+8Z72
 q8y3l+rzjCr8J0s6dCjQg+XjTUzWUv2IW5F83SSqYqfMnyO8PaQuJE1sRDxfinHSYpGzhH+Rkwm
 ZqaG0PJy9pBNZ0XsKGGe+4nzbMG+A7eOHcSDOuTFDoCvNguNoeCQN2JqGatFKvNeqfBl4S9u+dB
 dBJkA+XxRCjRcgLCAMEQS1tguTejCy9VLNDnNhrkNz3sOsBDh3029fblFvutY+aWvEx7O3fJnuo
 LzpBD5vk72+J4hUYYnxXZ/BwBgptpcDOnt/pCLG/lXh/JKMVOgMdhnDQdd9Ks44rdGh42naB2u8
 aqbhbmjW+xW4RG50P984sL7jsUJ6pWEbf+XINYRc5thLLvRBLwmNBTS/2wOXvuvHFJvqmZdhlSy
 n13XO9YvK6Gcrn1T7rpTPlCsbNfiuJTyhU0do3DWKVRESrfDV88qf6isIL/T9ETx0wr6hhAJ/nE
 ArY4fhXJdQoNytF9PBZlGegC4zRokbmOVUha9yqwoRzs/tMyHXZwt0l72Ug6w2Wo5Ax7Pre+q7K
 aMoVBsk0kWJhdmNUC1s7BRoschoGgPRx7PzqPp+znSW0Z4zYNnGOulp+3bmMmibgEpuiaTtu1xU
 v2k78Q0tTYVmEmg==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Extend the device match data with a flag indicating whether the IP
supports the BAM lock/unlock feature. Set it to true on BAM IP versions
1.4.0 and above.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/dma/qcom/bam_dma.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 8861245314b1d13c1abb78f474fd0749fea52f06..c9ae1fffe44d79c5eb59b8bbf7f147a8fa3aa0bd 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -58,6 +58,8 @@ struct bam_desc_hw {
 #define DESC_FLAG_EOB BIT(13)
 #define DESC_FLAG_NWD BIT(12)
 #define DESC_FLAG_CMD BIT(11)
+#define DESC_FLAG_LOCK BIT(10)
+#define DESC_FLAG_UNLOCK BIT(9)
 
 struct bam_async_desc {
 	struct virt_dma_desc vd;
@@ -113,6 +115,7 @@ struct reg_offset_data {
 
 struct bam_device_data {
 	const struct reg_offset_data *reg_info;
+	bool bam_pipe_lock;
 };
 
 static const struct reg_offset_data bam_v1_3_reg_info[] = {
@@ -179,6 +182,7 @@ static const struct reg_offset_data bam_v1_4_reg_info[] = {
 
 static const struct bam_device_data bam_v1_4_data = {
 	.reg_info = bam_v1_4_reg_info,
+	.bam_pipe_lock = true,
 };
 
 static const struct reg_offset_data bam_v1_7_reg_info[] = {
@@ -212,6 +216,7 @@ static const struct reg_offset_data bam_v1_7_reg_info[] = {
 
 static const struct bam_device_data bam_v1_7_data = {
 	.reg_info = bam_v1_7_reg_info,
+	.bam_pipe_lock = true,
 };
 
 /* BAM CTRL */

-- 
2.51.0

