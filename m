Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF9D310762
	for <linux-crypto@vger.kernel.org>; Thu,  6 Nov 2025 11:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762428872; cv=none; b=JaF5ysStCtri3ktZ07ZDMfQWRxiiUGJyMgwd+KfHXbogNlwyU2TLQ6h96e87NXIXHGlQC1tDM+jliab+n07yKib7I5LjVfzwBayB/oZ9SxiGNT4pMKMAoJwxxWnQSNpUepLTyfGhBtRZGa6n/f2Yhg1yX6dPru7KNIqrexfWQis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762428872; c=relaxed/simple;
	bh=a7wQEf6egR4mPuv5cdjgCNZ6WeJSo3nSIgoNmPEuE3E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Gec8JjSKtd0d4X1s6DNjfGWKFus4JQYfmvUhpF4jeqFTWTr0Zujy5ajC5GtEeMHl/pvVcZJdkX4b0VOOMyxMPN9AjVcyO1iFKLyF66+CYrEdgP2eHyL7dTbQ9eF+UrWdz6aO8+vv4xtM02E6fdj7OomFEY7rZNBhGdCuAbmAcqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl; spf=none smtp.mailfrom=bgdev.pl; dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b=Ma5hXJlN; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bgdev.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bgdev-pl.20230601.gappssmtp.com header.i=@bgdev-pl.20230601.gappssmtp.com header.b="Ma5hXJlN"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-429b7eecf7cso589899f8f.0
        for <linux-crypto@vger.kernel.org>; Thu, 06 Nov 2025 03:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20230601.gappssmtp.com; s=20230601; t=1762428869; x=1763033669; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PD+rs5pOYQ8OCsF4o4tgFNdDCvK3XuPAT18E201qmow=;
        b=Ma5hXJlNfP9rAldaxbjYNN+Y6dJsEchEFnZMhMp/wzb74Nx8BUGeR4eonGeYeLDRzn
         s9Ar62qlMUQzWN47RiKnvvoIBhDSIrH3MPFiav7i/J2AMnv36NL0f5e0ETQElhVvbg8y
         NUeHGBnq7mXMpEST+vVzfvefTLif0DD99K25LOcGSzs1TdbsLlL6GkTXVKq7vCCQsIGF
         cfPHKCLf28sOXyGLFaIxsRgt3YolEE1HdKiSRCdOOwFaMHBo7yX6D8RCOxNpQuBnrmrV
         u737ornnnETJWfddlzyjIo5DimeOrzWgCjGJiwUH7wi+WSCRcFx6dv3+hM0qqX2TWOBH
         B6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762428869; x=1763033669;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PD+rs5pOYQ8OCsF4o4tgFNdDCvK3XuPAT18E201qmow=;
        b=Xfi9Xink1R+eYbpendrWKH+UN5Kk4fDRUrgkEIePGGZgb3G1HoKKxBvdGa/75/xp2p
         b/5qfjqZNJHez0/81Bow6rsvREfqVWIm139PV5waIAS09h9kj948m50yroYE+8+ppTpa
         yyOlXi5ixy7EBM+HFWUOcLzvpL65jsMPXLA7vHfhy+KlLcl+oqm9T5RSYWIaFu05W8Qi
         e9j3c31krsGF8XxUak9Hu8+vZIMTfd9aVbp8NycnEYmuUALps04L6DFwtdnW+WcV5x70
         +oaCusUTeYYxONnF0wCTN7WKC26FP7ol1V5A5NLVacGcoJa+E1t0xQ8/EVV6yMbQbBGj
         4T/g==
X-Forwarded-Encrypted: i=1; AJvYcCXwuEYweEnAD/HtdiNaesMXG/5EnYOYWknYJAgRLhQXUiQiZ7pFR2BQQa0UJjhbcueDd927dM4+rIHRpuo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwohgTgEiWvptMRzMrrdcgKGbkbehFckuW7VqmCP3+gdtbckhMz
	doWWxXNE0Rcn3uREU1YQhQqc0PF53ihfg6E9CL047ljMrqceWA9YH8j5ZDZJsNcHaX8=
X-Gm-Gg: ASbGncuwcNzGsyfsJX5p/j9j0P94y2Da+dO6Gt9J7IJJEY7iWGmRoSYPJWvrw839Ibu
	9w84TuOjJR/mtGfOb9hD+Gn6IVGUD9JtQhmAsp1W99TsInTzIv1YeVLP0ygFti2lrsoewnyR9Pk
	r/oOecJkYbe9P6o+HyyIl4OnCbgdq0rVgE6z2j8uMbwusfDgZ1e0OT0srUvBTIFGHf6FzSvLZUk
	i7lTcDZbNAsUyC50tn3ZX8rPLiSop94uJAbedHrUuF11THLv5Aof/MXedFBsrAYWzhGwkoG73R0
	NtJHYKU8/gNpiP+40elEkJVnBNkaUghAax2AtCmYfa5EZmcW+PzGFS7ihChx67TGpT38T+CficG
	rOP6MvNltatsLPwwVyTgzKttmgJydDu0dHlRav6znDwJwnpNiBrtpeBGSzqoj+F4ld437uDaP76
	lnQ8jPaPruXXZ8eQ==
X-Google-Smtp-Source: AGHT+IFgtVKctrlOuzKQectqSEwKB2ayhahJJEey2N61I2W/lfSJB2I/53UnlfLzRQMvbCarVAJhsg==
X-Received: by 2002:a5d:64c4:0:b0:429:bc68:6ca0 with SMTP id ffacd0b85a97d-429eb12fb84mr2538324f8f.4.1762428868641;
        Thu, 06 Nov 2025 03:34:28 -0800 (PST)
Received: from [127.0.1.1] ([2a01:cb1d:dc:7e00:d9de:4038:a78:acab])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429eb40379esm4389459f8f.9.2025.11.06.03.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 03:34:27 -0800 (PST)
From: Bartosz Golaszewski <brgl@bgdev.pl>
Date: Thu, 06 Nov 2025 12:33:59 +0100
Subject: [PATCH v8 03/11] dmaengine: qcom: bam_dma: Add bam_pipe_lock flag
 support
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251106-qcom-qce-cmd-descr-v8-3-ecddca23ca26@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3204;
 i=bartosz.golaszewski@linaro.org; h=from:subject:message-id;
 bh=qu1xfYVQtzlM9Gqzgkm1BqB5ZitfYYPCUMV4Og+CRDo=;
 b=owEBbQKS/ZANAwAKARGnLqAUcddyAcsmYgBpDIe89GdN/Ar44t5r8WnhaHrBfOPqYa8CKf7cs
 8exTYFLr9qJAjMEAAEKAB0WIQQWnetsC8PEYBPSx58Rpy6gFHHXcgUCaQyHvAAKCRARpy6gFHHX
 cqW2EADe+TsFJg+T/SYNyFg8jW7yGLupg/8qCkMSkRipiwwmuO5kMlhyTmSTWIb4cBBjjcXnyqI
 9iqwPS5Rl6+ZCdzHSJlhhGJTCbeMcraPicuujhsUjSFle5cb8M38heAJ2B2buD/2TCw/+oD8TZ6
 IeujESttv94uaR5D+8wYDT0SkrFxWnO2oJdEqoZ42w+I2CnIUoNkxEbAErInw/GbClt7CUjP+ys
 wrlzkgXZmx3+u3XZHftUWg3CkqC/IbQofwY6n/naqiIAWCsQ+QJqu/1w4sQBO/xQyEHoes5HZmV
 oCDJ3BJa+XGw9FYKD6NgxySFr6pE837fWhTCDOqnJ3JSvCWFxJtN+rs5f3rg9dqIiQBMWcburH7
 /vEWzjWcFS7RUVQH7D8RSypiAqUnZu4yyWvVtBq9wnwVjC3Uy/RNE4sqpgkQKdbvMsDETxrQAOW
 ahSW8FjL8H81NS3eqfIhxN5Vj+cFNMeo+VUdIyDky2XDzYG9t88agarsN6/mifiRT4CyDPrsqo3
 DV8Mg0qcZkAutoOkdgLS0ZGIjcVq/s8kzudJl09WOD4BgmJbdvFyg2vFAbbbHSDy6rHnrLiXAzV
 xvkdg2Ka9dm0mI+ZHmNJBzMrarkWX+GdTQLbbUSSRZ5WolvZJrP9hwl4udloyjQ44BDbSphivy3
 xxHtuqNAmDmKe6g==
X-Developer-Key: i=bartosz.golaszewski@linaro.org; a=openpgp;
 fpr=169DEB6C0BC3C46013D2C79F11A72EA01471D772

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Extend the device match data with a flag indicating whether the IP
supports the BAM lock/unlock feature. Set it to true on BAM IP versions
1.4.0 and above.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 drivers/dma/qcom/bam_dma.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 8861245314b1d13c1abb78f474fd0749fea52f06..68921d22ad7abfef7059b1db78052ff48e842952 100644
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
@@ -386,6 +391,9 @@ struct bam_chan {
 	struct list_head desc_list;
 
 	struct list_head node;
+
+	/* Is the BAM currently locked? */
+	bool locked;
 };
 
 static inline struct bam_chan *to_bam_chan(struct dma_chan *common)
@@ -667,6 +675,7 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
 {
 	struct bam_chan *bchan = to_bam_chan(chan);
 	struct bam_device *bdev = bchan->bdev;
+	const struct bam_device_data *bdata = bdev->dev_data;
 	struct bam_async_desc *async_desc;
 	struct scatterlist *sg;
 	u32 i;
@@ -707,9 +716,34 @@ static struct dma_async_tx_descriptor *bam_prep_slave_sg(struct dma_chan *chan,
 		unsigned int curr_offset = 0;
 
 		do {
-			if (flags & DMA_PREP_CMD)
+			if (flags & DMA_PREP_CMD) {
+				if (!bdata->bam_pipe_lock &&
+				    (flags & (DMA_PREP_LOCK | DMA_PREP_UNLOCK))) {
+					dev_err(bdev->dev, "Device doesn't support BAM locking\n");
+					return NULL;
+				}
+
 				desc->flags |= cpu_to_le16(DESC_FLAG_CMD);
 
+				if (bdata->bam_pipe_lock && (flags & DMA_PREP_LOCK)) {
+					if (bchan->locked) {
+						dev_err(bdev->dev, "BAM already locked\n");
+						return NULL;
+					}
+
+					desc->flags |= cpu_to_le16(DESC_FLAG_LOCK);
+					bchan->locked = true;
+				} else if (bdata->bam_pipe_lock && (flags & DMA_PREP_UNLOCK)) {
+					if (!bchan->locked) {
+						dev_err(bdev->dev, "BAM is not locked\n");
+						return NULL;
+					}
+
+					desc->flags |= cpu_to_le16(DESC_FLAG_UNLOCK);
+					bchan->locked = false;
+				}
+			}
+
 			desc->addr = cpu_to_le32(sg_dma_address(sg) +
 						 curr_offset);
 

-- 
2.51.0

