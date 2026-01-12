Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com [209.85.218.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2447235B158
	for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 13:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768226002; cv=none; b=O/dqXP1sWZjKr75CCtcGeBoYzJYIslC3L0S98CCfpWuspfwS2QwknrFAl7ra6QcBWt3e9vmkmZtEJ39jikOIsIe1Xp4j2VUeJbNZZlDVqL3jkBZ6C5o1GfU28Cz1qE+YXgmTwylRUNoVk4jbrwyMoV4R8c435vawx+j/GjitYDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768226002; c=relaxed/simple;
	bh=qxN/7SFXQgGYehqBL9aUXI1J2mEyleNlSfDJOc+cUfo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QsuWqzKzrEGHp1x4CR8BNUHIRqI+jM7DXf0ZK0/ylxKzdrwWDFQzLSNny9U2L0PwgMdMDNY8yjG5MfVuaqj+4F25VC6Q7tdr/HIVIkW0D4rKAXggCfzhI+SXHkTlQZGf7hke/K1DdSlqOXIt2fzuFhszMgDefGHOQVd5n2TFvik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=Ci5jx4i4; arc=none smtp.client-ip=209.85.218.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="Ci5jx4i4"
Received: by mail-ej1-f65.google.com with SMTP id a640c23a62f3a-b871cfb49e6so147474466b.1
        for <linux-crypto@vger.kernel.org>; Mon, 12 Jan 2026 05:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1768225997; x=1768830797; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p6GBn7KiZoLHRbB+eXZ1LBCN30jAII3dIqXdIjZE+DM=;
        b=Ci5jx4i4kBvNw4Um7TQF5M4EvSRjawQQMfERBEl/Hozpiw2R51VjDR68WDTw6MKTYh
         wf35WKtTih69BRNEOJXrGdpO8NLdOgsWQSeW0hDs2GENoeJnhjRVczN+fGyJ9XiejK0x
         XrWMaWQV/wuNX1lKPgT2fBGbZJSqAF+e4YTdGpCOTdp/gzoqTkQYhbwTOtHTK45t7GCM
         PMEpzwWZ4i/7xo+AlxNd6BzV9HoEJAJjP2eubryW9H8H7sRVfVNl6DIG+UVjY1/+c1OJ
         okZfo5ftkT5sPmH7r3knud0XWnYp9qkCEkg8rrW2iGRTWij/EC59VVn9BNaUgjKY9cy6
         sEtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768225997; x=1768830797;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=p6GBn7KiZoLHRbB+eXZ1LBCN30jAII3dIqXdIjZE+DM=;
        b=Xip07vHEPXKDorgKNh/E7DfVmpTm4bv7EduLMSFfCOUhXgp8GicLA4UwesZqNM1y1r
         VB+I+CN2BbqkCzA+WQqIt+qufxfPJdQarYBloePL4K/1So1dznZ13Hhd+zXuul30LpPy
         f0eTxm1jTLngb9drLPxeKumbPy4miFhq5f1knWmXuCqiNx+002bm2kxewWCjGSLQ92gW
         /WOFOJgcY/WVk+FXZ4VIrfQnEH+9tYn6GLQXH2S3BvJtHJV+x/uSy+EzV+t8d3YAS1Gc
         7PWhaWsl0r1hyfvEDcmz7U+Hq3SHTyeVZwxTF92SteXKQOvPngyOYrMsSSwrTHEzLOK+
         E7pw==
X-Forwarded-Encrypted: i=1; AJvYcCW+uQr8OGPSb7gGKHJoGBqE5YEA438aV0bMvaWi4CJL8pZQAbR5Z3NiVKY5SguUmezzcYqDTq6GVK4ZcjM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHYNW110mXsqCJ2Mja3SsOK7jOOO98/rT4czihgQ/1DXyDV42s
	69gMmIAUIzYGshojqlrHZdT4jMnpK7us1k21vR3uV4IGGMyZr3M29rMg6adFMzoHw+s=
X-Gm-Gg: AY/fxX6zf0PHsSYowHpTRaZT9QrWSE6ccg9tRm2czPNdyVW6gdK1aJk+Jg/qvIx9cBN
	dAIXhkz00pqHkUEK6iHHSj+0fpcO9g4H+dX2j9PJ35JGVAL3BX4sXMLpTXAv9kEcy6ml4Z9j3Cc
	qsvmhpoyAW1vMJl/xu+knilTCgMXNOkJtzZL1eK/c7NQDZhiVh42vTANWC5aTeAEWXCCrxKLJqN
	GskJ/ssofEGKOxRRVQhwjVZDCAHGEFrt/Eh4CZHLOuiHgzksy4QTai7wMK6msct65HRkTtF4OP+
	nlnNrj8ch2yhS2Rm4WE1XFY3EgMa6gl18DA0winbnYsIxmHyVYbZ/MPYifuDnOoNOobnFdRbvff
	jbkjmq6HowgJpHUWWv2Xk3s6RTsS7bxgD3AOrAAH83ZBxkwOmOdJ5x1L5axJN99seg/K+6xCNSD
	glbJ3eDDEQvAOdSqA0qCOaw0WKlhf6eJyElunhnQIPHblLBAWj1ZHrq9D6ano5pUOI
X-Google-Smtp-Source: AGHT+IEd+nXuoyJH7y+5irMovJmQYLD5UodxDOlxMBwAbUiTSj+cIGE3y+/oEJNpNUV3FWxwU1bJFA==
X-Received: by 2002:a17:907:3e83:b0:b7a:32:3d60 with SMTP id a640c23a62f3a-b844518a88dmr1900919266b.11.1768225997580;
        Mon, 12 Jan 2026 05:53:17 -0800 (PST)
Received: from [172.16.240.99] (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8731f071e4sm25700466b.66.2026.01.12.05.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:53:17 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Mon, 12 Jan 2026 14:53:14 +0100
Subject: [PATCH v2 1/6] dt-bindings: crypto: qcom,inline-crypto-engine:
 document the Milos ICE
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-milos-ufs-v2-1-d3ce4f61f030@fairphone.com>
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
In-Reply-To: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, 
 Bart Van Assche <bvanassche@acm.org>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Konrad Dybcio <konradybcio@kernel.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-phy@lists.infradead.org, 
 Luca Weiss <luca.weiss@fairphone.com>, 
 Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1768225995; l=978;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=qxN/7SFXQgGYehqBL9aUXI1J2mEyleNlSfDJOc+cUfo=;
 b=+6y4wusQhtRueAHKb3ZVs4ptUD/5lU0HvbI8iylXgKJDlb89tUPOMEzoqIO5WEYaPfvbSmSYp
 Pq9sp8tM9qrDpSD5sTGW1dElYTST04D3dJj3ez+bzIGdUXXzHTuaQbM
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the Inline Crypto Engine (ICE) on the Milos SoC.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index c3408dcf5d20..061ff718b23d 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -14,6 +14,7 @@ properties:
     items:
       - enum:
           - qcom,kaanapali-inline-crypto-engine
+          - qcom,milos-inline-crypto-engine
           - qcom,qcs8300-inline-crypto-engine
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sc7180-inline-crypto-engine

-- 
2.52.0

