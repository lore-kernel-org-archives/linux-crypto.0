Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A769213DBBC
	for <linux-crypto@vger.kernel.org>; Tue, 26 Mar 2024 20:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711484653; cv=none; b=F7EY+B5KRgDYLWEezbLcZrxViLGt1NM9jmGZql6m28oO1wO2PxWqW1muWxMClszNXVcvPepRBjkoGRNxWDzDUQJ9DbFYQWSHfGXY2XZlyu9xjuLH3a4NMhIJchI3s+bW7cSciM8OVcdzVnnGBZWkzJytMCYBxq4YVWbjYdyqZuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711484653; c=relaxed/simple;
	bh=dLMLqJMRutmhpAj9QPWjvHyuzryPfsbXssGz64hwg7s=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FSjhtDEn+/ekIkbgXC0vkIf4FD/g8suGL2uTySzUl/op4qlHd6ac3Pkym8XIzpwekwleKVMT3b/sqp5IbHwejl5azvGlGRmv106qxH6eJqO9MO2fSbUHiX6ofcw3j46RzCgStjV2PK8YrxUoc308aQJBulMtjO0YQlMpvbRceq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=msmNa5+W; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="msmNa5+W"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a468226e135so714164166b.0
        for <linux-crypto@vger.kernel.org>; Tue, 26 Mar 2024 13:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711484650; x=1712089450; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MUoAEonqbq6mZXdrDqe4h4/X1Y47oOMjA1M1PU77dgA=;
        b=msmNa5+W1XY79AFfcKzvMG7gD8ab5FVtVAGSi8KXKAn2eBLpQDF/8X/1LJuOXkPYHo
         ic7tzv/JC/GpLeeCKaAmB6RyovFa65q8RqerqijZTGoQQhugk9oMPo/CiHyGJvnPE5Ok
         nDfbV7j7IFRjG1waaewVtOp2IUUNX6Ar8UlkwHQdplNtjjHSiRbWwbU1oVu1SdRioAX0
         0lfPXfTVZPmDgy1I5eDbX6M56umJRvMF44F0LuuwC7/20z0ZmhEmxl08nflcdBEzpWaS
         KkEbOkT/wRiD7cIjpD5Lm0y9GuVCxSXxspBqnIMyKSyIwl00rjs82e7OSoxHbpYr13UD
         8Gpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711484650; x=1712089450;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MUoAEonqbq6mZXdrDqe4h4/X1Y47oOMjA1M1PU77dgA=;
        b=EHOt7vAdwJRd9IgiMa5uRCsSkHRwF/Lf3ci0yrWmDpjSh+7ClugB4t2uXcb3zxx9Eg
         Sp3NEL7lh8D28M5mshHf/WNCHD2C9o2RkuXnYLK8tlsvByvnkkFouwrwMF8ut/LYDm1N
         J25XZcSi5YIfI8f14xEYVt1yWWwnlPWWhzWsWK6mFQzA3Sn6sDb8pypgsii1DiXVLn7O
         N+jXfB2CJbqXyYIexguCC8BDTXHy7p5ycQHQ7Yl2cb9JNrzjwe4NK6y+BGgTadCW2OjS
         T2HarNDBf+EjIKn6SspV+nHZv7b2be/MeX+37OWz5YVSwC7jgVxBO4qpll6j16kHwzPe
         UrYg==
X-Forwarded-Encrypted: i=1; AJvYcCVl/xbdleSDRKAIpv2lmWzuzFk7Rx8R8gWr151lp0Fi1aXkeEn2aYFuQYMDyr5hDTMcIGIKB1H8REUXwJaz8A7p6fNUcfSbWrSvGFC1
X-Gm-Message-State: AOJu0YyDx7RtKHxrwqp6G9xiaJfWSAfTH/6rHTUZHbWCVBRGBB2BrZmM
	4IAkEhlG1bguiv6Qx6D1FiwaQ50Bf+MokyWPI12O8zws2arAEPlOIjCqZFtJK+4=
X-Google-Smtp-Source: AGHT+IFktIMOuGQr83iXCOXqE8Qfk01qdlT5fhCvZP9F6Upy1Aunb2VLAuZdlUWX1tsm3QMok6//tw==
X-Received: by 2002:a17:907:868d:b0:a47:5351:e8a8 with SMTP id qa13-20020a170907868d00b00a475351e8a8mr3611593ejc.33.1711484649819;
        Tue, 26 Mar 2024 13:24:09 -0700 (PDT)
Received: from [127.0.1.1] ([178.197.222.44])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709062b4200b00a4725e4f53asm4584492ejg.40.2024.03.26.13.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 13:24:09 -0700 (PDT)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Date: Tue, 26 Mar 2024 21:23:35 +0100
Subject: [PATCH 05/19] coresight: etm4x: drop owner assignment
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240326-module-owner-amba-v1-5-4517b091385b@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=773;
 i=krzysztof.kozlowski@linaro.org; h=from:subject:message-id;
 bh=dLMLqJMRutmhpAj9QPWjvHyuzryPfsbXssGz64hwg7s=;
 b=owEBbQKS/ZANAwAKAcE3ZuaGi4PXAcsmYgBmAy7PqZxAqSLMTcZ+iIF2WgxJbOdjAERugmhHY
 Ri9uz+X3quJAjMEAAEKAB0WIQTd0mIoPREbIztuuKjBN2bmhouD1wUCZgMuzwAKCRDBN2bmhouD
 11YBEACKdHpjBts0bi85xrrB+V5bm9+C4a6btkKtB6exqkvpm4CJ6/J1wcZaqXuGclO7BcdfjMl
 Wfw+1cBXtd0NrHO0VdsLJe6YLD9lvVPx2MufQK9ZxVODxsQ/DONPj4t7bhOG4f+Q4yspNCN2a6m
 rdIx3+WzHtym438cEFWjgJuGtbFIDXHwWXPlo0Po+q3EHnvj21GGEO6yFP4zQGUTmKajdk1IASV
 FZVy5GpeKJ1K2KV8l8rCd+tYMsK32cWOgIUQGvExNx75N2Pm5Ac7zoUmbYpfL2ELwwXacdnw15N
 YkMnKu/VoXvsQ4gPjqyrviCQiifoPEV5O45ywNGJA2AjmEFdU9CMzJsxhoSa2OKchbgpy3sLjhB
 dvD9oBigcYn1nmkv93lRanSpS/lvGIOHbf2JWd/jblCUX3TVFUCibn6bicchBLObQH6VWD2+TPc
 Y0+nGtp5BdsRosXAMD3STQy8PZ+qo0K+JJ7tHHreyDspmRbCuel9ZlJ+Rj7htk4toMx5Nx3YPJE
 TvqW5MMDyOtqGWsSzuzvFG3tgcSiWZSwKRNt7jYKyfmMQKSQmFs7j6dp5iMNGqtlmGh9LP+SAa+
 aT6QiowSX4npz2oDHTUwakI4hcjbRDz1lt9HcvbvjBeabKhZcLb/SAsuX7VuWZxNygOkk51wrXG
 vYYXvPCZhk/EFLg==
X-Developer-Key: i=krzysztof.kozlowski@linaro.org; a=openpgp;
 fpr=9BD07E0E0C51F8D59677B7541B93437D3B41629B

Amba bus core already sets owner, so driver does not need to.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index c2ca4a02dfce..e6cd9705596c 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -2344,7 +2344,6 @@ MODULE_DEVICE_TABLE(amba, etm4_ids);
 static struct amba_driver etm4x_amba_driver = {
 	.drv = {
 		.name   = "coresight-etm4x",
-		.owner  = THIS_MODULE,
 		.suppress_bind_attrs = true,
 	},
 	.probe		= etm4_probe_amba,

-- 
2.34.1

