Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EB61E5701
	for <linux-crypto@vger.kernel.org>; Sun, 13 Jul 2025 08:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752394027; cv=none; b=JyVyDB00axwrN+clPFdC17gUTSfLsqzZ/+wBRbAO/lepTguC6OW3rQ7dFW73OrBVZgxyZ7PrnEYrDCn4Qc60+9/psu9JGzOwF/sra4y5G+TxB0hBIaoKUPY9lswuByHjbPBSz2xDgyOArZb7AU8gbAM2t+LGfy4TfRp9dORWCWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752394027; c=relaxed/simple;
	bh=psKgizPd8idK+9Xng1zZOiGE+n8ZxAcQQoK6CGGlaAM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q+sINdPNhDqwos2HRuNEfB64A78e5DTL9ukTcYkbMwdoq/0IGE7cK4rgl3XUz+HFN920gfiIifrbE5DFUmZYRunTXcMN5L0eO/Rjpmd0T0n9nrjx0WQk5AqUx3HIiiazbdHkPfx87+3wyu9UMRThZ4UMsAFgkA+bBdN35hgJopI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=Q1PNwP8A; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="Q1PNwP8A"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4561514c7f0so2132105e9.0
        for <linux-crypto@vger.kernel.org>; Sun, 13 Jul 2025 01:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1752394024; x=1752998824; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6lM8usxsSz+hgDvjepavl+3hVj5I731y8p/a4jtJD7g=;
        b=Q1PNwP8AFHY3h5FTQVJQoXXLObhKXKjrdBmRnqFLzpcn3mYZm3EQd4e3cpwKBWrIO/
         sK7GHZE3Ho3nM5mfLj9VvDKQriNFkg4fzFf7QlmdDE/HE7uKzvUXEHRDvmER1l6k2QJt
         dvXUg6WjsFpoZ5gky1pM1H9euwV3ksCPnfs8K1q25HDZY5DRWekJGLiDF6qbVkPFJ6gZ
         AgvSlAL7IlqCtFS1ys9LkJy45rD+DAhGpswHJUYgzQwuy8b6ZEf9lKEJ1LDnARmay+FQ
         PZSzYJ4S6Y+RznIM3SVnAYZmDuup/ZJKu+aDqSLDSVnVIJlG41ymN74uTsaZBQOWX5jj
         o6LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752394024; x=1752998824;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6lM8usxsSz+hgDvjepavl+3hVj5I731y8p/a4jtJD7g=;
        b=DJbsU0tEZgUCq/aAeaX/CFBl1O5ZK1hWPJd0QQ6SbHz8VGBqWQ0tzYWSmJy660IIaT
         iFdaqvI4wfbawJvejxcXE8IehaHPvIRIHvEFS3HEC5f+japJAy73knYkgnWbO4kO6cL6
         yDO6AdaUfOJJHn2SN739lIXQc5IwIVJJZLKSfNeOCtXI/ihqmoUGwBSXUxpKV+DyQ1gR
         Ld4J63PeGjABYXeqvELcDMT9t99EvDOWSgcfG8Y9lasvxXYWKvB6nCsJrvsNSLFZ5IAP
         IhQ9Zu4Au/kv6Feb6Om+OsxMcH66XavOsWUbS5d/nuBEpVNaHX4SQSqPdTQGF/Use8Xm
         08jw==
X-Forwarded-Encrypted: i=1; AJvYcCVfD3h5qvYNebAEF3+gyO8fDWsBgGAoIsiAahgjaO/h/4OJeBCqi/0OZl5ptvpF7ZuJzFVN4klLNJsyUAo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5SA1fyMtJNyDFGtf0wtRjo2xANlqYQKisGG5X0A1U1BJvCPEk
	1LYW+AvF+X4F/orj+NpxvMIrwfj34Q2EBEiPUAT/D261CyDiPWQHxa0VW8SJ8rHnnhZ5QZCXlfg
	CyH3L
X-Gm-Gg: ASbGncsOW5H4t4oEpI8ml5UcbJtluY0Vyjw6rlzf0xuNy153Kc2uM7UA9cmt+9YRtio
	EHqgrWZAQG4n87V5KgbIIPMCl4RLteAx6kDSiYxgRB6K9tQhFGPB0UF2oVeCEAwn6kaow5uuG23
	I2OIP9x5Ze2PBYyaLudCSyK2rlGVaMRK4hdPrFP1a66uJVXGIBBfWPWSTsq4IwKV34QaB3Rgojg
	nknDeBkgkwKz3JepKPbN9VlRm0i4sIJqZ+XKyBcN+4c5SCaB/qw/qwAauMvSkFrSOFZEaQ5x+Wc
	/j0MCG7cCd9vOYb46ORzIhOTHPp0d21N8j/KifUUaDkwpXmBMkKnTFyS1xN6alrmuF4wmoijUrh
	EFwzj+Z5vOwLoFWhd2Qd9XjfhmIUoAjDhbaPn
X-Google-Smtp-Source: AGHT+IG3pwvpc6BxS1YVZvmLXezCAzje9Y6cdBA2Ax5A0e9Me5Q1M68h5GqdQnaD8/2y2jlQ5aoTTQ==
X-Received: by 2002:a05:600c:1c95:b0:453:86cc:739c with SMTP id 5b1f17b1804b1-454ec14a50bmr77388375e9.1.1752394023657;
        Sun, 13 Jul 2025 01:07:03 -0700 (PDT)
Received: from [192.168.224.50] ([213.208.155.167])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b5e8dc22a8sm9386608f8f.34.2025.07.13.01.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jul 2025 01:07:03 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Sun, 13 Jul 2025 10:05:29 +0200
Subject: [PATCH v2 07/15] dt-bindings: soc: qcom,aoss-qmp: document the
 Milos Always-On Subsystem side channel
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250713-sm7635-fp6-initial-v2-7-e8f9a789505b@fairphone.com>
References: <20250713-sm7635-fp6-initial-v2-0-e8f9a789505b@fairphone.com>
In-Reply-To: <20250713-sm7635-fp6-initial-v2-0-e8f9a789505b@fairphone.com>
To: Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 Joerg Roedel <joro@8bytes.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Vinod Koul <vkoul@kernel.org>, 
 Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Das Srinagesh <quic_gurus@quicinc.com>, 
 Thomas Gleixner <tglx@linutronix.de>, Jassi Brar <jassisinghbrar@gmail.com>, 
 Amit Kucheria <amitk@kernel.org>, Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@linaro.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Ulf Hansson <ulf.hansson@linaro.org>
Cc: ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
 linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
 linux-mmc@vger.kernel.org, Luca Weiss <luca.weiss@fairphone.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1752393945; l=838;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=psKgizPd8idK+9Xng1zZOiGE+n8ZxAcQQoK6CGGlaAM=;
 b=OPdqk8kzOonRIU/FvMHf4OTch/jvk1/7G0B29tz1FcPCzLFyfw2MFYAPDwPtuFr0E3EKR2CfP
 Ni3Mb/Ur7LsDyQ+nsHsg5e6NHg8v4v7jXauIS2CrOl7e6VQ6BFwELcm
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the Always-On Subsystem side channel on the Milos SoC.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/soc/qcom/qcom,aoss-qmp.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,aoss-qmp.yaml b/Documentation/devicetree/bindings/soc/qcom/qcom,aoss-qmp.yaml
index 41fbbe059d80cebb214317df8ae15b86573546bc..d11bb623d08c0877cbef8e8ce4795974188b2fbb 100644
--- a/Documentation/devicetree/bindings/soc/qcom/qcom,aoss-qmp.yaml
+++ b/Documentation/devicetree/bindings/soc/qcom/qcom,aoss-qmp.yaml
@@ -25,6 +25,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,milos-aoss-qmp
           - qcom,qcs615-aoss-qmp
           - qcom,qcs8300-aoss-qmp
           - qcom,qdu1000-aoss-qmp

-- 
2.50.1

