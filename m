Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A957319E7E8
	for <linux-crypto@vger.kernel.org>; Sat, 28 Sep 2024 10:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727517948; cv=none; b=FvFIBRZ6l+FpTSNX+IAr7Fvu2Emlf9fzIIEHyqz24LliKdfXQnWy95V8OWLEm9f7Ltx0NiwnKGb5ixyhoGDIf/xUSoZQHTDhQbxu2OeMY3iC6N/FQXTbKfNRI+yJol96OzA2iWOlVg3owgZIBsuruVR3iKfow21I5SnJywzj0ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727517948; c=relaxed/simple;
	bh=Fhj/2WAgRX6TZNq4s+b672pG6RSzJbtSTQ4lNixnLGY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pAkZhi9O+XuB0/F75Li0jgqsT+PpYuQQy4kOcUT9DwKEfnaNU1/a5rS8skbZ1iz6uyh91+s97qnuIn84F+w46a61VbFuSJMl31T0lqgpbvz1JRU94py4BXZuW437/+cZc2K9F0KL+KCWERetRL0PAhPxVWDsuCqdvDlrgrUZ/T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o3HdzhXn; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o3HdzhXn"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-42cae102702so22441135e9.0
        for <linux-crypto@vger.kernel.org>; Sat, 28 Sep 2024 03:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727517944; x=1728122744; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wFXnq8tjuGE++NF0IRFhg8u5PXx+L4dCmmjvPjHBwaI=;
        b=o3HdzhXnPH1LpR51MzYDBAiJA6/5cRm2VJR/v0v9YpbfHcaf6GES4L9riF64ru572b
         2lmmjUDWPxwnCZEnmu85tpo/RqFuCAaSacVyONl9evKLdHRoVePv3W/nP1NwrBaaFNms
         ghxXQfuTQiqKUySMbJRaKW13XzY3dT55VU5PQttiNJsKgp43Tqo7Hxoo0KECndUQARSH
         uty3cxnnanyT886dRCask47aVrONdQRItwj0C3jyHDlrDWCncSMdxAckPQHsLHzTV5RZ
         zOsJls1LNOKNQ2VY4zJYye6PttLoSx64abd3vsBjl6wHmbVljkH/Zsy/en1t3CIkZ4MO
         K+4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727517944; x=1728122744;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wFXnq8tjuGE++NF0IRFhg8u5PXx+L4dCmmjvPjHBwaI=;
        b=JgTD7Pp2V4Be4YZZvqYlykbtoI1Trr5zPX8hSEIJIGg/QFeM9My/sLucHQGCu2mlGJ
         RnvZZ0fluQQcTFNJzY/v3RVcsvQ22GFheMmzdEmyWhPLyXx6cqTI+rFciuhdjupKGFqQ
         bg1ngQ2gLVta55IrLT3GJIgiFVnsN8sWk9bIcFfu6Mq9LfmpZmfHIFw7Ez9vo8Kheojj
         o1bKqIaCIJoBbf+7JFd0lZa7CDAwlsN0sfqEXEPcURhULp6ANPqDOVDIjVDpEZBe4D1H
         8A4UsgBAH2MC8yy3ZbDoYsTJ4/taVdbEd6N5qS/5cVd57ye8h88zQfhQNlZAH0RNzT87
         NYbw==
X-Forwarded-Encrypted: i=1; AJvYcCUFqZmxI1g1zIWvuSAagP34jWyk21CU55znHXjtHZBCyobHIOwApE9fmbHWmr11vgl4DF/6Rq28z2CWVGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxN+vCQIqlWAhbWUrtEepSXUa/CsMBCdOZd9AsptXujzhblHoSS
	8qZ3vGDxRhXkrgkpCw9uBe1RYxSDxr3I34OhddYVvsXWheIYE74q9s5RFs2nl+M=
X-Google-Smtp-Source: AGHT+IHZBI2SeNYmPuzbzS4OIpWMwP4GQ7Yg15aONo1+6wQnhIL+THchIfM5hb67RF96jt8tGxyVRA==
X-Received: by 2002:a05:600c:4f8f:b0:426:6a53:e54f with SMTP id 5b1f17b1804b1-42f5849101emr43200315e9.33.1727517943974;
        Sat, 28 Sep 2024 03:05:43 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e90274aa0sm77268275e9.0.2024.09.28.03.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2024 03:05:43 -0700 (PDT)
Date: Sat, 28 Sep 2024 13:05:01 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Jie Wang <jie.wang@intel.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Damian Muszynski <damian.muszynski@intel.com>,
	Tero Kristo <tero.kristo@linux.intel.com>,
	Shashank Gupta <shashank.gupta@intel.com>,
	Lucas Segarra Fernandez <lucas.segarra.fernandez@intel.com>,
	Dong Xie <dong.xie@intel.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: qat - (qat_420xx) fix off by one in uof_get_name()
Message-ID: <796ecd7c-54ad-4bec-b748-3e156cc0a1aa@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

This is called from uof_get_name_420xx() where "num_objs" is the
ARRAY_SIZE() of fw_objs[].  The > needs to be >= to prevent an out of
bounds access.

Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 78f0ea49254d..9faef33e54bd 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -375,7 +375,7 @@ static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
 	else
 		id = -EINVAL;
 
-	if (id < 0 || id > num_objs)
+	if (id < 0 || id >= num_objs)
 		return NULL;
 
 	return fw_objs[id];
-- 
2.45.2

