Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE3219E7E8
	for <linux-crypto@vger.kernel.org>; Sat, 28 Sep 2024 10:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727517937; cv=none; b=P0SmMAUlddSbyJhD+a2MDRcgJN0tEPkL/+/SvNe38hsJH0t4cKzfQ7BcVGxgAhKfT6BYqIV6e9jVTRPKLoCUj8IrXgVlcgGnP8mBzfmdp66y8bI5LWfm/5PTlbgsdy5XV2u+ij9TjFwsJ25eKxI0jmkS++X7n1sqcuqUSiQMdrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727517937; c=relaxed/simple;
	bh=nysf4iZQmwHqPE9b3am1r0Q+jJLgASIeYoXVo9KcmOc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hoV6/o8ZYBGDmMH1nnHzbrMOO8NbmjA4UKayy28FSuFMK87thmN1VkULDcJhb1VtsbmxFIZx2SvTviJQ4vifln8kvpKxBNdVRrfIdTnjcD0TzaZdD2LpOnX9bRUi2xMbrDv9pDk29+brg2SRHlzv4Hg+M02xB52ALPsALcEMUyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EFIZs3W1; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EFIZs3W1"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42cbc38a997so17730505e9.1
        for <linux-crypto@vger.kernel.org>; Sat, 28 Sep 2024 03:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727517933; x=1728122733; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x0UkuD3GuJbEJOo86vgUIxaJ+Z37a87v7S3JRkIjSIg=;
        b=EFIZs3W1+t49WVMXmO0Qhi+izUpOTnAODaFO8STl6XOaV7aCALjiZ9/w2H0zRipd51
         YjUqKkmBY5z3xVDYudIcT2eBaZ6VWzTCsaWcqxvlRyIADJKdFD/V85R2kwTpleTIONnO
         /uKwuqyPOuDsr0QaOM+zssyB7SZFfA+9zZrvMAC3BqN4IreNvMzr8Ody6K1C/J0I81P7
         RYZotmAKzcs7x0QovjYNHHNuPzDHfGVLVxjSSYTH7P7XRIe0veGMwphX2i95S3F7JcJE
         rlRhiPGWnRg6vXbQIiAjQqpiMQyM3ALeVsSFvnWad2WdEjZQd9qUmNTn7/byaZANduhq
         YdrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727517933; x=1728122733;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x0UkuD3GuJbEJOo86vgUIxaJ+Z37a87v7S3JRkIjSIg=;
        b=ie3DNTImJWD8VIjm8mgVnbIwncaww8GfemIKN27aMMZITScDISdWdQtCn6Utj92Msx
         mZ5X6XMEHZkXyh7PO/9YuT4jCJ2nKb5MsT6+BGWYqbANOzgouH3o6SiC0OOXb2zol33L
         Ae1rY52c24Zq44zVnvHvBr0LFXElHaFKKkIDQaqOzN/coEYF2ehwe2oDguE7ZXfWBzCX
         c8ylSJX2z3dX14jRMk0mUWZHTC7LJURLepDJqsmbAd6ruIloZE58ndjH0Q0nyJ0igyZ1
         Tdzw3rohr+Ih/PWwJ6Iz3UQ/GgnHb8cuQbuaQWsbzd355Pwplmor26jc3ibpY9xRDblR
         sGhg==
X-Forwarded-Encrypted: i=1; AJvYcCXEVQcmVAZh/+VmDpZ1vjHvbfPzZLc/pGUmNICtqa7STGxMDjTZISRMOLnFmHpzADWNpO0mLRTm4FgCYgA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyElHWdlI+jUqALp2hg2ucMrH+r8lMO1zGmTcQnyh/B4Op0EvxF
	n1uiD1w84nWiuyHAnTbLIMaQG27ir2wqwTcU93hzA7KZxKQ3ExAa84dzRG5JVW0=
X-Google-Smtp-Source: AGHT+IHAOnv7oc28ECrLbwz3MYtI2XlwEqYRbMn63MqyesZiRUO48orsjcjBjVWP4TAofwPjbOtNpQ==
X-Received: by 2002:a05:600c:1d08:b0:42c:b697:a62c with SMTP id 5b1f17b1804b1-42f521ce1a4mr63796565e9.5.1727517933542;
        Sat, 28 Sep 2024 03:05:33 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37cd575e322sm4431080f8f.110.2024.09.28.03.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2024 03:05:33 -0700 (PDT)
Date: Sat, 28 Sep 2024 13:05:08 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Jie Wang <jie.wang@intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>,
	Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Adam Guerin <adam.guerin@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: qat - (qat_4xxx) fix off by one in uof_get_name()
Message-ID: <cca43549-7715-44ba-a1c0-61dd027ed3b5@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The fw_objs[] array has "num_objs" elements so the > needs to be >= to
prevent an out of bounds read.

Fixes: 10484c647af6 ("crypto: qat - refactor fw config logic for 4xxx")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
index 9fd7ec53b9f3..bbd92c017c28 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -334,7 +334,7 @@ static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
 	else
 		id = -EINVAL;
 
-	if (id < 0 || id > num_objs)
+	if (id < 0 || id >= num_objs)
 		return NULL;
 
 	return fw_objs[id];
-- 
2.45.2

