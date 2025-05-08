Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D92B1DE3C0
	for <linux-crypto@vger.kernel.org>; Thu,  8 May 2025 06:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746685593; cv=none; b=Lha4auk9Op1nZguwts10Rglc0FWwJUjpqBpHAX0YGjHXRcKTtmyJSJAZsdbvg5GfSeI14fwJg2wm8Kw6aN6ZXQll6noUlwB093d+d4DxhvAEebga4Qvyff4VxbZplBuRGQhOEyEzo3Ah7ikqO+6tf/WzMHHsdquKiXKU4OaoNjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746685593; c=relaxed/simple;
	bh=RDPgm5xhma7QFLB18+5pqsvzgjikpNdaONSF0MiESTo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=L4JZjHbtqbsrXrM4KIT0jh09KYoemT5Dtxgt2Gy65um2MZ9V1cs6EMOWUAmhZFCkGVN8LSOlvOSzdDOUg79bHhVlWW+2DQ5qZF9X1d8DCRTU7EaaWjKbLiZxQu02Lir3Jv8jMY1V1l8ccv+J+B90exr58pm+KyhpWXYf8aif8A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fnS3IeSp; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fnS3IeSp"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3a0b6aa08e5so923816f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 07 May 2025 23:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746685589; x=1747290389; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vrj9ukkKygc1G8rKTTqLX2onZSR0aOFlnCDnYrntq9Q=;
        b=fnS3IeSprMBvRYeEMrUA2d8rKUtOZPD13FDaKWxGfIhU0WsZJvvVdKDKQMf5+7e1t5
         v206AGlMvxUm1T6Bq4Hf1SxlVefN01MJn3cmlFpGswzHy4PsPxeTo3UXlQUARs56Q3nb
         OkA223MdQu1harumoYixuEKA/lywl0gWJ6fn8JfhBiZTRmMrqMMy8mRBflCnZeuIP8rs
         noPQ0JBL0wTO7hbvdVyDo+VfAVwkxwA0/+2O5V2oiD1zIyQ1nDZo/uv0FYhwpnFLBxKE
         87M4bZgooqdYCK4kK1L17GSuoucVq7LSHeeV5KZq7oFG2xCaKeT/4qHtXKLIn54QOxr2
         CApQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746685589; x=1747290389;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vrj9ukkKygc1G8rKTTqLX2onZSR0aOFlnCDnYrntq9Q=;
        b=obOvB+miWUdu41BfBpk6tLhkGqTLJYJTc6016rlrVi3gnUtjAZMFvQwVJ1UOEQbjF8
         8KvNYqf1OCdCkBV5X2QNgmApfb7Nt1ZiPyrqv4t6atYMjfLHOGTk2weZXLolaWcMTSE2
         mAgDcd5EN005Mn7iw09/1V9PsuLfod4mIghjOfiQHvIs5Jl8tbjJsWYFUBu3qGvQcU8k
         BDOv/4/s52Jlr7zRSrlhTWP3vkZuUU8JOxpKFP7bOk3yI5hS84yiuGOBqswiOsRvUpcN
         jt8IhJ66/kZ95k44F1OQcpVrhdWXQenXBEuHiZuM0hHxYsVSXJWNJHYKf1TkEETuUahG
         S8VA==
X-Forwarded-Encrypted: i=1; AJvYcCXMl+wNRWPHsJRdbcsl5GhmkKQT98YjB1kTlF+VXDnnGpR7U02QhRvZXnYShooGEyR379JP4aIRff9DJjA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC862Ul8P6CfIY6yg1m1MO39xIJtKbwN6sdaxQt5vu9YLLlqte
	20WKjYkDRGACDhysreIro1UVxFOKPp2KSdoFgV9lRKWeQm2tsWqNVt7tO5QFNSA=
X-Gm-Gg: ASbGncvcA2Z1zo0OCxMy2Z3I65W8Ywe4nV3ji0SJaZhYh7Z0M0/NneUf0+1/9D1Xz+p
	F1zdCQ83Db9Aok1zttsMEtQaJ5GtedastT6nRY5WS1Owm+LMAnSvNrxYZdl+EPSzSshI/BKAV3/
	0qOfrM5isWsHl1z4h9Q3/wmvOkv3qzUP9blGOBErLTRAgM5kEgm18hJZivfo6ev6+oDL804ybMU
	M2QFhc8fQt55GyEz1jsdujkXokcI8iLw0GffNz2JaX7epSe1zQ7eo0jm8Cl5Hjnv5ZjW2/CtRGY
	QVcN7PzIhb/UqDU0VhWRigVFrw4E+/LYIuryqgPBPtiFsQ==
X-Google-Smtp-Source: AGHT+IFAMx7JUFXY3xA7TDuVFEdfH0Qfm/mO3IujmuFv9MragYBfI8mgTfu7zRm8OHQ8pIMC9sOyhA==
X-Received: by 2002:a5d:64ed:0:b0:3a0:b138:4810 with SMTP id ffacd0b85a97d-3a0b99171ecmr1632328f8f.17.1746685588890;
        Wed, 07 May 2025 23:26:28 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3a099b178absm19380008f8f.97.2025.05.07.23.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 23:26:28 -0700 (PDT)
Date: Thu, 8 May 2025 09:26:25 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Laurent M Coquerel <laurent.m.coquerel@intel.com>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	George Abraham P <george.abraham.p@intel.com>,
	Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
	Karthikeyan Gopal <karthikeyan.gopal@intel.com>,
	qat-linux@intel.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH next] crypto: qat/qat_6xxx - Fix NULL vs IS_ERR() check in
 adf_probe()
Message-ID: <aBxOkY99jQF7q-7M@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The pcim_iomap_region() returns error pointers.  It doesn't return NULL
pointers.  Update the check to match.

Fixes: 17fd7514ae68 ("crypto: qat - add qat_6xxx driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
index 2531c337e0dd..132e26501621 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
@@ -156,8 +156,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 		/* Map 64-bit PCIe BAR */
 		bar->virt_addr = pcim_iomap_region(pdev, bar_map[i], pci_name(pdev));
-		if (!bar->virt_addr) {
-			ret = -ENOMEM;
+		if (IS_ERR(bar->virt_addr)) {
+			ret = PTR_ERR(bar->virt_addr);
 			return dev_err_probe(dev, ret, "Failed to ioremap PCI region.\n");
 		}
 	}
-- 
2.47.2

