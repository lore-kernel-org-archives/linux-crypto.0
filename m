Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6763002C8
	for <linux-crypto@vger.kernel.org>; Fri,  5 Sep 2025 10:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757068866; cv=none; b=C1Tlk53kDowcYis/L2KOwwwIbdkF46uqtlIh+7go1ZhJgEvWU5oiG77g5HYoIfG73RIxatAxev02n3NQKpEaqGg2/ux9jXZWzk3CoxZ4EbMENaLSVTGOieyj7IaNOIF0Jt7rEgL/9YBRBcm2o/gCYKJtBN9R/vatKRMKRuVmS0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757068866; c=relaxed/simple;
	bh=UimigBuUtMxs7F8gG6umklkndUZUFsafBa5o33+qqu4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dkS/PM0AkjZfyLmjpfA/ueUKk+btC9DMyZL9Lp1mb7rv7mGPWkWeimDCzdePneqpIJ6HhZdfeM+vxcp8JHATaBWP+ZyIym0wWH5OyZfamNlCjoEYA3SqhoPKYTKe6yTNxg0jB6nphucxZ1s7RS8BDpPSs0ryZLak+VyGz5SRl1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=ZcwfmPxg; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="ZcwfmPxg"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3dcce361897so1362689f8f.3
        for <linux-crypto@vger.kernel.org>; Fri, 05 Sep 2025 03:41:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1757068862; x=1757673662; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4h7YaMzyJCzszrOQdboJaFyzXH8sFl3aopVTcpiY4P0=;
        b=ZcwfmPxg1kS7c4snlPFJGd3LpftrF0U4jOpMYyjkvXjXUhoB7GO4x7mwEedpHIGaac
         FcjWCBH80WKu9FwZ+ucf4GqwMtp5K++vVKguT8RLEaE5lrcY02Xmq/Bh7eS6yUM2t4Vc
         8aI+x+wV+lQZr8Nh1JBC60cITCIdfri5tpxAncb8erHY0IrYQAM33WlTwd9GzZPU4LPJ
         oM/n+gmfXBQNn/+7lOPnrvXOuU/a9ynpC8ZHeXOAD+HS5PMiLr9X0bVa+K+U/jCrBd2r
         Gh0j+uZCPbHi0gPt2zOuFVFPfECUufWbLy6lDfshjqzeUMlZLQu37VW7yUA4KC9AD4du
         MEwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757068862; x=1757673662;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4h7YaMzyJCzszrOQdboJaFyzXH8sFl3aopVTcpiY4P0=;
        b=GuInCSHdq8HDi40JMhfOOYoDlwHi7FJPWFJlqJZyRZ2BhwbkjTYILCCQaGuzc7YZ3/
         0LlKkO0fIaEl4BRuhR2NWjyfQ5sXmWIuYGsZ0zH23aTTTuuo1XQ6k+rY/F6jqglGjG7a
         wc5pKeaOi1V1RuwIUGZaWrg4KZn3BQaZ5ZiOm864HpR4OFHUzDCLRyQCe3UBBzZ4cx4r
         Vz/WKHvoR130LPUytuEVhE162dR8IBCWinywwyzNClw3NgA6PtlGYlefj+8eQjsUDbTY
         plb4v6Lz9vfaHzsI+xrdZ2HTvb0SNBAosIbWFPQ8pIpIZGfb3kHqPhUkgkoRuDIHBym9
         HgkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxf9PqiVmZFrSUmV4GUeADIeBHakKw9h+03M/qeoLsQhuFsunOP5/g0UwWARu24YmA0tDlPs32WlNM9nA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwC0PbGF4hI8++EL4ePWHbOHG/ZyEz84hcLklfLT/jwTJ5s5eK6
	vsnnJV9jyZ1B4mRBGsdlH6nJEAQsK2vgxDZXHMB0/o74bfZtMvRWEyfu7KL9/Kd9voY=
X-Gm-Gg: ASbGncvCqPu06BfV/aihqCdy9t4MdbVuEwuaZHqIOlm7YvzkazV3OLqApP5rV4IMn3R
	XHfR4xZtKtQey38U0ka8eDCZzgf4GHCAzzTO/86xgcAPQoodt6ygUQ83sAIwOxliRdLFz19KREJ
	XvLCYNl/APwOSnn2wT/q/tKOyhaDEqJP9UmEOjmd4mY1gycFPi3AX+Or4o8zfUP7PbbBm2pjFib
	8/hlIkp8WKv52yEiCw7diC07mqUyhquNh8GJNBayg+7ODZLPd4eMhM8totIfo1gjJDCz00GvBJH
	rwACljwhBp4j9lLKvxBTp32LOwixegZzgcKVjcS2vgGhVwO8U2sbBuUO/0SRWGt6vO5Q8e323Yy
	Y02WIlkBy3u17oqgWtJTnNCdoej/yhy4uMHRHODGofk1pK4PXvDgNlG3vM2+Tf2PgFGO9dIOOee
	B2iaaNZbRZBXPSpm7w/2il0kVitiO8zw==
X-Google-Smtp-Source: AGHT+IGtbARUvUaTJ4NIeSDeweSSytYiW6yHSoPrHxfTOVtady6hveXqNdHAZNNKJxa9x3TrxVsf3A==
X-Received: by 2002:a05:6000:24c7:b0:3e0:152a:87b6 with SMTP id ffacd0b85a97d-3e0152a8a00mr6371616f8f.25.1757068862097;
        Fri, 05 Sep 2025 03:41:02 -0700 (PDT)
Received: from [172.18.170.139] (ip-185-104-138-158.ptr.icomera.net. [185.104.138.158])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d6cf485eb7sm20990738f8f.3.2025.09.05.03.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 03:41:01 -0700 (PDT)
From: Luca Weiss <luca.weiss@fairphone.com>
Date: Fri, 05 Sep 2025 12:40:32 +0200
Subject: [PATCH v3 1/7] dt-bindings: cpufreq: qcom-hw: document Milos
 CPUFREQ Hardware
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250905-sm7635-fp6-initial-v3-1-0117c2eff1b7@fairphone.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1757068857; l=1212;
 i=luca.weiss@fairphone.com; s=20250611; h=from:subject:message-id;
 bh=UimigBuUtMxs7F8gG6umklkndUZUFsafBa5o33+qqu4=;
 b=DY1pFCOuq1avbn5t7ZPvcE56wWF7XIf1yrr3163XBBi/yD3M7RGi5JrUxggImZlz8IomMu7gf
 B9cbK5HaeebCOw3btr4WhZILE7SRIK7H7piwrfjlehWfycKYwf+7HoW
X-Developer-Key: i=luca.weiss@fairphone.com; a=ed25519;
 pk=O1aw+AAust5lEmgrNJ1Bs7PTY0fEsJm+mdkjExA69q8=

Document the CPUFREQ Hardware on the Milos SoC.

Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
---
 Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml b/Documentation/devicetree/bindings/cpufreq/cpufreq-qcom-hw.yaml
index 2d42fc3d8ef811368c990977173f41b26535e0c8..22eeaef14f557d615b06ec13e71daf86018fcdc9 100644
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
2.51.0

