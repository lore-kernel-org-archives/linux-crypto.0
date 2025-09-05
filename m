Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7222FFDFB
	for <linux-crypto@vger.kernel.org>; Fri,  5 Sep 2025 10:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757068867; cv=none; b=edGnFqs7aPF3COge35tcrCllgbyO6kv4FW77jhXpLx+nuM0EksBdHViegGHHM+GX+G+b+z6BNqmltmEFt8ghM2oc5suDdyi2Xwt4rmP36O4gLO2qx61+y9fIgbE64+MoaZDTkL0DS3cj2A165LH4MRJ/7Va3YKqabC3BgkOB43Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757068867; c=relaxed/simple;
	bh=BsquXCSdmRv8hbIvUjTb7dUQJIWJ4+iHdiZoxAVtdRQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nAW7c7zgKSeuebAc+YQptHb27kCNhQ0/AAqV95uT3SEEjPIxh8NJGN9GaxMVdlqtG/nOFCGjZ0CUDsxNVlzYxvxUQoK0FZOuOdDtZIzDBpvfeHIQ32ZegVS+G0QenRawcWqmTth/IG6yUHvmlONJCPsURUMx7oYTzkd5UazFmFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=yUR4/P1h; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="yUR4/P1h"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3da9ad0c1f4so1348616f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2025 03:41:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1757068864; x=1757673664; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vq4GY2r0cceMRd0WxojTtWDxH4I3aOXQIER+mEWrZpY=;
        b=yUR4/P1hbCo9eoUFZPWYduHC/ELgVqflahkT8UskbtEV1IIvcy5HLCPfvmgNZYX9tS
         3NJruTXoUcfOFx9nK0yblOZgUxuJZjwbFpW8rDQNMDUNNX5rqHo+3TPXYxolwVb4iP7d
         SyxI487AbppQI3JaqKE6xL30A2bLwX4fvYa+GE9E2lbCHrGyK4fO3frBz/IRyTBBwVkC
         dzrWOZgU2Tm38NQ1LlzY7Y22H4+Z9AaUfT2Z4Usj9xAzK4Q5Hj2S3TvatOzIqONITksj
         VqG+BNv/I00lHQSqmBxleunFi+SXj7iZRkSizi6Hn2VIpWGr2ZaVtSCqiCirszvO0DVP
         nmbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757068864; x=1757673664;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vq4GY2r0cceMRd0WxojTtWDxH4I3aOXQIER+mEWrZpY=;
        b=iYcPc962QSOR4qRtS6PS7+P1WZW2Dth3b2o8oryyhAuEJWEKt5aAcF139OOzZppeT1
         tGA6juXuZ6yYathw9yZ3wTH492Y8uWn0vk8i5gWNZejpAZ68z/FR/9IhZgeTB+i/AR6n
         ITy0L69VuFgN50aOP/2MG5O2VHfyuQrZmA+I2B0PhLLSrhdkX4aPLdJdzNGa5FCkK9/4
         QQYKihEBnxU1rd/S3MlotRHZ4VIYI0RdwCTS6YlJRR5aQ9/SIztq1mmUOd28ivOHLMmu
         9jM9QmgVcjxq84wGnmYXC1i9T95huvxfceicSpb5Npiriu3XcFDdy1nfZs6QUg4Nfgam
         ehIw==
X-Forwarded-Encrypted: i=1; AJvYcCWO/0I9YKUfvuKNkN7gjECuql/HYFSyPaPEemz6fYGHYCZ9rNgC1eTvEA/C3WKVfb7GBwuEAjwN6ZuA+5I=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywif0+pPegC+EBZDq7mXf1bpzjAumsyTe8kmfqObynY55j3qU1y
	/7usFabDEPCuEU+iHOS8PsHfIkGO8U1q3V1F6mXDviv+9F+WNimsOm7zMeba3QiqbR0=
X-Gm-Gg: ASbGncsdX4u++YJMNJRG1TiW9AMvA/oIM3htAq642L1mU5xM0Zq2q6WiDYl4T+0v0O9
	VSsiPW5N2LVQXEfy+0VYp7Q4eB1KmY8GU6umPazdf7aow7CVMBBWKKnqzlW7iOwR6Mk1AuiCbdA
	jiEOaWue+rvEiKmf241jTOjkxlA9+1lUgkwO2tyqH9hrrDcQBzmpK76QaDJpSwRFHcHSVDvSvo6
	abfll8mQI1c0y2Vri07hf5kNq+CXrLizkNJVFeuVCZUtmbTrWLWwEXWZd3uiuN8UbBTya5uCu6M
	RYaXxBOvvkCd7eInPCqFGrgBn81K+RXA+mRu7hCth6pEwNTZLIyu3+qNVXxFN9syCxvfSuLnyeG
	/lbvset1u4se4DOCExWKfGvE0JCGyUjPUkXwcyC7omTLNxtjyYNnXdTrJ/y6JLjbk0WyIfLLz0h
	V2MelL+SLCO7CyDvwLRwRlfwJLNK/k7A==
X-Google-Smtp-Source: AGHT+IHG8nffzwD4YN91CRrTsA4vU+N2ZBbmAzmBwvrFMUoXDd0zamtpz6w9o1A53yZ3pJ3Fdfiedg==
X-Received: by 2002:a05:6000:2910:b0:3e3:5b4:dc27 with SMTP id ffacd0b85a97d-3e305d3632bmr2626788f8f.47.1757068863712;
        Fri, 05 Sep 2025 03:41:03 -0700 (PDT)
Received: from [172.18.170.139] (ip-185-104-138-158.ptr.icomera.net. [185.104.138.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d6cf485eb7sm20990738f8f.3.2025.09.05.03.41.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 03:41:03 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Fri, 05 Sep 2025 12:40:33 +0200
Subject: [PATCH v3 2/7] dt-bindings: crypto: qcom,prng: document Milos
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-sm7635-fp6-initial-v3-2-0117c2eff1b7@fairphone.com>
References: <20250905-sm7635-fp6-initial-v3-0-0117c2eff1b7@fairphone.com>
In-Reply-To: <20250905-sm7635-fp6-initial-v3-0-0117c2eff1b7@fairphone.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Manivannan Sadhasivam <mani@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>, 
 Thomas Gleixner <tglx@linutronix.de>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-pm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1757068857; l=922;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=BsquXCSdmRv8hbIvUjTb7dUQJIWJ4+iHdiZoxAVtdRQ=;
 b=DufvbWhWfijv36FttwJUJbmZnqswuL+O9y5KlTf3evp/rae9jPjUvTHmnGQuHkt4QK2UESAbS
 xuhpq1+V0Q+DzEy1kFhJr7BCq7NmiM9RtK0Ej98vvt2HYMjZaC8HrYH
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document Milos SoC compatible for the True Random Number Generator.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index ed7e16bd11d33c16d0adf02c38419dbaee87ac48..0fdef054a1a30c363e0d99518351fb18124904f0 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -20,6 +20,7 @@ properties:
               - qcom,ipq5332-trng
               - qcom,ipq5424-trng
               - qcom,ipq9574-trng
+              - qcom,milos-trng
               - qcom,qcs615-trng
               - qcom,qcs8300-trng
               - qcom,sa8255p-trng

-- 
2.51.0

