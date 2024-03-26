Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8701D1422B8
	for <linux-crypto@vger.kernel.org>; Tue, 26 Mar 2024 20:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711484678; cv=none; b=sbPxVqjK6ZZOEPx93HzgYx5/XU5WDkMrNey1t0R+8JmpYDJkmmHF0WmZeYR6AJDhsFXlU/3W7lPFvU9tYdjRq7mbzqwZWCGpe3bAxoP+0DAQRzNrFLbKYwvNPxJKDF7ykiFdaqjRx311r3iMjqrUcJ1xCZpD4+566QYL37SQoB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711484678; c=relaxed/simple;
	bh=Ta7dMGxfM+ocB9u+vXfdOUVX8tV8+/0NM5Ti0pD7XdA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Jg6nfh1WDZto85+kuTaweAXhR3Ubj0VIJkD+j2TuBPZyiIjuvBYlSczM5KzPcRWzej6sWhPVv6iV/SF7jHeqnXhEGZwfLHS6k48VUMq8S7j7QQnfIj8EMSip/VxXN4NYiusf9pgT6wxMzhcMKkmwqGfn9je2lb+cadv3zKfKguI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jLuUJgiG; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jLuUJgiG"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a4a387ff7acso313384066b.2
        for <linux-crypto@vger.kernel.org>; Tue, 26 Mar 2024 13:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711484674; x=1712089474; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=alqiTmueEmAg/AIj/9Zgn6IQWkZkzik70i9h3A4UH80=;
        b=jLuUJgiGb44Z3xzHaaqoE4eWbr6I/U+MSS4HobHYMLZ6X+niPFs+eZlnNjkdPSjXZ6
         MJ7d5hYtn6X0dLisu70Vvsl/wZAWJCF88+6VZyoaHXEwkVD8Xom1g2wdVxj8mWdbsQA+
         ATxFEgPw5OvuuJ36vTJs352QKj2VpGO09FxA1NpejqwcPXc1PJWE7ecvq4t1OXHHtdiz
         kJSFNTeN7+94XgOzzbIFTJMJXhNdBJ3ytFHP7dVB5E6gacI4Dbdto4T/dt/2NYp9B0tu
         yOjeNPRPjK4iLZuwq8xl/X3U5rlKNdw1EtAOvq8Wpx8GP3UQYV7Niu7VWUQ8LGwNJQQK
         X/ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711484674; x=1712089474;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=alqiTmueEmAg/AIj/9Zgn6IQWkZkzik70i9h3A4UH80=;
        b=TFzRFSHPTSMXuzgC+yAlAcaoXtgNII2MrZYtWP5gqj1N5aNlgzA0OQfws0JjwcbAGR
         kIu5vscKzvjam5B/o95SDKnnpTr8GVE3bgifqcd1L+lg6djqFraJGq7JvsARylvmHqpU
         9kMRfJL6Lfxe34n2jxjQg14w6OGEbZaal+JwZZxrWY+nTLGzmBAkEHEgJSuldkRBke07
         IZiQRPpjrlMnpJAFGni95KdC9xyxblDAVvb8v9xI0qqYWXBZo92iOQEtagGmvucsTFPE
         VBIQEFOJcb9f3YW+QL/KN5PniG8vdFrU3vWaf7NgS3dGbHq99+WGt+zo+5yoZphNCy2y
         2iQw==
X-Forwarded-Encrypted: i=1; AJvYcCXBLGrjhRvTB58qAE5lOVxuAcOYiJ4j1mOghV0SvhG/M4fD4hXeyago4Zy6LbOctLahr07SjFN+6ISvlaf0/yPSvKM7H4lzknaVSS1A
X-Gm-Message-State: AOJu0YyVcEu3Gx9K1XTjQv+WsE5tvjQE6Ot07+nI7ZbNk+EAPe2XiqZW
	SDzkT58u+mgZ/w11fsZP8wFA9IAQyCNg+AC/ilnerNh+Fz4tS6uSf9YFQosljHY=
X-Google-Smtp-Source: AGHT+IHcXArE8HWSima7kQCTo8Zh8a6512FMMnxEs0jZ+4Tun1wBY/K1UeynxI769U408lVxmPNjzg==
X-Received: by 2002:a17:907:9485:b0:a4a:348c:de85 with SMTP id dm5-20020a170907948500b00a4a348cde85mr1945727ejc.37.1711484674669;
        Tue, 26 Mar 2024 13:24:34 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.222.44])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709062b4200b00a4725e4f53asm4584492ejg.40.2024.03.26.13.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 13:24:34 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Tue, 26 Mar 2024 21:23:47 +0100
Subject: [PATCH 17/19] Input: ambakmi - drop owner assignment
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240326-module-owner-amba-v1-17-4517b091385b@linaro.org>
References: <20240326-module-owner-amba-v1-0-4517b091385b@linaro.org>
In-Reply-To: <20240326-module-owner-amba-v1-0-4517b091385b@linaro.org>
To: Russell King <linux@armlinux.org.uk>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Mike Leach <mike.leach@linaro.org>, James Clark <james.clark@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
 Alexandre Torgue <alexandre.torgue@foss.st.com>, 
 Linus Walleij <linus.walleij@linaro.org>, 
 Andi Shyti <andi.shyti@kernel.org>, Olivia Mackall <olivia@selenic.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, Vinod Koul <vkoul@kernel.org>, 
 Dmitry Torokhov <dmitry.torokhov@gmail.com>, 
 Miquel Raynal <miquel.raynal@bootlin.com>, 
 Michal Simek <michal.simek@amd.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, 
 Eric Auger <eric.auger@redhat.com>, 
 Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, coresight@lists.linaro.org, 
 linux-arm-kernel@lists.infradead.org, 
 linux-stm32@st-md-mailman.stormreply.com, linux-i2c@vger.kernel.org, 
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
 linux-input@vger.kernel.org, kvm@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=718;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=Ta7dMGxfM+ocB9u+vXfdOUVX8tV8+/0NM5Ti0pD7XdA=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmAy7aviTUj8gNeRULPo78u6NzYKWEuNAxixM5g
 1brrNhkeKKJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgMu2gAKCRDBN2bmhouD
 149rEACFErbVZNJvYJJ4zTI/pfIloCtN3b2PLOn4hdxERvwt0Fcxvnf70+h6wrxDqeL1+iVqeTd
 gI+udxC0c9YS4SLblMYjdM74HVn3WRJBwuAK0FhgR44uyjqPsOZWxqq3nlAhnbpkKdCq+MNIQm6
 ZTlgd2GOGklxffz2IXrrzqZE3OmTsrsiTw20xqsi8e1aPXm73ompP7O6akxen/sx7I+jrazKq1k
 4W/OmVadyJzXiZjnhjl8ZONonTTE8RRlBCFn1hYkxpunio4OAkc0O0HW6FQL9T4GX02u9wTHtx7
 97LTwuyaf29bT/njgMgh0vLYeUFUpDOweJu3otuz7v+llEWqhhKDkeNss6gthZLCRWs7Q4aEVWI
 x8glER0d8nLfdVPqOfq0dVX9TDwEWEP5VJpxvfeNNWNyQq3KIOYZrjguurcOTx0i6PS4PtpaDMM
 JgOGygHunm6kLgUvN0ggRF14ULbWgpyTx/O57Be+5Yb8jLLcgm7N4B1RG4UGxfOCg23hBV8TjJ/
 v7zdaGBPtGSxE8bfVS0dBHV/hjZTwOiijtbGb7zIJKyBprHq7+riBG4h9/bMDMObioVyq0ONsmk
 1nrHInNQzMtNUpB733sAn6TbKmkPnxKouHHApzDWxHIXUjOWEthOW6JrCfKu8UHDiwRK+UoWCgO
 NUsugnnqQSbcCXQ==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Amba bus core already sets owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Depends on first amba patch.
---
 drivers/input/serio/ambakmi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/input/serio/ambakmi.c b/drivers/input/serio/ambakmi.c
index 8fbfa448be4a..496bb7a312d2 100644
--- a/drivers/input/serio/ambakmi.c
+++ b/drivers/input/serio/ambakmi.c
@@ -195,7 +195,6 @@ MODULE_DEVICE_TABLE(amba, amba_kmi_idtable);
 static struct amba_driver ambakmi_driver = {
 	.drv		= {
 		.name	= "kmi-pl050",
-		.owner	= THIS_MODULE,
 		.pm	= pm_sleep_ptr(&amba_kmi_dev_pm_ops),
 	},
 	.id_table	= amba_kmi_idtable,

-- 
2.34.1

