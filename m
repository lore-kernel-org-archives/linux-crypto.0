Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Q6L/gxFb"
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A74E3
	for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2023 02:00:49 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-40c39ef63d9so31053715e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 12 Dec 2023 02:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702375248; x=1702980048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cUVZQ/IYwAI6WZvMPjmfLWkKuvHpVKeTYMRhyrONudY=;
        b=Q6L/gxFb3FmCJ9Rc62yUUHCz1fi1AaxVY2RTavt3qOAr5vqjyj2QUBTBJx8cntZ+5K
         rfDb9ZN4f9j2sqfO3BEs4oE+gPa/YNgT4U9klHtugGCXvX9LOC+8GhhhJXqvI87IMOoG
         h8mUxTKwjFgC92zz0c7KMW0jZXVOYAY9TIhrl5QN3ZZ9xpwNGRQKtg90lN2lrmRgSvuW
         +ogppDyQcpl4L3mSlc8rY0w/2Va21k0KgLIoxjJ2JG3oudl3DK2BgjL+CCCs7/2h1L1W
         K/6FqI6LKG0WsddRus/6tVzixDjTuTJDO39jBQDtLGKU78FfrUWscYCBdNQsoDp8NMtT
         6Lgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702375248; x=1702980048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cUVZQ/IYwAI6WZvMPjmfLWkKuvHpVKeTYMRhyrONudY=;
        b=Nhn2YWyGfu5uEmoR6AOwO/j+3RYG6ZwObIomBJ8cjTEP8lIJqdDm+6C54SGDo/n1bf
         qj/2hz+5N7a//wdo09XLH0xe+hWI6ihhdlJOjb3kozkGl3GZ7cZstSFsYxPGYuVtFbS4
         anGkxyvUrxqSS4Cl/0MyVAvnLHh12eFO7qDAGeaObpfV0GHa1T68ElAnzQScqJ34wSA4
         Vg9k172rwXALPbNOw37StYohxoMsIGe8GihbTAWu2MXkWXIPUARPAvnxUpKyH2uwrvZB
         gHf5acshgaXdf2CXtHI8u5P6Q211Wf4r0NNWBrzIQZ0Adr0rtwuxOuOpDg68m2IU0vhC
         RtCQ==
X-Gm-Message-State: AOJu0YyyTZ2rxcZTdi8NjOx+xsKn+dQbSSl1MC5qQFiGHBZh/lUQlOEY
	tT+EUiY3MkPjN/W/5gyKP/vDIw==
X-Google-Smtp-Source: AGHT+IFr6GVYhaWHcireeD6R68VAGZ8agMs3iKkgcn39PwSI6e2bDEDPtZaXJL46wJHckm3gPKZT3w==
X-Received: by 2002:a05:600c:6020:b0:40c:370d:71fc with SMTP id az32-20020a05600c602000b0040c370d71fcmr2490188wmb.85.1702375247780;
        Tue, 12 Dec 2023 02:00:47 -0800 (PST)
Received: from krzk-bin.. ([178.197.218.27])
        by smtp.gmail.com with ESMTPSA id az27-20020a05600c601b00b0040c34e763ecsm14918912wmb.44.2023.12.12.02.00.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 02:00:47 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Anusha Rao <quic_anusha@quicinc.com>,
	linux-arm-msm@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 1/2] dt-bindings: crypto: qcom-qce: constrain clocks for IPQ9574 QCE
Date: Tue, 12 Dec 2023 11:00:43 +0100
Message-Id: <20231212100044.26466-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Binding marks several devices as compatible with IPQ4019 QCE.  They have
different number of clocks, thus the fallback does not define the
clock constraints per variant and each specific compatible should have
its clocks in if:then: section.

Add missing clocks description for IPQ9574 QCE.

Fixes: 1f5ce01d5d71 ("dt-bindings: crypto: qcom-qce: add SoC compatible string for ipq9574")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index eeb8a956d7cb..6435708da202 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -97,6 +97,7 @@ allOf:
               - qcom,crypto-v5.4
               - qcom,ipq6018-qce
               - qcom,ipq8074-qce
+              - qcom,ipq9574-qce
               - qcom,msm8996-qce
               - qcom,sdm845-qce
     then:
-- 
2.34.1

