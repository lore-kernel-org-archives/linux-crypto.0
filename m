Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C5615CD49
	for <linux-crypto@vger.kernel.org>; Wed, 24 Jul 2024 16:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721837388; cv=none; b=dn7JGen5XHz/aZRq5iwzJQXZZH2GfcOenPUiN44zHgnLGWbJRetp+WDQ/RTNJJ94ssaeZoBo6FgF3FtC7mhgRpokikzkogBU+ye+QePQPJczRhd2wMLF5+v99qqRbZMg0K6bx0WNSNeXdffoz+Kj0WuMy6GHRx7zMmTthAbm0is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721837388; c=relaxed/simple;
	bh=irBx30ZH81Fx6HQI9IkJBrgeBdvBm9pERG4FSMQxMC8=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=KT8reT+ycekxBEAx4TGdh19j9vjaX2iMt21/IyyiJzzmgwbgcgMqMlal0kN8U272xqs6MlYq6jWBkoi9xi15RMr000PErfhmWlni8UYi/nIp/Xykt58Rj5qDr2llbiAZ0HHBKAM4jJUPc8vxVaKYd7AUI0ptDgdvUIwre7QCgmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wP40oO2d; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wP40oO2d"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5cebf0b37fcso11912eaf.1
        for <linux-crypto@vger.kernel.org>; Wed, 24 Jul 2024 09:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721837386; x=1722442186; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h1PBLgIHK487Z50PNrv9ADUF0TlVhgZyaxmIow0sPp4=;
        b=wP40oO2dBS+rjR249dRQfWx3BLWseJVbRKHlmZDoZNNgA3PmgBDWGL0KPs5p3GMdIJ
         0JxTlp7O1RdTlyVqDaBaG4hlpVlmZPCvrFYDZCWBaF9kVlS/Y11y6dyRBmxWooIY/T3S
         uLDfNqMA6VME/yyhPNod3SGKn3jSGNU6VwtLNYHAy2Ipgtei6pnbqRl5aO9JFKmCjbzE
         oS4/Jom9JqXor9QpwyBG2EcMpNSNU5SoYSqrIu7/+Dot9NRLwZ/Z/NXIDdf3uFD89sjV
         FDr5wFd9oDQ36mp8fadEnPVMmc4ZwJme8Gh7rDTMPvmfHssN7XsysRq92PJa+Qm4D2Od
         suXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721837386; x=1722442186;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h1PBLgIHK487Z50PNrv9ADUF0TlVhgZyaxmIow0sPp4=;
        b=JtvHCgg3gHsEU0lHa7BdiTibAcXDpAXQ6tSH427yaeBhdWDfNKOwhojPz8nLjv2WUG
         ahFV4kYoVb/fmu670lbCANx5Myo4vbqcvzY+6sH3BF0DaZ9v7I4f4Ela9t4xW0ojxS2G
         M6lU94FbCp1XdTgt0eWbgh4OY90mjraU/55ZQjaRmeH6r/Gf9IXMekL8xpgJ5CYF4IG+
         8p4HQgFFGpkAGf5cLSY+6YuCwLNWwosLrfPtqbuCVziBhAcplWsMbjX6jXruuDuQ20Qv
         pYK52Xpon1aqOI+mnCNRc1bHjMVYWRX0AfxdWwgCuPjfbpkHIVImmhmuax7gy4r2Nx78
         TBYw==
X-Forwarded-Encrypted: i=1; AJvYcCVobZyDMckxIdF6fScZyLWaLIKt1xfcOzAPlXztDjCgpnjxkwHUVNliEnc0ZhM2B5uh15Xa3SH1Godu+/9mpVPtArhCLct3vz4IHEes
X-Gm-Message-State: AOJu0Yy4MdBZIL85OTaYIzMqChA0wCqkUse7hQrpHd6EHD7JWf6puXP8
	WfbfNFJF1ssaXnvZBxDoOoK/wCjrWVEfwlcYleP4YjAwKI5PPpTd9pJH8EnDKRw=
X-Google-Smtp-Source: AGHT+IHFom7KvpfbYKrPK/1mGnzI+CArrRK1rhoQT2jftUr92K4IlDd8GEMZkPh8yOdOvyQOSkETJg==
X-Received: by 2002:a05:6820:200e:b0:5ba:f20c:3629 with SMTP id 006d021491bc7-5d5add05fd4mr387041eaf.4.1721837386161;
        Wed, 24 Jul 2024 09:09:46 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:23ae:46cb:84b6:1002])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5d59f07e534sm364151eaf.43.2024.07.24.09.09.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 09:09:45 -0700 (PDT)
Date: Wed, 24 Jul 2024 11:09:43 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Tom Zanussi <tom.zanussi@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] crypto: iaa - Fix potential use after free bug
Message-ID: <e049271f-41f2-4d04-ac69-80186f2eecd9@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The free_device_compression_mode(iaa_device, device_mode) function frees
"device_mode" but it iss passed to iaa_compression_modes[i]->free() a few
lines later resulting in a use after free.

The good news is that, so far as I can tell, nothing implements the
->free() function and the use after free happens in dead code.  But, with
this fix, when something does implement it, we'll be ready.  :)

Fixes: b190447e0fa3 ("crypto: iaa - Add compression mode management along with fixed mode")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index e810d286ee8c..237f87000070 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -495,10 +495,10 @@ static void remove_device_compression_modes(struct iaa_device *iaa_device)
 		if (!device_mode)
 			continue;
 
-		free_device_compression_mode(iaa_device, device_mode);
-		iaa_device->compression_modes[i] = NULL;
 		if (iaa_compression_modes[i]->free)
 			iaa_compression_modes[i]->free(device_mode);
+		free_device_compression_mode(iaa_device, device_mode);
+		iaa_device->compression_modes[i] = NULL;
 	}
 }
 
-- 
2.43.0

