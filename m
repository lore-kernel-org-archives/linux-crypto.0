Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC14122A7E6
	for <linux-crypto@vger.kernel.org>; Wed, 10 Dec 2025 01:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331025; cv=none; b=LAHqpjrujFS/p+KQWV395WxHACh1YzoakyVA+y/KZQW0DmbCmVMwgZ5G/ztU04wg5WKDAUoyZBt6Meu/dPO+zQQdOg+TcIiF4FYZhWAAgwFOqtv+GqS2HV2OWKjj/10ncP7DDZrh03Od4RDnS0Bk9zVWXsUKvMGb8rVByAdqG38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331025; c=relaxed/simple;
	bh=i2fJ3oSJhw/ySwSUDxCvlBN2veS0HqsGf63LfSGR3lY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PVrIALLYdnatj7s4OZguTpZe51LYxANTThsn+oZFlXipeW5vAwxs15qLRlKtFBeo8NcrzhA9TnUINzNXwnejMFyQrnKKigxmou4SPZLSse9R0hYakaugpK7y9Jfr1pRsIBS3iKIpo/AE8ViExHe12RUw6qrawmpbaswASVRr8pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=pcvSqt2n; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="pcvSqt2n"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-477563e28a3so3078405e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 09 Dec 2025 17:43:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1765331022; x=1765935822; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FT1PuSSF/qNGP2vBlW8tIhEETokKmkXeWI2rZb/bUJo=;
        b=pcvSqt2nEgmPDOuZArN5hwfZIGgp4izgc2qvQU+/d5PaiW6z3sfTVwuB0OWNp74IQP
         pmVlM+tk+YaatGMoQrdhjiEyeba2Ha8rLSKP84qxQtfzWcWamN7umC8kbz0t+G1R/zQO
         roalzjG8LEe0kOAKpCQO+YAWMUp4+n87WNXQ25a2ncPyhEArTjO9Ok7m46o5skACnl8T
         5kDBhH6jqt2QisPyn0nuzYq5yFFVvcHa6Keo/Gl8ABVJk0MKotH0S9ZN4TDoRG9EkMAB
         fXveOV7dERT/0eL6WRgVQFQ3FItMm6uBZLOmEspHiVFQZi3XqgafGYs9eD1EHsi0UtN+
         j40Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331022; x=1765935822;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FT1PuSSF/qNGP2vBlW8tIhEETokKmkXeWI2rZb/bUJo=;
        b=JyTvtLNMBNuzKRliFF8MIQqpTbcTOAks0ZIlglypnDjrnjHte3UxJdKcYm5CLiFsH8
         4Op1pYAyfmzkFoY7qVljsVIrXtzY49DfQZ77KAXV5DP4GILS7Y08mHwRfTnsyAUqUJ+d
         +IpOHaVxciXtmwGcieZjyUEpOzhHjrv/Lg6N2Jizabn1sseNS9GI7qvXQcaiaAPrdfhM
         RkwmiWniv5jNcT9BNa5eEdXdWhkGQ6nzSI+S30/BR4ad7Vn/cEcFMD50Hm+hJcRtTj9b
         6g5hzgKyAgGG/kAe8wH8WOjjcMTX6ysuBoLu5qdo+SiiOjoI+Unx+3PCC8BVt6fLYotP
         PyHg==
X-Forwarded-Encrypted: i=1; AJvYcCVyr2WgCyM4L9VLqJQD9Mb0dlwf5SsxdE0Ozkqstd7RAjH6mbZkxmd/buI2wD2+0tkh5d5+otwPUXja2Wo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXUwGT2O78HnZTvGw0GNnQhKRa5vZruUeONJHssjgT8vIfx+ar
	tQ3MTykDUojejvcPLwQxFCttuLhxdvrBoFJYqN+pthcBUE0XaW9uxQQaLP4OgMLHSmgFShwM1qg
	FQQVl/Fyl2Q==
X-Gm-Gg: ASbGncuXg/SKXtSe0rV0Dz//gbmHWLtNqUUnKKmP6x64vOi6qaJUvgZZR0A//4OI/Al
	MA/mgZMbymMpnGKoDJ+FahbslG1lDpIk48IrIzXAGxXbJpM0MwBMMDU4AuC/lbSQml7h5yrpTxD
	F7FReM4CTt7ChzysVUbZrcKdJI8DlY21r4GHqafNLjpYb0tlZqj8d2umg0/7IcE1CyIh20o0tSC
	cgeTJEK6o6QPOJb5x1NVz/MDmEcWuOPjufMbZwp8Js1WDVxPQJr4EUuI3d1mMYV4dWaozEL2m37
	p5Ft1xVkrq9f+UiMjFvHoCdwzY28TwZaRbdARZ+9CsLVFQxc+rhXpPXjnapG82Yqqliolcww/3i
	421jMMXM6p+Txsq7XhX8HOh21gQLfnmT9VfQjtVX61sG3Y102canXzLvqjWDXBk9GuwASZzI/+B
	lcVvcVte2p03lpFrlE6eg2GQUyM8treVyWAfccx9v3gxaCZe7qtg==
X-Google-Smtp-Source: AGHT+IEBw/92gO6sgjRnYsvO6wdv2q1g/TUhOcjenuTs2Zh7ccxVbKZSVrtyYytk2eSeTYPplHLThA==
X-Received: by 2002:a05:600c:8596:b0:477:7588:c8cc with SMTP id 5b1f17b1804b1-47a7f91933fmr31692325e9.7.1765331021761;
        Tue, 09 Dec 2025 17:43:41 -0800 (PST)
Received: from [10.200.8.8] (p99249-ipoefx.ipoe.ocn.ne.jp. [153.246.134.248])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34a7000c984sm705234a91.6.2025.12.09.17.43.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:43:41 -0800 (PST)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Wed, 10 Dec 2025 10:43:25 +0900
Subject: [PATCH v4 1/9] dt-bindings: cpufreq: qcom-hw: document Milos
 CPUFREQ Hardware
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251210-sm7635-fp6-initial-v4-1-b05fddd8b45c@fairphone.com>
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
In-Reply-To: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
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
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1765331010; l=1206;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=i2fJ3oSJhw/ySwSUDxCvlBN2veS0HqsGf63LfSGR3lY=;
 b=B6fM0qV+kskrVmWrQrdWrdJegC4lscc5t5rGLEmjxKdgwtQcYnqbU6yJ2+Vpsji8OYmgZzx3Q
 zOxdKXnTJnFALGIximQ+/5iJfIDmy7CiRbk3LF8mMSrBGYwC2Pw+dYY
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the CPUFREQ Hardware on the Milos SoC.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml b/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
index 2d42fc3d8ef8..22eeaef14f55 100644
--- a/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
+++ b/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
@@ -35,6 +35,7 @@ properties:
       - description: v2 of CPUFREQ HW (EPSS)
         items:
           - enum:
+              - qcom,milos-cpufreq-epss
               - qcom,qcs8300-cpufreq-epss
               - qcom,qdu1000-cpufreq-epss
               - qcom,sa8255p-cpufreq-epss
@@ -169,6 +170,7 @@ allOf:
         compatible:
           contains:
             enum:
+              - qcom,milos-cpufreq-epss
               - qcom,qcs8300-cpufreq-epss
               - qcom,sc7280-cpufreq-epss
               - qcom,sm8250-cpufreq-epss

-- 
2.52.0

