Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7016D20CCFD
	for <linux-crypto@vger.kernel.org>; Fri,  7 Mar 2025 09:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741339998; cv=none; b=J6sZzXS8Omuya3xz3z6B9rNrHCmzlzaHZgmydopdRGq0uRyvEWUYBjKJigZTkFtFMERCKuz8TlK71UB5g+Sr0p4CMYN9IPgCdhsTVQWF+o5wNG7/BHjLOJfOWPMlgCTHFLn42SN8HEa4SZ3za1ZJMYJ1+uDdqK8vP1T/6kpLpFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741339998; c=relaxed/simple;
	bh=f6+JfLU/1QFiRs0zJLu13R4ni0sWGfII1CyAkkteBPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LDEzxMdH8GQ7zSa2k/9NlLxhfu/UViQZHaKEgQpRCMTMlAD6CpFHvvRDR6KM5fn5T8x5fjINdRpo1Rd4zC++RYQdGN+fwMDE1yy4Ku6uOgaKEiICHDguTOkfNcJ2lDNVTXy51wSpnyXLOVO/MSfIbYMNRlUlObeCpBX24hJCAm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tuoEXp4M; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tuoEXp4M"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5e5ea062471so54344a12.2
        for <linux-crypto@vger.kernel.org>; Fri, 07 Mar 2025 01:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741339994; x=1741944794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fU0HHdQ1hyz6Oi/pxgyRXXgGFlp0DgTNlBw/r19mLUE=;
        b=tuoEXp4MCXqWFa33f111JLpTrEcuR0hQ3u7Hli6VAsKF9HK22gpN1o5QTYlGbVK1xt
         CTEH7U7AWV3sRBBhx7/0S3BUjV0JLdYBjGlaJ/6m/wk0PmaA132L/rceatLF+aGxBBvD
         2Wfc4exbDizDs8aCSOftuvqaWJlXbP8WUpg3ZzokiTyJ1gmKqtN8jcs5vbgBSzwkXQhr
         8lQ2CC3PT02tJfzgLQsC8l7y+SDW+PGYeebXE35nOQQ4N3emfxtR/XqhWPTRYKgaYNqN
         vDGhhuXiZkNoyrO2iNJ274EohjgJ6zNSVYuTSf8+bXlq4RgyosAO0RJKjXjXQEYw8qlb
         CrcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741339994; x=1741944794;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fU0HHdQ1hyz6Oi/pxgyRXXgGFlp0DgTNlBw/r19mLUE=;
        b=t/siaH0IO5z70YwPEmLsipgWiRdeROSM3X0BIKPMGkbj0jWI2CPeEoLq5sGDlYu1UY
         gYTwTQ7gmVN74P5ykuRfATlj7Lyhy7EzQO//PdQl9aQaxAEp8QhDs3QSMjZEk+2n/Qxu
         MSHNMi2sfSe0rV0azxq10agK+kmYYta3WBeSsu81s/KOwjazArNCwHm3QJwtYV/z74ES
         AAOe1mBCD/qxpddwaTEmo0ADOPfRnFYEo11EcXkjfs4lQtkkKkGWJaFG38eBVnPCPuzU
         2p4DuTQvxwR/5k8MnWkGl6jtfyLqe3ks4FTvuIsFa9qOfZO8UXtgQoD8oJdJ9wz+xMcr
         ydjQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhwGOrJb49feF9+v3+HkOvJjYykFULRqiI2hoDDNmrsaPU2kWfJVNm4yqeb1a0AobAcd16yCR0Ew7PzwQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRk5dVE3WtNs6Sb/VffYP+SOLeLXyP6x9RRkZHhPZacNMYVn7p
	Gnxzg2BHsqRvIKw0pwBzWpV9dgkryB7cTqlCLd/ZO6oP/o0VfSx4sw1/ntg+I20=
X-Gm-Gg: ASbGncs7fHN86B/69LpwFr5IW51YJgTnDCjU9/U4LcLz6WcS1BcJrt2MNPIQh8859ud
	bmzL2tQw/WLjpos4Yecjv4eOK/HqHKVgSnp0movD7MQxHrLfr14/CnAUD5R7i3pWwXvFSYSy26K
	7xjzRJJ51uOrlFYOz5olUytWEYC6cyv2QiA/aHGDddo4IVH+xnZc6GlZHM172DkATRCkCJpHJDb
	3YZsYB+FRgOPMGDn1euXJqWleUBImg7glq1rmwzr0jxANwxSUkCTmbCqoSVEx04584PKV4PK0p7
	1l+xW4H2gUhEI7oF0CipQWZgA0Cq8IKH81CcatC9s2/R9oYRHGT7l9WIlQA=
X-Google-Smtp-Source: AGHT+IEAJGcNFFbHug7ITx5iMdjawlkckyUu9cdR2GxHKINK8WVBM4YprSaxysEv0Z5OJYbITLcdkQ==
X-Received: by 2002:a05:6402:51c9:b0:5e5:e17f:22fc with SMTP id 4fb4d7f45d1cf-5e5e22ae3c4mr1030915a12.2.1741339993683;
        Fri, 07 Mar 2025 01:33:13 -0800 (PST)
Received: from krzk-bin.. ([178.197.206.225])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c74a82ecsm2275091a12.37.2025.03.07.01.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 01:33:13 -0800 (PST)
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2] dt-bindings: rng: rockchip,rk3588-rng: Drop unnecessary status from example
Date: Fri,  7 Mar 2025 10:33:09 +0100
Message-ID: <20250307093309.44950-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Device nodes are enabled by default, so no need for 'status = "okay"' in
the DTS example.

Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes in v2:
1. Drop unnecessary full stop in subject prefix after ':'.
2. Add Rb tag.
---
 Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
index 757967212f55..ca71b400bcae 100644
--- a/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/rockchip,rk3588-rng.yaml
@@ -53,7 +53,6 @@ examples:
         interrupts = <GIC_SPI 400 IRQ_TYPE_LEVEL_HIGH 0>;
         clocks = <&scmi_clk SCMI_HCLK_SECURE_NS>;
         resets = <&scmi_reset SCMI_SRST_H_TRNG_NS>;
-        status = "okay";
       };
     };
 
-- 
2.43.0

